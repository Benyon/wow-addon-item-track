local function applyHoverEffect(frame, enabled, targetFrame)
    local fadeDuration = 0.1;

    if (enabled and targetFrame ~= nil) then
        local function createAlphaHandler(alpha, duration)
            return function ()
                UIFrameFadeIn(targetFrame, duration, targetFrame:GetAlpha(), alpha)
            end
        end
        frame:SetScript("OnEnter", createAlphaHandler(1, fadeDuration));
        frame:SetScript("OnLeave", createAlphaHandler(ItemTrack_IconFadeAmount, fadeDuration));
    else
        frame:SetScript("OnEnter", nil);
        frame:SetScript("OnLeave", nil);
        if (targetFrame ~= nil) then
            targetFrame:SetAlpha(ItemTrack_IconFadeAmount);
        end
    end
end

function ItemTrack_ApplyIcon(entry)
    -- Don't duplicate frames.
    if (entry.iconFrame ~= nil) then
        entry.iconFrame:Show();
        return;
    end

    local atlasAssetId = ItemRewardTrackAtlasIds[entry.rank];

    -- Create a frame and return it.
    local f = CreateFrame("Frame", nil, entry.parentFrame);
    f:SetFrameStrata("TOOLTIP");
    f:SetWidth(34);
    f:SetHeight(28);
    f:SetAlpha(ItemTrack_IconFadeAmount);
    f:EnableMouse(false);

    local t = f:CreateTexture(nil, "OVERLAY");
    t:SetAtlas(atlasAssetId);
    t:SetAllPoints(f);

    f.texture = t;

    f:SetPoint("CENTER", -4, 7);
    f:Show();

    applyHoverEffect(entry.parentFrame, true, f);

    return f;
end

function ItemTrack_ClearFrames()
    local function clearFrames(frames)
        if (not frames) then return end
        for _, itemIconInfo in pairs(frames) do
            if (itemIconInfo.iconFrame ~= nil) then
                applyHoverEffect(itemIconInfo.parentFrame, false, nil);
                itemIconInfo.iconFrame:Hide();
            end
        end
    end
    clearFrames(ItemTrack_BagFrames)
    clearFrames(ItemTrack_CharacterFrames)
end