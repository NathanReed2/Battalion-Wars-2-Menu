function Music(owner)
end
MusicFadeOutSecs = 0.5
local MusicDirectory = "Data/Audio/Music/Ingame"
local MusicDirectory2 = "Data/Audio/Music/BW2"
local FEMusic = false
local Fanfare = 1
local FirstTime = false
local TitleLoopVol = 0.6
local MapLoopVol = 0.85
local StingsVolV = 0.55
local StingsVolD = 0.55
local noLoop = 0
local titleLoop = 1
local mapLoop = 2
local currentLoop = titleLoop
local musicFadeCounter = 0
local musicFading = false
local fadeInTimeSecs = 0.1
local fadeOutTimeSecs = MusicFadeOutSecs
local musicFilenames = {
	TitleLoop = "TitleLoop",
	MapScreen = "MapScreen",
	Victory_A = "Victory_A",
	Victory_C = "Victory_A",
	Defeat = "Defeat",
	Credits = "SP_2.2_InGame",
	Units = "MapScreen",
	Concept = "MapScreen",
	SolarEmpire = "SP_1.3_InGame",
	WesternFrontier = "SP_2.1_InGame",
	AngloIsles = "SP_3.4_InGame",
	IronLegion = "C4B_Amb",
	TundranTerritories = "SP_5.3_InGame",
	Xylvania = "SP_4.2_InGame"
}
function SetFEMusic(bool)
	FEMusic = bool
end
function StopFEMusic()
	StopMusic()
	FEMusic = false
	Fanfare = 1
end
local function checkMusic(type)
	if 0 < musicFadeCounter and FEMusic then
		musicFadeCounter = musicFadeCounter - 1
		if musicFadeCounter == 1 then
			StopMusic()
			musicFadeCounter = 0
			FEMusic = false
			Fanfare = 1
		end
		return true
	end
	if currentLoop ~= type and not musicFading then
		musicFading = true
		musicFadeCounter = GetFramesPerSecond() * fadeOutTimeSecs
		SetMusicVolume(0, fadeOutTimeSecs)
		currentLoop = noLoop
	end
	return false
end
function PollTitleMusicLoop()
	if checkMusic(titleLoop) then
		return
	end
	if not FEMusic then
		SetMusicVolume(TitleLoopVol, fadeInTimeSecs)
		FEMusic = StartMusic(constant.FILENAME, MusicDirectory, musicFilenames.TitleLoop)
		if FEMusic then
			musicFading = false
			currentLoop = titleLoop
		end
	end
end
local unitsMusic = {
	musicFilenames.SolarEmpire,
	musicFilenames.WesternFrontier,
	musicFilenames.AngloIsles,
	musicFilenames.IronLegion,
	musicFilenames.TundranTerritories,
	musicFilenames.Xylvania
}
function PollUnitsMusicLoop(faction)
	if not FEMusic then
		local dir = MusicDirectory2
		if faction == 4 then
			dir = MusicDirectory
		end
		SetMusicVolume(MapLoopVol, fadeInTimeSecs)
		FEMusic = StartMusic(constant.FILENAME, dir, unitsMusic[faction])
	end
end
function PollConceptMusicLoop()
	if not FEMusic then
		SetMusicVolume(MapLoopVol, fadeInTimeSecs)
		FEMusic = StartMusic(constant.FILENAME, MusicDirectory, musicFilenames.Concept)
	end
end
function PollCreditsMusicLoop()
	if not FEMusic then
		SetMusicVolume(MapLoopVol, fadeInTimeSecs)
		FEMusic = StartMusic(constant.FILENAME, MusicDirectory2, musicFilenames.Credits)
	end
end
function InitDefeatMusic()
	Fanfare = 0
	FEMusic = false
	currentLoop = mapLoop
	SetMusicVolume(StingsVolD, fadeInTimeSecs)
	StartMusic(constant.FILENAME, MusicDirectory, musicFilenames.Defeat, 0, constant.ONCE)
end
function InitVictoryMusic(mGrade)
	Fanfare = 0
	FEMusic = false
	currentLoop = mapLoop
	SetMusicVolume(StingsVolV, fadeInTimeSecs)
	if mGrade == GRADE.S or mGrade == GRADE.A then
		StartMusic(constant.FILENAME, MusicDirectory, musicFilenames.Victory_A, 0, constant.ONCE)
	elseif mGrade == GRADE.B or mGrade == GRADE.C then
		StartMusic(constant.FILENAME, MusicDirectory, musicFilenames.Victory_C, 0, constant.ONCE)
	end
end
function PollMapMusicLoop()
	if checkMusic(mapLoop) then
		return
	end
	if Fanfare == 2 then
		return
	elseif Fanfare == 1 and not FEMusic then
		SetMusicVolume(MapLoopVol, fadeInTimeSecs)
		FEMusic = StartMusic(constant.FILENAME, MusicDirectory, musicFilenames.MapScreen)
		if FEMusic then
			musicFading = false
			Fanfare = 2
			currentLoop = mapLoop
		end
	elseif CheckMusicFinished() then
		Fanfare = 1
		StopMusic()
	end
end
function pollTitleLoop()
	PollTitleMusicLoop()
end
function MusicEnd()
end
