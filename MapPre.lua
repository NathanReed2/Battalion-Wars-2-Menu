function MapPre(owner)
	local tableData = {}
	local fadeCount = 180
	local fadeRate = 180 / (GetFramesPerSecond() * 1.5)
	local fadeScale = 3
	local bFadeIn = true
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
			PushPageStack("Map")
		elseif not bFadeIn and 180 < fadeCount then
			fadeCount = 180
			PopPageStack()
		end
	end
	function tableData.trapFilterCol()
		return 255
	end
	local selectedGlobe = 1
	local prevSelectedCampaign = 1
	local selectedCampaignButton = 1
	local selectedCampaign = 1
	local globeSelected = true
	function tableData.faderColour(scale)
		return 255 - (cos(fadeCount) * 127.5 + 127.5)
	end
	function tableData.faderColourReverse(scale)
		return cos(fadeCount) * 127.5 + 127.5
	end
	local buttonMoveCount = 180
	local buttonMoveRate = 180 / (GetFramesPerSecond() * 1.5)
	local function updateButtonMove()
		if bFadeIn then
			buttonMoveCount = buttonMoveCount - buttonMoveRate * fadeScale
		else
			buttonMoveCount = buttonMoveCount + buttonMoveRate * fadeScale
		end
	end
	function tableData.getButtonMoveUp(scale)
		return 0, 0 - (cos(buttonMoveCount) * 100 + 100)
	end
	function tableData.getButtonMoveUpReverse(scale)
		return 0, cos(buttonMoveCount) * 100 + 100
	end
	function tableData.getButtonMoveLeft(scale)
		return 0 - (cos(buttonMoveCount) * 100 + 100), 0
	end
	function tableData.getButtonMoveLeftReverse(scale)
		return cos(buttonMoveCount) * 100 + 100, 0
	end
	function tableData.getButtonMoveRight(scale)
		return cos(buttonMoveCount) * 100 + 100, 0
	end
	function tableData.getButtonMoveRightReverse(scale)
		return 0 - (cos(buttonMoveCount) * 100 + 100), 0
	end
	function tableData.gotoSave()
	end
	function tableData.gotoMP()
	end
	function tableData.gotoGO()
	end
	function tableData.gotoExtras()
	end
	function tableData.activateGlobeDown()
	end
	function tableData.activateGlobeHeld()
	end
	function tableData.activateGlobeReleased()
	end
	function tableData.gotoFactionS()
	end
	function tableData.gotoFactionWF()
	end
	function tableData.gotoFactionAI()
	end
	function tableData.gotoFactionIL()
	end
	function tableData.gotoFactionT()
	end
	function tableData.gotoFactionX()
	end
	function tableData.sAlpha()
	end
	function tableData.wfAlpha()
	end
	function tableData.aiAlpha()
	end
	function tableData.ilAlpha()
	end
	function tableData.tAlpha()
	end
	function tableData.getGlobeZoom()
		return 95.7
	end
	function tableData.getAtmosZoom()
		return 85.7
	end
	function tableData.getCampaignActiveButton(idx)
		if GetLevelsDone() > CampaignActiveTable[idx] then
			return true
		else
			return false
		end
	end
	function tableData.getCampaignActive(idx)
		if GetLevelsDone() > CampaignActiveTable[idx] and idx ~= SelectedCampaign then
			return true
		else
			return false
		end
	end
	function tableData.getCampaignSelected(idx)
		if GetLevelsDone() > CampaignActiveTable[idx] then
			return idx == SelectedCampaign
		else
			return false
		end
	end
	function tableData.openRolloverInfo(campaignID)
	end
	function tableData.closeRolloverInfo()
	end
	function tableData.getCampaignName()
		if selectedCampaign == 0 then
			CampaignUnlockString = 0
			return StringID.CampaignSelect
		else
			CampaignUnlockString = selectedCampaign
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
	function tableData.campaignButtonActivated(campaign)
		if selectedCampaign == campaign then
			SelectedCampaign = campaign
			if campaign == 1 and GetLevelsDone() == 0 then
				SelectedLevel = 1
			elseif GetLevelsDone() > CampaignActiveTable[campaign] then
			end
		end
	end
	function MapPreFade(toOrFrom)
		bFadeIn = toOrFrom
	end
	function tableData.fadeCampaign()
		return 82
	end
	function tableData.getPanelMapInfoAlpha()
		return 255
	end
	local numSPLevels = 20
	local EOCMap = {
		true,
		true,
		true,
		true,
		false,
		true,
		true,
		false,
		true,
		true,
		true,
		false,
		true,
		true,
		false,
		true,
		true,
		true,
		false
	}
	function tableData.Open()
		local level = GetLevelsDone()
		if GetLevelsDone() == GetCurrentLevel() and EOCMap[level] then
			level = level + 1
		end
		if level >= numSPLevels then
			level = 1
		end
		SelectedCampaign = GetLevelCampaignMap(level)
		selectedCampaign = SelectedCampaign
		if bFadeIn then
			local sc = SelectedCampaign
			if sc == 0 then
				sc = 1
			end
			if NewCampaign then
				sc = GetLevelCampaignMap(GetLevelsDone())
			end
			GlobeSelectTarget(sc)
		end
		if bFadeIn then
			fadeCount = 180
			buttonMoveCount = 180
		else
			fadeCount = 0
			buttonMoveCount = 0
		end
		SetNextUnlockStrings()
	end
	function tableData.Update()
		if bFadeIn then
			PollMapMusicLoop()
		else
			PollTitleMusicLoop()
		end
		updateAlpha()
		updateButtonMove()
		checkExit()
		GlobeSelectTargetUpdate()
	end
	function tableData.Close()
		if bFadeIn then
			bFadeIn = false
		else
			bFadeIn = true
		end
	end
	function GetMapPrePage()
		return tableData
	end
	DebugOut("MapPre page ticked ***")
end
