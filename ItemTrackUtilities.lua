ItemSlotNames = {
    "MainHand",
    "SecondaryHand",
    "Head",
    "Neck",
    "Shoulder",
    "Back",
    "Chest",
    "Wrist",
    "Hands",
    "Waist",
    "Legs",
    "Feet",
    "Finger1",
    "Finger0",
    "Trinket1",
    "Trinket0"
}

--- All tracks need to be here.
ItemRewardIconInfo = {
    Explorer = {
        atlasId = "No icon for this.",
        size = { width = 0, height = 0 },
        offset = { x = 0, y = 0},
        show = false,
    },
    Crafted = {
        atlasId = "Repair",
        size = { width = 19, height = 18 },
        offset = { x = -12, y = 12},
        show = true,
    },
    Adventurer = {
        atlasId = "Professions-Icon-Quality-Tier1-Inv",
        size = { width = 34, height = 28 },
        offset = { x = -4, y = 7},
        show = true,
    },
    Veteran = {
        atlasId = "Professions-Icon-Quality-Tier2-Inv",
        size = { width = 34, height = 28 },
        offset = { x = -4, y = 7},
        show = true,
    },
    Champion = {
        atlasId = "Professions-Icon-Quality-Tier3-Inv",
        size = { width = 34, height = 28 },
        offset = { x = -4, y = 7},
        show = true,
    },
    Hero = {
        atlasId = "Professions-Icon-Quality-Tier4-Inv",
        size = { width = 34, height = 28 },
        offset = { x = -4, y = 7},
        show = true,
    },
    Myth = {
        atlasId = "Professions-Icon-Quality-Tier5-Inv",
        size = { width = 34, height = 28 },
        offset = { x = -4, y = 7},
        show = true,
    }
}

--- Get a list of the reward tracks.
ItemRewardTracks = {}
for key, _ in pairs(ItemRewardIconInfo) do
    table.insert(ItemRewardTracks, key)
end

function WaitForFrameVisibility(containerFrameName, timeout, ifVisibleFn)
    local startTime = GetTime() -- Start time.
    local checkInterval = 0.005 -- Check every 0.1 seconds.

    local function check()
        local containerFrame = _G[containerFrameName]
        if (containerFrame and (containerFrame:IsVisible())) then
            ifVisibleFn(containerFrame);  -- Run the action if we find it.
        elseif GetTime() - startTime >= timeout then return; -- Cancel the check.
        else C_Timer.After(checkInterval, check) end -- Reschedual another check.
    end

    -- Start the checking process
    C_Timer.After(checkInterval, check)
end

--- Brand colour logging.
function Log(...)
    local args = {...}
    local text = table.concat(args, " ")
    print("|c0d49d6D6"..text)
end

--- Get length of table.
function TableLength(table)
    local count = 0
    for _ in pairs(table) do count = count + 1 end
    return count
end

function ItemTrack_GetBagSlotItemIfExists(frame)
    if (frame.GetItemInfo == nil) then return false end
    return pcall(function ()
        local itemLink = frame:GetItemInfo()
        if (itemLink ~= nil) then
            return itemLink
        end
    end)
end

function ItemTrack_CanItemBeMarkedWithAnIcon(itemLink)
    local tooltipData = C_TooltipInfo.GetHyperlink(itemLink)
    if not tooltipData or not tooltipData.lines then return end

    for _, line in ipairs(tooltipData.lines) do
        local text = line.leftText;
        local isOnRewardTrack = string.find(text, "Upgrade Level:");
        local isOmenCrafted = string.sub(StripColourCodes(text), -7) == "Crafted";

        if (isOnRewardTrack or isOmenCrafted) then
            local rewardTrackName = ItemTrack_GetRewardTrackFromToolTipLine(StripColourCodes(text))

            return true, rewardTrackName;
        end
    end
end

function ItemTrack_GetRewardTrackFromToolTipLine(text)
    for _, track in ipairs(ItemRewardTracks) do
        if string.find(text, track) then
            return track;
        end
    end
    return nil;
end

function ItemTrack_IsFrameABagSlot(frame)
    local frameName = frame:GetDebugName();
    local isBagSlot = string.match(frameName, "ContainerFrame%d%.[a-f0-9]+");
    local isCombinedBagSlot = string.match(frameName, "ContainerFrameCombinedBags%.[a-f0-9]+");
    if (not isBagSlot and not isCombinedBagSlot) then return nil end

    local id = string.match(frameName, "%.([a-f0-9]+)$");
    return true, id;
end
