function GO2(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	local unitFollowMode = eModeAction.Follow
	local fieldToggle = eFieldToggle.Off
	local displayTutorials = false
	local unitFollowModeColour = 1
	local fieldToggleColour = 1
	local displayTutorialsColour = 1
	local unitLeftModeColour = 1
	local unitRightModeColour = 1
	function tableData.setUnitSpawnLeft()
		unitFollowMode = eModeAction.Wait
		SetFollowMode(unitFollowMode)
		GOChanged = true
	end
	function tableData.setUnitSpawnRight()
		unitFollowMode = eModeAction.Follow
		SetFollowMode(unitFollowMode)
		GOChanged = true
	end
	function tableData.setUnitSpawnLeftColour()
		unitLeftModeColour = 1
	end
	function tableData.setUnitSpawnRightColour()
		unitFollowModeColour = 0
		unitRightModeColour = 1
	end
	function tableData.setUnitSpawnLeftColourOff()
		unitLeftModeColour = 0
	end
	function tableData.setUnitSpawnRightColourOff()
		unitRightModeColour = 0
	end
	function tableData.getUnitSpawnButtonSetLeft()
		if unitFollowMode == eModeAction.Wait then
			return 2
		end
		return 1
	end
	function tableData.getUnitSpawnButtonSetRight()
		if unitFollowMode == eModeAction.Follow then
			return 2
		end
		return 1
	end
	function tableData.getUnitSpawnStringColour()
		if unitFollowMode == eModeAction.Wait or unitLeftModeColour == 1 then
			return 0, 0, 0, 255
		end
		return 255, 255, 255, 128
	end
	function tableData.getUnitSpawnStringColourReverse()
		if unitFollowMode == eModeAction.Follow or unitRightModeColour == 1 then
			return 0, 0, 0, 255
		end
		return 255, 255, 255, 128
	end
	function tableData.setFieldToggleLeft()
		fieldToggle = eFieldToggle.Off
		SetFieldToggle(fieldToggle)
		GOChanged = true
	end
	function tableData.setFieldToggleRight()
		fieldToggle = eFieldToggle.On
		SetFieldToggle(fieldToggle)
		GOChanged = true
	end
	function tableData.setFieldToggleLeftColour()
		fieldToggleColour = 1
	end
	function tableData.setFieldToggleRightColour()
		fieldToggleColour = 0
	end
	function tableData.getFieldToggleButtonSetLeft()
		if fieldToggle == eFieldToggle.Off then
			return 2
		end
		return 1
	end
	function tableData.getFieldToggleButtonSetRight()
		if fieldToggle == eFieldToggle.On then
			return 2
		end
		return 1
	end
	function tableData.getFieldToggleStringColour()
		if fieldToggle == eFieldToggle.Off or fieldToggleColour == 1 then
			return 0, 0, 0, 255
		end
		return 255, 255, 255, 128
	end
	function tableData.getFieldToggleStringColourReverse()
		if fieldToggle == eFieldToggle.On or fieldToggleColour == 0 then
			return 0, 0, 0, 255
		end
		return 255, 255, 255, 128
	end
	function tableData.setDisplayTutorialsLeft()
		displayTutorials = true
		SetTutorialMode(displayTutorials)
		GOChanged = true
	end
	function tableData.setDisplayTutorialsRight()
		displayTutorials = false
		SetTutorialMode(displayTutorials)
		GOChanged = true
	end
	function tableData.setDisplayTutorialsLeftColour()
		displayTutorialsColour = 1
	end
	function tableData.setDisplayTutorialsRightColour()
		displayTutorialsColour = 0
	end
	function tableData.getDisplayTutorialsButtonSetLeft()
		if displayTutorials then
			return 2
		end
		return 1
	end
	function tableData.getDisplayTutorialsButtonSetRight()
		if not displayTutorials then
			return 2
		end
		return 1
	end
	function tableData.getDisplayTutorialsStringColour()
		if displayTutorials or displayTutorialsColour == 1 then
			return 0, 0, 0, 255
		end
		return 255, 255, 255, 128
	end
	function tableData.getDisplayTutorialsStringColourReverse()
		if not displayTutorials or displayTutorialsColour == 0 then
			return 0, 0, 0, 255
		end
		return 255, 255, 255, 128
	end
	local function initOptions()
		unitFollowMode = GetFollowMode()
		fieldToggle = GetFieldToggle()
		displayTutorials = GetTutorialMode()
	end
	local endOptions = function()
	end
	function tableData.Open()
		initOptions()
	end
	function tableData.Update()
		pollTitleLoop()
	end
	function tableData.Close()
		endOptions()
	end
	function GetGO2Page()
		return tableData
	end
	DebugOut("GO2 ticked ***")
end
