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

ItemRewardTrackAtlasIds = {
    -- Crafted = 'todo',
    -- Explorer = "no icon for this.",
    Adventurer = "Professions-Icon-Quality-Tier1-Inv",
    Veteran = "Professions-Icon-Quality-Tier2-Inv",
    Champion = "Professions-Icon-Quality-Tier3-Inv",
    Hero = "Professions-Icon-Quality-Tier4-Inv",
    Myth = "Professions-Icon-Quality-Tier5-Inv",
}

--- Get a list of the reward tracks.
ItemRewardTracks = {}
for key, _ in pairs(ItemRewardTrackAtlasIds) do
    table.insert(ItemRewardTracks, key)
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

      if (isOnRewardTrack) then
          local rewardTrackName = ItemTrack_GetRewardTrackFromToolTipLine(text)
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
    local isBagSlot = string.match(frameName, "ContainerFrameCombinedBags%.[a-f0-9]+");
    if (not isBagSlot) then return nil end

    local id = string.match(frameName, "%.([a-f0-9]+)$");
    return true, id;
end
