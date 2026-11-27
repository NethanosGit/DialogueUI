local _, addon = ...;

-- Settings > Audio: fades the sound, music and ambience volumes down while the dialogue or a readable is open, and back
-- to the player's own volumes when it closes. Not in retail.
-- The volumes are game CVars, saved with the game's settings, so what is lowered is put back at logout, and a copy is
-- kept in the saved variables for a session that ended without a logout.

local CallbackRegistry = addon.CallbackRegistry;
local GetDBValue = addon.GetDBValue;
local GetDBBool = addon.GetDBBool;

local GetCVar = GetCVar;
local SetCVar = SetCVar;
local pairs = pairs;
local ipairs = ipairs;
local abs = math.abs;
local floor = math.floor;

local UPDATE_INTERVAL = 0.05;
local EPSILON = 0.005;          -- smaller differences are the CVar's rounding, not someone moving a slider

local CHANNELS = {
    {key = "Sound", cvar = "Sound_SFXVolume"},
    {key = "Music", cvar = "Sound_MusicVolume"},
    {key = "Ambience", cvar = "Sound_AmbienceVolume"},
};

local ChannelByKey = {};
for _, channel in ipairs(CHANNELS) do
    ChannelByKey[channel.key] = channel;
end

local AudioFade = {};
addon.AudioFade = AudioFade;

