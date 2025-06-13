function Message(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	local bTesting = false
	local pageStatus = 0
	local messageFadeOut = 1
	local messageDone = 2
	local rankFadeIn = 3
	local rankFadeDone = 4
	local rankFadeOut = 5
	local rankDone = 6
	local unlockFadeIn = 7
	local unlockFadeDone = 8
	local unlockFadeOut = 9
	local unlockDone = 10
	local pageDone = 11
	local rankStatus = 0
	local rankFadeCount = 0
	local level = 0
	local gameType = 0
	local unlockString = 0
	local unlockFadeCount = 0
	local bRankChange = false
	local bUnlock = false
	local messageFadeCount = 255
	function tableData.StringMessage()
		local gameType = GetLevelGameType(GetCurrentLevel())
		if IQuit() then
			if gameType == GAMETYPE.Coop then
				return StringID.IQuitCoop
			else
				return StringID.IQuit
			end
		elseif OtherPlayerQuit() then
			if gameType == GAMETYPE.Coop then
				return StringID.OtherPlayerQuitCoop
			else
				return StringID.OtherPlayerQuit
			end
		else
			return StringID.ConnectionLost
		end
	end
	function tableData.StringOK()
		return StringID.OK
	end
	function tableData.onMessageOK()
		if pageStatus < messageFadeOut then
			pageStatus = messageFadeOut
		end
	end
	function tableData.bOKActive()
		return pageStatus == 0 or pageStatus == pageDone
	end
	local function checkQuitPage()
		if pageStatus == messageDone and not bRankChange and not bUnlock then
			PopPageStack()
		end
		if pageStatus == rankDone and not bUnlock then
			PopPageStack()
		end
		if pageStatus == unlockDone then
			PopPageStack()
		end
	end
	local function updateMessageFade()
		if pageStatus == messageFadeOut and 0 < messageFadeCount then
			messageFadeCount = messageFadeCount - 5
			if messageFadeCount <= 0 then
				pageStatus = messageDone
				messageFadeCount = 0
				checkQuitPage()
			end
		end
	end
	function tableData.messageAlpha()
		return messageFadeCount
	end
	local rankTitles = {
		StringID.RankIncrease,
		StringID.RankDecrease
	}
	local rankMessage = {
		StringID.Promoted,
		StringID.Demoted
	}
	function tableData.getPromotionTitle()
		return rankTitles[rankStatus]
	end
	function tableData.getPromotion()
		return rankMessage[rankStatus]
	end
	function tableData.isPromotePanelActive()
		return rankStatus ~= 0
	end
	local function updatePromotionFade()
		if pageStatus == rankFadeIn then
			if rankFadeCount < 255 then
				rankFadeCount = rankFadeCount + 5
				if 255 <= rankFadeCount then
					pageStatus = rankFadeDone
					rankFadeCount = 255
				end
			end
		elseif pageStatus == rankFadeOut and 0 < rankFadeCount then
			rankFadeCount = rankFadeCount - 5
			if rankFadeCount <= 0 then
				pageStatus = rankDone
				rankFadeCount = 0
				checkQuitPage()
			end
		end
	end
	function tableData.getPromoteFade()
		return rankFadeCount
	end
	local function checkRankChange()
		if GetMPRankPromoted() then
			rankStatus = 1
			bRankChange = true
		elseif GetMPRankDemoted() then
			rankStatus = 2
			bRankChange = true
		else
			rankStatus = 0
			bRankChange = false
			if bTesting then
				rankStatus = 1
				bRankChange = true
			end
		end
		return bRankChange
	end
	local function getUnlockString()
		if GetMPMapUnlocked() then
			if gameType == GAMETYPE.Skirmish then
				unlockString = StringID.UnlockSkirmishMap
			elseif gameType == GAMETYPE.Assault then
				unlockString = StringID.UnlockAssaultMap
			elseif gameType == GAMETYPE.Coop then
				unlockString = StringID.UnlockCoopMap
			end
		end
		if bTesting then
			unlockString = StringID.UnlockAssaultMap
		end
		return unlockString ~= 0
	end
	function tableData.getUnlockText()
		return unlockString
	end
	local function updateUnlockFade()
		if pageStatus == unlockFadeIn then
			if unlockFadeCount < 255 then
				unlockFadeCount = unlockFadeCount + 5
				if 255 <= unlockFadeCount then
					pageStatus = unlockFadeDone
					unlockFadeCount = 255
				end
			end
		elseif pageStatus == unlockFadeOut and 0 < unlockFadeCount then
			unlockFadeCount = unlockFadeCount - 5
			if unlockFadeCount <= 0 then
				pageStatus = unlockDone
				unlockFadeCount = 0
				checkQuitPage()
			end
		end
	end
	function tableData.panelFade()
		return unlockFadeCount
	end
	function tableData.UpdatePulse()
		if pageStatus == rankFadeDone or pageStatus == unlockFadeDone then
			return UpdatePulse()
		end
		return 0
	end
	function tableData.onActivate()
		if pageStatus == rankFadeDone then
			pageStatus = rankFadeOut
		elseif pageStatus == unlockFadeDone then
			pageStatus = unlockFadeOut
		end
	end
	function tableData.bBackActive()
		if not bRankChange and not bUnlock then
			return true
		end
		return pageStatus == pageDone
	end
	function tableData.PopPageStack()
		if pageStatus == 0 and not bRankChange and not bUnlock then
			PopPageStack()
		end
		if pageStatus == pageDone then
			PopPageStack()
		end
	end
	function tableData.Open()
		pageStatus = 0
		bRankChange = false
		rankStatus = 0
		rankFadeCount = 0
		unlockString = 0
		unlockFadeCount = 0
		level = GetCurrentLevel()
		gameType = GetLevelGameType(level)
		bRankChange = checkRankChange()
		bUnlock = getUnlockString()
	end
	function tableData.Update()
		PollMapMusicLoop()
		if pageStatus == messageDone then
			if bRankChange then
				pageStatus = rankFadeIn
			else
				pageStatus = rankDone
			end
		elseif pageStatus == rankDone then
			if bUnlock then
				pageStatus = unlockFadeIn
			else
				pageStatus = unlockDone
			end
		elseif pageStatus == unlockDone then
			pageStatus = pageDone
		end
		updateMessageFade()
		updatePromotionFade()
		updateUnlockFade()
	end
	function tableData.Close()
	end
	function GetMessagePage()
		return tableData
	end
	DebugOut("Message ticked ***")
end
