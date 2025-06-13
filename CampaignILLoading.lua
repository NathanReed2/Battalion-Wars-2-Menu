function CampaignILLoading(owner)
	local tableData = {}
	local levelCOHead = 0
	local levelUnits = 0
	local stratagemStrID = 0
	function tableData.closeLevelInfo()
	end
	function tableData.quitCampaignLoading()
		RunCampaignLevel()
	end
	local toolTip = 0
	function tableData.iconTTOn(id)
		toolTip = GetUnitToolTip(id)
		StartWidget(tableData, toolTip, false)
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
	function tableData.getFriendlyFacCol()
		if SelectedLevel == 1 then
			return FactionBGColours[CampaignBGColourMapping[1][1]]
		end
		return FactionBGColours[CampaignBGColourMapping[SelectedCampaign][1]]
	end
	function tableData.getStratagem()
		return stratagemStrID
	end
	function tableData.getObjectiveStr(obj)
		return GetMissionObjectives(SelectedLevel - 1) + obj - 1
	end
	function tableData.Open()
		IDTabColourMapping = 1
		StopFEMusic()
	end
	function tableData.Update()
		RunCampaignLevel()
	end
	function tableData.Close()
	end
	function GetCampaignILLoadingPage()
		return tableData
	end
	DebugOut("CampaignILLoading page ticked ***")
end
