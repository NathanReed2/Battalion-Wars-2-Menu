function SpriteTravel(owner)
end
local radius = 195
function SpriteTravelPos(speed, offset)
	local a = speed * GetTime() + offset
	return sin(a) * (radius * 1.1) + 320, cos(a) * radius + 240
end
function SpriteTravelRot(speed, offset)
	local a = speed * GetTime() + offset
	return a + 180
end
function iconSelect()
end
function iconDeselect()
end
function iconShootColour(id)
	return 255
end
function shootIcon(id)
end
function SpriteTravelEnd()
end
