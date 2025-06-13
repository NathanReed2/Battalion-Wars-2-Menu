function GO1Pre(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	local fadeCount = 180
	local fadeRate = 180 / (GetFramesPerSecond() * 1.5)
	local fadeScale = 3
	bGO1PreFadeIn = true
	local function updateAlpha()
		if bGO1PreFadeIn then
			fadeCount = fadeCount - fadeRate * fadeScale
		else
			fadeCount = fadeCount + fadeRate * fadeScale
		end
	end
	local function checkExit()
		if bGO1PreFadeIn and fadeCount < 0 then
			fadeCount = 0
			PushPageStack("GO1")
		elseif not bGO1PreFadeIn and 180 < fadeCount then
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
	function tableData.gotoGO1()
	end
	function tableData.gotoGO2()
	end
	function tableData.gotoGO3()
	end
	function tableData.gotoGO4()
	end
	local musicVolume = GUI_Slider.GO_Music_Volume
	local SFXVolume = GUI_Slider.GO_SFX_Volume
	local COVolume = GUI_Slider.GO_CO_Voice_Volume
	local musicVolumeID = 1
	local SFXVolumeID = 2
	local COVolumeID = 3
	local slider
	local sliderData = {
		{
			musicVolume,
			GetMusicVolume,
			SetMusicVolumeS,
			0
		},
		{
			SFXVolume,
			GetSFXVolume,
			SetSFXVolume,
			0
		},
		{
			COVolume,
			GetCOVoiceVolume,
			SetCOVoiceVolume,
			0
		}
	}
	local initSoundSliders = function()
		GetGO1Page().initOptions()
	end
	function tableData.setSliderEvent(id)
	end
	local coSubtitles = true
	local coSubtitlesLeftColour = 0
	local coSubtitlesRightColour = 0
	local function initCOSubtitles()
		coSubtitles = GetCOSubtitles()
		coSubtitlesLeftColour = 0
		coSubtitlesRightColour = 0
	end
	function tableData.setCoSubtitlesLeft()
		coSubtitles = true
		SetCOSubtitles(coSubtitles)
		GOChanged = true
	end
	function tableData.setCoSubtitlesRight()
		coSubtitles = false
		SetCOSubtitles(coSubtitles)
		GOChanged = true
	end
	function tableData.setCoSubtitlesLeftColour()
		coSubtitlesLeftColour = 1
	end
	function tableData.setCoSubtitlesRightColour()
		coSubtitlesRightColour = 1
	end
	function tableData.setCoSubtitlesLeftColourOff()
		coSubtitlesLeftColour = 0
	end
	function tableData.setCoSubtitlesRightColourOff()
		coSubtitlesRightColour = 0
	end
	function tableData.getCoSubtitlesButtonSetLeft()
		if coSubtitles then
			return 2
		end
		return 1
	end
	function tableData.getCoSubtitlesButtonSetRight()
		if not coSubtitles then
			return 2
		end
		return 1
	end
	function tableData.getCoSubtitlesStringColour()
		if coSubtitles or coSubtitlesLeftColour == 1 then
			return 0, 0, 0, 255
		end
		return 255, 255, 255, 128
	end
	function tableData.getCoSubtitlesStringColourReverse()
		if not coSubtitles or coSubtitlesRightColour == 1 then
			return 0, 0, 0, 255
		end
		return 255, 255, 255, 128
	end
	local movieSubtitles = true
	local movieSubtitlesLeftColour = 0
	local movieSubtitlesRightColour = 0
	local function initMovieSubtitles()
		movieSubtitles = GetMovieSubtitles()
		movieSubtitlesLeftColour = 0
		movieSubtitlesRightColour = 0
	end
	function tableData.setMovieSubtitlesLeft()
		movieSubtitles = true
		SetMovieSubtitles(movieSubtitles)
		GOChanged = true
	end
	function tableData.setMovieSubtitlesRight()
		movieSubtitles = false
		SetMovieSubtitles(movieSubtitles)
		GOChanged = true
	end
	function tableData.setMovieSubtitlesLeftColour()
		movieSubtitlesLeftColour = 1
	end
	function tableData.setMovieSubtitlesRightColour()
		movieSubtitlesRightColour = 1
	end
	function tableData.setMovieSubtitlesLeftColourOff()
		movieSubtitlesLeftColour = 0
	end
	function tableData.setMovieSubtitlesRightColourOff()
		movieSubtitlesRightColour = 0
	end
	function tableData.getMovieSubtitlesButtonSetLeft()
		if movieSubtitles then
			return 2
		end
		return 1
	end
	function tableData.getMovieSubtitlesButtonSetRight()
		if not movieSubtitles then
			return 2
		end
		return 1
	end
	function tableData.getMovieSubtitlesStringColour()
		if movieSubtitles or movieSubtitlesLeftColour == 1 then
			return 0, 0, 0, 255
		end
		return 255, 255, 255, 128
	end
	function tableData.getMovieSubtitlesStringColourReverse()
		if not movieSubtitles or movieSubtitlesRightColour == 1 then
			return 0, 0, 0, 255
		end
		return 255, 255, 255, 128
	end
	local function initOptions()
		initSoundSliders()
		initCOSubtitles()
		initMovieSubtitles()
	end
	function tableData.optionChanged()
	end
	function tableData.Open()
		initOptions()
		if bGO1PreFadeIn then
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
		if bGO1PreFadeIn then
			bGO1PreFadeIn = false
		else
			bGO1PreFadeIn = true
		end
	end
	function GetGO1PrePage()
		return tableData
	end
	DebugOut("GO1Pre ticked ***")
end
