function VictoryMP(owner)
	local tableData = {}
	tableData.clearColour = {
		0,
		0,
		0,
		255
	}
	tableData.revConCursor = GetMainCursor()
	local level = 54
	local gameType = 0
	local localPlayer = 1
	local remotePlayer = 2
	local playerName = {"Player1", "Player2"}
	local unitScoreLocal = {
		11,
		21,
		31,
		41,
		850
	}
	local unitScoreRemote = {
		52,
		62,
		72,
		82,
		1250
	}
	local unitScore = {unitScoreLocal, unitScoreRemote}
	local timeRemaining = 0
	local objectivesP1 = 0
	local objectivesP2 = 0
	local p1Total = 0
	local p2Total = 0
	local stars = {
		true,
		true,
		true
	}
	local promoted = false
	local testing = false
	local left = 1
	local right = 2
	local playerAssaultWins = {111, 112}
	local playerAssaultLosses = {21, 22}
	local playerSkirmishWins = {131, 132}
	local playerSkirmishLosses = {41, 42}
	local mSpeed = 0
	local mPower = 0
	local mTechnique = 0
	local mGrade = 0
	local mTotal = 0
	local mSpeedOld = 0
	local mPowerOld = 0
	local mTechniqueOld = 0
	local mGradeOld = 0
	local mTotalOld = 0
	local badges = {
		GUI_Texture.Victory_Grade_Badge_C,
		GUI_Texture.Victory_Grade_Badge_B,
		GUI_Texture.Victory_Grade_Badge_A,
		GUI_Texture.Victory_Grade_Badge_S
	}
	local gradeBadge = 0
	local function initStats()
		mSpeed, mPower, mTechnique, mGrade = GetMissionData()
		mTotal = (mSpeed + mPower + mTechnique + 0.5) / 3
		mSpeedOld, mPowerOld, mTechniqueOld, mGradeOld = GetStoredMissionData(SelectedLevel)
		mTotalOld = (mSpeedOld + mPowerOld + mTechniqueOld + 0.5) / 3
		gradeBadge = badges[mGrade]
	end
	local speedData = {}
	local powerData = {}
	local techniqueData = {}
	local armyType = 1
	local initStringsTable = {
		{
			"",
			"",
			"",
			""
		},
		{
			"",
			"",
			"",
			"",
			""
		},
		{
			"",
			"",
			"",
			"",
			""
		}
	}
	local speedIconPos = 0
	local speedGraphSize = 0
	local speedGraphPercent = 0
	local function initStringsTableFunc(idx)
		local hrs = rint(speedData[idx] / (60 * 60))
		local tmp = speedData[idx] - hrs * (60 * 60)
		local mins = rint(tmp / 60)
		local secs = tmp - mins * 60
		if 0 < hrs then
			if mins < 10 and secs < 10 then
				initStringsTable[1][idx] = rint(hrs) .. " " .. GetString(StringID.Hours) .. "  0" .. rint(mins) .. " " .. GetString(StringID.Minutes) .. "  0" .. rint(secs) .. " " .. GetString(StringID.Seconds)
			elseif mins < 10 and 9 < secs then
				initStringsTable[1][idx] = rint(hrs) .. " " .. GetString(StringID.Hours) .. "  0" .. rint(mins) .. " " .. GetString(StringID.Minutes) .. "  " .. rint(secs) .. " " .. GetString(StringID.Seconds)
			elseif 9 < mins and secs < 10 then
				initStringsTable[1][idx] = rint(hrs) .. " " .. GetString(StringID.Hours) .. "  " .. rint(mins) .. " " .. GetString(StringID.Minutes) .. "  0" .. rint(secs) .. " " .. GetString(StringID.Seconds)
			else
				initStringsTable[1][idx] = rint(hrs) .. " " .. GetString(StringID.Hours) .. "  " .. rint(mins) .. " " .. GetString(StringID.Minutes) .. "  " .. rint(secs) .. " " .. GetString(StringID.Seconds)
			end
		elseif mins < 10 and secs < 10 then
			initStringsTable[1][idx] = "0" .. rint(mins) .. " " .. GetString(StringID.Minutes) .. "  0" .. rint(secs) .. " " .. GetString(StringID.Seconds)
		elseif mins < 10 and 9 < secs then
			initStringsTable[1][idx] = "0" .. rint(mins) .. " " .. GetString(StringID.Minutes) .. "  " .. rint(secs) .. " " .. GetString(StringID.Seconds)
		elseif 9 < mins and secs < 10 then
			initStringsTable[1][idx] = "" .. rint(mins) .. " " .. GetString(StringID.Minutes) .. "  0" .. rint(secs) .. " " .. GetString(StringID.Seconds)
		else
			initStringsTable[1][idx] = "" .. rint(mins) .. " " .. GetString(StringID.Minutes) .. "  " .. rint(secs) .. " " .. GetString(StringID.Seconds)
		end
	end
	local function initStrings()
		initStringsTableFunc(1)
		initStringsTableFunc(2)
		initStringsTableFunc(3)
		initStringsTableFunc(4)
		initStringsTable[2][1] = "" .. GetString(StringID.VictoryMPInfantry) .. "  " .. GetString(StringID.Destroyed) .. "  " .. rint(powerData[2]) .. "/" .. rint(powerData[1])
		initStringsTable[2][2] = "" .. GetString(StringID.VictoryMPGroundVehicles) .. "  " .. GetString(StringID.Destroyed) .. "  " .. rint(powerData[4]) .. "/" .. rint(powerData[3])
		initStringsTable[2][3] = "" .. GetString(StringID.VictoryMPAirUnits) .. "  " .. GetString(StringID.Destroyed) .. "  " .. rint(powerData[6]) .. "/" .. rint(powerData[5])
		initStringsTable[2][4] = "" .. GetString(StringID.VictoryMPNavalScore) .. "  " .. GetString(StringID.Destroyed) .. "  " .. rint(powerData[8]) .. "/" .. rint(powerData[7])
		initStringsTable[2][5] = "" .. GetString(StringID.DestroyObjectives) .. "  " .. rint(powerData[10]) .. "/" .. rint(powerData[9])
		initStringsTable[3][1] = "" .. GetString(StringID.VictoryMPInfantry) .. "  " .. GetString(StringID.Remaining) .. "  " .. rint(techniqueData[1] - techniqueData[2]) .. "/" .. rint(techniqueData[1])
		initStringsTable[3][2] = "" .. GetString(StringID.VictoryMPGroundVehicles) .. "  " .. GetString(StringID.Remaining) .. "  " .. rint(techniqueData[3] - techniqueData[4]) .. "/" .. rint(techniqueData[3])
		initStringsTable[3][3] = "" .. GetString(StringID.VictoryMPAirUnits) .. "  " .. GetString(StringID.Remaining) .. "  " .. rint(techniqueData[5] - techniqueData[6]) .. "/" .. rint(techniqueData[5])
		initStringsTable[3][4] = "" .. GetString(StringID.VictoryMPNavalScore) .. "  " .. GetString(StringID.Remaining) .. "  " .. rint(techniqueData[7] - techniqueData[8]) .. "/" .. rint(techniqueData[7])
		initStringsTable[3][5] = "" .. GetString(StringID.TechniqueObjectives) .. "  " .. rint(techniqueData[10]) .. "/" .. rint(techniqueData[9])
		local speedMin = speedData[1]
		local speedMax = speedData[2]
		local speedCurrent = speedData[3]
		local speedCent = speedMax - speedMin
		if speedCent <= 0 then
			speedCent = 1
		end
		speedGraphPercent = 100 - 100 / speedCent * (speedCurrent - speedMin)
		if 100 < speedGraphPercent then
			speedGraphPercent = 100
		elseif speedGraphPercent < 0 then
			speedGraphPercent = 0
		end
		speedGraphSize = 383 / 100 * speedGraphPercent
		speedIconPos = 180 + 370 / 100 * speedGraphPercent
	end
	function tableData.getSpeedValues(idx)
		return initStringsTable[1][idx]
	end
	function tableData.getPowerValues(idx)
		return initStringsTable[2][idx]
	end
	function tableData.getTechniqueValues(idx)
		return initStringsTable[3][idx]
	end
	function tableData.getSpeedIconPos()
		return speedIconPos, 295
	end
	function tableData.getSpeedGraph()
		return speedGraphSize, 16
	end
	function tableData.getSpeed()
		return "" .. rint(mSpeed) .. "%"
	end
	function tableData.getPower()
		return "" .. rint(mPower) .. "%"
	end
	function tableData.getTechnique()
		return "" .. rint(mTechnique) .. "%"
	end
	function tableData.techniqueDesc()
		return GetString(StringID.CoopTechniqueDesc)
	end
	function tableData.powerDesc()
		return GetString(StringID.CoopPowerDesc)
	end
	function tableData.speedDesc()
		return GetString(StringID.CoopSpeedDesc)
	end
	function tableData.returnTechniqueString()
		return GetString(StringID.Technique)
	end
	function tableData.returnPowerString()
		return GetString(StringID.Power)
	end
	function tableData.returnSpeedString()
		return GetString(StringID.Speed)
	end
	function tableData.isSkirmishGame()
		return gameType == GAMETYPE.Skirmish
	end
	function tableData.isAssaultGame()
		return gameType == GAMETYPE.Assault
	end
	function tableData.isCoopGame()
		return gameType == GAMETYPE.Coop
	end
	function tableData.getPlayerName(leftRight)
		return playerName[leftRight]
	end
	function tableData.getTimeRemaining()
		return timeRemaining
	end
	function tableData.getTotalScore(leftRight)
		if gameType == GAMETYPE.Assault then
			return " x  " .. unitScore[leftRight][1] + unitScore[leftRight][2] + unitScore[leftRight][3] + unitScore[leftRight][4]
		elseif gameType == GAMETYPE.Coop then
			return "" .. rint(mTotal) .. "%"
		else
			return "" .. unitScore[leftRight][5]
		end
	end
	function tableData.getAssaultP1Objectives()
		if level == 35 then
			return objectivesP1 .. " / 2 "
		else
			return objectivesP1 .. " / 3 "
		end
	end
	function tableData.getAssaultP2Objectives()
		if level == 35 then
			return objectivesP2 .. " / 2 "
		else
			return objectivesP2 .. " / 3 "
		end
	end
	function tableData.getPlayerStarOn(leftRight, starIndex)
		if leftRight == left then
			return stars[starIndex] == true
		else
			return stars[starIndex] == false
		end
	end
	function tableData.getPlayerStarOff(leftRight, starIndex)
		return tableData.getPlayerStarOn(leftRight, starIndex) == false
	end
	function tableData.getUnitScore(leftRight, unitIndex)
		return " x  " .. unitScore[leftRight][unitIndex]
	end
	local getIntegers = function(float)
		local integers = 0
		while 1 <= float do
			integers = integers + 1
			float = float - 1
		end
		return integers
	end
	local globeZoomCount = 180
	local globeZoomRate = 180 / (GetFramesPerSecond() * 4)
	local function updateGlobeZoom()
		if 0 < globeZoomCount then
			globeZoomCount = globeZoomCount - globeZoomRate
			if globeZoomCount <= 0 then
				EnableControllerErrorMessages(true)
				globeZoomCount = 0
			end
		end
	end
	function tableData.getGlobeZoom()
		return 70 - (cos(globeZoomCount) * 20 + 20)
	end
	function tableData.getAtmosZoom()
		return 60 - (cos(globeZoomCount) * 20 + 20)
	end
	function tableData.globeDrop()
		return 0 - (cos(globeZoomCount) * 15 + 15)
	end
	function tableData.globeAtmosDrop()
		return 0 - (cos(globeZoomCount) * 12 + 12)
	end
	function tableData.getAtmosRotX()
		return cos(globeZoomCount) * 17 + 17
	end
	local defeatCount = 180
	local defeatRate = 180 / (GetFramesPerSecond() * 13)
	local waitCount = 0
	local waitCountMax = GetFramesPerSecond() * 6.67
	local imageHeight = 0
	local imageWidth = 200
	function tableData.isVictoryBig()
		if gameType == GAMETYPE.Assault or gameType == GAMETYPE.Coop then
			return true
		else
			return false
		end
	end
	function tableData.isVictorySmall()
		if gameType == GAMETYPE.Skirmish then
			return true
		else
			return false
		end
	end
	function tableData.defeatRise()
		if gameType == GAMETYPE.Assault then
			imageHeight = 190
			imageWidth = 140
		elseif gameType == GAMETYPE.Coop then
			imageHeight = 210
			imageWidth = 140
		else
			imageHeight = 215
			imageWidth = 200
		end
		if waitCount < waitCountMax then
			waitCount = waitCount + 1
			return imageWidth, 480 - (cos(defeatCount) * imageHeight + imageHeight)
		elseif 0 < defeatCount then
			defeatCount = defeatCount - defeatRate
			return imageWidth, 480 - (cos(defeatCount) * imageHeight + imageHeight)
		else
			return imageWidth, 480 - (cos(defeatCount) * imageHeight + imageHeight)
		end
	end
	local fadeCount = 180
	local fadeRate = 180 / (GetFramesPerSecond() * 2)
	local waitCount2 = 0
	local waitCount2Max = GetFramesPerSecond() * 3
	local function updatePanelFade()
		if waitCount2 < waitCount2Max then
			waitCount2 = waitCount2 + 1
		else
			if 0 < fadeCount then
				fadeCount = fadeCount - fadeRate
			else
				fadeCount = fadeCount + fadeRate
			end
			if 180 < fadeCount then
				fadeCount = 180
			end
			if fadeCount < 0 then
				fadeCount = 0
			end
		end
	end
	function tableData.panelFade()
		return cos(fadeCount) * 127.5 + 127.5
	end
	local quickFadeCount = 180
	local quickFadeRate = 180 / (GetFramesPerSecond() * 0.1)
	local waitCount3 = 0
	local waitCount3Max = GetFramesPerSecond() * 4
	local waitCount4 = 0
	local waitCount4Max = GetFramesPerSecond() * 4
	local waitCount4PFade = GetFramesPerSecond() / 1.2
	local flareEffect = 0
	local firework1 = 0
	local aButtonReady = false
	local fadeFinished = false
	local powerHighlighted = false
	local speedHighlighted = false
	local techniqueHighlighted = false
	local scorePowerHeight = {0, -2}
	local scoreSpeedHeight = {0, -2}
	local scoreTechniqueHeight = {0, -2}
	local function updateQuickFade()
		if waitCount3 < waitCount3Max then
			waitCount3 = waitCount3 + 1
		else
			if 0 < quickFadeCount then
				quickFadeCount = quickFadeCount - quickFadeRate
			else
				quickFadeCount = quickFadeCount + quickFadeRate
			end
			if flareEffect == 0 then
				if gameType == GAMETYPE.Assault then
					flareEffect = GUI_Tequila_Effect_Array.Spark_Explode_MP_Assault
				elseif gameType == GAMETYPE.Coop then
					flareEffect = GUI_Tequila_Effect_Array.Spark_Explode
				else
					flareEffect = GUI_Tequila_Effect_Array.Spark_Explode_MP
				end
				StartWidget(tableData, flareEffect, false)
				fadeFinished = true
			end
			if 180 < quickFadeCount then
				quickFadeCount = 180
			end
			if quickFadeCount < 0 then
				quickFadeCount = 0
			end
			if fadeFinished == true and powerHighlighted == false and speedHighlighted == false and techniqueHighlighted == false then
				if waitCount4 < waitCount4Max then
					waitCount4 = waitCount4 + 1
					aButtonReady = false
				else
					aButtonReady = true
				end
			end
		end
	end
	function tableData.quickFade()
		return cos(quickFadeCount) * 127.5 + 127.5
	end
	function tableData.getStatsActive()
		if gameType == GAMETYPE.Coop then
			return fadeFinished
		else
			return false
		end
	end
	function tableData.getFinishFade()
		if gameType == GAMETYPE.Coop then
			return fadeFinished
		else
			return false
		end
	end
	function tableData.isButtonActive()
		if fadeFinished then
			return true
		else
			return false
		end
	end
	function tableData.getAButtonReady()
		if fadeFinished then
			return aButtonReady
		else
			return false
		end
	end
	function tableData.finishPage()
		if aButtonReady and fadeFinished and not promoted then
			PopPageStack()
		elseif aButtonReady and fadeFinished and promoted then
			promoted = false
		end
	end
	function tableData.getButtonPowerSelected()
		return scorePowerHeight
	end
	function tableData.getButtonSpeedSelected()
		return scoreSpeedHeight
	end
	function tableData.getButtonTechniqueSelected()
		return scoreTechniqueHeight
	end
	function tableData.getPowerOn()
		return powerHighlighted
	end
	function tableData.getSpeedOn()
		return speedHighlighted
	end
	function tableData.getTechniqueOn()
		return techniqueHighlighted
	end
	function tableData.openPowerRolloverInfo(type)
		armyType = type
		if fadeFinished then
			aButtonReady = false
			powerHighlighted = true
			scorePowerHeight = {0, 0}
		end
	end
	function tableData.openSpeedRolloverInfo()
		armyType = 1
		if fadeFinished then
			aButtonReady = false
			speedHighlighted = true
			scoreSpeedHeight = {0, 0}
		end
	end
	function tableData.openTechniqueRolloverInfo(type)
		armyType = type
		if fadeFinished then
			aButtonReady = false
			techniqueHighlighted = true
			scoreTechniqueHeight = {0, 0}
		end
	end
	function tableData.closeRolloverInfo()
		powerHighlighted = false
		speedHighlighted = false
		techniqueHighlighted = false
		aButtonReady = true
		scorePowerHeight = {0, -2}
		scoreSpeedHeight = {0, -2}
		scoreTechniqueHeight = {0, -2}
	end
	function tableData.getMPGrade(idx)
		if testing then
			mGrade = 1
		end
		if mGrade == idx then
			return true
		else
			return false
		end
	end
	local saveSunDir = {}
	local saveAmbient = {}
	local colour = true
	local slice = GetFramesPerSecond() * 1
	local bAmbValue = 0
	local mergeSunDir = {}
	local ySunValue = 0
	local xSunValue = 0
	local mergeAmbCol = {}
	local rAmbValue = 0
	local gAmbValue = 0
	local bAmbValue = 0
	local function saveInitialLightSettings()
		GetSunDirection(saveSunDir)
		GetSunAmbientColour(saveAmbient)
		mergeSunDir = saveSunDir
		ySunValue = (90 - mergeSunDir[1]) / slice
		xSunValue = (0 - mergeSunDir[2]) / slice
		mergeAmbCol = saveAmbient
		rAmbValue = (50 - mergeAmbCol[1]) / slice
		gAmbValue = (50 - mergeAmbCol[2]) / slice
		bAmbValue = (50 - mergeAmbCol[3]) / slice
	end
	local function changeColour()
		if colour then
			slice = slice - 1
			SetSunDirection(mergeSunDir)
			SetSunAmbientColour(mergeAmbCol)
			mergeSunDir[1] = mergeSunDir[1] + ySunValue
			mergeSunDir[2] = mergeSunDir[2] + xSunValue
			mergeAmbCol[1] = mergeAmbCol[1] + rAmbValue
			mergeAmbCol[2] = mergeAmbCol[2] + gAmbValue
			mergeAmbCol[3] = mergeAmbCol[3] + bAmbValue
			if slice < 1 then
				colour = false
			end
		end
	end
	local function resetLighting()
		if not colour then
			SetSunDirection({65, 65})
			SetSunAmbientColour({
				224,
				224,
				224
			})
		end
	end
	local armyTable = {
		{1, 1},
		{1, 1},
		{1, 1},
		{1, 1},
		{1, 1},
		{1, 1},
		{1, 1},
		{1, 1},
		{1, 1},
		{1, 1},
		{1, 1},
		{1, 1},
		{1, 1},
		{1, 1},
		{1, 1},
		{1, 1},
		{1, 1},
		{1, 1},
		{1, 1},
		{1, 1},
		{1, 1},
		{1, 1},
		{1, 1},
		{1, 1},
		{1, 1},
		{1, 1},
		{1, 1},
		{1, 1},
		{1, 1},
		{1, 1},
		{1, 1},
		{2, 3},
		{6, 5},
		{4, 5},
		{4, 6},
		{3, 1},
		{6, 5},
		{1, 1},
		{1, 1},
		{1, 1},
		{1, 1},
		{6, 5},
		{4, 6},
		{4, 5},
		{3, 2},
		{4, 1},
		{3, 2},
		{1, 1},
		{1, 1},
		{1, 1},
		{1, 1},
		{
			5,
			3,
			1
		},
		{
			5,
			4,
			6
		},
		{
			3,
			4,
			6
		},
		{
			4,
			5,
			6
		}
	}
	local mapEArmyToArmy = {
		6,
		4,
		3,
		0,
		2,
		1
	}
	local function figureOutCoop(idx)
		if powerHighlighted then
			if armyTable[SelectedLevel][3] == idx then
				return true
			end
		elseif armyTable[SelectedLevel][localPlayer] == idx then
			return true
		end
		return false
	end
	function tableData.selectArmies(idx)
		if testing then
			SelectedLevel = level
		end
		if gameType == GAMETYPE.Coop then
			return figureOutCoop(idx)
		elseif gameType == GAMETYPE.Skirmish then
			return mapEArmyToArmy[idx] == GetEnemyArmy()
		elseif gameType == GAMETYPE.Assault then
			return mapEArmyToArmy[idx] == GetFriendlyArmy()
		end
	end
	function tableData.selectArmiesP2(idx)
		if testing then
			SelectedLevel = level
		end
		if gameType == GAMETYPE.Coop then
			return false
		elseif gameType == GAMETYPE.Skirmish then
			return mapEArmyToArmy[idx] == GetFriendlyArmy()
		elseif gameType == GAMETYPE.Assault then
			return mapEArmyToArmy[idx] == GetEnemyArmy()
		end
	end
	function tableData.isInfantryActive()
		if gameType == GAMETYPE.Skirmish then
			if SelectedLevel == 42 or SelectedLevel == 44 or SelectedLevel == 45 or SelectedLevel == 46 or SelectedLevel == 47 then
				return 255
			else
				return 20
			end
		end
	end
	function tableData.isVehicleActive()
		if gameType == GAMETYPE.Skirmish then
			if SelectedLevel == 42 or SelectedLevel == 44 or SelectedLevel == 45 or SelectedLevel == 46 or SelectedLevel == 47 then
				return 255
			else
				return 20
			end
		end
	end
	function tableData.isAirActive()
		if gameType == GAMETYPE.Skirmish then
			if SelectedLevel == 42 or SelectedLevel == 43 or SelectedLevel == 44 or SelectedLevel == 45 or SelectedLevel == 46 then
				return 255
			else
				return 0
			end
		end
	end
	function tableData.isNavalActive()
		if gameType == GAMETYPE.Skirmish then
			if SelectedLevel == 43 then
				return 255
			else
				return 0
			end
		end
	end
	function tableData.isNavalOn()
		if SelectedLevel == 47 or SelectedLevel == 45 then
			return false
		else
			return true
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
	function tableData.getStarRank(playerIndex)
		if not starsDone[playerIndex] then
			if playerIndex ~= left then
				local wins = playerAssaultWins[playerIndex] + playerSkirmishWins[playerIndex]
				local losses = playerAssaultLosses[playerIndex] + playerSkirmishLosses[playerIndex]
				local diff = wins - losses
				local rank = GetRankFromDiff(diff)
				starsStrings[playerIndex] = getStars(rank)
			else
				local rank = GetOwnRank(MPProfile)
				starsStrings[playerIndex] = getStars(rank)
			end
			starsDone[playerIndex] = true
		end
		return starsStrings[playerIndex]
	end
	function tableData.getPromotionTitle()
		return StringID.RankIncrease
	end
	function tableData.getPromotion()
		return StringID.Promoted
	end
	function tableData.isPromotePanelActive()
		if promoted then
			return true
		else
			return false
		end
	end
	local promoteFadeCount = 0
	local promoteFadeMax = 255
	function tableData.getPromoteFade()
		if waitCount4 < waitCount4PFade then
			return 0
		else
			if fadeFinished and promoteFadeCount < promoteFadeMax then
				promoteFadeCount = promoteFadeCount + 5
				if 255 < promoteFadeCount then
					promoteFadeCount = 255
				end
			end
			return promoteFadeCount
		end
	end
	function tableData.Open()
		local dummy
		EnableControllerErrorMessages(false)
		saveInitialLightSettings()
		if not testing then
			level = GetCurrentLevel()
		end
		gameType = GetLevelGameType(level)
		if IsNetworkPlayer(0) then
			localPlayer = 1
			remotePlayer = 2
		else
			remotePlayer = 1
			localPlayer = 2
		end
		if testing then
			localPlayer = 1
			remotePlayer = 2
		end
		if not testing then
			playerName[left] = GetPlayerInformation(1)
			playerName[right] = GetPlayerInformation(2)
		end
		if testing then
			promoted = true
		else
			promoted = GetMPRankPromoted()
		end
		GetMissionSpeedData(speedData)
		GetMissionPowerData(powerData)
		GetMissionTechniqueData(techniqueData)
		if gameType == GAMETYPE.Skirmish then
			p1Total = GetFriendlyScoreTotals()
			p2Total = GetEnemyScoreTotals()
		end
		if not testing then
			unitScore[left][1] = powerData[MissionData.TroopDeaths]
			unitScore[left][2] = powerData[MissionData.GroundDeaths]
			unitScore[left][3] = powerData[MissionData.AirDeaths]
			unitScore[left][4] = powerData[MissionData.WaterDeaths]
			unitScore[left][5] = p1Total
			unitScore[right][1] = techniqueData[MissionData.TroopDeaths]
			unitScore[right][2] = techniqueData[MissionData.GroundDeaths]
			unitScore[right][3] = techniqueData[MissionData.AirDeaths]
			unitScore[right][4] = techniqueData[MissionData.WaterDeaths]
			unitScore[right][5] = p2Total
		end
		local seconds = speedData[2] - speedData[MissionData.CurrentTime]
		local minutes = getIntegers(seconds / 60)
		seconds = seconds - minutes * 60
		local seconds = getIntegers(seconds)
		if seconds < 10 then
			seconds = "0" .. seconds
		end
		timeRemaining = "" .. minutes .. ":" .. seconds
		stars[1], stars[2], stars[3] = GetObjectivesResult()
		objectivesP1 = 0
		objectivesP2 = 3
		if level == 35 then
			objectivesP2 = 2
		end
		if stars[1] == true then
			objectivesP1 = objectivesP1 + 1
			objectivesP2 = objectivesP2 - 1
		end
		if stars[2] == true then
			objectivesP1 = objectivesP1 + 1
			objectivesP2 = objectivesP2 - 1
		end
		if level ~= 35 and stars[3] == true then
			objectivesP1 = objectivesP1 + 1
			objectivesP2 = objectivesP2 - 1
		end
		if not testing then
			dummy, dummy, dummy, playerAssaultWins[left], playerAssaultLosses[left], playerSkirmishWins[left], playerSkirmishLosses[left] = GetPlayerInformation(1)
			dummy, dummy, dummy, playerAssaultWins[right], playerAssaultLosses[right], playerSkirmishWins[right], playerSkirmishLosses[right] = GetPlayerInformation(2)
		end
		initStats()
		initStrings()
	end
	function tableData.Update()
		PollMapMusicLoop()
		updateGlobeZoom()
		updatePanelFade()
		updateQuickFade()
		changeColour()
	end
	function tableData.Close()
		EnableControllerErrorMessages(true)
		resetLighting()
		PushPageStack("Unlock")
	end
	function GetVictoryMPPage()
		return tableData
	end
	DebugOut("VictoryMP ticked ***")
end
