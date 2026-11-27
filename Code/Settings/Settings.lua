local _, addon = ...;

-- Settings window. Port of retail's Settings.xml / Settings.lua layout (frame, header with tabs and close button,
-- header divider, option list on the left, description on the right). The tabs are empty for now.
-- Retail builds this in XML with texture slicing; 3.3.5a has neither, so it is Lua + NineSlice:CreateTiled.
local L = addon.L;
local API = addon.API;
local NineSlice = addon.NineSlice;
local ThemeUtil = addon.ThemeUtil;
local FontUtil = addon.FontUtil;
local CallbackRegistry = addon.CallbackRegistry;
local GetDBValue = addon.GetDBValue;
local SetDBValue = addon.SetDBValue;

local CreateFrame = CreateFrame;
local InCombatLockdown = InCombatLockdown;
local SetOverrideBindingClick = SetOverrideBindingClick;
local ClearOverrideBindings = ClearOverrideBindings;
local PlaySound = PlaySound;
local Round = API.Round;
local upper = string.upper;
local max = math.max;
local min = math.min;
local floor = math.floor;

-- Retail values (Settings.lua) at the default font height 12.
local FRAME_PADDING = 14;
local BUTTON_PADDING_LARGE = 12;
local FONT_HEIGHT = 12;
local TAB_BUTTON_GAP = 4;
local OPTIONBUTTON_HEIGHT = FONT_HEIGHT + 2 * BUTTON_PADDING_LARGE;         -- 36
local OPTIONBUTTON_WIDTH = OPTIONBUTTON_HEIGHT * 12;                        -- 432
local NUM_VISIBLE_OPTIONS = 10.5;
local GAP_TO_HEADER = 12;
local TAB_HEIGHT = FONT_HEIGHT + 2 * BUTTON_PADDING_LARGE;                  -- 36
local TAB_MIN_WIDTH = 2 * TAB_HEIGHT;                                       -- 72
local DIVIDER_THICKNESS = 9;

-- Frame background: GenericFrame-Tiled-Large, 80 px corners, with a 16 px transparent drop shadow around it.
local BACKGROUND_SCALE = 0.75;                  -- drawn size of one texel (retail: pixel-perfect, ~0.71 at 1080p)
local BACKGROUND_SHADOW = 16 * BACKGROUND_SCALE;
local SELECTION_SCALE = 0.75;

local TAB_ENTRIES = {
    { name = L["UI"] },
    { name = L["Control"] },
    { name = L["Gameplay"] },
    { name = L["Audio"] },
    { name = L["Other Addons"] },
    { name = L["Experimental"] },
};

-- Decor picture of the right area (retail Art/ParchmentDecor/Dalaran, a white silhouette tinted in code).
local PREVIEW_PATH = "Interface\\AddOns\\DialogueUI\\Textures\\PreviewPicture\\";
local DECOR_FILE = "Interface\\AddOns\\DialogueUI\\Textures\\ParchmentDecor\\Dalaran.blp";
local DECOR_INSET = 4;                  -- distance from the frame's bottom right corner
local DECOR_MASK_OFFSET = 24;           -- mask edge below the description text
local DECOR_MASK_ALPHA = 0.875;         -- alpha of the mask's opaque part (0xDF)
local DECOR_FADE_ROWS = 8 / 128;        -- fade height as a part of the picture (8 of the mask's 128 rows)

local OTHER_ADDONS_TAB = 5;                   -- index in TAB_ENTRIES
local LOOT_UI_TAB = 6;                        -- index in TAB_ENTRIES

local TOGGLE_NAME ="DialogueUI335SettingsToggle";      -- global names so key bindings can click them
local CLOSE_NAME = "DialogueUI335SettingsClose";

local SettingsUI = {};
addon.SettingsUI = SettingsUI;

local frame;
local ScrollFrameMixin = {};

-- A row half scrolled out of the list keeps its full size for the mouse (3.3.5a does not clip mouse input), so
-- rows only react while the pointer is inside the list itself.
local function IsPointerInList()
    return frame.list:IsMouseOver()
end


---------------------------------------------------------------------------
-- Pieces
---------------------------------------------------------------------------

-- Three-piece divider: two end caps keep their shape, the middle stretches. Retail slices these with margins
-- (H: left/right 32, V: top/bottom 32) and draws them 9 px thick.
local function CreateDivider(parent, fileName, isVertical)
    local f = CreateFrame("Frame", nil, parent);
    local cap = 32 / 256;
    local capSize = 32 * DIVIDER_THICKNESS / 16;

    local first = f:CreateTexture(nil, "ARTWORK");
    local middle = f:CreateTexture(nil, "ARTWORK");
    local last = f:CreateTexture(nil, "ARTWORK");
    f.pieces = { first, middle, last };

    if isVertical then
        first:SetTexCoord(0, 1, 0, cap);
        middle:SetTexCoord(0, 1, cap, 1 - cap);
        last:SetTexCoord(0, 1, 1 - cap, 1);
        first:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0);
        first:SetPoint("TOPRIGHT", f, "TOPRIGHT", 0, 0);
        first:SetHeight(capSize);
        last:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 0, 0);
        last:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 0);
        last:SetHeight(capSize);
        middle:SetPoint("TOPLEFT", first, "BOTTOMLEFT", 0, 0);
        middle:SetPoint("BOTTOMRIGHT", last, "TOPRIGHT", 0, 0);
        f:SetWidth(DIVIDER_THICKNESS);
    else
        first:SetTexCoord(0, cap, 0, 1);
        middle:SetTexCoord(cap, 1 - cap, 0, 1);
        last:SetTexCoord(1 - cap, 1, 0, 1);
        first:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0);
        first:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 0, 0);
        first:SetWidth(capSize);
        last:SetPoint("TOPRIGHT", f, "TOPRIGHT", 0, 0);
        last:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 0);
        last:SetWidth(capSize);
        middle:SetPoint("TOPLEFT", first, "TOPRIGHT", 0, 0);
        middle:SetPoint("BOTTOMRIGHT", last, "BOTTOMLEFT", 0, 0);
        f:SetHeight(DIVIDER_THICKNESS);
    end

    for i = 1, 3 do
        ThemeUtil:BindTexture(f.pieces[i], fileName);
    end
    return f
end

-- Drags the whole window from any of its mouse-enabled parts.
local function ForwardDrag(object)
    object:RegisterForDrag("LeftButton");
    object:SetScript("OnDragStart", function()
        frame:StartMoving();
    end);
    object:SetScript("OnDragStop", function()
        frame:StopMovingOrSizing();
    end);
end


---------------------------------------------------------------------------
-- Close button (retail Header.CloseButton)
---------------------------------------------------------------------------

local CLOSE_SHEET = { 0, 0, 256, 128 };
local CLOSE_HIGHLIGHT_SHEET = { 128, 0, 256, 128 };

local function CreateCloseButton(parent)
    local button = CreateFrame("Button", nil, parent);
    button:SetWidth(TAB_MIN_WIDTH);
    button:SetHeight(TAB_HEIGHT);
    button:RegisterForClicks("LeftButtonUp");

    local fileName = "Settings-CloseButton.blp";
    local file = ThemeUtil:GetTextureFile(fileName);
    local level = button:GetFrameLevel();

    -- Background and hover glow are 128x64 cells of the 256x128 sheet, sliced with 16 px corners.
    local backFrame = CreateFrame("Frame", nil, button);
    backFrame:SetAllPoints(button);
    backFrame:SetFrameLevel(level);
    button.background = NineSlice:CreateTiled(backFrame, file, { 128, 64 }, 16, 1, "BACKGROUND", CLOSE_SHEET);
    button.background:Update(TAB_MIN_WIDTH, TAB_HEIGHT);
    ThemeUtil:BindSlice(button.background, fileName);

    local highlightFrame = CreateFrame("Frame", nil, button);
    highlightFrame:SetAllPoints(button);
    highlightFrame:SetFrameLevel(level + 1);
    button.highlight = NineSlice:CreateTiled(highlightFrame, file, { 128, 64 }, 16, 1, "ARTWORK", CLOSE_HIGHLIGHT_SHEET);
    button.highlight:Update(TAB_MIN_WIDTH, TAB_HEIGHT);
    button.highlight:SetShown(false);
    ThemeUtil:BindSlice(button.highlight, fileName);

    local iconFrame = CreateFrame("Frame", nil, button);
    iconFrame:SetAllPoints(button);
    iconFrame:SetFrameLevel(level + 2);
    local icon = iconFrame:CreateTexture(nil, "OVERLAY");
    ThemeUtil:BindTexture(icon, fileName);
    icon:SetTexCoord(0.0625, 0.1875, 0.625, 0.875);
    icon:SetWidth(FONT_HEIGHT);
    icon:SetHeight(FONT_HEIGHT);
    icon:SetPoint("CENTER", button, "CENTER", 0, 0);
    button.icon = icon;

    button:SetScript("OnEnter", function(self)
        self.highlight:SetShown(true);
    end);
    button:SetScript("OnLeave", function(self)
        self.highlight:SetShown(false);
    end);
    button:SetScript("OnMouseDown", function(self)
        self.icon:SetPoint("CENTER", self, "CENTER", 0, -1);
    end);
    button:SetScript("OnMouseUp", function(self)
        self.icon:SetPoint("CENTER", self, "CENTER", 0, 0);
    end);
    button:SetScript("OnClick", function()
        SettingsUI:Hide();
        PlaySound("igMainMenuOptionCheckBoxOn");
    end);
    button:SetScript("OnHide", function(self)
        self.highlight:SetShown(false);
        self.icon:SetPoint("CENTER", self, "CENTER", 0, 0);
    end);
    ForwardDrag(button);

    return button
end


---------------------------------------------------------------------------
-- Tabs
---------------------------------------------------------------------------

local NormalTabFont, SelectedTabFont;

local function Tab_SetSelected(button, selected)
    button.isSelected = selected;
    button.Name:SetFontObject(selected and SelectedTabFont or NormalTabFont);
end

local function CreateTabButton(parent, tabID, name)
    local button = CreateFrame("Button", nil, parent);
    button:RegisterForClicks("LeftButtonUp");
    button.tabID = tabID;

    button.Name = button:CreateFontString(nil, "OVERLAY");
    button.Name:SetFontObject(NormalTabFont);
    button.Name:SetPoint("CENTER", button, "CENTER", 0, 0);
    button.Name:SetText(upper(name));

    button:SetHeight(TAB_HEIGHT);       -- the width is set by LayoutTabs

    button:SetScript("OnEnter", function(self)
        SettingsUI:HighlightButton(self);
    end);
    button:SetScript("OnLeave", function()
        SettingsUI:HighlightButton(nil);
    end);
    button:SetScript("OnMouseDown", function(self, mouseButton)
        if mouseButton == "LeftButton" and not self.isSelected then
            self.Name:SetPoint("CENTER", self, "CENTER", 0, -1);
        end
    end);
    button:SetScript("OnMouseUp", function(self)
        self.Name:SetPoint("CENTER", self, "CENTER", 0, 0);
    end);
    button:SetScript("OnClick", function(self)
        SettingsUI:SelectTab(self.tabID);
    end);
    ForwardDrag(button);

    return button
end

