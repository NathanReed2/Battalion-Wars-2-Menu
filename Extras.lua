function Extras(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	local yesNoDialog = GUI_Dialog_Box_2.YesNo
	local yesNoAlpha = 0
	local yesNoAlphaRate = 32
	local yesNo = false
	local exitToCredits = 1
	local exitToConcepts = 2
	local isExiting = 0
	function tableData.gotoCredits()
		if isExiting == 0 then
			isExiting = exitToCredits
			initFadeOut()
			SetMusicVolume(0, MusicFadeOutSecs)
		end
	end
	function tableData.gotoConcepts()
		if isExiting == 0 then
			isExiting = exitToConcepts
			initFadeOut()
			SetMusicVolume(0, MusicFadeOutSecs)
		end
	end
	local gotoCredits = function()
		SetMissionStatus(GAMESTATUS.CREDITS)
		SelectedLevel = CreditsLevel
		FrontendDone = true
		PageDone = true
	end
	local gotoConcepts = function()
		SetMissionStatus(GAMESTATUS.CONCEPT)
		SelectedLevel = ConceptLevel
		SetTmpStore(GetNewUnlockFlags())
		FrontendDone = true
		PageDone = true
	end
	function tableData.gotoFactions()
		if isExiting == 0 then
			SetTmpStore(0)
			FactionPreForward(true)
			PushPageStack("FactionsPre")
		end
	end
	function tableData.gotoTrainingLevel()
		if isExiting == 0 then
			yesNo = true
			StartWidget(tableData, GUI_Dialog_Box_2.YesNo, true)
		end
	end
	function tableData.isPrologueOpen()
		if GetLevelsDone() > 0 then
			return true
		end
		return false
	end
	function tableData.conceptsUnlocked()
		return IsUnlocked(SolarEmpireID, UnlockConcept)
	end
	function tableData.unitsUnlocked()
		return IsUnlocked(SolarEmpireID, UnlockUnits)
	end
	function tableData.PopPageStack()
		if isExiting == 0 then
			ExtrasPreForward(false)
			PopPageStack()
		end
	end
	function tableData.YesNoTitle()
		return StringID.PlayPrologueTitle
	end
	function tableData.YesNoMessage()
		return StringID.PlayPrologueMssg
	end
	function tableData.YesNoOnYes()
		if yesNoAlpha < 255 then
			return
		end
		yesNo = false
		SelectedLevel = 1
		SelectedCampaign = 1
		GlobeSetTarget(4)
		SetMissionStatus(GAMESTATUS.PROLOGUE)
		PushPageStack("CutsceneIn")
	end
	function tableData.YesNoOnNo()
		if yesNoAlpha < 255 then
			return
		end
		yesNo = false
	end
	function tableData.YesNoColour()
		return yesNoAlpha
	end
	local function updateYesNoAlpha()
		if yesNo then
			if yesNoAlpha < 255 then
				yesNoAlpha = yesNoAlpha + yesNoAlphaRate
			end
			if 255 < yesNoAlpha then
				yesNoAlpha = 255
			end
		else
			if 0 < yesNoAlpha then
				yesNoAlpha = yesNoAlpha - yesNoAlphaRate
			end
			if yesNoAlpha < 0 then
				yesNoAlpha = 0
				StopWidget(yesNoDialog)
			end
		end
	end
	function tableData.unlockUnitsActive()
		return UnitsUnlocked()
	end
	function tableData.unlockConceptsActive()
		return ConceptsUnlocked()
	end
	function tableData.Open()
		DoUnlockFlags()
		yesNoAlpha = 0
		yesNo = false
		if TestMissionStatus(GAMESTATUS.CONCEPT) or TestMissionStatus(GAMESTATUS.CREDITS) then
			SetMissionStatus(GAMESTATUS.NONE)
			initFadeIn()
		else
			initFadeFullOn()
		end
		HighlightedLevel = -1
		isExiting = 0
	end
	function tableData.Update()
		updateFadeColour(tableData)
		pollTitleLoop()
		updateYesNoAlpha()
		if isExiting == exitToCredits and bFadeOutDone() then
			gotoCredits()
		end
		if isExiting == exitToConcepts and bFadeOutDone() then
			gotoConcepts()
		end
	end
	function tableData.Close()
	end
	function GetExtrasPage()
		return tableData
	end
	DebugOut("Extras ticked ***")
end
