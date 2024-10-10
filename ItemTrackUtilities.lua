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
    Explorer = "hello im an explorer",
    Myth = "hello im a myth",
}

ItemRewardTracks = {
    "Explorer",
    "Adventurer",
    "Veteran",
    "Champion",
    "Hero",
    "Myth"
};

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
    for _, track in ipairs(tracks) do
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

function BIS_EnumerateCharacterPanel()
    -- Iterate through item slots in character panel.
    for _, slot in pairs(ItemSlotNames) do
        local invSlotId = GetInventorySlotInfo(string.upper(slot).."SLOT")
        local itemLink = GetInventoryItemLink('player', invSlotId)
        if itemLink ~= nil then
            local itemId = GetItemInfoFromHyperlink(itemLink) or 0
            local itemName = GetItemInfo(itemId)
            local isBIS = BIS_IsItemBestInSlotItem(itemName)
            if isBIS == true then
                local marker = BIS_ApplyNewIcon(_G["Character"..slot.."Slot"])
                table.insert(BISCharacterFrames, marker)
            end
        end
    end
end