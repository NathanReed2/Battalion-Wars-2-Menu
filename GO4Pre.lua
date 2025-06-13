function GO4Pre(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	local fadeCount = 180
	local fadeRate = 180 / (GetFramesPerSecond() * 1.5)
	local fadeScale = 3
	bGO4PreFadeIn = true
	local function updateAlpha()
		if bGO4PreFadeIn then
			fadeCount = fadeCount - fadeRate * fadeScale
		else
			fadeCount = fadeCount + fadeRate * fadeScale
		end
	end
	local function checkExit()
		if bGO4PreFadeIn and fadeCount < 0 then
			fadeCount = 0
			PushPageStack("GO4")
		elseif not bGO4PreFadeIn and 180 < fadeCount then
			fadeCount = 180
			PopPageStack()
		end
	end
	function tableData.trapFilterCol()
		return 255
	end
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
	function tableData.faderColour(scale)
		return 255 - (cos(fadeCount) * 127.5 + 127.5)
	end
	function tableData.faderColourReverse(scale)
		return cos(fadeCount) * 127.5 + 127.5
	end
	function tableData.gotoGO1()
	end
	function tableData.gotoGO2()
	end
	function tableData.gotoGO3()
	end
	function tableData.gotoGO4()
	end
	function tableData.clear()
	end
	function tableData.gotoFriend()
	end
	function tableData.gotoName()
	end
	function tableData.gotoFriends()
	end
	function tableData.gotoStats()
	end
	function tableData.triggerSave()
	end
	function tableData.Open()
		if bGO4PreFadeIn then
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
		if bGO4PreFadeIn then
			bGO4PreFadeIn = false
		else
			bGO4PreFadeIn = true
		end
	end
	function GetGO4PrePage()
		return tableData
	end
	DebugOut("GO4 Pre ticked ***")
end
