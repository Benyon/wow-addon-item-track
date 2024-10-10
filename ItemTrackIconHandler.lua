local function applyIcon(bagFrameTableEntry)
    -- Don't duplicate frames.
    if (bagFrameTableEntry.iconFrame ~= nil) then
        bagFrameTableEntry.iconFrame:Show();
        return;
    end

    -- Create a frame and return it.
    local f = CreateFrame("Frame", nil, bagFrameTableEntry.parentFrame)
    f:SetFrameStrata("TOOLTIP")
    f:SetWidth(34)
    f:SetHeight(28)
    f:SetAlpha(1)

    local t = f:CreateTexture(nil, "OVERLAY")
    t:SetAtlas('Professions-Icon-Quality-Tier5-Inv')
    t:SetAllPoints(f)
    f.texture = t

    f:SetPoint("CENTER", -4, 7)
    f:Show();
    return f;
end

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
                    Log('Item has been found that can be upgraded.', itemLink, rank);

                    ItemTrack_BagFrames[id] = {
                        rank = rank,
                        parentFrame = frame
                    }

                    ItemTrack_BagFrames[id].iconFrame = applyIcon(ItemTrack_BagFrames[id]);
                end
            end
        end
    end

    Log('There is now a total of ' .. TableLength(ItemTrack_BagFrames) .. ' frames.')
end

function ItemTrack_ClearFrames()
    local function clearFrames(frames)
        if (not frames) then return end
        for _, itemIconInfo in pairs(frames) do
            if (itemIconInfo.iconFrame ~= nil) then
                print('Found an icon to hide ' .. itemIconInfo.iconFrame:GetDebugName())
                itemIconInfo.iconFrame:Hide();
            end
        end
    end
    clearFrames(ItemTrack_BagFrames)
    clearFrames(ItemTrack_CharacterFrames)
end