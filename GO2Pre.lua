function GO2Pre(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	local fadeCount = 180
	local fadeRate = 180 / (GetFramesPerSecond() * 1.5)
	local fadeScale = 3
	bGO2PreFadeIn = true
	local function updateAlpha()
		if bGO2PreFadeIn then
			fadeCount = fadeCount - fadeRate * fadeScale
		else
			fadeCount = fadeCount + fadeRate * fadeScale
		end
	end
	local function checkExit()
		if bGO2PreFadeIn and fadeCount < 0 then
			fadeCount = 0
			PushPageStack("GO2")
		elseif not bGO2PreFadeIn and 180 < fadeCount then
			fadeCount = 180
			PopPageStack()
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
	end
	function tableData.setUnitSpawnRight()
		unitFollowMode = eModeAction.Follow
		SetFollowMode(unitFollowMode)
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
	end
	function tableData.setFieldToggleRight()
		fieldToggle = eFieldToggle.On
		SetFieldToggle(fieldToggle)
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
	end
	function tableData.setDisplayTutorialsRight()
	end
	function tableData.setDisplayTutorialsLeftColour()
	end
	function tableData.setDisplayTutorialsRightColour()
	end
	function tableData.getDisplayTutorialsButtonSetLeft()
	end
	function tableData.getDisplayTutorialsButtonSetRight()
	end
	function tableData.getDisplayTutorialsStringColour()
	end
	function tableData.getDisplayTutorialsStringColourReverse()
	end
	local function initOptions()
		unitFollowMode = GetFollowMode()
		fieldToggle = GetFieldToggle()
		displayTutorials = GetTutorialMode()
	end
	local endOptions = function()
	end
	function tableData.gotoGO1()
	end
	function tableData.gotoGO2()
	end
	function tableData.gotoGO3()
	end
	function tableData.gotoGO4()
	end
	function tableData.Open()
		initOptions()
		if bGO2PreFadeIn then
			fadeCount = 180
		else
			fadeCount = 0
		end
	end
	function tableData.Update()
		pollTitleLoop()
		updateAlpha()
		checkExit()
	end
	function tableData.Close()
		if bGO2PreFadeIn then
			bGO2PreFadeIn = false
		else
			bGO2PreFadeIn = true
		end
	end
	function GetGO2PrePage()
		return tableData
	end
	DebugOut("GO2Pre ticked ***")
end
