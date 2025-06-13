function Unlock(owner)
	local tableData = {}
	local level = 0
	local gameType = 0
	function tableData.gotoMap()
		PushPageStack("Map")
	end
	local fadeCount = 180
	local fadeRate = 180 / (GetFramesPerSecond() * 1)
	local waitCount2 = 0
	local function updatePanelFade()
		if waitCount2 < 10 then
			waitCount2 = waitCount2 + 1
		else
			if 0 < fadeCount then
				fadeCount = fadeCount - fadeRate
			else
				fadeCount = fadeCount + fadeRate
			end
			if 180 < fadeCount then
				fadeCount = 180
			end
			if fadeCount < 0 then
				fadeCount = 0
			end
		end
	end
	function tableData.panelFade()
		return cos(fadeCount) * 127.5 + 127.5
	end
	local quickFadeCount = 180
	local quickFadeRate = 180 / (GetFramesPerSecond() * 0.1)
	local waitCount3 = 0
	local flareEffect = 0
	local function updateQuickFade()
		if waitCount3 < 10 then
			waitCount3 = waitCount3 + 1
		else
			if 0 < quickFadeCount then
				quickFadeCount = quickFadeCount - quickFadeRate
			else
				quickFadeCount = quickFadeCount + quickFadeRate
			end
			if 180 < quickFadeCount then
				quickFadeCount = 180
			end
			if quickFadeCount < 0 then
				quickFadeCount = 0
			end
		end
	end
	function tableData.quickFade()
		return cos(quickFadeCount) * 127.5 + 127.5
	end
	local unlockString = 1
	local function getUnlockString()
		if GetMPMapUnlocked() then
			if gameType == GAMETYPE.Skirmish then
				unlockString = StringID.UnlockSkirmishMap
			elseif gameType == GAMETYPE.Assault then
				unlockString = StringID.UnlockAssaultMap
			elseif gameType == GAMETYPE.Coop then
				unlockString = StringID.UnlockCoopMap
			end
		elseif StatsCampaign == 0 then
			unlockString = StringID.UnlockPrologue
		elseif UnlockedSP() then
			if UnlockedMPWithoutSP() then
				unlockString = StringID.UnlockLastSNoMP
			else
				unlockString = StringID.UnlockLastSAndMP
			end
		elseif GetCampaignUnlockLevel(StatsCampaign) == 3 then
			unlockString = StringID.UnlockS
		elseif GetCampaignUnlockLevel(StatsCampaign) == 2 then
			unlockString = StringID.UnlockA
		else
			unlockString = StringID.UnlockNothing
		end
	end
	function tableData.getUnlockText()
		return unlockString
	end
	function tableData.Open()
		level = GetCurrentLevel()
		gameType = GetLevelGameType(level)
		getUnlockString()
	end
	function tableData.Update()
		if not UnlockFlagsChanged() and not UnlockedCampaignFlag and not GetMPMapUnlocked() then
			PopPageStack()
			return
		end
		PollMapMusicLoop()
		updateQuickFade()
		updatePanelFade()
	end
	function tableData.Close()
		UnlockedCampaignFlag = false
		if CreditsLevelNext then
			SetMissionStatus(GAMESTATUS.ENDCREDITS)
			SelectedLevel = CreditsLevel
			FrontendDone = true
			PageDone = true
		end
	end
	function GetUnlockPage()
		return tableData
	end
	DebugOut("Unlock ticked ***")
end
