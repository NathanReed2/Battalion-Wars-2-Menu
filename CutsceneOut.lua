function CutsceneOut(owner)
	local tableData = {}
	local bExiting = false
	local totalFrames = 0
	local CutsceneFMVNames = {
		"0.2_Prologue_2",
		"",
		"",
		"",
		"",
		"1.2_Tundra_Joins",
		"",
		"",
		"2.2_A_Necessary_Peace",
		"",
		"",
		"",
		"3.2_The_Enemy_Revealed",
		"",
		"",
		"4.2_The_Plot_Revealed",
		"",
		"",
		"",
		"5.2_The_Reckoning"
	}
	local function startVideo()
		if CutsceneFMVNames[SelectedLevel] ~= "" then
			PlayVideo(VIDEO.ONCE, CutsceneFMVNames[SelectedLevel], 0)
		else
			bExiting = true
		end
	end
	local function stopVideo()
		if CutsceneFMVNames[SelectedLevel] ~= "" then
			SetMusicVolume(0)
			PlayVideo(VIDEO.OFF, CutsceneFMVNames[SelectedLevel], 0)
		end
	end
	local function exitUpdate()
		if bExiting and bFadeOutDone() then
			stopVideo()
			SetCurrentFMVOutSeen()
			PopPageStack()
		end
	end
	local function checkVideo()
		totalFrames = GetTotalFrames() - 15
		if totalFrames < 1 then
			return
		end
		if GetFrameNum() >= totalFrames and bExiting == false then
			bExiting = true
			initFadeOut()
		end
	end
	function tableData.bPress()
		if bExiting == false and SelectedLevel <= LevelsDone then
			bExiting = true
			initFadeOut()
		end
		if TestLevelCycle then
			bExiting = true
			initFadeOut()
		end
	end
	function tableData.Open()
		bExiting = false
		initFadeIn()
		startVideo()
	end
	function tableData.Update()
		exitUpdate()
		checkVideo()
		updateFadeColour(tableData)
	end
	function tableData.Close()
	end
	function GetCutsceneOutPage()
		return tableData
	end
	DebugOut("CutsceneOut ticked ***")
end
