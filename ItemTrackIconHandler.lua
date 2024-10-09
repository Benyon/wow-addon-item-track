function ItemTrack_ClearFrames()
  local function clearFrames(frames)
    if not frames then return end
    for _, frame in pairs(frames) do
      frame:Hide()
    end
  end

  clearFrames(ItemTrack_BagFrames)
  clearFrames(ItemTrack_CharacterFrames)
end

function ItemTrack_EnumerateInventory()
  print('ItemTrack_EnumerateInventory - void');
end

function ItemTrack_ApplyIcon(parent)
  local f = CreateFrame("Frame", nil, parent)
  f:SetFrameStrata("TOOLTIP")
  f:SetWidth(41)
  f:SetHeight(41)
  f:SetAlpha(1)

  local t = f:CreateTexture(nil, "OVERLAY")
  t:SetAtlas('dressingroom-itemborder-white')
  t:SetAllPoints(f)
  f.texture = t

  f:SetPoint("CENTER", 0, 0)
  f:Show()

  return f;
end