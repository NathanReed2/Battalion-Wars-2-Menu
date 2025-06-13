function MapPost(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	local panelAlpha = 0
	local panelAlphaRate = 20
	local panelOn = false
	local fadeCount = 180
	local fadeRate = 180 / (GetFramesPerSecond() * 1.5)
	local fadeScale = 3
	local bFadeIn = true
	local movieUnlockedMap = {
		{1, 5},
		{6, 8},
		{9, 12},
		{13, 15},
		{16, 19}
	}
	local function updateAlpha()
		if bFadeIn then
			fadeCount = fadeCount - fadeRate * fadeScale
		else
			fadeCount = fadeCount + fadeRate * fadeScale
		end
	end
	local function checkExit()
		if bFadeIn and fadeCount < 0 then
			fadeCount = 0
		elseif not bFadeIn and 180 < fadeCount then
			fadeCount = 180
		end
	end
	function tableData.trapFilterCol()
		return 255
	end
	function tableData.faderColour(scale)
		return 255 - (cos(fadeCount) * 127.5 + 127.5)
	end
	function tableData.faderColourReverse(scale)
		return cos(fadeCount) * 127.5 + 127.5
	end
	local done = true
	local forward = true
	local globeZoomFar = 95.7
	local globeZoomNear = 63
	local globeZoomDist = globeZoomFar - globeZoomNear
	local globeZoomCount = 180
	local globeZoomRate = 180 / (GetFramesPerSecond() * 1)
	function tableData.getGlobeZoom()
		return 95.7 - (cos(globeZoomCount) * 16.35 + 16.35)
	end
	function tableData.getAtmosZoom()
		return 88.3781 - (cos(globeZoomCount) * 16.9 + 16.9)
	end
	local fadeRate = 12
	local campaignFade = 255
	local unselectedCampaignFade = 82
	if not forward then
		campaignFade = 0
		unselectedCampaignFade = 0
	end
	local function updatePanelFade()
		if forward and not GlobeHasTarget then
			campaignFade = campaignFade - fadeRate
			unselectedCampaignFade = unselectedCampaignFade - fadeRate
			if campaignFade < 0 then
				campaignFade = 0
			end
			if unselectedCampaignFade < 0 then
				unselectedCampaignFade = 0
			end
		else
			campaignFade = campaignFade + fadeRate
			unselectedCampaignFade = unselectedCampaignFade + fadeRate
			if 255 < campaignFade then
				campaignFade = 255
			end
			if 82 < unselectedCampaignFade then
				unselectedCampaignFade = 82
			end
		end
	end
	function tableData.fadeCampaign()
		return unselectedCampaignFade
	end
	function tableData.getPanelMapInfoAlpha()
		return campaignFade
	end
	local campaignNameTable = {
		"CampaignS",
		"CampaignWF",
		"CampaignAI",
		"CampaignIL",
		"CampaignT"
	}
	local mapHeaderPosY = 8
	local updatemapHeaderPos = function()
	end
	function tableData.mapHeaderPos()
		return 0, mapHeaderPosY
	end
	function tableData.getCampaignName()
		return FactionNameTable[SelectedCampaign]
	end
	local zoomSound = 0
	local function updateGlobeZoom()
		if done then
			return
		end
		if forward and not GlobeHasTarget then
			globeZoomCount = globeZoomCount - globeZoomRate
			if globeZoomCount < 1 then
				globeZoomCount = 1
				PushPageStack(campaignNameTable[SelectedCampaign])
				forward = false
				done = true
			end
			if zoomSound == 0 then
				zoomSound = GUI_Sound.Globe_Zoom_Sound
				StartWidget(tableData, zoomSound, false)
			end
		else
			globeZoomCount = globeZoomCount + globeZoomRate
			if 180 < globeZoomCount then
				globeZoomCount = 180
				if not GlobeHasTarget then
					PopPageStack()
					forward = true
					done = true
				end
			end
		end
	end
	function tableData.getCampaignTitle()
		if SelectedCampaign == 1 then
			return StringID.Campaign1
		end
		if SelectedCampaign == 2 then
			return StringID.Flashback1
		end
		if SelectedCampaign == 3 then
			return StringID.Campaign2
		end
		if SelectedCampaign == 4 then
			return StringID.Flashback2
		end
		if SelectedCampaign == 5 then
			return StringID.Campaign3
		end
	end
	function tableData.getCampaignTitleColour()
		if SelectedCampaign == 1 then
			return 255, 255, 255, 255
		end
		if SelectedCampaign == 2 then
			return 124, 207, 41, 255
		end
		if SelectedCampaign == 3 then
			return 255, 242, 136, 255
		end
		if SelectedCampaign == 4 then
			return 174, 85, 255, 255
		end
		if SelectedCampaign == 5 then
			return 231, 79, 61, 255
		end
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
	local selectedGlobe = 1
	local prevSelectedCampaign = 1
	local selectedCampaignButton = 0
	local selectedCampaign = 1
	local globeSelected = true
	function tableData.getCampaignName()
		if selectedCampaign == 0 then
			panelOn = false
			return StringID.CampaignSelect
		else
			panelOn = true
			return FactionNameTable[selectedCampaign]
		end
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
	local function updateGlobe()
		GlobeSelectUpdate()
		selectedCampaign = GlobeSelectedContinent()
		if selectedCampaign == 0 and selectedCampaignButton ~= 0 then
			selectedCampaign = selectedCampaignButton
		end
		if selectedCampaign ~= prevSelectedCampaign then
			if selectedGlobe ~= 0 then
				selectedGlobe = 0
			end
			prevSelectedCampaign = selectedCampaign
		end
	end
	function tableData.campaignButtonActivated(campaign)
	end
	function tableData.openRolloverInfo(campaignID)
	end
	function tableData.closeRolloverInfo()
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
	function tableData.backSelected()
	end
	function tableData.backDeselected()
	end
	function MapPostForwards(flag)
		bFadeIn = flag
		forward = flag
		if flag then
			campaignFade = 255
			unselectedCampaignFade = 82
			globeZoomCount = 180
		else
			campaignFade = 0
			unselectedCampaignFade = 0
			globeZoomCount = 1
		end
	end
	function tableData.Open()
		selectedCampaign = SelectedCampaign
		if forward then
			GlobeSelectTarget(SelectedCampaign)
		else
			StartWidget(tableData, GUI_Sound.Globe_Zoom_Sound, false)
		end
		done = false
		if bFadeIn then
			fadeCount = 180
		else
			fadeCount = 0
		end
	end
	function tableData.Update()
		PollMapMusicLoop()
		if 100 < globeZoomCount then
			updatePanelFade()
		end
		updateGlobeZoom()
		GlobeSelectTargetUpdate()
		updateAlpha()
		checkExit()
	end
	function tableData.Close()
		zoomSound = 0
		if bFadeIn then
			bFadeIn = false
		else
			bFadeIn = true
		end
		if not forward and movieUnlockedMap[SelectedCampaign][1] == GetLevelsDone() and not BriefingHasBeenSeen(SelectedSlot, SelectedCampaign) then
			PushPageStack("CampaignBriefing1st")
		end
	end
	function GetMapPostPage()
		return tableData
	end
	DebugOut("MapPost page ticked ***")
end
