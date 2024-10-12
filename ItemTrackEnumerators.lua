--- Checks the bag frame for items with ranks and applies an icon to them.
local function bagCheck(params)
    local frame = params.frameToEnumerate;
    local frameTable = params.whereToStoreFrames;

    local bagFrames = {frame:GetChildren()};
    for _, itemButton in ipairs(bagFrames) do
        local frameIsBagSlot, id = ItemTrack_IsFrameABagSlot(itemButton);

        if (frameIsBagSlot and id) then
            local hasBagSlotGotItem, itemLink = ItemTrack_GetBagSlotItemIfExists(itemButton);

            if (hasBagSlotGotItem) then
                local canItemBeMarked, rank = ItemTrack_CanItemBeMarkedWithAnIcon(itemLink);

                if (canItemBeMarked) then
                    frameTable[id] = {
                        item = itemLink,
                        rank = rank,
                        parentFrame = itemButton,
                        onEnterFunction = itemButton:GetScript('OnEnter');
                        onLeaveFunction = itemButton:GetScript('OnLeave');
                    }
                    local iconFrame = ItemTrack_ApplyIcon(frameTable[id]);
                    frameTable[id].iconFrame = iconFrame;
                end
            end
        end
    end
end

function ItemTrack_CombinedBags()
    if (not ContainerFrameCombinedBags:IsVisible()) then return end;
    bagCheck({
        frameToEnumerate = ContainerFrameCombinedBags,
        whereToStoreFrames = ItemTrack_CombinedBagFrames
    });
end

--- Checks the bag frames for items with ranks and applies an icon to them.
function ItemTrack_NonCombinedBags(containerFrame, frameTable)
    if (not containerFrame:IsVisible()) then return end;
    bagCheck({
        frameToEnumerate = containerFrame,
        whereToStoreFrames = frameTable
    });
end

--- Checks the character panel for items with ranks and applies an icon to them.
function ItemTrack_EnumerateCharacter()
    if (not CharacterFrame:IsVisible()) then return end;

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

-- TODO: Bank frames.
-- May be worth removing the wait for frames and iteratively add the events in the itemtrack.lua