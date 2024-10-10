--- Checks the bag frame for items with ranks and applies an icon to them.
function ItemTrack_EnumerateInventory()
    local combinedBagsFrame = _G["ContainerFrameCombinedBags"];
    local bagFrames = {combinedBagsFrame:GetChildren()};
    ItemTrack_ClearFrames();

    for _, frame in ipairs(bagFrames) do
        local frameIsBagSlot, id = ItemTrack_IsFrameABagSlot(frame);

        if (frameIsBagSlot and id) then
            local hasBagSlotGotItem, itemLink = ItemTrack_GetBagSlotItemIfExists(frame);

            if (hasBagSlotGotItem) then
                local canItemBeMarked, rank = ItemTrack_CanItemBeMarkedWithAnIcon(itemLink);

                if (canItemBeMarked) then
                    ItemTrack_BagFrames[id] = {
                        item = itemLink,
                        rank = rank,
                        parentFrame = frame,
                    }
                    local iconFrame = ItemTrack_ApplyIcon(ItemTrack_BagFrames[id]);
                    ItemTrack_BagFrames[id].iconFrame = iconFrame;
                end
            end
        end
    end
end

--- Checks the character panel for items with ranks and applies an icon to them.
function ItemTrack_EnumerateCharacter()
    for _, slot in pairs(ItemSlotNames) do
        local invSlotId = GetInventorySlotInfo(string.upper(slot).."SLOT");
        local itemLink = GetInventoryItemLink('player', invSlotId);
        if (itemLink ~= nil) then
            local canItemBeMarked, rank = ItemTrack_CanItemBeMarkedWithAnIcon(itemLink);

            if (canItemBeMarked) then
                ItemTrack_CharacterFrames[invSlotId] = {
                    item = itemLink,
                    rank = rank,
                    parentFrame = _G["Character"..slot.."Slot"],
                }
                local iconFrame = ItemTrack_ApplyIcon(ItemTrack_CharacterFrames[invSlotId]);
                ItemTrack_CharacterFrames[invSlotId].iconFrame = iconFrame;
            end
        end
    end
end