local _, addon = ...;
local LootUI = addon.LootUI;
local Def = LootUI.Def;
local MainFrame = LootUI.MainFrame;
local MoneyUtil = addon.MoneyUtil;
local After = addon.API.After;
local CallbackRegistry = addon.CallbackRegistry;

local CreateFrame = CreateFrame;
local GetNumLootItems = GetNumLootItems;
local GetLootSlotInfo = GetLootSlotInfo;
local GetLootSlotLink = GetLootSlotLink;
local LootSlotIsItem = LootSlotIsItem;
local LootSlotIsCoin = LootSlotIsCoin;
local LootSlot = LootSlot;
local CloseLoot = CloseLoot;
local GetItemInfo = GetItemInfo;
local GetMoney = GetMoney;
local ipairs = ipairs;
local pairs = pairs;
local tonumber = tonumber;
local match = string.match;
local gsub = string.gsub;

-- Events, loot data and the queue behind the loot window.
-- 3.3.5a differences from Plumber (retail): no LOOT_READY and no LOOT_SLOT_CHANGED, no LootSlotHasItem (a slot that
-- was taken is tracked from LOOT_SLOT_CLEARED), GetLootSlotInfo has no quest / currency return values, no currencies
-- or reputation toasts, no "toast" alert system. Items that were received come from CHAT_MSG_LOOT.

local EL = CreateFrame("Frame");
LootUI.EventListener = EL;

-- The events of the game's LootFrame. Re-registered when this module is off.
local BLIZZARD_EVENTS = {
    "LOOT_OPENED", "LOOT_SLOT_CLEARED", "LOOT_CLOSED", "OPEN_MASTER_LOOT_LIST", "UPDATE_MASTER_LOOT_LIST",
};

local enabled = false;
local lootToken = 0;                    -- bumped on every LOOT_OPENED / LOOT_CLOSED: stale timers do nothing


---------------------------------------------------------------------------
-- Slot data
---------------------------------------------------------------------------

local function GetItemID(link)
    return link and tonumber(match(link, "item:(%d+)"))
end

local function BuildItemData(link, slotIndex, icon, name, quantity, quality, locked)
    local itemName, _, itemQuality, _, _, _, subType, _, equipSlot, itemIcon = GetItemInfo(link);
    quality = quality or itemQuality or 1;
    name = name or itemName or match(link, "%[(.-)%]") or "";
    return {
        slotType = Def.SLOT_TYPE_ITEM,
        slotIndex = slotIndex,
        icon = icon or itemIcon,
        name = name,
        quantity = quantity or 1,
        quality = quality,
        locked = locked,
        link = link,
        id = GetItemID(link),
        subType = subType,
        hideCount = equipSlot ~= nil and equipSlot ~= "",      -- one piece of equipment shows no count
        looted = false,
    }
end

local function BuildSlotData(slotIndex)
    local icon, name, quantity, quality, locked = GetLootSlotInfo(slotIndex);
    if LootSlotIsCoin(slotIndex) then
        return {
            slotType = Def.SLOT_TYPE_MONEY,
            slotIndex = slotIndex,
            icon = icon,
            name = name or "",
            quantity = quantity or 0,
            quality = 1,
            looted = false,
        }
    elseif LootSlotIsItem(slotIndex) then
        local link = GetLootSlotLink(slotIndex);
        if link then
            return BuildItemData(link, slotIndex, icon, name, quantity, quality, locked)
        end
    end
end

local FastLoot = {};
LootUI.FastLoot = FastLoot;

function FastLoot:Reset()
    self.slotProcessed = nil;
end

-- LootSlot once per slot (a second call on the same slot can disconnect the player).
function FastLoot:Start()
    for slotIndex = 1, GetNumLootItems() do
        if not (EL.cleared and EL.cleared[slotIndex]) and (LootSlotIsItem(slotIndex) or LootSlotIsCoin(slotIndex)) then
            self.slotProcessed = self.slotProcessed or {};
            if not self.slotProcessed[slotIndex] then
                self.slotProcessed[slotIndex] = true;
                LootSlot(slotIndex);
            end
        end
    end
