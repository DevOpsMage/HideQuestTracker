-- Initialize saved variables
HideQuestTrackerDB = HideQuestTrackerDB or { enabled = true }

local frame = CreateFrame("Frame")
local lastTrackerState = nil -- Cache last state to avoid redundant chat spam
local hooksInstalled = false

local function GetTrackerFrame()
    -- Classic Era / Forever use QuestWatchFrame; some clients use WatchFrame or ObjectiveTrackerFrame
    return QuestWatchFrame or WatchFrame or ObjectiveTrackerFrame
end

local function HideQuestTracker()
    local tracker = GetTrackerFrame()
    if tracker and tracker:IsShown() then
        tracker:Hide()
        if lastTrackerState ~= "hidden" then
            print("Quest tracker hidden.")
            lastTrackerState = "hidden"
        end
    elseif tracker and lastTrackerState ~= "hidden" then
        -- Already hidden (e.g. OnShow re-hide); keep cache in sync without chat spam
        lastTrackerState = "hidden"
    end
end

local function ShowQuestTracker()
    local tracker = GetTrackerFrame()
    if tracker and not tracker:IsShown() then
        tracker:Show()
        if lastTrackerState ~= "shown" then
            print("Quest tracker shown.")
            lastTrackerState = "shown"
        end
    end
end

-- Re-hide immediately when Blizzard shows the tracker after quest progress updates
local function EnforceHidden()
    if HideQuestTrackerDB.enabled then
        HideQuestTracker()
    end
end

local function InstallHooks()
    if hooksInstalled then
        return
    end

    local tracker = GetTrackerFrame()
    if not tracker then
        return
    end

    -- Catch Show() from Blizzard UI (quest kills, looting, accepts, discoveries, etc.)
    tracker:HookScript("OnShow", function()
        EnforceHidden()
    end)

    -- QuestWatch_Update rebuilds and shows the tracker on Classic Era / Forever
    if type(QuestWatch_Update) == "function" then
        hooksecurefunc("QuestWatch_Update", EnforceHidden)
    end

    -- WatchFrame_Update on some Classic clients
    if type(WatchFrame_Update) == "function" then
        hooksecurefunc("WatchFrame_Update", EnforceHidden)
    end

    -- ObjectiveTracker_Update when ObjectiveTrackerFrame is present
    if type(ObjectiveTracker_Update) == "function" then
        hooksecurefunc("ObjectiveTracker_Update", EnforceHidden)
    end

    hooksInstalled = true
end

local function ToggleAddon(enable)
    HideQuestTrackerDB.enabled = enable
    if enable then
        print("HideQuestTracker enabled. The quest tracker will be hidden.")
        InstallHooks()
        HideQuestTracker()
    else
        print("HideQuestTracker disabled. The quest tracker will be shown.")
        ShowQuestTracker()
    end
end

local function SlashCommandHandler(msg)
    if msg == "on" then
        ToggleAddon(true)
    elseif msg == "off" then
        ToggleAddon(false)
    elseif msg == "mem" then
        UpdateAddOnMemoryUsage()
        local usage = GetAddOnMemoryUsage("HideQuestTracker")
        print(string.format("HideQuestTracker memory usage: %.2f KB", usage))
    else
        print("Usage: /hqt on|off|mem")
        print("Current status: " .. (HideQuestTrackerDB.enabled and "enabled" or "disabled"))
    end
end

SLASH_HIDEQUESTTRACKER1 = "/hqt"
SlashCmdList["HIDEQUESTTRACKER"] = SlashCommandHandler

-- PLAYER_LOGIN event handler
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        InstallHooks()
        if HideQuestTrackerDB.enabled then
            -- Brief delay so Blizzard can finish initial layout; OnShow hooks keep it hidden after that
            C_Timer.After(0.5, function()
                if HideQuestTrackerDB.enabled then
                    HideQuestTracker()
                end
            end)
        end
    end
end)
