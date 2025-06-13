function GlobeSelect(owner)
end
local globeOrtnLatitude = 10
local globeOrtnLongitude = 355
local globeOrtnMtx = {
	{
		1,
		0,
		0,
		0
	},
	{
		0,
		1,
		0,
		0
	},
	{
		0,
		0,
		1,
		0
	},
	{
		0,
		0,
		0,
		1
	}
}
local globeSpinLongitudeVel = 0
local globeSpinLatitudeVel = 0
local globeVelWeight = 1
local globeSpinMaxLatitudeDelta = 45
local globeFrameTime = 1 / GetFramesPerSecond()
local globeMaxAngularLatitudeVel = 180
local globeMaxAngularLongitudeVel = 1260
local globeSpinLatitudeDecel = 400
local globeSpinLongitudeDecel = 540
local globeSpinLatitudeSlowBoundarySize = 8
local globeGrabbed = false
local globeHeld = false
local globeGrabLatitude = 0
local globeGrabLongitude = 0
local globeGrabMtx = {
	{
		1,
		0,
		0,
		0
	},
	{
		0,
		1,
		0,
		0
	},
	{
		0,
		0,
		1,
		0
	},
	{
		0,
		0,
		0,
		1
	}
}
local globeButtonActive = false
GlobeHasTarget = false
local globeTargetTime = 0
local globeTargetProgress = 0
local globeTargetLatA, globeTargetLatB, globeTargetLatC, globeTargetLatD, globeTargetLonA, globeTargetLonB, globeTargetLonC, globeTargetLonD
local globeX = 0
local globeY = 0
local globeZStart = 95.7
local globeZ = globeZStart
local globeModelRadius = 57.52 / 2
local globeMaxClickY = 23.91
local globeGrabbedOutside = false
local globeGrabbedOutsideLonX = 0.5
local globeGrabbedOutsideLatY = -0.25
local ScreenX = 0
local ScreenY = 0
local LastScreenX = 0
local LastScreenY = 0
local pressedScreenX = 0
local pressedScreenY = 0
local bGlobeSelected = false
local canSelectCampaignCount = 0
local canSelectCampaignCountTimeout = GetFramesPerSecond() * 0.2
local bCanSelectCampaign = false
local Continent = 1
local moveDistance = 500
local spinSound = 0
local targetList = {
	{17, 2},
	{-10, 96},
	{32, 232},
	{-11, 279.7},
	{-13, 48.5}
}
local GlobeSelectIsNullVector = function(x, y, z)
	return x + y + z == 0
end
function GlobeSelectGetOrientation()
	return globeOrtnMtx
end
function GlobeSelectGetGlobeX()
	return globeX
end
function GlobeSelectGetGlobeY()
	return globeY
end
function GlobeSelectGetGlobeZ()
	return globeZ
end
function GlobeSelectRemapAngle360(angle)
	angle = mod(angle, 360)
	if angle < 0 then
		angle = angle + 360
	end
	return angle
end
function GlobeSetTarget(idx)
	if idx < 1 or 5 < idx then
		return
	end
	local lat = targetList[idx][1]
	local lon = targetList[idx][2]
	if lat > globeSpinMaxLatitudeDelta then
		lat = globeSpinMaxLatitudeDelta
	elseif lat < -globeSpinMaxLatitudeDelta then
		lat = -globeSpinMaxLatitudeDelta
	end
	globeOrtnLatitude = lat
	globeOrtnLongitude = lon
	GlobeLatLonToOrientationMatrix(globeOrtnMtx, globeOrtnLatitude, globeOrtnLongitude)
