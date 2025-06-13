function Backgrounds(owner)
end
local bgTexWidth = 928
local bgStartPos = -127
local bg1x = bgStartPos
function bg1pos()
	return bg1x - bgTexWidth, 0
end
function bg2pos()
	return bg1x, 0
end
function bgposUpdate(rate)
	bg1x = bg1x + rate
	if bg1x >= bgTexWidth + bgStartPos then
		bg1x = bgStartPos
	end
end
local getrate = function(val)
	return 1 / GetFramesPerSecond() * 30 * val
end
local bg3p = {
	{
		x = 640,
		y = 20,
		rate = getrate(0.4),
		limitx = 640,
		limity = 336
	},
	{
		x = 800,
		y = 240,
		rate = getrate(0.45),
		limitx = 800,
		limity = 160
	},
	{
		x = 0,
		y = 300,
		rate = getrate(0.6),
		limitx = 700,
		limity = 29
	},
	{
		x = 0,
		y = 340,
		rate = getrate(0.3),
		limitx = 710,
		limity = 48
	},
	{
		x = 500,
		y = 80,
		rate = getrate(1.4),
		limitx = 1500,
		limity = 48
	},
	{
		x = 1000,
		y = 180,
		rate = getrate(1.7),
		limitx = 1500,
		limity = 48
	},
	{
		x = 1500,
		y = 280,
		rate = getrate(1.1),
		limitx = 1500,
		limity = 48
	},
	{
		x = -750,
		y = 60,
		rate = getrate(0.55),
		limitx = 750,
		limity = 240
	},
	{
		x = -250,
		y = 40,
		rate = getrate(0.55),
		limitx = 750,
		limity = 240
	},
	{
		x = 0,
		y = 70,
		rate = getrate(0.55),
		limitx = 750,
		limity = 240
	},
	{
		x = 250,
		y = 50,
		rate = getrate(0.55),
		limitx = 750,
		limity = 320
	},
	{
		x = 750,
		y = 20,
		rate = getrate(0.55),
		limitx = 750,
		limity = 320
	},
	{
		x = 0,
		y = 80,
		rate = getrate(0.7),
		limitx = 650,
		limity = 112
	},
	{
		x = 60,
		y = 110,
		rate = getrate(0.73),
		limitx = 670,
		limity = 112
	},
	{
		x = 120,
		y = 140,
		rate = getrate(0.76),
		limitx = 690,
		limity = 112
	},
	{
		x = 180,
		y = 170,
		rate = getrate(0.79),
		limitx = 710,
		limity = 112
	},
	{
		x = 240,
		y = 200,
		rate = getrate(0.81),
		limitx = 730,
		limity = 112
	},
	{
		x = 0,
		y = 90,
		rate = getrate(0.85),
		limitx = 650,
		limity = 48
	},
	{
		x = 60,
		y = 120,
		rate = getrate(0.86),
		limitx = 670,
		limity = 48
	},
	{
		x = 120,
		y = 150,
		rate = getrate(0.87),
		limitx = 690,
		limity = 48
	},
	{
		x = 180,
		y = 180,
		rate = getrate(0.88),
		limitx = 710,
		limity = 48
	},
	{
		x = 240,
		y = 210,
		rate = getrate(0.9),
		limitx = 730,
		limity = 48
	},
	{
		x = 250,
		y = 80,
		rate = getrate(1.2),
		limitx = 750,
		limity = 80
	},
	{
		x = 250,
		y = 50,
		rate = getrate(0.65),
		limitx = 750,
		limity = 240
	},
	{
		x = 750,
		y = 20,
		rate = getrate(0.67),
		limitx = 750,
		limity = 379
	},
	{
		x = 15,
		y = 80,
		rate = getrate(0.75),
		limitx = 650,
		limity = 56
	},
	{
		x = 75,
		y = 110,
		rate = getrate(0.78),
		limitx = 670,
		limity = 64
	},
	{
		x = 135,
		y = 140,
		rate = getrate(0.82),
		limitx = 690,
		limity = 56
	},
	{
		x = 195,
		y = 170,
		rate = getrate(0.87),
		limitx = 710,
		limity = 56
	},
	{
		x = 255,
		y = 200,
		rate = getrate(0.91),
		limitx = 730,
		limity = 48
	}
}
function bg3pos(idx)
	local vars = bg3p[idx]
	vars.x = vars.x - vars.rate
	if vars.x < -vars.limitx then
		vars.x = vars.limitx
		vars.y = GetRandom(22, 379 - vars.limity)
	end
	return vars.x, vars.y
end
local bg3a = {
	{
		rate = 5,
		offset = 0,
		amp = 1024
	},
	{
		rate = 5,
		offset = 2000,
		amp = 512
	},
	{
		rate = 5,
		offset = 1000,
		amp = 1524
	},
	{
		rate = 5,
		offset = 150,
		amp = 256
	},
	{
		rate = 5,
		offset = 230,
		amp = 1024
	},
	{
		rate = 5,
		offset = 360,
		amp = 1024
	},
	{
		rate = 5,
		offset = 430,
		amp = 1024
	},
	{
		rate = 6,
		offset = 1000,
		amp = 2000
	},
	{
		rate = 6,
		offset = 1070,
		amp = 2000
	},
	{
		rate = 6,
		offset = 1140,
		amp = 2000
	},
	{
		rate = 6,
		offset = 1210,
		amp = 2000
	},
	{
		rate = 6,
		offset = 1280,
		amp = 2000
	},
	{
		rate = 7,
		offset = 360 / 5 * 0,
		amp = 120
	},
	{
		rate = 7,
		offset = 360 / 5 * 1,
		amp = 120
	},
	{
		rate = 7,
		offset = 360 / 5 * 2,
		amp = 120
	},
	{
		rate = 7,
		offset = 360 / 5 * 3,
		amp = 120
	},
	{
		rate = 7,
		offset = 360 / 5 * 4,
		amp = 120
	},
	{
		rate = 5,
		offset = 10,
		amp = 1024
	},
	{
		rate = 5,
		offset = 40,
		amp = 1024
	},
	{
		rate = 5,
		offset = 80,
		amp = 1024
	},
	{
		rate = 5,
		offset = 110,
		amp = 1024
	},
	{
		rate = 5,
		offset = 150,
		amp = 1024
	},
	{
		rate = 6,
		offset = 920,
		amp = 2000
	},
	{
		rate = 6,
		offset = 1210,
		amp = 2000
	},
	{
		rate = 6,
		offset = 1280,
		amp = 2000
	},
	{
		rate = 8,
		offset = 360 / 5 * 0,
		amp = 220
	},
	{
		rate = 8,
		offset = 360 / 5 * 1,
		amp = 220
	},
	{
		rate = 8,
		offset = 360 / 5 * 2,
		amp = 220
	},
	{
		rate = 8,
		offset = 360 / 5 * 3,
		amp = 220
	},
	{
		rate = 8,
		offset = 360 / 5 * 4,
		amp = 220
	}
}
function bg3colour(idx)
	local vars = bg3a[idx]
	local i = sin((GetTime() + vars.offset) * vars.rate * 2) * vars.amp
	if 255 < i then
		i = 255
	elseif i < 0 then
		i = 0
	end
	return i
end
function RotY(param)
	return GetTime() * param
end
function EndBackgroundsTable()
	DebugOut("Backgrounds ticked ***")
end
