function GametypePre(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
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
			PushPageStack("Gametype")
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
	function tableData.gotoLevels(what)
	end
	function tableData.gotoAny()
	end
	function tableData.gotoFriendmatch()
	end
	function tableData.gotoGametype()
	end
	function tableData.gotoSearch()
	end
	function tableData.gotoStatistics()
	end
	tableData.StringMPGameTypeScreen = 399 + NumGlobalStrings
	tableData.StringAssault = 400 + NumGlobalStrings
	tableData.StringSkirmish = 401 + NumGlobalStrings
	tableData.StringCoop = 402 + NumGlobalStrings
	tableData.StringAny = 421 + NumGlobalStrings
	tableData.StringMultiplayerScreen = 336 + NumGlobalStrings
	tableData.StringPlayRandom = 357 + NumGlobalStrings
	tableData.StringPlayFriend = 358 + NumGlobalStrings
	function tableData.getPlayAnyone()
		return GetString(StringID.PlayAnyone)
	end
	function tableData.Open()
		if bFadeIn then
			fadeCount = 180
		else
			fadeCount = 0
		end
	end
	function tableData.Update()
		PollMapMusicLoop()
		CheckChallenge(false)
		PopPageStackIfNetworkError()
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
	function GetGametypePrePage()
		return tableData
	end
	DebugOut("GametypePre ticked ***")
end
