function GO4(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	local rename = false
	local name = 1
	local clear = 2
	local yesNoMode = 0
	function tableData.getStringClear()
		return 71 + NumGlobalStrings
	end
	function tableData.getStringName()
		return 75 + NumGlobalStrings
	end
	function tableData.getStringFriends()
		return 441 + NumGlobalStrings
	end
	function tableData.getStringStats()
		return 442 + NumGlobalStrings
	end
	function tableData.backButtonText()
		return StringID.Back
	end
	function tableData.showFriends()
		return GetFriendKey() ~= "000 000 000 000"
	end
	function tableData.clear()
		yesNoMode = clear
		StartWidget(tableData, GUI_Dialog_Box_2.YesNo, true)
	end
	function tableData.gotoFriend()
		PushPageStack("Friend")
	end
	function tableData.gotoName()
		yesNoMode = name
		StartWidget(tableData, GUI_Dialog_Box_2.YesNo, true)
	end
	function tableData.gotoFriends()
		PushPageStack("FriendMatchPre")
	end
	function tableData.gotoStats()
		PushPageStack("Profile2Pre")
	end
	function tableData.triggerSave()
		PopPageStack()
	end
	local yesNoTitle = {
		StringID.ChangeName,
		StringID.ClrCamProgTitle
	}
	function tableData.YesNoTitle()
		return yesNoTitle[yesNoMode]
	end
	local yesNoMessage = {
		StringID.NameIsUsedMssg,
		StringID.ClrCamProgMssg
	}
	function tableData.YesNoMessage()
		return yesNoMessage[yesNoMode]
	end
	local function changeNameOnYes()
		rename = true
		MPText = GetProfileName(MPProfile)
		StopWidget(GUI_Dialog_Box_2.YesNo)
		yesNoMode = 0
		PushPageStack("NamePre")
	end
	local function clearSlotOnYes()
		StartNewSlot()
		ClearProfile(MPProfile)
		GOChanged = true
		GOChangedMP = true
		ResetUnlockFlags()
		SelectedCampaign = 0
		StopWidget(GUI_Dialog_Box_2.YesNo)
		yesNoMode = 0
		ClearBriefingSeenFlags(SelectedSlot)
		PopPageStack()
		PopPageStack()
		bGO4PreFadeIn = true
		PopPageStack()
		PopPageStack()
		bGOPreFadeIn = true
		PopPageStack()
		PopPageStack()
		MainPreForwards(true)
	end
	local yesNoOnYesFuncs = {changeNameOnYes, clearSlotOnYes}
	function tableData.YesNoOnYes()
		yesNoOnYesFuncs[yesNoMode]()
	end
	function tableData.YesNoOnNo()
		StopWidget(GUI_Dialog_Box_2.YesNo)
		yesNoMode = 0
	end
	function tableData.Open()
		yesNoMode = 0
		if rename then
			rename = false
			if MPText ~= "" then
				SetProfileName(MPText)
			end
		end
	end
	function tableData.Update()
		pollTitleLoop()
	end
	function tableData.Close()
	end
	function GetGO4Page()
		return tableData
	end
	DebugOut("GO4 ticked ***")
end
