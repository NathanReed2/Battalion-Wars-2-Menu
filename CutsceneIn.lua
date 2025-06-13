function CutsceneIn(owner)
	local tableData = {}
	local bExiting = false
	local totalFrames = 0
	local CutsceneFMVNames = {
		"0.1_Prologue_1",
		"1.1_Anglo_Attack",
		"",
		"",
		"",
		"",
		"2.1_Learning_From_History",
		"",
		"",
		"3.1_A_Dish_Served_Cold",
		"",
		"",
		"",
		"4.1_We_Know_Only_War",
		"",
		"",
		"5.1_Enemy_At_The_Gates",
		"",
		"",
		""
	}
	local loadingScreens = {
		"CampaignSLoading",
		"CampaignWFLoading",
		"CampaignAILoading",
		"CampaignILLoading",
		"CampaignTLoading"
	}
	local function selectMission()
		SetCurrentLevel(SelectedLevel)
		if TestLevelCycle and BuildType ~= Build.Final then
			PushPageStack("Game")
		elseif SelectedLevel == 1 then
			PushPageStack(loadingScreens[4])
		else
			PushPageStack(loadingScreens[SelectedCampaign])
		end
	end
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
			selectMission()
		end
	end
	function tableData.bPress()
		if not bExiting and SelectedLevel <= GetLevelsAttemptedOrDone() then
			bExiting = true
			initFadeOut()
		end
		if TestLevelCycle then
			bExiting = true
			initFadeOut()
		end
	end
	local function checkVideo()
		totalFrames = GetTotalFrames() - 15
		if totalFrames < 1 then
			return
		end
		if GetFrameNum() >= totalFrames and not bExiting then
			bExiting = true
			initFadeOut()
		end
	end
	function tableData.Open()
		StopFEMusic()
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
		RegisterMissionAttempt(SelectedLevel)
	end
	function GetCutsceneInPage()
		return tableData
	end
	DebugOut("CutsceneIn ticked ***")
end
