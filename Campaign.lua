function Campaign(owner)
end
SelectedCampaign = 0
HighlightedLevel = -1
FMVFileNameToPlay = ""
NewCampaign = false
StatsCampaign = 1
CampaignActiveTable = {
	-1,
	5,
	8,
	12,
	15,
	19
}
LevelCampaignMap = {
	1,
	1,
	1,
	1,
	1,
	2,
	2,
	2,
	3,
	3,
	3,
	3,
	4,
	4,
	4,
	5,
	5,
	5,
	5,
	5,
	5
}
function GetLevelCampaignMap(level)
	return LevelCampaignMap[level]
end
function InitCurrentSelectedCampaign()
	local initCampaignMap = {
		0,
		1,
		1,
		1,
		1,
		1,
		2,
		2,
		2,
		3,
		3,
		3,
		3,
		4,
		4,
		4,
		5,
		5,
		5,
		5,
		1,
		1,
		1,
		1,
		1
	}
	if 0 < SelectedLevel and SelectedLevel < 24 then
		SelectedCampaign = initCampaignMap[SelectedLevel]
	else
		SelectedCampaign = 1
	end
end
MissionPositionTable = {
	{
		{X = 92, Y = 209},
		{X = 213, Y = 148},
		{X = 229, Y = 273},
		{X = 420, Y = 196},
		{X = 515, Y = 252}
	},
	{
		{X = 142, Y = 270},
		{X = 242, Y = 176},
		{X = 510, Y = 221}
	},
	{
		{X = 146, Y = 274},
		{X = 240, Y = 232},
		{X = 346, Y = 279},
		{X = 420, Y = 198}
	},
	{
		{X = 191, Y = 276},
		{X = 298, Y = 230},
		{X = 428, Y = 159}
	},
	{
		{X = 207, Y = 271},
		{X = 424, Y = 259},
		{X = 414, Y = 164},
		{X = 297, Y = 150}
	}
}
FactionBGColours = {
	{
		192,
		231,
		255,
		255
	},
	{
		107,
		117,
		46,
		255
	},
	{
		168,
		137,
		93,
		255
	},
	{
		84,
		51,
		82,
		255
	},
	{
		122,
		23,
		18,
		255
	},
	{
		4,
		96,
		135,
		255
	}
}
CampaignBGColourMapping = {
	{1, 3},
	{2, 5},
	{3, 1},
	{4, 1},
	{5, 4}
}
function GetFactionIcon(id)
	local factionIcons = {
		GUI_Sprite.Mobility_Faction_S_Icon,
		GUI_Sprite.Mobility_Faction_WF_Icon,
		GUI_Sprite.Mobility_Faction_AI_Icon,
		GUI_Sprite.Mobility_Faction_IL_Icon,
		GUI_Sprite.Mobility_Faction_T_Icon,
		GUI_Sprite.Mobility_Faction_X_Icon
	}
	return factionIcons[id]
