function ExtrasPre(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	local fadeCount = 180
	local fadeRate = 180 / (GetFramesPerSecond() * 1.5)
	local fadeScale = 3
	local bFadeIn = true
	function ExtrasPreForward(flag)
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
			PushPageStack("Extras")
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
	function tableData.gotoSave()
	end
	function tableData.gotoMP()
	end
	function tableData.gotoGO()
	end
	function tableData.gotoExtras()
	end
	function tableData.gotoGO1()
	end
	function tableData.gotoGO2()
	end
	function tableData.gotoGO3()
	end
	function tableData.gotoGO4()
	end
	function tableData.unlockUnitsActive()
		return UnitsUnlocked()
	end
	function tableData.unlockConceptsActive()
		return ConceptsUnlocked()
	end
	function tableData.Open()
		if bFadeIn then
			fadeCount = 180
		else
			fadeCount = 0
		end
	end
	function tableData.Update()
		pollTitleLoop()
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
	function GetExtrasPrePage()
		return tableData
	end
	DebugOut("ExtrasPre page ticked ***")
end
