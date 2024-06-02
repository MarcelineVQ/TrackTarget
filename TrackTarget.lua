
if not SetAutoloot then
  DEFAULT_CHAT_FRAME:AddMessage("[|cff36c948TrackTarget requires |cffffd200SuperWoW|r to operate.")
  return
end

local orig_FriendsFrameFriendButton_OnClick = FriendsFrameFriendButton_OnClick
-- the playertarget unit doesn't update instantly so exact TargetByName is the best for now
local function TT_FriendsFrameFriendButton_OnClick(a1)
  orig_FriendsFrameFriendButton_OnClick(a1)
  local _,_,friendIndex = string.find(this:GetName(),"FriendsFrameFriendButton(%d+)")

  name, level, class, area, connected, status = GetFriendInfo(tonumber(friendIndex));

  if name and GetZoneText() == area then
    TargetByName(name,true)
  end
end
FriendsFrameFriendButton_OnClick = TT_FriendsFrameFriendButton_OnClick

local orig_FriendsFrameGuildStatusButton_OnClick = FriendsFrameGuildStatusButton_OnClick
-- the playertarget unit doesn't update instantly so exact TargetByName is the best for now
local function TT_FriendsFrameGuildStatusButton_OnClick(a1)
  orig_FriendsFrameGuildStatusButton_OnClick(a1)
  name, rank, rankIndex, level, class, zone, note, officernote, online = GetGuildRosterInfo(GetGuildRosterSelection());

  if name and GetZoneText() == zone then
    TargetByName(name,true)
  end
end
FriendsFrameGuildStatusButton_OnClick = TT_FriendsFrameGuildStatusButton_OnClick

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
