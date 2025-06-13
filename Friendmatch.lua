function Friendmatch(owner)
	local tableData = {}
	tableData.StringFriendMatch = 379 + NumGlobalStrings
	tableData.StringSelectMission = 380 + NumGlobalStrings
	tableData.StringPlayRandom = 381 + NumGlobalStrings
	local friendList = {}
	local friendCount = 0
	local neverSelected = true
	local mLineCount = 0
	local mItemCount = 0
	local mTopItem = 0
	local mActivatedItem = 0
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	local function indexOfSelectedFriend()
		local item = 1 + mActivatedItem
		return friendList[item][1]
	end
	function tableData.isFriendSelected()
		return -1 < mActivatedItem
	end
	function tableData.isConnected()
		return GetNetworkStatus() ~= NETWORK.UNKNOWN
	end
	function tableData.isDisconnected()
		return GetNetworkStatus() == NETWORK.UNKNOWN
	end
	function tableData.isOkToAddFriends()
		return IsOkToChangeFriends()
	end
	function tableData.isOkToDeleteFriends()
		return IsOkToChangeFriends() and tableData.isFriendSelected()
	end
	function tableData.isOkToPlayFriend()
		if tableData.isFriendSelected() then
			local code = GetFriendStatusCode(indexOfSelectedFriend())
			return code == 1
		else
			return false
		end
	end
	function tableData.canScrollUp()
		return 0 < mTopItem
	end
	function tableData.canScrollDown()
		return mTopItem + mLineCount < mItemCount
	end
	local getWinsAndLosses = function(friend)
		local won = 0
		local lost = 0
		for map = 1, 20 do
			for result = MATCHRESULT.C, MATCHRESULT.S do
				won = won + GetMPStatistics(friend, map, result)
			end
			for result = MATCHRESULT.Started, MATCHRESULT.Started do
				lost = lost + GetMPStatistics(friend, map, result)
			end
		end
		lost = lost - won
		if lost < 0 then
			lost = 0
		end
		return won, lost
	end
	local function addFriendToList(friend, name)
		friendCount = friendCount + 1
		local rank = GetFriendRank(friend)
		local stars = ""
		if 0 < rank then
			for tl = 1, rank do
				stars = "*" .. stars
			end
		else
			stars = " "
		end
		local won, lost
		won, lost = getWinsAndLosses(friend)
		local statistics = "" .. won .. "/" .. lost
		local friendCode = GetFriendKey(friend)
		local code = GetFriendStatusCode(friend)
		local status = "" .. GetFriendStatusStringFromCode(code)
		friendList[friendCount] = {
			friend,
			name,
			friendCode,
			stars,
			status,
			65 - friend,
			code == 0
		}
	end
	local function addFriendsToList(code)
		local first = 0
		local friend = 64
		while 0 < friend do
			local name = GetFriendName(friend)
			if name ~= "" and GetFriendStatusCode(friend) == code then
				addFriendToList(friend, name)
				if first == 0 then
					first = friendCount
				end
			end
			friend = friend - 1
		end
		return first
	end
	local function updateFriendList()
		SetWidgetValue(GUI_List_Box_Widget.Friendmatch_list, "mActivatedItem", "-1")
		friendList = {}
		friendCount = 0
		local firstOnline = addFriendsToList(1)
		addFriendsToList(2)
		addFriendsToList(3)
		addFriendsToList(4)
		addFriendsToList(0)
		SetWidgetValue(GUI_List_Box_Widget.Friendmatch_list, "mItemCount", "" .. friendCount)
		mItemCount = 0 + GetWidgetValue(GUI_List_Box_Widget.Friendmatch_list, "mItemCount")
		mActivatedItem = 0 + GetWidgetValue(GUI_List_Box_Widget.Friendmatch_list, "mActivatedItem")
		return firstOnline
	end
	function tableData.listBoxData(id, item)
		if item < friendCount then
			SetListBoxData(id, item, 0, friendList[item + 1][2])
			SetListBoxData(id, item, 1, friendList[item + 1][3])
			SetListBoxData(id, item, 2, friendList[item + 1][4])
			SetListBoxData(id, item, 3, friendList[item + 1][5])
			SetListBoxData(id, item, friendList[item + 1][7])
		else
			local empty = GetString(483 + NumGlobalStrings)
			SetListBoxData(id, item, 0, empty)
			SetListBoxData(id, item, 1, " ")
			SetListBoxData(id, item, 2, " ")
			SetListBoxData(id, item, 3, " ")
			SetListBoxData(id, item, true)
		end
	end
	function tableData.optionChanged()
	end
	function tableData.askDeleteFriend()
		StartWidget(tableData, GUI_Dialog_Box_2.YesNo, true)
	end
	local function deleteFriend()
		local index = indexOfSelectedFriend()
		DeleteFriend(index)
		updateFriendList()
	end
	function tableData.YesNoTitle()
		local index = indexOfSelectedFriend()
		return GetString(StringID.FMDeleteFriend) .. GetFriendName(index) .. "."
	end
	function tableData.YesNoMessage()
		return StringID.FMAreYouSure
	end
	function tableData.YesNoOnYes()
		StopWidget(GUI_Dialog_Box_2.YesNo)
		deleteFriend()
		GOChangedMP = GetGameSaveValid(MPSaveStatus)
	end
	function tableData.YesNoOnNo()
		StopWidget(GUI_Dialog_Box_2.YesNo)
	end
	function tableData.gotoFriend()
		PushPageStack("Friend")
	end
	function tableData.gotoChallengeGametype()
		MPFriendAnyLevel = false
		MPFriend = indexOfSelectedFriend()
		MPWho = 1
		PushPageStack("Gametype")
	end
	function tableData.gotoChallengeRandom()
		MPFriendAnyLevel = true
		MPChallenging = true
		MPChallenged = false
		MPFriend = indexOfSelectedFriend()
		MPWhat = -1
		MPWho = 1
		PushPageStack("Challenge")
	end
	function tableData.Open()
		neverSelected = true
		updateFriendList()
	end
	local wait = 0
	function tableData.Update()
		CheckChallenge(false)
		mLineCount = 0 + GetWidgetValue(GUI_List_Box_Widget.Friendmatch_list, "mLineCount")
		mItemCount = 0 + GetWidgetValue(GUI_List_Box_Widget.Friendmatch_list, "mItemCount")
		mTopItem = 0 + GetWidgetValue(GUI_List_Box_Widget.Friendmatch_list, "mTopItem")
		mActivatedItem = 0 + GetWidgetValue(GUI_List_Box_Widget.Friendmatch_list, "mActivatedItem")
		wait = wait + 1
		if wait == 60 then
			local selection = 1 + mActivatedItem
			local previousStatus = "~"
			local previousIndex = 0
			if 0 < selection then
				neverSelected = false
				local friendData1 = friendList[selection]
				previousIndex = friendData1[1]
				previousStatus = friendData1[5]
			end
			local firstOnline = updateFriendList()
			if selection == 0 then
				if neverSelected then
					neverSelected = false
					selection = firstOnline
				end
			else
				local friend = 1
				local found = 0
				while found == 0 and friend <= friendCount do
					local friendData2 = friendList[friend]
					if previousIndex == friendData2[1] then
						found = friend
					end
					friend = friend + 1
				end
				if friendList[found][5] == GetFriendStatusStringFromCode(1) or friendList[found][5] == previousStatus then
					selection = found
				else
					selection = 0
				end
			end
			SetWidgetValue(GUI_List_Box_Widget.Friendmatch_list, "mActivatedItem", selection - 1)
			mActivatedItem = 0 + GetWidgetValue(GUI_List_Box_Widget.Friendmatch_list, "mActivatedItem")
			wait = 0
		end
		PopPageStackIfNetworkError()
	end
	function tableData.Close()
	end
	function GetFriendmatchPage()
		return tableData
	end
	DebugOut("Friendmatch ticked ***")
end
