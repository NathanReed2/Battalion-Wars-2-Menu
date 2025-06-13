function MPLoading(owner)
	local tableData = {}
	local level = 0
	local gameType = 0
	local loadDelayStart = 2
	local loadDelay = loadDelayStart
	local left = 1
	local right = 2
	local localPlayer = 1
	local remotePlayer = 2
	local playerName = {
		StringID.MPLoadPlayer1,
		StringID.MPLoadPlayer2
	}
	local playerAssaultWins = {111, 112}
	local playerAssaultLosses = {21, 22}
	local playerSkirmishWins = {131, 132}
	local playerSkirmishLosses = {41, 42}
	local playerCoopCompleted = {51, 52}
	local playerCoopSranks = {61, 62}
	function tableData.getPlayerName(playerIndex)
		return playerName[playerIndex]
	end
	function tableData.isCoopGame()
		return gameType == GAMETYPE.Coop
	end
	function tableData.isNotCoopGame()
		return gameType ~= GAMETYPE.Coop
	end
	function tableData.isLevel(requestedLevel)
		return level - 31 == requestedLevel
	end
	function tableData.getPlayerFirstTitle()
		if tableData.isCoopGame() then
			return 1373 + NumGlobalStrings
		else
			return 1370 + NumGlobalStrings
		end
	end
	function tableData.getPlayerFirstScore(playerIndex)
		if gameType == GAMETYPE.Assault then
			return ": " .. playerAssaultWins[playerIndex]
		elseif gameType == GAMETYPE.Skirmish then
			return ": " .. playerSkirmishWins[playerIndex]
		else
			return ": " .. playerCoopSranks[playerIndex]
		end
	end
	function tableData.getPlayerSecondTitle()
		if tableData.isCoopGame() then
			return 1372 + NumGlobalStrings
		else
			return 1371 + NumGlobalStrings
		end
	end
	function tableData.getPlayerSecondScore(playerIndex)
		if gameType == GAMETYPE.Assault then
			return ": " .. playerAssaultLosses[playerIndex]
		elseif gameType == GAMETYPE.Skirmish then
			return ": " .. playerSkirmishLosses[playerIndex]
		else
			return ": " .. playerCoopCompleted[playerIndex]
		end
	end
	local starsDone = {false, false}
	local starsStrings = {"", ""}
	local getStars = function(rank)
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
	function tableData.getPlayerRank(playerIndex)
		if not starsDone[playerIndex] then
			local wins = playerAssaultWins[playerIndex] + playerSkirmishWins[playerIndex]
			local losses = playerAssaultLosses[playerIndex] + playerSkirmishLosses[playerIndex]
			local diff = wins - losses
			local rank = GetRankFromDiff(diff)
			starsStrings[playerIndex] = getStars(rank)
			starsDone[playerIndex] = true
		end
		return starsStrings[playerIndex]
	end
	function tableData.getPlayerSide(playerIndex)
		if localPlayer == 1 then
			return getPlayerSide(level - 31, playerIndex)
		else
			return getPlayerSide(level - 31, 3 - playerIndex)
		end
	end
	function tableData.isFaction(faction, playerIndex)
		if localPlayer == 1 then
			return isFaction(level - 31, faction, playerIndex)
		else
			return isFaction(level - 31, faction, 3 - playerIndex)
		end
	end
	function tableData.getRecordTitle()
		return GetString(tableData.getHeader()) .. " " .. GetString(1374 + NumGlobalStrings)
	end
	function tableData.getLevelName()
		return 1212 - 8 + level + NumGlobalStrings
	end
	function tableData.getHeader()
		if gameType == GAMETYPE.Skirmish then
			return 1362 + NumGlobalStrings
		elseif gameType == GAMETYPE.Assault then
			return 1366 + NumGlobalStrings
		else
			return 1365 + NumGlobalStrings
		end
	end
	function tableData.getVS()
		if tableData.isCoopGame() then
			return 1369 + NumGlobalStrings
		else
			return 1375 + NumGlobalStrings
		end
	end
	function tableData.getInstruction1()
		if gameType == GAMETYPE.Skirmish then
			return 1350 + NumGlobalStrings
		elseif gameType == GAMETYPE.Assault then
			local isAttacker = IsNetworkPlayer(0)
			if isAttacker then
				return 1353 + NumGlobalStrings
			else
				return 1356 + NumGlobalStrings
			end
		else
			return 1359 + NumGlobalStrings
		end
	end
	function tableData.getInstruction2()
		if gameType == GAMETYPE.Skirmish then
			return 1351 + NumGlobalStrings
		elseif gameType == GAMETYPE.Assault then
			local isAttacker = IsNetworkPlayer(0)
			if isAttacker then
				return 1354 + NumGlobalStrings
			else
				return 1357 + NumGlobalStrings
			end
		else
			return 1360 + NumGlobalStrings
		end
	end
	function tableData.getInstruction3()
		if gameType == GAMETYPE.Skirmish then
			return 1352 + NumGlobalStrings
		elseif gameType == GAMETYPE.Assault then
			local isAttacker = IsNetworkPlayer(0)
			if isAttacker then
				return 1355 + NumGlobalStrings
			else
				return 1358 + NumGlobalStrings
			end
		else
			return 1361 + NumGlobalStrings
		end
	end
	function tableData.Open()
		local dummy
		level = GetCurrentLevel()
		gameType = GetLevelGameType(level)
		loadDelay = loadDelayStart
		if IsNetworkPlayer(0) then
			localPlayer = 1
			remotePlayer = 2
		else
			remotePlayer = 1
			localPlayer = 2
		end
		SetTmpStore(localPlayer)
		playerName[left], dummy, dummy, playerAssaultWins[left], playerAssaultLosses[left], playerSkirmishWins[left], playerSkirmishLosses[left], playerCoopSranks[left], playerCoopCompleted[left] = GetPlayerInformation(1)
		playerName[right], dummy, dummy, playerAssaultWins[right], playerAssaultLosses[right], playerSkirmishWins[right], playerSkirmishLosses[right], playerCoopSranks[right], playerCoopCompleted[right] = GetPlayerInformation(2)
		local side = tableData.getPlayerSide(1) - NumGlobalStrings
	end
	function tableData.Update()
		loadDelay = loadDelay - 1
		if loadDelay == 0 and GetNetworkStatus() ~= NETWORK.UNKNOWN then
			TriggerFrameSave()
			RunLevel(level)
		end
	end
	function tableData.Close()
	end
	function GetMPLoadingPage()
		return tableData
	end
	DebugOut("MPLoading page ticked ***")
end
