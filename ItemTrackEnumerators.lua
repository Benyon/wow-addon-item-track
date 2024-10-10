--- Checks the bag frame for items with ranks and applies an icon to them.
function ItemTrack_EnumerateInventory()
    local combinedBagsFrame = _G["ContainerFrameCombinedBags"];
    local bagFrames = {combinedBagsFrame:GetChildren()};
    ItemTrack_ClearFrames();

    for _, itemButton in ipairs(bagFrames) do
        local frameIsBagSlot, id = ItemTrack_IsFrameABagSlot(itemButton);

        if (frameIsBagSlot and id) then
            local hasBagSlotGotItem, itemLink = ItemTrack_GetBagSlotItemIfExists(itemButton);

            if (hasBagSlotGotItem) then
                local canItemBeMarked, rank = ItemTrack_CanItemBeMarkedWithAnIcon(itemLink);

                if (canItemBeMarked) then
                    ItemTrack_BagFrames[id] = {
                        item = itemLink,
                        rank = rank,
                        parentFrame = itemButton,
                        onEnterFunction = itemButton:GetScript('OnEnter');
                        onLeaveFunction = itemButton:GetScript('OnLeave');
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
                local characterSlot = _G["Character"..slot.."Slot"];
                ItemTrack_CharacterFrames[invSlotId] = {
                    item = itemLink,
                    rank = rank,
                    parentFrame = characterSlot,
                    onEnterFunction = characterSlot:GetScript('OnEnter'),
                    onLeaveFunction = characterSlot:GetScript('OnLeave'),
                }
                local iconFrame = ItemTrack_ApplyIcon(ItemTrack_CharacterFrames[invSlotId]);
                ItemTrack_CharacterFrames[invSlotId].iconFrame = iconFrame;
            end
        end
    end
end