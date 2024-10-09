function WrapInPink(text)
    return "|cffDA70D6"..text
end

function GetListOfItemSlots()
    return {
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
end

function BIS_EnumerateInventory()
    if BISOptions_ShowIcons == 'enabled' then
        local f = _G["ContainerFrameCombinedBags"]
        local children = {f:GetChildren()}
        for _, frame in ipairs(children) do
            -- If the frame is a combined bags item
            local frameName = frame:GetDebugName()
            if (string.match(frameName, "ContainerFrameCombinedBags%.[a-f0-9]+")) then
                -- See if there's an item in the slot
                if (frame.GetItemInfo ~= nil) then
                    -- Try risky move.
                    local success, result = pcall(function ()
                        local itemLink = frame:GetItemInfo()
                        if (itemLink ~= nil) then
                            return itemLink
                        end
                    end)

                    if success then
                        -- Found an item in a slot
                        local itemId = GetItemInfoFromHyperlink(result) or 0
                        local itemName = GetItemInfo(itemId)
                        local isBIS = BIS_IsItemBestInSlotItem(itemName)
                        if isBIS == true then
                            local marker = BIS_ApplyNewIcon(frame)
                            table.insert(BISFrames, marker)
                        end
                    end
                end
            end
        end

        -- Iterate through item slots in character panel.
        for _, slot in pairs(GetListOfItemSlots()) do
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
end