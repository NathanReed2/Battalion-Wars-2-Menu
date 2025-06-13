function Map2(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	function tableData.getCampaignName()
		if SelectedCampaign == 0 then
			return ""
		else
			return FactionNameTable[SelectedCampaign]
		end
	end
	function tableData.getCampaignActive(idx)
		if GetLevelsDone() > CampaignActiveTable[idx] then
			return true
		else
			return false
		end
	end
	function tableData.gotoFactionS()
		if GetLevelsDone() == 0 then
			SelectedLevel = 1
			RunCampaignLevel()
		else
			PushPageStack("CampaignS")
		end
	end
	function tableData.gotoFactionWF()
		PushPageStack("CampaignWF")
	end
	function tableData.gotoFactionAI()
		PushPageStack("CampaignAI")
	end
	function tableData.gotoFactionIL()
		PushPageStack("CampaignIL")
	end
	function tableData.gotoFactionT()
		PushPageStack("CampaignT")
	end
	function tableData.gotoFactionX()
		PushPageStack("CampaignX")
	end
	function tableData.popTwice()
		PopPageStack()
	end
	function tableData.gotoTraining()
		PushPageStack("Training")
	end
	local panelAlpha = 0
	local panelAlphaRate = 48
	local panelOn = false
	function tableData.openRolloverInfo(campaignID)
		panelOn = true
		SelectedCampaign = campaignID
	end
	function tableData.closeRolloverInfo()
		panelOn = false
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
	function tableData.Open()
		panelAlpha = 0
		panelAlphaRate = 48
		panelOn = false
		HighlightedLevel = -1
	end
	function tableData.Update()
		PollUnitsMusicLoop()
		updatePanelAlpha()
	end
	function GetMap2Page()
		return tableData
	end
	DebugOut("Map2 ticked ***")
end
