function Name(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	local nameOnEntry = ""
	KeyPadMode = 4
	local titleMode = 0
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
	local keyPadStringLength = 8
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
	local EOS = -1
	local keyPadNumbers = {}
	local keyPadLettersUpper = {}
	local keyPadLettersLower = {}
	if GetRegionStr() == "EUR" then
		local aE = NumGlobalStrings + 793
		local AE = NumGlobalStrings + 794
		local cE = NumGlobalStrings + 803
		local CE = NumGlobalStrings + 804
		local eE = NumGlobalStrings + 814
		local EE = NumGlobalStrings + 815
		local iE = NumGlobalStrings + 835
		local IE = NumGlobalStrings + 836
		local nE = NumGlobalStrings + 846
		local NE = NumGlobalStrings + 847
		local oE = NumGlobalStrings + 848
		local OE = NumGlobalStrings + 849
		local sE = NumGlobalStrings + 859
		local uE = NumGlobalStrings + 868
		local UE = NumGlobalStrings + 869
		local p1 = NumGlobalStrings + 885
		local p2 = NumGlobalStrings + 886
		local p3 = NumGlobalStrings + 887
		local p4 = NumGlobalStrings + 888
		local p5 = NumGlobalStrings + 889
		local p6 = NumGlobalStrings + 890
		local p7 = NumGlobalStrings + 891
		local p8 = NumGlobalStrings + 892
		local p9 = NumGlobalStrings + 893
		local p10 = NumGlobalStrings + 894
		local p11 = NumGlobalStrings + 895
		if GetLanguageStr() == "German" then
			local germanPunctuation = {
				".",
				",",
				"!",
				"?",
				":",
				";",
				"-",
				"(",
				")",
				"'",
				"@",
				"_",
				"/",
				"&",
				p10,
				p11,
				p7,
				p9,
				EOS
			}
			keyPadLettersUpper = {
				{"0", EOS},
				germanPunctuation,
				{
					"A",
					"B",
					"C",
					AE + 8,
					EOS
				},
				{
					"D",
					"E",
					"F",
					EOS
				},
				{
					"G",
					"H",
					"I",
					EOS
				},
				{
					"J",
					"K",
					"L",
					EOS
				},
				{
					"M",
					"N",
					"O",
					OE + 6,
					EOS
				},
				{
					"P",
					"Q",
					"R",
					"S",
					EOS
				},
				{
					"T",
					"U",
					"V",
					UE + 6,
					EOS
				},
				{
					"W",
					"X",
					"Y",
					"Z",
					EOS
				},
				{" ", EOS}
			}
			keyPadLettersLower = {
				{"0", EOS},
				germanPunctuation,
				{
					"a",
					"b",
					"c",
					aE + 8,
					EOS
				},
				{
					"d",
					"e",
					"f",
					eE,
					EOS
				},
				{
					"g",
					"h",
					"i",
					EOS
				},
				{
					"j",
					"k",
					"l",
					EOS
				},
				{
					"m",
					"n",
					"o",
					oE + 6,
					EOS
				},
				{
					"p",
					"q",
					"r",
					"s",
					sE,
					EOS
				},
				{
					"t",
					"u",
					"v",
					uE + 6,
					EOS
				},
				{
					"w",
					"x",
					"y",
					"z",
					EOS
				},
				{" ", EOS}
			}
		elseif GetLanguageStr() == "French" then
			local frenchPunctuation = {
				".",
				",",
				"?",
				"!",
				"-",
				"'",
				":",
				"@",
				"/",
				"$",
				"#",
				"&",
				p1,
				p2,
				p3,
				p4,
				EOS
			}
			keyPadLettersUpper = {
				{"0", EOS},
				frenchPunctuation,
				{
					"A",
					"B",
					"C",
					AE + 2,
					AE + 4,
					AE + 8,
					CE,
					EOS
				},
				{
					"D",
					"E",
					"F",
					EE,
					EE + 2,
					EE + 4,
					EE + 6,
					EOS
				},
				{
					"G",
					"H",
					"I",
					IE + 2,
					IE + 4,
					EOS
				},
				{
					"J",
					"K",
					"L",
					EOS
				},
				{
					"M",
					"N",
					"O",
					OE + 2,
					OE + 4,
					OE + 6,
					EOS
				},
				{
					"P",
					"Q",
					"R",
					"S",
					EOS
				},
				{
					"T",
					"U",
					"V",
					UE + 2,
					UE + 4,
					UE + 6,
					EOS
				},
				{
					"W",
					"X",
					"Y",
					"Z",
					EOS
				},
				{" ", EOS}
			}
			keyPadLettersLower = {
				{"0", EOS},
				frenchPunctuation,
				{
					"a",
					"b",
					"c",
					aE + 2,
					aE + 4,
					aE + 8,
					cE,
					EOS
				},
				{
					"d",
					"e",
					"f",
					eE,
					eE + 2,
					eE + 4,
					eE + 6,
					EOS
				},
				{
					"g",
					"h",
					"i",
					iE + 2,
					iE + 4,
					EOS
				},
				{
					"j",
					"k",
					"l",
					EOS
				},
				{
					"m",
					"n",
					"o",
					oE + 2,
					oE + 4,
					oE + 6,
					EOS
				},
				{
					"p",
					"q",
					"r",
					"s",
					EOS
				},
				{
					"t",
					"u",
					"v",
					uE + 2,
					uE + 4,
					uE + 6,
					EOS
				},
				{
					"w",
					"x",
					"y",
					"z",
					EOS
				},
				{" ", EOS}
			}
		elseif GetLanguageStr() == "Spanish" then
			local spanishPunctuation = {
				".",
				",",
				"?",
				p5,
				"!",
				p6,
				"-",
				"'",
				":",
				"@",
				"/",
				"$",
				"#",
				"&",
				p1,
				p8,
				p9,
				p3,
				p4,
				EOS
			}
			keyPadLettersUpper = {
				{"0", EOS},
				spanishPunctuation,
				{
					"A",
					"B",
					"C",
					AE,
					EOS
				},
				{
					"D",
					"E",
					"F",
					EE,
					EOS
				},
				{
					"G",
					"H",
					"I",
					IE,
					EOS
				},
				{
					"J",
					"K",
					"L",
					EOS
				},
				{
					"M",
					"N",
					"O",
					NE,
					OE,
					EOS
				},
				{
					"P",
					"Q",
					"R",
					"S",
					EOS
				},
				{
					"T",
					"U",
					"V",
					UE,
					UE + 6,
					EOS
				},
				{
					"W",
					"X",
					"Y",
					"Z",
					EOS
				},
				{" ", EOS}
			}
			keyPadLettersLower = {
				{"0", EOS},
				spanishPunctuation,
				{
					"a",
					"b",
					"c",
					aE,
					EOS
				},
				{
					"d",
					"e",
					"f",
					eE,
					EOS
				},
				{
					"g",
					"h",
					"i",
					iE,
					EOS
				},
				{
					"j",
					"k",
					"l",
					EOS
				},
				{
					"m",
					"n",
					"o",
					nE,
					oE,
					EOS
				},
				{
					"p",
					"q",
					"r",
					"s",
					EOS
				},
				{
					"t",
					"u",
					"v",
					uE,
					uE + 6,
					EOS
				},
				{
					"w",
					"x",
					"y",
					"z",
					EOS
				},
				{" ", EOS}
			}
		elseif GetLanguageStr() == "Italian" then
			italianPunctuation = {
				".",
				",",
				"?",
				"!",
				"-",
				"'",
				":",
				"@",
				"/",
				"$",
				"#",
				"&",
				p1,
				p8,
				p9,
				p3,
				p4,
				EOS
			}
			keyPadLettersUpper = {
				{"0", EOS},
				italianPunctuation,
				{
					"A",
					"B",
					"C",
					AE + 2,
					EOS
				},
				{
					"D",
					"E",
					"F",
					EE,
					EE + 2,
					EOS
				},
				{
					"G",
					"H",
					"I",
					IE + 6,
					EOS
				},
				{
					"J",
					"K",
					"L",
					EOS
				},
				{
					"M",
					"N",
					"O",
					OE + 8,
					EOS
				},
				{
					"P",
					"Q",
					"R",
					"S",
					EOS
				},
				{
					"T",
					"U",
					"V",
					UE + 2,
					EOS
				},
				{
					"W",
					"X",
					"Y",
					"Z",
					EOS
				},
				{" ", EOS}
			}
			keyPadLettersLower = {
				{"0", EOS},
				italianPunctuation,
				{
					"a",
					"b",
					"c",
					aE + 2,
					EOS
				},
				{
					"d",
					"e",
					"f",
					eE,
					eE + 2,
					EOS
				},
				{
					"g",
					"h",
					"i",
					iE + 6,
					EOS
				},
				{
					"j",
					"k",
					"l",
					EOS
				},
				{
					"m",
					"n",
					"o",
					oE + 8,
					EOS
				},
				{
					"p",
					"q",
					"r",
					"s",
					EOS
				},
				{
					"t",
					"u",
					"v",
					uE + 2,
					EOS
				},
				{
					"w",
					"x",
					"y",
					"z",
					EOS
				},
				{" ", EOS}
			}
		else
			local englishPunctuation = {
				".",
				",",
				"?",
				"!",
				"-",
				"'",
				":",
				"@",
				"/",
				"$",
				"#",
				"&",
				"(",
				")",
				"[",
				"]",
				EOS
			}
			keyPadLettersUpper = {
				{"0", EOS},
				englishPunctuation,
				{
					"A",
					"B",
					"C",
					EOS
				},
				{
					"D",
					"E",
					"F",
					EOS
				},
				{
					"G",
					"H",
					"I",
					EOS
				},
				{
					"J",
					"K",
					"L",
					EOS
				},
				{
					"M",
					"N",
					"O",
					EOS
				},
				{
					"P",
					"Q",
					"R",
					"S",
					EOS
				},
				{
					"T",
					"U",
					"V",
					EOS
				},
				{
					"W",
					"X",
					"Y",
					"Z",
					EOS
				},
				{" ", EOS}
			}
			keyPadLettersLower = {
				{"0", EOS},
				englishPunctuation,
				{
					"a",
					"b",
					"c",
					EOS
				},
				{
					"d",
					"e",
					"f",
					EOS
				},
				{
					"g",
					"h",
					"i",
					EOS
				},
				{
					"j",
					"k",
					"l",
					EOS
				},
				{
					"m",
					"n",
					"o",
					EOS
				},
				{
					"p",
					"q",
					"r",
					"s",
					EOS
				},
				{
					"t",
					"u",
					"v",
					EOS
				},
				{
					"w",
					"x",
					"y",
					"z",
					EOS
				},
				{" ", EOS}
			}
		end
	else
		local englishPunctuation = {
			".",
			",",
			"?",
			"!",
			"-",
			"'",
			":",
			"@",
			"/",
			"$",
			"#",
			"&",
			"(",
			")",
			"[",
			"]",
			EOS
		}
		keyPadLettersUpper = {
			{"0", EOS},
			englishPunctuation,
			{
				"A",
				"B",
				"C",
				EOS
			},
			{
				"D",
				"E",
				"F",
				EOS
			},
			{
				"G",
				"H",
				"I",
				EOS
			},
			{
				"J",
				"K",
				"L",
				EOS
			},
			{
				"M",
				"N",
				"O",
				EOS
			},
			{
				"P",
				"Q",
				"R",
				"S",
				EOS
			},
			{
				"T",
				"U",
				"V",
				EOS
			},
			{
				"W",
				"X",
				"Y",
				"Z",
				EOS
			},
			{" ", EOS}
		}
		keyPadLettersLower = {
			{"0", EOS},
			englishPunctuation,
			{
				"a",
				"b",
				"c",
				EOS
			},
			{
				"d",
				"e",
				"f",
				EOS
			},
			{
				"g",
				"h",
				"i",
				EOS
			},
			{
				"j",
				"k",
				"l",
				EOS
			},
			{
				"m",
				"n",
				"o",
				EOS
			},
			{
				"p",
				"q",
				"r",
				"s",
				EOS
			},
			{
				"t",
				"u",
				"v",
				EOS
			},
			{
				"w",
				"x",
				"y",
				"z",
				EOS
			},
			{" ", EOS}
		}
	end
	local keyPadLetters = {
		keyPadNumbers,
		keyPadLettersUpper,
		keyPadLettersLower,
		keyPadLettersLower
	}
	function tableData.onAccept()
		MPText = GetStringFromTable(keyPadStringTable)
		if nameOnEntry ~= MPText then
			GOChanged = true
		end
		PopPageStack()
	end
	function tableData.getAcceptEnabled()
		return keyPadIndex ~= 0
	end
	local function setTitleModeUppercase()
		titleMode = 2
		keyPadLetters[4] = keyPadLettersUpper
		keyPadStrLabels[4] = keyPadStrLabelsLettersUpper
	end
	local function setTitleModeLowercase()
		titleMode = 0
		keyPadLetters[4] = keyPadLettersLower
		keyPadStrLabels[4] = keyPadStrLabelsLettersLower
	end
	local keyPadLetter = 0
	local previousInput = -1
	local previousTime = 0
	local currentTime = 0
	local maximumTime = 1
	local function addLetter(idx)
		keyPadLetter = keyPadLetter + 1
		if keyPadLetters[KeyPadMode][idx + 1][keyPadLetter] == EOS then
			keyPadLetter = 1
		end
		local mode = KeyPadMode
		if KeyPadMode == 4 then
			if titleMode == 2 then
				mode = 2
			elseif titleMode == 0 then
				mode = 3
			end
		end
		local char = keyPadLetters[mode][idx + 1][keyPadLetter]
		if char == " " and keyPadIndex == 1 then
			keyPadIndex = 0
			previousInput = -1
			currentTime = 0
			previousTime = 0
		else
			keyPadStringTable[keyPadIndex] = char
			if char == " " and KeyPadMode == 4 then
				setTitleModeUppercase()
			end
		end
	end
	local function addLetters(idx)
		if currentTime > previousTime + maximumTime or idx ~= previousInput then
			if 0 < titleMode then
				if titleMode == 2 then
					titleMode = 1
				elseif titleMode == 1 then
					setTitleModeLowercase()
				else
					titleMode = 0
				end
			end
			keyPadLetter = 0
			if keyPadIndex < keyPadStringLength then
				keyPadIndex = keyPadIndex + 1
			else
				return
			end
		end
		previousTime = currentTime
		previousInput = idx
		addLetter(idx)
	end
	local function addNumber(idx)
		local num = idx
		if 9 < idx then
			num = 0
		end
		if keyPadIndex < keyPadStringLength then
			keyPadIndex = keyPadIndex + 1
			keyPadStringTable[keyPadIndex] = "" .. num
		end
	end
	local function keyPadBS(idx)
		if 0 < keyPadIndex then
			keyPadIndex = keyPadIndex - 1
			if KeyPadMode == 4 then
				if keyPadStringTable[keyPadIndex] == " " or keyPadIndex == 0 then
					setTitleModeUppercase()
				else
					setTitleModeLowercase()
				end
			end
		end
	end
	local keyPadCR = function(idx)
	end
	local keyPadFunc1 = {
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
	local keyPadFunc2 = {
		addLetters,
		addLetters,
		addLetters,
		addLetters,
		addLetters,
		addLetters,
		addLetters,
		addLetters,
		addLetters,
		addLetters,
		keyPadBS,
		keyPadCR
	}
	local keyPadFunc = {
		keyPadFunc1,
		keyPadFunc2,
		keyPadFunc2,
		keyPadFunc2
	}
	function tableData.keyPadPressed(idx)
		keyPadFunc[KeyPadMode][idx](idx)
	end
	function tableData.setFirstCapMode()
		KeyPadMode = 4
		setTitleModeUppercase()
	end
	function tableData.setLowerMode()
		titleMode = 0
		KeyPadMode = 3
	end
	function tableData.setUpperMode()
		titleMode = 0
		KeyPadMode = 2
	end
	function tableData.setNumbersMode()
		titleMode = 0
		KeyPadMode = 1
	end
	function tableData.clear()
		for i = 1, keyPadStringLength do
			keyPadStringTable[i] = 0
		end
		keyPadIndex = 0
		if KeyPadMode == 4 then
			setTitleModeUppercase()
		end
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
		keyPadStringTable[keyPadIndex + 1] = EOS
		return keyPadStringTable
	end
	local tmpKeyPadStringTable = {
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
	function tableData.getKeyPadStringOverlay()
		if currentTime > previousTime + maximumTime then
			return keyPadStringTable
		else
			for i = 1, keyPadIndex - 1 do
				tmpKeyPadStringTable[i] = keyPadStringTable[i]
			end
			tmpKeyPadStringTable[keyPadIndex] = EOS
			return tmpKeyPadStringTable
		end
	end
	function tableData.Open()
		nameOnEntry = GetProfileName(SelectedSlot)
		keyPadIndex = 0
		while GetCharFromString(MPText, keyPadIndex) ~= "" do
			keyPadStringTable[keyPadIndex + 1] = GetCharFromString(MPText, keyPadIndex)
			keyPadIndex = keyPadIndex + 1
		end
		KeyPadMode = 4
		if keyPadIndex == 0 then
			setTitleModeUppercase()
		else
			setTitleModeLowercase()
		end
	end
	function tableData.Update()
		currentTime = GetTime()
		if currentTime > previousTime + maximumTime and titleMode == 1 then
			setTitleModeLowercase()
		end
	end
	function tableData.Close()
	end
	function GetNamePage()
		return tableData
	end
	DebugOut("Name ticked ***")
end
