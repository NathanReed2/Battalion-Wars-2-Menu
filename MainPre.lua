function MainPre(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	tableData.cursorSelect = GetFingetCursor()
	local fadeCount = 180
	local fadeRate = 180 / (GetFramesPerSecond() * 1.5)
	local fadeScale = 3
	local bFadeIn = true
	function MainPreForwards(flag)
		bFadeIn = flag
	end
	local function updateAlpha()
		if bFadeIn then
			fadeCount = fadeCount - fadeRate * fadeScale
		else
			fadeCount = fadeCount + fadeRate * fadeScale
		end
	end
	local function checkExit()
		if bFadeIn and fadeCount < 0 then
			fadeCount = 0
			PushPageStack("Main")
		elseif not bFadeIn and 180 < fadeCount then
			fadeCount = 180
			PopPageStack()
		end
	end
	function tableData.trapFilterCol()
		return 255
	end
	function tableData.gotoMap(id)
	end
	function tableData.gotoGlobeSelect()
	end
	function tableData.popThrice()
	end
	local missionStatsText = {}
	function tableData.getSlotDetails(id)
		return missionStatsText[id]
	end
	function tableData.setUserSelectedSlot(id)
	end
	local slotLabels = {
		StringID.A,
		StringID.B,
		StringID.C
	}
	local numSPLevels = 20
	local function setSlotStatsText(id)
		SetSelectedSlot(id)
		local levelsDone = GetLevelsDone()
		if levelsDone > numSPLevels then
			levelsDone = numSPLevels
		end
		local percent = 100 / numSPLevels * levelsDone
		local percent1 = rint(percent)
		local percent10 = rint((percent - percent1) * 10) / 10
		percent = percent1 + percent10
		local name = GetProfileName(id)
		if name == "" then
			name = GetString(StringID.Save) .. " " .. GetString(slotLabels[id])
		end
		if GetSlotTime(id - 1) == 0 then
			missionStatsText[id] = name .. "\\n" .. percent .. "%"
		else
			missionStatsText[id] = name .. "\\n" .. percent .. "%"
		end
		if 0 < SelectedSlot then
			SetSelectedSlot(SelectedSlot)
		end
	end
	function tableData.faderColour(scale)
		return 255 - (cos(fadeCount) * 127.5 + 127.5)
	end
	function tableData.faderColourReverse(scale)
		return cos(fadeCount) * 127.5 + 127.5
	end
	function tableData.gotoSave()
	end
	function tableData.gotoMP()
	end
	function tableData.gotoGO()
	end
	function tableData.gotoExtras()
	end
	function tableData.Open()
		DoUnlockFlags()
		if bFadeIn then
			fadeCount = 180
		else
			fadeCount = 0
		end
		for id = 1, 3 do
			setSlotStatsText(id)
		end
	end
	function tableData.Update()
		pollTitleLoop()
		updateAlpha()
		checkExit()
	end
	function tableData.Close()
		if bFadeIn then
			bFadeIn = false
		else
			bFadeIn = true
		end
	end
	function GetMainPrePage()
		return tableData
	end
	DebugOut("MainPre page ticked ***")
end
