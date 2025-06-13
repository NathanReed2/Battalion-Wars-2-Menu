function CampaignILInfo(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	local levelCOHead = 0
	local levelCOEnemyHead = 0
	local briefing = 0
	local levelUnits = 0
	local enemyUnits = 0
	local gradeBadge = 0
	function tableData.closeLevelInfo()
		PopPageStack()
	end
	local toolTip = 0
	function tableData.iconTTOn(id)
	end
	function tableData.iconTTOff()
		if toolTip ~= 0 then
			StopWidget(toolTip)
			toolTip = 0
		end
	end
	function tableData.getGlobeZoom()
		return 63
	end
	function tableData.getAtmosZoom()
		return 53
	end
	function tableData.playCampaignLevel()
		if SelectedLevel <= GetLevelsDone() + 1 then
			SetMissionStatus(GAMESTATUS.PLAY)
			PushPageStack("CutsceneIn")
		end
	end
	function tableData.getFriendlyFacCol()
		return FactionBGColours[CampaignBGColourMapping[SelectedCampaign][1]]
	end
	function tableData.getEnemyFacCol()
		return FactionBGColours[CampaignBGColourMapping[SelectedCampaign][2]]
	end
	function tableData.Open()
		IDTabColourMapping = 4
		toolTip = 0
		levelCOHead = LevelCOHeadFunction(SelectedLevel)
		levelCOEnemyHead = LevelCOHeadEnemy(SelectedLevel)
		levelUnits = LevelUnitsFunction(SelectedLevel)
		enemyUnits = LevelUnitsEnemy(SelectedLevel)
		StartWidget(tableData, levelUnits, false)
		StartWidget(tableData, enemyUnits, false)
		StartWidget(tableData, levelCOHead, false)
		StartWidget(tableData, levelCOEnemyHead, false)
		if 0 < gradeBadge then
			StartWidget(tableData, GetPreviousGradeBadgeBG(), false)
			StartWidget(tableData, gradeBadge, false)
		end
		briefing = LevelBriefing(SelectedLevel)
		StartVO(constant.FILENAME, BriefingDirectory, briefing, 0, constant.ONCE)
	end
	function tableData.Update()
		ResetIconPos()
		PollMapMusicLoop()
	end
	function tableData.Close()
		tableData.iconTTOff()
		StopWidget(levelUnits)
		StopWidget(enemyUnits)
		StopWidget(levelCOHead)
		StopWidget(levelCOEnemyHead)
		if 0 < gradeBadge then
			StopWidget(GetPreviousGradeBadgeBG())
			StopWidget(gradeBadge)
		end
		levelCOHead = 0
		levelUnits = 0
		gradeBadge = 0
		levelCOEnemyHead = 0
		enemyUnits = 0
		StopVO()
	end
	function GetCampaignILInfoPage()
		return tableData
	end
	DebugOut("CampaignILInfo page ticked ***")
end
