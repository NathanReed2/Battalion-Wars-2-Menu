function Rematch(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	function tableData.PopPageStack()
		tableData.YesNoOnNo()
	end
	local rematch = {
		eRematchStatus.Pending,
		eRematchStatus.Pending
	}
	local declined = false
	local testing = false
	function tableData.getPlayerName(remotePlayer)
		local name = GetPlayerInformation(2)
		if testing then
			name = "remote player"
		end
		if rematch[remotePlayer] == eRematchStatus.Pending then
			return FormatString(GetString(StringID.RematchPlayerIsThinking), name) .. GetString(StringID.RematchYouWillSwapSides)
		else
			return FormatString(GetString(StringID.RematchPlayerApproves), name) .. GetString(StringID.RematchYouWillSwapSides)
		end
	end
	function tableData.getQuestion()
		local level = GetCurrentLevel()
		local gameType = GetLevelGameType(level)
		if testing then
			gameType = GAMETYPE.Coop
		end
		if gameType == GAMETYPE.Coop then
			return StringID.RematchDoYouWantToReplay
		else
			return StringID.RematchDoYouWantToRematch
		end
	end
	function tableData.playerYes(playerIndex)
		return rematch[playerIndex] == eRematchStatus.Yes
	end
	function tableData.playerNo(playerIndex)
		return rematch[playerIndex] == eRematchStatus.No
	end
	function tableData.ShowStatusTitle()
		if rematch[1] == eRematchStatus.No or rematch[2] == eRematchStatus.No then
			return StringID.RematchNoRematch
		else
			return StringID.RematchWaiting
		end
	end
	function tableData.ShowStatusMessage()
		local name = GetPlayerInformation(2)
		if testing then
			name = "remote player"
		end
		if rematch[1] == eRematchStatus.No or rematch[2] == eRematchStatus.No then
			return FormatString(GetString(StringID.RematchPlayerDeclines), name)
		else
			return FormatString(GetString(StringID.RematchPlayerIsThinking), name)
		end
	end
	function tableData.ShowStatusButton1Text()
		if rematch[1] == eRematchStatus.No or rematch[2] == eRematchStatus.No then
			return StringID.OK
		else
			return StringID.Cancel
		end
	end
	function tableData.ShowStatusButton1()
		StopWidget(GUI_Dialog_Box_1.ShowStatus)
		tableData.YesNoOnNo()
	end
	function tableData.YesNoOnYes()
		if IsNetworkPlayer(constant.PLAYER_ONE) then
			rematch[1] = eRematchStatus.Yes
		else
			rematch[2] = eRematchStatus.Yes
		end
		StartWidget(tableData, GUI_Dialog_Box_1.ShowStatus, true)
	end
	function tableData.YesNoOnNo()
		LeaveMPGame()
		PopPageStack()
	end
	function tableData.Open()
		MPPreferredPlayer = -1
		declined = false
	end
	function tableData.Update()
		PollMapMusicLoop()
		local state = GetMissionStatus()
		if state == GAMESTATUS.MPPLAY then
			PushPageStack("MPLoading")
			PushPageStack("Saving")
		end
		if IsNetworkPlayer(constant.PLAYER_ONE) and testing == false then
			rematch[2] = UpdateRematch(rematch[1])
		else
			rematch[1] = UpdateRematch(rematch[2])
		end
		if declined == false and testing == false and (rematch[1] == eRematchStatus.No or rematch[2] == eRematchStatus.No) then
			declined = true
			StartWidget(tableData, GUI_Dialog_Box_1.ShowStatus, true)
		end
		PopPageStackIfNetworkError()
	end
	function tableData.Close()
	end
	function GetRematchPage()
		return tableData
	end
	DebugOut("Rematch ticked ***")
end
