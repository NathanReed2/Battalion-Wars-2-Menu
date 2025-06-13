function Movies(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	local tabSelected = 1
	local levelsDone = 0
	local leftMovieButton = 0
	local rightMovieButton = 0
	local played = false
	local locked = {
		GUI_Sprite.Movie_Thumb_1_locked,
		GUI_Sprite.Movie_Thumb_2_locked
	}
	local unlocked = {
		{
			GUI_Sprite.Movies_Thumb_0_1,
			GUI_Sprite.Movies_Thumb_0_2
		},
		{
			GUI_Sprite.Movies_Thumb_1_1,
			GUI_Sprite.Movies_Thumb_1_2
		},
		{
			GUI_Sprite.Movies_Thumb_2_1,
			GUI_Sprite.Movies_Thumb_2_2
		},
		{
			GUI_Sprite.Movies_Thumb_3_1,
			GUI_Sprite.Movies_Thumb_3_2
		},
		{
			GUI_Sprite.Movies_Thumb_4_1,
			GUI_Sprite.Movies_Thumb_4_2
		},
		{
			GUI_Sprite.Movies_Thumb_5_1,
			GUI_Sprite.Movies_Thumb_5_2
		}
	}
	local FMVNames = {
		{
			"0.1_Prologue_1",
			"0.2_Prologue_2"
		},
		{
			"1.1_Anglo_Attack",
			"1.2_Tundra_Joins"
		},
		{
			"2.1_Learning_From_History",
			"2.2_A_Necessary_Peace"
		},
		{
			"3.1_A_Dish_Served_Cold",
			"3.2_The_Enemy_Revealed"
		},
		{
			"4.1_We_Know_Only_War",
			"4.2_The_Plot_Revealed"
		},
		{
			"5.1_Enemy_At_The_Gates",
			"5.2_The_Reckoning"
		}
	}
	local movieUnlockedMap = {
		{0, 1},
		{2, 5},
		{6, 8},
		{9, 13},
		{14, 15},
		{16, 19}
	}
	local function openLeftMovieButton()
		if movieUnlockedMap[tabSelected][1] > levelsDone then
			leftMovieButton = locked[1]
		else
			leftMovieButton = unlocked[tabSelected][1]
		end
		if 0 < leftMovieButton then
			StartWidget(tableData, leftMovieButton, false)
		end
	end
	local function closeLeftMovieButton()
		if 0 < leftMovieButton then
			StopWidget(leftMovieButton)
			leftMovieButton = 0
		end
	end
	local function openRightMovieButton()
		if movieUnlockedMap[tabSelected][2] > levelsDone then
			rightMovieButton = locked[2]
		else
			rightMovieButton = unlocked[tabSelected][2]
		end
		if 0 < rightMovieButton then
			StartWidget(tableData, rightMovieButton, false)
		end
	end
	local function closeRightMovieButton()
		if 0 < rightMovieButton then
			StopWidget(rightMovieButton)
			rightMovieButton = 0
		end
	end
	function tableData.tabActivated(id)
		if id ~= tabSelected then
			closeLeftMovieButton()
			closeRightMovieButton()
			tabSelected = id
			openLeftMovieButton()
			openRightMovieButton()
		end
	end
	local thumbSelected = 0
	function tableData.thumbSelected(id)
		thumbSelected = id
	end
	function tableData.thumbDeslected(id)
		thumbSelected = 0
	end
	function tableData.thumbActivated(id)
		FMVFileNameToPlay = FMVNames[tabSelected][id]
		played = true
		PushPageStack("FMV")
	end
	function tableData.thumbScale(id)
		if thumbSelected == id then
			return 1
		else
			return 0.75
		end
	end
	function tableData.Open()
		levelsDone = GetLevelsDone()
		if not played then
			tabSelected = 1
		end
		played = false
		thumbSelected = 0
		openLeftMovieButton()
		openRightMovieButton()
	end
	function tableData.Update()
		pollTitleLoop()
	end
	function tableData.Close()
		closeLeftMovieButton()
		closeRightMovieButton()
	end
	function GetMoviesPage()
		return tableData
	end
	DebugOut("Movie ticked ***")
end
