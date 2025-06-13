function FMV(owner)
	local tableData = {}
	tableData.clearColour = {
		0,
		0,
		0,
		255
	}
	local bExiting = false
	local totalFrames = 0
	local getAttractName = function()
		return FMVFileNameToPlay
	end
	local function startVideo()
		PlayVideo(VIDEO.ONCE, getAttractName(), 0)
	end
	local function stopVideo()
		SetMusicVolume(0)
		PlayVideo(VIDEO.OFF, getAttractName(), 0)
	end
	local function exitUpdate()
		if bExiting and bFadeOutDone() then
			stopVideo()
			PopPageStack()
		end
	end
	local function checkVideo()
		totalFrames = GetTotalFrames() - 15
		if totalFrames < 1 then
			return
		end
		if GetFrameNum() >= totalFrames and not bExiting then
			bExiting = true
			initFadeOut()
		end
	end
	function tableData.fadeMeOut()
		if not bExiting then
			bExiting = true
			initFadeOut()
		end
	end
	function tableData.Open()
		StopFEMusic()
		bExiting = false
		initFadeIn()
		startVideo()
	end
	function tableData.Update()
		updateFadeColour(tableData)
		exitUpdate()
		checkVideo()
	end
	function tableData.Close()
	end
	function GetFMVPage()
		return tableData
	end
	DebugOut("FMV ticked ***")
end
