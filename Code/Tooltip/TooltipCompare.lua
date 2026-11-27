local _, addon = ...;

-- Equipped-item comparison for the tooltip. Port of retail's item level delta (ItemEvaluator, API.lua
-- EQUIPLOC_SLOTID) and its stat comparison, using GetItemStatDelta instead of parsing tooltip text.
local TooltipCompare = {};
addon.TooltipCompare = TooltipCompare;

local GetItemInfo = GetItemInfo;
local GetInventoryItemLink = GetInventoryItemLink;
local GetItemStatDelta = GetItemStatDelta;
local sort = table.sort;
local floor = math.floor;

-- GetItemInfo equipSlot (field 9) -> inventory slots to compare against (retail EQUIPLOC_SLOTID).
local EQUIP_SLOTS = {
    INVTYPE_HEAD = {1},
    INVTYPE_NECK = {2},
    INVTYPE_SHOULDER = {3},
    INVTYPE_BODY = {4},
    INVTYPE_CHEST = {5},
    INVTYPE_ROBE = {5},
    INVTYPE_WAIST = {6},
    INVTYPE_LEGS = {7},
    INVTYPE_FEET = {8},
    INVTYPE_WRIST = {9},
    INVTYPE_HAND = {10},
    INVTYPE_FINGER = {11, 12},
    INVTYPE_TRINKET = {13, 14},
    INVTYPE_CLOAK = {15},
    INVTYPE_WEAPON = {16, 17},
    INVTYPE_SHIELD = {17},
    INVTYPE_2HWEAPON = {16},
    INVTYPE_WEAPONMAINHAND = {16},
    INVTYPE_WEAPONOFFHAND = {17},
    INVTYPE_HOLDABLE = {17},
    INVTYPE_RANGED = {18},
    INVTYPE_RANGEDRIGHT = {18},
    INVTYPE_THROWN = {18},
    INVTYPE_RELIC = {18},
    INVTYPE_TABARD = {19},
};

-- Slots where the armor type (cloth / leather / mail / plate) matters.
local ARMOR_TYPE_SLOTS = {[1] = true, [3] = true, [5] = true, [6] = true, [7] = true, [8] = true, [9] = true, [10] = true};

local GREEN = "|cff19ff19";
local RED = "|cffff2020";
local GREY = "|cff808080";
local ITEM_LEVEL_FLOOR = -13;     -- retail hides the delta for much older items

local function GetEquipSlots(link)
    local _, _, _, _, _, _, _, _, equipSlot = GetItemInfo(link);
    return equipSlot and EQUIP_SLOTS[equipSlot], equipSlot
end
TooltipCompare.GetEquipSlots = GetEquipSlots;

function TooltipCompare:IsEquippable(link)
    return GetEquipSlots(link) ~= nil
end

-- Returns the equipped item that `link` would replace: its link and item level.
-- For ring / trinket / one-hand weapon, the weaker of the two slots, so the delta is the best case.
function TooltipCompare:GetReplacedItem(link)
    local slots = GetEquipSlots(link);
    if not slots then
        return nil
    end

    local bestLink, bestLevel;
    for i = 1, #slots do
        local equipped = GetInventoryItemLink("player", slots[i]);
        if equipped then
            local level = select(4, GetItemInfo(equipped)) or 0;
            if not bestLevel or level < bestLevel then
                bestLink, bestLevel = equipped, level;
            end
        end
    end
    return bestLink, bestLevel
end

