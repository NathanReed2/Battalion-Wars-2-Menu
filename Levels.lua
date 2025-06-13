function Levels(owner)
	local tableData = {}
	tableData.StringMPMissionSelectScreen = 420 + NumGlobalStrings
	tableData.StringPlayAny = 421 + NumGlobalStrings
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
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
		if tableData.isSkirmish() then
			iLevel = iLevel + assaultMaps
		elseif tableData.isCoop() then
			iLevel = iLevel + assaultMaps + skirmishMaps
		end
		if MPIsUnlocked(iLevel) then
			return true
		else
			return false
		end
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
	function getLevelNameString(iLevel)
		if tableData.isSkirmish() then
			iLevel = iLevel + assaultMaps
		elseif tableData.isCoop() then
			iLevel = iLevel + assaultMaps + skirmishMaps
		end
		return GetMissionNameStart() + singleMaps + iLevel - 1
	end
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
			return getLevelNameString(chosenLevel)
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
		MPLevel = iLevel
		if MPIsUnlocked(MPLevel) then
			PushPageStack("ChooseArmy")
		end
	end
	function tableData.activateLevel(iLevel)
		chosenLevel = iLevel
		MPText = tableData.getChosenLevelName()
		tableData.gotoSearch()
	end
	function tableData.selectLevel(iLevel)
		chosenLevel = iLevel
		chosenLevelSwitch = 1
	end
	function tableData.deselectLevel()
		chosenLevelSwitch = 0
	end
	function tableData.searchAnyLevel()
		MPLevel = 0
		if MPWho == 1 then
			MPChallenging = true
			MPChallenged = false
			PopPageStack()
			PopPageStack()
			PopPageStack()
			bLevelsPreFadeIn = true
			PushPageStack("Challenge")
		else
			PushPageStack("Search")
		end
	end
	function tableData.Open()
		chosenLevel = 0
	end
	function tableData.Update()
		PollMapMusicLoop()
		CheckChallenge(false)
		updatempMissionDescAlpha()
		PopPageStackIfNetworkError()
	end
	function tableData.Close()
	end
	function GetLevelsPage()
		return tableData
	end
	DebugOut("Levels ticked ***")
end