-- A channel has `original` (the player's volume) only while we hold it.
-- On WorldFrame: hiding UIParent (Hide UI) must not stop the OnUpdate.
local driver = CreateFrame("Frame", nil, WorldFrame);
driver:Hide();

local function Read(channel)
    return tonumber(GetCVar(channel.cvar)) or 1
end

local function Write(channel, value)
    SetCVar(channel.cvar, value);
    channel.applied = Read(channel);
end

-- The Spoken addon lowers other volumes while it speaks (its OtherSounds.lua).
local function GetSpokenOriginal(key)
    local env = _G.SpokenEnv;
    local others = env and env.OtherSounds;
    local original = others and others.original;
    if original then
        if key == "Sound" then
            return original.SFX
        end
        return original[key]
    end
end

-- On 3.3.5a Spoken plays its voices on the music channel (on by default) and saves and restores that volume itself.
-- Changing it too would mute the voice or leave the music volume lowered for good, so music is left to Spoken then.
function AudioFade:IsMusicUsedBySpoken()
    local env = _G.SpokenEnv;
    local spoken = env and env.Addon;
    local audio = spoken and spoken.db and spoken.db.profile and spoken.db.profile.Audio;
    local music = audio and audio.LegacyMusicChannel;
    return (music and music.Enabled) and true or false
end

-- The volume (0..1) the player has chosen, whoever has lowered the channel at the moment.
function AudioFade:GetPlayerVolume(key)
    local channel = ChannelByKey[key];
    return channel.original or GetSpokenOriginal(key) or Read(channel)
end

local function SaveBackup()
    local backup;
    for _, channel in ipairs(CHANNELS) do
        if channel.original then
            backup = backup or {};
            backup[channel.cvar] = channel.original;
        end
    end
    addon.SetDBValue("AudioFadeBackup", backup);
end

local function Forget(channel)
    channel.original, channel.applied, channel.target, channel.from = nil, nil, nil, nil;
end

-- A held channel that is no longer at what we set was moved by the player: it is theirs again. A change made by
-- Spoken does not count, or the volume would stay low after Spoken is done.
local function ReleaseIfMoved(channel)
    if channel.original and abs(Read(channel) - channel.applied) > EPSILON and not GetSpokenOriginal(channel.key) then
        Forget(channel);
        return true
    end
end

local function Finish(channel)
    local restored = channel.target == channel.original;
    Write(channel, channel.target);
    channel.from = nil;
    if restored then
        Forget(channel);
        return true
    end
end

local function OnUpdate(self, elapsed)
    self.t = self.t + elapsed;
    if self.t < UPDATE_INTERVAL then return end;
    local delta = self.t;
    self.t = 0;

    local fading, released = false, false;
    for _, channel in ipairs(CHANNELS) do
        if channel.from then
            if ReleaseIfMoved(channel) then
                released = true;
            else
                channel.elapsed = channel.elapsed + delta;
                if channel.elapsed >= channel.duration then
                    released = Finish(channel) or released;
                else
                    Write(channel, channel.from + (channel.target - channel.from) * channel.elapsed / channel.duration);
                    fading = true;
                end
            end
        end
    end

    if released then
        SaveBackup();
    end
    if not fading then
        self:Hide();
    end
end
driver:SetScript("OnUpdate", OnUpdate);

local function FadeTo(channel, target)
    if channel.from and channel.target == target then return end;     -- already on the way
    channel.target = target;
    channel.from = Read(channel);
    channel.elapsed = 0;
    channel.duration = GetDBValue("AudioFade_" .. channel.key .. "Duration") or 0;
    if channel.duration <= 0 or abs(channel.from - target) <= EPSILON then
        Finish(channel);
    else
        driver.t = 0;
        driver:Show();
    end
end

-- The Move Position samples are layout aids, not something being read.
local function IsReading()
    local dialogue = addon.DialogueUI;
    if dialogue and dialogue.frame and dialogue.frame:IsVisible() and not dialogue:IsEditMode() then
        return true
    end
    local book = addon.Book;
    local bookFrame = book and book:GetFrame();
    if bookFrame and bookFrame:IsVisible() and not book:IsEditMode() then
        return true
    end
    return false
end

-- Brings every channel to where it belongs now.
function AudioFade:Update()
    local active = GetDBBool("EnableAudioFading") and IsReading();

    for _, channel in ipairs(CHANNELS) do
        ReleaseIfMoved(channel);

        local target;
        if active and not (channel.key == "Music" and self:IsMusicUsedBySpoken()) then
            local percent = GetDBValue("AudioFade_" .. channel.key .. "Volume");     -- -1: not chosen, left alone
            if percent and percent >= 0 then
                local volume = self:GetPlayerVolume(channel.key);
                if percent / 100 < volume - EPSILON then
                    target = percent / 100;
                    if not channel.original then
                        channel.original = volume;
                        channel.applied = Read(channel);
                    end
                end
            end
        end

        if channel.original then
            FadeTo(channel, target or channel.original);
        end
    end

    SaveBackup();
end

-- Back to the player's volumes at once.
function AudioFade:RestoreNow()
    for _, channel in ipairs(CHANNELS) do
        ReleaseIfMoved(channel);
        if channel.original then
            SetCVar(channel.cvar, channel.original);
            Forget(channel);
        end
    end
    driver:Hide();
    SaveBackup();
end


local function Update()
    AudioFade:Update();
end

CallbackRegistry:Register("ParchmentShown", Update);
CallbackRegistry:Register("ParchmentHidden", Update);
CallbackRegistry:Register("BookShown", Update);
CallbackRegistry:Register("BookHidden", Update);

-- A change in the Settings applies at once to what is open.
local function OnSettingChanged(_, userInput)
    if userInput then
        AudioFade:Update();
    end
end

CallbackRegistry:Register("SettingChanged.EnableAudioFading", OnSettingChanged);
for _, channel in ipairs(CHANNELS) do
    CallbackRegistry:Register("SettingChanged.AudioFade_" .. channel.key .. "Volume", OnSettingChanged);
end

-- Volumes a previous session lowered and never put back. After PLAYER_LOGIN, where Spoken puts back its own copy,
-- which may hold a volume we had lowered.
CallbackRegistry:Register("PLAYER_ENTERING_WORLD", function()
    local backup = GetDBValue("AudioFadeBackup");
    if type(backup) ~= "table" then return end;
    for _, channel in ipairs(CHANNELS) do
        local value = tonumber(backup[channel.cvar]);
        if value and not channel.original then
            SetCVar(channel.cvar, floor(value * 1000 + 0.5) / 1000);
        end
    end
    SaveBackup();
end);

-- Also fires on /reload, before the client saves its CVars.
driver:RegisterEvent("PLAYER_LOGOUT");
driver:SetScript("OnEvent", function()
    AudioFade:RestoreNow();
end);
