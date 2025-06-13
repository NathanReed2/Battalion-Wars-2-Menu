function ChooseArmy(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	function tableData.stringIDTitle()
		return StringID.PreferredArmy
	end
	function tableData.stringIDWhichever()
		return StringID.Whichever
	end
	function tableData.getButtonTitle()
		if MPWho == 1 then
			return StringID.CAChallenge
		else
			return StringID.Search
		end
	end
	function tableData.stringIDDisclaimer()
		return StringID.PrefMayBeRefused
	end
	local playerIndexTable = {
		StringID.Attacker,
		StringID.Defender
	}
	function tableData.getPlayerSide(buttonIndex)
		local playerIndex
		if MPLevel <= 10 then
			local attacker = attackingPlayer[MPLevel]
			if buttonIndex == 1 then
				playerIndex = attacker
			else
				playerIndex = 1 - attacker
			end
			return GetString(getPlayerSide(MPLevel, playerIndex + 1)) .. "  " .. GetString(playerIndexTable[buttonIndex])
		else
			playerIndex = buttonIndex - 1
			return GetString(getPlayerSide(MPLevel, playerIndex + 1))
		end
	end
	function tableData.isFaction(faction, buttonIndex)
		local playerIndex
		if MPLevel <= 10 then
			local attacker = attackingPlayer[MPLevel]
			if buttonIndex == 1 then
				playerIndex = attacker
			else
				playerIndex = 1 - attacker
			end
			return isFaction(MPLevel, faction, playerIndex + 1)
		else
			playerIndex = buttonIndex - 1
			return isFaction(MPLevel, faction, playerIndex + 1)
		end
	end
	local gotoSearchOrChallenge = function()
		if MPWho == 1 then
			if MPChallenged then
				PopPageStack()
				PushPageStack("Search")
			else
				MPChallenging = true
				MPChallenged = false
				PopPageStack()
				PopPageStack()
				PopPageStack()
				PopPageStack()
				bLevelsPreFadeIn = true
				PushPageStack("Challenge")
			end
		else
			PushPageStack("Search")
		end
	end
	function tableData.onButtonWhichever()
		MPPreferredPlayer = -1
		gotoSearchOrChallenge()
	end
	function tableData.onButtonOne()
		if MPLevel <= 10 then
			MPPreferredPlayer = attackingPlayer[MPLevel]
		else
			MPPreferredPlayer = PLAYER_INDEX.One
		end
		gotoSearchOrChallenge()
	end
	function tableData.onButtonTwo()
		if MPLevel <= 10 then
			MPPreferredPlayer = 1 - attackingPlayer[MPLevel]
		else
			MPPreferredPlayer = PLAYER_INDEX.Two
		end
		gotoSearchOrChallenge()
	end
	function tableData.Open()
	end
	function tableData.Update()
		PollMapMusicLoop()
		PopPageStackIfNetworkError()
		if MPChallenged == false and MPChallenging == false then
			CheckChallenge(false)
		end
		if MPChallenged then
			local status = GetFriendStatusStringTag(MPFriend, GetFriendKey())
			if status == nil then
				PopPageStack()
			end
		end
	end
	function tableData.Close()
	end
	function GetChooseArmyPage()
		return tableData
	end
	DebugOut("ChooseArmy ticked ***")
end
