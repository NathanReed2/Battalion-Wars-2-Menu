function GO(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	local nandDialog
	function tableData.gotoGO1()
		PushPageStack("GO1Pre")
	end
	function tableData.gotoGO2()
		PushPageStack("GO2Pre")
	end
	function tableData.gotoGO3()
		PushPageStack("GO3")
	end
	function tableData.gotoGO4()
		PushPageStack("GO4Pre")
	end
	local initOptions = function()
	end
	local endOptions = function()
	end
	local countFileOpsOnSave = 0
	local function goSaveCallback(status)
		if GetGameSaveValid(SPSaveStatus) then
			SetGameSaveValid(SPSaveStatus, status)
		end
		if GetGameSaveValid(MPSaveStatus) then
			SetGameSaveValid(MPSaveStatus, status)
		end
		countFileOpsOnSave = countFileOpsOnSave - 1
		if countFileOpsOnSave == 0 then
			PopPageStack()
		end
	end
	local function saveToNAND()
		if GetGameSaveValid(SPSaveStatus) and GOChanged then
			GOChanged = false
			countFileOpsOnSave = countFileOpsOnSave + 1
			WriteSaveFile()
		end
		if GetGameSaveValid(MPSaveStatus) and GOChangedMP then
			GOChangedMP = false
			countFileOpsOnSave = countFileOpsOnSave + 1
			RequestSaveMultiPlayer()
		end
	end
	function tableData.backButtonText()
		if BuildType() ~= Build.Final and (GOChanged or GOChangedMP) then
			return StringID.Save
		end
		return StringID.Back
	end
	local yesNoDialog = GUI_Dialog_Box_2.YesNo
	local yesNoAlpha = 0
	local yesNoAlphaRate = 32
	local yesNo = false
	function tableData.YesNoTitle()
		return StringID.OptionsDialogTitle
	end
	function tableData.YesNoMessage()
		return StringID.OptionsDialogMssg
	end
	function tableData.YesNoOnYes()
		if yesNoAlpha < 255 then
			return
		end
		yesNo = false
		StopWidget(yesNoDialog)
		EndSettings()
		if GetGameSaveValid(SPSaveStatus) and GOChanged or GetGameSaveValid(MPSaveStatus) and GOChangedMP then
			yesNoAlpha = 0
			countFileOpsOnSave = 0
			nandDialog.Save(saveToNAND, goSaveCallback)
		else
			PopPageStack()
		end
	end
	function tableData.YesNoOnNo()
		if yesNoAlpha < 255 then
			return
		end
		yesNo = false
		StopWidget(yesNoDialog)
		GOChanged = false
		GOChangedMP = false
		InitSettings()
		ApplySettings()
		RestoreProfileFromUndoBuffer()
		SetProfileName(NameUndoBuffer)
		PopPageStack()
	end
	function tableData.triggerSave()
		if 0 < yesNoAlpha then
			return
		end
		if GetGameSaveValid(SPSaveStatus) and GOChanged or GetGameSaveValid(MPSaveStatus) and GOChangedMP then
			yesNo = true
			StartWidget(tableData, yesNoDialog, true)
		else
			PopPageStack()
		end
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
	function tableData.Open()
		yesNoAlpha = 0
		yesNo = false
		nandDialog = GetNANDDialog()
		nandDialog.Open()
		initOptions()
	end
	function tableData.Update()
		nandDialog.Update()
		pollTitleLoop()
		updateYesNoAlpha()
	end
	function tableData.Close()
		endOptions()
		nandDialog.Close()
	end
	function GetGOPage()
		return tableData
	end
	DebugOut("GO ticked ***")
end