-- Every equipped item `link` could replace, in slot order. Only when there are two of them (ring, trinket, one-hand
-- weapon with a weapon in the off hand): the caller shows both in a side tooltip. Otherwise nil.
-- A shield or off-hand holdable is not something a one-hand weapon replaces, so it does not count as a second item.
function TooltipCompare:GetReplacedItems(link)
    local slots, equipSlot = GetEquipSlots(link);
    -- A two-hander takes both hands: main hand and off hand are what it replaces.
    if equipSlot == "INVTYPE_2HWEAPON" then
        slots = {16, 17};
    end
    if not slots or #slots < 2 then
        return nil
    end

    local list = {};
    for i = 1, #slots do
        local equipped = GetInventoryItemLink("player", slots[i]);
        if equipped then
            local equippedSlot = select(9, GetItemInfo(equipped));
            local isWeaponPair = (equipSlot == "INVTYPE_WEAPON" and i == 2);
            if not isWeaponPair or equippedSlot == "INVTYPE_WEAPON" or equippedSlot == "INVTYPE_WEAPONOFFHAND" then
                list[#list + 1] = equipped;
            end
        end
    end
    if #list < 2 then
        return nil
    end
    return list
end

-- The upgrade arrow needs the Pawn addon (item level alone is not a good measure). Pawn is looked up when asked,
-- not at load, so the load order does not matter. Pawn's globals: PawnGetItemData(link) and
-- PawnGetItemDataForInventorySlot(slot, unenchanted) return an item whose `Values` is a list of
-- {scaleName, value, unenchantedValue, ...} for the scales the player has enabled (only values above 0).
function TooltipCompare:IsPawnAvailable()
    return type(PawnGetItemData) == "function" and type(PawnGetItemDataForInventorySlot) == "function"
        and type(PawnCommon) == "table" and type(PawnCommon.Scales) == "table"
end

-- Journal: Gear Guide marks upgrades on your gear list (from level 55, for gear it knows) and draws the same
-- arrow. Where its list can judge an item its answer counts, otherwise Pawn's. Its globals: JournalGearGuide.Knows(link)
-- and JournalGearGuide.ShowsArrow(link, carried) (carried: the item is in your bags, so is it better than what you
-- wear?).
local function GearGuide()
    local G = _G.JournalGearGuide;
    if type(G) == "table" and type(G.Knows) == "function" and type(G.ShowsArrow) == "function" then
        return G
    end
end

local gearGuideErrorReported = false;

-- Gear Guide's verdict, or nil when its list cannot judge the item. Its errors are caught so they cannot break the
-- reward window or the popup: reported once, and the item is left to Pawn.
local function AskGearGuide(link, carried)
    local G = GearGuide();
    if not G then
        return nil
    end
    local ok, result = pcall(function()
        if G.Knows(link) then
            return G.ShowsArrow(link, carried) and true or false
        end
    end);
    if ok then
        return result
    end
    if not gearGuideErrorReported then
        gearGuideErrorReported = true;
        geterrorhandler()("DialogueUI: Journal: Gear Guide failed: " .. tostring(result));
    end
end

-- Pawn or Journal: Gear Guide: either can say what is an upgrade.
function TooltipCompare:HasUpgradeSource()
    return self:IsPawnAvailable() or GearGuide() ~= nil
end

local function PawnValues(item)
    local values = {};
    if item and item.Values then
        for i = 1, #item.Values do
            local entry = item.Values[i];
            values[entry[1]] = entry[2] or 0;
        end
    end
    return values
end

-- True when `newValues` beats `oldValues` (scale name -> value) in at least one scale.
local function BeatsInAnyScale(newValues, oldValues)
    for scale, value in pairs(newValues) do
        if value > (oldValues[scale] or 0) then
            return true
        end
    end
    return false
end

-- Upgrade according to Pawn: the item scores higher than what is in one of its slots in at least one of the
-- player's enabled scales (equipped items without enchants and gems, so those do not count against the new item).
-- Returns isUpgrade, isReady (false while an item is not in the cache yet: ask again later).
-- An empty slot counts as an upgrade, except the second slot of a one-hand weapon (its second slot only counts when
-- it holds a weapon). Armor of another type than the equipped one (cloth over leather) is never an upgrade.
-- Without Pawn nothing is an upgrade. Journal: Gear Guide comes first, for the items its list can judge.
-- carried: the item is already in the bags (the reward just received).
function TooltipCompare:IsUpgrade(link, carried)
    local verdict = AskGearGuide(link, carried);
    if verdict ~= nil then
        return verdict, true
    end
    local slots, equipSlot = GetEquipSlots(link);
    if not slots or not self:IsPawnAvailable() then
        return false, true
    end
    local _, _, _, level, _, class, subclass = GetItemInfo(link);
    if not level then
        return false, false
    end

    local newValues = PawnValues(PawnGetItemData(link));
    local isOneHand = (equipSlot == "INVTYPE_WEAPON");
    for i = 1, #slots do
        local equipped = GetInventoryItemLink("player", slots[i]);
        local upgrade = false;
        if equipped then
            local _, _, _, _, _, equippedClass, equippedSubclass, _, equippedSlot = GetItemInfo(equipped);
            if i == 2 and isOneHand and equippedSlot ~= "INVTYPE_WEAPON" and equippedSlot ~= "INVTYPE_WEAPONOFFHAND" then
                upgrade = false;
            elseif ARMOR_TYPE_SLOTS[slots[i]] and equippedClass == class and equippedSubclass ~= subclass then
                upgrade = false;
            else
                upgrade = BeatsInAnyScale(newValues, PawnValues(PawnGetItemDataForInventorySlot(slots[i], true)));
            end
        elseif not (i == 2 and isOneHand) then
            upgrade = next(newValues) ~= nil;
        end
        if upgrade then
            return true, true
        end
    end
    return false, true
end

-- Item level difference against the replaced item, or nil when there is nothing to compare.
function TooltipCompare:GetItemLevelDelta(link)
    local level = select(4, GetItemInfo(link));
    local _, equippedLevel = self:GetReplacedItem(link);
    if not level or not equippedLevel then
        return nil
    end
    local delta = level - equippedLevel;
    if delta <= ITEM_LEVEL_FLOOR then
        return nil
    end
    return delta
end

-- "(+N)" green or "(-N)" grey, like retail's Tooltip_Private.lua 468-489. Empty when zero or unknown.
function TooltipCompare:FormatItemLevelDelta(delta)
    if not delta or delta == 0 then
        return ""
    elseif delta > 0 then
        return GREY .. "(|r" .. GREEN .. "+" .. delta .. "|r" .. GREY .. ")|r"
    end
    return GREY .. "(" .. delta .. ")|r"
end

-- Display name for a stat token. Global strings (ITEM_MOD_*_SHORT, RESISTANCE*_NAME) are FrameXML,
-- not in wow-docs, so the token itself is the fallback.
local function StatName(token)
    local name = _G[token];
    if type(name) == "string" then
        return name
    end
    return (token:gsub("^ITEM_MOD_", ""):gsub("_SHORT$", ""):gsub("_", " "):lower())
end

-- Whole numbers for every stat, except damage per second: one decimal at most (53.9, not 53.9238...).
-- Returns a number, so "52.0" prints as 52.
local function RoundStat(token, value)
    if token:find("PER_SECOND") then
        return floor(value * 10 + (value >= 0 and 0.5 or -0.5)) / 10
    end
    return floor(value + (value >= 0 and 0.5 or -0.5))
end

-- Lines for the stat comparison: {text} entries, "+N Stat" green or "-N Stat" red.
-- Returns a list of strings and a flag for "identical".
-- `equipped` picks the item to compare with; by default the one GetReplacedItem returns.
function TooltipCompare:GetStatLines(link, equipped)
    equipped = equipped or self:GetReplacedItem(link);
    if not equipped then
        return {}, false
    end

    -- GetItemStatDelta(item1, item2): item1 minus item2 (UNVERIFIED direction, see docs).
    local delta = GetItemStatDelta(link, equipped, {});
    local shown = {};                  -- token -> rounded value; stats that round to 0 are dropped
    local tokens = {};
    for token, value in pairs(delta) do
        if value then
            local rounded = RoundStat(token, value);
            if rounded ~= 0 then
                shown[token] = rounded;
                tokens[#tokens + 1] = token;
            end
        end
    end
    sort(tokens);

    local lines = {};
    for i = 1, #tokens do
        local value = shown[tokens[i]];
        local color = value > 0 and GREEN or RED;
        local sign = value > 0 and "+" or "";
        lines[#lines + 1] = color .. sign .. value .. "|r " .. StatName(tokens[i]);
    end
    return lines, #lines == 0
end

-- True when the item is a different type from the one it would replace (e.g. cloth vs plate).
function TooltipCompare:IsDifferentType(link, equipped)
    equipped = equipped or self:GetReplacedItem(link);
    if not equipped then
        return false
    end
    local _, _, _, _, _, class, subclass = GetItemInfo(link);
    local _, _, _, _, _, eClass, eSubclass = GetItemInfo(equipped);
    return class ~= eClass or subclass ~= eSubclass
end
