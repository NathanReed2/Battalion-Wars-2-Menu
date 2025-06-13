function FactionsPre(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	function tableData.getFactionName()
		if SelectedFaction == 0 then
			return ""
		else
			return FactionNameTable[SelectedFaction]
		end
	end
	local fadeCount = 180
	local fadeRate = 180 / (GetFramesPerSecond() * 1.5)
	local fadeScale = 3
	local bFadeIn = true
	function FactionPreForward(flag)
		bFadeIn = flag
	end
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
			PushPageStack("Factions")
		elseif not bFadeIn and 180 < fadeCount then
			fadeCount = 180
			PopPageStack()
		end
	end
	function tableData.trapFilterCol()
		return 255
	end
	function tableData.faderColour(scale)
		return 255 - (cos(fadeCount) * 127.5 + 127.5)
	end
	function tableData.faderColourReverse(scale)
		return cos(fadeCount) * 127.5 + 127.5
	end
	function tableData.gotoNextPage()
	end
	local panelAlpha = 0
	function tableData.openRolloverInfo(factionID)
	end
	function tableData.closeRolloverInfo()
	end
	function tableData.getPanelMapInfoAlpha()
		return panelAlpha
	end
	function tableData.gotoCredits()
	end
	function tableData.gotoMovies()
	end
	function tableData.gotoConcepts()
	end
	function tableData.gotoFactions()
	end
	function tableData.gotoTrainingLevel()
	end
	function tableData.isPrologueOpen()
		if GetLevelsDone() > 0 then
			return true
		else
			return false
		end
	end
	function tableData.conceptsUnlocked()
		return IsUnlocked(SolarEmpireID, UnlockConcept)
	end
	function tableData.unitsUnlocked()
		return IsUnlocked(SolarEmpireID, UnlockUnits)
	end
	function tableData.unlockUnitsActive()
		return UnitsUnlocked()
	end
	function tableData.unlockConceptsActive()
		return ConceptsUnlocked()
	end
	function tableData.getFactionUnlocked(faction)
		return IsUnlocked(faction, UnlockUnits)
	end
	function tableData.unlockedSEActive()
		return C1Unlocked(UnlockUnits)
	end
	function tableData.unlockedWFActive()
		return C2Unlocked(UnlockUnits)
	end
	function tableData.unlockedAIActive()
		return C3Unlocked(UnlockUnits)
	end
	function tableData.unlockedILActive()
		return C4Unlocked(UnlockUnits)
	end
	function tableData.unlockedTTActive()
		return C5Unlocked(UnlockUnits)
	end
	function tableData.unlockedXActive()
		return C6Unlocked(UnlockUnits)
	end
	function tableData.Open()
		if bFadeIn then
			fadeCount = 180
		else
			fadeCount = 0
		end
	end
	function tableData.Update()
		PollTitleMusicLoop()
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
	function GetFactionsPrePage()
		return tableData
	end
	DebugOut("FactionsPre ticked ***")
end
