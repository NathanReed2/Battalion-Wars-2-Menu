function Search(owner)
	local tableData = {}
	local timeLimit = 20 * GetFramesPerSecond()
	local timeLeft = timeLimit
	local status = 0
	local previousStatus = 0
	local singleMaps = NumLevels
	local showConnectDialogMinFrames = 60
	local showConnectDialogFrame = 0
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	local function restartSearch()
		StopMatchMaking()
		StopWidget(GUI_Dialog_Box_0.ShowStatus)
		StopWidget(GUI_Dialog_Box_0.ShowStatusConnecting)
		StopWidget(GUI_Dialog_Box_1.ShowStatus_animation)
		tableData.Open()
	end
	function tableData.ShowStatusMessage()
		if status == eWiiMatchingStatus.ConnectionProblem or status == eWiiMatchingStatus.Connecting or 0 < showConnectDialogFrame and (status == eWiiMatchingStatus.Busy or status == eWiiMatchingStatus.BusyThread) then
			return GetString(StringID.SearchWaitingConnecting)
		end
		local Searching_for_any_game = GetString(StringID.SearchWaitingRandomGame)
		local message = Searching_for_any_game
		if MPLevel == 0 then
			if MPWhat == "0" then
				message = GetString(StringID.SearchWaitingSkirmishGame)
			elseif MPWhat == "1" then
				message = GetString(StringID.SearchWaitingAssaultGame)
			elseif MPWhat == "2" then
				message = GetString(StringID.SearchWaitingCoopGame)
			end
		else
			local levelname_id = GetMissionNameStart() + singleMaps + MPLevel - 1
			local levelname = GetString(levelname_id)
			message = FormatString(GetString(StringID.SearchWaitingLevel), levelname)
		end
		if MPFriend == 0 then
			return message .. GetString(StringID.SearchPlayAnybody)
		else
			local code = GetFriendStatusCode(MPFriend)
			return message .. FormatString(GetString(StringID.SearchPlayFriend), GetFriendName(MPFriend), GetFriendStatusStringFromCode(code))
		end
	end
	function tableData.ShowStatusTitle()
		if status == eWiiMatchingStatus.Success then
			if timeLeft == 0 then
				return StringID.SearchRestarting
			else
				return StringID.SearchTrying
			end
		elseif status == eWiiMatchingStatus.Failure then
			return StringID.SearchFailed
		elseif status == eWiiMatchingStatus.ConnectionProblem or status == eWiiMatchingStatus.Connecting or 0 < showConnectDialogFrame and (status == eWiiMatchingStatus.Busy or status == eWiiMatchingStatus.BusyThread) then
			return StringID.SearchWaitingConnectingTitle
		else
			return StringID.SearchWaiting
		end
	end
	function tableData.ShowStatusButton1()
		if status == eWiiMatchingStatus.Connecting or status == eWiiMatchingStatus.ConnectionProblem then
			return
		end
		if status ~= eWiiMatchingStatus.Success or timeLeft == 0 then
			StopMatchMaking()
			if MPFriend ~= 0 then
				if MPChallenged then
					setRefusedFlag(MPFriend, true)
					SetOwnStatusStringTag(GetFriendKey(MPFriend), "No!")
					MPWhat = MPOldWhat
					MPLevel = MPOldLevel
					MPWho = MPOldWho
					MPOldLevel = -1
					MPFriend = MPOldFriend
					MPChallenged = false
				else
					RemoveOwnStatusStringTag(GetFriendKey(MPFriend))
					MPChallenging = false
					MPFriend = 0
					MPWho = 0
				end
				PopPageStack()
			end
			PopPageStack()
		end
	end
	function tableData.ShowStatusButton1Text()
		if status == eWiiMatchingStatus.Failure or status == eWiiMatchingStatus.Success then
			return StringID.OK
		else
			return StringID.Cancel
		end
	end
	function tableData.Open()
		local locked = {
			MPIsUnlocked(1),
			MPIsUnlocked(2),
			MPIsUnlocked(3),
			MPIsUnlocked(4),
			MPIsUnlocked(5),
			MPIsUnlocked(6),
			MPIsUnlocked(7),
			MPIsUnlocked(8),
			MPIsUnlocked(9),
			MPIsUnlocked(10),
			MPIsUnlocked(11),
			MPIsUnlocked(12),
			MPIsUnlocked(13),
			MPIsUnlocked(14),
			MPIsUnlocked(15),
			MPIsUnlocked(16),
			MPIsUnlocked(17),
			MPIsUnlocked(18),
			MPIsUnlocked(19),
			MPIsUnlocked(20),
			MPIsUnlocked(21),
			MPIsUnlocked(22),
			MPIsUnlocked(23),
			MPIsUnlocked(24),
			MPIsUnlocked(25),
			MPIsUnlocked(26),
			MPIsUnlocked(27),
			MPIsUnlocked(28),
			MPIsUnlocked(29),
			MPIsUnlocked(30)
		}
		status = 0
		previousStatus = 0
		local success = StartMatchMaking(MPWho, MPFriend, MPWhat, MPLevel, locked, MPPreferredPlayer)
		if success == false then
			status = eWiiMatchingStatus.Failure
		end
		StopWidget(GUI_Dialog_Box_0.ShowStatus)
		StopWidget(GUI_Dialog_Box_0.ShowStatusConnecting)
		StartWidget(tableData, GUI_Dialog_Box_1.ShowStatus_animation, true)
		timeLeft = timeLimit
		showConnectDialogFrame = 0
	end
	function tableData.Update()
		PollMapMusicLoop()
		status = CheckMatchMaking()
		local state = GetMissionStatus()
		if state == GAMESTATUS.MPPLAY and GetPlayerInformationReady(2) then
			PushPageStack("MPLoading")
			PushPageStack("SavingPostSearch")
		end
		if status == eWiiMatchingStatus.Success then
			if 0 < timeLeft then
				timeLeft = timeLeft - 1
			elseif timeLeft == 0 then
				timeLeft = -1
				restartSearch()
			end
		end
		if 0 < showConnectDialogFrame then
			showConnectDialogFrame = showConnectDialogFrame - 1
		end
		if status ~= previousStatus and (showConnectDialogFrame <= 0 or status ~= eWiiMatchingStatus.Busy and status ~= eWiiMatchingStatus.BusyThread) then
			previousStatus = status
			if status == eWiiMatchingStatus.Connecting or status == eWiiMatchingStatus.ConnectionProblem then
				showConnectDialogFrame = showConnectDialogMinFrames
				StopWidget(GUI_Dialog_Box_1.ShowStatus_animation)
				StopWidget(GUI_Dialog_Box_0.ShowStatus)
				StartWidget(tableData, GUI_Dialog_Box_0.ShowStatusConnecting, true)
			elseif status == eWiiMatchingStatus.Success then
				StopWidget(GUI_Dialog_Box_0.ShowStatusConnecting)
				StopWidget(GUI_Dialog_Box_1.ShowStatus_animation)
				StartWidget(tableData, GUI_Dialog_Box_0.ShowStatus, true)
			else
				StopWidget(GUI_Dialog_Box_0.ShowStatus)
				StopWidget(GUI_Dialog_Box_0.ShowStatusConnecting)
				StartWidget(tableData, GUI_Dialog_Box_1.ShowStatus_animation, true)
			end
		end
		if MPFriend == 0 then
			CheckChallenge(true)
		else
			local friendStatus = GetFriendStatusStringTag(MPFriend, GetFriendKey())
			if friendStatus == nil or friendStatus == "No!" then
				StopMatchMaking()
				PopPageStack()
			end
		end
		PopPageStackIfNetworkError()
	end
	function tableData.Close()
		StopWidget(GUI_Dialog_Box_0.ShowStatus)
		StopWidget(GUI_Dialog_Box_0.ShowStatusConnecting)
		StopWidget(GUI_Dialog_Box_1.ShowStatus_animation)
		if MPFriend ~= 0 then
			RemoveOwnStatusStringTag(GetFriendKey(MPFriend))
		end
	end
	function GetSearchPage()
		return tableData
	end
	DebugOut("Search ticked ***")
end
