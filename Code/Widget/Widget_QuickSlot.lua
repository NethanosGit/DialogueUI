local _, addon = ...;

-- Valuable Reward Popup. Port of retail's Widget_QuickSlot.lua (equipment only).
-- After a quest is turned in, the loot messages are watched for a few seconds. When one of the player's own new items
-- is an upgrade according to Pawn or Journal: Gear Guide (TooltipCompare:IsUpgrade), a small popup offers to equip it.
-- Differences from retail:
--   * only equipment: no chests / cosmetics / mounts / pets / toys / decor. A chest needs a secure button to open;
--   * equipping is a plain EquipItemByName (not protected), so it does not work in combat (the button is greyed out);
--   * no "Press Key To Use Item" hotkey;
--   * the auto close countdown is a ring of dots around the close button (no mask textures in 3.3.5a);
--   * a ring or trinket goes to the first slot the game picks, even when Pawn compared it to the second slot.
local L = addon.L;
local API = addon.API;
local GetDBValue = addon.GetDBValue;
local GetDBBool = addon.GetDBBool;
local SetDBValue = addon.SetDBValue;
local After = API.After;
local ThemeUtil = addon.ThemeUtil;
local FontUtil = addon.FontUtil;
local NineSlice = addon.NineSlice;
local BindingUtil = addon.BindingUtil;
local TooltipCompare = addon.TooltipCompare;
local CallbackRegistry = addon.CallbackRegistry;

local CreateFrame = CreateFrame;
local GetItemInfo = GetItemInfo;
local IsEquippedItem = IsEquippedItem;
local EquipItemByName = EquipItemByName;
local InCombatLockdown = InCombatLockdown;
local GetCursorPosition = GetCursorPosition;
local GetContainerNumSlots = GetContainerNumSlots;
local GetContainerItemLink = GetContainerItemLink;
local UIParent = UIParent;
local max, min, floor, ceil = math.max, math.min, math.floor, math.ceil;
local match = string.match;

local QuickSlot = CreateFrame("Frame");
addon.QuickSlot = QuickSlot;

-- Retail numbers (CreateItemActionButton: border 52, everything else relative to it).
local BORDER_SIZE = 52;
local ICON_SIZE = 64 / 96 * BORDER_SIZE;
local TEXT_LEFT = 40 / 96 * BORDER_SIZE - 12;       -- text start, from the left edge of the coloured strip
local HEIGHT = 72 / 96 * BORDER_SIZE;
local TEXT_PADDING_V = 12;
local TEXT_PADDING_H = 12;
local MAX_TEXT_WIDTH = 192;
local ARROW_SIZE = 28;
local CLOSE_SIZE = 34;

local DEFAULT_OFFSET_Y = 196;                   -- from the bottom of the screen
local COUNTDOWN_IDLE = 4;                       -- the player does nothing
local COUNTDOWN_EQUIPPED_AUTO = 2;              -- the item was equipped already (by the game)
local COUNTDOWN_EQUIPPED_MANUAL = 1;            -- the item was equipped with the button
local LOOT_LISTEN_WINDOW = 3;
local RETRY_DELAY = 0.8;
local SLIDE_TIME = 0.35;
local SLIDE_DISTANCE = 32;
local FADE_OUT_SPEED = 4;                       -- alpha per second

local RING_SEGMENTS = 60;
local RING_RADIUS = 8.5;
local RING_DOT_SIZE = 1.4;
local RING_COLOR = {0.88, 0.76, 0.55};

-- Art: Textures\Shared\QuestFlyoutButton.blp, 512 x 512: six coloured strips of 64 px (grey, green, blue, purple, red,
-- teal), the round icon border in the bottom right corner.
local SHEET_FILE = "Interface\\AddOns\\DialogueUI\\Textures\\Shared\\QuestFlyoutButton.blp";
local CLOSE_FILE = "Interface\\AddOns\\DialogueUI\\Textures\\Shared\\WidgetCloseButton.blp";
local ARROW_FILE = "Interface\\AddOns\\DialogueUI\\Textures\\Shared\\ItemIsUpgrade.blp";
local HOTKEY_FILE = "Interface\\AddOns\\DialogueUI\\Textures\\Theme_Dark\\HotkeyBackground.blp";     -- the popup is always dark
local SPACE_FILE = "Interface\\AddOns\\DialogueUI\\Textures\\Keys\\SPACE.blp";
local HOTKEY_SIZE = 20;
local HOTKEY_ICON_SIZE = 14;
local HOTKEY_CORNER = 6;
local HOTKEY_GAP = 4;
local BUTTON_NAME = "DialogueUI335QuickSlotPopup";    -- the Confirm key clicks this button
local SOLID_FILE = "Interface\\Buttons\\WHITE8X8";
local SAMPLE_ICON = "Interface\\Icons\\INV_Misc_QuestionMark";
local COLOR_PURPLE = 4;

