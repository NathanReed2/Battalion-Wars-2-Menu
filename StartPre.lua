function StartPre(owner)
	local tableData = {}
	local fadeCount = 180
	local fadeRate = 180 / (GetFramesPerSecond() * 0.3)
	local function updateAlpha()
		if bFadeInDone() then
			fadeCount = fadeCount - fadeRate
		end
		if fadeCount < 0 then
			SetPageStack("Start")
			fadeCount = 0
		end
	end
	function tableData.faderColour()
		return cos(fadeCount) * 127.5 + 127.5
	end
	function tableData.Open()
		initFadeIn()
	end
	function tableData.Update()
		updateFadeColour(tableData)
		updateAlpha()
		PollTitleMusicLoop()
	end
	function tableData.Close()
	end
	function GetStartPrePage()
		return tableData
	end
	DebugOut("StartPre ticked ***")
end
