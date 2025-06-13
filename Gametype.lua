function Gametype(owner)
	local tableData = {}
	tableData.StringMPGameTypeScreen = 399 + NumGlobalStrings
	tableData.StringAssault = 400 + NumGlobalStrings
	tableData.StringSkirmish = 401 + NumGlobalStrings
	tableData.StringCoop = 402 + NumGlobalStrings
	tableData.StringAny = 421 + NumGlobalStrings
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	function tableData.gotoLevels(what)
		MPWhat = "" .. what
		PushPageStack("LevelsPre")
	end
	function tableData.gotoAny()
		MPWhat = -1
		MPLevel = 0
		if MPWho == 1 then
			MPChallenging = true
			MPChallenged = false
			PopPageStack()
			PushPageStack("Challenge")
		else
			PushPageStack("Search")
		end
	end
	function tableData.Open()
	end
	function tableData.Update()
		PollMapMusicLoop()
		CheckChallenge(false)
		PopPageStackIfNetworkError()
	end
	function tableData.Close()
	end
	function GetGametypePage()
		return tableData
	end
	DebugOut("Gametype ticked ***")
end
