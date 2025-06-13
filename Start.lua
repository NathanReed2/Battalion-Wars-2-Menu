function Start(owner)
	local haveAttractMode = true
	local tableData = {}
	local revConCursor = GetMainCursor()
	local revConCrosshair = GetCrosshairCursor()
	tableData.revConCursor = revConCursor
	local controllerTimeout = GetFramesPerSecond() * 60
	local controllerTimeoutCount = 0
	local bAttractExiting = false
	local numIcons = 11
	local iconFadeInRate = GetFramesPerSecond() * 0.2
	local cursorLastX = 0
	local cursorLastY = 0
	local explosion = 0
	local explosionSound = 0
	local allDeadJingle = 0
	local allAliveJingle = 0
	local bAllDead = false
	local allDeadCount = 0
	local iconDeadTime = GetFramesPerSecond() * 3
	local allDeadTimeout = 2
	local getExplosion = function()
		return GUI_Custom_Widget.Explosion_Effect
	end
	local getExplosionSound = function()
		return GUI_Sound.Icon_Explode_SFX
	end
	local getJingle = function()
		return GUI_Sound.Icons_All_Dead_Jingle
	end
	local getJingle2 = function()
		return GUI_Sound.Icons_All_Alive_Jingle
	end
	local iconTable = {
		{
			false,
			255,
			0
		},
		{
			false,
			255,
			0
		},
		{
			false,
			255,
			0
		},
		{
			false,
			255,
			0
		},
		{
			false,
			255,
			0
		},
		{
			false,
			255,
			0
		},
		{
			false,
			255,
			0
		},
		{
			false,
			255,
			0
		},
		{
			false,
			255,
			0
		},
		{
			false,
			255,
			0
		},
		{
			false,
			255,
			0
		},
		{
			false,
			255,
			0
		},
		{
			false,
			255,
			0
		}
	}
	function tableData.iconSelect(id)
		if iconTable[id][1] == false then
			tableData.revConCursor = revConCrosshair
		end
	end
	function tableData.iconDeselect()
		tableData.revConCursor = revConCursor
	end
	function tableData.iconShootColour(id)
		return iconTable[id][2]
	end
	function tableData.shootIcon(id)
		controllerTimeoutCount = 0
		if iconTable[id][1] == false then
			tableData.revConCursor = revConCursor
			iconTable[id][1] = true
			iconTable[id][2] = 0
			iconTable[id][3] = 0
			if explosion ~= 0 then
				StopWidget(explosion)
			else
				explosion = getExplosion()
			end
			cursorLastX, cursorLastY = GetCursorPosition()
			if GetScreenRatio() == 1 then
				cursorLastX = cursorLastX - 40
			end
			StartWidget(tableData, explosion, false)
			if explosionSound ~= 0 then
				StopWidget(explosionSound)
			else
				explosionSound = getExplosionSound()
			end
			StartWidget(tableData, explosionSound, false)
		end
	end
	local function resetIcon(id)
		local iconData = iconTable[id]
		iconData[1] = false
		iconData[2] = 255
		iconData[3] = 0
	end
	local function resetAllIcons()
		for i = 1, numIcons do
			resetIcon(i)
		end
	end
	local function updateIcons()
		bAllDead = true
		for i = 1, numIcons do
			local iconData = iconTable[i]
			if iconData[1] then
				if iconData[3] < iconDeadTime then
					iconData[3] = iconData[3] + 1
				else
					iconData[1] = false
				end
			else
				bAllDead = false
				allDeadCount = 0
				if iconData[2] < 255 then
					iconData[2] = iconData[2] + iconFadeInRate
				end
				if iconData[2] > 255 then
					iconData[2] = 255
				end
			end
		end
		if bAllDead then
			if allDeadCount == 0 then
				if allDeadJingle ~= 0 then
					StopWidget(allDeadJingle)
					allDeadJingle = 0
				end
				allDeadJingle = getJingle()
				StartWidget(tableData, allDeadJingle, false)
			end
			if allDeadCount < allDeadTimeout then
				for i = 1, numIcons do
					iconTable[i][1] = true
					iconTable[i][2] = 0
					iconTable[i][3] = 0
				end
			elseif allDeadCount == allDeadTimeout + iconDeadTime - 1 then
				if allAliveJingle ~= 0 then
					StopWidget(allAliveJingle)
					allAliveJingle = 0
				end
				allAliveJingle = getJingle2()
				StartWidget(tableData, allAliveJingle, false)
			end
			allDeadCount = allDeadCount + 1
		end
	end
	function tableData.explosionEffectPos(xOff, yOff)
		return cursorLastX + xOff, cursorLastY + yOff
	end
	function tableData.getVersion()
		return GetVersionStr()
	end
	function tableData.gotoMain()
		PushPageStack("LoadCampaignData")
	end
	function tableData.testNANDDialog()
		if BuildType() ~= Build.Final then
			PushPageStack("LoadMPData")
		end
	end
	function tableData.Open()
		EnableControllerErrorMessages(not haveAttractMode)
		controllerTimeoutCount = 0
		if bAttractExiting then
			bAttractExiting = false
			initFadeIn()
			SetMusicVolume(1, 0.5)
		else
			initFadeFullOn()
		end
		if PlayLogoAnim then
			if not IsVideoFinished() then
				PlayVideo(VIDEO.OFF, "BWii_Intro", 0)
			end
			PlayLogoAnim = false
		end
		tableData.revConCursor = revConCursor
		OpenSprite(revConCrosshair)
		bAllDead = false
	end
	function tableData.Update()
		updateIcons()
		if haveAttractMode then
			if not bAttractExiting then
				if controllerTimeoutCount > controllerTimeout then
					bAttractExiting = true
					initFadeOut()
					SetMusicVolume(0, 0.5)
				else
					PollTitleMusicLoop()
					controllerTimeoutCount = controllerTimeoutCount + 1
				end
			elseif bFadeOutDone() then
				PushPageStack("Attract")
			end
		end
		updateFadeColour(tableData)
	end
	function tableData.Close()
		tableData.revConCursor = revConCursor
		resetAllIcons()
		if explosion ~= 0 then
			StopWidget(explosion)
			explosion = 0
		end
		if explosionSound ~= 0 then
			StopWidget(explosionSound)
			explosionSound = 0
		end
		if allDeadJingle ~= 0 then
			StopWidget(allDeadJingle)
			allDeadJingle = 0
		end
		if allAliveJingle ~= 0 then
			StopWidget(allAliveJingle)
			allAliveJingle = 0
		end
		if bAttractExiting then
			StopFEMusic()
		end
		controllerTimeoutCount = 0
	end
	function GetStartPage()
		return tableData
	end
	DebugOut("Start ticked ***")
end
