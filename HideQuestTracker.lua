-- Initialize saved variables
HideQuestTrackerDB = HideQuestTrackerDB or { enabled = true }

local function HideQuestTracker()
    if HideQuestTrackerDB.enabled and QuestWatchFrame and QuestWatchFrame:IsVisible() then
        QuestWatchFrame:Hide()
        print("Quest tracker hidden.")
    end
end

local function ShowQuestTracker()
    if QuestWatchFrame and not QuestWatchFrame:IsVisible() then
        QuestWatchFrame:Show()
        print("Quest tracker shown.")
    end
end

local function ToggleAddon(enable)
    HideQuestTrackerDB.enabled = enable
    if enable then
        print("HideQuestTracker enabled. The quest tracker will be hidden.")
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
    else
        print("Usage: /hqt on|off")
        print("Current status: " .. (HideQuestTrackerDB.enabled and "enabled" or "disabled"))
    end
end

SLASH_HIDEQUESTTRACKER1 = "/hqt"
SlashCmdList["HIDEQUESTTRACKER"] = SlashCommandHandler

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        C_Timer.After(10, function()
            if HideQuestTrackerDB.enabled then
                HideQuestTracker()
            end
            C_Timer.NewTicker(5, HideQuestTracker)
        end)
    end
end)