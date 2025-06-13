function Logo(owner)
	local tableData = {}
	local bPlaying = false
	local bExiting = false
	local fadeCount = 180
	local fadeRate = 0
	local fadeRateStart = 180 / (GetFramesPerSecond() * 0.3)
	function tableData.faderColour()
		return cos(fadeCount) * 127.5 + 127.5
	end
	local function updateAlpha()
		if 0 < fadeCount then
			fadeCount = fadeCount - fadeRate
			if fadeCount < 0 then
				fadeCount = 0
			end
		end
	end
	local function checkVideo()
		if bPlaying then
			local totalFrames = GetTotalFrames()
			if GetFrameNum() >= totalFrames - 1 and not bExiting then
				bExiting = true
				ResetPageStack("StartPre")
			end
		else
			bPlaying = true
			if GetScreenRatio() == 0 then
				PlayVideo(VIDEO.ONCE, "BWii_Intro", 0)
			else
				PlayVideo(VIDEO.ONCE, "BWii_Intro_w", 0)
			end
			PlayLogoAnim = true
		end
	end
	function tableData.skipLogo()
		bExiting = true
		ResetPageStack("StartPre")
	end
	function tableData.Open()
		EnableControllerErrorMessages(false)
		bPlaying = false
		bExiting = false
		initFadeIn()
	end
	function tableData.Update()
		updateFadeColour(tableData)
		checkVideo()
		updateAlpha()
	end
	function tableData.Close()
	end
	function GetLogoPage()
		return tableData
	end
	DebugOut("Logo page ticked ***")
end
