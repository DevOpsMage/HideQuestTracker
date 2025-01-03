-- Initialize saved variables
HideQuestTrackerDB = HideQuestTrackerDB or { enabled = true }

local frame = CreateFrame("Frame")
local activeTicker = nil -- Reference for the ticker
local lastTrackerState = nil -- Cache last state to avoid redundant operations

local function HideQuestTracker()
    -- Avoid hiding if already hidden
    if QuestWatchFrame and QuestWatchFrame:IsVisible() then
        QuestWatchFrame:Hide()
        if lastTrackerState ~= "hidden" then
            print("Quest tracker hidden.")
            lastTrackerState = "hidden" -- Cache the state
        end
    end
end

local function ShowQuestTracker()
    -- Avoid showing if already visible
    if QuestWatchFrame and not QuestWatchFrame:IsVisible() then
        QuestWatchFrame:Show()
        if lastTrackerState ~= "shown" then
            print("Quest tracker shown.")
            lastTrackerState = "shown" -- Cache the state
        end
    end
end

local function ToggleAddon(enable)
    HideQuestTrackerDB.enabled = enable
    if enable then
        print("HideQuestTracker enabled. The quest tracker will be hidden.")
        HideQuestTracker()
        -- Start ticker if not already running
        if not activeTicker then
            activeTicker = C_Timer.NewTicker(5, HideQuestTracker)
        end
    else
        print("HideQuestTracker disabled. The quest tracker will be shown.")
        ShowQuestTracker()
        -- Stop the ticker if running
        if activeTicker then
            activeTicker:Cancel()
            activeTicker = nil
        end
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
        C_Timer.After(10, function()
            if HideQuestTrackerDB.enabled then
                HideQuestTracker()
                -- Ensure only one ticker runs
                if not activeTicker then
                    activeTicker = C_Timer.NewTicker(5, HideQuestTracker)
                end
            end
        end)
    end
end)