end
function GlobeSelectTarget(idx)
	if idx < 1 or 5 < idx then
		return
	end
	local lat = targetList[idx][1]
	local lon = targetList[idx][2]
	if lat > globeSpinMaxLatitudeDelta then
		lat = globeSpinMaxLatitudeDelta
	elseif lat < -globeSpinMaxLatitudeDelta then
		lat = -globeSpinMaxLatitudeDelta
	end
	local dlat = lat - globeOrtnLatitude
	local dlon = mod(lon - globeOrtnLongitude, 360)
	if 180 < dlon then
		dlon = dlon - 360
	elseif dlon < -180 then
		dlon = dlon + 360
	end
	globeOrtnLongitude = lon - dlon
	globeTargetTime = sqrt(dlat * dlat + dlon * dlon) / 80
	if globeTargetTime < 0.001 then
		GlobeHasTarget = false
		globeOrtnLatitude = lat
		globeOrtnLongitude = lon
		globeSpinLatitudeVel = 0
		globeSpinLongitudeVel = 0
		GlobeLatLonToOrientationMatrix(globeOrtnMtx, globeOrtnLatitude, globeOrtnLongitude)
		return
	end
	if dlat ~= 0 then
		local T = globeTargetTime
		globeTargetLatD = globeOrtnLatitude
		globeTargetLatC = globeSpinLatitudeVel
		globeTargetLatA = globeTargetLatC / (T * T) - 2 * (lat - globeTargetLatD) / (T * T * T)
		globeTargetLatB = -2 * globeTargetLatC / T + 3 * (lat - globeTargetLatD) / (T * T)
	else
		globeTargetLatD = globeOrtnLatitude
		globeTargetLatC = 0
		globeTargetLatB = 0
		globeTargetLatA = 0
	end
	if dlon ~= 0 then
		local T = globeTargetTime
		globeTargetLonD = globeOrtnLongitude
		globeTargetLonC = globeSpinLongitudeVel
		globeTargetLonA = globeTargetLonC / (T * T) - 2 * (lon - globeTargetLonD) / (T * T * T)
		globeTargetLonB = -2 * globeTargetLonC / T + 3 * (lon - globeTargetLonD) / (T * T)
	else
		globeTargetLonD = globeOrtnLongitude
		globeTargetLonC = 0
		globeTargetLonB = 0
		globeTargetLonA = 0
	end
	globeTargetProgress = 0
	globeSpinLatitudeVel = 0
	globeSpinLongitudeVel = 0
	GlobeHasTarget = true
end
function GlobeSelectTargetUpdate()
	if not GlobeHasTarget then
		return
	elseif globeTargetProgress >= globeTargetTime then
		GlobeHasTarget = false
		return
	end
	globeTargetProgress = globeTargetProgress + globeFrameTime
	if globeTargetProgress > globeTargetTime then
		globeTargetProgress = globeTargetTime
	end
	globeOrtnLongitude = globeTargetLonD + globeTargetProgress * (globeTargetLonC + globeTargetProgress * (globeTargetLonB + globeTargetProgress * globeTargetLonA))
	globeOrtnLatitude = globeTargetLatD + globeTargetProgress * (globeTargetLatC + globeTargetProgress * (globeTargetLatB + globeTargetProgress * globeTargetLatA))
	GlobeLatLonToOrientationMatrix(globeOrtnMtx, globeOrtnLatitude, globeOrtnLongitude)
end
function GlobeSelectUpdateSpinLatitude()
	local deltaLat = globeSpinLatitudeDecel * globeFrameTime
	if globeOrtnLatitude < -globeSpinMaxLatitudeDelta + globeSpinLatitudeSlowBoundarySize and globeSpinLatitudeVel < 0 then
		deltaLat = deltaLat * 2
	elseif globeOrtnLatitude > globeSpinMaxLatitudeDelta - globeSpinLatitudeSlowBoundarySize and 0 < globeSpinLatitudeVel then
		deltaLat = deltaLat * 2
	end
	if deltaLat > abs(globeSpinLatitudeVel) then
		globeSpinLatitudeVel = 0
	elseif 0 < globeSpinLatitudeVel then
		globeSpinLatitudeVel = globeSpinLatitudeVel - deltaLat
	else
		globeSpinLatitudeVel = globeSpinLatitudeVel + deltaLat
	end
	globeOrtnLatitude = globeOrtnLatitude + globeSpinLatitudeVel * globeFrameTime
	if globeOrtnLatitude < -globeSpinMaxLatitudeDelta then
		globeOrtnLatitude = -globeSpinMaxLatitudeDelta
		globeSpinLatitudeVel = 0
	elseif globeOrtnLatitude > globeSpinMaxLatitudeDelta then
		globeOrtnLatitude = globeSpinMaxLatitudeDelta
		globeSpinLatitudeVel = 0
	end
end
function GlobeSelectUpdateSpinLongitude()
	local deltaLon = globeSpinLongitudeDecel * globeFrameTime
	if deltaLon > abs(globeSpinLongitudeVel) then
		globeSpinLongitudeVel = 0
	elseif 0 < globeSpinLongitudeVel then
		globeSpinLongitudeVel = globeSpinLongitudeVel - deltaLon
	else
		globeSpinLongitudeVel = globeSpinLongitudeVel + deltaLon
	end
	globeOrtnLongitude = globeOrtnLongitude + globeSpinLongitudeVel * globeFrameTime
