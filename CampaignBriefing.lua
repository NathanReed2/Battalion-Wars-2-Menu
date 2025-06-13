function CampaignBriefing(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	local wholeString = ""
	local levelsDone = 0
	local briefingName = ""
	local campaignTitleTable = {
		750,
		755,
		760,
		765,
		770
	}
	local campaignDescTable = {
		751,
		756,
		761,
		766,
		771
	}
	function tableData.getTitle()
		return campaignTitleTable[SelectedCampaign]
	end
	local function getDesc()
		return campaignDescTable[SelectedCampaign]
	end
	function tableData.getDesc1()
		return wholeString
	end
	local FMVNames = {
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
		{2, 5},
		{7, 8},
		{10, 12},
		{14, 15},
		{17, 19}
	}
	function tableData.panelFade()
		if movieUnlockedMap[SelectedCampaign][2] < levelsDone then
			return 255
		else
			return 128
		end
	end
	function tableData.getIntroFade()
		if movieUnlockedMap[SelectedCampaign][1] <= levelsDone then
			return 255
		else
			return 128
		end
	end
	function tableData.isOutroButtonActive()
		if movieUnlockedMap[SelectedCampaign][2] < levelsDone then
			return true
		else
			return false
		end
	end
	function tableData.isIntroButtonActive()
		if movieUnlockedMap[SelectedCampaign][1] <= levelsDone then
			return true
		else
			return false
		end
	end
	local doFMVid = 0
	local bExiting = false
	function tableData.gotoIntro()
		if not bExiting then
			doFMVid = 1
			bExiting = true
			initFadeOut()
			SetMusicVolume(0, MusicFadeOutSecs)
		end
	end
	function tableData.gotoOutro()
		if movieUnlockedMap[SelectedCampaign][2] < levelsDone and not bExiting then
			doFMVid = 2
			bExiting = true
			initFadeOut()
			SetMusicVolume(0, MusicFadeOutSecs)
		end
	end
	local function doFMV()
		if doFMVid == 1 then
			FMVFileNameToPlay = FMVNames[SelectedCampaign][1]
		elseif doFMVid == 2 then
			FMVFileNameToPlay = FMVNames[SelectedCampaign][2]
		end
		PushPageStack("FMV")
	end
	function tableData.getGlobeZoom()
		return 63
	end
	function tableData.getAtmosZoom()
		return 53
	end
	local campaignStartLevels = {
		0,
		5,
		8,
		12,
		15
	}
	local bCheckCompleted = false
	local function checkCompleted()
		if not bCheckCompleted then
			bCheckCompleted = true
			local tmpLevel = GetCurrentLevel()
			SetCurrentLevel(campaignStartLevels[SelectedCampaign])
			local bCompleted = GetCurrentMissionCompleted()
			SetCurrentLevel(tmpLevel)
			if bCompleted then
			end
		end
	end
	function tableData.Open()
		if bExiting then
			initFadeIn()
			bExiting = false
		else
			initFadeFullOn()
		end
		bCheckCompleted = false
		levelsDone = GetLevelsDone()
		GlobeSelectTarget(SelectedCampaign)
		wholeString = GetString(getDesc()) .. "\\n\\n" .. GetString(getDesc() + 1) .. "\\n\\n" .. GetString(getDesc() + 2) .. "\\n\\n" .. GetString(getDesc() + 3)
		briefingName = CampaignBriefingFileName(SelectedCampaign)
		StartVO(constant.FILENAME, BriefingDirectory, briefingName, 0, constant.ONCE)
	end
	function tableData.Update()
		checkCompleted()
		PollMapMusicLoop()
		GlobeSelectTargetUpdate()
		updateFadeColour(tableData)
		if bExiting and bFadeOutDone() then
			doFMV()
		end
	end
	function tableData.Close()
		StopVO()
	end
	function GetCampaignBriefingPage()
		return tableData
	end
	DebugOut("Campaign Briefing ticked ***")
end
