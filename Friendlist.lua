function Friendlist(owner)
	local tableData = {}
	local friendList = {}
	local friendCount = 0
	local friendIndex = -1
	local renameFriend = false
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	function tableData.gotoFriend()
		PushPageStack("Friend")
	end
	local function indexOfSelectedFriend()
		local item = 1 + GetWidgetValue(GUI_List_Box_Widget.Friendlist_list, "mActivatedItem")
		return friendList[item][1]
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
			stars = "*****"
		end
		local won, lost
		won, lost = getWinsAndLosses(friend)
		local statistics = "" .. won .. "/" .. lost
		local code = GetFriendKey(friend)
		friendList[friendCount] = {
			friend,
			name,
			stars,
			statistics,
			code,
			65 - friend
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
		SetWidgetValue(GUI_List_Box_Widget.Friendlist_list, "mActivatedItem", "-1")
		friendList = {}
		friendCount = 0
		local firstOnline = addFriendsToList(1)
		addFriendsToList(2)
		addFriendsToList(3)
		addFriendsToList(4)
		addFriendsToList(0)
		SetWidgetValue(GUI_List_Box_Widget.Friendlist_list, "mItemCount", "" .. friendCount)
		return firstOnline
	end
	function tableData.askDeleteFriend()
		StartWidget(tableData, GUI_Dialog_Box_2.YesNo, true)
	end
	local function deleteFriend()
		local index = indexOfSelectedFriend()
		DeleteFriend(index)
		updateFriendList()
	end
	function tableData.listBoxData(id, item)
		if item < friendCount then
			SetListBoxData(id, item, 0, friendList[item + 1][2])
			SetListBoxData(id, item, 1, friendList[item + 1][3])
			SetListBoxData(id, item, 2, friendList[item + 1][4])
			SetListBoxData(id, item, 3, friendList[item + 1][5])
			SetListBoxData(id, item, 4, friendList[item + 1][6])
		else
			local empty = GetString(483 + NumGlobalStrings)
			SetListBoxData(id, item, 0, empty)
			SetListBoxData(id, item, 1, " ")
			SetListBoxData(id, item, 2, " ")
			SetListBoxData(id, item, 3, " ")
			SetListBoxData(id, item, 4, " ")
		end
	end
	function tableData.isFriendSelected()
		return 0 + GetWidgetValue(GUI_List_Box_Widget.Friendlist_list, "mActivatedItem") > -1
	end
	function tableData.optionChanged()
	end
	function tableData.YesNoTitle()
		local index = indexOfSelectedFriend()
		return GetString(StringID.DeleteFriend) .. GetFriendName(index) .. "."
	end
	function tableData.YesNoMessage()
		return StringID.AreYouSure
	end
	function tableData.YesNoOnYes()
		StopWidget(GUI_Dialog_Box_2.YesNo)
		deleteFriend()
		GOChangedMP = GetGameSaveValid(MPSaveStatus)
	end
	function tableData.YesNoOnNo()
		StopWidget(GUI_Dialog_Box_2.YesNo)
	end
	function tableData.Open()
		friendList = {}
		friendCount = 0
		friendIndex = -1
		renameFriend = false
		if -1 < friendIndex and MPText ~= "" and renameFriend then
			renameFriend = false
			SetFriendName(friendIndex, MPText)
		end
		updateFriendList()
	end
	function tableData.Update()
	end
	function tableData.Close()
	end
	function GetFriendlistPage()
		return tableData
	end
	DebugOut("Friendlist ticked ***")
end