end
local getCOHeads = function(id, type)
	local table = {
		{
			GUI_Sprite.Mission_CO_Lei_Qo,
			GUI_Sprite.Mission_CO_Ferrok_E
		},
		{
			GUI_Sprite.Mission_CO_Lei_Qo,
			GUI_Sprite.Mission_CO_Windsor_E
		},
		{
			GUI_Sprite.Mission_CO_Aqira,
			GUI_Sprite.Mission_CO_Pierce_E
		},
		{
			GUI_Sprite.Mission_CO_Lei_Qo,
			GUI_Sprite.Mission_CO_Windsor_E
		},
		{
			GUI_Sprite.Mission_CO_Aqira,
			GUI_Sprite.Mission_CO_Windsor_E
		},
		{
			GUI_Sprite.Mission_CO_Aqira,
			GUI_Sprite.Mission_CO_Pierce_E
		},
		{
			GUI_Sprite.Mission_CO_Herman,
			GUI_Sprite.Mission_CO_Gorgi_E
		},
		{
			GUI_Sprite.Mission_CO_Herman,
			GUI_Sprite.Mission_CO_Gorgi_E
		},
		{
			GUI_Sprite.Mission_CO_Herman,
			GUI_Sprite.Mission_CO_Gorgi_E
		},
		{
			GUI_Sprite.Mission_CO_Pierce,
			GUI_Sprite.Mission_CO_Aqira_E
		},
		{
			GUI_Sprite.Mission_CO_Windsor,
			GUI_Sprite.Mission_CO_Aqira_E
		},
		{
			GUI_Sprite.Mission_CO_Windsor,
			GUI_Sprite.Mission_CO_Aqira_E
		},
		{
			GUI_Sprite.Mission_CO_Pierce,
			GUI_Sprite.Mission_CO_Aqira_E
		},
		{
			GUI_Sprite.Mission_CO_Ferrok,
			GUI_Sprite.Mission_CO_Qa_Len_E
		},
		{
			GUI_Sprite.Mission_CO_Ferrok,
			GUI_Sprite.Mission_CO_Qa_Len_E
		},
		{
			GUI_Sprite.Mission_CO_Ferrok,
			GUI_Sprite.Mission_CO_Qa_Len_E
		},
		{
			GUI_Sprite.Mission_CO_Nova,
			GUI_Sprite.Mission_CO_Ubel_E
		},
		{
			GUI_Sprite.Mission_CO_Nova,
			GUI_Sprite.Mission_CO_Vlad_E
		},
		{
			GUI_Sprite.Mission_CO_Nova,
			GUI_Sprite.Mission_CO_Ubel_E
		},
		{
			GUI_Sprite.Mission_CO_Nova,
			GUI_Sprite.Mission_CO_Vlad_E
		}
	}
	return table[id][type]
end
function LevelCOHeadFunction(id)
	return getCOHeads(id, 1)
end
function LevelCOHeadEnemy(id)
	return getCOHeads(id, 2)
end
local getLevelUnits = function(id, type)
	local table = {
		{0, 0},
		{
			GUI_Custom_Widget.Mission_Units_1_1,
			GUI_Custom_Widget.Mission_Units_1_1_E
		},
		{
			GUI_Custom_Widget.Mission_Units_1_2,
			GUI_Custom_Widget.Mission_Units_1_2_E
		},
		{
			GUI_Custom_Widget.Mission_Units_1_3,
			GUI_Custom_Widget.Mission_Units_1_3_E
		},
		{
			GUI_Custom_Widget.Mission_Units_1_4,
			GUI_Custom_Widget.Mission_Units_1_4_E
		},
		{
			GUI_Custom_Widget.Mission_Units_1_5,
			GUI_Custom_Widget.Mission_Units_1_5_E
		},
		{
			GUI_Custom_Widget.Mission_Units_2_1,
			GUI_Custom_Widget.Mission_Units_2_1_E
		},
		{
			GUI_Custom_Widget.Mission_Units_2_2,
			GUI_Custom_Widget.Mission_Units_2_2_E
		},
		{
			GUI_Custom_Widget.Mission_Units_2_3,
			GUI_Custom_Widget.Mission_Units_2_3_E
		},
		{
			GUI_Custom_Widget.Mission_Units_3_1,
			GUI_Custom_Widget.Mission_Units_3_1_E
		},
		{
			GUI_Custom_Widget.Mission_Units_3_2,
			GUI_Custom_Widget.Mission_Units_3_2_E
		},
		{
			GUI_Custom_Widget.Mission_Units_3_3,
			GUI_Custom_Widget.Mission_Units_3_3_E
		},
		{
			GUI_Custom_Widget.Mission_Units_3_4,
			GUI_Custom_Widget.Mission_Units_3_4_E
		},
		{
			GUI_Custom_Widget.Mission_Units_4_1,
			GUI_Custom_Widget.Mission_Units_4_1_E
		},
		{
			GUI_Custom_Widget.Mission_Units_4_2,
			GUI_Custom_Widget.Mission_Units_4_2_E
		},
		{
			GUI_Custom_Widget.Mission_Units_4_3,
			GUI_Custom_Widget.Mission_Units_4_3_E
		},
		{
			GUI_Custom_Widget.Mission_Units_5_1,
			GUI_Custom_Widget.Mission_Units_5_1_E
		},
		{
			GUI_Custom_Widget.Mission_Units_5_2,
			GUI_Custom_Widget.Mission_Units_5_2_E
		},
		{
			GUI_Custom_Widget.Mission_Units_5_3,
			GUI_Custom_Widget.Mission_Units_5_3_E
		},
		{
			GUI_Custom_Widget.Mission_Units_5_4,
			GUI_Custom_Widget.Mission_Units_5_4_E
		}
	}
	return table[id][type]