local function ColorIndexByQuality(quality)
    if quality == 0 or quality == 1 then
        return 1
    elseif quality == 2 then
        return 2
    elseif quality == 3 then
        return 3
    elseif quality == 4 then
        return 4
    end
    return 5
end

local function GetItemID(link)
    local id = link and match(link, "item:(%d+)");
    return id and tonumber(id)
end

local function FindInBags(itemID)
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local link = GetContainerItemLink(bag, slot);
            if link and GetItemID(link) == itemID then
                return bag, slot
            end
        end
    end
end

local function IsCursorOver(frame)
    local left, right, top, bottom = frame:GetLeft(), frame:GetRight(), frame:GetTop(), frame:GetBottom();
    if not (left and right and top and bottom) then return false end;
    local scale = frame:GetEffectiveScale();
    local x, y = GetCursorPosition();
    x, y = x / scale, y / scale;
    return x >= left and x <= right and y >= bottom and y <= top
end

local Popup;        -- the frame, made on first use
local Font, measurer;

---------------------------------------------------------------------------------------------------------------
-- Popup frame

local function CreatePopup()
    Font = FontUtil:GetColoredFont("DUI335_QuickSlot_Text", 12, {"DarkModeGold", "DarkModeGold"});

    local f = CreateFrame("Button", BUTTON_NAME, UIParent);
    Popup = f;
    f:Hide();
    f:SetFrameStrata("FULLSCREEN_DIALOG");
    f:SetHeight(HEIGHT);
    f:SetWidth(3 * HEIGHT);
    f:SetClampedToScreen(true);
    f:SetMovable(true);
    f:EnableMouse(true);
    f:RegisterForClicks("LeftButtonUp", "RightButtonUp", "MiddleButtonUp");

    local textBackground = f:CreateTexture(nil, "BACKGROUND");
    f.textBackground = textBackground;
    textBackground:SetTexture(SHEET_FILE);
    textBackground:SetPoint("LEFT", f, "LEFT", ICON_SIZE, 0);

    local textHighlight = f:CreateTexture(nil, "BORDER");
    f.textHighlight = textHighlight;
    textHighlight:SetTexture(SHEET_FILE);
    textHighlight:SetBlendMode("ADD");
    textHighlight:SetAlpha(0.35);
    textHighlight:SetAllPoints(textBackground);
    textHighlight:Hide();

    local icon = f:CreateTexture(nil, "ARTWORK");
    f.icon = icon;
    icon:SetWidth(ICON_SIZE);
    icon:SetHeight(ICON_SIZE);
    icon:SetPoint("LEFT", f, "LEFT", 0, 0);
    icon:SetTexCoord(0.0625, 0.9275, 0.0625, 0.9275);

    -- The border sits on its own frame above the icon, the text above the strip.
    local top = CreateFrame("Frame", nil, f);
    top:SetAllPoints(f);
    top:SetFrameLevel(f:GetFrameLevel() + 2);
    top:EnableMouse(false);

    local border = top:CreateTexture(nil, "ARTWORK");
    f.iconBorder = border;
    border:SetTexture(SHEET_FILE);
    border:SetTexCoord(416 / 512, 1, 416 / 512, 1);
    border:SetWidth(BORDER_SIZE);
    border:SetHeight(BORDER_SIZE);
    border:SetPoint("CENTER", icon, "CENTER", 0, 0);

    local arrow = top:CreateTexture(nil, "OVERLAY");
    f.upgradeArrow = arrow;
    arrow:SetTexture(ARROW_FILE);
    arrow:SetWidth(ARROW_SIZE);
    arrow:SetHeight(ARROW_SIZE);
    arrow:SetPoint("CENTER", icon, "TOPRIGHT", -4, -4);
    arrow:Hide();

    -- Key badge (retail's hotkey frame, dark): "Press Button To Use".
    local hotkey = CreateFrame("Frame", nil, top);
    f.hotkey = hotkey;
    hotkey:SetWidth(HOTKEY_SIZE);
    hotkey:SetHeight(HOTKEY_SIZE);
    hotkey.background = NineSlice:Create(hotkey, HOTKEY_FILE, {32, 32}, 8, HOTKEY_CORNER, "ARTWORK");
    hotkey.keyName = hotkey:CreateFontString(nil, "OVERLAY");
    hotkey.keyName:SetFontObject(FontUtil:GetColoredFont("DUI335_Hotkey", 10, {"DarkModeGrey70", "DarkModeGrey70"}));
    hotkey.keyName:SetPoint("CENTER", hotkey, "CENTER", 0, 0);
    hotkey.icon = hotkey:CreateTexture(nil, "OVERLAY");
    hotkey.icon:SetWidth(HOTKEY_ICON_SIZE);
    hotkey.icon:SetHeight(HOTKEY_ICON_SIZE);
    hotkey.icon:SetPoint("CENTER", hotkey, "CENTER", 0, 0);
    hotkey.icon:SetVertexColor(0.72, 0.72, 0.72);
    hotkey:Hide();

    local text = top:CreateFontString(nil, "OVERLAY");
    f.text = text;
    text:SetFontObject(Font);
    text:SetJustifyH("LEFT");
    text:SetJustifyV("MIDDLE");

    -- Close button: it only shows the countdown, until Move Position makes it work.
    local close = CreateFrame("Button", nil, f);
    f.closeButton = close;
    close:SetFrameLevel(f:GetFrameLevel() + 4);
    close:SetWidth(CLOSE_SIZE);
    close:SetHeight(CLOSE_SIZE);
    close:SetPoint("CENTER", f, "TOPRIGHT", -5, -5);
    close:SetNormalTexture(CLOSE_FILE);
    -- Retail's small dark style (AutoCloseButton:SetTheme(2, true)): black disc with a cream X, bottom left of the sheet.
    close:GetNormalTexture():SetTexCoord(0, 0.25, 0.75, 1);
    close:SetHighlightTexture(CLOSE_FILE, "ADD");
    close:GetHighlightTexture():SetTexCoord(0.5, 0.75, 0.75, 1);
    close:GetHighlightTexture():SetVertexColor(0.5, 0.5, 0.5);
    close:EnableMouse(false);
    close:SetScript("OnClick", function()
        QuickSlot:Clear();
    end);

    local ring = {};
    for i = 1, RING_SEGMENTS do
        local angle = (i - 1) / RING_SEGMENTS * 2 * math.pi;
        local dot = close:CreateTexture(nil, "OVERLAY");
        dot:SetTexture(SOLID_FILE);
        dot:SetVertexColor(RING_COLOR[1], RING_COLOR[2], RING_COLOR[3]);
        dot:SetWidth(RING_DOT_SIZE);
        dot:SetHeight(RING_DOT_SIZE);
        dot:SetPoint("CENTER", close, "CENTER", math.sin(angle) * RING_RADIUS, math.cos(angle) * RING_RADIUS);
        dot:Hide();
        ring[i] = dot;
    end
    f.ring = ring;

    f:SetScript("OnEnter", function(self)
        if self.enabled then
            self.textHighlight:Show();
        end
    end);
    f:SetScript("OnLeave", function(self)
        self.textHighlight:Hide();
    end);
    f:SetScript("OnClick", QuickSlot.OnClick);
    f:SetScript("OnEvent", QuickSlot.OnPopupEvent);
    f:SetScript("OnDragStart", QuickSlot.OnDragStart);
    f:SetScript("OnDragStop", QuickSlot.OnDragStop);
    f:SetScript("OnHide", QuickSlot.OnPopupHide);

    QuickSlot:LoadPosition();
    return f
end

local function GetPopup()
    return Popup or CreatePopup()
end

-- progress: 0 = empty ring, 1 = full ring (clockwise from the top).
function QuickSlot:SetRingProgress(progress)
    local ring = Popup.ring;
    local visible = floor(max(min(progress, 1), 0) * RING_SEGMENTS);
    if visible == Popup.ringVisible then return end;
    Popup.ringVisible = visible;
    for i = 1, RING_SEGMENTS do
        if i <= visible then
            ring[i]:Show();
        else
            ring[i]:Hide();
        end
    end
end

-- Colour strip (1 grey .. 6 teal) and text. The strip keeps its proportions: only the right part of the art is used.
function QuickSlot:SetContent(colorIndex, iconTexture, text, textColorKey)
    local f = Popup;
    f.content = {colorIndex, iconTexture, text, textColorKey};
    f.icon:SetTexture(iconTexture);
    f.text:SetText(text);
    f.text:SetTextColor(ThemeUtil:GetColor(textColorKey or "DarkModeGold"));

    -- Measured on a spare FontString that never has a fixed width (the real one depends on its wrapping).
    if not measurer then
        measurer = UIParent:CreateFontString(nil, "OVERLAY");
        measurer:SetAlpha(0);
        measurer:SetPoint("TOPLEFT", UIParent, "BOTTOMRIGHT", 0, 0);   -- off screen
        measurer:SetFontObject(Font);
    end
    measurer:SetText(text);
    local textWidth = measurer:GetStringWidth();
    if textWidth > MAX_TEXT_WIDTH then
        f.text:SetWidth(MAX_TEXT_WIDTH);
        textWidth = MAX_TEXT_WIDTH;
    else
        textWidth = ceil(textWidth) + 2;
        f.text:SetWidth(textWidth);
    end

    local textHeight = f.text:GetHeight();
    local stripHeight = floor(textHeight + 2 * TEXT_PADDING_V + 0.5);

    -- Key badge before the text (the Confirm key; Space is drawn as the space bar icon).
    local key = (not f.hideHotkey) and GetDBBool("QuickSlotUseHotkey") and BindingUtil:GetActiveConfirmKey();
    local badgeWidth = 0;
    local hotkey = f.hotkey;
    if key then
        if key == "SPACE" then
            hotkey.icon:SetTexture(SPACE_FILE);
            hotkey.icon:Show();
            hotkey.keyName:Hide();
            badgeWidth = HOTKEY_SIZE;
        else
            hotkey.icon:Hide();
            hotkey.keyName:SetText(key);
            hotkey.keyName:Show();
            badgeWidth = max(HOTKEY_SIZE, floor(hotkey.keyName:GetStringWidth() + 12 + 0.5));
        end
        hotkey:SetWidth(badgeWidth);
        hotkey:Show();
        badgeWidth = badgeWidth + HOTKEY_GAP;
    else
        hotkey:Hide();
    end
    f.hotkeyKey = key or nil;

    local stripWidth = floor(TEXT_LEFT + TEXT_PADDING_H + badgeWidth + textWidth + 0.5);
    stripWidth = max(stripWidth, 3 * stripHeight);

    f.textBackground:SetWidth(stripWidth);
    f.textBackground:SetHeight(stripHeight);
    local left = max(1 - 0.125 * stripWidth / stripHeight, 0);
    local topCoord, bottomCoord = (colorIndex - 1) * 0.125, colorIndex * 0.125;
    f.textBackground:SetTexCoord(left, 1, topCoord, bottomCoord);
    f.textHighlight:SetTexCoord(left, 1, topCoord, bottomCoord);

    f.text:ClearAllPoints();
    f.text:SetPoint("LEFT", f.textBackground, "LEFT", TEXT_LEFT + badgeWidth, 0);
    hotkey:ClearAllPoints();
    hotkey:SetPoint("LEFT", f.textBackground, "LEFT", TEXT_LEFT, 0);

    f:SetWidth(floor(ICON_SIZE + stripWidth + 0.5));
    f:SetHeight(max(HEIGHT, stripHeight));
end

function QuickSlot:SetEnabled(enabled)
    local f = Popup;
    f.enabled = enabled;
    local g = enabled and 1 or 0.6;
    f.textBackground:SetDesaturated(not enabled);
    f.iconBorder:SetDesaturated(not enabled);
    f.icon:SetDesaturated(not enabled);
    f.textBackground:SetVertexColor(g, g, g);
    f.iconBorder:SetVertexColor(g, g, g);
    f.icon:SetVertexColor(g, g, g);
    if not enabled then
        f.textHighlight:Hide();
    end
    self:UpdateBinding();
end

-- The Confirm key equips the item while the popup is usable (not in the Move sample, not after equipping).
function QuickSlot:UpdateBinding()
    if InCombatLockdown() then return end;
    ClearOverrideBindings(self);
    local f = Popup;
    if f and f.link and f.enabled and not f.done and f.hotkeyKey then
        SetOverrideBindingClick(self, true, f.hotkeyKey, BUTTON_NAME, "LeftButton");
    end
end

-- Shows the popup again with its content, after a setting that changes its layout (Press Button To Use, the Confirm key).
function QuickSlot:Refresh()
    local f = Popup;
    if f and f.content then
        local c = f.content;
        self:SetContent(c[1], c[2], c[3], c[4]);
        if f.done then
            f.text:SetTextColor(0.4, 1, 0.4);
        end
        self:UpdateBinding();
    end
end
CallbackRegistry:Register("SettingChanged.QuickSlotUseHotkey", function() QuickSlot:Refresh(); end);
CallbackRegistry:Register("CustomBindingChanged", function() QuickSlot:Refresh(); end);

---------------------------------------------------------------------------------------------------------------
-- Position (center of the popup from the bottom left of the screen, or the default above the action bars)

function QuickSlot:LoadPosition()
    local pos = GetDBValue("QuickSlotPosition");
    if type(pos) == "table" and type(pos[1]) == "number" and type(pos[2]) == "number" then
        self.base = {"CENTER", UIParent, "BOTTOMLEFT", pos[1], pos[2]};
    else
        self.base = {"BOTTOM", UIParent, "BOTTOM", 0, DEFAULT_OFFSET_Y};
    end
    self:ApplyPosition(0);
end

-- offsetY: extra vertical offset while the popup slides in.
function QuickSlot:ApplyPosition(offsetY)
    local base = self.base;
    Popup:ClearAllPoints();
    Popup:SetPoint(base[1], base[2], base[3], base[4], base[5] + (offsetY or 0));
end

function QuickSlot:SavePosition()
    local x, y = Popup:GetCenter();
    if not (x and y) then return end;
    SetDBValue("QuickSlotPosition", {floor(x + 0.5), floor(y + 0.5)});
end

function QuickSlot:IsUsingCustomPosition()
    return GetDBValue("QuickSlotPosition") ~= nil
end

function QuickSlot:ResetItemButtonPosition()
    SetDBValue("QuickSlotPosition", nil);
    if Popup then
        self:LoadPosition();
    end
end

function QuickSlot.OnDragStart(f)
    f.isMoving = true;
    f:StartMoving();
end

function QuickSlot.OnDragStop(f)
    f:StopMovingOrSizing();
    f.isMoving = nil;
    QuickSlot:SavePosition();
    QuickSlot:LoadPosition();
end

---------------------------------------------------------------------------------------------------------------
-- Show, countdown, close

function QuickSlot:StartAnimation(countdown)
    local f = Popup;
    f.phase = "in";
    f.t = 0;
    f.countdown = countdown;
    f.remaining = countdown;
    f.ringVisible = nil;
    self:SetRingProgress(0);
    f:SetAlpha(0);
    self:ApplyPosition(-SLIDE_DISTANCE);
    f:SetScript("OnUpdate", QuickSlot.OnUpdate);
    f:Show();
end

function QuickSlot:SetCountdown(seconds)
    local f = Popup;
    f.countdown = seconds;
    f.remaining = seconds;
    f.ringVisible = nil;
    self:SetRingProgress(0);
    if f.phase == "out" then
        f.phase = "hold";
        f:SetAlpha(1);
    end
end

function QuickSlot:IsPaused()
    local f = Popup;
    return f.isMoving or IsCursorOver(f) or IsCursorOver(f.closeButton)
end

function QuickSlot.OnUpdate(f, elapsed)
    local phase = f.phase;
    if phase == "in" then
        f.t = f.t + elapsed;
        local p = min(f.t / SLIDE_TIME, 1);
        local eased = 1 - (1 - p) * (1 - p);
        f:SetAlpha(p);
        if not f.isMoving then
            QuickSlot:ApplyPosition(-SLIDE_DISTANCE * (1 - eased));
        end
        if p >= 1 then
            f.phase = "hold";
        end
    elseif phase == "hold" then
        if f.remaining and not QuickSlot:IsPaused() then
            f.remaining = max(f.remaining - elapsed, 0);
            QuickSlot:SetRingProgress(1 - f.remaining / f.countdown);
            if f.remaining <= 0 then
                f.phase = "out";
                f.alpha = f:GetAlpha();
            end
        end
    elseif phase == "out" then
        f.alpha = f.alpha - FADE_OUT_SPEED * elapsed;
        if f.alpha <= 0 then
            QuickSlot:Clear();
        else
            f:SetAlpha(f.alpha);
        end
    end
end

-- Removes the popup and forgets the item.
function QuickSlot:Clear()
    local f = Popup;
    if not f then return end;
    local wasEditMode = f.isEditMode;
    f:SetScript("OnUpdate", nil);
    f:UnregisterAllEvents();
    f.phase = nil;
    f.link = nil;
    f.itemID = nil;
    f.isEditMode = nil;
    f.done = nil;
    f.hideHotkey = nil;
    self:UpdateBinding();
    f:RegisterForDrag();
    f.closeButton:EnableMouse(false);
    f:SetAlpha(1);
    f:Hide();
    if wasEditMode and addon.SettingsUI then
        addon.SettingsUI:RefreshToggles();      -- the Move row is no longer on
    end
end

function QuickSlot.OnPopupHide(f)
    if f.isMoving then
        f:StopMovingOrSizing();
        f.isMoving = nil;
        QuickSlot:SavePosition();
        QuickSlot:LoadPosition();
    end
end

---------------------------------------------------------------------------------------------------------------
-- The item

function QuickSlot:ShowEquipment(link)
    local f = GetPopup();
    local name, _, quality, _, _, _, _, _, _, texture = GetItemInfo(link);
    if not name then return false end;

    self:Clear();
    f.link = link;
    f.itemID = GetItemID(link);
    f.isEditMode = nil;

    f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
    f:RegisterEvent("BAG_UPDATE");
    f:RegisterEvent("PLAYER_REGEN_DISABLED");
    f:RegisterEvent("PLAYER_REGEN_ENABLED");

    self:SetContent(ColorIndexByQuality(quality), texture or SAMPLE_ICON, name);
    if IsEquippedItem(link) then
        self:MarkEquipped(COUNTDOWN_EQUIPPED_AUTO, true);
    else
        f.upgradeArrow:Show();
        self:SetEnabled(not InCombatLockdown());
        self:StartAnimation(COUNTDOWN_IDLE);
    end
    return true
end

-- The item is on the character: green "Equipped", button off, short countdown.
function QuickSlot:MarkEquipped(countdown, isNew)
    local f = Popup;
    f.done = true;
    f.hideHotkey = true;
    f.upgradeArrow:Hide();
    local c = f.content;
    self:SetContent(c[1], c[2], L["Item Equipped"], c[4]);      -- no key badge any more
    f.text:SetTextColor(0.4, 1, 0.4);
    self:SetEnabled(false);
    if isNew then
        self:StartAnimation(countdown);
    else
        self:SetCountdown(countdown);
    end
end

function QuickSlot.OnClick(f, button)
    if button == "RightButton" then
        QuickSlot:Clear();
    elseif button == "MiddleButton" then
        if QuickSlot:IsUsingCustomPosition() then
            QuickSlot:ResetItemButtonPosition();
        end
    elseif button == "LeftButton" then
        if f.isEditMode or not f.enabled or f.done or not f.link or InCombatLockdown() then return end;
        EquipItemByName(f.link);        -- bind-on-equip: the game asks for confirmation itself
    end
end

function QuickSlot.OnPopupEvent(f, event)
    if not f.link then return end;
    if event == "PLAYER_REGEN_DISABLED" then
        if not f.done then
            QuickSlot:SetEnabled(false);
        end
    elseif event == "PLAYER_REGEN_ENABLED" then
        if not f.done then
            QuickSlot:SetEnabled(true);
        end
    elseif not f.done then
        -- PLAYER_EQUIPMENT_CHANGED / BAG_UPDATE
        if IsEquippedItem(f.link) then
            QuickSlot:MarkEquipped(COUNTDOWN_EQUIPPED_MANUAL);
        elseif not FindInBags(f.itemID) then
            QuickSlot:Clear();      -- sold, destroyed or traded
        end
    end
end

---------------------------------------------------------------------------------------------------------------
-- Loot detection (only for a few seconds after a quest was turned in)

local pendingLink;
local listenTime;

function QuickSlot:ListenLootEvent(state)
    if state then
        self:RegisterEvent("CHAT_MSG_LOOT");
        listenTime = 0;
        self:SetScript("OnUpdate", self.OnUpdate_Listen);
    else
        listenTime = nil;
        pendingLink = nil;
        self:SetScript("OnUpdate", nil);
        self:UnregisterEvent("CHAT_MSG_LOOT");
        self:UnregisterEvent("BAG_UPDATE");
    end
end

function QuickSlot:OnUpdate_Listen(elapsed)
    listenTime = listenTime + elapsed;
    if listenTime >= LOOT_LISTEN_WINDOW then
        self:ListenLootEvent(false);
    end
end

-- The loot message can come before the item is in the bag: wait for BAG_UPDATE (a second more than usual).
function QuickSlot:WatchBag(link)
    pendingLink = link;
    self:RegisterEvent("BAG_UPDATE");
    if listenTime then
        listenTime = listenTime - 1;
    end
end

function QuickSlot:EvaluateItem(link, isRetry)
    if self.inCutscene or not GetDBBool("QuickSlotQuestReward") then return end;
    if not TooltipCompare:IsEquippable(link) then return end;

    local isUpgrade, isReady = TooltipCompare:IsUpgrade(link, true);
    if not isReady then
        -- The item data is not in the cache yet. The call above asked for it: look again shortly.
        if not isRetry then
            After(RETRY_DELAY, function()
                self:EvaluateItem(link, true);
            end);
        end
        return
    end
    if not isUpgrade then return end;

    if FindInBags(GetItemID(link)) then
        self:ShowEquipment(link);
    else
        self:WatchBag(link);
    end
end

function QuickSlot:OnEvent(event, ...)
    if event == "CHAT_MSG_LOOT" then
        local text, playerName = ...;
        if not text or not addon.IsOwnLootMessage(text, playerName) then return end;
        local link = match(text, "(|c%x+|Hitem:.-|h%[.-%]|h|r)");
        if link then
            self:EvaluateItem(link);
        end
    elseif event == "BAG_UPDATE" then
        if pendingLink and FindInBags(GetItemID(pendingLink)) then
            local link = pendingLink;
            pendingLink = nil;
            self:UnregisterEvent("BAG_UPDATE");
            self:ShowEquipment(link);
        end
    elseif event == "CINEMATIC_START" or event == "PLAY_MOVIE" then
        self.inCutscene = true;
        self:Clear();
    elseif event == "CINEMATIC_STOP" or event == "PLAYER_ENTERING_WORLD" then
        self.inCutscene = nil;
    end
end
QuickSlot:SetScript("OnEvent", QuickSlot.OnEvent);
QuickSlot:RegisterEvent("CINEMATIC_START");
QuickSlot:RegisterEvent("CINEMATIC_STOP");
QuickSlot:RegisterEvent("PLAY_MOVIE");
QuickSlot:RegisterEvent("PLAYER_ENTERING_WORLD");

-- FooterButtons.lua: the player took the reward.
CallbackRegistry:Register("TriggerQuestFinished", function()
    if GetDBBool("QuickSlotQuestReward") then
        QuickSlot:ListenLootEvent(true);
    end
end);

CallbackRegistry:Register("SettingChanged.QuickSlotQuestReward", function(state)
    if not state then
        QuickSlot:ListenLootEvent(false);
        QuickSlot:Clear();
    end
end);

---------------------------------------------------------------------------------------------------------------
-- Settings > Gameplay > Valuable Reward Popup > Move: a sample popup to drag, without needing a reward.

function QuickSlot:IsEditMode()
    return Popup ~= nil and Popup.isEditMode and Popup:IsShown() and true or false
end

function QuickSlot:ToggleEditMode()
    if self:IsEditMode() then
        self:Clear();
        return
    end
    local f = GetPopup();
    self:Clear();
    f.isEditMode = true;
    f.hideHotkey = nil;
    f.upgradeArrow:Hide();
    f:RegisterForDrag("LeftButton");
    f.closeButton:EnableMouse(true);
    self:SetContent(COLOR_PURPLE, SAMPLE_ICON, L["Valuable Reward Popup Sample"]);
    self:SetEnabled(true);
    self:StartAnimation(nil);       -- no countdown
    addon.SettingsUI:RefreshToggles();
end

-- The sample goes away with the Settings window, when the Gameplay tab is left or the option is turned off.
CallbackRegistry:Register("SettingsUI.Hide", function()
    if QuickSlot:IsEditMode() then
        QuickSlot:Clear();
    end
end);
CallbackRegistry:Register("SettingsUI.TabChanged", function(tabID)
    if tabID ~= 3 and QuickSlot:IsEditMode() then
        QuickSlot:Clear();
    end
end);
