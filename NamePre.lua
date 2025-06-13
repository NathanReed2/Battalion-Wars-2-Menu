function NamePre(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	local keyPadStrLabelsNumbers = {
		"1",
		"2",
		"3",
		"4",
		"5",
		"6",
		"7",
		"8",
		"9",
		"0"
	}
	local keyPadStrLabelsLettersUpper = {
		".,?@",
		"ABC",
		"DEF",
		"GHI",
		"JKL",
		"MNO",
		"PQRS",
		"TUV",
		"WXYZ",
		"_"
	}
	local keyPadStrLabelsLettersLower = {
		".,?@",
		"abc",
		"def",
		"ghi",
		"jkl",
		"mno",
		"pqrs",
		"tuv",
		"wxyz",
		"_"
	}
	local keyPadStrLabels = {
		keyPadStrLabelsNumbers,
		keyPadStrLabelsLettersUpper,
		keyPadStrLabelsLettersLower,
		keyPadStrLabelsLettersLower
	}
	function tableData.getKeyPadStr(idx)
		return keyPadStrLabels[KeyPadMode][idx]
	end
	function tableData.alphaModesActive()
		return true
	end
	local fadeCount = 180
	local fadeRate = 180 / (GetFramesPerSecond() * 1.5)
	local fadeScale = 3
	local bFadeIn = true
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
			PushPageStack("Name")
		elseif not bFadeIn and 180 < fadeCount then
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
	function tableData.onAccept()
	end
	function tableData.getAcceptEnabled()
		return false
	end
	function tableData.keyPadPressed(idx)
	end
	function tableData.setFirstCapMode()
	end
	function tableData.setLowerMode()
	end
	function tableData.setUpperMode()
	end
	function tableData.setNumbersMode()
	end
	function tableData.clear()
	end
	function tableData.getAbcSet()
		if KeyPadMode == 4 then
			return 2
		end
		return 1
	end
	function tableData.getabcSet()
		if KeyPadMode == 3 then
			return 2
		end
		return 1
	end
	function tableData.getABCSet()
		if KeyPadMode == 2 then
			return 2
		end
		return 1
	end
	function tableData.get123Set()
		if KeyPadMode == 1 then
			return 2
		end
		return 1
	end
	function tableData.getKeyPadString()
		return MPText
	end
	function tableData.getKeyPadStringOverlay()
		return MPText
	end
	function tableData.Open()
		if bFadeIn then
			fadeCount = 180
		else
			fadeCount = 0
		end
	end
	function tableData.Update()
		updateAlpha()
		checkExit()
	end
	function tableData.Close()
		if bFadeIn then
			bFadeIn = false
		else
			bFadeIn = true
		end
		KeyPadMode = 4
	end
	function GetNamePrePage()
		return tableData
	end
	DebugOut("NamePre ticked ***")
end
