function Game(owner)
	local tableData = {}
	tableData.gridColour = {
		255,
		0,
		255,
		180
	}
	tableData.revConCursor = GetMainCursor()
	local grade = 0
	local quit = false
	function tableData.bDefeat()
		SetMissionComplete(constant.MISSIONOVER_LOSE, 0, 0, 0, 0)
	end
	local testMP = false
	function tableData.bVictory()
		if quit then
			if TestMissionStatus(GAMESTATUS.TRAINING) then
				SetMissionStatus(GAMESTATUS.QUIT + GAMESTATUS.TRAINING)
			elseif TestMissionStatus(GAMESTATUS.PROLOGUE) then
				SetMissionStatus(GAMESTATUS.QUIT + GAMESTATUS.PROLOGUE)
			else
				SetMissionStatus(GAMESTATUS.QUIT)
			end
			RunLevel(0)
		elseif testMP then
			SetMissionStatus(GAMESTATUS.MPWIN)
			SetCurrentLevel(28)
			RunLevel(0)
		else
			local speed = rint(GetRandom(100))
			local power = rint(GetRandom(100))
			local tech = rint(GetRandom(100))
			if grade == 0 then
				grade = rint(GetRandom(GRADE.B - 1)) + 1
			end
			SetMissionComplete(constant.MISSIONOVER_PLAYER1_WINS, speed, power, tech, grade)
		end
	end
	function tableData.setS()
		grade = GRADE.S
	end
	function tableData.setA()
		DebugOut("setA connected!")
		grade = GRADE.A
	end
	function tableData.onDown()
		quit = true
	end
	function GetGamePage()
		return tableData
	end
	DebugOut("Game ticked ***")
end
