function MPGlobal(owner)
end
MPWhat = 0
MPWho = 0
MPLevel = 0
MPProfile = GetCurrentMPProfile()
MPProfileLoading = 0
MPText = ""
MPChallenged = false
MPChallenging = false
local MPRefused = {}
for i = 1, 64 do
	MPRefused[i] = false
end
function setRefusedFlag(index, value)
	MPRefused[index] = value
end
MPFriendAnyLevel = false
MPFriend = 0
MPPreferredPlayer = -1
MPOldFriend = 0
MPOldWhat = 0
MPOldWho = 0
MPOldLevel = -1
local playedMaps = function(first, played)
	local count = 0
	for map = first, first + 9 do
		for result = MATCHRESULT.Lost, MATCHRESULT.S do
			count = count + GetMPStatistics(0, map, result)
			if played <= count then
				return true
			end
		end
	end
	return false
end
local getPlayedCount = function(first)
	local count = 0
	for map = first, first + 9 do
		for result = MATCHRESULT.Lost, MATCHRESULT.S do
			count = count + GetMPStatistics(0, map, result)
		end
	end
	return count
end
local wonMap = function(map, minimum)
	for result = minimum, MATCHRESULT.S do
		if 0 < GetMPStatistics(0, map, result) then
			return true
		end
	end
	return false
end
local function wonMaps(first, maps, minimum)
	local count = 0
	for map = first, first + 9 do
		if wonMap(map, minimum) then
			count = count + 1
			if maps <= count then
				return true
			end
		end
	end
	return false
end
local Assault = 1
local Skirmish = 11
local Coop = 21
function MPIsUnlocked(iLevel)
	local levelExists = false
	local levelUnlocked = false
	if 1 == iLevel then
		levelUnlocked = playedMaps(Assault, 18)
		levelExists = true
	elseif 2 == iLevel then
		levelUnlocked = true
		levelExists = true
	elseif 3 == iLevel then
		levelUnlocked = playedMaps(Assault, 3)
		levelExists = true
	elseif 4 == iLevel then
		levelUnlocked = true
		levelExists = true
	elseif 5 == iLevel then
		levelUnlocked = true
		levelExists = true
	elseif 6 == iLevel then
		levelUnlocked = playedMaps(Assault, 8)
		levelExists = true
	elseif 11 == iLevel then
		levelUnlocked = playedMaps(Skirmish, 18)
		levelExists = true
	elseif 12 == iLevel then
		levelUnlocked = true
		levelExists = true
	elseif 13 == iLevel then
		levelUnlocked = true
		levelExists = true
	elseif 14 == iLevel then
		levelUnlocked = playedMaps(Skirmish, 8)
		levelExists = true
	elseif 15 == iLevel then
		levelUnlocked = playedMaps(Skirmish, 3)
		levelExists = true
	elseif 16 == iLevel then
		levelUnlocked = true
		levelExists = true
	elseif 21 == iLevel then
		levelUnlocked = playedMaps(Coop, 3)
		levelExists = true
	elseif 22 == iLevel then
		levelUnlocked = true
		levelExists = true
	elseif 23 == iLevel then
		levelUnlocked = true
		levelExists = true
	elseif 24 == iLevel then
		levelUnlocked = true
		levelExists = true
	end
	if levelExists and UnlockedSP() then
		levelUnlocked = true
	end
	return levelUnlocked
end
local function GetAssaultMapsUnlockLevel()
	if UnlockedSP() then
		return 3
	end
	local playedCount = getPlayedCount(Assault)
	local unlockLevel = 0
	if playedCount < 3 then
		unlockLevel = 0
	elseif playedCount < 8 then
		unlockLevel = 1
	elseif playedCount < 18 then
		unlockLevel = 2
	else
		unlockLevel = 3
	end
	return unlockLevel
end
local function GetSkirmishMapsUnlockLevel()
	if UnlockedSP() then
		return 3
	end
	local playedCount = getPlayedCount(Skirmish)
	local unlockLevel = 0
	if playedCount < 3 then
		unlockLevel = 0
	elseif playedCount < 8 then
		unlockLevel = 1
	elseif playedCount < 18 then
		unlockLevel = 2
	else
		unlockLevel = 3
	end
	return unlockLevel
end
local function GetCoopMapsUnlockLevel()
	if UnlockedSP() then
		return 1
	end
	local playedCount = getPlayedCount(Coop)
	local unlockLevel = 0
	if playedCount < 3 then
		unlockLevel = 0
	else
		unlockLevel = 1
	end
	return unlockLevel
