-- Frame storage object.
ItemTrack_BagFrames = {};
ItemTrack_CharacterFrames = {};

-- Addon Core
ItemTrack = LibStub('AceAddon-3.0'):NewAddon(
    "ItemTrack",
    "AceConsole-3.0",
    "AceEvent-3.0"
);

-- When the addon is loaded.
function ItemTrack:OnInitialize()
	self:RegisterChatCommand("itemtrack", "SlashCommand"); -- TODO

    function ItemTrack:OnEnable()
        self:RegisterEvent("BAG_UPDATE");
        self:RegisterEvent("UNIT_INVENTORY_CHANGED");

    end
    Log('ItemTrack has loaded.');
end

-- When an item is moved, added or removes from the bag.
function ItemTrack:BAG_UPDATE()
    ItemTrack_EnumerateInventory();
end

--- When the player equips or unequips an item. (excludes rings and trinkets)
function ItemTrack:UNIT_INVENTORY_CHANGED(_, unit)
    if (unit ~= "player") then return end
    ItemTrack_EnumerateInventory()
end

--- When a user does `/itemtrack`
function ItemTrack:SlashCommand()

    Log('Outputting ItemTrack_BagFrames ---------');
    for key, value in pairs(ItemTrack_BagFrames) do
        Log('Key: ' .. key);
        Log('    parentFrame: ' .. (value.parentFrame:GetDebugName() or 'unknown'));
        Log('    rank: ' .. (value.rank or 'unknown'));
        Log('    iconFrame: ' .. (value.iconFrame:GetDebugName() or 'unknown'));
    end
    Log('--------- End');
    
end

--- When the player opens the character panel.
CharacterFrame:HookScript("OnShow", function ()
    Log("TODO - ItemTrack_EnumerateCharacterPanel");
end)

--- When the player opens the combined bags window.
ContainerFrameCombinedBags:HookScript("OnShow", function ()
    ItemTrack_EnumerateInventory()
end);