end
function lerp(a, b, f)
	return a + (b - a) * f
end
function clamp(r, a, b)
	if r < a then
		return a
	elseif b < r then
		return b
	end
	return r
end
function GlobeSelectUpdate()
	local regrab, lat, lon
	ScreenX, ScreenY = GetCursorPosition()
	local x, y, z = CalcGlobeInterection(ScreenX, ScreenY, globeX, globeY, globeZ, globeModelRadius)
	globeOrtnLongitude = GlobeSelectRemapAngle360(globeOrtnLongitude)
	if GlobeSelectIsNullVector(x, y, z) then
		bGlobeSelected = false
	else
		bGlobeSelected = true
	end
	if globeButtonActive then
		if bGlobeSelected then
			if not globeGrabbed then
				GlobeCalcClickedPos(x, y, z, globeOrtnMtx, globeGrabMtx)
			end
			globeGrabbedOutside = false
			globeGrabbed = true
		else
			globeGrabbed = false
			globeGrabbedOutside = true
		end
	end
	if globeButtonActive then
		lat, lon = globeOrtnLatitude, globeOrtnLongitude
		if globeGrabbed and abs(z) < 0.8 then
			lat, lon, regrab = GlobeSelectCalcTargetOrientation(globeGrabMtx, x, y, z, globeOrtnMtx, globeSpinMaxLatitudeDelta)
			local llat = globeOrtnLatitude + globeGrabbedOutsideLatY * (ScreenY - LastScreenY)
			local llon = globeOrtnLongitude + globeGrabbedOutsideLonX * (ScreenX - LastScreenX)
			if llat > globeSpinMaxLatitudeDelta then
				llat = globeSpinMaxLatitudeDelta
			elseif llat < -globeSpinMaxLatitudeDelta then
				llat = -globeSpinMaxLatitudeDelta
			end
			local f = clamp((0.8 - abs(z)) * 4, 0, 1)
			local londiff = abs(lon - llon)
			local londiffp = abs(lon - (llon + 360))
			local londiffm = abs(lon - (llon - 360))
			if londiff > londiffp then
				llon = llon + 360
			elseif londiff > londiffm then
				llon = llon - 360
			end
			lat = lerp(lat, llat, f)
			lon = lerp(lon, llon, f)
			GlobeLatLonToOrientationMatrix(globeOrtnMtx, lat, lon)
			GlobeCalcClickedPos(x, y, z, globeOrtnMtx, globeGrabMtx)
		elseif globeGrabbed then
			lat, lon, regrab = GlobeSelectCalcTargetOrientation(globeGrabMtx, x, y, z, globeOrtnMtx, globeSpinMaxLatitudeDelta)
			if regrab then
				GlobeCalcClickedPos(x, y, z, globeOrtnMtx, globeGrabMtx)
			end
		else
			lon = globeOrtnLongitude + globeGrabbedOutsideLonX * (ScreenX - LastScreenX)
			lat = globeOrtnLatitude + globeGrabbedOutsideLatY * (ScreenY - LastScreenY)
			if lat > globeSpinMaxLatitudeDelta then
				lat = globeSpinMaxLatitudeDelta
			elseif lat < -globeSpinMaxLatitudeDelta then
				lat = -globeSpinMaxLatitudeDelta
			end
			GlobeLatLonToOrientationMatrix(globeOrtnMtx, lat, lon)
		end
		local londiff = lon - globeOrtnLongitude
		local londiffn = londiff - 360
		local londiffp = londiff + 360
		if abs(londiffn) < abs(londiff) then
			londiff = londiffn
		elseif abs(londiffp) < abs(londiff) then
			londiff = londiffp
		end
		local frameLonVel = londiff / globeFrameTime
		local frameLatVel = (lat - globeOrtnLatitude) / globeFrameTime
		globeSpinLongitudeVel = lerp(globeSpinLongitudeVel, frameLonVel, globeVelWeight)
		globeSpinLatitudeVel = lerp(globeSpinLatitudeVel, frameLatVel, globeVelWeight)
		globeVelWeight = 0.45
		if abs(globeSpinLongitudeVel) > globeMaxAngularLongitudeVel then
			if globeSpinLongitudeVel < 0 then
				globeSpinLongitudeVel = -globeMaxAngularLongitudeVel
			else
				globeSpinLongitudeVel = globeMaxAngularLongitudeVel
			end
		end
		if abs(globeSpinLatitudeVel) > globeMaxAngularLatitudeVel then
			if globeSpinLatitudeVel < 0 then
				globeSpinLatitudeVel = -globeMaxAngularLatitudeVel
			else
				globeSpinLatitudeVel = globeMaxAngularLatitudeVel
			end
		end
		globeOrtnLatitude = lat
		globeOrtnLongitude = lon
	elseif GlobeHasTarget then
		GlobeSelectTargetUpdate()
	else
		GlobeSelectUpdateSpinLatitude()
		GlobeSelectUpdateSpinLongitude()
		GlobeLatLonToOrientationMatrix(globeOrtnMtx, globeOrtnLatitude, globeOrtnLongitude)
	end
	LastScreenX = ScreenX
	LastScreenY = ScreenY
	if bGlobeSelected then
		lat, lon = GlobeCalcClickedPos(x, y, z, globeOrtnMtx, globeGrabMtx)
		local continent = GlobePickRegionFromMap(lon, globeGrabMtx[3][2] * globeModelRadius / globeMaxClickY)
		if continent < 6 and 0 <= continent then
			Continent = continent
		end
	else
		Continent = 0
	end