end

function LootUI.GetSortedLootList()
    if not EL.currentLoot then
        return nil
    end
    local list = {};
    for slotIndex, data in pairs(EL.currentLoot) do
        data.looted = EL.cleared and EL.cleared[slotIndex] or false;
        list[#list + 1] = data;
    end
    if #list > 0 then
        table.sort(list, LootUI.SortFunc_LootSlot);
        return list
    end
end

function EL:BuildLootData()
    self.currentLoot = {};
    for slotIndex = 1, GetNumLootItems() do
        if not self.cleared[slotIndex] then
            local data = BuildSlotData(slotIndex);
            if data then
                self.currentLoot[slotIndex] = data;
            end
        end
    end
end

function EL:HasRemainingLoot()
    if not self.currentLoot then
        return false
    end
    for slotIndex in pairs(self.currentLoot) do
        if not self.cleared[slotIndex] then
            return true
        end
    end
    return false
end


---------------------------------------------------------------------------
-- Queue (notification mode). Items arrive one by one, the window shows them together.
---------------------------------------------------------------------------

do
    local QueueFrame = CreateFrame("Frame");
    local QUEUE_DELAY = 0.15;           -- events arrive a little apart
    local lootQueue;

    local function OnUpdate(self, elapsed)
        self.t = self.t + elapsed;
        if self.t > QUEUE_DELAY then
            self.t = 0;
            self:SetScript("OnUpdate", nil);
            if not MainFrame:IsInManualMode() then
                MainFrame:DisplayLootResult();
            end
        end
    end

    function LootUI.QueueDisplayLoot(data)
        if not ((enabled or LootUI.forceEnabled) and data and data.quantity) or MainFrame:IsInManualMode() then
            return
        end
        lootQueue = lootQueue or {};
        data.slotIndex = data.slotIndex or 0;
        lootQueue[#lootQueue + 1] = data;
        QueueFrame.t = 0;
        QueueFrame:SetScript("OnUpdate", OnUpdate);
    end

    -- For other modules: a line with an icon and a text, optionally glowing.
    function LootUI.QueueDisplayCustom(icon, name, quality, showGlow)
        LootUI.QueueDisplayLoot({
            slotType = Def.SLOT_TYPE_CUSTOM,
            icon = icon,
            name = name,
            quality = quality or 1,
            quantity = 1,
            hideCount = true,
            showGlow = showGlow,
        });
    end

    -- Shows what is queued now, without the short wait (the preview of the Settings).
    function LootUI.FlushLootQueue()
        QueueFrame.t = 0;
        QueueFrame:SetScript("OnUpdate", nil);
        if lootQueue and not MainFrame:IsInManualMode() then
            MainFrame:DisplayLootResult();
        end
    end

    function LootUI.GetLootQueue()
        return lootQueue
    end

    function LootUI.WipeLootQueue()
        QueueFrame.t = 0;
        QueueFrame:SetScript("OnUpdate", nil);
        lootQueue = nil;
    end
end


---------------------------------------------------------------------------
-- Chat message of an item that was received
---------------------------------------------------------------------------

-- "You receive loot: %s." -> pattern. Formats with a count (the "x%d" ones) come first, a pattern for a single
-- item must not swallow them.
local function ToPattern(format)
    if not format then
        return nil
    end
    format = gsub(format, "([%^%$%(%)%.%[%]%*%+%-%?])", "%%%1");
    format = gsub(format, "%%%d%$s", "(.+)");                       -- positional: "%1$s"
    format = gsub(format, "%%%d%$d", "(%%d+)");
    format = gsub(format, "%%s", "(.+)");
    format = gsub(format, "%%d", "(%%d+)");
    return "^" .. format .. "$"
end

local MessagePatterns;

local function GetMessagePatterns()
    if not MessagePatterns then
        MessagePatterns = {};
        local names = {
            "LOOT_ITEM_SELF_MULTIPLE", "LOOT_ITEM_PUSHED_SELF_MULTIPLE", "LOOT_ITEM_CREATED_SELF_MULTIPLE",
            "LOOT_ITEM_SELF", "LOOT_ITEM_PUSHED_SELF", "LOOT_ITEM_CREATED_SELF",
        };
        for _, name in ipairs(names) do
            local pattern = ToPattern(_G[name]);
            if pattern then
                MessagePatterns[#MessagePatterns + 1] = pattern;
            end
        end
    end
    return MessagePatterns
end

function EL:ProcessMessageItem(text)
    for _, pattern in ipairs(GetMessagePatterns()) do
        local link, count = match(text, pattern);
        if link then
            if match(link, "item:%d+") then
                local data = BuildItemData(link, 0, nil, nil, tonumber(count) or 1);
                data.looted = true;
                LootUI.QueueDisplayLoot(data);
            end
            return
        end
    end
end

-- Money that was looted: the difference of the player's money since the loot window opened.
function EL:ProcessMoneyFromLoot()
    if self.playerMoney then
        local money = GetMoney();
        local delta = money - self.playerMoney;
        if delta > 0 then
            LootUI.QueueDisplayLoot({
                slotType = Def.SLOT_TYPE_MONEY,
                quantity = delta,
                copper = delta,
                name = MoneyUtil:GetShortText(delta),
                quality = 1,
            });
        end
        self.playerMoney = money;
    end
end


---------------------------------------------------------------------------
-- Dynamic events: only while looting and a moment after (Plumber's msgListeningDuration)
---------------------------------------------------------------------------

local LISTEN_AFTER_CLOSE = 1.5;

-- Item messages are needed while looting, and after a quest reward was taken.
function EL:IsListeningItemMessage()
    return self.dynamicRegistered or self.questListening
end

function EL:RefreshItemListening()
    if self:IsListeningItemMessage() then
        self:RegisterEvent("CHAT_MSG_LOOT");
    else
        self:UnregisterEvent("CHAT_MSG_LOOT");
    end
end

function EL:ListenDynamicEvents(state)
    if state and not self.dynamicRegistered then
        self.dynamicRegistered = true;
        self:RefreshItemListening();
        self:RefreshExtraListening();
    elseif not state and self.dynamicRegistered then
        self.dynamicRegistered = nil;
        self:RefreshItemListening();
        self:RefreshExtraListening();
    end
end

-- Quest rewards come without a loot window. Only the item messages: money follows "Show Any Money Changes".
local LISTEN_AFTER_QUEST = 3;
local questToken = 0;

function EL:ListenQuestReward()
    if not enabled then
        return
    end
    questToken = questToken + 1;
    local token = questToken;
    self.questListening = true;
    self:RefreshItemListening();
    After(LISTEN_AFTER_QUEST, function()
        if token == questToken then
            EL.questListening = nil;
            EL:RefreshItemListening();
        end
    end);
end

-- FooterButtons.lua: the player took the reward.
CallbackRegistry:Register("TriggerQuestFinished", function()
    EL:ListenQuestReward();
end);

---------------------------------------------------------------------------
-- Show Any Money / Currency Changes
-- Money: PLAYER_MONEY all the time (not only around looting); every gain is a row. Currency: 3.3.5a has honor and
-- arena points (GetHonorCurrency / GetArenaCurrency, not hidden by a collapsed category) and item currencies in the
-- currency list (Emblems ...; only the expanded categories are listed, so only currencies seen in both snapshots count).
-- There is no CHAT_MSG_CURRENCY: item currencies come as items through CHAT_MSG_LOOT while that is listened to (see
-- IsListeningItemMessage), and through the currency list otherwise. Only gains are shown.
---------------------------------------------------------------------------

-- Show Reputation Changes: CHAT_MSG_COMBAT_FACTION_CHANGE, "Reputation with %s increased by %d." Only increases with
-- an amount are shown. Messages come at once, also in combat (retail shows the ones of combat afterwards).
local RepPattern;

function EL:ProcessMessageFaction(text)
    if not RepPattern then
        RepPattern = ToPattern(_G.FACTION_STANDING_INCREASED) or false;
    end
    if not (RepPattern and text) then
        return
    end
    local first, second = match(text, RepPattern);
    if not first then
        return
    end
    -- A language may put the amount first (positional format arguments).
    local name, amount = first, tonumber(second);
    if not amount and tonumber(first) then
        name, amount = second, tonumber(first);
    end
    if name and amount and amount > 0 then
        LootUI.QueueDisplayLoot({
            slotType = Def.SLOT_TYPE_REP,
            id = name,
            name = name,
            quantity = amount,
            quality = 1,
            hideCount = false,
        });
    end
end

local HONOR_ID, ARENA_ID = 1901, 1900;      -- the ids retail gives them (they have none here)

local function TakeCurrencySnapshot()
    local snapshot = {};
    snapshot[HONOR_ID] = {id = HONOR_ID, count = (GetHonorCurrency()) or 0, name = _G.HONOR_POINTS or "Honor Points",
        icon = "Interface\\AddOns\\DialogueUI\\Textures\\Icons\\Honor.blp"};
    snapshot[ARENA_ID] = {id = ARENA_ID, count = GetArenaCurrency() or 0, name = _G.ARENA_POINTS or "Arena Points",
        icon = "Interface\\AddOns\\DialogueUI\\Textures\\Icons\\Conquest.blp"};
    for i = 1, GetCurrencyListSize() do
        local name, isHeader, _, _, _, count, extraType, icon, itemID = GetCurrencyListInfo(i);
        if not isHeader and itemID and itemID > 0 and (extraType or 0) == 0 then
            snapshot[itemID] = {id = itemID, count = count or 0, name = name, icon = icon, item = true};
        end
    end
    return snapshot
end

function EL:OnCurrencyUpdate()
    local old = self.currencySnapshot;
    local new = TakeCurrencySnapshot();
    self.currencySnapshot = new;
    if not old then
        return
    end
    for id, current in pairs(new) do
        local before = old[id];
        local delta = before and (current.count - before.count) or 0;
        -- An item currency is a row of its own already while the chat messages of loot are listened to.
        if delta > 0 and not (current.item and self:IsListeningItemMessage()) then
            local quality = 1;
            if current.item then
                quality = select(3, GetItemInfo(id)) or 1;
            end
            LootUI.QueueDisplayLoot({
                slotType = Def.SLOT_TYPE_CURRENCY,
                id = id,
                icon = current.icon,
                name = current.name,
                quantity = delta,
                quality = quality,
                link = current.item and ("item:" .. id) or nil,
                hideCount = false,
                looted = true,
            });
        end
    end
end

-- Which of the always-on events are needed now (PLAYER_MONEY is also the loot window's money).
function EL:RefreshExtraListening()
    if not enabled then
        return
    end
    if Def.SHOW_ALL_MONEY_CHANGE or self.dynamicRegistered then
        self:RegisterEvent("PLAYER_MONEY");
        self.playerMoney = self.playerMoney or GetMoney();
    else
        self:UnregisterEvent("PLAYER_MONEY");
        self.playerMoney = nil;
    end
    if Def.SHOW_REPUTATION then
        self:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE");
    else
        self:UnregisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE");
    end
    if Def.SHOW_ALL_CURRENCY_CHANGE then
        self:RegisterEvent("CURRENCY_DISPLAY_UPDATE");
        self.currencySnapshot = self.currencySnapshot or TakeCurrencySnapshot();
    else
        self:UnregisterEvent("CURRENCY_DISPLAY_UPDATE");
        self.currencySnapshot = nil;
    end
end

CallbackRegistry:Register("SettingChanged.LootUI_ShowReputation", function(value)
    Def.SHOW_REPUTATION = value and true or false;
    EL:RefreshExtraListening();
end);
CallbackRegistry:Register("SettingChanged.LootUI_ShowAllMoneyChange", function(value)
    Def.SHOW_ALL_MONEY_CHANGE = value and true or false;
    EL:RefreshExtraListening();
end);
CallbackRegistry:Register("SettingChanged.LootUI_ShowAllCurrencyChange", function(value)
    Def.SHOW_ALL_CURRENCY_CHANGE = value and true or false;
    EL:RefreshExtraListening();
end);

function EL:RequestUnregisterDynamicEvents()
    local token = lootToken;
    After(LISTEN_AFTER_CLOSE, function()
        if token == lootToken and not Def.ALWAYS_LISTEN_LOOT_MSG then
            EL:ListenDynamicEvents(false);
        end
    end);
end


---------------------------------------------------------------------------
-- Loot window events
---------------------------------------------------------------------------

-- Whether items are taken without asking (the game's auto loot option, or this module's forced auto loot).
local function IsAutoLoot(autoLootArg)
    if autoLootArg == 1 or autoLootArg == true then
        return true
    end
    return addon.GetDBBool("LootUI_ForceAutoLoot")
end

-- Auto loot: items the game did not take (bag full, a roll is pending, bind-on-pickup ...) come up as a loot window.
function EL:CheckRemainingLoot()
    if self.lootOpened and not MainFrame.manualMode and self:HasRemainingLoot() then
        MainFrame:OnErrored();
    end
end

function EL:OnLootOpened(autoLootArg)
    lootToken = lootToken + 1;
    local token = lootToken;
    self.lootOpened = true;
    self.cleared = {};
    FastLoot:Reset();
    LootUI.HideMasterLootMenu();

    if GetNumLootItems() == 0 then
        CloseLoot();
        return
    end

    self:BuildLootData();
    self:RegisterEvent("UI_ERROR_MESSAGE");

    if not IsAutoLoot(autoLootArg) then
        self:ListenDynamicEvents(false);
        LootUI.WipeLootQueue();
        MainFrame:DisplayPendingLoot();
        return
    end

    if MainFrame.errorMode then
        return              -- LOOT_OPENED can fire again after a failed attempt: do not retry or the server is spammed
    end
    if MainFrame:IsShown() and MainFrame.manualMode then
        MainFrame:Hide();
        MainFrame:SetAlpha(0);
    end

    self.playerMoney = GetMoney();
    self:ListenDynamicEvents(true);

    -- The game takes the items itself on auto loot. If something is still there a moment later the game did not
    -- (or this is forced auto loot): take it once ourselves, then show what is left.
    if addon.GetDBBool("FastLoot") or (addon.GetDBBool("LootUI_ForceAutoLoot") and not (autoLootArg == 1 or autoLootArg == true)) then
        FastLoot:Start();
    else
        After(0.5, function()
            if token == lootToken and self:HasRemainingLoot() then
                FastLoot:Start();
            end
        end);
    end
    After(1.2, function()
        if token == lootToken then
            self:CheckRemainingLoot();
        end
    end);
end

function EL:OnLootClosed()
    lootToken = lootToken + 1;
    self.lootOpened = nil;
    self.currentLoot = nil;
    self.cleared = nil;
    FastLoot:Reset();
    self:UnregisterEvent("UI_ERROR_MESSAGE");
    LootUI.HideMasterLootMenu();
    if MainFrame.manualMode then
        LootUI.WipeLootQueue();
        MainFrame:ClosePendingLoot();
    end
    MainFrame.errorMode = nil;
    self:RequestUnregisterDynamicEvents();
end

function EL:OnLootSlotCleared(slotIndex)
    if self.cleared then
        self.cleared[slotIndex] = true;
    end
    if MainFrame.manualMode then
        MainFrame:SetLootSlotCleared(slotIndex);
    end
end

function EL:OnEvent(event, ...)
    if event == "LOOT_OPENED" then
        self:OnLootOpened(...);
    elseif event == "LOOT_CLOSED" then
        self:OnLootClosed();
    elseif event == "LOOT_SLOT_CLEARED" then
        self:OnLootSlotCleared(...);
    elseif event == "UI_ERROR_MESSAGE" then
        -- ERR_INV_FULL, ERR_LOOT_CANT_LOOT_THAT ... It is not known which messages belong to loot, so every one
        -- while the window is open re-checks what is left (after a moment: the slot clears first on success).
        local token = lootToken;
        After(0.3, function()
            if token == lootToken then
                EL:CheckRemainingLoot();
            end
        end);
    elseif event == "CHAT_MSG_LOOT" then
        self:ProcessMessageItem((...));
    elseif event == "PLAYER_MONEY" then
        self:ProcessMoneyFromLoot();
    elseif event == "CURRENCY_DISPLAY_UPDATE" then
        self:OnCurrencyUpdate();
    elseif event == "CHAT_MSG_COMBAT_FACTION_CHANGE" then
        self:ProcessMessageFaction((...));
    elseif event == "PLAYER_ENTERING_WORLD" then
        -- Money and currencies are not known yet when the addon loads: start from what the player has now.
        self.playerMoney = (Def.SHOW_ALL_MONEY_CHANGE or self.dynamicRegistered) and GetMoney() or nil;
        self.currencySnapshot = Def.SHOW_ALL_CURRENCY_CHANGE and TakeCurrencySnapshot() or nil;
    elseif event == "OPEN_MASTER_LOOT_LIST" then
        if MainFrame.manualMode then
            LootUI.ShowMasterLootMenu(LootUI.lastClickedSlot, LootUI.lastClickedRow);
        end
    elseif event == "UPDATE_MASTER_LOOT_LIST" then
        -- candidates changed (someone left): the menu is built again on the next OPEN_MASTER_LOOT_LIST
        LootUI.HideMasterLootMenu();
    elseif event == "DISPLAY_SIZE_CHANGED" then
        MainFrame:OnUIScaleChanged();
    end
end
EL:SetScript("OnEvent", EL.OnEvent);


---------------------------------------------------------------------------
-- Switch on / off ("LootUI"; Blizzard's LootFrame is taken out while we run)
---------------------------------------------------------------------------

local function SetBlizzardLootFrame(state)
    local frame = _G.LootFrame;         -- FrameXML frame; only its events are touched
    if not frame then
        return
    end
    if state then
        frame:UnregisterAllEvents();
        frame:Hide();
    else
        for _, event in ipairs(BLIZZARD_EVENTS) do
            frame:RegisterEvent(event);
        end
    end
end

local function Apply()
    local state = addon.GetDBBool("LootUI") and not addon.defaultUIActive;
    if state == enabled then
        return
    end
    enabled = state;

    if enabled then
        if MainFrame.Init then
            MainFrame:Init();
        end
        SetBlizzardLootFrame(true);
        for _, event in ipairs(BLIZZARD_EVENTS) do
            EL:RegisterEvent(event);
        end
        EL:RegisterEvent("DISPLAY_SIZE_CHANGED");
        EL:RegisterEvent("PLAYER_ENTERING_WORLD");
        EL:RefreshExtraListening();
        if Def.ALWAYS_LISTEN_LOOT_MSG then
            EL:ListenDynamicEvents(true);
        end
    else
        EL:UnregisterAllEvents();
        EL.dynamicRegistered = nil;
        EL.questListening = nil;
        EL.playerMoney = nil;
        EL.currencySnapshot = nil;
        EL.lootOpened = nil;
        EL.currentLoot = nil;
        LootUI.WipeLootQueue();
        LootUI.HideMasterLootMenu();
        MainFrame:Disable();
        SetBlizzardLootFrame(false);
    end
end

CallbackRegistry:Register("SettingChanged.LootUI", Apply);
CallbackRegistry:Register("DefaultUIActiveChanged", Apply);
