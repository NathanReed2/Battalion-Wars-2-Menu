function LevelsPre(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	local fadeCount = 180
	local fadeRate = 180 / (GetFramesPerSecond() * 1.5)
	local fadeScale = 3
	bLevelsPreFadeIn = true
	local function updateAlpha()
		if bLevelsPreFadeIn then
			fadeCount = fadeCount - fadeRate * fadeScale
		else
			fadeCount = fadeCount + fadeRate * fadeScale
		end
	end
	local function checkExit()
		if bLevelsPreFadeIn and fadeCount < 0 then
			fadeCount = 0
			PushPageStack("Levels")
		elseif not bLevelsPreFadeIn and 180 < fadeCount then
			fadeCount = 180
			PopPageStack()
		end
	end
	function tableData.trapFilterCol()
		return 255
	end
	local chosenLevel = 0
	local singleMaps = NumLevels
	local assaultMaps = 10
	local skirmishMaps = 10
	local coopMaps = 10
	function tableData.isAssault()
		return MPWhat == "1"
	end
	function tableData.isSkirmish()
		return MPWhat == "0"
	end
	function tableData.isCoop()
		return MPWhat == "2"
	end
	function tableData.isLocked(iLevel)
		return false
	end
	local mpLevel = {
		6,
		2,
		4,
		1,
		3,
		5,
		0,
		0,
		0,
		0,
		6,
		2,
		3,
		5,
		4,
		1,
		0,
		0,
		0,
		0,
		4,
		1,
		2,
		3
	}
	function tableData.getLevelName(iLevel)
		if tableData.isSkirmish() then
			iLevel = iLevel + assaultMaps
		elseif tableData.isCoop() then
			iLevel = iLevel + assaultMaps + skirmishMaps
		end
		if MPIsUnlocked(iLevel) then
			return mpLevel[iLevel] .. ". " .. GetString(GetMissionNameStart() + singleMaps + iLevel - 1)
		else
			return StringID.Locked
		end
	end
	function tableData.getChosenLevelName()
		if chosenLevel == 0 then
			return ""
		else
			return tableData.getLevelName(chosenLevel)
		end
	end
	function tableData.getChosenLevelDescription()
		if chosenLevel == 0 then
			return ""
		else
			local iLevel = chosenLevel
			if tableData.isSkirmish() then
				iLevel = iLevel + assaultMaps
			elseif tableData.isCoop() then
				iLevel = iLevel + assaultMaps + skirmishMaps
			end
			if MPIsUnlocked(iLevel) then
				return GetMissionDescStart() + singleMaps + iLevel - 1
			else
				return ""
			end
		end
	end
	local mpMissionDescAlphaCount = 0
	local fadeInRate = 0
	local fadeOutRate = 0
	local chosenLevelSwitch = 0
	local function updatempMissionDescAlpha()
		if chosenLevelSwitch == 0 then
			mpMissionDescAlphaCount = mpMissionDescAlphaCount - fadeOutRate
			if mpMissionDescAlphaCount < 0 then
				mpMissionDescAlphaCount = 0
				chosenLevel = 0
			end
		else
			mpMissionDescAlphaCount = mpMissionDescAlphaCount + fadeInRate
			if 512 < mpMissionDescAlphaCount then
				mpMissionDescAlphaCount = 512
			end
		end
	end
	function tableData.mpMissionDescAlpha(inRate, outRate)
		fadeInRate = inRate
		fadeOutRate = outRate
		if mpMissionDescAlphaCount < 255 then
			return mpMissionDescAlphaCount
		else
			return 255
		end
	end
	function tableData.gotoSearch()
		local iLevel = chosenLevel
		if tableData.isSkirmish() then
			iLevel = iLevel + assaultMaps
		elseif tableData.isCoop() then
			iLevel = iLevel + assaultMaps + skirmishMaps
		end
	end
	function tableData.activateLevel(iLevel)
	end
	function tableData.selectLevel(iLevel)
	end
	function tableData.deselectLevel()
	end
	function tableData.searchAnyLevel()
	end
	function tableData.faderColour(scale)
		return 255 - (cos(fadeCount) * 127.5 + 127.5)
	end
	function tableData.faderColourReverse(scale)
		return cos(fadeCount) * 127.5 + 127.5
	end
	function tableData.gotoLevels(what)
	end
	function tableData.gotoAny()
	end
	tableData.StringMPGameTypeScreen = 399 + NumGlobalStrings
	tableData.StringAssault = 400 + NumGlobalStrings
	tableData.StringSkirmish = 401 + NumGlobalStrings
	tableData.StringCoop = 402 + NumGlobalStrings
	tableData.StringAny = 421 + NumGlobalStrings
	tableData.StringMPMissionSelectScreen = 420 + NumGlobalStrings
	tableData.StringPlayAny = 421 + NumGlobalStrings
	function tableData.Open()
		if bLevelsPreFadeIn then
			fadeCount = 180
		else
			fadeCount = 0
		end
	end
	function tableData.Update()
		PollMapMusicLoop()
		CheckChallenge(false)
		PopPageStackIfNetworkError()
		updateAlpha()
		checkExit()
	end
	function tableData.Close()
		if bLevelsPreFadeIn then
			bLevelsPreFadeIn = false
		else
			bLevelsPreFadeIn = true
		end
	end
	function GetLevelsPrePage()
		return tableData
	end
	DebugOut("LevelsPre ticked ***")
end