end
function LevelUnitsFunction(id)
	return getLevelUnits(id, 1)
end
function LevelUnitsEnemy(id)
	return getLevelUnits(id, 2)
end
BriefingDirectory = "Data/Audio/Voiceover/Mission_Briefs"
local levelBriefings = {
	"0_1.adp",
	"1_1.adp",
	"1_2.adp",
	"1_3.adp",
	"1_4.adp",
	"1_5.adp",
	"2_1.adp",
	"2_2.adp",
	"2_3.adp",
	"3_1.adp",
	"3_2.adp",
	"3_3.adp",
	"3_4.adp",
	"4_1.adp",
	"4_2.adp",
	"4_3.adp",
	"5_1.adp",
	"5_2.adp",
	"5_3.adp",
	"5_4.adp"
}
function LevelBriefing(id)
	return levelBriefings[id]
end
local campaignBriefings = {
	"c1.adp",
	"c2.adp",
	"c3.adp",
	"c4.adp",
	"c5.adp"
}
function CampaignBriefingFileName(campaign)
	return campaignBriefings[campaign]
end
local tttextTable = {
	327,
	328,
	349,
	326,
	329,
	347,
	346,
	378,
	377,
	330,
	350,
	364,
	331,
	348,
	380,
	326,
	366,
	351,
	381,
	363
}
local unitTTText = 0
function UnitToolTipTextStr()
	return tttextTable[unitTTText]
end
function GetUnitToolTip(id)
	unitTTText = id
	return GUI_Custom_Widget.ICON_ID_Tab
end
IconPosX = 0
function GetInfoIconPos(offset)
	local x = IconPosX * offset
	IconPosX = IconPosX + 1
	return x, 0
end
EnemyIconPosX = 0
function GetInfoEnemyIconPos(offset)
	local x = EnemyIconPosX * offset
	EnemyIconPosX = EnemyIconPosX + 1
	return x, 0
end
function ResetIconPos()
	IconPosX = 0
	EnemyIconPosX = 0
end
function GetIDTabPos(offset, modval)
	return offset + rint((GetCursorPosition() - offset + modval / 2) / modval) * modval, 0
end
IDTabColourMapping = 1
function GetIDTabCol()
	return FactionBGColours[IDTabColourMapping]
end
function GetFactionBGColour(faction)
	return FactionBGColours[faction]
end
function GetMissionToolTip()
	return GUI_Custom_Widget.Mission_tool_tip
end
local mSpeed = 0
local mPower = 0
local mTechnique = 0
local mGrade = 0
local mTotal = 0
local getBadge = function(id)
	local badges = {
		GUI_Texture.Previous_Grade_C,
		GUI_Texture.Previous_Grade_B,
		GUI_Texture.Previous_Grade_A,
		GUI_Texture.Previous_Grade_S
	}
	return badges[id]
end
local gradeBadge = 0
local function initStats()
	mSpeed, mPower, mTechnique, mGrade = GetStoredMissionData(HighlightedLevel)
	mTotal = (mSpeed + mPower + mTechnique) / 3
	if 0 < mGrade then
		gradeBadge = getBadge(mGrade)
	else
		gradeBadge = 0
	end
end
function GetPreviousGradeBadge()
	return gradeBadge
end
function GetPreviousGradeBadgeBG()
	return GUI_Texture.Campaign_Grade_BG
end
function GetSpeed()
	return "" .. rint(mSpeed) .. "%"
end
function GetPower()
	return "" .. rint(mPower) .. "%"
end
function GetTechnique()
	return "" .. rint(mTechnique) .. "%"
end
function GetTotal()
	return "" .. rint(mTotal) .. "%"
end
function SetHighlightedLevel(idx)
	HighlightedLevel = idx + 1
	SelectedLevel = HighlightedLevel
	initStats()
