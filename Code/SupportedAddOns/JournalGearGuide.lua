local _, addon = ...;
local L = addon.L;

-- Journal: Gear Guide (JournalGearGuide, formerly JournalGearBIS): "On your gear list" for items that are an
-- upgrade for your spec. The addon adds that line by hooking GameTooltip, which our tooltip is not, so we ask it
-- the same question through its public JournalGearGuide.IsUpgrade(item) and draw the answer ourselves. It answers
-- for the active talents (or the list picked in its tab) at the realm's progression stage, and keeps its answer
-- until gear, bags, level, talents or stage change.
-- Its upgrade arrow on reward items goes through TooltipCompare:IsUpgrade (Code\Tooltip\TooltipCompare.lua).
local GetItemInfo = GetItemInfo;
local tonumber = tonumber;
local ipairs = ipairs;
local table_concat = table.concat;

local ADDON_NAME = "JournalGearGuide";
local GOLD = "|cffffd200";

local REQUIRED = {
    "JournalGearGuide",
    "Journal",
};

local function OnAddOnLoaded()
    local G = _G.JournalGearGuide;
    if not (G and G.IsUpgrade) then
        return
    end

    local function ItemName(id)
        local name = GetItemInfo(id);
        if name then
            return name
        end
        local item = G.Item and G.Item(id);
        return item and item.name or ("item " .. id)
    end

    local function provider(tooltip, link)
        if not addon.GetDBBool("ShowJournalGearTooltip") then
            return
        end
        local id = tonumber(link:match("item:(%d+)"));
        if not id then
            return
        end
        local row, becomes = G.IsUpgrade(id);
        if not (row or becomes) then
            return
        end
        -- Its own line adds "Roll Need", which means nothing for quest rewards.
        tooltip:AddLine(GOLD .. L["On Your Gear List"] .. "|r");
        if becomes then
            local names = {};
            for _, other in ipairs(becomes) do
                names[#names + 1] = ItemName(other);
            end
            tooltip:AddLine(L["Format Exchange It For"]:format(table_concat(names, ", ")), 1, 1, 1);
        end
    end

    -- Early: drawn above the transmog line.
    DialogueUI_API.RegisterItemTooltipProvider(ADDON_NAME, provider, true);
end

addon.AddSupportedAddOn(ADDON_NAME, OnAddOnLoaded, REQUIRED);
