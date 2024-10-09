ItemTrack = LibStub('AceAddon-3.0'):NewAddon("BisAlert", "AceConsole-3.0", "AceEvent-3.0")
ItemTrack_BagFrames = {} -- Table for bag frames.
ItemTrack_CharacterFrames = {} -- Table for character panel frames.

function ItemTrack:OnInitialize()
	self:RegisterChatCommand("itemtrack", "SlashCommand");
    print(WrapInPink('ItemTrack has loaded.'));
end

function ItemTrack:OnEnable()
	self:RegisterEvent("BAG_UPDATE");
    self:RegisterEvent("UNIT_INVENTORY_CHANGED");
    _G["ContainerFrameCombinedBags"]:SetScript("OnShow", ItemTrack_EnumerateInventory);
end

function ItemTrack:BAG_UPDATE()
end

function ItemTrack:UNIT_INVENTORY_CHANGED(_, unit)
    if (unit == "player") then
        -- Iterate through frames again.
    end
end

CharacterFrame:HookScript('OnShow', function ()
    ItemTrack_ClearFrames()
    ItemTrack_EnumerateInventory()
end)