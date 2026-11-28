local _, addon = ...;
local LootUI = addon.LootUI;
local Def = LootUI.Def;
local ThemeUtil = addon.LootThemeUtil;
local NineSlice = addon.NineSlice;
local MoneyUtil = addon.MoneyUtil;

local CreateFrame = CreateFrame;
local floor = math.floor;
local ceil = math.ceil;
local NAME_RIGHT_PAD = 10;
local min = math.min;
local max = math.max;
local match = string.match;
local gsub = string.gsub;
local ipairs = ipairs;
local tostring = tostring;
local GetItemCount = GetItemCount;
local OutQuart = LootUI.OutQuart;

-- One row of the loot window: reward-button look (ItemButtonBackground, ItemBorder, quality corner, transmog marker)
-- with Plumber's behaviour (hover shift, slide-out, animated count, glow for rare items).
--   row      the layout slot, never moves
--   body     background + highlight, slides out to the right when the item is taken
--   content  icon, name and count, shifts 8 px on hover

local BACKGROUND_FILE = "ItemButtonBackground.blp";     -- 64x64, slice margin 16
local BORDER_FILE = "ItemBorder.blp";
local HIGHLIGHT_ADD = "ButtonHighlight-Add.blp";        -- 128x64
local HIGHLIGHT_FRONT = "ButtonHighlight-Front.blp";
local HIGHLIGHT_FRONT_WIDTH = 18;

local ICON_TEXCOORD = {0.0625, 0.9275, 0.0625, 0.9275};
local ICON_JUNK = "Interface\\Icons\\INV_Misc_QuestionMark";
local OVERLAY_TRANSMOG_INDEX = 8;
local TRANSMOG_GROW = 4;
local COIN_SIZE = 22;

local HOVER_DURATION = 0.25;
local HOVER_OFFSET = 8;
local SLIDE_SPEED = 128;                -- units per second
local SLIDE_FADE = 5;                   -- alpha per second
local COUNT_DELAY = 0.25;
local COUNT_DURATION = 0.25;
local COUNT_RISE = 6;

local NAME_FONT ={"DUI335_LootItem", 10, {"DarkModeGrey90", "DarkModeGrey90"}};

