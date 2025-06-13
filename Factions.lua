function Factions(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	local nandDialog
	local bExiting = false
	function tableData.getFactionName()
		if SelectedFaction == 0 then
			return ""
		else
			return FactionNameTable[SelectedFaction]
		end
	end
	local saveCallback = function(status)
		SetGameSaveValid(SPSaveStatus, status)
		PopPageStack()
	end
	local function saveSeenFlags()
		nandDialog.Save(WriteSaveFile, saveCallback)
	end
	function tableData.gotoNextPage()
		if SelectedFaction ~= 0 and not bExiting then
			if AddFactionUnlockUnitsFlag(SelectedFaction) then
				SetTmpStore(1)
			end
			bExiting = true
			initFadeOut()
			SetMusicVolume(0, MusicFadeOutSecs)
		end
	end
	local gotoUnits = function()
		if IsUnlocked(SelectedFaction, UnlockUnits) then
			SetMissionStatus(GAMESTATUS.UNITS)
			SelectedLevel = SelectedFaction
			FrontendDone = true
			PageDone = true
		end
	end
	local panelAlpha = 0
	local panelAlphaRate = 64
	local panelOn = false
	function tableData.openRolloverInfo(factionID)
		if not bExiting then
			panelOn = true
			SelectedFaction = factionID
		end
	end
	function tableData.closeRolloverInfo()
		if not bExiting then
			panelOn = false
		end
	end
	function tableData.getPanelMapInfoAlpha()
		return panelAlpha
	end
	local function updatePanelAlpha()
		if panelOn then
			panelAlpha = panelAlpha + panelAlphaRate
		else
			panelAlpha = panelAlpha - panelAlphaRate
		end
		if 255 < panelAlpha then
			panelAlpha = 255
		elseif panelAlpha < 0 then
			panelAlpha = 0
		end
	end
	function tableData.getFactionUnlocked(faction)
		return IsUnlocked(faction, UnlockUnits)
	end
	function tableData.unlockedSEActive()
		return C1Unlocked(UnlockUnits)
	end
	function tableData.unlockedWFActive()
		return C2Unlocked(UnlockUnits)
	end
	function tableData.unlockedAIActive()
		return C3Unlocked(UnlockUnits)
	end
	function tableData.unlockedILActive()
		return C4Unlocked(UnlockUnits)
	end
	function tableData.unlockedTTActive()
		return C5Unlocked(UnlockUnits)
	end
	function tableData.unlockedXActive()
		return C6Unlocked(UnlockUnits)
	end
	function tableData.PopPageStack()
		if not bExiting then
			FactionPreForward(false)
			if GetTmpStore() == 1 then
				SetTmpStore(0)
				saveSeenFlags()
			else
				PopPageStack()
			end
		end
	end
	function tableData.Open()
		nandDialog = GetNANDDialog()
		nandDialog.Open()
		bExiting = false
		if TestMissionStatus(GAMESTATUS.UNITS) then
			SetMissionStatus(GAMESTATUS.NONE)
			DoUnlockFlags()
			initFadeIn()
		else
			initFadeFullOn()
		end
		panelAlpha = 0
		panelOn = false
		SelectedFaction = 0
	end
	function tableData.Update()
		updateFadeColour(tableData)
		PollTitleMusicLoop()
		updatePanelAlpha()
		if bExiting and bFadeOutDone() then
			gotoUnits()
		end
		nandDialog.Update()
	end
	function tableData.Close()
		nandDialog.Close()
	end
	function GetFactionsPage()
		return tableData
	end
	DebugOut("Factions ticked ***")
end
