-- Frame storage object.
ItemTrack_CharacterFrames = {};
ItemTrack_CombinedBagFrames = {};
ItemTrack_ContainerBagFrames = {
    ContainerFrame1 = {},
    ContainerFrame2 = {},
    ContainerFrame3 = {},
    ContainerFrame4 = {},
    ContainerFrame5 = {},
    ContainerFrame6 = {}
};

local helpMessage = [[
ItemTrack.

/itemtrack debug -- Dumps out a bunch of useful information if the developer needs it.
/itemtrack opacity <number> -- Sets the fade opacity of the applied icons.

]];

-- Addon Core
ItemTrack = LibStub('AceAddon-3.0'):NewAddon(
    "ItemTrack",
    "AceConsole-3.0",
    "AceEvent-3.0"
);

-- Table to store command definitions
ItemTrack.commands = {
    opacity = function (value)
        local num = tonumber(value)
        if (num and (num >= 0) and (num <= 1)) then
            ItemTrack_IconFadeAmount = num
            Log('Opacity is set to ' .. ItemTrack_IconFadeAmount)
        else
            Log('Invalid opacity value. Please provide a number between 0 and 1.')
        end
    end;
    debug = function ()

        local function outputItemTrackFrames(table, context)
            if (TableLength(table) == 0) then
                Log('No "'.. context .. '" entries detected');
            else
                for key, info in pairs(table) do
                    Log('Key: ' .. key);
                    Log('    item: ' .. (info.item or 'unknown'));
                    Log('    parentFrame: ' .. (info.parentFrame:GetDebugName() or 'unknown'));
                    Log('    rank: ' .. (info.rank or 'unknown'));
                    Log('    iconFrame: ' .. (info.iconFrame:GetDebugName() or 'unknown'));
                    Log('');
                end
            end
            Log('Frame "' .. context .. '" has ' .. tostring(TableLength(table)) .. ' entries');
        end

        outputItemTrackFrames(ItemTrack_CombinedBagFrames, 'bag');
        outputItemTrackFrames(ItemTrack_CharacterFrames, 'character');
        Log('Opacity is set to ' .. ItemTrack_IconFadeAmount);

    end
}

-- When the addon is loaded.
function ItemTrack:OnInitialize()
	self:RegisterChatCommand("itemtrack", "SlashCommand");
	self:RegisterChatCommand("it", "SlashCommand");

    -- Default variables.
    if (ItemTrack_IconFadeAmount == nil) then
        ItemTrack_IconFadeAmount = 0.5;
    end

    function ItemTrack:OnEnable()
        self:RegisterEvent("BAG_UPDATE");
        self:RegisterEvent("UNIT_INVENTORY_CHANGED");

    end
    Log('ItemTrack has loaded.');
end

-- When an item is moved, added or removes from the bag.
function ItemTrack:BAG_UPDATE(_, bagId)
    local containerId = tostring(bagId + 1);
    local containerName = "ContainerFrame" .. containerId;
    ItemTrack_ClearFrames(
        ItemTrack_CharacterFrames,
        ItemTrack_CombinedBagFrames,
        ItemTrack_ContainerBagFrames[containerName]
    );
    ItemTrack_CombinedBags();
    ItemTrack_NonCombinedBags(_G[containerName], ItemTrack_ContainerBagFrames[containerName]);
    ItemTrack_EnumerateCharacter();
end

--- When the player equips or unequips an item. (excludes rings and trinkets)
function ItemTrack:UNIT_INVENTORY_CHANGED(_, unit)
    if (unit ~= "player") then return end
    ItemTrack_ClearFrames(ItemTrack_CharacterFrames, ItemTrack_CombinedBagFrames);
    ItemTrack_CombinedBags();
    ItemTrack_EnumerateCharacter();
end

--- When a user does `/itemtrack`
function ItemTrack:SlashCommand(input)
    local commandName, value = input:match("^(%S+)%s*(.*)$")  -- Match command and value

    if commandName and self.commands[commandName] then
        self.commands[commandName](value);
    else
        Log(helpMessage);
    end
end

--- When the player opens the character panel.
CharacterFrame:HookScript("OnShow", function ()
    ItemTrack_ClearFrames(ItemTrack_CharacterFrames);
    ItemTrack_EnumerateCharacter();
end);

--- When the player opens the combined bags window.
ContainerFrameCombinedBags:HookScript("OnShow", function ()
    ItemTrack_ClearFrames(ItemTrack_CombinedBagFrames);
    ItemTrack_CombinedBags();
end);

--- When the player opens any of the non combined bags windows.
for i = 1, 7 do
    local containerFrame = _G["ContainerFrame"..i]
    if containerFrame then
        containerFrame:HookScript("OnShow", function ()
            ItemTrack_ClearFrames(ItemTrack_ContainerBagFrames["ContainerFrame"..i]);
            ItemTrack_NonCombinedBags(containerFrame, ItemTrack_ContainerBagFrames["ContainerFrame"..i]);
        end);
    end
end