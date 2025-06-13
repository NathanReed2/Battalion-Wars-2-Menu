function Global(owner)
end
TestLevelCycle = false
PlayLogoAnim = false
SelectedLevel = 0
LevelsDone = 0
SelectedSlot = 0
NumFrontendLevels = GetNumOfGameType(GAMETYPE.Frontend2)
NumLevels = 24
MStatus = GAMESTATUS.NONE
MPStatus = GAMESTATUS.NONE
GameType = GAMETYPE.Skirmish
FrontendDone = false
GameSaveLoaded = true
MPSaveStatus = true
SPSaveStatus = false
MPSaveLoaded = true
MPSaveLoadedOK = false
GOChanged = false
GOChangedMP = false
ConceptLevel = 7
CreditsLevel = 8
SelectedFaction = 0
CreditsLevelNext = false
SolarEmpireID = 1
WesternFrontierID = 2
AngloIslesID = 3
IronLegionID = 4
TundranTerritoriesID = 5
XylvaniaID = 6
ForcesType = 0
local fadeCount = 180
local fadeRate = 180 / (GetFramesPerSecond() * 0.5)
local fadeDir = 0
function initFadeIn()
	fadeCount = 0
	fadeDir = 1
end
function bFadeInDone()
	return fadeCount == 180
end
function initFadeOut()
	fadeCount = 180
	fadeDir = 2
end
function bFadeOutDone()
	return fadeCount == 0
end
function getFadeCount()
	return fadeCount
end
function initFadeFullOn()
	fadeCount = 180
	fadeDir = 0
end
function initFadeFullOff()
	fadeCount = 0
	fadeDir = 0
end
function updateFadeColour(table)
	local a = 0
	if fadeDir == 1 then
		fadeCount = fadeCount + fadeRate
		if 180 < fadeCount then
			fadeCount = 180
			fadeDir = 0
		end
	elseif fadeDir == 2 then
		fadeCount = fadeCount - fadeRate
		if fadeCount < 0 then
			fadeCount = 0
			fadeDir = 0
		end
	end
	if fadeCount < 180 then
		a = cos(fadeCount) * 127.5 + 127.5
	end
	table.fadeColour = a
end
function bFadeNotDone()
	return fadeCount < 120
end
TriggerPanel = 0
DialogCount = 0
DialogCountStart = GetFramesPerSecond() * 3
TriggerPanelRate = 1 / GetFramesPerSecond() * 30 * 20
TriggerPanelStart = 180 + TriggerPanelRate
function DialogFadeCol()
	local a = 255
	if TriggerPanel > 0 then
		a = cos(TriggerPanel) * 127.5 + 127.5
	end
	return 255, 255, 255, a
end
local buttonState = {
	false,
	false,
	false,
	false
}
function OnButtonSelect(idx)
	buttonState[idx] = true
end
function OnButtonDeselect(idx)
	buttonState[idx] = false
end
function ButtonTextColour(idx)
	if buttonState[idx] then
		return 255, 255, 0, 255
	end
	return 255, 255, 255, 255
end
function GetMainCursor()
	local cursor = {
		SpriteID.FE_RevCon_Cursor,
		{0, 20},
		GetCursorRoll
	}
	return cursor
end
function GetFingetCursor()
	local cursor = {
		SpriteID.FE_RevCon_Cursor,
		{0, 20},
		GetCursorRoll
	}
	return cursor
end
function GetHandCursor()
	local cursor = {
		SpriteID.FE_RevCon_Cursor_Hand,
		{0, 20},
		GetCursorRoll
	}
	return cursor
end
function GetGrabCursor()
	local cursor = {
		SpriteID.FE_RevCon_Cursor_Grab,
		{0, 20},
		GetCursorRoll
	}
	return cursor
end
function GetCrosshairCursor()
	local cursor = {
		SpriteID.FE_RevCon_Cursor_crosshair,
		{0, 0},
		GetCursorRoll
	}
	return cursor
end
function EndSelectCursor(thisTable)
	if thisTable.cursorSelect ~= 0 then
		CloseSprite(thisTable.cursorSelect)
		thisTable.cursorSelect = 0
	end
end
function EndMainCursor(thisTable)
	if thisTable.revConCursor ~= 0 then
		CloseSprite(thisTable.revConCursor)
		thisTable.revConCursor = 0
	end
end
function StartMainCursor(thisTable)
	EndMainCursor(thisTable)
	if thisTable.revConCursor == 0 then
		thisTable.revConCursor = GetMainCursor()
		OpenSprite(thisTable.revConCursor)
	end
end
function StartFingerCursor(thisTable)
	EndSelectCursor(thisTable)
	if thisTable.cursorSelect == 0 then
		thisTable.cursorSelect = GetFingetCursor()
		OpenSprite(thisTable.cursorSelect)
	end
end
function StartHandCursor(thisTable)
	EndSelectCursor(thisTable)
	if thisTable.cursorSelect == 0 then
		thisTable.cursorSelect = GetHandCursor()
		OpenSprite(thisTable.cursorSelect)
	end
end
function StartGrabCursor(thisTable)
	EndSelectCursor(thisTable)
	if thisTable.cursorSelect == 0 then
		thisTable.cursorSelect = GetGrabCursor()
		OpenSprite(thisTable.cursorSelect)
	end
end
local pulseCount = 180
local pulseRate = 180 / (GetFramesPerSecond() * 4)
local pulseAdd = false
function UpdatePulse()
	if pulseAdd then
		pulseCount = pulseCount + pulseRate
	else
		pulseCount = pulseCount - pulseRate
	end
	if 100 < pulseCount then
		pulseAdd = false
	end
	if pulseCount < 0 then
		pulseAdd = true
	end
	return cos(pulseCount) * 127.5 + 127.5
end
NameUndoBuffer = ""
function print(t)
	DebugOut(t)
end
DebugOut("Global ticked ***")
function GlobalEnd()
end
