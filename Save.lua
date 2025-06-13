function Save(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	local numSPLevels = 20
	local nandDialog
	local askName = false
	local gotoMap = false
	function tableData.gotoMap(id)
		SelectedSlot = id
		SetSelectedSlot(id)
		InitSettings()
		ApplySettings()
		MPProfile = id
		SetCurrentMPProfile(id)
		UpdateMPMapUnlocked()
		UpdateMPMapUnlocked()
		UpdateMPRankStatus()
		UpdateMPRankStatus()
		DoUnlockFlags()
		if GetProfileName(id) == "" then
			StartWidget(tableData, GUI_Dialog_Box_1.ShowStatus, true)
		else
			PushPageStack("MainPre")
		end
	end
	function tableData.gotoGlobeSelect()
		if BuildType() ~= Build.Final then
			PushPageStack("VictoryMP")
		end
	end
	function tableData.popThrice()
		ResetPageStack("Start")
	end
	local missionStatsText = {}
	function tableData.getSlotDetails(id)
		return missionStatsText[id]
	end
	function tableData.setUserSelectedSlot(id)
	end
	local slotLabels = {
		StringID.A,
		StringID.B,
		StringID.C
	}
	local function setSlotStatsText(id)
		SetSelectedSlot(id)
		local levelsDone = GetLevelsDone()
		if levelsDone > numSPLevels then
			levelsDone = numSPLevels
		end
		local percent = 100 / numSPLevels * levelsDone
		local percent1 = rint(percent)
		local percent10 = rint((percent - percent1) * 10) / 10
		percent = percent1 + percent10
		local name = GetProfileName(id)
		if name == "" then
			name = GetString(StringID.Save) .. " " .. GetString(slotLabels[id])
		end
		if GetSlotTime(id - 1) == 0 then
			missionStatsText[id] = name .. "\\n" .. percent .. "%"
		else
			missionStatsText[id] = name .. "\\n" .. percent .. "%"
		end
		if 0 < SelectedSlot then
			SetSelectedSlot(SelectedSlot)
		end
	end
	function tableData.ShowStatusTitle()
		return StringID.ChangeName
	end
	function tableData.ShowStatusMessage()
		return StringID.NewNameMessg
	end
	function tableData.ShowStatusButton1()
		StopWidget(GUI_Dialog_Box_1.ShowStatus)
		MPText = ""
		askName = true
		PushPageStack("Name")
	end
	function tableData.ShowStatusButton1Text()
		return StringID.Continue
	end
	local fileOpCount = 0
	local function saveCallback(status)
		if GetGameSaveValid(SPSaveStatus) then
			SetGameSaveValid(SPSaveStatus, status)
		end
		if GetGameSaveValid(MPSaveStatus) then
			SetGameSaveValid(MPSaveStatus, status)
		end
		fileOpCount = fileOpCount - 1
		if fileOpCount == 0 and gotoMap then
			gotoMap = false
			MainPreForwards(true)
			PushPageStack("MainPre")
		end
	end
	local function saveToNAND()
		if GetGameSaveValid(SPSaveStatus) and GOChanged then
			GOChanged = false
			WriteSaveFile()
			fileOpCount = fileOpCount + 1
		end
		if GetGameSaveValid(MPSaveStatus) and GOChangedMP then
			GOChangedMP = false
			RequestSaveMultiPlayer()
			fileOpCount = fileOpCount + 1
		end
	end
	local function checkSaveClearedSlot()
		if GOChanged or GOChangedMP then
			if GOChanged and GetGameSaveValid(SPSaveStatus) or GOChangedMP and GetGameSaveValid(MPSaveStatus) then
				fileOpCount = 0
				nandDialog.Save(saveToNAND, saveCallback)
			else
				GOChanged = false
				GOChangedMP = false
				gotoMap = false
				PushPageStack("MainPre")
			end
		end
	end
	function tableData.Open()
		nandDialog = GetNANDDialog()
		nandDialog.Open()
		if askName then
			askName = false
			if MPText ~= "" then
				SetProfileName(MPText)
				gotoMap = true
			end
		else
			SelectedSlot = 0
		end
		for id = 1, 3 do
			setSlotStatsText(id)
		end
	end
	function tableData.Update()
		nandDialog.Update()
		PollTitleMusicLoop()
		checkSaveClearedSlot()
	end
	function tableData.Close()
		nandDialog.Close()
	end
	function GetSavePage()
		return tableData
	end
	DebugOut("Save ticked ***")
end
