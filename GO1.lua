function GO1(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	local musicVolume = 840002101
	local SFXVolume = 620000071
	local COVolume = 620000070
	local musicVolumeID = 1
	local SFXVolumeID = 2
	local COVolumeID = 3
	local slider, volume
	local minVolumeSize = 3
	local maxVolumeSize = 125
	local volumeHeight = 32
	local maxVolume = 31
	local volumeStep = 1
	local volumeRepeatStep = 1
	local volumeChangeFrames = 0
	local volumeChangeLastRepeatFrames = 0
	local volumeRepeatRate = 7
	local volumeRepeatDelay = 30
	local effectDirectory = "Data/Audio/Voiceover/Mission_Briefs"
	local effectNames = {
		"Ubel_Hello03.adp",
		"Ubel_Hello03copy.adp"
	}
	local voPlaying = {false, false}
	local playVOCounter = 0
	local playVOCount = GetFramesPerSecond() * 0.8
	local playVOCountMin = GetFramesPerSecond() * 0.3
	local playVOID = 1
	local bPlayVO = false
	local function playVO1()
		playVOID = 2
		StartVO(constant.FILENAME, effectDirectory, effectNames[playVOID], 0, constant.ONCE)
		playVOCounter = playVOCountMin
		bPlayVO = false
	end
	local function playVO2()
		playVOID = 1
		StartVO(constant.FILENAME, effectDirectory, effectNames[playVOID], 0, constant.ONCE)
		playVOCounter = playVOCountMin
		bPlayVO = false
	end
	local playVOFuncVector = {playVO1, playVO2}
	function tableData.sliderCOButtonReleased()
	end
	local playSFXCount = GetFramesPerSecond() * 0.4
	local playSFX = 0
	local sfxSound = 0
	local prevCOVol = 0
	local prevSFXVol = 0
	local function updateSoundCounters()
		if bPlayVO then
			if playVOCounter == 1 then
				playVOCounter = 0
				StopVO()
			else
				playVOFuncVector[playVOID]()
			end
		end
		if 0 < playVOCounter then
			playVOCounter = playVOCounter - 1
		end
		if 0 < playSFX then
			playSFX = playSFX - 1
			if playSFX == 0 and sfxSound ~= 0 then
				StopWidget(sfxSound)
				sfxSound = 0
			end
		end
	end
	local bMaxVolOnce = true
	local function doCOVoiceVol(vol)
		SetCOVoiceVolume(vol)
		if vol < maxVolume then
			bMaxVolOnce = true
		end
		if bMaxVolOnce and playVOCounter == 0 then
			playVOCounter = 1
			bPlayVO = true
		end
		if vol == maxVolume then
			bMaxVolOnce = false
		end
		prevCOVol = vol
	end
	local function doSFXSoundVol(vol)
		SetSFXVolume(vol)
		if playSFX == 0 and vol ~= prevSFXVol then
			sfxSound = GUI_Sound.GO1_SFX_slider_sound
			StartWidget(tableData, sfxSound, false)
			playSFX = playSFXCount
		end
		prevSFXVol = vol
	end
	local sliderData = {
		{
			musicVolume,
			GetMusicVolume,
			SetMusicVolumeS,
			0,
			0
		},
		{
			SFXVolume,
			GetSFXVolume,
			doSFXSoundVol,
			0,
			0
		},
		{
			COVolume,
			GetCOVoiceVolume,
			doCOVoiceVol,
			0,
			0
		}
	}
	local function volumeToSliderSize(volume)
		return volume * (maxVolumeSize - minVolumeSize) / maxVolume + minVolumeSize
	end
	local function setSliderWidth(vector, width)
		SetWidgetValue(vector, "msVector", width .. "," .. volumeHeight)
	end
	local function initSoundSliders()
		for i = 1, 3 do
			slider = sliderData[i]
			slider[4] = slider[2]()
			slider[5] = slider[4]
			setSliderWidth(slider[1], volumeToSliderSize(slider[4]))
		end
		prevCOVol = GetCOVoiceVolume()
		prevSFXVol = GetSFXVolume()
	end
	function tableData.setSliderEvent(id)
		if 0 < id and id < 4 then
			slider = sliderData[id]
			slider[3](GetWidgetValue(slider[1], "mValue"))
		end
	end
	function onGO1SliderButtonActivate(moreOrLess, sliderID)
		volumeChangeFrames = 0
		volumeChangeLastRepeatFrames = 0
		if 0 < sliderID and sliderID < 4 then
			slider = sliderData[sliderID]
			volume = slider[4]
			if 0 < moreOrLess then
				volume = volume + volumeStep
				if volume > maxVolume then
					volume = maxVolume
				end
			else
				volume = volume - volumeStep
				if volume < 0 then
					volume = 0
				end
			end
			slider[4] = volume
			local size = volumeToSliderSize(volume)
			setSliderWidth(slider[1], size)
			slider[3](volume)
		end
	end
	function onGO1SliderButtonHold(moreOrLess, sliderID)
		if volumeChangeFrames > volumeRepeatDelay and volumeChangeFrames - volumeChangeLastRepeatFrames >= volumeRepeatRate and 0 < sliderID and sliderID < 4 then
			volumeChangeLastRepeatFrames = volumeChangeFrames
			slider = sliderData[sliderID]
			volume = slider[4]
			if 0 < moreOrLess then
				volume = volume + volumeRepeatStep
				if volume > maxVolume then
					volume = maxVolume
				end
			else
				volume = volume - volumeRepeatStep
				if volume < 0 then
					volume = 0
				end
			end
			slider[4] = volume
			local size = volumeToSliderSize(volume)
			setSliderWidth(slider[1], size)
			slider[3](volume)
		end
		volumeChangeFrames = volumeChangeFrames + 1
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
	function tableData.setGO2()
		SetPageStack("GO2")
	end
	function tableData.setGO3()
		SetPageStack("GO3")
	end
	function tableData.initOptions()
		initSoundSliders()
		initCOSubtitles()
		initMovieSubtitles()
	end
	local function endOptions()
		for i = 1, 3 do
			if not GOChanged then
				slider = sliderData[i]
				if slider[4] ~= slider[5] then
					GOChanged = true
				end
			end
		end
	end
	function tableData.optionChanged()
		GOChanged = true
	end
	function tableData.Open()
		tableData.initOptions()
	end
	function tableData.Update()
		pollTitleLoop()
		updateSoundCounters()
	end
	function tableData.Close()
		endOptions()
		StopVO()
	end
	function GetGO1Page()
		return tableData
	end
	DebugOut("GO1 ticked ***")
end
