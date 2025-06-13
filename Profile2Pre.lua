function Profile2Pre(owner)
	local tableData = {}
	local rename = false
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	function tableData.gotoName()
		rename = true
		MPText = GetProfileName(MPProfile)
	end
	function tableData.gotoFriendlist()
	end
	function tableData.GetFriendKey()
		local code = GetFriendKey()
		if code == "000 000 000 000" then
			return 97 + NumGlobalStrings
		else
			return code
		end
	end
	local fadeCount = 180
	local fadeRate = 180 / (GetFramesPerSecond() * 1.5)
	local fadeScale = 3
	local bFadeIn = true
	local function updateAlpha()
		if bFadeIn then
			fadeCount = fadeCount - fadeRate * fadeScale
		else
			fadeCount = fadeCount + fadeRate * fadeScale
		end
	end
	local function checkExit()
		if bFadeIn and fadeCount < 0 then
			fadeCount = 0
			PushPageStack("Profile")
		elseif not bFadeIn and 180 < fadeCount then
			fadeCount = 180
			PopPageStack()
		end
	end
	function tableData.trapFilterCol()
		return 255
	end
	function tableData.getStringClear()
		return 71 + NumGlobalStrings
	end
	function tableData.getStringName()
		return 75 + NumGlobalStrings
	end
	function tableData.getStringFriends()
		return 441 + NumGlobalStrings
	end
	function tableData.getStringStats()
		return 442 + NumGlobalStrings
	end
	function tableData.backButtonText()
		return StringID.Back
	end
	function tableData.showFriends()
		return GetFriendKey() ~= "000 000 000 000"
	end
	function tableData.faderColour(scale)
		return 255 - (cos(fadeCount) * 127.5 + 127.5)
	end
	function tableData.faderColourReverse(scale)
		return cos(fadeCount) * 127.5 + 127.5
	end
	function tableData.gotoGO1()
	end
	function tableData.gotoGO2()
	end
	function tableData.gotoGO3()
	end
	function tableData.gotoGO4()
	end
	function tableData.clear()
	end
	function tableData.gotoFriend()
	end
	function tableData.gotoName()
	end
	function tableData.gotoFriends()
	end
	function tableData.gotoStats()
	end
	function tableData.triggerSave()
	end
	local assaultUnlockString1 = ""
	local assaultUnlockString2 = ""
	local skirmishUnlockString1 = ""
	local skirmishUnlockString2 = ""
	local coopUnlockString1 = ""
	local coopUnlockString2 = ""
	local gameCount = function(firstMap, lastMap, firstResult, lastResult)
		local count = 0
		for map = firstMap, lastMap do
			for result = firstResult, lastResult do
				count = count + GetMPStatistics(0, map, result)
			end
		end
		return count
	end
	local getGamesRemaining = function(games)
		if 8 <= games then
			return 18 - games
		elseif 3 <= games then
			return 8 - games
		else
			return 3 - games
		end
	end
	local function initUnlockStrings()
		assaultUnlockString1 = GetString(StringID.NextAssaultUnlock) .. ": "
		local games = gameCount(1, 10, MATCHRESULT.Lost, MATCHRESULT.S)
		if 18 <= games or UnlockedSP() then
			assaultUnlockString2 = GetString(299 + NumGlobalStrings)
		else
			games = getGamesRemaining(games)
			assaultUnlockString2 = GetString(StringID.PlayAssault) .. " " .. games .. " " .. GetString(StringID.Times)
		end
		skirmishUnlockString1 = GetString(StringID.NextSkirmishUnlock) .. ": "
		local games = gameCount(11, 20, MATCHRESULT.Lost, MATCHRESULT.S)
		if 18 <= games or UnlockedSP() then
			skirmishUnlockString2 = GetString(299 + NumGlobalStrings)
		else
			games = getGamesRemaining(games)
			skirmishUnlockString2 = GetString(StringID.PlaySkirmish) .. " " .. games .. " " .. GetString(StringID.Times)
		end
		coopUnlockString1 = GetString(StringID.NextCOOPUnlock) .. ": "
		local games = gameCount(21, 30, MATCHRESULT.Lost, MATCHRESULT.S)
		if 3 <= games or UnlockedSP() then
			coopUnlockString2 = GetString(299 + NumGlobalStrings)
		else
			games = getGamesRemaining(games)
			coopUnlockString2 = GetString(StringID.PlayCOOP) .. " " .. games .. " " .. GetString(StringID.Times)
		end
	end
	function tableData.getNextAssaultUnlockString1()
		return assaultUnlockString1
	end
	function tableData.getNextAssaultUnlockString2()
		return assaultUnlockString2
	end
	function tableData.getNextSkirmishUnlockString1()
		return skirmishUnlockString1
	end
	function tableData.getNextSkirmishUnlockString2()
		return skirmishUnlockString2
	end
	function tableData.getNextCOOPUnlockString1()
		return coopUnlockString1
	end
	function tableData.getNextCOOPUnlockString2()
		return coopUnlockString2
	end
	function tableData.getStars()
		local rank = GetOwnRank(MPProfile)
		local stars = ""
		if 0 < rank then
			for tl = 1, rank do
				stars = "*" .. stars
			end
		else
			stars = " "
		end
		return stars
	end
	function tableData.getTotalWins()
		return "" .. tableData.getAssaultWon() + tableData.getSkirmishWon() + tableData.getCoopWon()
	end
	function tableData.getTotalLosses()
		return "" .. tableData.getAssaultLost() + tableData.getSkirmishLost() + tableData.getCoopLost()
	end
	function tableData.getAssaultWon()
		return "" .. gameCount(1, 10, MATCHRESULT.C, MATCHRESULT.S)
	end
	function tableData.getAssaultLost()
		local lost = gameCount(1, 10, MATCHRESULT.Started, MATCHRESULT.Started) - tableData.getAssaultWon()
		if lost < 0 then
			lost = 0
		end
		return "" .. lost
	end
	function tableData.getSkirmishWon()
		return "" .. gameCount(11, 20, MATCHRESULT.C, MATCHRESULT.S)
	end
	function tableData.getSkirmishLost()
		local lost = gameCount(11, 20, MATCHRESULT.Started, MATCHRESULT.Started) - tableData.getSkirmishWon()
		if lost < 0 then
			lost = 0
		end
		return "" .. lost
	end
	function tableData.getCoopWon()
		return "" .. gameCount(21, 30, MATCHRESULT.C, MATCHRESULT.S)
	end
	function tableData.getCoopLost()
		local lost = gameCount(21, 30, MATCHRESULT.Started, MATCHRESULT.Started) - tableData.getCoopWon()
		if lost < 0 then
			lost = 0
		end
		return "" .. lost
	end
	local gameCount = function(firstResult, lastResult)
		local count = 0
		for map = 1, 30 do
			for result = firstResult, lastResult do
				count = count + GetMPStatistics(0, map, result)
			end
		end
		return count
	end
	function tableData.getName()
		return GetProfileName(MPProfile)
	end
	function tableData.getStarted()
		return "" .. gameCount(MATCHRESULT.Started, MATCHRESULT.Started)
	end
	function tableData.getFinished()
		return "" .. gameCount(MATCHRESULT.Lost, MATCHRESULT.S)
	end
	function tableData.getWon()
		return "" .. gameCount(MATCHRESULT.C, MATCHRESULT.S)
	end
	function tableData.getKey()
		return GetFriendKey()
	end
	function tableData.getSkill()
		return "" .. GetSkill()
	end
	function tableData.getUncertainty()
		return "" .. GetSkillUncertainty()
	end
	function tableData.displayAll()
		return true
	end
	function tableData.Open()
		initUnlockStrings()
		if rename then
			rename = false
			SetProfileName(MPText)
		end
		if bFadeIn then
			fadeCount = 180
		else
			fadeCount = 0
		end
	end
	function tableData.Update()
		PopPageStackIfNetworkError()
		CheckChallenge(false)
		updateAlpha()
		checkExit()
	end
	function tableData.Close()
		if bFadeIn then
			bFadeIn = false
		else
			bFadeIn = true
		end
	end
	function GetProfile2PrePage()
		return tableData
	end
	DebugOut("Profile2Pre ticked ***")
end
