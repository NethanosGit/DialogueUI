local VERSION_TEXT = "1.7.2";


local addonName, addon = ...;

local L = {};       --Locale
local API = {};     --Custom APIs used by this addon
local DB;

-- A missing translation falls back to its own key, so a typo shows up as readable text and not as an error.
setmetatable(L, {
    __index = function(_, key)
        return key
    end,
});

addon.L = L;
addon.API = API;
addon.VERSION_TEXT = VERSION_TEXT;

-- Same key names as retail's DefaultValues, so the future settings menu can reuse retail's definitions.
-- Where our default differs from retail's it is noted.
local DefaultValues = {
    --Appearance
    Theme = 1,                                  --1 Brown, 2 Dark
    FrameSize = 2,                              --0..5 = 0.9, 1.0, 1.1, 1.25, 1.4, 1.6 (retail default 2, see FrameSize.lua)
    FontSizeBase = 1,                           --0..7 = 11 to 18 (see FontUtil.lua)
    FontText = "default",                       --"default" Friz Quadrata, "system" the client font, or the file of a LibSharedMedia font (see FontUtil.lua)
    OpenAnimationDuration = 0.25,               --Seconds the parchment takes to open, 0..2 in steps of 0.25 (not in retail, see ParchmentBackground.lua)
    HideUI = true,                              --Fade out the game UI during a conversation (see HideUI.lua)
    ShowCopyTextButton = false,                 --Copy Text button in the top right corner (see Clipboard.lua)
    ShowNPCNameOnPage = false,                  --"Name: " in front of the page text (see QuestTextLayout.lua)
    ShowQuestType = false,                      --Quest type pills (Quest / Daily / Dungeon ...) in the header (not in retail, see HeaderTags.lua)
    QuestDifficultyStyle = 1,                   --0 Off, 1 Level (default), 2 Name, 3 Both (not in retail) (see GossipDataProvider.lua)
    ColorPlayerName = false,                    --Player name in class color in the page text, Dark theme only (not in retail, see QuestTextLayout.lua)
    ColorClassName = false,                     --Class name in class color in the page text, Dark theme only (not in retail, see QuestTextLayout.lua)
    FrameOrientation = 2,                  --1 Left, 2 Right (default), 3 Custom (not in retail: drag the frame, ParchmentPosition)

    --Control
    InputDevice = 1,                            --1 Keyboard & Mouse (the only one in 3.3.5a, no gamepad)
    RightClickToCloseUI = true,                 --Right click on the dialogue or a readable closes it
    CycleRewardHotkeyEnabled = false,           --Tab / Shift-Tab choose the next / previous quest reward (see FooterButtons.lua)
    ScrollDownThenAcceptQuest = false,          --Confirm key scrolls a long quest text down before accepting (see FooterButtons.lua)
    EscapeToDeclineQuest = false,               --Esc on a quest chosen from a list goes back to the list instead of closing (see FooterButtons.lua)
    UseCustomBindings = false,                --Own keys for Confirm / Settings / Option 1-9 (see Keybindings.lua, DB.CustomBindings)

    --Experience bar at the bottom of the screen (see ExperienceBar.lua)
    ShowEXPBar = true,                          --Shown while the parchment is open
        ShowEXPBarAlways = false,               --Also without a conversation, as the game's experience bar (needs ShowEXPBar). Not in retail

    --Reward tooltip
    UseBlizzardTooltip = false,
    TooltipShowItemComparison = false,
    TooltipShowCalculations = true,             --Stat differences under "Replace X"; off: only the Replace line (see TooltipItem.lua)
    TooltipSeparateCompare = false,            --Equipped items are compared in tooltips of their own, beside the reward tooltip (see TooltipItem.lua)

    --Quest rewards
    MarkHighestSellPrice = false,
    ShowTransmogStatus = false,                 --"Appearance not collected" marker and tooltip line. Needs the server's transmog module (see TransmogStatus.lua)
    UseTransmogPlus = false,                    --The server runs mod-transmog-plus (own protocol) instead of the original mod-transmog (.transmog sync)
    ShowUpgradeArrow = true,                    --Green arrow on reward items with a higher item level than the equipped one (see RewardLayout.lua)

    --Quest Item Display
    QuestItemDisplay = true,                    --Retail: false
        QuestItemDisplayHideSeen = false,
        QuestItemDisplayAwaitWorldMap = false,
        QuestItemDisplayFontSize = 14,          --Not in retail (it follows FontSizeBase)

    --Valuable Reward Popup (Widget_QuickSlot.lua). Needs Pawn, like the upgrade arrow
    QuickSlotQuestReward = false,
        QuickSlotUseHotkey = true,              --The Confirm key equips the item (Press Button To Use)

    --Book Settings
    BookUIEnabled = true,
        BookPositionMode = 1,                   --1 Default (left edge), 2 Custom (not in retail: drag the frame, BookPosition)
        BookUISize = 1,                         --0..5 = 0.9, 1.0, 1.1, 1.25, 1.4, 1.6
        BookHideUI = false,                     --Fade out the game UI while a readable is open (not in retail, see HideUI.lua)
        BookKeepUIOpen = false,
        BookShowLocation = true,                --Retail: false
        BookUIItemDescription = true,           --Retail: false
        BookDarkenScreen = false,

    --Other addons: Spoken (the folders in SupportedAddons are copied into Interface\AddOns, see Code\SpokenSupport.lua)
    SpokenButtons = false,                      --Spoken's Play and Skip buttons on the quest window and the book view

    --Audio fading (see Code\Utility\AudioFade.lua). Not in retail
    EnableAudioFading = false,                  --Lower the game volumes while the dialogue or a readable is open
        AudioFade_SoundVolume = -1,             --0..100 in steps of 5; -1 not chosen: the channel keeps the game's volume
        AudioFade_SoundDuration = 0.5,          --Seconds each way, 0..3 in steps of 0.5 (0.5 is Spoken's default)
        AudioFade_MusicVolume = -1,
        AudioFade_MusicDuration = 0.5,
        AudioFade_AmbienceVolume = -1,
        AudioFade_AmbienceDuration = 0.5,

    --Compatibility
    DisableDUIInInstance = false,               --Blizzard's gossip, quest and book windows in dungeons and raids (see Core.lua)

    --Other addons (see Code\SupportedAddOns)
    ShowAuctionHouseTooltip = true,             --Auction prices in the item tooltip. Not in retail. On because Auctionator prices were always shown
    ShowAuctionatorTooltip = true,              --Auctionator prices (needs ShowAuctionHouseTooltip). On: they were always shown
    ShowJournalGearTooltip = true,              --"On your gear list" line from Journal: Gear Guide (JournalGearGuide). On: it was always shown
    ShowRetailAHTooltip = false,                --AH bot prices of mod-retail-ah (needs ShowAuctionHouseTooltip)

    --Loot UI (see Code\Loot). A port of the Loot UI of the Plumber addon (retail)
    LootUI = false,                             --Replace the game's loot window (see LootController.lua)
        LootUI_Theme = 1,                       --1 Brown, 2 Dark, only for the loot window (needs LootUI)
        FastLoot = true,                        --Loot right when the window opens on auto loot, no delay (needs LootUI)
        LootUI_FontSize = 1,                    --0..7 = 11 to 18 like FontSizeBase, but only for the loot window (needs LootUI)
        LootUI_FadeDelayPerItem = 0.25,         --Seconds the window stays longer per item, 0.25..1 in steps of 0.25 (needs LootUI)
        LootUI_ItemsPerPage = 6,                --Items on one page of the notification window, 5..8 (needs LootUI)
        LootUI_BackgroundAlpha = 0.5,           --Opacity of the notification window background, 0..1 in steps of 0.1 (needs LootUI)
        LootUI_ShowItemCount = true,            --Owned count (bags and bank) on the icon of an item row (needs LootUI)
        LootUI_CombineItem = true,              --Gray items on one "Junk Items" row (needs LootUI)
        LootUI_LowFrameStrata = false,          --Notification window behind other UI, "Send to Back" (needs LootUI)
        LootUI_LootUnderMouse = false,          --Manual loot window opens under the mouse, "Open Loot Window at Mouse" (needs LootUI)
        LootUI_UseHotkey = true,                --A key takes all items in the manual loot window, "Press Key To Take All Items" (needs LootUI)
        LootUI_HotkeyName = "E",                --The key of Take All (needs LootUI_UseHotkey)
        LootUI_HideTitle = false,               --Leave the "You Received" text above the notification window empty (needs LootUI)
        LootUI_ShowReputation = false,          --Reputation gains in the window (needs LootUI)
        LootUI_ShowAllMoneyChange = false,     --Every gain of money, not only the looted one (needs LootUI)
        LootUI_ShowAllCurrencyChange = false,   --Every gain of honor / arena points and currencies, not only looted ones (needs LootUI)
        LootUI_GrowUpwards = false,         --The window's bottom left stays still and it grows upwards, instead of the top left staying still (needs LootUI)
        LootUI_ShowTransmogStatus = false,      --Marker on rows whose appearance is not collected. Needs the server's transmog module (see TransmogStatus.lua) (needs LootUI)

    --Minimap button (see Code\Widget\MinimapButton.lua)
    ShowMinimapButton = true,
    MinimapButtonAngle = 215,                   --Position on the minimap rim in degrees (set by dragging, not shown in the Settings)

    --Not shown in the Settings. Accessible by other means
    DebugGossip = false,                        --Prints the raw gossip lists: /run DialogueUI_DB.DebugGossip = true

    --ParchmentPosition = {point, relativePoint, x, y}
    --BookPosition = {point, relativePoint, x, y}
    --QuestItemDisplayPosition = {x, y}
    --LootUIPosition = {x, y}                 --Fixed corner of the Loot UI window (top left, bottom left with Grow Upwards), from the bottom left of the screen
    --QuickSlotPosition = {x, y}               --Center of the Valuable Reward Popup, from the bottom left of the screen
    --QuestItems = {[itemID] = true}          --Items the Quest Item Display has shown
    --AudioFadeBackup = {[cvar] = volume}      --The player's volumes while lowered, for a session ending without a logout
};

-- Keys that were renamed to match retail. The old value is moved to the new key once.
local RenamedKeys = {
    {"BookSizeIndex", "BookUISize"},
    {"QuestItemDisplayEnabled", "QuestItemDisplay"},
};

local function GetDBValue(dbKey)
    if DB then
        return DB[dbKey]
    end
    --Saved variables are not loaded yet (file load time)
    return DefaultValues[dbKey]
end
addon.GetDBValue = GetDBValue;

local function SetDBValue(dbKey, value, userInput)
    if not DB then return end;
    DB[dbKey] = value;
    addon.CallbackRegistry:Trigger("SettingChanged."..dbKey, value, userInput);
end
addon.SetDBValue = SetDBValue;

local function GetDBBool(dbKey)
    return GetDBValue(dbKey) == true
end
addon.GetDBBool = GetDBBool;

local function FlipDBBool(dbKey, userInput)
    SetDBValue(dbKey, not GetDBBool(dbKey), userInput);
end
addon.FlipDBBool = FlipDBBool;

local function IsDBValue(dbKey, value)
    return GetDBValue(dbKey) == value
end
addon.IsDBValue = IsDBValue;

local function LoadDatabase()
    --One-time migration from the old addon name (DialogueUI_335). The old variable is left untouched as a backup.
    if type(DialogueUI_DB) ~= "table" then
        if type(DialogueUI_335_DB) == "table" then
            local function DeepCopy(t)
                local copy = {};
                for k, v in pairs(t) do
                    copy[k] = (type(v) == "table") and DeepCopy(v) or v;
                end
                return copy;
            end
            DialogueUI_DB = DeepCopy(DialogueUI_335_DB);
        else
            DialogueUI_DB = {};
        end
    end
    DB = DialogueUI_DB;

    for _, v in ipairs(RenamedKeys) do
        local oldKey, newKey = v[1], v[2];
        if DB[oldKey] ~= nil then
            if DB[newKey] == nil then
                DB[newKey] = DB[oldKey];
            end
            DB[oldKey] = nil;
        end
    end

    local type = type;

    for dbKey, defaultValue in pairs(DefaultValues) do
        --Some settings are inter-connected so we load all values first
        if DB[dbKey] == nil or type(DB[dbKey]) ~= type(defaultValue) then
            DB[dbKey] = defaultValue;
        end
    end

    --Every setting announces its value once, so modules can apply it from their SettingChanged callback
    for dbKey in pairs(DefaultValues) do
        SetDBValue(dbKey, DB[dbKey]);
    end

    addon.CallbackRegistry:Trigger("ADDON_LOADED", DB);
end


local EL = CreateFrame("Frame");
EL:RegisterEvent("ADDON_LOADED");
EL:RegisterEvent("PLAYER_ENTERING_WORLD");

EL:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local name = ...
        if name == addonName then
            self:UnregisterEvent(event);
            LoadDatabase();
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        self:UnregisterEvent(event);
        addon.CallbackRegistry:Trigger("PLAYER_ENTERING_WORLD");
    end
end);
