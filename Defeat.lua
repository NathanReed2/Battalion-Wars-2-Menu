function Defeat(owner)
	local tableData = {}
	local level = 36
	local gameType = 0
	local localPlayer = 0
	local remotePlayer = 0
	local playerName = {"DaMonkey", "ChimpBoy"}
	local unitScoreLocal = {
		11,
		21,
		31,
		41
	}
	local unitScoreRemote = {
		52,
		62,
		72,
		82
	}
	local unitScore = {unitScoreLocal, unitScoreRemote}
	local timeRemaining = 0
	local stars = {
		true,
		true,
		true
	}
	local testing = false
	local left = 1
	local right = 2
	local playerAssaultWins = {111, 112}
	local playerAssaultLosses = {21, 22}
	local playerSkirmishWins = {131, 132}
	local playerSkirmishLosses = {41, 42}
	function tableData.isSkirmishGame()
		return gameType == GAMETYPE.Skirmish
	end
	function tableData.isAssaultGame()
		return gameType == GAMETYPE.Assault
	end
	function tableData.isCoopGame()
		return gameType == GAMETYPE.Coop
	end
	function tableData.getDefeatReasonsOn()
		if gameType == GAMETYPE.Skirmish or gameType == GAMETYPE.Assault then
			return false
		else
			return true
		end
	end
	function tableData.getPlayerName(leftRight)
		return playerName[leftRight]
	end
	function tableData.getTimeRemaining()
		return timeRemaining
	end
	function tableData.getTotalScore(leftRight)
		return "" .. unitScore[leftRight][1] + unitScore[leftRight][2] + unitScore[leftRight][3] + unitScore[leftRight][4]
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
		return "" .. unitScore[leftRight][unitIndex]
	end
	local getIntegers = function(float)
		local integers = 0
		while 1 <= float do
			integers = integers + 1
			float = float - 1
		end
		return integers
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
		{1, 1},
		{1, 1},
		{2, 3},
		{6, 5},
		{4, 5},
		{1, 1},
		{1, 1},
		{6, 5},
		{1, 1},
		{1, 1},
		{1, 1},
		{1, 1},
		{5, 6},
		{4, 6},
		{4, 5},
		{3, 2},
		{4, 1},
		{3, 2},
		{1, 1},
		{1, 1},
		{1, 1},
		{1, 1},
		{3, 5},
		{4, 5},
		{4, 3},
		{5, 4}
	}
	function tableData.selectArmies(idx)
		if testing then
			SelectedLevel = level
		end
		if armyTable[SelectedLevel][2] == idx then
			return true
		else
			return false
		end
	end
	function tableData.selectArmiesP2(idx)
		if testing then
			SelectedLevel = level
		end
		if armyTable[SelectedLevel][1] == idx then
			return true
		else
			return false
		end
	end
	local function getPlayerRank(playerIndex)
		local wins = playerAssaultWins[playerIndex] + playerSkirmishWins[playerIndex]
		local losses = playerAssaultLosses[playerIndex] + playerSkirmishLosses[playerIndex]
		local diff = wins - losses
		return GetRankFromDiff(diff)
	end
	function tableData.getStarRankP1(idx)
		return idx <= getPlayerRank(1)
	end
	function tableData.getStarRankP2(idx)
		return idx <= getPlayerRank(2)
	end
	function tableData.getPromotionTitle()
		return ""
	end
	function tableData.getPromotion()
		return ""
	end
	function tableData.isPromotePanelActive()
		return false
	end
	function tableData.getPromoteFade()
		return 0
	end
	local saveAmbient = {}
	local saveSun = {}
	local saveSunDir = {}
	local saveAntiSun = {}
	local colour = true
	local slice = GetFramesPerSecond() * 1
	local mergeSunCol = {}
	local rSunValue = 0
	local gSunValue = 0
	local bSunValue = 0
	local mergeAntiSunCol = {}
	local rAntiSunValue = 0
	local gAntiSunValue = 0
	local bAntiSunValue = 0
	local mergeAmbCol = {}
	local rAmbValue = 0
	local gAmbValue = 0
	local bAmbValue = 0
	local mergeSunDir = {}
	local ySunValue = 0
	local xSunValue = 0
	local function saveInitialLightSettings()
		GetSunDirection(saveSunDir)
		GetSunAmbientColour(saveAmbient)
		GetSunDirectionalColour(saveSun)
		GetAntiSunDirectionalColour(saveAntiSun)
		mergeSunCol = saveSun
		rSunValue = (255 - mergeSunCol[1]) / slice
		gSunValue = (60 - mergeSunCol[2]) / slice
		bSunValue = (0 - mergeSunCol[3]) / slice
		mergeAntiSunCol = saveAntiSun
		rAntiSunValue = (255 - mergeAntiSunCol[1]) / slice
		gAntiSunValue = (60 - mergeAntiSunCol[2]) / slice
		bAntiSunValue = (0 - mergeAntiSunCol[3]) / slice
		mergeAmbCol = saveAmbient
		rAmbValue = (50 - mergeAmbCol[1]) / slice
		gAmbValue = (50 - mergeAmbCol[2]) / slice
		bAmbValue = (50 - mergeAmbCol[3]) / slice
		mergeSunDir = saveSunDir
		ySunValue = (70 - mergeSunDir[1]) / slice
		xSunValue = (0 - mergeSunDir[2]) / slice
	end
	local function changeColour()
		if colour then
			slice = slice - 1
			SetSunDirectionalColour(mergeSunCol)
			SetAntiSunDirectionalColour(mergeAntiSunCol)
			SetSunAmbientColour(mergeAmbCol)
			SetSunDirection(mergeSunDir)
			mergeSunCol[1] = mergeSunCol[1] + rSunValue
			mergeSunCol[2] = mergeSunCol[2] + gSunValue
			mergeSunCol[3] = mergeSunCol[3] + bSunValue
			mergeAntiSunCol[1] = mergeAntiSunCol[1] + rAntiSunValue
			mergeAntiSunCol[2] = mergeAntiSunCol[2] + gAntiSunValue
			mergeAntiSunCol[3] = mergeAntiSunCol[3] + bAntiSunValue
			mergeAmbCol[1] = mergeAmbCol[1] + rAmbValue
			mergeAmbCol[2] = mergeAmbCol[2] + gAmbValue
			mergeAmbCol[3] = mergeAmbCol[3] + bAmbValue
			mergeSunDir[1] = mergeSunDir[1] + ySunValue
			mergeSunDir[2] = mergeSunDir[2] + xSunValue
			if slice < 1 then
				colour = false
			end
		end
	end
	local resetLighting = function()
		SetSunDirection({65, 65})
		SetSunAmbientColour({
			224,
			224,
			224
		})
		SetSunDirectionalColour({
			226,
			224,
			226,
			255
		})
		SetAntiSunDirectionalColour({
			225,
			226,
			227
		})
	end
	local defeatCount = 180
	local defeatRate = 180 / (GetFramesPerSecond() * 0.5)
	local waitCount = 0
	local waitCountMax = GetFramesPerSecond() * 1
	function tableData.defeatRise()
		if waitCount < waitCountMax then
			waitCount = waitCount + 1
			return 160, 480 - (cos(defeatCount) * 160 + 160)
		elseif 0 < defeatCount then
			defeatCount = defeatCount - defeatRate
			return 160, 480 - (cos(defeatCount) * 160 + 160)
		else
			return 160, 480 - (cos(defeatCount) * 160 + 160)
		end
	end
	local firecount = 480
	local firemax = 200
	function tableData.defeatFireRise()
		if firecount > firemax then
			firecount = firecount - 2
			return -20, firecount
		else
			return -20, 200
		end
	end
	local fadeCount = 180
	local fadeRate = 180 / (GetFramesPerSecond() * 2)
	local panelCount = 0
	local function updatePanelFade()
		if waitCount < waitCountMax then
			panelCount = panelCount + 1
		elseif 0 < fadeCount then
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
	function tableData.panelFade()
		return cos(fadeCount) * 127.5 + 127.5
	end
	local quickFadeCount = 180
	local quickFadeRate = 180 / (GetFramesPerSecond() * 0.1)
	local waitCount3 = 0
	local waitCount3Max = GetFramesPerSecond() / 0.75
	local waitCount3Flare = GetFramesPerSecond() / 1.5
	local flareEffect = 0
	local aButtonReady = false
	local fadeFinished = false
	local function updateQuickFade()
		if waitCount3 < waitCount3Max then
			waitCount3 = waitCount3 + 1
			if flareEffect == 0 and waitCount3 > waitCount3Flare then
				flareEffect = GUI_Sound.FireSound
				StartWidget(tableData, flareEffect, false)
			end
		else
			if 0 < quickFadeCount then
				quickFadeCount = quickFadeCount - quickFadeRate
			else
				quickFadeCount = quickFadeCount + quickFadeRate
			end
			aButtonReady = true
			if 180 < quickFadeCount then
				quickFadeCount = 180
				fadeFinished = true
			end
			if quickFadeCount < 0 then
				quickFadeCount = 0
				fadeFinished = true
			end
		end
	end
	function tableData.quickFade()
		return cos(quickFadeCount) * 127.5 + 127.5
	end
	function tableData.getFinishFade()
		return aButtonReady
	end
	function tableData.getAButtonReady()
		return aButtonReady
	end
	function tableData.isButtonActive()
		return fadeFinished
	end
	function tableData.finishPage()
		if aButtonReady then
			PopPageStack()
		end
	end
	local globeZoomCount = 180
	local globeZoomRate = 180 / (GetFramesPerSecond() * 2)
	local function updateGlobeZoom()
		if 0 < globeZoomCount then
			globeZoomCount = globeZoomCount - globeZoomRate
		else
			globeZoomCount = 0
			EnableControllerErrorMessages(true)
		end
	end
	function tableData.getGlobeZoom()
		return 30 + (cos(globeZoomCount) * 40 + 40)
	end
	function tableData.getAtmosZoom()
		return 30 + (cos(globeZoomCount) * 40 + 40) - 10
	end
	function tableData.Open(timeoutval)
		EnableControllerErrorMessages(false)
		fadeCount = 180
		InitDefeatMusic()
		saveInitialLightSettings()
		GlobeSetTarget(SelectedCampaign)
		if testing == false then
			level = GetCurrentLevel()
		end
		gameType = GetLevelGameType(level)
		if IsNetworkPlayer(0) or testing then
			localPlayer = 1
			remotePlayer = 2
		else
			remotePlayer = 1
			localPlayer = 2
		end
		if testing == false then
			playerName[left] = GetPlayerInformation(1)
			playerName[right] = GetPlayerInformation(2)
		end
		local speedData = {}
		local powerData = {}
		local techniqueData = {}
		GetMissionSpeedData(speedData)
		GetMissionPowerData(powerData)
		GetMissionTechniqueData(techniqueData)
		if testing == false then
			unitScore[left][1] = powerData[MissionData.TroopDeaths]
			unitScore[left][2] = powerData[MissionData.GroundDeaths]
			unitScore[left][3] = powerData[MissionData.AirDeaths]
			unitScore[left][4] = powerData[MissionData.WaterDeaths]
			unitScore[right][1] = techniqueData[MissionData.TroopDeaths]
			unitScore[right][2] = techniqueData[MissionData.GroundDeaths]
			unitScore[right][3] = techniqueData[MissionData.AirDeaths]
			unitScore[right][4] = techniqueData[MissionData.WaterDeaths]
		end
		local seconds = speedData[MissionData.CurrentTime]
		local minutes = getIntegers(seconds / 60)
		seconds = seconds - minutes * 60
		local seconds = getIntegers(seconds)
		if seconds < 10 then
			seconds = "0" .. seconds
		end
		timeRemaining = "" .. minutes .. ":" .. seconds
		stars[1], stars[2], stars[3] = GetObjectivesResult()
		if testing == false then
			local dummy
			dummy, dummy, dummy, playerAssaultWins[1], playerAssaultLosses[1], playerSkirmishWins[1], playerSkirmishLosses[1] = GetPlayerInformation(1)
			dummy, dummy, dummy, playerAssaultWins[2], playerAssaultLosses[2], playerSkirmishWins[2], playerSkirmishLosses[2] = GetPlayerInformation(2)
		end
	end
	function tableData.Update()
		PollMapMusicLoop()
		updateGlobeZoom()
		changeColour()
		updatePanelFade()
		updateQuickFade()
	end
	local presetStackToMap = function()
		ResetPageStack("Start")
		PushPageStack("LoadCampaignData")
		PushPageStack("LoadMPData")
		PushPageStack("Save")
		PushPageStack("MainPre")
		PushPageStack("Main")
		PushPageStack("MapPre")
		PushPageStack("Map")
	end
	local campaignNameTable = {
		"CampaignS",
		"CampaignWF",
		"CampaignAI",
		"CampaignIL",
		"CampaignT"
	}
	function tableData.Close(timeoutval)
		resetLighting()
		if not TestMissionStatus(GAMESTATUS.PROLOGUE) and not TestMissionStatus(GAMESTATUS.TRAINING) then
			presetStackToMap()
			PushPageStack("MapPost")
			PushPageStack(campaignNameTable[SelectedCampaign])
		end
		EnableControllerErrorMessages(true)
	end
	function GetDefeatPage()
		return tableData
	end
	DebugOut("Defeat ticked ***")
end
