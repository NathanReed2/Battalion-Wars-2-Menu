function Friend(owner)
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
	function tableData.getKeyPadStr(idx)
		return keyPadStrLabelsNumbers[idx]
	end
	function tableData.alphaModesActive()
		return false
	end
	local result = 0
	function tableData.onAccept()
		result = AddFriend(tableData.getKeyPadStringUnformatted())
		if result ~= 0 then
			StartWidget(tableData, GUI_Dialog_Box_1.ShowStatus, true)
		else
			GOChangedMP = true
			tableData.clear()
			PopPageStack()
		end
	end
	function tableData.ShowStatusTitle()
		return 613 + NumGlobalStrings
	end
	function tableData.ShowStatusMessage()
		if result == -1 then
			return 616 + NumGlobalStrings
		elseif result == -2 then
			return 615 + NumGlobalStrings
		elseif result == -3 then
			return 614 + NumGlobalStrings
		elseif result == -4 then
			return 617 + NumGlobalStrings
		else
			return 618 + NumGlobalStrings
		end
	end
	function tableData.ShowStatusButton1()
		StopWidget(GUI_Dialog_Box_1.ShowStatus)
	end
	function tableData.ShowStatusButton1Text()
		return StringID.OK
	end
	local keyPadStringLength = 12
	local keyPadIndex = 0
	local keyPadStringTable = {
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0
	}
	local tmpStr = ""
	local function addNumber(idx)
		local num = idx
		if 9 < idx then
			num = 0
		end
		if keyPadIndex < keyPadStringLength then
			keyPadIndex = keyPadIndex + 1
			keyPadStringTable[keyPadIndex] = num
		end
	end
	local function keyPadBS(idx)
		if 0 < keyPadIndex then
			keyPadIndex = keyPadIndex - 1
		end
	end
	local keyPadCR = function(idx)
	end
	local keyPadFunc = {
		addNumber,
		addNumber,
		addNumber,
		addNumber,
		addNumber,
		addNumber,
		addNumber,
		addNumber,
		addNumber,
		addNumber,
		keyPadBS,
		keyPadCR
	}
	function tableData.keyPadPressed(idx)
		keyPadFunc[idx](idx)
	end
	function tableData.setNumbersMode()
	end
	function tableData.setUpperMode()
	end
	function tableData.setLowerMode()
	end
	function tableData.setFirstCapMode()
	end
	function tableData.clear()
		for i = 1, keyPadStringLength do
			keyPadStringTable[i] = 0
		end
		keyPadIndex = 0
	end
	function tableData.getAbcSet()
		return 1
	end
	function tableData.getabcSet()
		return 1
	end
	function tableData.getABCSet()
		return 1
	end
	function tableData.get123Set()
		return 2
	end
	function tableData.getKeyPadStringUnformatted()
		tmpStr = ""
		for i = 1, keyPadIndex do
			tmpStr = tmpStr .. keyPadStringTable[i]
		end
		return tmpStr
	end
	function tableData.getKeyPadString()
		tmpStr = ""
		return tmpStr
	end
	function tableData.getKeyPadStringOverlay()
		tmpStr = ""
		for i = 1, keyPadIndex do
			tmpStr = tmpStr .. keyPadStringTable[i]
			if i == 3 or i == 6 or i == 9 then
				tmpStr = tmpStr .. " "
			end
		end
		return tmpStr
	end
	function tableData.getAcceptEnabled()
		return 11 < keyPadIndex
	end
	function tableData.Open()
		tableData.clear()
	end
	function tableData.Update()
	end
	function tableData.Close()
	end
	function GetFriendPage()
		return tableData
	end
	DebugOut("Friend ticked ***")
end