-- Each tab is as wide as its text plus padding. When they do not all fit beside the close button (long translations,
-- wide fonts), the padding and then the minimum width give way.
local function LayoutTabs(buttons, availableWidth)
    local gaps = (#buttons - 1) * TAB_BUTTON_GAP;
    local textWidth = 0;
    for _, button in ipairs(buttons) do
        textWidth = textWidth + button.Name:GetStringWidth();
    end
    local padding = max(0, min(2 * FONT_HEIGHT, floor((availableWidth - gaps - textWidth) / #buttons)));

    local total = gaps;
    for _, button in ipairs(buttons) do
        total = total + max(TAB_MIN_WIDTH, Round(button.Name:GetStringWidth() + padding));
    end
    local minWidth = total > availableWidth and 0 or TAB_MIN_WIDTH;

    for _, button in ipairs(buttons) do
        button:SetWidth(max(minWidth, Round(button.Name:GetStringWidth() + padding)));
    end
end


---------------------------------------------------------------------------
-- Options
---------------------------------------------------------------------------

local OPTION_ROW_HEIGHT = OPTIONBUTTON_HEIGHT;
local OPTION_LABEL_OFFSET = 14;
local OPTION_WIDGET_SIZE = 24;
local ARROW_FILE = "Settings-ArrowOption.blp";
local ARROW_BUTTON_WIDTH = 24;
local ARROW_BUTTON_HEIGHT = 32;
local ARROWOPTION_WIDTH = OPTION_WIDGET_SIZE * 7;
local ARROWOPTION_VALUETEXT_OFFSET_Y = -2;
-- Retail sizes the bars in screen pixels (API.GetPixelForWidget: 5 and 4 px, ~3.6 and ~2.8 units at 1080p).
-- Same 0.75 units per pixel as the other pixel-scaled art here (BACKGROUND_SCALE).
local ARROWOPTION_BAR_HEIGHT = 4 * BACKGROUND_SCALE;        -- retail uses 5 px, tuned by eye in the game
local ARROWOPTION_BAR_GAP = 4 * BACKGROUND_SCALE;
local ARROWOPTION_BAR_SHRINK = 4;

-- Orientation: Move / Reset Position rows (retail "Custom" rows). Move shows a sample page to drag, Reset puts the
-- frame back on the default side.
local ORIENTATION_CUSTOM = 3;

local function Orientation_Move_OnClick()
    addon.DialogueUI:ToggleEditMode();
end

local function Orientation_Reset_OnClick()
    addon.DialogueUI:ResetPosition();
end

local function Orientation_Move_IsToggled()
    return addon.DialogueUI:IsEditMode()
end

local function OrientationPosition_Validation()
    return addon.DialogueUI:IsUsingCustomPosition()
end

-- Readables: same Move / Reset rows, shown for BookPositionMode Custom.
local BOOK_POSITION_CUSTOM = 2;

local function Book_Move_OnClick()
    addon.Book:ToggleEditMode();
end

local function Book_Reset_OnClick()
    addon.Book:ResetPosition();
end

local function Book_Move_IsToggled()
    return addon.Book:IsEditMode()
end

local function BookPosition_Validation()
    return addon.Book:IsUsingCustomPosition()
end

-- Quest Item Display: Move shows a sample popup to drag, Reset puts it back at the default place.
local function QuestItemDisplay_Move_OnClick()
    addon.QuestItemDisplay:ToggleEditMode();
end

local function QuestItemDisplay_Move_IsToggled()
    return addon.QuestItemDisplay:IsEditMode()
end

local function QuestItemDisplay_Reset_OnClick()
    addon.QuestItemDisplay:ResetPosition();
end

local function QuestItemDisplayPosition_Validation()
    return addon.QuestItemDisplay:IsUsingCustomPosition()
end

-- Loot UI: the window is dragged where it is (no Move row), Reset puts it back at the default place.
local function LootUI_Move_OnClick()
    addon.LootUI.MainFrame:SetMoveMode(not addon.LootUI.MainFrame:IsMoveMode());
end

local function LootUI_Move_IsToggled()
    return addon.LootUI.MainFrame:IsMoveMode()
end

local function LootUI_Reset_OnClick()
    addon.LootUI.MainFrame:ResetPosition();
end

local function LootUIPosition_Validation()
    return addon.LootUI.MainFrame:IsUsingCustomPosition()
end

-- Valuable Reward Popup: Move shows a sample popup to drag, Reset puts it back. Needs Pawn (or Journal: Gear Guide)
-- like the upgrade arrow, so without either the checkbox is greyed out (UpgradeArrow_* below) and the rows under it
-- stay hidden.
local function QuickSlot_Move_OnClick()
    addon.QuickSlot:ToggleEditMode();
end

local function QuickSlot_Move_IsToggled()
    return addon.QuickSlot:IsEditMode()
end

local function QuickSlot_Reset_OnClick()
    addon.QuickSlot:ResetItemButtonPosition();
end

local function QuickSlot_Move_Validation()
    return addon.TooltipCompare:HasUpgradeSource()
end

local function QuickSlotPosition_Validation()
    return addon.TooltipCompare:HasUpgradeSource() and addon.QuickSlot:IsUsingCustomPosition()
end

-- Press Button To Use: names the Confirm key the player has now.
local function UseItemHotkey_Tooltip()
    local key = addon.BindingUtil:GetActiveConfirmKey();
    if key == "SPACE" then
        return L["Press Key To Use Item Desc PC"]
    end
    return L["Press Key To Use Item Desc Generic"]:format(key or L["Not Bound"])
end

-- Retail's requiredParentValueAnd = {dbKey = value or {values}} (all must match) and validationFunc.
local function IsOptionValid(optionData)
    local required = optionData.requiredParentValueAnd;
    if required then
        for dbKey, wanted in pairs(required) do
            local current = GetDBValue(dbKey);
            local matches = false;
            if type(wanted) == "table" then
                for _, value in ipairs(wanted) do
                    if value == current then
                        matches = true;
                    end
                end
            else
                matches = (current == wanted);
            end
            if not matches then
                return false
            end
        end
    end
    if optionData.validationFunc and not optionData.validationFunc() then
        return false
    end
    return true
end

-- Description of the chosen Quest Difficulty style (retail QuestDifficultyStyle_Tooltip).
local function QuestDifficultyStyle_Tooltip()
    local index = addon.GetDBValue("QuestDifficultyStyle");
    if index == 0 then
        return L["QuestDifficultyStyle Off Desc"]
    elseif index == 1 then
        return L["QuestDifficultyStyle Level Desc"]
    elseif index == 2 then
        return L["QuestDifficultyStyle Name Desc"]
    elseif index == 3 then
        return L["QuestDifficultyStyle Both Desc"]
    end
end

-- Description with the arrow drawn inline (retail ItemEvaluatorTooltip uses UpgradeArrowSmall the same way).
local UPGRADE_ARROW_ICON = "|TInterface\\AddOns\\DialogueUI\\Textures\\Shared\\UpgradeArrowSmall.blp:0:0:0:-6|t";     -- retail's numbers (0 = font height)
local PAWN_URL = "https://warperia.com/addon-wotlk/pawn/download/";
local function QuickSlot_Tooltip()
    local text = L["Valuable Reward Popup Desc"];
    if not addon.TooltipCompare:HasUpgradeSource() then
        text = text .. "\n\n" .. L["Show Upgrade Arrow Pawn Missing"]:format(PAWN_URL);
    end
    return text
end
local function UpgradeArrow_Tooltip()
    local text = L["Show Upgrade Arrow Desc"]:format(UPGRADE_ARROW_ICON);
    if not addon.TooltipCompare:HasUpgradeSource() then
        text = text .. "\n\n" .. L["Show Upgrade Arrow Pawn Missing"]:format(PAWN_URL);
    end
    return text
end
-- Without Pawn (or Journal: Gear Guide) the checkbox is greyed out; clicking it opens the Clipboard window with
-- Pawn's download link.
local function UpgradeArrow_IsDisabled()
    return not addon.TooltipCompare:HasUpgradeSource()
end
local function UpgradeArrow_DisabledClick()
    addon.Clipboard:ShowContent(PAWN_URL, nil, true, 360, 40);
end

-- Auction House tooltip addons (Other Addons tab). The description names what is missing when the addon is not
-- running, as the Transmog options do for their server module.
local function AuctionHouseAddOn_Tooltip(addonName, displayName, descKey)
    return function()
        local text = L[descKey];
        if not addon.IsSupportedAddOnActive(addonName) then
            text = text .. "\n\n" .. L["Addon Not Installed"]:format(displayName);
        end
        return text
    end
end
local Auctionator_Tooltip = AuctionHouseAddOn_Tooltip("Auctionator", "Auctionator", "Auction House Auctionator Desc");
local RetailAH_Tooltip = AuctionHouseAddOn_Tooltip("RetailAH", "Retail Auction House", "Auction House RetailAH Desc");
-- Spoken (Other Addons tab): its side is files copied into the Spoken folders (from SupportedAddons). The description
-- says how; the tooltip adds what is missing right now.
local function Spoken_Tooltip(descKey)
    return function()
        local text = L[descKey];
        if not addon.IsSupportedAddOnActive("Spoken") then
            text = text .. "\n\n" .. L["Addon Not Installed"]:format("Spoken");
        elseif not _G.DialogueUI_SpokenBridge then
            text = text .. "\n\n" .. L["Spoken Bridge Missing"];
        end
        return text
    end
end
local function Spoken_IsDisabled()
    return not (addon.IsSupportedAddOnActive("Spoken") and _G.DialogueUI_SpokenBridge)
end
-- Greyed out and unchecked while the addon is not running (the saved choice is kept for when it is).
-- Journal: Gear Guide is not released yet, so its row only exists for those who have it.
local function JournalGear_IsAvailable()
    return addon.IsSupportedAddOnActive("JournalGearGuide")
end
local function Auctionator_IsDisabled()
    return not addon.IsSupportedAddOnActive("Auctionator")
end
local function RetailAH_IsDisabled()
    return not addon.IsSupportedAddOnActive("RetailAH")
end

-- The separate comparison tooltip is ours: greyed out (and unchecked) while the Blizzard tooltip is in use.
local function SeparateCompare_IsDisabled()
    return addon.GetDBBool("UseBlizzardTooltip")
end
local function SeparateCompare_Tooltip()
    local text = L["Use Separate Tooltip for Comparison Desc"];
    if SeparateCompare_IsDisabled() then
        text = text .. "\n\n" .. L["Use Separate Tooltip Blizzard Active"]:format(L["Use Blizzard Tooltip"]);
    end
    return text
end

-- Transmog options: greyed out while the server's module is known not to be there (see TransmogStatus.lua).
local function TransmogStatus_IsDisabled()
    return not addon.TransmogStatus:IsModuleAvailable()
end
local function TransmogStatus_IsAvailable()
    return addon.TransmogStatus:IsModuleAvailable()
end
-- Never greyed out: finding out whether plus is there takes an addon whisper, which some servers block (with a red error)
-- until a level. So it is only sent once the player turns this option on.
local function TransmogPlus_IsMissing()
    return addon.TransmogStatus:IsPlus() and not addon.TransmogStatus:IsPlusAvailable()
end
local function TransmogStatus_Tooltip()
    local text = L["Show Transmog Status Desc"];
    if TransmogStatus_IsDisabled() then
        text = text .. "\n\n" .. L["Transmog Module Missing"]:format("mod-transmog / mod-transmog-plus");
    end
    return text
end
local function TransmogPlus_Tooltip()
    local text = L["Use Transmog Plus Desc"];
    if TransmogPlus_IsMissing() then
        text = text .. "\n\n" .. L["Transmog Module Missing"]:format("mod-transmog-plus");
    end
    return text
end

-- Grow Upwards: the text of the current state first and highlighted (white; black on the brown theme), the other
-- one below (as Plumber).
local function GrowUpwards_Tooltip()
    local on, off = L["Grow Upwards On Desc"], L["Grow Upwards Off Desc"];
    local color = addon.ThemeUtil:IsDarkMode() and "|cffffffff" or "|cff000000";
    if addon.GetDBBool("LootUI_GrowUpwards") then
        return color .. on .. "|r\n\n" .. off
    end
    return color .. off .. "|r\n\n" .. on
end

-- Control tab (retail Settings_Definitions). Retail's Input Device has Keyboard & Mouse, Xbox, PlayStation and Switch;
-- 3.3.5a has no gamepad, so the only choice is Keyboard & Mouse (the arrows are hidden for a single choice).
-- Use Custom Bindings shows the rows of the actions under it (retail: branch mark = depends on the option above).
local ControlOptions = {
    {type = "ArrowOption", name = L["Input Device"], description = L["Input Device Desc"], dbKey = "InputDevice",
        choices = {
            {dbValue = 1, valueText = L["Input Device KBM"]},
        },
    },
    {type = "Checkbox", name = L["Use Custom Bindings"], description = L["Use Custom Bindings Desc"], dbKey = "UseCustomBindings",
        requiredParentValueAnd = {InputDevice = 1}},
};

do
    local requiredCustom = {InputDevice = 1, UseCustomBindings = true};

    -- Description of a key row: what the key does, how to change it, and the key it has now.
    local function AddKeybinding(action, name, description)
        local fullDescription = function()
            return description .. "\n\n" .. L["Keybinding Hint"] .. "\n\n" .. addon.BindingUtil:GetActionTooltip(action)
        end;
        ControlOptions[#ControlOptions + 1] = {type = "Keybinding", branchLevel = 2, action = action, name = name,
            description = description, tooltip = fullDescription, requiredParentValueAnd = requiredCustom};
    end

    AddKeybinding("Confirm", L["Action Confirm"], L["Primary Control Key Desc"]);
    AddKeybinding("Settings", L["Action Settings"], L["Action Settings Desc"]);
    for i = 1, 9 do
        AddKeybinding("Option" .. i, L["Action Option" .. i], L["Action Option Desc"]:format(i));
    end

    ControlOptions[#ControlOptions + 1] = {type = "Checkbox", name = L["Right Click To Close UI"], description = L["Right Click To Close UI Desc"],
        dbKey = "RightClickToCloseUI", requiredParentValueAnd = {InputDevice = 1}};
    ControlOptions[#ControlOptions + 1] = {type = "Subheader", name = L["Quest"]};
    ControlOptions[#ControlOptions + 1] = {type = "Checkbox", name = L["Press Tab To Select Reward"], description = L["Press Tab To Select Reward Desc"],
        dbKey = "CycleRewardHotkeyEnabled", requiredParentValueAnd = {InputDevice = 1}};
    ControlOptions[#ControlOptions + 1] = {type = "Checkbox", name = L["Press Button To Scroll Down"], description = L["Press Button To Scroll Down Desc"],
        dbKey = "ScrollDownThenAcceptQuest"};
    ControlOptions[#ControlOptions + 1] = {type = "Checkbox", name = L["Press Escape To Decline Quest"], description = L["Press Escape To Decline Quest Desc"],
        dbKey = "EscapeToDeclineQuest"};
end

-- Font: names what is wrong when the saved font is gone, and where to get more fonts.
local function Font_Tooltip()
    local text = L["Font Desc"];
    local value = GetDBValue("FontText");
    if value ~= "default" and value ~= "system" and FontUtil:GetFontFile(value) ~= value then
        text = text .. "\n\n" .. L["Font Missing"];
    end
    if not FontUtil:HasSharedMedia() then
        text = text .. "\n\n" .. L["Font No Shared Media"];
    end
    return text
end
-- The menu draws each name in its own font; the files are resolved when a page is shown.
local function Font_GetChoices()
    return FontUtil:GetFontChoices()
end
local function Font_GetChoiceFile(choice)
    return FontUtil:GetFontFile(choice.dbValue)
end

-- Audio tab: a volume and a fade duration for each channel (see AudioFade.lua).
local AudioOptions = {
    {type = "Checkbox", name = L["Enable Audio Fading"], description = L["Enable Audio Fading Desc"], dbKey = "EnableAudioFading"},
};

do
    local volumeChoices, durationChoices = {}, {};
    for percent = 0, 100, 5 do
        volumeChoices[#volumeChoices + 1] = {dbValue = percent, valueText = percent .. "%"};
    end
    for step = 0, 6 do
        local seconds = step * 0.5;
        durationChoices[#durationChoices + 1] = {dbValue = seconds, valueText = seconds .. "s"};
    end

    local required = {EnableAudioFading = true};

    -- Music: says why it has no effect while Spoken plays its voices through that channel.
    local function Music_Tooltip(description)
        return function()
            if addon.AudioFade:IsMusicUsedBySpoken() then
                return description .. "\n\n" .. L["Audio Fade Music Spoken"]
            end
            return description
        end
    end

    local function AddChannel(key, volumeName, volumeDesc, durationName, durationDesc)
        local dbKey = "AudioFade_" .. key .. "Volume";
        -- Not chosen yet (-1): the game's own volume, to the nearest step.
        local function GetShownVolume()
            local value = GetDBValue(dbKey);
            if value < 0 then
                value = 5 * floor(addon.AudioFade:GetPlayerVolume(key) * 20 + 0.5);
            end
            return value
        end
        local isMusic = (key == "Music");
        AudioOptions[#AudioOptions + 1] = {type = "ArrowOption", name = volumeName, description = volumeDesc,
            tooltip = isMusic and Music_Tooltip(volumeDesc) or nil, dbKey = dbKey, getValueFunc = GetShownVolume,
            choices = volumeChoices, requiredParentValueAnd = required};
        AudioOptions[#AudioOptions + 1] = {type = "ArrowOption", name = durationName, description = durationDesc,
            tooltip = isMusic and Music_Tooltip(durationDesc) or nil, dbKey = "AudioFade_" .. key .. "Duration",
            choices = durationChoices, requiredParentValueAnd = required};
    end

    AddChannel("Sound", L["Sound Fade Volume"], L["Sound Fade Volume Desc"], L["Sound Fade Duration"], L["Sound Fade Duration Desc"]);
    AddChannel("Music", L["Music Fade Volume"], L["Music Fade Volume Desc"], L["Music Fade Duration"], L["Music Fade Duration Desc"]);
    AddChannel("Ambience", L["Ambiance Fade Volume"], L["Ambiance Fade Volume Desc"], L["Ambiance Fade Duration"], L["Ambiance Fade Duration Desc"]);
end

-- The tabs, in the order of TAB_ENTRIES. Option fields follow retail: type, name, description, dbKey, choices.
local Schematic = {
    {   -- UI
        options = {
            {type = "ArrowOption", name = L["Theme"], description = L["Theme Desc"], dbKey = "Theme", preview = "Theme", ratio = 2,
                choices = {
                    {dbValue = 1, valueText = L["Theme Brown"]},
                    {dbValue = 2, valueText = L["Theme Dark"]},
                },
            },
            {type = "ArrowOption", name = L["Frame Size"], description = L["Frame Size Desc"], dbKey = "FrameSize",
                choices = {
                    {dbValue = 0, valueText = L["Size Extra Small"]},
                    {dbValue = 1, valueText = L["Size Small"]},
                    {dbValue = 2, valueText = L["Size Medium"]},
                    {dbValue = 3, valueText = L["Size Large"]},
                    {dbValue = 4, valueText = L["Size Very Large"]},
                    {dbValue = 5, valueText = L["Size Extra Large"]},
                },
            },
            {type = "ArrowOption", name = L["Open Animation"], description = L["Open Animation Desc"], dbKey = "OpenAnimationDuration",
                choices = {
                    {dbValue = 0, valueText = "0s"},
                    {dbValue = 0.25, valueText = "0.25s"},
                    {dbValue = 0.5, valueText = "0.5s"},
                    {dbValue = 0.75, valueText = "0.75s"},
                    {dbValue = 1, valueText = "1s"},
                    {dbValue = 1.25, valueText = "1.25s"},
                    {dbValue = 1.5, valueText = "1.5s"},
                    {dbValue = 1.75, valueText = "1.75s"},
                    {dbValue = 2, valueText = "2s"},
                },
            },
            {type = "ArrowOption", name = L["Font Size"], description = L["Font Size Desc"], dbKey = "FontSizeBase",
                choices = {
                    {dbValue = 0, valueText = "11"},
                    {dbValue = 1, valueText = "12"},
                    {dbValue = 2, valueText = "13"},
                    {dbValue = 3, valueText = "14"},
                    {dbValue = 4, valueText = "15"},
                    {dbValue = 5, valueText = "16"},
                    {dbValue = 6, valueText = "17"},
                    {dbValue = 7, valueText = "18"},
                },
            },
            {type = "DropdownButton", name = L["Font"], description = L["Font Desc"], tooltip = Font_Tooltip, dbKey = "FontText",
                choices = Font_GetChoices, getChoiceFile = Font_GetChoiceFile},
            {type = "ArrowOption", name = L["Frame Orientation"], description = L["Frame Orientation Desc"], dbKey = "FrameOrientation",
                choices = {
                    {dbValue = 1, valueText = L["Orientation Left"]},
                    {dbValue = 2, valueText = L["Orientation Right"]},
                    {dbValue = 3, valueText = L["Orientation Custom"]},
                },
            },
            {type = "Custom", name = L["Move Position"], description = L["Move Position Desc"], icon = "Settings-Move.blp",
                onClickFunc = Orientation_Move_OnClick, isToggledFunc = Orientation_Move_IsToggled, requiredParentValueAnd = {FrameOrientation = ORIENTATION_CUSTOM}},
            {type = "Custom", name = L["Reset Position"], description = L["Reset Position Desc"], icon = "Settings-Reset.blp",
                onClickFunc = Orientation_Reset_OnClick, validationFunc = OrientationPosition_Validation,
                requiredParentValueAnd = {FrameOrientation = ORIENTATION_CUSTOM}},
            {type = "Checkbox", name = L["Show Copy Text Button"], description = L["Show Copy Text Button Desc"], dbKey = "ShowCopyTextButton", preview = "CopyTextButton", ratio = 1},
            {type = "Checkbox", name = L["Instant Quest Text"], description = L["Instant Quest Text Desc"], cvarFunc = function() return addon.INSTANT_TEXT_CVAR end},
            {type = "Subheader", name = L["Quest"]},
            {type = "Checkbox", name = L["Hide UI"], description = L["Hide UI Desc"], dbKey = "HideUI"},
            {type = "ArrowOption", name = L["Quest Difficulty Option"], description = L["Quest Difficulty Option Desc"], tooltip = QuestDifficultyStyle_Tooltip, dbKey = "QuestDifficultyStyle", preview = "QuestDifficultyStyle", ratio = 2,
                choices = {
                    {dbValue = 0, valueText = L["QuestDifficultyStyle Off"]},
                    {dbValue = 1, valueText = L["QuestDifficultyStyle Level"]},
                    {dbValue = 2, valueText = L["QuestDifficultyStyle Name"]},
                    {dbValue = 3, valueText = L["QuestDifficultyStyle Both"]},
                },
            },
            {type = "Checkbox", name = L["Show NPC Name On Page"], description = L["Show NPC Name On Page Desc"], dbKey = "ShowNPCNameOnPage"},
            {type = "Checkbox", name = L["Show Quest Type"], description = L["Show Quest Type Desc"], dbKey = "ShowQuestType", preview = "QuestType", ratio = 409 / 124},     -- picture is 409 x 124 stretched to 512 x 128
            {type = "Checkbox", name = L["Show Upgrade Arrow"], description = L["Show Upgrade Arrow Desc"], tooltip = UpgradeArrow_Tooltip, dbKey = "ShowUpgradeArrow", isDisabledFunc = UpgradeArrow_IsDisabled, onDisabledClick = UpgradeArrow_DisabledClick, copyLink = PAWN_URL},
            {type = "Checkbox", name = L["Mark Highest Sell Price"], description = L["Mark Highest Sell Price Desc"], dbKey = "MarkHighestSellPrice", preview = "MarkHighestSellPrice", ratio = 1},
            {type = "Checkbox", name = L["Show EXP Bar"], description = L["Show EXP Bar Desc"], dbKey = "ShowEXPBar"},
            {type = "Checkbox", name = L["Always Show EXP Bar"], description = L["Always Show EXP Bar Desc"], dbKey = "ShowEXPBarAlways",
                requiredParentValueAnd = {ShowEXPBar = true}},
            {type = "Checkbox", name = L["Color Player Name"], description = L["Color Player Name Desc"], dbKey = "ColorPlayerName"},
            {type = "Checkbox", name = L["Color Class Name"], description = L["Color Class Name Desc"], dbKey = "ColorClassName"},
            {type = "Subheader", name = L["Tooltip"], extraWidth = 15},
            {type = "Checkbox", name = L["Use Separate Tooltip for Comparison"], description = L["Use Separate Tooltip for Comparison Desc"], tooltip = SeparateCompare_Tooltip, dbKey = "TooltipSeparateCompare",
                isDisabledFunc = SeparateCompare_IsDisabled, keepValueWhenDisabled = true},
            {type = "Checkbox", name = L["Show Replace Calculations"], description = L["Show Replace Calculations Desc"], dbKey = "TooltipShowCalculations"},
            {type = "Checkbox", name = L["Use Blizzard Tooltip"], description = L["Use Blizzard Tooltip Desc"], dbKey = "UseBlizzardTooltip"},
            {type = "Subheader", name = L["Readables"], extraWidth = 20},
            {type = "Checkbox", name = L["Hide UI"], description = L["Readables Hide UI Desc"], dbKey = "BookHideUI"},
            {type = "ArrowOption", name = L["Readables Position"], description = L["Readables Position Desc"], dbKey = "BookPositionMode",
                choices = {
                    {dbValue = 1, valueText = L["Position Default"]},
                    {dbValue = 2, valueText = L["Orientation Custom"]},
                },
            },
            {type = "Custom", name = L["Move Position"], description = L["Readables Move Position Desc"], icon = "Settings-Move.blp",
                onClickFunc = Book_Move_OnClick, isToggledFunc = Book_Move_IsToggled, requiredParentValueAnd = {BookPositionMode = BOOK_POSITION_CUSTOM}},
            {type = "Custom", name = L["Reset Position"], description = L["Readables Reset Position Desc"], icon = "Settings-Reset.blp",
                onClickFunc = Book_Reset_OnClick, validationFunc = BookPosition_Validation,
                requiredParentValueAnd = {BookPositionMode = BOOK_POSITION_CUSTOM}},
            {type = "ArrowOption", name = L["Frame Size"], description = L["BookUI Frame Size Desc"], dbKey = "BookUISize",
                choices = {
                    {dbValue = 0, valueText = L["Size Extra Small"]},
                    {dbValue = 1, valueText = L["Size Small"]},
                    {dbValue = 2, valueText = L["Size Medium"]},
                    {dbValue = 3, valueText = L["Size Large"]},
                    {dbValue = 4, valueText = L["Size Very Large"]},
                    {dbValue = 5, valueText = L["Size Extra Large"]},
                },
            },
            {type = "Checkbox", name = L["BookUI Keep UI Open"], description = L["BookUI Keep UI Open Desc"], dbKey = "BookKeepUIOpen"},
            {type = "Checkbox", name = L["BookUI Show Location"], description = L["BookUI Show Location Desc"], dbKey = "BookShowLocation"},
            {type = "Checkbox", name = L["BookUI Show Item Description"], description = L["BookUI Show Item Description Desc"], dbKey = "BookUIItemDescription"},
            {type = "Checkbox", name = L["BookUI Darken Screen"], description = L["BookUI Darken Screen Desc"], dbKey = "BookDarkenScreen"},
        },
    },
    {   -- Control
        options = ControlOptions,
    },
    {   -- Gameplay
        options = {
            {type = "Checkbox", name = L["Quest Item Display"], description = L["Quest Item Display Desc"], dbKey = "QuestItemDisplay", preview = "QuestItemDisplay", ratio = 2},
            {type = "Checkbox", name = L["Quest Item Display Hide Seen"], description = L["Quest Item Display Hide Seen Desc"], dbKey = "QuestItemDisplayHideSeen",
                requiredParentValueAnd = {QuestItemDisplay = true}},
            {type = "Checkbox", name = L["Quest Item Display Await World Map"], description = L["Quest Item Display Await World Map Desc"], dbKey = "QuestItemDisplayAwaitWorldMap",
                requiredParentValueAnd = {QuestItemDisplay = true}},
            {type = "Custom", name = L["Move Position"], description = L["Move Position Desc"], icon = "Settings-Move.blp",
                onClickFunc = QuestItemDisplay_Move_OnClick, isToggledFunc = QuestItemDisplay_Move_IsToggled,
                requiredParentValueAnd = {QuestItemDisplay = true}},
            {type = "Custom", name = L["Reset Position"], description = L["Quest Item Display Reset Position Desc"], icon = "Settings-Reset.blp",
                onClickFunc = QuestItemDisplay_Reset_OnClick, validationFunc = QuestItemDisplayPosition_Validation,
                requiredParentValueAnd = {QuestItemDisplay = true}},
            {type = "Subheader", name = L["Quest"]},
            {type = "Checkbox", name = L["Valuable Reward Popup"], description = L["Valuable Reward Popup Desc"], tooltip = QuickSlot_Tooltip, dbKey = "QuickSlotQuestReward",
                preview = "QuickSlotQuestReward", ratio = 2, isDisabledFunc = UpgradeArrow_IsDisabled, onDisabledClick = UpgradeArrow_DisabledClick, copyLink = PAWN_URL},
            {type = "Custom", name = L["Move Position"], description = L["Move Position Desc"], icon = "Settings-Move.blp",
                onClickFunc = QuickSlot_Move_OnClick, isToggledFunc = QuickSlot_Move_IsToggled, validationFunc = QuickSlot_Move_Validation,
                requiredParentValueAnd = {QuickSlotQuestReward = true}},
            {type = "Custom", name = L["Reset Position"], description = L["Quest Item Display Reset Position Desc"], icon = "Settings-Reset.blp",
                onClickFunc = QuickSlot_Reset_OnClick, validationFunc = QuickSlotPosition_Validation,
                requiredParentValueAnd = {QuickSlotQuestReward = true}},
            {type = "Checkbox", name = L["Press Key To Use Item"], tooltip = UseItemHotkey_Tooltip, dbKey = "QuickSlotUseHotkey",
                requiredParentValueAnd = {QuickSlotQuestReward = true}, validationFunc = QuickSlot_Move_Validation, branchLevel = 0},
            {type = "Subheader", name = L["Compatibility"], extraWidth = 15},
            {type = "Checkbox", name = L["Disable DUI In Instance"], description = L["Disable DUI In Instance Desc"], dbKey = "DisableDUIInInstance"},
            {type = "Subheader", name = L["Minimap"], extraWidth = 15},
            {type = "Checkbox", name = L["Show Minimap Button"], description = L["Show Minimap Button Desc"], dbKey = "ShowMinimapButton"},
        },
    },
    {   -- Audio
        options = AudioOptions,
    },
    {   -- Other Addons
        options = {
            {type = "Subheader", name = L["Tooltip"], extraWidth = 15},
            {type = "Checkbox", name = L["Auction House"], description = L["Auction House Desc"], dbKey = "ShowAuctionHouseTooltip"},
            {type = "Checkbox", name = "Auctionator", description = L["Auction House Auctionator Desc"], tooltip = Auctionator_Tooltip,
                dbKey = "ShowAuctionatorTooltip", isDisabledFunc = Auctionator_IsDisabled, requiredParentValueAnd = {ShowAuctionHouseTooltip = true}},
            {type = "Checkbox", name = "Retail Auction House", description = L["Auction House RetailAH Desc"], tooltip = RetailAH_Tooltip,
                dbKey = "ShowRetailAHTooltip", isDisabledFunc = RetailAH_IsDisabled, requiredParentValueAnd = {ShowAuctionHouseTooltip = true}},
            {type = "Checkbox", name = "Journal: Gear Guide", description = L["Journal Gear Desc"],
                validationFunc = JournalGear_IsAvailable, dbKey = "ShowJournalGearTooltip"},
            {type = "Checkbox", name = L["Show Transmog Status"], description = L["Show Transmog Status Desc"], tooltip = TransmogStatus_Tooltip, isDisabledFunc = TransmogStatus_IsDisabled, dbKey = "ShowTransmogStatus", preview = "Transmog", ratio = 511 / 484},     -- picture is 511 x 484 stretched to 512 x 512,
            {type = "Checkbox", name = L["Use Transmog Plus"], description = L["Use Transmog Plus Desc"], tooltip = TransmogPlus_Tooltip, dbKey = "UseTransmogPlus",
                requiredParentValueAnd = {ShowTransmogStatus = true}},
            {type = "Subheader", name = "Spoken", extraWidth = 15},
            {type = "Checkbox", name = L["Spoken Buttons"], description = L["Spoken Buttons Desc"], tooltip = Spoken_Tooltip("Spoken Buttons Desc"),
                dbKey = "SpokenButtons", isDisabledFunc = Spoken_IsDisabled},
        },
    },
    {   -- Loot UI
        options = {
            {type = "Checkbox", name = L["Use Loot UI"], description = L["Use Loot UI Desc"], dbKey = "LootUI", preview = "LootUI", ratio = 504 / 560, previewScale = 1.6},     -- picture is 504 x 560 stretched to 512 x 512
            {type = "ArrowOption", name = L["Theme"], description = L["Loot Theme Desc"], dbKey = "LootUI_Theme",
                requiredParentValueAnd = {LootUI = true},
                choices = {
                    {dbValue = 1, valueText = L["Theme Brown"]},
                    {dbValue = 2, valueText = L["Theme Dark"]},
                },
            },
            {type = "Checkbox", name = L["Fast Loot"], description = L["Fast Loot Desc"], dbKey = "FastLoot",
                requiredParentValueAnd = {LootUI = true}},
            {type = "ArrowOption", name = L["Font Size"], description = L["Loot UI Font Size Desc"], dbKey = "LootUI_FontSize",
                requiredParentValueAnd = {LootUI = true},
                choices = {
                    {dbValue = 0, valueText = "11"},
                    {dbValue = 1, valueText = "12"},
                    {dbValue = 2, valueText = "13"},
                    {dbValue = 3, valueText = "14"},
                    {dbValue = 4, valueText = "15"},
                    {dbValue = 5, valueText = "16"},
                    {dbValue = 6, valueText = "17"},
                    {dbValue = 7, valueText = "18"},
                },
            },
            {type = "ArrowOption", name = L["Fade Out Delay Per Item"], description = L["Fade Out Delay Per Item Desc"], dbKey = "LootUI_FadeDelayPerItem",
                requiredParentValueAnd = {LootUI = true},
                choices = {
                    {dbValue = 0.25, valueText = "0.25s"},
                    {dbValue = 0.5, valueText = "0.5s"},
                    {dbValue = 0.75, valueText = "0.75s"},
                    {dbValue = 1, valueText = "1s"},
                },
            },
            {type = "ArrowOption", name = L["Items Per Page"], description = L["Items Per Page Desc"], dbKey = "LootUI_ItemsPerPage",
                requiredParentValueAnd = {LootUI = true},
                choices = {
                    {dbValue = 5, valueText = "5"},
                    {dbValue = 6, valueText = "6"},
                    {dbValue = 7, valueText = "7"},
                    {dbValue = 8, valueText = "8"},
                },
            },
            {type = "ArrowOption", name = L["Opacity"], description = L["Loot UI Opacity Desc"], dbKey = "LootUI_BackgroundAlpha",
                requiredParentValueAnd = {LootUI = true},
                choices = {
                    {dbValue = 0, valueText = "0%"},
                    {dbValue = 0.1, valueText = "10%"},
                    {dbValue = 0.2, valueText = "20%"},
                    {dbValue = 0.3, valueText = "30%"},
                    {dbValue = 0.4, valueText = "40%"},
                    {dbValue = 0.5, valueText = "50%"},
                    {dbValue = 0.6, valueText = "60%"},
                    {dbValue = 0.7, valueText = "70%"},
                    {dbValue = 0.8, valueText = "80%"},
                    {dbValue = 0.9, valueText = "90%"},
                    {dbValue = 1, valueText = "100%"},
                },
            },
            {type = "Checkbox", name = L["Show Number Of Owned Items"], description = L["Show Number Of Owned Items Desc"], dbKey = "LootUI_ShowItemCount",
                requiredParentValueAnd = {LootUI = true}},
            {type = "Checkbox", name = L["Grow Upwards"], description = L["Grow Upwards On Desc"] .. "\n\n" .. L["Grow Upwards Off Desc"], tooltip = GrowUpwards_Tooltip,
                dbKey = "LootUI_GrowUpwards", requiredParentValueAnd = {LootUI = true}},
            {type = "Checkbox", name = L["Combine Similar Items"], description = L["Combine Similar Items Desc"], dbKey = "LootUI_CombineItem",
                requiredParentValueAnd = {LootUI = true}},
            {type = "Checkbox", name = L["Send to Back"], description = L["Send to Back Desc"], dbKey = "LootUI_LowFrameStrata",
                requiredParentValueAnd = {LootUI = true}},
            {type = "Checkbox", name = L["Loot Under Mouse"], description = L["Loot Under Mouse Desc"], dbKey = "LootUI_LootUnderMouse",
                requiredParentValueAnd = {LootUI = true}},
            {type = "Checkbox", name = L["Press Key To Take All Items"], description = L["Press Key To Take All Items Desc"], dbKey = "LootUI_UseHotkey",
                requiredParentValueAnd = {LootUI = true}},
            {type = "Keybinding", branchLevel = 2, name = L["Take All"], description = L["Press Key To Take All Items Desc"], dbKey = "LootUI_HotkeyName",
                defaultKey = "E", requiredParentValueAnd = {LootUI = true, LootUI_UseHotkey = true}},
            {type = "Custom", name = L["Move Position"], description = L["Move Position Desc"], icon = "Settings-Move.blp",
                onClickFunc = LootUI_Move_OnClick, isToggledFunc = LootUI_Move_IsToggled, requiredParentValueAnd = {LootUI = true}},
            {type = "Custom", name = L["Reset Position"], description = L["Quest Item Display Reset Position Desc"], icon = "Settings-Reset.blp",
                onClickFunc = LootUI_Reset_OnClick, validationFunc = LootUIPosition_Validation, requiredParentValueAnd = {LootUI = true}},
            {type = "Checkbox", name = L["Hide You Received Text"], description = L["Hide You Received Text Desc"], dbKey = "LootUI_HideTitle",
                requiredParentValueAnd = {LootUI = true}},
            {type = "Checkbox", name = L["Show Reputation Changes"], description = L["Show Reputation Changes Desc"], dbKey = "LootUI_ShowReputation",
                requiredParentValueAnd = {LootUI = true}},
            {type = "Checkbox", name = L["Show Any Money Changes"], description = L["Show Any Money Changes Desc"], dbKey = "LootUI_ShowAllMoneyChange",
                requiredParentValueAnd = {LootUI = true}},
            {type = "Checkbox", name = L["Show Any Currency Changes"], description = L["Show Any Currency Changes Desc"], dbKey = "LootUI_ShowAllCurrencyChange",
                requiredParentValueAnd = {LootUI = true}},
            -- Same states as in Other Addons, but not shown at all while the server has no transmog module.
            {type = "Checkbox", name = L["Show Transmog Status"], description = L["Show Transmog Status Desc"], tooltip = TransmogStatus_Tooltip,
                isDisabledFunc = TransmogStatus_IsDisabled, validationFunc = TransmogStatus_IsAvailable, dbKey = "LootUI_ShowTransmogStatus",
                preview = "Transmog", ratio = 511 / 484, requiredParentValueAnd = {LootUI = true}},
        },
    },
};

---------------------------------------------------------------------------
-- Keybinding rows (retail Settings_Keybinding.lua)
---------------------------------------------------------------------------

-- Retail listens with a keyboard frame (OnKeyDown, GLOBAL_MOUSE_DOWN). 3.3.5a keyboard frames do not stop a key from
-- also reaching the game (Space would jump), so while a key is being assigned every candidate key is an override
-- binding that clicks one hidden button with the key's name as the mouse button argument (SetOverrideBindingClick's
-- last parameter): the click tells which key was pressed and the key does nothing else. No GLOBAL_MOUSE_DOWN either:
-- a click away from the button is read with IsMouseButtonDown. Override bindings cannot change in combat, so
-- assigning is not started in combat.
local CAPTURE_NAME = "DialogueUI335KeyCapture";
local CAPTURE_KEYS = {
    "SPACE", "ENTER", "TAB", "BACKSPACE", "CAPSLOCK", "DELETE", "INSERT", "HOME", "END", "PAGEUP", "PAGEDOWN",
    "UP", "DOWN", "LEFT", "RIGHT",
    "NUMPADPLUS", "NUMPADMINUS", "NUMPADMULTIPLY", "NUMPADDIVIDE", "NUMPADDECIMAL",
    "`", "-", "=", "[", "]", "\\", ";", "'", ",", ".", "/",
};
for i = 0, 9 do
    CAPTURE_KEYS[#CAPTURE_KEYS + 1] = tostring(i);
    CAPTURE_KEYS[#CAPTURE_KEYS + 1] = "NUMPAD" .. i;
end
for i = 1, 12 do
    CAPTURE_KEYS[#CAPTURE_KEYS + 1] = "F" .. i;
end
for c = 65, 90 do
    CAPTURE_KEYS[#CAPTURE_KEYS + 1] = string.char(c);
end

local KeybindCapture = CreateFrame("Button", CAPTURE_NAME, UIParent);
addon.KeybindCapture = KeybindCapture;
KeybindCapture:SetWidth(1);
KeybindCapture:SetHeight(1);
KeybindCapture:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0);
KeybindCapture:RegisterForClicks("AnyUp");
KeybindCapture.active = false;

function KeybindCapture:IsActive()
    return self.active
end

-- The key row that is waiting for a key.
function KeybindCapture:Start(owner)
    if InCombatLockdown() then
        return false
    end
    self:Stop();
    self.active = true;
    self.owner = owner;
    -- The window's and the dialogue's keys are taken off first (Footer, SettingsUI:UpdateKeys), then ours are set.
    SettingsUI:UpdateKeys();
    CallbackRegistry:Trigger("KeyCaptureChanged");
    for _, key in ipairs(CAPTURE_KEYS) do
        SetOverrideBindingClick(self, true, key, CAPTURE_NAME, key);
    end
    self:SetScript("OnUpdate", self.OnUpdate);
    return true
end

function KeybindCapture:Stop()
    if not self.active then
        return
    end
    self.active = false;
    self:SetScript("OnUpdate", nil);
    if InCombatLockdown() then
        self.pendingClear = true;       -- cleared when combat ends (see the event below)
    else
        ClearOverrideBindings(self);
    end
    local owner = self.owner;
    self.owner = nil;
    if owner then
        owner:SetKeybindingMode(false);
    end
    SettingsUI:UpdateKeys();
    CallbackRegistry:Trigger("KeyCaptureChanged");
end

KeybindCapture:SetScript("OnClick", function(self, key)
    if not self.active or not self.owner then
        return
    end
    local owner = self.owner;
    if not addon.BindingUtil:IsKeyInvalid(key) then
        if owner.dbKey then
            SetDBValue(owner.dbKey, key, true);
        elseif owner.action then
            addon.BindingUtil:CheckAndSetBindingKey(owner.action, key, true);
        end
    end
    self:Stop();
end);

-- A click away from the row cancels. The row hiding (tab change, window closed, scrolled) is handled where it happens.
function KeybindCapture:OnUpdate()
    local owner = self.owner;
    if not owner or not owner:IsVisible() then
        self:Stop();
    elseif (IsMouseButtonDown("LeftButton") or IsMouseButtonDown("RightButton")) and not owner:IsMouseOver() then
        self:Stop();
    end
end
KeybindCapture:SetScript("OnUpdate", nil);

KeybindCapture:RegisterEvent("PLAYER_REGEN_ENABLED");
KeybindCapture:RegisterEvent("PLAYER_REGEN_DISABLED");
KeybindCapture:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_REGEN_DISABLED" then
        -- Cannot change the override bindings any more, so give up the assignment at once.
        if self.active then
            self.active = false;
            self:SetScript("OnUpdate", nil);
            self.pendingClear = true;
            local owner = self.owner;
            self.owner = nil;
            if owner then
                owner:SetKeybindingMode(false);
            end
        end
    elseif self.pendingClear then
        self.pendingClear = nil;
        ClearOverrideBindings(self);
        SettingsUI:UpdateKeys();
        CallbackRegistry:Trigger("KeyCaptureChanged");
    end
end);

CallbackRegistry:Register("SettingsUI.Hide", function() KeybindCapture:Stop(); end);
CallbackRegistry:Register("SettingsUI.TabChanged", function() KeybindCapture:Stop(); end);

-- Retail's 144 x 24 key button: a 192 x 192 sheet with 8 rows of 24, the left 3/4 used. Row 1 normal, 2 hover, 3 waiting
-- for a key (rows 4 / 5 are unused). Text colors by state and theme as retail.
local KEYBIND_FILE = "Settings-Keybinding.blp";
local KEYBIND_WIDTH = 6 * OPTION_WIDGET_SIZE;
local KEYBIND_ROWS = {
    normal = {0, 0.125},
    hover = {0.125, 0.25},
    binding = {0.375, 0.5},
};

local function CreateKeybinding(row, optionData)
    local widget = CreateFrame("Button", nil, row.content);
    widget:SetWidth(KEYBIND_WIDTH);
    widget:SetHeight(OPTION_WIDGET_SIZE);
    widget:SetPoint("RIGHT", row.content, "RIGHT", -BUTTON_PADDING_LARGE, 0);
    widget:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    widget.action = optionData.action;
    widget.dbKey = optionData.dbKey;            -- a key saved as a setting of its own (Loot UI: Take All), not a dialogue action

    local background = widget:CreateTexture(nil, "ARTWORK");
    background:SetAllPoints(widget);
    ThemeUtil:BindTexture(background, KEYBIND_FILE);

    local valueText = widget:CreateFontString(nil, "OVERLAY");
    valueText:SetFontObject(FontUtil:GetQuestFont("DUI335_SettingsValue", FONT_HEIGHT, { "DarkBrown", "DarkModeGrey90" }));
    valueText:SetJustifyH("CENTER");
    valueText:SetWidth(120);
    valueText:SetPoint("CENTER", widget, "CENTER", 0, 2);
    widget.valueText = valueText;

    -- state: "normal", "hover", "binding"
    function widget:SetButtonState(state)
        self.state = state;
        local rows = KEYBIND_ROWS[state];
        background:SetTexCoord(0, 0.75, rows[1], rows[2]);
        local colorKey;
        if ThemeUtil:IsDarkMode() then
            colorKey = "DarkModeGold";
        elseif state == "binding" then
            colorKey = "Ivory";
        else
            colorKey = "DarkBrown";
        end
        valueText:SetTextColor(ThemeUtil:GetColor(colorKey));
    end

    function widget:Refresh()
        local key;
        if self.dbKey then
            key = GetDBValue(self.dbKey);
        else
            key = addon.BindingUtil:GetBindingKey(self.action);
        end
        valueText:SetText(key or L["Not Bound"]);
        self:SetButtonState(self.isBinding and "binding" or (self:IsMouseOver() and "hover" or "normal"));
    end

    -- Called by KeybindCapture:Stop as well.
    function widget:SetKeybindingMode(state)
        self.isBinding = state;
        self:Refresh();
    end

    widget:SetScript("OnEnter", function(self)
        row:OnEnter();
        if not self.isBinding then
            self:SetButtonState("hover");
        end
    end);
    widget:SetScript("OnLeave", function(self)
        row:OnLeave();
        if not self.isBinding then
            self:SetButtonState("normal");
        end
    end);
    widget:SetScript("OnMouseDown", function(self)
        valueText:SetPoint("CENTER", self, "CENTER", 0, 1);
    end);
    widget:SetScript("OnMouseUp", function(self)
        valueText:SetPoint("CENTER", self, "CENTER", 0, 2);
    end);
    widget:SetScript("OnClick", function(self, button)
        if not IsPointerInList() then
            return
        end
        PlaySound("igMainMenuOptionCheckBoxOn");
        if button == "LeftButton" then
            if self.isBinding then
                KeybindCapture:Stop();
            elseif KeybindCapture:Start(self) then
                self:SetKeybindingMode(true);
            end
        else    -- RightButton: back to the default key
            KeybindCapture:Stop();
            if self.dbKey then
                SetDBValue(self.dbKey, optionData.defaultKey, true);
            else
                addon.BindingUtil:CheckAndSetBindingKey(self.action, nil, true);
            end
        end
    end);
    widget:SetScript("OnHide", function(self)
        if self.isBinding then
            KeybindCapture:Stop();
        end
    end);

    CallbackRegistry:Register("ThemeChanged", function()
        widget:Refresh();
    end);
    if widget.dbKey then
        CallbackRegistry:Register("SettingChanged." .. widget.dbKey, function()
            widget:Refresh();
        end);
    end

    return widget
end

-- A key changed (here or by Use Custom Bindings): the key texts and the description under the pointer follow.
CallbackRegistry:Register("CustomBindingChanged", function()
    if not frame then
        return
    end
    local rows = frame.rows[2];
    for i = 1, #rows do
        local widget = rows[i].widget;
        if widget and widget.action then
            widget:Refresh();
        end
    end
    if frame:IsShown() then
        SettingsUI:RefreshHover();
    end
end);

-- One arrow of the arrow option. The 128x128 sheet holds the arrow (top left) and its hover glow (top right),
-- drawn pointing right; the left arrow flips them.
local function CreateArrowButton(parent, delta)
    local button = CreateFrame("Button", nil, parent);
    button:SetWidth(ARROW_BUTTON_WIDTH);
    button:SetHeight(ARROW_BUTTON_HEIGHT);
    button:RegisterForClicks("LeftButtonUp");
    button.delta = delta;

    local arrow = button:CreateTexture(nil, "BACKGROUND");
    arrow:SetWidth(OPTION_WIDGET_SIZE);
    arrow:SetHeight(OPTION_WIDGET_SIZE);
    arrow:SetPoint("CENTER", button, "CENTER", 0, 0);
    ThemeUtil:BindTexture(arrow, ARROW_FILE);

    local glow = button:CreateTexture(nil, "OVERLAY");
    glow:SetAllPoints(arrow);
    glow:Hide();
    ThemeUtil:BindTexture(glow, ARROW_FILE);

    if delta < 0 then
        arrow:SetTexCoord(0.5, 0, 0, 0.5);
        glow:SetTexCoord(1, 0.5, 0, 0.5);
    else
        arrow:SetTexCoord(0, 0.5, 0, 0.5);
        glow:SetTexCoord(0.5, 1, 0, 0.5);
    end

    button.arrow = arrow;
    button.glow = glow;
    return button
end

-- "< value >" with one small bar per choice under the text. Arrows step through the choices (no wrap-around).
local function CreateArrowOption(row, optionData)
    local widget = CreateFrame("Frame", nil, row.content);
    widget:SetWidth(ARROWOPTION_WIDTH);
    widget:SetHeight(OPTION_WIDGET_SIZE);
    widget:SetPoint("RIGHT", row.content, "RIGHT", -BUTTON_PADDING_LARGE, 0);

    widget.choices = optionData.choices;
    widget.dbKey = optionData.dbKey;
    local numChoices = #widget.choices;

    widget.valueText = widget:CreateFontString(nil, "OVERLAY");
    widget.valueText:SetFontObject(FontUtil:GetQuestFont("DUI335_SettingsValue", FONT_HEIGHT, { "DarkBrown", "DarkModeGrey90" }));
    widget.valueText:SetJustifyH("CENTER");
    widget.valueText:SetWidth(120);
    widget.valueText:SetPoint("TOP", widget, "TOP", 0, ARROWOPTION_VALUETEXT_OFFSET_Y);

    widget.leftArrow = CreateArrowButton(widget, -1);
    widget.leftArrow:SetPoint("LEFT", widget, "LEFT", 0, 0);
    widget.rightArrow = CreateArrowButton(widget, 1);
    widget.rightArrow:SetPoint("RIGHT", widget, "RIGHT", 0, 0);

    for _, button in ipairs({ widget.leftArrow, widget.rightArrow }) do
        button:SetScript("OnEnter", function(self)
            self.glow:Show();
            row:OnEnter();
        end);
        button:SetScript("OnLeave", function(self)
            self.glow:Hide();
            row:OnLeave();
        end);
        button:SetScript("OnMouseDown", function(self)
            if self:IsEnabled() then
                self.arrow:SetPoint("CENTER", self, "CENTER", self.delta < 0 and -1 or 1, 0);
            end
        end);
        button:SetScript("OnMouseUp", function(self)
            self.arrow:SetPoint("CENTER", self, "CENTER", 0, 0);
        end);
        button:SetScript("OnClick", function(self)
            if not IsPointerInList() then
                return
            end
            widget:SelectByDelta(self.delta);
        end);
    end

    -- One bar per choice, from the arrow edge to the other arrow edge.
    widget.bars = {};
    local barGap = numChoices > 12 and 0.5 * ARROWOPTION_BAR_GAP or ARROWOPTION_BAR_GAP;     -- many choices: the bars keep some width
    local barWidth = (ARROWOPTION_WIDTH - 2 * ARROWOPTION_BAR_SHRINK - 2 * ARROW_BUTTON_WIDTH
        - (numChoices - 1) * barGap) / numChoices;
    for i = 1, numChoices do
        -- Retail: a 16x4 piece of the sheet (x 0-16, y 124-128), tiled slice with 1 texel margins.
        -- Its own frame, so the bar can be dimmed as a whole.
        local bar = CreateFrame("Frame", nil, widget);
        bar:SetWidth(barWidth);
        bar:SetHeight(ARROWOPTION_BAR_HEIGHT);
        bar:SetPoint("BOTTOMLEFT", widget, "BOTTOMLEFT",
            ARROW_BUTTON_WIDTH + ARROWOPTION_BAR_SHRINK + (barWidth + barGap) * (i - 1), 2);
        local slice = NineSlice:CreateTiled(bar, ThemeUtil:GetTextureFile(ARROW_FILE), { 16, 4 }, 1, BACKGROUND_SCALE,
            "OVERLAY", { 0, 124, 128, 128 });
        slice:Update(barWidth, ARROWOPTION_BAR_HEIGHT);
        ThemeUtil:BindSlice(slice, ARROW_FILE);
        widget.bars[i] = bar;
    end

    -- A single choice (Input Device: only Keyboard & Mouse in 3.3.5a) has nothing to step to: no arrows.
    if numChoices == 1 then
        widget.leftArrow:Hide();
        widget.rightArrow:Hide();
    end

    function widget:ShowChoice(id)
        self.selectedID = id;
        self.valueText:SetText(self.choices[id].valueText);
        local dimmed = ThemeUtil:IsDarkMode() and 0.5 or 0.2;
        for i, bar in ipairs(self.bars) do
            bar:SetAlpha(i == id and 1 or dimmed);
        end
        -- The ends are disabled instead of wrapping around.
        if id == 1 then
            self.leftArrow:Disable();
            self.leftArrow:SetAlpha(0.2);
        else
            self.leftArrow:Enable();
            self.leftArrow:SetAlpha(1);
        end
        if id == numChoices then
            self.rightArrow:Disable();
            self.rightArrow:SetAlpha(0.2);
        else
            self.rightArrow:Enable();
            self.rightArrow:SetAlpha(1);
        end
    end

    -- Shows the saved value.
    function widget:Refresh()
        local value;
        if optionData.getValueFunc then
            value = optionData.getValueFunc();      -- what is shown differs from what is saved
        else
            value = GetDBValue(self.dbKey);
        end
        local id = 1;
        for i, choice in ipairs(self.choices) do
            if choice.dbValue == value then
                id = i;
                break
            end
        end
        self:ShowChoice(id);
    end

    function widget:SelectByDelta(delta)
        local id = (self.selectedID or 1) + delta;
        if id < 1 or id > numChoices then
            return
        end
        self:ShowChoice(id);
        SetDBValue(self.dbKey, self.choices[id].dbValue, true);
        SettingsUI:LayoutRows(frame.tabID);     -- other options may depend on this one
        PlaySound("igMainMenuOptionCheckBoxOn");
        row:OnEnter();      -- the description may depend on the choice
    end

    -- Dark dims the bars less than Brown.
    CallbackRegistry:Register("ThemeChanged", function()
        if widget.selectedID then
            widget:ShowChoice(widget.selectedID);
        end
    end);

    return widget
end

-- Retail's dropdown button (DUIDialogSettingsDropdownButtonTemplate): 192 x 24, from a 512 x 256 sheet. The button is the
-- top row (the hover state a row below), the small arrow sits in the bottom left corner (shut, then open). Opens DropdownMenu.
local DROPDOWN_FILE = "Settings-DropdownButton.blp";
local DROPDOWN_WIDTH = 8 * OPTION_WIDGET_SIZE;
local DROPDOWN_ARROW_SIZE = 0.5 * OPTION_WIDGET_SIZE;
local DROPDOWN_PADDING = 8;
local DROPDOWN_MIN_TEXT_HEIGHT = 9;

local function CreateDropdownButton(row, optionData)
    local widget = CreateFrame("Button", nil, row.content);
    widget:SetWidth(DROPDOWN_WIDTH);
    widget:SetHeight(OPTION_WIDGET_SIZE);
    widget:SetPoint("RIGHT", row.content, "RIGHT", -BUTTON_PADDING_LARGE, 0);
    widget:SetHitRectInsets(0, 0, -4, -4);      -- as tall as an arrow option
    widget:RegisterForClicks("LeftButtonUp");
    widget.dbKey = optionData.dbKey;

    local background = widget:CreateTexture(nil, "ARTWORK");
    background:SetAllPoints(widget);
    background:SetTexCoord(0, 1, 0, 64 / 256);
    ThemeUtil:BindTexture(background, DROPDOWN_FILE);

    local arrow = widget:CreateTexture(nil, "OVERLAY");
    arrow:SetWidth(DROPDOWN_ARROW_SIZE);
    arrow:SetHeight(DROPDOWN_ARROW_SIZE);
    arrow:SetPoint("RIGHT", widget, "RIGHT", -DROPDOWN_PADDING, 0);
    arrow:SetTexCoord(0, 32 / 512, 224 / 256, 1);
    ThemeUtil:BindTexture(arrow, DROPDOWN_FILE);

    -- Retail's DUIFont_Quest_Quest: light text on the dark button.
    local valueFont = FontUtil:GetColoredFont("DUI335_SettingsTabSelected", FONT_HEIGHT, { "Ivory", "DarkModeGold" });
    local valueText = widget:CreateFontString(nil, "OVERLAY");
    valueText:SetFontObject(valueFont);
    valueText:SetJustifyH("LEFT");
    valueText:SetPoint("LEFT", widget, "LEFT", DROPDOWN_PADDING, 0);
    widget.valueText = valueText;

    -- A long name is made smaller until it fits (retail SetAutoScalingText), down to a minimum.
    local function SetValueText(text)
        valueText:SetFontObject(valueFont);
        valueText:SetText(text);
        local available = DROPDOWN_WIDTH - 2 * DROPDOWN_PADDING - DROPDOWN_ARROW_SIZE - 10;
        local file, _, flags = valueFont:GetFont();
        local height = FONT_HEIGHT;
        while valueText:GetStringWidth() > available and height > DROPDOWN_MIN_TEXT_HEIGHT do
            height = height - 1;
            valueText:SetFont(file, height, flags);
        end
    end

    -- Shows the saved choice. A saved value that is not on the list (the font's addon was removed) shows the first
    -- choice, the default, which is what is used then.
    function widget:Refresh()
        local choices = optionData.choices();
        local value = GetDBValue(self.dbKey);
        local name = choices[1] and choices[1].name or "-";
        for _, choice in ipairs(choices) do
            if choice.dbValue == value then
                name = choice.name;
                break
            end
        end
        SetValueText(name);
    end

    function widget:OnMenuClosed()
        arrow:SetTexCoord(0, 32 / 512, 224 / 256, 1);
    end

    -- Retail: the menu closes once the button is scrolled out of the list.
    function widget:IsInRange()
        local top, bottom = self:GetTop(), self:GetBottom();
        local listTop, listBottom = frame.list:GetTop(), frame.list:GetBottom();
        if top and bottom and listTop and listBottom then
            return top > listBottom and bottom < listTop
        end
        return true
    end

    function widget:ToggleMenu()
        if addon.DropdownMenu:IsOpenFor(self) then
            addon.DropdownMenu:Close();
            return
        end
        arrow:SetTexCoord(36 / 512, 68 / 512, 224 / 256, 1);
        addon.DropdownMenu:Open(self, frame, {
            choices = optionData.choices(),
            getFontFile = optionData.getChoiceFile,
            getSelected = function()
                return GetDBValue(self.dbKey)
            end,
            onSelect = function(dbValue)
                SetDBValue(self.dbKey, dbValue, true);
                self:Refresh();
                row:OnEnter();      -- the description may depend on the choice
            end,
        });
    end

    widget:SetScript("OnEnter", function()
        background:SetTexCoord(0, 1, 68 / 256, 132 / 256);
        row:OnEnter();
    end);
    widget:SetScript("OnLeave", function()
        background:SetTexCoord(0, 1, 0, 64 / 256);
        row:OnLeave();
    end);
    widget:SetScript("OnClick", function(self)
        if not IsPointerInList() then
            return
        end
        PlaySound("igMainMenuOptionCheckBoxOn");
        self:ToggleMenu();
    end);

    -- The name is fitted to the font and the colors of the theme.
    CallbackRegistry:Register("ThemeChanged", function()
        widget:Refresh();
    end);
    CallbackRegistry:Register("FontChanged", function()
        widget:Refresh();
    end);

    return widget
end

-- Retail's checkbox: a 24 px box from Settings-Checkbox (top left cell empty, top right cell ticked background) and
-- a 12 px tick on top (bottom left cell). Clicking anywhere on the row toggles it.
local CHECKBOX_FILE = "Settings-Checkbox.blp";

local function CreateCheckbox(row, optionData)
    local widget = CreateFrame("Frame", nil, row.content);
    widget:SetWidth(OPTION_WIDGET_SIZE);
    widget:SetHeight(OPTION_WIDGET_SIZE);
    widget:SetPoint("RIGHT", row.content, "RIGHT", -BUTTON_PADDING_LARGE, 0);
    widget.dbKey = optionData.dbKey;

    -- Optional cvarFunc: the option is a game CVar (Blizzard's own setting), not a saved variable of ours.
    local function GetValue()
        if optionData.cvarFunc then
            local ok, value = pcall(GetCVar, optionData.cvarFunc());
            return ok and value == "1"
        end
        return GetDBValue(widget.dbKey) == true
    end
    local function SetValue(state)
        if optionData.cvarFunc then
            pcall(SetCVar, optionData.cvarFunc(), state and "1" or "0");
        else
            SetDBValue(widget.dbKey, state, true);
        end
    end

    local background = widget:CreateTexture(nil, "BACKGROUND");
    background:SetAllPoints(widget);
    ThemeUtil:BindTexture(background, CHECKBOX_FILE);

    local check = widget:CreateTexture(nil, "OVERLAY");
    check:SetWidth(OPTION_WIDGET_SIZE * 0.5);
    check:SetHeight(OPTION_WIDGET_SIZE * 0.5);
    check:SetPoint("CENTER", widget, "CENTER", 0, 0);
    ThemeUtil:BindTexture(check, CHECKBOX_FILE);
    check:SetTexCoord(0.0625, 0.4375, 0.5625, 0.9375);

    function widget:SetChecked(state)
        self.checked = state;
        if state then
            background:SetTexCoord(0.5, 1, 0, 0.5);
            check:Show();
        else
            background:SetTexCoord(0, 0.5, 0, 0.5);
            check:Hide();
        end
    end

    -- Optional isDisabledFunc (e.g. a required addon is missing): unchecked, dimmed, and a click calls onDisabledClick.
    local function IsDisabled()
        return optionData.isDisabledFunc and optionData.isDisabledFunc()
    end

    -- Optional copyLink: a copy icon right after the label while the option is disabled. 3.3.5a cannot write to the
    -- clipboard, so it opens the Clipboard window with the link selected, ready for Ctrl+C.
    local copyButton;
    if optionData.copyLink then
        copyButton = addon.CreateCopyTextButton(row.content, function(self)
            if not addon.Clipboard:CloseIfFromSameSender(self) then
                addon.Clipboard:ShowContent(optionData.copyLink, self, true, 360, 40);
            end
        end, ThemeUtil:GetThemeID(), L["Click To Copy To Clipboard"]);
        copyButton:SetPoint("LEFT", row.label, "RIGHT", 4, 0);
        copyButton:Hide();
        copyButton:HookScript("OnEnter", function() row:OnEnter(); end);      -- keep the row's description while on the icon
        CallbackRegistry:Register("ThemeChanged", function(themeID)
            copyButton:SetTheme(themeID);
        end);
    end

    function widget:Refresh()
        if copyButton then
            if IsDisabled() then
                copyButton:Show();
            else
                copyButton:Hide();
            end
        end
        if IsDisabled() then
            -- Usually unchecked; keepValueWhenDisabled shows the saved choice, dimmed.
            self:SetChecked(optionData.keepValueWhenDisabled and GetValue() or false);
            self:SetAlpha(0.4);
            row.label:SetAlpha(0.5);
        else
            self:SetChecked(GetValue());
            self:SetAlpha(1);
            row.label:SetAlpha(1);
        end
    end

    function widget:Toggle()
        self:SetChecked(not self.checked);
        SetValue(self.checked);
        SettingsUI:RefreshTab(frame.tabID);     -- sub-options may depend on this one (shown / hidden / greyed out)
        PlaySound(self.checked and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff");
        row:OnEnter();
    end

    row:RegisterForClicks("LeftButtonUp");
    row:SetScript("OnClick", function()
        if IsPointerInList() then
            if IsDisabled() then
                if optionData.onDisabledClick then
                    PlaySound("igMainMenuOptionCheckBoxOn");
                    optionData.onDisabledClick();
                end
            else
                widget:Toggle();
            end
        end
    end);

    return widget
end

local OptionLabelFont;
local SubheaderFont;

-- Retail SetSubheader: the label is upper case in the "disabled" font on a LabelBackground plate (3 x font height
-- high, text width + 2.2 x font height wide, at least as wide as high). The plate is 204 x 54 texels of a 256 x 64
-- file with margins 24 / 24 / 24 / 16 (stretched). 24 + 16 is more than the 36 drawn height, so the margins are
-- scaled down to fit (as the retail slice does).
local LABEL_BG_FILE = "LabelBackground.blp";
local LABEL_BG_TEX = { 256, 64 };
local LABEL_BG_REGION = { 204, 54 };
local LABEL_BG_MARGINS = { 24, 24, 24, 16 };       -- left, right, top, bottom
local SUBHEADER_WIDTH = 70;                      -- plate size (retail: 3 x font height high, text width + 2.2 x font height wide)
local SUBHEADER_HEIGHT = 45;


local function CreateSubheaderBackground(row, label, extraWidth)
    local height = SUBHEADER_HEIGHT;
    -- Wider than retail's text + 2.2 x font height: the texture has a transparent rim, so the visible plate is narrower.
    local textWidth = label:GetStringWidth();
    local width = max(SUBHEADER_WIDTH, textWidth + FONT_HEIGHT) + (extraWidth or 0);     -- extraWidth: per-row option

    local plate = CreateFrame("Frame", nil, row);
    plate:SetFrameLevel(row:GetFrameLevel() + 1);
    plate:SetWidth(width);
    plate:SetHeight(height);
    plate:SetPoint("LEFT", label, "LEFT", -FONT_HEIGHT, 0);     -- retail: one font height left of the label; the label keeps the normal option text offset

    local left, right, top, bottom = unpack(LABEL_BG_MARGINS);
    local s = min(1, height / (top + bottom));
    local pieces = NineSlice:CreateEdges(plate, ThemeUtil:GetTextureFile(LABEL_BG_FILE), LABEL_BG_TEX,
        left * s, right * s, top * s, bottom * s, "BACKGROUND");

    -- CreateEdges maps the whole file; the plate is only the top left 204 x 54 region of it.
    local rw, rh = LABEL_BG_REGION[1], LABEL_BG_REGION[2];
    local us = { 0, left / rw, 1 - right / rw, 1 };
    local vs = { 0, top / rh, 1 - bottom / rh, 1 };
    local uMax, vMax = rw / LABEL_BG_TEX[1], rh / LABEL_BG_TEX[2];
    for rowIndex = 1, 3 do
        for col = 1, 3 do
            pieces[(rowIndex - 1) * 3 + col]:SetTexCoord(us[col] * uMax, us[col + 1] * uMax, vs[rowIndex] * vMax, vs[rowIndex + 1] * vMax);
        end
    end
    ThemeUtil:BindSlice(pieces, LABEL_BG_FILE);
end

-- A row of the option list: label on the left, the option widget on the right, hover glow behind both.
local function CreateOptionRow(page, index, optionData)
    local row = CreateFrame("Button", nil, page);
    row:SetWidth(OPTIONBUTTON_WIDTH);
    row:SetHeight(OPTION_ROW_HEIGHT);
    row:SetPoint("TOPLEFT", page, "TOPLEFT", 0, -(index - 1) * OPTION_ROW_HEIGHT);
    row.optionData = optionData;

    -- Label and widget live one level above the row, so the hover glow (row level + 1) is under them.
    local content = CreateFrame("Frame", nil, row);
    content:SetAllPoints(row);
    content:SetFrameLevel(row:GetFrameLevel() + 2);
    row.content = content;

    local label = content:CreateFontString(nil, "OVERLAY");
    label:SetFontObject(optionData.type == "Subheader" and SubheaderFont or OptionLabelFont);
    label:SetJustifyH("LEFT");
    label:SetPoint("LEFT", content, "LEFT", OPTION_LABEL_OFFSET, 0);
    label:SetText(optionData.type == "Subheader" and upper(optionData.name) or optionData.name);
    row.label = label;

    if optionData.type == "Subheader" then
        -- Not an option: no hover glow, no click, and the description area stays empty (retail).
        row.isSubheader = true;
        CreateSubheaderBackground(row, label, optionData.extraWidth);
        row:SetScript("OnEnter", function() SettingsUI:SetDescription(nil) end);
        row:SetScript("OnLeave", nil);
        ForwardDrag(row);
        return row
    end

    function row:OnEnter()
        if not IsPointerInList() then
            return
        end
        SettingsUI:HighlightButton(self, 1);
        -- Retail's optional `tooltip` function gives the description of the current choice.
        local data = self.optionData;
        local text = data.tooltip and data.tooltip() or data.description;
        SettingsUI:SetDescription(text, data);
    end
    function row:OnLeave()
        SettingsUI:HighlightButton(nil);
        SettingsUI:SetDescription(nil);
    end
    row:SetScript("OnEnter", row.OnEnter);
    row:SetScript("OnLeave", row.OnLeave);
    ForwardDrag(row);

    if optionData.type == "ArrowOption" then
        row.widget = CreateArrowOption(row, optionData);
    elseif optionData.type == "Checkbox" then
        row.widget = CreateCheckbox(row, optionData);
    elseif optionData.type == "Keybinding" then
        row.widget = CreateKeybinding(row, optionData);
    elseif optionData.type == "DropdownButton" then
        row.widget = CreateDropdownButton(row, optionData);
    end

    -- Retail: a branch mark in front of the label when the option depends on another one (branchLevel steps in,
    -- default 1, 0 = no mark), then an optional icon.
    do
        local nameOffset = OPTION_LABEL_OFFSET;
        if optionData.requiredParentValueAnd and optionData.branchLevel ~= 0 then
            local branchSize = OPTIONBUTTON_HEIGHT * 0.5;
            nameOffset = OPTION_LABEL_OFFSET + (optionData.branchLevel or 1) * (branchSize * 0.5 + 10);
            local branch = content:CreateTexture(nil, "ARTWORK");
            branch:SetWidth(branchSize);
            branch:SetHeight(branchSize);
            branch:SetPoint("BOTTOMRIGHT", content, "LEFT", nameOffset - 8, 0);
            ThemeUtil:BindTexture(branch, "Settings-SubOptionIcon.blp");
            branch:SetVertexColor(1, 1, 1, 0.5);
        end
        if optionData.icon then
            local icon = content:CreateTexture(nil, "ARTWORK");
            icon:SetWidth(OPTION_WIDGET_SIZE);
            icon:SetHeight(OPTION_WIDGET_SIZE);
            icon:SetPoint("LEFT", content, "LEFT", nameOffset - 0.125 * OPTION_WIDGET_SIZE, 0);
            ThemeUtil:BindTexture(icon, optionData.icon);
            nameOffset = nameOffset + OPTION_WIDGET_SIZE;
        end
        label:ClearAllPoints();
        label:SetPoint("LEFT", content, "LEFT", nameOffset, 0);
    end

    if optionData.type == "Custom" then
        -- A plain button row (the whole row is the button).
        row:RegisterForClicks("LeftButtonUp");
        row:SetScript("OnClick", function(self)
            if not IsPointerInList() then
                return
            end
            PlaySound("igMainMenuOptionCheckBoxOn");
            if optionData.onClickFunc then
                optionData.onClickFunc(self);
            end
            SettingsUI:LayoutRows(frame.tabID);     -- Reset hides itself once there is nothing to reset
            if self:IsShown() then
                self:OnEnter();
            else
                SettingsUI:HighlightButton(nil);
                SettingsUI:SetDescription(nil);
            end
        end);

        -- A toggle row (Move) keeps the hover glow while it is on. Same glow as the hover, under the label.
        if optionData.isToggledFunc then
            local toggleFrame = CreateFrame("Frame", nil, row);
            toggleFrame:SetAllPoints(row);
            toggleFrame:SetFrameLevel(row:GetFrameLevel() + 1);
            toggleFrame:Hide();
            local slice = NineSlice:CreateTiled(toggleFrame, ThemeUtil:GetTextureFile("Settings-ButtonHighlight.blp"),
                { 128, 64 }, 24, 1, "BACKGROUND");
            slice:Update(OPTIONBUTTON_WIDTH, OPTION_ROW_HEIGHT);
            ThemeUtil:BindSlice(slice, "Settings-ButtonHighlight.blp");
            row.toggleFrame = toggleFrame;
        end
    end

    return row
end

-- Shows the glow on toggle rows that are on. The hover glow skips them meanwhile (isSelected), so it is not doubled.
function SettingsUI:RefreshToggles()
    local rows = frame.rows[frame.tabID];
    for i = 1, #rows do
        local row = rows[i];
        if row.toggleFrame then
            local on = row:IsShown() and row.optionData.isToggledFunc() and true or false;
            row.isSelected = on;
            if on then
                row.toggleFrame:Show();
                if frame.highlightFrame:IsShown() then
                    self:HighlightButton(nil);
                end
            else
                row.toggleFrame:Hide();
            end
        end
    end
end

---------------------------------------------------------------------------
-- Scrolling (retail ScrollFrameMixin: view size, content height -> scroll range, offset in units from the top)
---------------------------------------------------------------------------

function ScrollFrameMixin:SetViewSize(height)
    self.viewSize = height;
end

function ScrollFrameMixin:GetViewSize()
    return self.viewSize or 0
end

-- Negative range: everything fits, the scroll bar hides and the vertical divider is back.
function ScrollFrameMixin:SetScrollRange(range)
    if range < 0 then
        range = 0;
    end
    self.maxScrollOffset = range;
    if range > 0 then
        frame.verticalDivider:Hide();
    else
        frame.verticalDivider:Show();
    end
    self.scrollBar:UpdateThumbSize();     -- shows or hides the bar
end

function ScrollFrameMixin:GetScrollRange()
    return self.maxScrollOffset or 0
end

function ScrollFrameMixin:SetContentHeight(contentHeight)
    self.scrollChild:SetHeight(max(contentHeight, self:GetViewSize()));
    self:SetScrollRange(contentHeight - self:GetViewSize());
end

function ScrollFrameMixin:GetScrollOffset()
    return self.scrollOffset or 0
end

function ScrollFrameMixin:SetScrollOffset(scrollOffset)
    scrollOffset = API.Clamp(scrollOffset, 0, self:GetScrollRange());
    if scrollOffset ~= self.scrollOffset then
        self.scrollOffset = scrollOffset;
        self:SetVerticalScroll(scrollOffset);
        self.scrollBar:UpdateThumbPosition();
        SettingsUI:QueueHoverRefresh();
    end
end

function ScrollFrameMixin:ScrollBy(offset)
    self:SetScrollOffset(self:GetScrollOffset() + offset);
end

function ScrollFrameMixin:OnMouseWheel(delta)
    KeybindCapture:Stop();      -- retail: scrolling cancels a key assignment
    if delta > 0 then
        self:ScrollBy(-OPTIONBUTTON_HEIGHT);
    else
        self:ScrollBy(OPTIONBUTTON_HEIGHT);
    end
end

-- The row under the cursor changes when the list scrolls without the mouse moving. The rows' new positions are
-- known a frame later, so the hover is re-evaluated in the next OnUpdate.
local function HoverRefresh_OnUpdate(self)
    self:SetScript("OnUpdate", nil);
    SettingsUI:RefreshHover();
end

function SettingsUI:QueueHoverRefresh()
    frame.list:SetScript("OnUpdate", HoverRefresh_OnUpdate);
end

function SettingsUI:RefreshHover()
    if not IsPointerInList() then
        return
    end
    local rows = frame.rows[frame.tabID];
    for i = 1, #rows do
        local row = rows[i];
        if row:IsShown() and row:IsMouseOver() then
            row:GetScript("OnEnter")(row);
            return
        end
    end
    self:HighlightButton(nil);
    self:SetDescription(nil);
end

-- Shows the rows whose requirements are met, stacked from the top.
function SettingsUI:LayoutRows(tabID)
    local rows = frame.rows[tabID];
    local page = frame.pages[tabID];
    local shown = 0;
    for i = 1, #rows do
        local row = rows[i];
        if IsOptionValid(row.optionData) then
            shown = shown + 1;
            row:ClearAllPoints();
            row:SetPoint("TOPLEFT", page, "TOPLEFT", 0, -(shown - 1) * OPTION_ROW_HEIGHT);
            row:Show();
        else
            row:Hide();
        end
    end
    self:RefreshToggles();
    -- Rows may have appeared or gone: the scroll range follows (the offset is clamped to it).
    if tabID == frame.tabID then
        frame.list:SetContentHeight(shown * OPTION_ROW_HEIGHT);
        frame.list:SetScrollOffset(frame.list:GetScrollOffset());
    end
end

function SettingsUI:RefreshTab(tabID)
    self:LayoutRows(tabID);
    local rows = frame.rows[tabID];
    for i = 1, #rows do
        if rows[i].widget then
            rows[i].widget:Refresh();
        end
    end
end


---------------------------------------------------------------------------
-- Frame
---------------------------------------------------------------------------

local function CreateSettingsFrame()
    -- Normal: on paper (retail DUIFont_Quest_Gossip). Selected: on the dark plate (DUIFont_Quest_Quest).
    NormalTabFont = FontUtil:GetQuestFont("DUI335_SettingsTab", FONT_HEIGHT, { "DarkBrown", "DarkModeGoldDim" });
    SelectedTabFont = FontUtil:GetColoredFont("DUI335_SettingsTabSelected", FONT_HEIGHT, { "Ivory", "DarkModeGold" });
    OptionLabelFont = FontUtil:GetQuestFont("DUI335_SettingsDescription", FONT_HEIGHT, { "DarkBrown", "DarkModeGrey70" });
    SubheaderFont = FontUtil:GetQuestFont("DUI335_SettingsSubheader", FONT_HEIGHT, { "LightBrown", "DarkModeGrey50" });     -- retail DUIFont_Settings_Disabled

    local f =CreateFrame("Frame", "DialogueUI335Settings", addon.UIRoot);
    frame = f;
    f:SetFrameStrata("DIALOG");
    f:SetToplevel(true);
    f:EnableMouse(true);
    f:SetMovable(true);
    f:SetClampedToScreen(true);
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
    f:Hide();
    ForwardDrag(f);

    -- Retail geometry: the option list is OPTIONBUTTON_WIDTH wide and 10.5 rows tall, the frame width puts the
    -- list and the description area in the golden ratio.
    local listWidth = OPTIONBUTTON_WIDTH;
    local listHeight = NUM_VISIBLE_OPTIONS * OPTIONBUTTON_HEIGHT;
    local frameWidth = Round((listWidth + 1.5 * FRAME_PADDING) / 0.618);
    local frameHeight = FRAME_PADDING + TAB_HEIGHT + GAP_TO_HEADER + listHeight + FRAME_PADDING;
    local rightAreaWidth = Round(frameWidth - listWidth - 2 * FRAME_PADDING);
    local descriptionWidth = Round(frameWidth - listWidth - 3 * FRAME_PADDING - BUTTON_PADDING_LARGE);
    f:SetWidth(frameWidth);
    f:SetHeight(frameHeight);

    local baseLevel = f:GetFrameLevel();

    -- Background with the drop shadow outside the frame edge.
    local background = CreateFrame("Frame", nil, f);
    background:SetFrameLevel(baseLevel);
    background:SetPoint("TOPLEFT", f, "TOPLEFT", -BACKGROUND_SHADOW, BACKGROUND_SHADOW);
    background:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", BACKGROUND_SHADOW, -BACKGROUND_SHADOW);
    f.backgroundSlice = NineSlice:CreateTiled(background, ThemeUtil:GetTextureFile("GenericFrame-Tiled-Large.blp"),
        { 512, 512 }, 80, BACKGROUND_SCALE, "BACKGROUND");
    ThemeUtil:BindSlice(f.backgroundSlice, "GenericFrame-Tiled-Large.blp");

    -- Retail draws this texture pixel-perfect (1 texel = 1 screen pixel). Fixed 0.75 units land on fractional
    -- pixels and blur, so the texel size is recomputed from the real resolution and UI scale each time it shows.
    local function UpdateBackgroundScale()
        local _, physHeight = string.match(GetCVar("gxResolution") or "", "(%d+)x(%d+)");
        physHeight = tonumber(physHeight);
        local effScale = f:GetEffectiveScale();
        local texel = BACKGROUND_SCALE;
        if physHeight and physHeight > 0 and effScale and effScale > 0 then
            texel = 768 / physHeight / effScale;
        end
        local shadow = 16 * texel;
        background:ClearAllPoints();
        background:SetPoint("TOPLEFT", f, "TOPLEFT", -shadow, shadow);
        background:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", shadow, -shadow);
        local slice = f.backgroundSlice;
        slice.scale = texel;
        slice.width = nil;                      -- force a re-layout
        slice:Update(frameWidth + 2 * shadow, frameHeight + 2 * shadow);
    end
    f.UpdateBackgroundScale = UpdateBackgroundScale;
    UpdateBackgroundScale();

    -- Dividers and description sit on one frame above the background.
    local content = CreateFrame("Frame", nil, f);
    content:SetFrameLevel(baseLevel + 1);
    content:SetAllPoints(f);
    f.content = content;

    -- Header: tab buttons on the left, close button on the right.
    local header = CreateFrame("Frame", nil, f);
    header:SetFrameLevel(baseLevel + 2);
    header:SetPoint("TOPLEFT", f, "TOPLEFT", FRAME_PADDING, -FRAME_PADDING);
    header:SetPoint("TOPRIGHT", f, "TOPRIGHT", -FRAME_PADDING, -FRAME_PADDING);
    header:SetHeight(TAB_HEIGHT);
    f.header = header;

    -- Dark plate behind the selected tab. Its own frame so it stays under the tab text.
    local selectionFrame = CreateFrame("Frame", nil, header);
    selectionFrame:SetFrameLevel(baseLevel + 2);
    selectionFrame:Hide();
    f.selectionFrame = selectionFrame;
    f.selection = NineSlice:CreateTiled(selectionFrame, ThemeUtil:GetTextureFile("Settings-TabButton-Selection.blp"),
        { 128, 64 }, 16, SELECTION_SCALE, "BACKGROUND");
    ThemeUtil:BindSlice(f.selection, "Settings-TabButton-Selection.blp");

    -- Hover glow shared by the tab buttons.
    local highlightFrame = CreateFrame("Frame", nil, header);
    highlightFrame:Hide();
    f.highlightFrame = highlightFrame;
    f.highlight = NineSlice:CreateTiled(highlightFrame, ThemeUtil:GetTextureFile("Settings-ButtonHighlight.blp"),
        { 128, 64 }, 24, 1, "BACKGROUND");
    ThemeUtil:BindSlice(f.highlight, "Settings-ButtonHighlight.blp");

    f.closeButton = CreateCloseButton(header);
    f.closeButton:SetFrameLevel(baseLevel + 4);
    f.closeButton:SetPoint("RIGHT", header, "RIGHT", 0, 0);

    f.tabButtons = {};
    for i, entry in ipairs(TAB_ENTRIES) do
        local button = CreateTabButton(header, i, entry.name);
        button:SetFrameLevel(baseLevel + 4);
        if i == 1 then
            button:SetPoint("LEFT", header, "LEFT", 0, 0);
        else
            button:SetPoint("LEFT", f.tabButtons[i - 1], "RIGHT", TAB_BUTTON_GAP, 0);
        end
        f.tabButtons[i] = button;
    end
    f.tabAreaWidth = frameWidth - 2 * FRAME_PADDING - TAB_MIN_WIDTH - TAB_BUTTON_GAP;      -- left of the close button
    LayoutTabs(f.tabButtons, f.tabAreaWidth);

    -- Line under the header.
    f.headerDivider = CreateDivider(content, "Settings-Divider-H.blp", false);
    f.headerDivider:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -TAB_BUTTON_GAP);
    f.headerDivider:SetPoint("TOPRIGHT", header, "BOTTOMRIGHT", 0, -TAB_BUTTON_GAP);

    -- Option list (left). Retail's ScrollFrame clips its children; here it is a real ScrollFrame whose scroll child
    -- holds one page per tab. The scroll bar is made by Code\Scroll\Scroll_Bar.lua.
    local list = CreateFrame("ScrollFrame", nil, f);
    list:SetFrameLevel(baseLevel + 2);
    list:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -GAP_TO_HEADER);
    list:SetWidth(listWidth);
    list:SetHeight(listHeight);
    list:EnableMouseWheel(true);
    API.Mixin(list, ScrollFrameMixin);
    list:SetViewSize(listHeight);
    list:SetScript("OnMouseWheel", ScrollFrameMixin.OnMouseWheel);
    f.list = list;

    local scrollChild = CreateFrame("Frame", nil, list);
    scrollChild:SetWidth(listWidth);
    scrollChild:SetHeight(listHeight);
    list:SetScrollChild(scrollChild);
    list.scrollChild = scrollChild;

    f.pages = {};
    for i = 1, #TAB_ENTRIES do
        local page = CreateFrame("Frame", nil, scrollChild);
        page:SetAllPoints(scrollChild);
        page:Hide();
        f.pages[i] = page;
    end

    -- The option rows of every tab (the options do not change, so they are built once).
    f.rows = {};
    for i, tabData in ipairs(Schematic) do
        f.rows[i] = {};
        for j, optionData in ipairs(tabData.options) do
            f.rows[i][j] = CreateOptionRow(f.pages[i], j, optionData);
        end
    end

    -- Scroll bar: 4 right of the list (retail OPTIONBUTTON_FROM_Y). Only shown when the tab needs scrolling, and
    -- then it takes the place of the vertical divider.
    local scrollBar = addon.CreateScrollBar(f);
    scrollBar:SetFrameLevel(baseLevel + 3);
    scrollBar:SetPoint("TOPLEFT", list, "TOPRIGHT", 4, 0);
    scrollBar:SetOwner(list);
    scrollBar:Hide();
    list.scrollBar = scrollBar;
    f.scrollBar = scrollBar;

    -- Line between the list and the description. Retail anchors it to the scroll bar (bar center - 2 = list right + 8).
    f.verticalDivider = CreateDivider(content, "Settings-Divider-V.blp", true);
    f.verticalDivider:SetPoint("TOPLEFT", list, "TOPRIGHT", 8, 0);
    f.verticalDivider:SetPoint("BOTTOMLEFT", list, "BOTTOMRIGHT", 8, 0);

    -- Description (right). Preview picture slot first, text below it, as retail.
    local previewShrink = 1;
    local previewWidth = descriptionWidth - 2 * previewShrink;
    local preview = CreateFrame("Frame", nil, f);
    preview:SetFrameLevel(baseLevel + 2);
    preview:SetWidth(previewWidth);
    preview:SetHeight(0.5 * previewWidth);
    preview:SetPoint("TOP", f, "TOPRIGHT", -rightAreaWidth * 0.5 - previewShrink, -(TAB_HEIGHT + 2.5 * FRAME_PADDING));
    preview:Hide();                 -- shown by SetDescription for options that have a picture
    f.preview = preview;
    f.previewHeight = 0.5 * previewWidth;
    f.previewFullWidth = previewWidth;
    f.previewTexture = preview:CreateTexture(nil, "ARTWORK");
    f.previewTexture:SetAllPoints(preview);

    -- Border 1 px outside the picture (retail PreviewBorder: tiled, margin 8). Retail scales the slice by
    -- 768 / screen height (API.UpdateTextureSliceScale), so one texel is one screen pixel: BACKGROUND_SCALE here
    -- (0.75 units per pixel, ~0.71 in retail at 1080p). Scale 1 made the border ~40% too thick.
    local borderFrame = CreateFrame("Frame", nil, preview);
    borderFrame:SetFrameLevel(preview:GetFrameLevel() + 1);
    borderFrame:SetPoint("TOPLEFT", preview, "TOPLEFT", -1, 1);
    borderFrame:SetPoint("BOTTOMRIGHT", preview, "BOTTOMRIGHT", 1, -1);
    f.previewBorder = NineSlice:CreateTiled(borderFrame, ThemeUtil:GetTextureFile("Settings-PreviewBorder.blp"),
        { 64, 64 }, 8, BACKGROUND_SCALE, "OVERLAY");
    ThemeUtil:BindSlice(f.previewBorder, "Settings-PreviewBorder.blp");

    -- The description is one text; a coloured part (|cAARRGGBB...|r, a warning) is its own text below the other parts
    -- because only a whole text can have an outline (see SetDescription).
    f.descriptionFont = FontUtil:GetQuestFont("DUI335_SettingsDescription", FONT_HEIGHT, { "DarkBrown", "DarkModeGrey70" });
    f.descriptionWidth = descriptionWidth;
    local description = content:CreateFontString(nil, "OVERLAY");
    description:SetFontObject(f.descriptionFont);
    description:SetJustifyH("LEFT");
    description:SetJustifyV("TOP");
    description:SetSpacing(4);
    description:SetWidth(descriptionWidth);
    description:SetPoint("TOP", preview, "TOP", 0, -8);
    f.description = description;
    f.descriptionParts = { description };

    -- Decor picture, bottom right (retail BackgroundDecor + DecorMask). 3.3.5a has no mask texture, so the picture
    -- is two textures that follow the description text: the body below the mask edge, a short fade band above it.
    local decorBody = content:CreateTexture(nil, "ARTWORK");
    decorBody:SetTexture(DECOR_FILE);
    local decorFade = content:CreateTexture(nil, "ARTWORK");
    decorFade:SetTexture(DECOR_FILE);
    f.decor = { body = decorBody, fade = decorFade, size = rightAreaWidth, frameHeight = frameHeight };
    CallbackRegistry:Register("ThemeChanged", function()
        SettingsUI:UpdateDecor();
    end);

    -- Keys while the window is open: Esc and F1 close it.
    f:SetScript("OnShow", function()
        f.UpdateBackgroundScale();
        SettingsUI:MoveToBestPosition(true);
        SettingsUI:RefreshTab(f.tabID);         -- a setting may have changed by other means (/run)
        SettingsUI:UpdateKeys();
        CallbackRegistry:Trigger("SettingsUI.Show");
    end);
    f:SetScript("OnHide", function()
        SettingsUI:UpdateKeys();
        CallbackRegistry:Trigger("SettingsUI.Hide");
    end);

    f.keysEvents = CreateFrame("Frame");
    f.keysEvents:RegisterEvent("PLAYER_REGEN_ENABLED");
    f.keysEvents:SetScript("OnEvent", function()
        if f.keysDirty then
            SettingsUI:UpdateKeys();
        end
    end);

    return f
end


---------------------------------------------------------------------------
-- Public
---------------------------------------------------------------------------

-- levelOffset: frame level of the glow relative to the button. Tabs: -1 (behind the tab, which has no art of its own),
-- option rows: +1 (above the row, under its label and widget).
function SettingsUI:HighlightButton(button, levelOffset)
    local f = frame;
    f.highlightFrame:Hide();
    f.highlightFrame:ClearAllPoints();
    -- The selected tab already has the dark plate.
    if button and not button.isSelected then
        -- Same parent as the button, so the glow of a row is clipped with the list.
        f.highlightFrame:SetParent(button:GetParent());
        f.highlightFrame:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0);
        f.highlightFrame:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0);
        f.highlightFrame:SetFrameLevel(button:GetFrameLevel() + (levelOffset or -1));
        f.highlight:Update(button:GetWidth(), button:GetHeight());
        f.highlightFrame:Show();
    end
end

function SettingsUI:SelectTab(tabID, silent)
    local f = frame;
    if tabID == f.tabID then
        return
    end
    if f.tabID then
        f["tabOffset" .. f.tabID] = f.list:GetScrollOffset();       -- each tab keeps its scroll position (retail)
    end
    f.tabID = tabID;
    f.list.scrollOffset = nil;                                      -- force the offset to be applied below

    for i, button in ipairs(f.tabButtons) do
        local selected = (i == tabID);
        Tab_SetSelected(button, selected);
        -- Frame:SetShown does not exist in 3.3.5a.
        if selected then
            f.pages[i]:Show();
        else
            f.pages[i]:Hide();
        end
        if selected then
            f.selectionFrame:ClearAllPoints();
            f.selectionFrame:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0);
            f.selectionFrame:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0);
            f.selectionFrame:SetFrameLevel(button:GetFrameLevel() - 1);
            f.selection:Update(button:GetWidth(), button:GetHeight());
            f.selectionFrame:Show();
        end
    end
    self:HighlightButton(nil);
    self:SetDescription(nil);
    self:RefreshTab(tabID);
    f.list:SetScrollOffset(f["tabOffset" .. tabID] or 0);
    CallbackRegistry:Trigger("SettingsUI.TabChanged", tabID);

    if not silent and f:IsVisible() then
        PlaySound("igMainMenuOptionCheckBoxOn");
    end
end

-- True while the window is open on the UI tab (the Custom orientation lets the parchment be dragged then).
-- True while the Loot UI tab is on screen (the loot window shows a preview then, see LootTest.lua).
function SettingsUI:IsOnLootUITab()
    return frame ~= nil and frame:IsShown() and frame.tabID == LOOT_UI_TAB
end

function SettingsUI:IsOnUITab()
    return frame:IsShown() and frame.tabID == 1
end

-- Loot UI tab: puts the window beside the loot window (left or right of it, whichever has room for it; the larger
-- side when neither has), centered in that space. onlyIfOverlap: leaves it alone when it does not cover the loot
-- window (the player may have moved it by hand). Returns false when the loot window is not to be avoided.
local LOOT_WINDOW_GAP = 16;

function SettingsUI:PlaceAwayFromLootWindow(force)
    local f = frame;
    local lootFrame = addon.LootUI and addon.LootUI.MainFrame;
    if not (f and lootFrame and lootFrame.GetHorizontalExtent) then
        return false
    end
    local screenWidth = UIParent:GetWidth();
    local width = f:GetWidth();
    local lootLeft, lootRight = lootFrame:GetHorizontalExtent();

    if not force and f:GetLeft() and f:GetRight() then
        if f:GetRight() <= lootLeft - LOOT_WINDOW_GAP / 2 or f:GetLeft() >= lootRight + LOOT_WINDOW_GAP / 2 then
            return true                 -- already clear of it
        end
    end

    local leftSpace = lootLeft - LOOT_WINDOW_GAP;
    local rightSpace = screenWidth - lootRight - LOOT_WINDOW_GAP;
    local centerX;
    if rightSpace >= width then
        centerX = lootRight + LOOT_WINDOW_GAP + rightSpace / 2;
    elseif leftSpace >= width then
        centerX = leftSpace / 2;
    elseif rightSpace >= leftSpace then
        centerX = screenWidth - width / 2;      -- no room on either side: as far from it as the screen allows
    else
        centerX = width / 2;
    end
    centerX = max(width / 2, min(screenWidth - width / 2, centerX));
    f:ClearAllPoints();
    f:SetPoint("CENTER", UIParent, "CENTER", centerX - screenWidth / 2, 0);
    return true
end

-- Retail: the window opens on the opposite side of the dialogue so both can be seen, centered when no dialogue is
-- up. Left orientation: window on the right. Right: on the left. Custom: not moved at all.
function SettingsUI:MoveToBestPosition(force)
    local f = frame;
    local parchment = addon.DialogueUI;
    local orientation = GetDBValue("FrameOrientation");

    -- Custom: the window stays wherever it is (the player moves both frames by hand).
    if orientation == ORIENTATION_CUSTOM then
        return
    end

    -- Loot UI tab: the loot window shows a preview, so the Settings go to the side of it that has room.
    if f.tabID == LOOT_UI_TAB and self:PlaceAwayFromLootWindow(force) then
        return
    end

    -- Readables: the window goes to the side of the book that has the room (the book is on the left by default).
    local book = addon.Book;
    local bookFrame = book and book:IsShown() and book:GetFrame();
    if bookFrame and bookFrame:GetLeft() and bookFrame:GetRight() and not (parchment and parchment:IsShown()) then
        local screenWidth = UIParent:GetWidth();
        local width = f:GetWidth();
        local gap = 16;
        local scale = bookFrame:GetEffectiveScale() / UIParent:GetEffectiveScale();
        local bookLeft, bookRight = bookFrame:GetLeft() * scale, bookFrame:GetRight() * scale;
        local centerX;
        if screenWidth - bookRight - gap >= width then
            centerX = bookRight + gap + (screenWidth - bookRight - gap) / 2;
        elseif bookLeft - gap >= width then
            centerX = (bookLeft - gap) / 2;
        elseif screenWidth - bookRight >= bookLeft then
            centerX = screenWidth - width / 2;
        else
            centerX = width / 2;
        end
        centerX = max(width / 2, min(screenWidth - width / 2, centerX));
        f:ClearAllPoints();
        f:SetPoint("CENTER", UIParent, "CENTER", centerX - screenWidth / 2, 0);
        return
    end

    f:ClearAllPoints();

    if parchment and parchment:IsShown() then
        local screenWidth = UIParent:GetWidth();
        local viewportWidth = min(screenWidth, UIParent:GetHeight() * 16/9);
        local offset = 0.5 * f:GetWidth() - 0.5 * viewportWidth + 16;      -- against the left edge of the viewport

        if orientation == 1 then
            offset = -offset;
        end
        f:SetPoint("CENTER", UIParent, "CENTER", offset, 0);
    else
        f:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
    end
end

local function MoveIfShown()
    if frame and frame:IsShown() then
        SettingsUI:MoveToBestPosition();
    end
end

-- The loot window was dropped somewhere else, or reset, or the tab changed: the Settings step aside if they are in the way.
local function AvoidLootWindowIfShown()
    if frame and frame:IsShown() and frame.tabID == LOOT_UI_TAB
        and GetDBValue("FrameOrientation") ~= ORIENTATION_CUSTOM then
        SettingsUI:PlaceAwayFromLootWindow(false);
    end
end
CallbackRegistry:Register("SettingChanged.LootUIPosition", AvoidLootWindowIfShown);
CallbackRegistry:Register("SettingChanged.LootUI_GrowUpwards", AvoidLootWindowIfShown);
CallbackRegistry:Register("SettingsUI.TabChanged", AvoidLootWindowIfShown);
CallbackRegistry:Register("SettingChanged.FrameOrientation", MoveIfShown);
CallbackRegistry:Register("ParchmentShown", MoveIfShown);       -- Left / Right: to the other side of the parchment
CallbackRegistry:Register("ParchmentHidden", MoveIfShown);      -- and back to the middle

-- Another font has other glyph widths: the tabs are as wide as their text again.
CallbackRegistry:Register("FontChanged", function()
    if not frame or not frame.tabButtons then
        return
    end
    LayoutTabs(frame.tabButtons, frame.tabAreaWidth);
    local selected = frame.tabButtons[frame.tabID];
    if selected then
        frame.selection:Update(selected:GetWidth(), selected:GetHeight());
    end
end);

-- The Other Addons tab asks the server which transmog module it has (the answer greys out the options of the missing one).
CallbackRegistry:Register("SettingsUI.TabChanged", function(tabID)
    if tabID == OTHER_ADDONS_TAB or tabID == LOOT_UI_TAB then
        addon.TransmogStatus:ProbePlus();
        addon.TransmogStatus:ProbeOriginal();
    end
end);
CallbackRegistry:Register("TransmogModuleChanged", function()
    if frame and frame:IsShown() and (frame.tabID == OTHER_ADDONS_TAB or frame.tabID == LOOT_UI_TAB) then
        SettingsUI:LayoutRows(frame.tabID);
    end
end);

-- The Valuable Reward Popup was dragged (or reset): same for its Reset row.
CallbackRegistry:Register("SettingChanged.QuickSlotPosition", function()
    if frame and frame:IsShown() and frame.tabID == 3 then
        SettingsUI:LayoutRows(3);
    end
end);

-- The Loot UI window was dragged (or reset): same for its Reset row.
CallbackRegistry:Register("SettingChanged.LootUIPosition", function()
    if frame and frame:IsShown() then
        SettingsUI:LayoutRows(frame.tabID);
    end
end);

-- The Quest Item Display was dragged (or reset): the Reset row appears (or goes) at once.
CallbackRegistry:Register("SettingChanged.QuestItemDisplayPosition", function()
    if frame and frame:IsShown() and frame.tabID == 3 then
        SettingsUI:LayoutRows(3);
    end
end);

-- optionData (optional): when it has `preview` (file name in Textures\PreviewPicture, no extension) and `ratio`
-- (1 square, 2 twice as wide as high) the picture is shown above the text, as retail.
function SettingsUI:SetDescription(text, optionData)
    local preview = frame.preview;
    local hasPreview = optionData and optionData.preview and true or false;

    if hasPreview then
        -- ratio = width / height of the picture as it should look (any number; wider than 2 uses the full width)
        local ratio = optionData.ratio or 2;
        -- previewScale (optional): the picture may be this many times higher than the usual slot (a tall picture)
        local width = math.min(frame.previewFullWidth, frame.previewHeight * (optionData.previewScale or 1) * ratio);
        local height = width / ratio;
        frame.currentPreviewHeight = height;
        preview:SetWidth(width);
        preview:SetHeight(height);
        frame.previewTexture:SetTexture(PREVIEW_PATH .. optionData.preview .. ".blp");
        frame.previewBorder:Update(width + 2, height + 2);
        preview:Show();
    else
        preview:Hide();
    end

    if hasPreview ~= frame.hasPreview then
        frame.hasPreview = hasPreview;
        frame.description:ClearAllPoints();
        if hasPreview then
            frame.description:SetPoint("TOP", preview, "BOTTOM", 0, -FRAME_PADDING);
        else
            frame.description:SetPoint("TOP", preview, "TOP", 0, -8);
        end
    end

    self:SetDescriptionParts(text or "");
    self:UpdateDecor();
end

-- Splits the text into plain parts and warning parts: red / orange (|cffff48.. or |cffff80..: |cffffGGBB with GG
-- below 90; the white highlight of a state is not one). The blank lines around a warning are left out (the parts are
-- put below each other with a gap).
local function SplitDescription(text)
    local list, position = {}, 1;
    local function Add(part, colored)
        part = part:gsub("^\n+", "");
        part = part:gsub("\n+$", "");
        if part ~= "" then
            list[#list + 1] = { text = part, colored = colored };
        end
    end
    while true do
        local first, last = text:find("|cffff[0-8]%x%x%x.-|r", position);
        if not first then
            break
        end
        Add(text:sub(position, first - 1), false);
        Add(text:sub(first, last), true);
        position = last + 1;
    end
    Add(text:sub(position), false);
    return list
end

function SettingsUI:SetDescriptionParts(text)
    local parts = frame.descriptionParts;
    local list = SplitDescription(text);
    local gap = FONT_HEIGHT + 8;                    -- a blank line
    local total = 0;
    for i, data in ipairs(list) do
        local part = parts[i];
        if not part then
            part = frame.description:GetParent():CreateFontString(nil, "OVERLAY");
            part:SetJustifyH("LEFT");
            part:SetJustifyV("TOP");
            part:SetSpacing(4);
            part:SetWidth(frame.descriptionWidth);
            part:SetPoint("TOP", parts[i - 1], "BOTTOM", 0, -gap);
            parts[i] = part;
        end
        part:SetFontObject(frame.descriptionFont);
        if data.colored then
            local file, size = part:GetFont();
            part:SetFont(file, size, "OUTLINE");
        end
        part:SetText(data.text);
        part:Show();
        total = total + part:GetStringHeight() + (i > 1 and gap or 0);
    end
    if #list == 0 then
        frame.description:SetText("");
        frame.description:Show();
    end
    for i = max(#list, 1) + 1, #parts do
        parts[i]:SetText("");
        parts[i]:Hide();
    end
    frame.descriptionHeight = total;
end

-- Places the decor picture. Retail: the mask's bottom edge sits 24 below the description text. Below that edge
-- the picture is fully visible (mask alpha 0.875), above it fades out over 8 of the mask's 128 rows.
function SettingsUI:UpdateDecor()
    local decor = frame.decor;
    local body, fade, size = decor.body, decor.fade, decor.size;
    local pictureBottom = DECOR_INSET;                  -- from the frame bottom
    local pictureTop = DECOR_INSET + size;
    local textOffset = frame.hasPreview and ((frame.currentPreviewHeight or frame.previewHeight) + FRAME_PADDING) or 8;
    local descriptionBottom = TAB_HEIGHT + 2.5 * FRAME_PADDING + textOffset + (frame.descriptionHeight or frame.description:GetStringHeight());  -- from the frame top
    local edge = decor.frameHeight - descriptionBottom - DECOR_MASK_OFFSET;
    local fadeHeight = size * DECOR_FADE_ROWS;

    local r, g, b, alpha;
    if ThemeUtil:IsDarkMode() then
        r, g, b, alpha = 0.2, 0.2, 0.2, 1;
        body:SetBlendMode("ADD");
        fade:SetBlendMode("ADD");
    else
        r, g, b, alpha = 173 / 255, 114 / 255, 65 / 255, 0.8;
        body:SetBlendMode("BLEND");
        fade:SetBlendMode("BLEND");
    end
    alpha = alpha * DECOR_MASK_ALPHA;

    -- Body: from the picture bottom up to the edge.
    local bodyTop = math.min(math.max(edge, pictureBottom), pictureTop);
    if bodyTop > pictureBottom then
        body:ClearAllPoints();
        body:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -DECOR_INSET, pictureBottom);
        body:SetWidth(size);
        body:SetHeight(bodyTop - pictureBottom);
        body:SetTexCoord(0, 1, (pictureTop - bodyTop) / size, 1);
        body:SetVertexColor(r, g, b, alpha);
        body:Show();
    else
        body:Hide();
    end

    -- Fade band: just above the edge, transparent at its top.
    local bandBottom = math.max(edge, pictureBottom);
    local bandTop = math.min(edge + fadeHeight, pictureTop);
    if bandTop > bandBottom then
        fade:ClearAllPoints();
        fade:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -DECOR_INSET, bandBottom);
        fade:SetWidth(size);
        fade:SetHeight(bandTop - bandBottom);
        fade:SetTexCoord(0, 1, (pictureTop - bandTop) / size, (pictureTop - bandBottom) / size);
        local alphaBottom = alpha * (1 - (bandBottom - edge) / fadeHeight);
        local alphaTop = alpha * (1 - (bandTop - edge) / fadeHeight);
        -- VERTICAL: the first color is at the bottom.
        fade:SetGradientAlpha("VERTICAL", r, g, b, alphaBottom, r, g, b, alphaTop);
        fade:Show();
    else
        fade:Hide();
    end
end

function SettingsUI:Show()
    frame:Show();
end

function SettingsUI:Hide()
    frame:Hide();
end

function SettingsUI:Toggle()
    if frame:IsShown() then
        frame:Hide();
    else
        frame:Show();
    end
end

function SettingsUI:IsShown()
    return frame:IsShown()
end

-- Override bindings cannot change in combat: apply them when it ends. Esc and F1 click the hidden buttons below.
function SettingsUI:UpdateKeys()
    local f = frame;
    if InCombatLockdown() then
        f.keysDirty = true;
        return
    end
    f.keysDirty = false;
    ClearOverrideBindings(f);
    if f:IsShown() then
        SetOverrideBindingClick(f, true, "ESCAPE", CLOSE_NAME, "LeftButton");
        -- The toggle key is the player's "Toggle Settings" key; while a key is being assigned it is a candidate.
        local toggleKey = addon.BindingUtil:GetActiveActionKey("Settings");
        if toggleKey and not KeybindCapture:IsActive() then
            SetOverrideBindingClick(f, true, toggleKey, TOGGLE_NAME, "LeftButton");
        end
    end
end

-- Buttons the key bindings click. Shown but empty, so they are invisible.
local function CreateKeyTarget(name, onClick)
    local button = CreateFrame("Button", name, UIParent);
    button:SetWidth(1);
    button:SetHeight(1);
    button:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0);
    button:SetScript("OnClick", onClick);
end

CreateKeyTarget(TOGGLE_NAME, function()
    SettingsUI:Toggle();
end);
CreateKeyTarget(CLOSE_NAME, function()
    if KeybindCapture:IsActive() then
        KeybindCapture:Stop();      -- Esc cancels a key assignment first
    else
        SettingsUI:Hide();
    end
end);

-- The toggle key changed in Settings > Control: the window listens to the new one.
CallbackRegistry:Register("CustomBindingChanged", function()
    if frame and frame:IsShown() then
        SettingsUI:UpdateKeys();
    end
end);

CreateSettingsFrame();
SettingsUI:SelectTab(1, true);

-- The chat frame stops reading SLASH_<NAME><n> at the first missing n, so the indexes must have no gaps.
SLASH_DIALOGUEUI3351 = "/dialogueui";
SLASH_DIALOGUEUI3352 = "/dialogui";
SlashCmdList["DIALOGUEUI335"] = function(message)
    if message and message:lower():match("^%s*test%s*$") and addon.StartTestPage then
        addon.StartTestPage();          -- quest page with every reward icon combination (DevTool.lua)
    else
        SettingsUI:Toggle();
    end
end;

-- DragonUI also uses /dui. If it is loaded, /dui is left to DragonUI.
-- Checked at PLAYER_LOGIN, when all addons have loaded. /dui goes last so the indexes stay gapless.
do
    local f = CreateFrame("Frame");
    f:RegisterEvent("PLAYER_LOGIN");
    f:SetScript("OnEvent", function(self)
        self:UnregisterEvent("PLAYER_LOGIN");
        if not IsAddOnLoaded("DragonUI") then
            SLASH_DIALOGUEUI3353 = "/dui";
        end
    end);
end
