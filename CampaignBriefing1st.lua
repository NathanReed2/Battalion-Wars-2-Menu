function CampaignBriefing1st(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	local wholeString = ""
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
	local campaignNameTable = {
		"CampaignS",
		"CampaignWF",
		"CampaignAI",
		"CampaignIL",
		"CampaignT"
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
	local aButtonReady = false
	local waitCount = 0
	local function updateTimer()
		if waitCount < 300 then
			waitCount = waitCount + 1
			if 299 < waitCount then
				aButtonReady = true
			end
		end
	end
	function tableData.quitBriefing()
		if aButtonReady then
			PopPageStack()
		end
		SetBriefingSeen(SelectedSlot, SelectedCampaign)
	end
	function tableData.getAButtonReady()
		return aButtonReady
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
			if bCompleted and aButtonReady then
				PopPageStack()
			end
		end
	end
	function tableData.Open()
		bCheckCompleted = false
		wholeString = {
			getDesc(),
			"\\n\\n",
			getDesc() + 1,
			"\\n\\n",
			getDesc() + 2,
			"\\n\\n",
			getDesc() + 3
		}
		briefingName = CampaignBriefingFileName(SelectedCampaign)
		StartVO(constant.FILENAME, BriefingDirectory, briefingName, 0, constant.ONCE)
	end
	function tableData.Update()
		checkCompleted()
		PollMapMusicLoop()
		GlobeSelectTargetUpdate()
		updateTimer()
	end
	function tableData.Close()
		GlobeSelectTarget(SelectedCampaign)
		waitCount = 0
		aButtonReady = false
		StopVO()
	end
	function GetCampaignBriefing1stPage()
		return tableData
	end
	DebugOut("Campaign Brifing 1st ticked ***")
end
