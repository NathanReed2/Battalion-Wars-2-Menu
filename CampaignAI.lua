function CampaignAI(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	local movieUnlockedMap = {
		{1, 5},
		{6, 8},
		{9, 12},
		{13, 15},
		{16, 19}
	}
	local toolTip = 0
	function tableData.missionTTOn(idx)
		SetHighlightedLevel(idx)
		toolTip = GetMissionToolTip()
	end
	function tableData.missionTTOff()
		if toolTip ~= 0 then
			toolTip = 0
		end
	end
	local crossfadeCounter = 0
	local function crossfadeUpdate()
		if toolTip == 0 then
			crossfadeCounter = crossfadeCounter - 20
			if crossfadeCounter < 0 then
				crossfadeCounter = 0
			end
		else
			crossfadeCounter = crossfadeCounter + 40
			if 512 < crossfadeCounter then
				crossfadeCounter = 512
			end
		end
	end
	function tableData.getPlayerVsEnemyAlpha()
		local count = crossfadeCounter
		if 255 < count then
			count = 255
		end
		return 255 - count
	end
	function tableData.getMissionTitleAlpha()
		local count = crossfadeCounter
		if 255 < count then
			count = 255
		end
		return count
	end
	function tableData.getGlobeZoom()
		return 63
	end
	function tableData.getAtmosZoom()
		return 53
	end
	function tableData.openLevelInfo()
		if SelectedLevel >= 1 and SelectedLevel <= GetLevelsDone() + 1 then
			PushPageStack("CampaignAIInfo")
		end
	end
	local bezierCurves = {}
	local bezierDot
	local function openSprites()
		bezierDot = GetSprite(SpriteID.Map_link_dot_1)
	end
	local closeSprites = function()
	end
	local maxMissions = 5
	local function openBezier()
		local gap
		local done = GetLevelsDone() - 8
		if 4 < done then
			maxMissions = 4
		else
			maxMissions = done
		end
		bezierCurves[1] = {}
		bezierCurves[1].n = 0
		for i = 2, maxMissions do
			bezierCurves[i] = {}
			bezierCurves[i].n = 0
			gap = 12
			QuadraticBezier(MissionPositionTable[SelectedCampaign][i - 1].X, MissionPositionTable[SelectedCampaign][i - 1].Y, MissionPositionTable[SelectedCampaign][i].X, MissionPositionTable[SelectedCampaign][i].Y, gap, 50, bezierCurves[i])
		end
	end
	function tableData.renderBeziers()
		for mission = 1, maxMissions do
			for i = 1, bezierCurves[mission].n do
				MoveSprite(bezierDot, bezierCurves[mission][i][1], bezierCurves[mission][i][2])
				DrawSprite(bezierDot)
			end
		end
	end
	local function closeBezier()
		bezierCurves = {}
	end
	function tableData.gotoBriefing()
		PushPageStack("CampaignBriefing")
	end
	function tableData.Open()
		ResetHighlightedLevel()
		openSprites()
		openBezier()
		MapPostForwards(false)
	end
	function tableData.Update()
		PollMapMusicLoop()
		crossfadeUpdate()
	end
	function tableData.Close()
		crossfadeCounter = 0
		toolTip = 0
		closeSprites()
		closeBezier()
	end
	function GetCampaignAIPage()
		return tableData
	end
	DebugOut("CampaignAI ticked ***")
end