end
function ResetHighlightedLevel()
	HighlightedLevel = -1
	SelectedLevel = -1
	initStats()
end
function GetMissionName()
	if HighlightedLevel == -1 then
		return " "
	else
		return GetMissionNameStart() + HighlightedLevel - 1
	end
end
function GetMissionDescription()
	if HighlightedLevel == -1 then
		return " "
	else
		return GetMissionDescStart() + HighlightedLevel - 1
	end
end
function GetLevelActive(idx)
	if idx > GetLevelsDone() then
		return false
	else
		return true
	end
end
function GetButtonSet(idx)
	local speed, power, technique, grade = GetStoredMissionData(idx + 1)
	return grade
end
function RunCampaignLevel()
	if SelectedLevel ~= -1 then
		if not TestLevelCycle or BuildType() == Build.Final then
			TriggerFrameSave()
		end
		LoadCurrentMissionStats(SelectedLevel)
		RunLevel(SelectedLevel + NumFrontendLevels - 1)
	end
end
function getCampaignScore()
	return "100"
end
CampaignUnlockString = 0
local nextUnlockStringTable = {
	0,
	0,
	0,
	0,
	0
}
local function setNextUnlockStr(campaign)
	local stringTable = {
		StringID.AllARank,
		StringID.AllSRank,
		StringID.Completed
	}
	nextUnlockStringTable[campaign] = stringTable[GetCampaignUnlockLevel(campaign)]
end
function GetNextUnlockStr()
	if CampaignUnlockString < 0 or CampaignUnlockString > 5 then
		return StringID.NoString
	end
	return nextUnlockStringTable[CampaignUnlockString]
end
function SetNextUnlockStrings()
	for campaign = 1, 5 do
		setNextUnlockStr(campaign)
	end
end
function setCampaignS()
	SelectedCampaign = SolarEmpireID
	SetPageStack("CampaignS")
end
function setCampaignWF()
	SelectedCampaign = WesternFrontierID
	SetPageStack("CampaignWF")
end
function setCampaignAI()
	SelectedCampaign = AngloIslesID
	SetPageStack("CampaignAI")
end
function setCampaignIL()
	SelectedCampaign = IronLegionID
	SetPageStack("CampaignIL")
end
function setCampaignT()
	SelectedCampaign = TundranTerritoriesID
	SetPageStack("CampaignT")
end
AtmosPosX = -16
AtmosPosY = -113
AtmosSizeX = 672
AtmosSizeY = 700
function atmosPos()
	return AtmosPosX, AtmosPosY
end
function atmosSize()
	return AtmosSizeX, AtmosSizeY
end
function atmosAlpha()
	local a = 255
	return a
end
local gpFlags = {
	1,
	2,
	4,
	8,
	16,
	32,
	64,
	128,
	256,
	512,
	1024,
	2048,
	4096,
	8192,
	16384,
	32768,
	65536,
	131072,
	262144,
	524288,
	1048576,
	2097152,
	4194304,
	8388608,
	16777216,
	33554432,
	67108864,
	134217728,
	268435456,
	536870912,
	1073741824,
	2147483648
}
local briefingFlags = {
	{
		gpFlags[1],
		gpFlags[2],
		gpFlags[3],
		gpFlags[4],
		gpFlags[5]
	},
	{
		gpFlags[6],
		gpFlags[7],
		gpFlags[8],
		gpFlags[9],
		gpFlags[10]
	},
	{
		gpFlags[11],
		gpFlags[12],
		gpFlags[13],
		gpFlags[14],
		gpFlags[15]
	}
}
function BriefingHasBeenSeen(slot, campaign)
	return TestUnlockFlag(GetGeneralPurposeFlags(), briefingFlags[slot][campaign])
end
function SetBriefingSeen(slot, campaign)
	SetGeneralPurposeFlags(AddUnlockFlag(GetGeneralPurposeFlags(), briefingFlags[slot][campaign]))
end
function ClearBriefingSeenFlags(slot)
	for i = 1, 5 do
		SetGeneralPurposeFlags(RemoveUnlockFlag(GetGeneralPurposeFlags(), briefingFlags[slot][i]))
	end
end
DebugOut("Campaign ticked ***")
function Campaign_end()
end
