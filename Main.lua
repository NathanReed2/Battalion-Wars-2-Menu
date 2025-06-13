function Main(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	function tableData.gotoSave()
		if GetLevelsDone() == 0 then
			SelectedLevel = 1
			SelectedCampaign = 1
			GlobeSetTarget(4)
			SetMissionStatus(GAMESTATUS.TRAINING)
			PushPageStack("CutsceneIn")
		else
			MapPreFade(true)
			PushPageStack("MapPre")
		end
	end
	function tableData.gotoMP()
		MPProfileLoading = true
		PushPageStack(GetMPPageFromCode())
	end
	function tableData.gotoGO()
		GOChanged = false
		GOChangedMP = false
		InitSettings()
		SaveProfileToUndoBuffer()
		NameUndoBuffer = GetProfileName(SelectedSlot)
		PushPageStack("GOPre")
	end
	function tableData.gotoExtras()
		ExtrasPreForward(true)
		PushPageStack("ExtrasPre")
	end
	function tableData.gotoGlobeSelect()
		if BuildType() ~= Build.Final then
			PushPageStack("Unlock")
		end
	end
	function tableData.unlockActive()
		return UnitsUnlocked() or ConceptsUnlocked()
	end
	function tableData.PopPageStack()
		MainPreForwards(false)
		PopPageStack()
	end
	function tableData.Open()
		DoUnlockFlags()
	end
	function tableData.Update()
		UnblockHomebutton()
		PollTitleMusicLoop()
	end
	function tableData.Close()
	end
	function GetMainPage()
		return tableData
	end
	DebugOut("Main ticked ***")
end
