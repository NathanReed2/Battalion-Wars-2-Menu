function GOPre(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	local fadeCount = 180
	local fadeRate = 180 / (GetFramesPerSecond() * 1.5)
	local fadeScale = 3
	bGOPreFadeIn = true
	local function updateAlpha()
		if bGOPreFadeIn then
			fadeCount = fadeCount - fadeRate * fadeScale
		else
			fadeCount = fadeCount + fadeRate * fadeScale
		end
	end
	local function checkExit()
		if bGOPreFadeIn and fadeCount < 0 then
			fadeCount = 0
			PushPageStack("GO")
		elseif not bGOPreFadeIn and 180 < fadeCount then
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
	function tableData.gotoSave()
	end
	function tableData.gotoMP()
	end
	function tableData.gotoGO()
	end
	function tableData.gotoExtras()
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
		if bGOPreFadeIn then
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
		if bGOPreFadeIn then
			bGOPreFadeIn = false
		else
			bGOPreFadeIn = true
		end
	end
	function GetGOPrePage()
		return tableData
	end
	DebugOut("GOPre ticked ***")
end
