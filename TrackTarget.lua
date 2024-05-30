
if not SetAutoloot then
  DEFAULT_CHAT_FRAME:AddMessage("[|cff36c948TrackTarget requires |cffffd200SuperWoW|r to operate.")
  return
end

local trackFrame = CreateFrame("Frame")
local current_target = nil
trackFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
trackFrame:SetScript("OnEvent", function ()
  if event == "PLAYER_TARGET_CHANGED" then
    local _,guid = UnitExists("target")
    -- if we select someone new erase the old one
    if guid ~= current_target and UnitExists(current_target) then
      TrackUnit(current_target) -- toggle off tracking on old target
      current_target = nil
    end
    -- TrackUnit can only be used on units you can assist, sorrrrry
    if guid and UnitCanAssist("player",guid) then
      TrackUnit(guid)
      current_target = guid
    end
  end
end)