end
function UpdateMPMapUnlocked()
	local MPUnlockStatus = GetAssaultMapsUnlockLevel() + GetSkirmishMapsUnlockLevel() + GetCoopMapsUnlockLevel()
	local lastMPUnlockStatus = UpdateMPUnlockStatus(MPUnlockStatus)
	if MPUnlockStatus ~= lastMPUnlockStatus then
		UnlockMPMap = true
	else
		UnlockMPMap = false
	end
end
function UnlockedMPWithoutSP()
	if getPlayedCount(Assault) < 18 then
		return false
	end
	if getPlayedCount(Skirmish) < 18 then
		return false
	end
	if getPlayedCount(Coop) < 3 then
		return false
	end
	return true
end
function UpdateMPRankStatus()
	ResetRankChange(MPProfile)
	UnlockMPRankPromoted = false
	UnlockMPRankDemoted = false
	if GetRankIncreased(MPProfile) then
		UnlockMPRankPromoted = true
	elseif GetRankDecreased(MPProfile) then
		UnlockMPRankDemoted = true
	end
end
function GetMPRankPromoted()
	return UnlockMPRankPromoted
end
function GetMPRankDemoted()
	return UnlockMPRankDemoted
end
function GetMPMapUnlocked()
	return UnlockMPMap
end
local friendIndex = 1
function CheckChallenge(stopMatchMaking)
	friendIndex = friendIndex + 1
	if 64 < friendIndex then
		friendIndex = 1
	end
	local nameTag = GetFriendStatusStringTag(friendIndex, "NAME")
	if nameTag ~= nil then
		SetFriendName(friendIndex, nameTag)
	end
	local rankTag = GetFriendStatusStringTag(friendIndex, "RANK")
	if rankTag ~= nil then
		SetFriendRank(friendIndex, rankTag)
	end
	if MPChallenging == false then
		local status = GetFriendStatusStringTag(friendIndex, GetFriendKey())
		if status == nil then
			RemoveOwnStatusStringTag(GetFriendKey(friendIndex))
			setRefusedFlag(friendIndex, false)
		end
		if MPRefused[friendIndex] == false then
			local challenge = "Play?"
			if status == challenge then
				if stopMatchMaking then
					StopMatchMaking()
					PopPageStack()
				end
				MPFriendAnyLevel = true
				MPChallenged = true
				MPOldFriend = MPFriend
				MPFriend = friendIndex
				PushPageStack("Challenge")
			end
		end
	end
end
function GetFriendStatusStringFromCode(code)
	local searching = GetString(507 + NumGlobalStrings)
	if code == 0 then
		local off_line = GetString(504 + NumGlobalStrings)
		return off_line
	elseif code == 1 then
		local on_line = GetString(505 + NumGlobalStrings)
		return on_line
	elseif code == 2 then
		local playing = GetString(506 + NumGlobalStrings)
		return playing
	elseif code == 3 then
		return searching
	elseif code == 4 then
		return searching
	elseif code == 5 then
		return searching
	elseif code == 6 then
		return searching
	else
		local not_found = GetString(508 + NumGlobalStrings)
		return not_found .. code
	end
end
function PopPageStackIfNetworkError()
	if GetNetworkStatus() == NETWORK.LostConnection then
		LeaveMPGame()
		PopPageStack()
	end
end
local WF = 1
local TT = 2
local SE = 3
local XY = 4
local AI = 5
local IL = 6
factionPerLevel = {
	IL,
	SE,
	XY,
	TT,
	WF,
	TT,
	WF,
	XY,
	SE,
	AI,
	XY,
	TT,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	XY,
	TT,
	WF,
	XY,
	WF,
	TT,
	SE,
	IL,
	WF,
	AI,
	SE,
	IL,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	SE,
	TT,
	WF,
	TT,
	WF,
	SE,
	TT,
	WF,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0
}
attackingPlayer = {
	PLAYER_INDEX.One,
	PLAYER_INDEX.One,
	PLAYER_INDEX.One,
	PLAYER_INDEX.Two,
	PLAYER_INDEX.One,
	PLAYER_INDEX.One,
	PLAYER_INDEX.One,
	PLAYER_INDEX.One,
	PLAYER_INDEX.One,
	PLAYER_INDEX.One
}
function isFaction(level, faction, playerIndex)
	return faction == factionPerLevel[(level - 1) * 2 + playerIndex]
end
function getPlayerSide(level, playerIndex)
	return 1330 + factionPerLevel[(level - 1) * 2 + playerIndex] + NumGlobalStrings
end
DebugOut("MPGlobal ticked ***")
function MPGlobalEnd()
end