-- Owned count on the icon: the same size as the item name font (NAME_FONT). Like every font of the
-- window it follows the setting and the text outline (LootUI.GetFont).
local COUNT_FONT_FILE = "Fonts\\ARIALN.TTF";     -- the stack count face of the game (retail's NumberFont), not the text face
local OWNED_COUNT_FONT ={"DUI335_LootOwnedCount", NAME_FONT[2], {1, 1, 1}};


---------------------------------------------------------------------------
-- Money text
---------------------------------------------------------------------------

-- "7 Gold 3 Silver" (a coin slot's name in a client of any language) -> copper. GOLD_AMOUNT = "%d Gold".
local function BuildAmountPattern(globalName)
    local text = _G[globalName];
    if not text then
        return nil
    end
    text = gsub(text, "([%^%$%(%)%.%[%]%*%+%-%?])", "%%%1");    -- escape magic characters, "%d" is left alone
    return (gsub(text, "%%%%d", "(%%d+)"))
end

local goldPattern, silverPattern, copperPattern;

local function ParseCoinText(text)
    goldPattern = goldPattern or BuildAmountPattern("GOLD_AMOUNT");
    silverPattern = silverPattern or BuildAmountPattern("SILVER_AMOUNT");
    copperPattern = copperPattern or BuildAmountPattern("COPPER_AMOUNT");
    if not (goldPattern and silverPattern and copperPattern and text) then
        return nil
    end
    local g = tonumber(match(text, goldPattern)) or 0;
    local s = tonumber(match(text, silverPattern)) or 0;
    local c = tonumber(match(text, copperPattern)) or 0;
    local total = g * 10000 + s * 100 + c;
    if total > 0 then
        return total
    end
    return nil
end
LootUI.ParseCoinText = ParseCoinText;


---------------------------------------------------------------------------
-- Row
---------------------------------------------------------------------------

local ItemFrame = {};

function ItemFrame:UpdateNameColor()
    local data = self.data;
    local quality = self.quality or 1;
    local font = self.nameFont;
    self.name:SetFontObject(font);
    if data and data.slotType == Def.SLOT_TYPE_ITEM then
        self.name:SetTextColor(LootUI.GetNameColor(quality));
    else
        self.name:SetTextColor(font:GetTextColor());
    end
    self.count:SetFontObject(font);
    self.dummyCount:SetFontObject(font);
end

function ItemFrame:SetIcon(texture, coin)
    self.icon:SetTexture(texture);
    if coin then
        self.icon:SetTexCoord(0, 1, 0, 1);
        self.icon:SetWidth(COIN_SIZE);
        self.icon:SetHeight(COIN_SIZE);
    else
        self.icon:SetTexCoord(ICON_TEXCOORD[1], ICON_TEXCOORD[2], ICON_TEXCOORD[3], ICON_TEXCOORD[4]);
        self.icon:SetWidth(Def.ICON_SIZE);
        self.icon:SetHeight(Def.ICON_SIZE);
    end
    self.border:Show();
end

-- Marker for an appearance the player has not collected (server module, see TransmogStatus.lua).
function ItemFrame:UpdateTransmogMarker()
    local data = self.data;
    local show = data and data.slotType == Def.SLOT_TYPE_ITEM and data.id
        and not data.mergedData and addon.TransmogStatus:IsUncollected(data.id, "LootUI_ShowTransmogStatus");
    ThemeUtil:SetItemOverlay(self.transmogOverlay, show and OVERLAY_TRANSMOG_INDEX or nil);
end

function ItemFrame:RefreshTransmog()
    local data = self.data;
    if data and data.slotType == Def.SLOT_TYPE_ITEM and data.link and data.id and not data.mergedData then
        if addon.TooltipCompare:IsEquippable(data.link) then
            addon.TransmogStatus:Request(data.id);
        end
    end
    self:UpdateTransmogMarker();
end

-- Owned count on the icon's lower right corner (Plumber: Def.SHOW_ITEM_COUNT). Bank included: GetItemCount's second
-- argument counts the bank too (the bank part is what the client saw at the last bank visit).
function ItemFrame:UpdateOwnedCount()
    local data = self.data;
    local text = "";
    if Def.SHOW_ITEM_COUNT and data and data.slotType == Def.SLOT_TYPE_ITEM and not data.mergedData and data.link then
        local owned = data.testOwned or GetItemCount(data.link, true) or 0;     -- testOwned: the settings preview
        if owned > 0 then
            text = owned > 9999 and "*" or tostring(owned);
        end
    end
    self.ownedCount:SetText(text);
end

function ItemFrame:SetBorderColor(r, g, b)
    self.border:SetVertexColor(r, g, b);
end

-- Count in front of the name: "+3 ". Hidden for a single piece of equipment.
function ItemFrame:SetCount(data)
    if (not data) or (data.hideCount and (data.quantity or 0) < 2) or not data.quantity or data.quantity < 1 then
        self.countWidth = 0;
        self.count:SetText("");
        self.count:Hide();
        return
    end
    local quantity = data.totalQuantity or data.quantity;
    if data.oldQuantity then
        self:AnimateCount(data.oldQuantity, quantity);
        data.oldQuantity = nil;
    else
        self.count:SetText("+" .. quantity);
        self.count:SetAlpha(1);
    end
    self.count:Show();
    self.countWidth = max(self.count:GetStringWidth(), self.dummyCount:GetStringWidth()) + 6;
end

function ItemFrame:Layout()
    local left = Def.NAME_LEFT;
    self.count:ClearAllPoints();
    self.count:SetPoint("LEFT", self.content, "LEFT", left, 0);
    self.dummyCount:ClearAllPoints();
    self.dummyCount:SetPoint("CENTER", self.count, "CENTER", 0, 0);

    local nameLeft = left + (self.countWidth or 0);
    self.name:ClearAllPoints();
    self.name:SetPoint("TOPLEFT", self.content, "TOPLEFT", nameLeft, 0);
    self.name:SetPoint("BOTTOMLEFT", self.content, "BOTTOMLEFT", nameLeft, 0);
    self.name:SetWidth((self.rowWidth or Def.ROW_WIDTH) - nameLeft - NAME_RIGHT_PAD);
    self.nameLeft = nameLeft;
end

-- Width this row needs to show its name on one line (the window takes the widest row, so the longest name decides).
function ItemFrame:GetDesiredWidth()
    -- Measure unwrapped: a narrow fontstring would report the wrapped width.
    self.name:SetWidth(2048);
    local textWidth = self.name:GetStringWidth() + 1;
    local width = (self.nameLeft or Def.NAME_LEFT) + textWidth + NAME_RIGHT_PAD;
    return max(Def.ROW_MIN_WIDTH, ceil(width))
end

function ItemFrame:SetRowWidth(width)
    self.rowWidth = width;
    self:SetWidth(width);
    self.body:SetWidth(width);
    self.content:SetWidth(width);
    self.name:SetWidth(width - (self.nameLeft or Def.NAME_LEFT) - NAME_RIGHT_PAD);
end

function ItemFrame:SetNameByQuality(name, quality)
    self.quality = quality or 1;
    self.name:SetText(name or "");
    self:UpdateNameColor();
end


-- Stacked items of a merged row (gray items): up to 4 complete item frames (icon and border) laid over each other
-- with an offset, the first on top. The ones below are darker.
function ItemFrame:SetStackedIcons(mergedData)
    self.stacked = self.stacked or {};
    for _, s in ipairs(self.stacked) do
        s:Hide();
    end

    local n = min(#mergedData, 4);
    local overlap = 0.25;
    local factor = 1 / (1 + (n - 1) * overlap);
    local borderSize = Def.BORDER_SIZE * factor;
    local iconSize = Def.ICON_SIZE * factor;
    local step = borderSize * overlap;
    local baseLevel = self.content:GetFrameLevel() + 1;
    for i = 1, n do
        local s = self.stacked[i];
        if not s then
            s = CreateFrame("Frame", nil, self.content);
            s.icon = s:CreateTexture(nil, "ARTWORK");
            s.icon:SetTexCoord(ICON_TEXCOORD[1], ICON_TEXCOORD[2], ICON_TEXCOORD[3], ICON_TEXCOORD[4]);
            s.icon:SetPoint("CENTER", s, "CENTER", 0, 0);
            s.border = s:CreateTexture(nil, "OVERLAY");
            s.border:SetAllPoints(s);
            ThemeUtil:BindTexture(s.border, BORDER_FILE);
            self.stacked[i] = s;
        end
        local shade = 1 - (i - 1) * 0.2;
        s:SetFrameLevel(baseLevel + (n - i) * 2);
        s:SetWidth(borderSize);
        s:SetHeight(borderSize);
        s:ClearAllPoints();
        s:SetPoint("TOPLEFT", self.border, "TOPLEFT", (i - 1) * step, -(i - 1) * step);
        s.icon:SetWidth(iconSize);
        s.icon:SetHeight(iconSize);
        s.icon:SetTexture(mergedData[i].icon);
        s.icon:SetVertexColor(shade, shade, shade);
        s.border:SetVertexColor(shade, shade, shade);
        s:Show();
    end
    self.border:Hide();             -- the stack has its own borders
end

function ItemFrame:HideStackedIcons()
    if self.stacked then
        for _, s in ipairs(self.stacked) do
            s:Hide();
        end
    end
end

local function SortByQuality(a, b)
    if a.quality ~= b.quality then
        return a.quality > b.quality
    end
    return (a.id or 0) > (b.id or 0)
end

function ItemFrame:SetMergedItem(data)
    self:UnregisterEvent("BAG_UPDATE");
    self.ownedCount:SetText("");
    local merged = data.mergedData;
    table.sort(merged, SortByQuality);

    local total = 0;
    for _, v in ipairs(merged) do
        total = total + v.quantity;
    end
    if data.totalQuantity then
        data.oldQuantity = data.totalQuantity;
    end
    data.totalQuantity = total;
    data.hideCount = false;

    self:SetNameByQuality(addon.L["Junk Items"], merged[1].quality);
    self:SetIcon(merged[1].icon);
    if #merged > 1 then
        self.icon:Hide();
        self:SetStackedIcons(merged);
    else
        self.icon:Show();
        self:HideStackedIcons();
    end
    self:SetBorderColor(1, 1, 1);
    ThemeUtil:SetItemOverlay(self.overlay, nil);
    self:SetCount(data);
    self:Layout();
    self:ShowGlow(false);
    self:UpdateTransmogMarker();
end

function ItemFrame:SetItem(data)
    self.icon:Show();
    self:HideStackedIcons();
    self:SetNameByQuality(data.name, data.quality);
    self:SetIcon(data.icon or ICON_JUNK);
    if data.locked then
        self.icon:SetVertexColor(0.9, 0, 0);
    else
        self.icon:SetVertexColor(1, 1, 1);
    end
    self:SetBorderColor(1, 1, 1);
    ThemeUtil:SetItemOverlay(self.overlay, (data.quality or 0) >= 2 and data.quality or nil);
    self:SetCount(data);
    self:Layout();
    self:ShowGlow(LootUI.IsRareItem(data));
    self:RefreshTransmog();
    self:UpdateOwnedCount();
    self:RegisterEvent("BAG_UPDATE");       -- the looted item reaches the bags after the row is shown
end

function ItemFrame:SetMoney(data)
    self:UnregisterEvent("BAG_UPDATE");
    self.ownedCount:SetText("");
    local copper = data.copper or ParseCoinText(data.name);
    local text;
    if copper then
        data.copper = copper;
        text = MoneyUtil:GetShortText(copper);
    else
        text = gsub(data.name or "", "%c+", ", ");
    end
    self.icon:Show();
    self:HideStackedIcons();
    self:SetIcon(ThemeUtil:GetTextureFile(MoneyUtil:GetCoinFile(copper or 0)), true);
    self.icon:SetVertexColor(1, 1, 1);
    self:SetBorderColor(1, 1, 1);
    ThemeUtil:SetItemOverlay(self.overlay, nil);
    self:SetCount(nil);
    self:SetNameByQuality(text, 1);
    self:Layout();
    self:ShowGlow(false);
    ThemeUtil:SetItemOverlay(self.transmogOverlay, nil);
    if data.oldCopper and copper then
        self:AnimateMoney(data.oldCopper, copper);
        data.oldCopper = nil;
    end
end

-- Reputation gain: the addon's reputation icon (there are no faction icons), the faction's name in light blue
-- (Plumber: INFLUENCE_COLOR, the default blue is too dark) and the amount as the count.
local ICON_REPUTATION = "Interface\\AddOns\\DialogueUI\\Textures\\Icons\\Reputation.blp";

function ItemFrame:SetReputation(data)
    self:UnregisterEvent("BAG_UPDATE");
    self.ownedCount:SetText("");
    self.icon:Show();
    self:HideStackedIcons();
    self:SetIcon(ICON_REPUTATION);
    self.icon:SetVertexColor(1, 1, 1);
    self:SetBorderColor(1, 1, 1);
    ThemeUtil:SetItemOverlay(self.overlay, nil);
    ThemeUtil:SetItemOverlay(self.transmogOverlay, nil);
    self:SetCount(data);
    self:SetNameByQuality(data.name, 1);
    self.name:SetTextColor(0, 0.8, 1);
    self:Layout();
    self:ShowGlow(false);
end

function ItemFrame:SetCustom(data)
    self:UnregisterEvent("BAG_UPDATE");
    self.ownedCount:SetText("");
    self.icon:Show();
    self:HideStackedIcons();
    self:SetIcon(data.icon or ICON_JUNK);
    self.icon:SetVertexColor(1, 1, 1);
    self:SetBorderColor(1, 1, 1);
    ThemeUtil:SetItemOverlay(self.overlay, nil);
    ThemeUtil:SetItemOverlay(self.transmogOverlay, nil);
    self:SetCount(data);
    self:SetNameByQuality(data.name, data.quality or 1);
    self:Layout();
    self:ShowGlow(data.showGlow);
end

function ItemFrame:SetData(data)
    -- Same item arriving again: the count grows (and animates), see Plumber's ItemFrameMixin:SetData.
    local old = self.data;
    if old and (old.quantity or 0) ~= 0 and (data.quantity or 0) ~= 0
        and not (old.toast ~= data.toast and old.quantity == data.quantity) and old ~= data then
        data.oldQuantity = old.quantity;
        data.quantity = old.quantity + data.quantity;
        if old.copper and data.copper then
            data.oldCopper = old.copper;
            data.copper = old.copper + data.copper;
        end
    end

    self.data = data;
    if data.slotType == Def.SLOT_TYPE_ITEM then
        if data.mergedData then
            self:SetMergedItem(data);
        else
            self:SetItem(data);
        end
    elseif data.slotType == Def.SLOT_TYPE_MONEY then
        self:SetMoney(data);
    elseif data.slotType == Def.SLOT_TYPE_REP then
        self:SetReputation(data);
    else
        self:SetCustom(data);
    end
end

function ItemFrame:IsSameItem(data)
    local own = self.data;
    if own and not own.mergedData and not data.mergedData and own.slotType == data.slotType
        and data.slotType ~= Def.SLOT_TYPE_CUSTOM then
        if data.slotType == Def.SLOT_TYPE_MONEY then
            return true
        end
        return own.id == data.id
    end
    return false
end


---------------------------------------------------------------------------
-- Glow (rare items). Plumber rotates a masked spike texture; 3.3.5a has no mask textures, so this is a pulsing
-- additive halo and a slowly turning star around the icon, tinted by quality.
---------------------------------------------------------------------------

local GLOW_COLORS = {
    [1] = {0.8, 0.8, 0.8},
    [2] = {0, 1, 0},
    [3] = {0, 0.5, 1},
    [4] = {0.64, 0.21, 0.93},
    [5] = {1, 0.5, 0},
};

function ItemFrame:CreateGlow()
    local glow = CreateFrame("Frame", nil, self.content);
    glow:SetFrameLevel(self.content:GetFrameLevel() + 1);
    glow:SetWidth(Def.BORDER_SIZE);
    glow:SetHeight(Def.BORDER_SIZE);
    glow:SetPoint("CENTER", self.icon, "CENTER", 0, 0);
    glow:Hide();

    glow.halo = glow:CreateTexture(nil, "OVERLAY");
    glow.halo:SetTexture("Interface\\Buttons\\UI-ActionButton-Border");
    glow.halo:SetBlendMode("ADD");
    glow.halo:SetWidth(Def.BORDER_SIZE * 1.9);
    glow.halo:SetHeight(Def.BORDER_SIZE * 1.9);
    glow.halo:SetPoint("CENTER", glow, "CENTER", 0, 0);

    glow.star = glow:CreateTexture(nil, "OVERLAY");
    glow.star:SetTexture("Interface\\Cooldown\\star4");
    glow.star:SetBlendMode("ADD");
    glow.star:SetWidth(Def.BORDER_SIZE * 1.6);
    glow.star:SetHeight(Def.BORDER_SIZE * 1.6);
    glow.star:SetPoint("CENTER", glow, "CENTER", 0, 0);

    glow.anim = glow:CreateAnimationGroup();
    glow.anim:SetLooping("REPEAT");
    local pulse1 = glow.anim:CreateAnimation("Alpha");
    pulse1:SetChange(-0.5);
    pulse1:SetDuration(1.5);
    pulse1:SetOrder(1);
    local pulse2 = glow.anim:CreateAnimation("Alpha");
    pulse2:SetChange(0.5);
    pulse2:SetDuration(1.5);
    pulse2:SetOrder(2);

    self.glow = glow;
    return glow
end

function ItemFrame:ShowGlow(state)
    if state then
        local glow = self.glow or self:CreateGlow();
        local c = GLOW_COLORS[self.quality or 1] or GLOW_COLORS[1];
        glow.halo:SetVertexColor(c[1], c[2], c[3]);
        glow.star:SetVertexColor(c[1], c[2], c[3]);
        glow:Show();
        glow.anim:Play();
    elseif self.glow then
        self.glow.anim:Stop();
        self.glow:Hide();
    end
end


---------------------------------------------------------------------------
-- Animations (one driver frame each, so they never replace each other's OnUpdate)
---------------------------------------------------------------------------

function ItemFrame:SetContentOffset(offset)
    self.hoverOffset = offset;
    self.content:SetPoint("LEFT", self.body, "LEFT", offset, 0);
end

function ItemFrame:ShowHoverVisual()
    local driver = self.hoverDriver;
    local from = self.hoverOffset or 0;
    local t = 0;
    driver:SetScript("OnUpdate", function(_, elapsed)
        t = t + elapsed;
        if t < HOVER_DURATION then
            self:SetContentOffset(OutQuart(t, from, HOVER_OFFSET - from, HOVER_DURATION));
        else
            self:SetContentOffset(HOVER_OFFSET);
            driver:SetScript("OnUpdate", nil);
        end
    end);
end

function ItemFrame:ResetHoverVisual(instant)
    local driver = self.hoverDriver;
    local from = self.hoverOffset or 0;
    if from == 0 then
        driver:SetScript("OnUpdate", nil);
        return
    end
    if instant then
        driver:SetScript("OnUpdate", nil);
        self:SetContentOffset(0);
        return
    end
    local t = 0;
    driver:SetScript("OnUpdate", function(_, elapsed)
        t = t + elapsed;
        if t < HOVER_DURATION then
            self:SetContentOffset(OutQuart(t, from, -from, HOVER_DURATION));
        else
            self:SetContentOffset(0);
            driver:SetScript("OnUpdate", nil);
        end
    end);
end

-- The item was taken: the row slides to the right while it fades (delay in seconds, for several rows in a row).
function ItemFrame:PlaySlideOutAnimation(delay)
    local driver = self.slideDriver;
    local t = -(delay or 0);
    local alpha = self.body:GetAlpha();
    local offset = self.slideOffset or 0;
    self:ResetHoverVisual(true);
    driver:SetScript("OnUpdate", function(_, elapsed)
        t = t + elapsed;
        if t <= 0 then
            return
        end
        alpha = max(0, alpha - SLIDE_FADE * elapsed);
        offset = offset + SLIDE_SPEED * elapsed;
        self.slideOffset = offset;
        self.body:SetAlpha(alpha);
        self.body:SetPoint("LEFT", self, "LEFT", offset, 0);
        if alpha <= 0 then
            driver:SetScript("OnUpdate", nil);
        end
    end);
end

-- Old count rises out, the new one rises in (Plumber AnimItemCount).
function ItemFrame:AnimateCount(oldValue, newValue)
    local driver = self.countDriver;
    self.count:SetText("+" .. newValue);
    self.dummyCount:SetText("+" .. oldValue);
    self.dummyCount:Show();
    self.count:SetAlpha(0);
    self.dummyCount:SetAlpha(1);
    self.count:ClearAllPoints();
    self.dummyCount:ClearAllPoints();
    local t = 0;
    driver:SetScript("OnUpdate", function(_, elapsed)
        t = t + elapsed;
        local p = (t - COUNT_DELAY) / COUNT_DURATION;
        if p <= 0 then
            self.count:SetPoint("LEFT", self.content, "LEFT", Def.NAME_LEFT, -COUNT_RISE);
            self.dummyCount:SetPoint("LEFT", self.content, "LEFT", Def.NAME_LEFT, 0);
            return
        end
        if p >= 1 then
            self.count:SetAlpha(1);
            self.dummyCount:Hide();
            self.count:ClearAllPoints();
            self.count:SetPoint("LEFT", self.content, "LEFT", Def.NAME_LEFT, 0);
            driver:SetScript("OnUpdate", nil);
            return
        end
        self.count:SetAlpha(p);
        self.dummyCount:SetAlpha(1 - p);
        self.count:ClearAllPoints();
        self.count:SetPoint("LEFT", self.content, "LEFT", Def.NAME_LEFT, -COUNT_RISE * (1 - p));
        self.dummyCount:ClearAllPoints();
        self.dummyCount:SetPoint("LEFT", self.content, "LEFT", Def.NAME_LEFT, COUNT_RISE * p);
    end);
end

-- Money rolls up to the new amount instead of jumping.
function ItemFrame:AnimateMoney(fromCopper, toCopper)
    local driver = self.moneyDriver;
    local t = 0;
    local duration = 0.2;
    driver:SetScript("OnUpdate", function(_, elapsed)
        t = t + elapsed;
        local p = min(1, t / duration);
        local value = floor(fromCopper + (toCopper - fromCopper) * p);
        self.name:SetText(MoneyUtil:GetShortText(value));
        if p >= 1 then
            driver:SetScript("OnUpdate", nil);
        end
    end);
end


---------------------------------------------------------------------------
-- Mouse
---------------------------------------------------------------------------

---@alias ItemFrameInteractionState
---| 0 # Not interactive
---| 1 # Clicks and hover: manual loot window
---| 2 # Hover only (tooltip): loot notification

function ItemFrame:EnableMouseScript(state)
    if state == 1 or state == 2 then
        self:EnableMouse(true);
        self.enableState = state;
    else
        self:EnableMouse(false);
        self.enableState = 0;
    end
end

function ItemFrame:ShowTooltip()
    local data = self.data;
    if not data then
        return
    end
    local tooltip = GameTooltip;
    if self.enableState == 1 then
        if data.slotType == Def.SLOT_TYPE_ITEM and data.slotIndex and data.slotIndex > 0 then
            tooltip:SetOwner(self, "ANCHOR_RIGHT", -Def.FRAME_PADDING, 0);
            tooltip:SetLootItem(data.slotIndex);
        end
    elseif self.enableState == 2 then
        local link = data.mergedData and data.mergedData[1].link or data.link;
        if link then
            tooltip:SetOwner(self, "ANCHOR_RIGHT", -Def.FRAME_PADDING, 0);
            tooltip:SetHyperlink(link);
        end
    end
end

function ItemFrame:OnEnter()
    if self.enableState == 1 then
        self.highlight:Show();
        self:ShowHoverVisual();
    end
    self:ShowTooltip();
    self:RegisterEvent("MODIFIER_STATE_CHANGED");
    self.lootFrame:SetFocused(true);
end

function ItemFrame:OnLeave()
    GameTooltip:Hide();
    self.highlight:Hide();
    self:ResetHoverVisual();
    self:UnregisterEvent("MODIFIER_STATE_CHANGED");
    self.lootFrame:SetFocused(false);
end

function ItemFrame:OnEvent(event)
    if event == "MODIFIER_STATE_CHANGED" then
        if self:IsMouseOver() then
            self:ShowTooltip();     -- Shift toggles the comparison tooltips
        end
    elseif event == "BAG_UPDATE" then
        self:UpdateOwnedCount();
    end
end

function ItemFrame:OnClick(button)
    local data = self.data;
    if not data or self.lootFrame:WasJustDragged() then
        return
    end
    if button == "RightButton" then
        self.lootFrame:CloseFromClick();
        return
    end

    local link = data.mergedData and data.mergedData[1].link or data.link;
    if link and data.slotType == Def.SLOT_TYPE_ITEM then
        if IsModifiedClick("CHATLINK") then
            -- Into the edit box that has the keyboard focus (documented replacement for ChatEdit_InsertLink).
            local focus = GetCurrentKeyBoardFocus();
            if focus and focus.Insert and focus.HasFocus and focus:HasFocus() then
                focus:Insert(link);
                return
            end
        elseif IsModifiedClick("DRESSUP") then
            local dressUp = _G.DressUpItemLink;                 -- FrameXML, not in wow-docs (UNVERIFIED)
            if dressUp then
                dressUp(link);
                return
            end
        end
    end

    if self.enableState == 1 and data.test then
        self.lootFrame:TestTake(self);
    elseif self.enableState == 1 and data.slotIndex and data.slotIndex > 0 then
        LootUI.lastClickedSlot = data.slotIndex;
        LootUI.lastClickedRow = self;
        LootSlot(data.slotIndex);
        self.lootFrame:SetClickedFrameIndex(self.index);
    end
end


---------------------------------------------------------------------------
-- Create / reset
---------------------------------------------------------------------------

local function NewDriver(parent)
    return CreateFrame("Frame", nil, parent)
end

function ItemFrame:Reset()
    self.hoverDriver:SetScript("OnUpdate", nil);
    self.slideDriver:SetScript("OnUpdate", nil);
    self.countDriver:SetScript("OnUpdate", nil);
    self.moneyDriver:SetScript("OnUpdate", nil);
    self.dummyCount:Hide();
    self:SetContentOffset(0);
    self.slideOffset = 0;
    self.body:ClearAllPoints();
    self.body:SetPoint("LEFT", self, "LEFT", 0, 0);
    self.body:SetAlpha(1);
    self.highlight:Hide();
    self:ShowGlow(false);
    self:HideStackedIcons();
    self:UnregisterEvent("MODIFIER_STATE_CHANGED");
    self:UnregisterEvent("BAG_UPDATE");
    self.ownedCount:SetText("");
    self.data = nil;
    self.hasItem = nil;
    self.toAlpha = nil;
    self.index = nil;
    self.quality = nil;
    self.rowWidth = nil;
    self.countWidth = 0;
    ThemeUtil:SetItemOverlay(self.overlay, nil);
    ThemeUtil:SetItemOverlay(self.transmogOverlay, nil);
    self:EnableMouseScript(0);
    self:ClearAllPoints();
    self:Hide();
end

function LootUI.CreateItemFrame(parent, lootFrame)
    local row = CreateFrame("Button", nil, parent);
    addon.API.Mixin(row, ItemFrame);
    row.lootFrame = lootFrame;
    row:SetWidth(Def.ROW_WIDTH);
    row:SetHeight(Def.ROW_HEIGHT);
    row:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    -- A drag on a row moves the whole window (a child that has the mouse does not pass the drag on by itself).
    row:RegisterForDrag("LeftButton");
    row:SetScript("OnDragStart", function() lootFrame:StartDrag() end);
    row:SetScript("OnDragStop", function() lootFrame:StopDrag() end);
    row:Hide();
    local level = row:GetFrameLevel();

    row.nameFont = LootUI.GetFont(NAME_FONT[1], NAME_FONT[2], NAME_FONT[3]);

    local body = CreateFrame("Frame", nil, row);
    body:SetWidth(Def.ROW_WIDTH);
    body:SetHeight(Def.ROW_HEIGHT);
    body:SetPoint("LEFT", row, "LEFT", 0, 0);
    body:SetFrameLevel(level + 1);
    row.body = body;

    row.background = NineSlice:Create(body, ThemeUtil:GetTextureFile(BACKGROUND_FILE), {64, 64}, 16, 16, "BACKGROUND");
    ThemeUtil:BindSlice(row.background, BACKGROUND_FILE);

    -- Hover glow, as the option buttons: stretched back plus a bar on the left.
    local highlight = CreateFrame("Frame", nil, body);
    highlight:SetAllPoints(body);
    highlight:SetFrameLevel(level + 2);
    highlight:Hide();
    highlight.back = NineSlice:CreateEdges(highlight, ThemeUtil:GetTextureFile(HIGHLIGHT_ADD), {128, 64}, 40, 16, 8, 8, "ARTWORK");
    NineSlice:SetBlendMode(highlight.back, "ADD");
    ThemeUtil:BindSlice(highlight.back, HIGHLIGHT_ADD);
    highlight.front = highlight:CreateTexture(nil, "OVERLAY");
    ThemeUtil:BindTexture(highlight.front, HIGHLIGHT_FRONT);
    highlight.front:SetWidth(HIGHLIGHT_FRONT_WIDTH);
    highlight.front:SetPoint("TOPLEFT", body, "TOPLEFT", 0, 0);
    highlight.front:SetPoint("BOTTOMLEFT", body, "BOTTOMLEFT", 0, 0);
    row.highlight = highlight;

    local content = CreateFrame("Frame", nil, body);
    content:SetWidth(Def.ROW_WIDTH);
    content:SetHeight(Def.ROW_HEIGHT);
    content:SetFrameLevel(level + 3);
    row.content = content;
    content:SetPoint("LEFT", body, "LEFT", 0, 0);
    row.hoverOffset = 0;

    local icon = content:CreateTexture(nil, "ARTWORK");
    icon:SetWidth(Def.ICON_SIZE);
    icon:SetHeight(Def.ICON_SIZE);
    icon:SetPoint("CENTER", content, "LEFT", Def.BORDER_SIZE / 2 + 2, 0);
    row.icon = icon;

    local border = content:CreateTexture(nil, "OVERLAY");
    border:SetWidth(Def.BORDER_SIZE);
    border:SetHeight(Def.BORDER_SIZE);
    border:SetPoint("CENTER", icon, "CENTER", 0, 0);
    ThemeUtil:BindTexture(border, BORDER_FILE);
    row.border = border;

    -- Quality corner, transmog marker and the like sit one frame level above the border.
    local top = CreateFrame("Frame", nil, content);
    top:SetAllPoints(content);
    top:SetFrameLevel(content:GetFrameLevel() + 6);
    row.top = top;

    row.overlay = top:CreateTexture(nil, "OVERLAY");
    row.overlay:SetWidth(Def.BORDER_SIZE);
    row.overlay:SetHeight(Def.BORDER_SIZE);
    row.overlay:SetPoint("CENTER", icon, "CENTER", 0, 0);
    row.overlay:Hide();

    row.transmogOverlay = top:CreateTexture(nil, "ARTWORK");
    row.transmogOverlay:SetWidth(Def.BORDER_SIZE + TRANSMOG_GROW);
    row.transmogOverlay:SetHeight(Def.BORDER_SIZE + TRANSMOG_GROW);
    row.transmogOverlay:SetPoint("CENTER", icon, "CENTER", 0, 0);
    row.transmogOverlay:Hide();

    -- Owned count, drawn on top of the border like a stack count.
    row.ownedCount = top:CreateFontString(nil, "OVERLAY");
    local countFont = LootUI.GetFont(OWNED_COUNT_FONT[1], OWNED_COUNT_FONT[2], OWNED_COUNT_FONT[3]);
    local _, countHeight, countFlags = countFont:GetFont();
    countFont:SetFont(COUNT_FONT_FILE, countHeight, countFlags);       -- the later size and outline changes keep the file
    row.ownedCount:SetFontObject(countFont);
    row.ownedCount:SetJustifyH("RIGHT");
    row.ownedCount:SetJustifyV("BOTTOM");
    row.ownedCount:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", -1, 2);

    row.name = content:CreateFontString(nil, "ARTWORK");
    row.name:SetJustifyH("LEFT");
    row.name:SetJustifyV("MIDDLE");
    row.name:SetWordWrap(true);
    row.name:SetSpacing(2);

    row.count = content:CreateFontString(nil, "OVERLAY");
    row.count:SetJustifyH("LEFT");
    row.dummyCount = content:CreateFontString(nil, "OVERLAY");
    row.dummyCount:SetJustifyH("LEFT");
    row.dummyCount:Hide();
    row.countWidth = 0;

    row.hoverDriver = NewDriver(row);
    row.slideDriver = NewDriver(row);
    row.countDriver = NewDriver(row);
    row.moneyDriver = NewDriver(row);

    row:SetScript("OnEnter", row.OnEnter);
    row:SetScript("OnLeave", row.OnLeave);
    row:SetScript("OnClick", row.OnClick);
    row:SetScript("OnEvent", row.OnEvent);
    row:EnableMouseScript(0);

    row:UpdateNameColor();
    addon.CallbackRegistry:Register("LootThemeChanged", function()
        row:UpdateNameColor();
        if row.data and row:IsShown() then
            row:SetData(row.data);      -- the coin file and the transmog sheet follow the theme
        end
    end);
    addon.CallbackRegistry:Register("LootUI.ItemCountSettingChanged", function()
        if row.data and row:IsShown() then
            row:UpdateOwnedCount();
        end
    end);
    addon.CallbackRegistry:Register("TransmogStatusChanged", function(itemID)
        local data = row.data;
        if data and row:IsShown() and (not itemID or data.id == itemID) then
            row:UpdateTransmogMarker();
        end
    end);

    return row
end
