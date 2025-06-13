function Victory(owner)
	local tableData = {}
	tableData.clearColour = {
		0,
		0,
		0,
		255
	}
	tableData.revConCursor = GetMainCursor()
	local nandDialog
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
	local newUnits = false
	local saveStats = false
	local maxMissions = 20
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
	local function initData()
		GetMissionSpeedData(speedData)
		GetMissionPowerData(powerData)
		GetMissionTechniqueData(techniqueData)
	end
	local armyTable = {
		{3, 2},
		{3, 1},
		{3, 1},
		{3, 1},
		{3, 1},
		{3, 1},
		{4, 5},
		{4, 5},
		{4, 5},
		{1, 3},
		{1, 3},
		{1, 3},
		{1, 3},
		{2, 3},
		{2, 3},
		{2, 3},
		{5, 6},
		{5, 6},
		{5, 6},
		{5, 6},
		{5, 6}
	}
	local armyType = 1
	function tableData.selectArmies(idx)
		if SelectedLevel >= 1 and SelectedLevel <= 21 then
			if armyTable[SelectedLevel][armyType] == idx then
				return true
			end
		elseif armyType == 1 and idx == 3 then
			return true
		elseif armyType == 2 and idx == 2 then
			return true
		end
		return false
	end
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
		return speedIconPos, 293
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
	function tableData.getTotalScore()
		return "" .. rint(mTotal) .. "%"
	end
	function tableData.techniqueDesc()
		return GetString(StringID.TechniqueDesc)
	end
	function tableData.powerDesc()
		return GetString(StringID.PowerDesc)
	end
	function tableData.speedDesc()
		return GetString(StringID.SpeedDesc)
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
		return true
	end
	local saveCallback = function(status)
		SetGameSaveValid(SPSaveStatus, status)
	end
	local function progressLevels()
		if mGrade > mGradeOld then
			SetCurrentMissionStats(SelectedLevel)
			saveStats = true
		elseif mGrade == mGradeOld and mTotal > mTotalOld then
			SetCurrentMissionStats(SelectedLevel)
			saveStats = true
		end
		if SelectedLevel <= maxMissions and SelectedLevel > LevelsDone then
			local prevSelectedCampaign = 0
			if LevelsDone > 0 then
				prevSelectedCampaign = GetLevelCampaignMap(LevelsDone)
			end
			SetLevelsDone(SelectedLevel)
			saveStats = true
			SelectedCampaign = GetLevelCampaignMap(SelectedLevel)
			if prevSelectedCampaign < SelectedCampaign then
				UnlockedCampaignFlag = true
				NewCampaign = true
			end
		end
		if mGradeOld == GRADE.NONE and SelectedLevel == maxMissions then
			CreditsLevelNext = true
		end
		DoUnlockFlags()
		if UnlockFlagsChanged() then
			SavePrevToSeen()
			saveStats = true
		end
		if saveStats and GetGameSaveValid(SPSaveStatus) then
			nandDialog.Save(WriteSaveFile, saveCallback)
		end
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
	local defeatRate = 180 / (GetFramesPerSecond() * 6)
	local waitCount = 0
	local waitCountMax = GetFramesPerSecond() * 6.67
	function tableData.defeatRise()
		if waitCount < waitCountMax then
			waitCount = waitCount + 1
			return 140, 480 - (cos(defeatCount) * 210 + 210)
		elseif 0 < defeatCount then
			defeatCount = defeatCount - defeatRate
			return 140, 480 - (cos(defeatCount) * 210 + 210)
		else
			return 140, 480 - (cos(defeatCount) * 210 + 210)
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
		if SelectedLevel == 1 then
			return 0
		else
			return cos(fadeCount) * 127.5 + 127.5
		end
	end
	function tableData.getStatsActive()
		if SelectedLevel == 1 then
			return false
		else
			return true
		end
	end
	function PlaySoundFireworks()
		PlayEffect(Scripted_Effect.Fireworks, 3, 0, 0, 0)
	end
	local quickFadeCount = 180
	local quickFadeRate = 180 / (GetFramesPerSecond() * 0.1)
	local waitCount3 = 0
	local waitCount3Max = GetFramesPerSecond() * 4
	local waitCount4 = 0
	local waitCount4Max = GetFramesPerSecond() * 4
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
				flareEffect = GUI_Tequila_Effect_Array.Spark_Explode
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
	function tableData.getFinishFade()
		if SelectedLevel == 1 then
			return false
		else
			return fadeFinished
		end
	end
	function tableData.getAButtonReady()
		if fadeFinished == true then
			return aButtonReady
		else
			return false
		end
	end
	function tableData.isButtonActive()
		if SelectedLevel == 1 then
			return false
		else
			return fadeFinished
		end
	end
	function tableData.finishPage()
		if aButtonReady == true and fadeFinished == true then
			PopPageStack()
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
		if SelectedLevel ~= 1 then
			armyType = type
			aButtonReady = false
			if fadeFinished then
				powerHighlighted = true
				scorePowerHeight = {0, 0}
			end
		end
	end
	function tableData.openSpeedRolloverInfo()
		if SelectedLevel ~= 1 then
			armyType = 1
			aButtonReady = false
			if fadeFinished then
				speedHighlighted = true
				scoreSpeedHeight = {0, 0}
			end
		end
	end
	function tableData.openTechniqueRolloverInfo(type)
		if SelectedLevel ~= 1 then
			armyType = type
			aButtonReady = false
			if fadeFinished then
				techniqueHighlighted = true
				scoreTechniqueHeight = {0, 0}
			end
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
	function tableData.isInfantryActive()
		return 255
	end
	function tableData.isVehicleActive()
		return 255
	end
	function tableData.isAirActive()
		return 255
	end
	function tableData.isNavalActive()
		return 255
	end
	function tableData.isNavalOn()
		if SelectedLevel == 14 and techniqueHighlighted == true then
			return false
		elseif SelectedLevel == 15 and techniqueHighlighted == true then
			return false
		elseif SelectedLevel == 16 and techniqueHighlighted == true then
			return false
		else
			return true
		end
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
	function tableData.Open()
		EnableControllerErrorMessages(false)
		saveStats = false
		StatsCampaign = SelectedCampaign
		nandDialog = GetNANDDialog()
		nandDialog.Open()
		initStats()
		initData()
		initStrings()
		saveInitialLightSettings()
		if SelectedLevel ~= 1 then
			StartWidget(tableData, gradeBadge, false)
		else
			waitCount4 = waitCount4Max
		end
		if GetLevelGameType(SelectedLevel + NumFrontendLevels - 1) == GAMETYPE.SinglePlayer then
			progressLevels()
		end
		InitVictoryMusic(mGrade)
		GlobeSetTarget(SelectedCampaign)
	end
	function tableData.Update()
		nandDialog.Update()
		PollMapMusicLoop()
		updateGlobeZoom()
		updatePanelFade()
		updateQuickFade()
		changeColour()
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
	function tableData.Close()
		EnableControllerErrorMessages(true)
		resetLighting()
		StopWidget(gradeBadge)
		nandDialog.Close()
		if not TestMissionStatus(GAMESTATUS.PROLOGUE) then
			presetStackToMap()
			if not UnlockedCampaignFlag then
				PushPageStack("MapPost")
				PushPageStack(campaignNameTable[SelectedCampaign])
			end
		end
		PushPageStack("Unlock")
	end
	function GetVictoryPage()
		return tableData
	end
	DebugOut("Victory ticked ***")
end
