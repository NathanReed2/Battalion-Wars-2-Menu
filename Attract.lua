function Attract(owner)
	local tableData = {}
	local bExiting = false
	local alreadyPressedButton = false
	local controllerErrorsWereEnabled = false
	local getAttractName = function()
		return "AttractMode"
	end
	local function startVideo()
		SetMusicVolume(1, 0.5)
		PlayVideo(VIDEO.ONCE, getAttractName(), 0)
	end
	local function stopVideo()
		SetMusicVolume(0, 0.5)
		PlayVideo(VIDEO.OFF, getAttractName(), 0)
	end
	function tableData.bPress()
		if bFadeNotDone() then
			return
		end
		if alreadyPressedButton == false then
			alreadyPressedButton = true
			initFadeOut()
		end
	end
	local checkVideo = function()
		if IsVideoFinished() then
			PopPageStack()
		end
	end
	function tableData.Open()
		controllerErrorsWereEnabled = EnableControllerErrorMessages(false)
		alreadyPressedButton = false
		initFadeIn()
		startVideo()
	end
	function tableData.Update()
		updateFadeColour(tableData)
		checkVideo()
		if alreadyPressedButton and bFadeOutDone() then
			PopPageStack()
		end
	end
	function tableData.Close()
		stopVideo()
		EnableControllerErrorMessages(controllerErrorsWereEnabled)
	end
	function GetAttractPage()
		return tableData
	end
	DebugOut("Attract ticked ***")
end
