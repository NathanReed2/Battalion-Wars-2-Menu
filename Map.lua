function Map(owner)
	local tableData = {}
	tableData.cursorSelect = GetFingetCursor()
	tableData.revConCursor = GetHandCursor()
	local panelAlpha = 0
	local panelAlphaRate = 20
	local panelOn = false
	local initCursorState = 0
	local selectedGlobe = 1
	local prevSelectedCampaign = 1
	local selectedCampaignButton = 0
	local selectedCampaign = 1
	local globeSelected = true
	function tableData.selectGlobe()
		globeSelected = true
	end
	function tableData.deselectGlobe()
		globeSelected = false
	end
	function tableData.activateGlobeDown()
		GlobeSelectOnActivate()
		EndMainCursor(tableData)
		tableData.revConCursor = GetGrabCursor()
		OpenSprite(tableData.revConCursor)
	end
	function tableData.activateGlobeHeld()
		GlobeSelectOnHeld()
	end
	function tableData.activateGlobeReleased()
		GlobeSelectOnReleased()
		EndMainCursor(tableData)
		tableData.revConCursor = GetHandCursor()
		OpenSprite(tableData.revConCursor)
	end
	function tableData.mapButtonHeld()
	end
	function tableData.mapButtonRelease()
	end
	function tableData.PopPageStack()
		MapPreFade(false)
		PopPageStack()
	end
	local function updateGlobe()
		GlobeSelectUpdate()
		selectedCampaign = GlobeSelectedContinent()
		if selectedCampaign == 0 and selectedCampaignButton ~= 0 then
			selectedCampaign = selectedCampaignButton
		end
		if selectedCampaign ~= prevSelectedCampaign then
			selectedGlobe = 0
			prevSelectedCampaign = selectedCampaign
		end
	end
	local initGlobe = function()
		GlobeSelectInit()
	end
	local globeZoomCount = 180
	function tableData.getGlobeZoom()
		return 95.7 - (cos(globeZoomCount) * 16.35 + 16.35)
	end
	local fadeCount = 180
	local fadeRate = 180 / (GetFramesPerSecond() * 2)
	local waitCount2 = 0
	local function updatePanelFade()
		if waitCount2 < 180 then
			waitCount2 = waitCount2 + 1
		else
			if 0 < fadeCount then
				fadeCount = fadeCount - fadeRate
			else
				fadeCount = fadeCount + fadeRate
			end
			if 180 < fadeCount then
				fadeCount = 180
			end
			if fadeCount < 0 then
				fadeCount = 0
			end
		end
	end
	function tableData.fadeCampaign()
		return 255
	end
	local mapHeaderPosY = -60
	local function updatemapHeaderPos()
		if selectedCampaign == 0 then
			mapHeaderPosY = mapHeaderPosY - 5
			if mapHeaderPosY < -60 then
				mapHeaderPosY = -60
			end
		else
			mapHeaderPosY = mapHeaderPosY + 5
			if 8 < mapHeaderPosY then
				mapHeaderPosY = 8
			end
		end
	end
	function tableData.mapHeaderPos()
		return 0, mapHeaderPosY
	end
	local headerColours = {
		{
			255,
			255,
			255,
			255
		},
		{
			124,
			207,
			41,
			255
		},
		{
			255,
			242,
			136,
			255
		},
		{
			174,
			85,
			255,
			255
		},
		{
			231,
			79,
			61,
			255
		}
	}
	function getCampaignTitleColour()
		if 1 <= selectedCampaign and selectedCampaign <= 5 and GetLevelsDone() > CampaignActiveTable[selectedCampaign] then
			return headerColours[selectedCampaign]
		end
		return 255, 255, 255, 255
	end
	function tableData.getCampaignName()
		if 0 < selectedCampaign and selectedCampaign <= 5 and GetLevelsDone() > CampaignActiveTable[selectedCampaign] then
			if GetGlobeGrabbed() then
				SetCursorState(CursorState.Normal)
			else
				SetCursorState(CursorState.Selected)
			end
			panelOn = true
			CampaignUnlockString = selectedCampaign
			return FactionNameTable[selectedCampaign]
		end
		SetCursorState(CursorState.Normal)
		panelOn = false
		CampaignUnlockString = 0
		return ""
	end
	function tableData.getCampaignActiveButton(idx)
		if GetLevelsDone() > CampaignActiveTable[idx] then
			return true
		else
			return false
		end
	end
	function tableData.getCampaignActive(idx)
		if GetLevelsDone() > CampaignActiveTable[idx] and idx ~= selectedCampaign then
			return true
		else
			return false
		end
	end
	function tableData.getCampaignSelected(idx)
		if GetLevelsDone() > CampaignActiveTable[idx] then
			return idx == selectedCampaign
		else
			return false
		end
	end
	local movieUnlockedMap = {
		{1, 5},
		{6, 8},
		{9, 12},
		{13, 15},
		{16, 19}
	}
	function tableData.campaignButtonActivated(campaign)
		if selectedCampaign == campaign then
			SelectedCampaign = campaign
			if GetLevelsDone() == 0 then
				SelectedLevel = 1
				SetMissionStatus(GAMESTATUS.PLAY)
				PushPageStack("CutsceneIn")
			elseif GetLevelsDone() > CampaignActiveTable[SelectedCampaign] then
				MapPostForwards(true)
				PushPageStack("MapPost")
			end
		end
	end
	function tableData.getAtmosZoom()
		return 85.7
	end
	function tableData.sAlpha()
		if selectedCampaign == 1 then
			return 255
		else
			return 130
		end
	end
	function tableData.wfAlpha()
		if selectedCampaign == 2 then
			return 255
		else
			return 130
		end
	end
	function tableData.aiAlpha()
		if selectedCampaign == 3 then
			return 255
		else
			return 130
		end
	end
	function tableData.ilAlpha()
		if selectedCampaign == 4 then
			return 255
		else
			return 130
		end
	end
	function tableData.tAlpha()
		if selectedCampaign == 5 then
			return 255
		else
			return 130
		end
	end
	local armyPlate = 0
	local armyPlateNo = 0
	function getArmyPlate(id)
		if GetCampaignUnlockLevel(id) == 3 then
			if armyPlate == id then
				return 4
			else
				return 3
			end
		elseif armyPlate == id then
			return 2
		else
			return 1
		end
	end
	function getArmyPlateNo(id)
		if armyPlate == id then
			return -45, 2
		else
			return -39, 0
		end
	end
	function getArmyPlateNo2(id)
		if armyPlate == id then
			return 32, 2
		else
			return 27, 0
		end
	end
	function tableData.backSelected()
		if not GetGlobeGrabbed() then
			EndMainCursor(tableData)
			tableData.revConCursor = GetFingetCursor()
			OpenSprite(tableData.revConCursor)
		end
	end
	function tableData.backDeselected()
		if not GetGlobeGrabbed() then
			EndMainCursor(tableData)
			tableData.revConCursor = GetHandCursor()
			OpenSprite(tableData.revConCursor)
		end
	end
	function tableData.openRolloverInfo(campaignID)
		panelOn = true
		selectedCampaignButton = campaignID
		armyPlate = campaignID
	end
	function tableData.closeRolloverInfo()
		panelOn = false
		selectedCampaignButton = 0
		armyPlate = 0
	end
	function tableData.getPanelMapInfoAlpha()
		return panelAlpha
	end
	local function updatePanelAlpha()
		if panelOn then
			panelAlpha = panelAlpha + panelAlphaRate
		else
			panelAlpha = panelAlpha - panelAlphaRate
		end
		if 255 < panelAlpha then
			panelAlpha = 255
		elseif panelAlpha < 0 then
			panelAlpha = 0
		end
	end
	function tableData.getSpinPitch()
		return GlobeSelectSpinPitch()
	end
	function tableData.fadeCampaign()
		return 220
	end
	function tableData.Open()
		panelAlpha = 0
		panelAlphaRate = 20
		panelOn = false
		HighlightedLevel = -1
		selectedCampaignButton = 0
		armyPlate = 0
		initGlobe()
		local sc = SelectedCampaign
		if sc == 0 then
			sc = 1
		end
		if NewCampaign then
			sc = GetLevelCampaignMap(GetLevelsDone())
		end
		GlobeSetTarget(sc)
		selectedCampaign = 0
		NewCampaign = false
		SetNextUnlockStrings()
		initCursorState = 0
	end
	function tableData.Update()
		if initCursorState < 3 then
			initCursorState = initCursorState + 1
		end
		PollMapMusicLoop()
		updatePanelAlpha()
		updateGlobe()
		updatemapHeaderPos()
	end
	function tableData.Close()
		initCursorState = 0
	end
	function GetMapPage()
		return tableData
	end
	DebugOut("Map ticked ***")
end
