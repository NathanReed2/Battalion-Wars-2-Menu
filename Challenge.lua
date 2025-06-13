function Challenge(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	local accepted = false
	local waiting = false
	local withdrawn = false
	local refused = false
	local singleMaps = NumLevels
	local timeOutCount = GetFramesPerSecond() * 60
	local timeout = timeOutCount
	local waitForLastRequestToClear = false
	function tableData.getText()
		local code = GetFriendStatusCode(MPFriend)
		local status = GetFriendStatusStringFromCode(code)
		local name = GetFriendName(MPFriend)
		if MPChallenged then
			if withdrawn then
				return FormatString(GetString(StringID.ChallengeWithdrewChallenge), name, status)
			end
			if waiting then
				return FormatString(GetString(StringID.ChallengeWaitingAcknowledge), name, status)
			end
			local challenge = ""
			if MPLevel == 0 then
				if MPWhat == "0" then
					return FormatString(GetString(StringID.ChallengeSkirmishGame), name, status) .. GetString(StringID.ChallengeDoYouAccept)
				elseif MPWhat == "1" then
					return FormatString(GetString(StringID.ChallengeAssaultGame), name, status) .. GetString(StringID.ChallengeDoYouAccept)
				elseif MPWhat == "2" then
					return FormatString(GetString(StringID.ChallengeCoopGame), name, status) .. GetString(StringID.ChallengeDoYouAccept)
				else
					return FormatString(GetString(StringID.ChallengeRandomGame), name, status) .. GetString(StringID.ChallengeDoYouAccept)
				end
			else
				MPText = GetMissionNameStart() + singleMaps + MPLevel - 1
				local level_name = GetString(MPText)
				return FormatString(GetString(StringID.ChallengeHasChallengedSpecificLevel), name, status, level_name) .. GetString(StringID.ChallengeDoYouAccept)
			end
		else
			if waiting then
				return FormatString(GetString(StringID.ChallengeFriendIsWaiting), name, status)
			end
			if refused then
				return FormatString(GetString(StringID.ChallengeDeclinedYourChallenge), name, status)
			end
			if timeout == 0 then
				return GetString(StringID.ChallengeErrorCode) .. " 80430. " .. GetString(StringID.ChallengeThereIsNoResponse)
			end
			return FormatString(GetString(StringID.ChallengeYouAreWaiting), name, status)
		end
	end
	function tableData.showYesNo()
		return MPChallenged and waiting == false and withdrawn == false or MPChallenging and waiting
	end
	function tableData.onYes()
		if MPChallenged then
			waiting = true
			SetOwnStatusStringTag(GetFriendKey(MPFriend), "Yes!")
		else
			startSearching()
		end
	end
	function tableData.onNo()
		PopPageStack()
	end
	function tableData.showOKCancel()
		return tableData.showYesNo() == false
	end
	function tableData.getOKCancelText()
		if withdrawn or refused or MPChallenging and timeout == 0 then
			return 12 + NumGlobalStrings
		else
			return 7 + NumGlobalStrings
		end
	end
	function tableData.onOKCancel()
		if MPChallenging and waiting then
			startSearching()
		else
			PopPageStack()
		end
	end
	local function startSearching()
		accepted = true
		SetOwnStatusStringTag(GetFriendKey(MPFriend), "Go!")
		MPWho = 1
		if MPChallenged and MPLevel > 0 then
			PushPageStack("ChooseArmy")
		else
			PushPageStack("Search")
		end
	end
	function tableData.Open()
		setRefusedFlag(MPFriend, false)
		accepted = false
		waiting = false
		withdrawn = false
		refused = false
		waitForLastRequestToClear = false
		if MPChallenging then
			local status = GetFriendStatusStringTag(MPFriend, GetFriendKey())
			if status == "Go!" or status == "Yes!" or status == "Thinking." then
				waitForLastRequestToClear = true
			else
				SetOwnStatusStringTag(GetFriendKey(MPFriend), "Play?")
				SetOwnStatusStringTag("MPWhat", MPWhat)
				SetOwnStatusStringTag("MPLevel", MPLevel)
			end
			MPOldFriend = MPFriend
			timeout = timeOutCount
		end
		if MPChallenged then
			SetOwnStatusStringTag(GetFriendKey(MPFriend), "Thinking.")
			if MPOldLevel < 0 then
				MPOldWhat = MPWhat
				MPOldWho = MPWho
				MPOldLevel = MPLevel
			end
			local what = GetFriendStatusStringTag(MPFriend, "MPWhat")
			local level = GetFriendStatusStringTag(MPFriend, "MPLevel")
			if what ~= nil and level ~= nil then
				MPWhat = what
				MPLevel = 0 + level
			end
		end
	end
	function tableData.Update()
		PollMapMusicLoop()
		local status = GetFriendStatusStringTag(MPFriend, GetFriendKey())
		if MPChallenging then
			if waitForLastRequestToClear then
				if status ~= "Go!" and status ~= "Yes!" and status ~= "Thinking." then
					SetOwnStatusStringTag(GetFriendKey(MPFriend), "Play?")
					SetOwnStatusStringTag("MPWhat", MPWhat)
					SetOwnStatusStringTag("MPLevel", MPLevel)
					waitForLastRequestToClear = false
				end
			elseif status == "Yes!" then
				startSearching()
			elseif status == "No!" then
				waiting = false
				refused = true
				RemoveOwnStatusStringTag(GetFriendKey(MPFriend))
			elseif status == "Play?" then
				if GetFriendKey() < GetFriendKey(MPFriend) or refused or timeout == 0 then
					MPChallenging = false
					MPChallenged = true
					MPFriendAnyLevel = true
					timeout = 1
					tableData.Open()
				end
			elseif status == "Go!" then
				waiting = true
			elseif status == nil then
				if 0 < timeout then
					timeout = timeout - 1
				else
					RemoveOwnStatusStringTag(GetFriendKey(MPFriend))
				end
			end
		end
		if MPChallenged then
			if status == "Go!" then
				if waiting then
					startSearching()
				else
				end
			elseif status == "Play?" then
				local what = GetFriendStatusStringTag(MPFriend, "MPWhat")
				local level = GetFriendStatusStringTag(MPFriend, "MPLevel")
				if what ~= nil and level ~= nil then
					MPWhat = what
					MPLevel = 0 + level
				end
			end
			withdrawn = status == nil
		end
		PopPageStackIfNetworkError()
	end
	function tableData.Close()
		if accepted == false then
			if MPChallenging then
				MPChallenging = false
				RemoveOwnStatusStringTag(GetFriendKey(MPFriend))
			end
			if MPChallenged then
				if withdrawn then
					RemoveOwnStatusStringTag(GetFriendKey(MPFriend))
				else
					setRefusedFlag(MPFriend, true)
					SetOwnStatusStringTag(GetFriendKey(MPFriend), "No!")
				end
				MPWhat = MPOldWhat
				MPLevel = MPOldLevel
				MPWho = MPOldWho
				MPOldLevel = -1
				MPFriend = MPOldFriend
				MPChallenged = false
			end
		end
	end
	function GetChallengePage()
		return tableData
	end
	DebugOut("Challenge ticked ***")
end
