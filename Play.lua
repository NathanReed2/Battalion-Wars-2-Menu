function Play(owner)
	local tableData = {}
	tableData.StringMultiplayerScreen = 336 + NumGlobalStrings
	tableData.StringPlayRandom = 357 + NumGlobalStrings
	tableData.StringPlayFriend = 358 + NumGlobalStrings
	function tableData.getPlayAnyone()
		return GetString(StringID.PlayAnyone)
	end
	local status = NETWORK.OK
	local statusError = NETWORK.OK
	local failed = false
	local trying = false
	local badName = false
	local code = ""
	local nandDialog
	local saving = false
	local wasConnected = false
	local testing = false
	local yesNoMode = 1
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	function tableData.gotoFriendmatch()
		PushPageStack("FriendMatchPlayPre")
	end
	function tableData.gotoGametype()
		PushPageStack("GametypePre")
	end
	function tableData.gotoSearch()
		PushPageStack("Search")
	end
	function tableData.gotoStatistics()
		PushPageStack("ProfilePlayPre")
	end
	function tableData.hasFriends()
		local friend = 64
		while 0 < friend do
			local name = GetFriendName(friend)
			if name ~= "" then
				return true
			end
			friend = friend - 1
		end
		return false
	end
	local function saveCallback(status)
		SetGameSaveValid(MPSaveStatus, status)
		saving = false
	end
	local function yesNoConnectTitle()
		if failed then
			return 343 + NumGlobalStrings
		else
			return 337 + NumGlobalStrings
		end
	end
	local yesNoDisconnectTitle = function()
		return 338 + NumGlobalStrings
	end
	local yesNoTitles = {yesNoConnectTitle, yesNoDisconnectTitle}
	function tableData.YesNoTitle()
		return yesNoTitles[yesNoMode]()
	end
	local function yesNoConnectMessage()
		if failed then
			local newStatus = status
			status = statusError
			local message = tableData.ShowNetworkMessage()
			status = newStatus
			return message
		else
			return 339 + NumGlobalStrings
		end
	end
	local yesNoDisconnectMessage = function()
		return 340 + NumGlobalStrings
	end
	local yesNoMessages = {yesNoConnectMessage, yesNoDisconnectMessage}
	function tableData.YesNoMessage()
		return yesNoMessages[yesNoMode]()
	end
	local function yesNoOnYesConnect()
		StopWidget(GUI_Dialog_Box_2.YesNo)
		status = NETWORK.OK
		StartWidget(tableData, GUI_Dialog_Box_0.ShowStatusAnimation, true)
		RequestNetworkOpen(MPProfile)
		trying = true
	end
	local function yesNoOnYesDisconnect()
		StopWidget(GUI_Dialog_Box_2.YesNo)
		RequestNetworkClose()
		PopPageStack()
		wasConnected = false
	end
	local yesNoOnYesFuncs = {yesNoOnYesConnect, yesNoOnYesDisconnect}
	function tableData.YesNoOnYes()
		yesNoOnYesFuncs[yesNoMode]()
	end
	local yesNoOnNoConnect = function()
		StopWidget(GUI_Dialog_Box_2.YesNo)
		PopPageStack()
	end
	local yesNoOnNoDisconnect = function()
		StopWidget(GUI_Dialog_Box_2.YesNo)
	end
	local yesNoOnNoFuncs = {yesNoOnNoConnect, yesNoOnNoDisconnect}
	function tableData.YesNoOnNo()
		yesNoOnNoFuncs[yesNoMode]()
	end
	function tableData.ShowStatusTitle()
		if badName then
			return 360 + NumGlobalStrings
		else
			return 341 + NumGlobalStrings
		end
	end
	function tableData.ShowStatusMessage()
		if badName then
			return 361 + NumGlobalStrings
		else
			return tableData.ShowNetworkMessage()
		end
	end
	function tableData.ShowStatusButton1Text()
		return 12 + NumGlobalStrings
	end
	function tableData.ShowStatusButton1()
		RequestNetworkClose()
		PopPageStack()
	end
	function tableData.getErrorMessage()
		local code = GetNetworkErrorCode()
		local message = GetString(354 + NumGlobalStrings) .. " " .. code .. ". "
		if 20102 <= code and code <= 20109 or 20111 <= code and code <= 20999 then
			message = message .. GetString(344 + NumGlobalStrings)
		elseif code == 20101 or 23000 <= code and code <= 23999 then
			message = message .. GetString(346 + NumGlobalStrings)
		elseif code == 20110 then
			message = message .. GetString(348 + NumGlobalStrings)
		elseif code == 29000 then
			message = message .. GetString(349 + NumGlobalStrings)
		elseif code == 29001 then
			message = message .. GetString(350 + NumGlobalStrings)
		elseif code == 20100 or 50000 <= code and code <= 59999 then
			message = message .. GetString(351 + NumGlobalStrings)
		elseif code == 80430 then
			message = message .. GetString(478 + NumGlobalStrings)
		elseif wasConnected then
			message = message .. GetString(352 + NumGlobalStrings)
		else
			message = message .. GetString(353 + NumGlobalStrings)
		end
		return message
	end
	function tableData.ShowNetworkMessage()
		if status == NETWORK.OK then
			return 345 + NumGlobalStrings
		elseif status == NETWORK.Initialising then
			return 342 + NumGlobalStrings
		elseif status == NETWORK.GetServers then
			return StringID.GettingServers
		elseif status == NETWORK.InterfaceFailed then
			return tableData.getErrorMessage()
		elseif status == NETWORK.DHCPFailed then
			return tableData.getErrorMessage()
		elseif status == NETWORK.LoginFailed then
			return tableData.getErrorMessage()
		elseif status == NETWORK.LostConnection then
			return tableData.getErrorMessage()
		elseif status == NETWORK.Creating then
			return StringID.PlayCreating
		elseif status == NETWORK.CreateFailed then
			return StringID.CreateFailed
		elseif status == NETWORK.Joining then
			return StringID.Joining
		elseif status == NETWORK.JoinFailed then
			return StringID.JoinFailed
		else
			return 347 + NumGlobalStrings
		end
	end
	local function checkNetwork()
		badName = false
		if GetNetworkStatus() == NETWORK.OK then
		elseif GetNetworkStatus() == NETWORK.UNKNOWN then
			failed = false
			status = NETWORK.OK
			statusError = GetNetworkStatus()
			yesNoMode = 1
			StartWidget(tableData, GUI_Dialog_Box_2.YesNo, true)
		else
			failed = true
			status = NETWORK.OK
			statusError = GetNetworkStatus()
			yesNoMode = 1
			StartWidget(tableData, GUI_Dialog_Box_2.YesNo, true)
		end
	end
	function tableData.PopPageStack()
		yesNoMode = 2
		StartWidget(tableData, GUI_Dialog_Box_2.YesNo, true)
	end
	local function checkSaveFriendCode()
		if (code ~= GetFriendKey() or MultiPlayerNeedsSaving()) and GetGameSaveValid(MPSaveStatus) then
			code = GetFriendKey()
			nandDialog.Save(RequestSaveMultiPlayer, saveCallback)
			saving = true
		end
	end
	function tableData.Open()
		code = GetFriendKey()
		nandDialog = GetNANDDialog()
		nandDialog.Open()
		saving = false
		yesNoMode = 1
		if testing == false then
			checkNetwork()
		end
		MPLevel = 0
		MPWho = 0
		MPWhat = -1
		MPFriend = 0
		MPChallenging = false
		MPChallenged = false
	end
	function tableData.Update()
		PollMapMusicLoop()
		if trying then
			status = GetNetworkStatus()
			if status == NETWORK.InterfaceFailed or status == NETWORK.DHCPFailed or status == NETWORK.LoginFailed or status == NETWORK.LostConnection then
				statusError = status
				status = NETWORK.OK
				trying = false
				failed = true
				yesNoMode = 1
				RequestNetworkClose()
				StopWidget(GUI_Dialog_Box_0.ShowStatusAnimation)
				StartWidget(tableData, GUI_Dialog_Box_2.YesNo, true)
			elseif status == NETWORK.OK then
				StopWidget(GUI_Dialog_Box_0.ShowStatusAnimation)
				if GetProfileNameCheckResult() == eNameCheckResults.Allowed then
					trying = false
					SetOwnStatusStringTag("NAME", GetProfileName(GetCurrentMPProfile()))
					SetOwnStatusStringTag("RANK", GetOwnRank(GetCurrentMPProfile()))
				elseif badName == false then
					StartWidget(tableData, GUI_Dialog_Box_1.ShowStatus, true)
					badName = true
				end
			end
		else
			if saving == false then
				checkSaveFriendCode()
			end
			if saving == false then
				if GetNetworkStatus() == NETWORK.OK then
					wasConnected = true
					CheckChallenge(false)
				else
					trying = true
				end
			end
			nandDialog.Update()
		end
	end
	function tableData.Close()
		nandDialog.Close()
		SetIsClientOrServer(GAMESTATUS.NONE)
		if GetGameSaveValid(MPSaveStatus) == false then
			DontSaveMultiPlayer()
		end
	end
	function GetPlayPage()
		return tableData
	end
	DebugOut("Play ticked ***")
end