end
function GlobeSelectOnActivate()
	globeButtonActive = true
	globeGrabbed = true
	globeHeld = false
	canSelectCampaignCount = 0
	bCanSelectCampaign = true
	pressedScreenX = ScreenX
	pressedScreenY = ScreenY
	if spinSound ~= 0 then
		StopWidget(spinSound)
		spinSound = 0
	end
end
function GlobeSelectedContinent()
	return Continent
end
function GlobeSetContinent(continent)
	Continent = continent
	globeButtonActive = false
	globeGrabbed = false
	globeGrabbedOutside = false
end
function GlobeSelectOnHeld()
	if not bCanSelectCampaign then
		return
	end
	if canSelectCampaignCount > canSelectCampaignCountTimeout then
		bCanSelectCampaign = false
		GlobeHasTarget = false
		globeVelWeight = 1
		globeHeld = true
	else
		canSelectCampaignCount = canSelectCampaignCount + 1
		local x = pressedScreenX - ScreenX
		local y = pressedScreenY - ScreenY
		local diff = x * x + y * y
		if diff > 36 * 36 then
			canSelectCampaignCount = canSelectCampaignCountTimeout + 1
		end
	end
end
local movieUnlockedMap = {
	{1, 5},
	{6, 8},
	{9, 12},
	{13, 15},
	{16, 19}
}
function GlobeSelectSpinPitch()
	return abs(globeSpinLongitudeVel) / 1000
end
function GlobeSelectGotoMap()
	if bCanSelectCampaign and 0 < Continent then
		SelectedCampaign = Continent
		if Continent == 1 and GetLevelsDone() == 0 then
			SelectedLevel = 1
			SetMissionStatus(GAMESTATUS.PLAY)
			PushPageStack("CutsceneIn")
		elseif GetLevelsDone() > CampaignActiveTable[Continent] then
			PushPageStack("MapPost")
		end
	elseif abs(globeSpinLongitudeVel) > 500 and canSelectCampaignCount > canSelectCampaignCountTimeout then
		spinSound = GUI_Sound.Globe_Spin_Sound
		StartWidget(0, spinSound, false)
	end
end
function GlobeSelectOnReleased()
	globeButtonActive = false
	globeGrabbed = false
	globeHeld = false
	globeGrabbedOutside = false
	GlobeSelectGotoMap()
end
function GlobeSelectInit()
	globeZ = globeZStart
	bCanSelectCampaign = false
	globeButtonActive = false
	globeGrabbed = false
	globeGrabbedOutside = false
end
function GlobeSelectConvertScreenToGlobeCoords(x, y)
	return 0, 0
end
function GlobeSelectConvertGlobeToScreenCoords(x, y)
	return 0, 0
end
function GlobeSelectConvertGlobeToMapCoords(globeX, globeY)
	return 0, 0
end
function GlobeSelectCalcScreenToRotationOffset(screenX, screenY)
	local ix, iy, iz = CalcGlobeInterection(screenX, screenY, globeX, globeY, globeZ, globeModelRadius)
	return ix, iy
end
function GetGlobeGrabbed()
	return globeHeld
end
DebugOut("GlobeSelect ticked ***")
function GlobeSelect_end()
end
