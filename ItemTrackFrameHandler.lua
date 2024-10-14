local function applyHoverEffect(itemIconInfo, enabled)
    local fadeDuration = 0.1;

    if (enabled and itemIconInfo.iconFrame ~= nil) then
        local function createAlphaHandler(alpha, duration, originalFunction)
            return function (self, ...)
                UIFrameFadeIn(itemIconInfo.iconFrame, duration, itemIconInfo.iconFrame:GetAlpha(), alpha)
                if (originalFunction) then
                    originalFunction(self, ...);
                end
            end
        end

        itemIconInfo.parentFrame:SetScript("OnEnter", createAlphaHandler(1, fadeDuration, itemIconInfo.onEnterFunction));
        itemIconInfo.parentFrame:SetScript("OnLeave", createAlphaHandler(ItemTrack_IconFadeAmount, fadeDuration, itemIconInfo.onLeaveFunction));
    else
        itemIconInfo.parentFrame:SetScript("OnEnter", itemIconInfo.onEnterFunction);
        itemIconInfo.parentFrame:SetScript("OnLeave", itemIconInfo.onLeaveFunction);

        -- Reset opacity on reseting events.
        if (itemIconInfo.iconFrame ~= nil) then
            itemIconInfo.iconFrame:SetAlpha(ItemTrack_IconFadeAmount);
        end
    end
end

function ItemTrack_ApplyIcon(itemIconInfo)
    local rankIconInfo = ItemRewardIconInfo[itemIconInfo.rank];
    if (not rankIconInfo.show) then return end;

    -- Don't duplicate frames.
    if (itemIconInfo.iconFrame ~= nil) then
        itemIconInfo.iconFrame.texture:SetAtlas(rankIconInfo.atlasId);
        itemIconInfo.iconFrame:Show();
        return;
    end

    -- Create a frame and return it.
    local iconFrame = CreateFrame("Frame", nil, itemIconInfo.parentFrame);
    iconFrame:SetFrameStrata("TOOLTIP");
    iconFrame:SetFrameLevel(200);
    iconFrame:SetWidth(rankIconInfo.size.width);
    iconFrame:SetHeight(rankIconInfo.size.height);
    iconFrame:SetAlpha(ItemTrack_IconFadeAmount);
    iconFrame:EnableMouse(false);

    local t = iconFrame:CreateTexture(nil, "OVERLAY");
    t:SetAtlas(rankIconInfo.atlasId);
    t:SetAllPoints(iconFrame);

    iconFrame.texture = t;

    iconFrame:SetPoint(
        "CENTER",
        rankIconInfo.offset.x,
        rankIconInfo.offset.y
    );

    iconFrame:Show();

    -- Apply to icon frame to complete the object and apply the effects.
    itemIconInfo.iconFrame = iconFrame;
    applyHoverEffect(itemIconInfo, true);

    return iconFrame;
end

function ItemTrack_ClearFrames(...)
    local frameTables = {...}
    for _, frameTable in ipairs(frameTables) do
        for _, itemIconInfo in pairs(frameTable) do
            if (itemIconInfo.iconFrame ~= nil) then
                applyHoverEffect(itemIconInfo, false);
                itemIconInfo.iconFrame:Hide();
            end
        end
    end
end