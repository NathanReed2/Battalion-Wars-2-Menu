function Unlocking(owner)
end
UnlockConcept = 1
UnlockUnits = 2
UnlockedCampaignFlag = false
UnlockMPRankPromoted = false
UnlockMPRankDemoted = false
UnlockMPMap = false
local unlockFlags = 0
local prevUnlockFlags = 0
local newUnlockFlags = 0
local unlockSeenFlags = 0
local UnlockFlag_SEUnits = 1
local UnlockFlag_SEConcepts = 2
local UnlockFlag_WFUnits = 4
local UnlockFlag_WFConcepts = 8
local UnlockFlag_AIUnits = 16
local UnlockFlag_AIConcepts = 32
local UnlockFlag_ILUnits = 64
local UnlockFlag_ILConcepts = 128
local UnlockFlag_TTUnits = 256
local UnlockFlag_TTConcepts = 512
local UnlockFlag_XUnits = 1024
local UnlockFlag_XConcepts = 2048
local campaignActiveTable = {
	0,
	5,
	8,
	12,
	15,
	19
}
local function getUnlockStatus(campaign, pass)
	local speed, power, technique, grade
	if 0 < campaign then
		for level = campaignActiveTable[campaign] + 1, campaignActiveTable[campaign + 1] do
			speed, power, technique, grade = GetStoredMissionData(level + 1)
			if pass > grade then
				return false
			end
		end
	end
	return true
end
local function SEUnits()
	if GetLevelsDone() > 0 then
		return UnlockFlag_SEUnits
	end
	return 0
end
local function SEConcepts()
	if GetLevelsDone() > 0 then
		return UnlockFlag_SEConcepts
	end
	return 0
end
local function WFUnits()
	if getUnlockStatus(1, GRADE.A) then
		return UnlockFlag_WFUnits
	end
	return 0
end
local function WFConcepts()
	if getUnlockStatus(1, GRADE.S) then
		return UnlockFlag_WFConcepts
	end
	return 0
end
local function AIUnits()
	if getUnlockStatus(2, GRADE.A) then
		return UnlockFlag_AIUnits
	end
	return 0
end
local function AIConcepts()
	if getUnlockStatus(2, GRADE.S) then
		return UnlockFlag_AIConcepts
	end
	return 0
end
local function ILUnits()
	if getUnlockStatus(3, GRADE.A) then
		return UnlockFlag_ILUnits
	end
	return 0
end
local function ILConcepts()
	if getUnlockStatus(3, GRADE.S) then
		return UnlockFlag_ILConcepts
	end
	return 0
end
local function TTUnits()
	if getUnlockStatus(4, GRADE.A) then
		return UnlockFlag_TTUnits
	end
	return 0
end
local function TTConcepts()
	if getUnlockStatus(4, GRADE.S) then
		return UnlockFlag_TTConcepts
	end
	return 0
end
local function XUnits()
	if getUnlockStatus(5, GRADE.A) then
		return UnlockFlag_XUnits
	end
	return 0
end
local function XConcepts()
	if getUnlockStatus(5, GRADE.S) then
		return UnlockFlag_XConcepts
	end
	return 0
end
local unlockedTable_1 = {
	{SEConcepts, SEUnits},
	{WFConcepts, WFUnits},
	{AIConcepts, AIUnits},
	{ILConcepts, ILUnits},
	{TTConcepts, TTUnits},
	{XConcepts, XUnits}
}
local unlockedTable_3 = {
	{XConcepts, XUnits},
	{TTConcepts, TTUnits},
	{ILConcepts, ILUnits},
	{AIConcepts, AIUnits},
	{WFConcepts, WFUnits},
	{SEConcepts, SEUnits}
}
function IsUnlocked(faction, type)
	return unlockedTable_1[faction][type]() ~= 0
end
function DoUnlockFlags()
	local flag = 0
	prevUnlockFlags = GetUnlockFlags()
	unlockSeenFlags = GetUnlockSeenFlags()
	unlockFlags = 0
	for i = 1, 6 do
		flag = unlockedTable_3[i][UnlockUnits]()
		unlockFlags = AddUnlockFlag(unlockFlags, flag)
	end
	for i = 1, 6 do
		flag = unlockedTable_3[i][UnlockConcept]()
		unlockFlags = AddUnlockFlag(unlockFlags, flag)
	end
	SetUnlockFlags(unlockFlags)
	newUnlockFlags = unlockFlags - unlockSeenFlags
end
function SavePrevToSeen()
end
function UnlockFlagsChanged()
	return unlockFlags - prevUnlockFlags ~= 0
end
function UnitsUnlocked()
	return TestAnyUnlockFlag(newUnlockFlags, UnlockFlag_SEUnits + UnlockFlag_WFUnits + UnlockFlag_TTUnits + UnlockFlag_AIUnits + UnlockFlag_ILUnits + UnlockFlag_XUnits)
end
function ConceptsUnlocked()
	return TestAnyUnlockFlag(newUnlockFlags, UnlockFlag_SEConcepts + UnlockFlag_WFConcepts + UnlockFlag_TTConcepts + UnlockFlag_AIConcepts + UnlockFlag_ILConcepts + UnlockFlag_XConcepts)
end
local campaignFlagTable = {
	{UnlockFlag_SEConcepts, UnlockFlag_SEUnits},
	{UnlockFlag_WFConcepts, UnlockFlag_WFUnits},
	{UnlockFlag_AIConcepts, UnlockFlag_AIUnits},
	{UnlockFlag_ILConcepts, UnlockFlag_ILUnits},
	{UnlockFlag_TTConcepts, UnlockFlag_TTUnits},
	{UnlockFlag_XConcepts, UnlockFlag_XUnits}
}
function UnlockedSP()
	local currentUnlockFlags = GetUnlockFlags()
	for campaign = 1, 6 do
		for unlocktype = 1, 2 do
			if not TestUnlockFlag(currentUnlockFlags, campaignFlagTable[campaign][unlocktype]) then
				return false
			end
		end
	end
	return true
end
function C1Unlocked(type)
	return TestUnlockFlag(newUnlockFlags, campaignFlagTable[1][type])
end
function C2Unlocked(type)
	return TestUnlockFlag(newUnlockFlags, campaignFlagTable[2][type])
end
function C3Unlocked(type)
	return TestUnlockFlag(newUnlockFlags, campaignFlagTable[3][type])
end
function C4Unlocked(type)
	return TestUnlockFlag(newUnlockFlags, campaignFlagTable[4][type])
end
function C5Unlocked(type)
	return TestUnlockFlag(newUnlockFlags, campaignFlagTable[5][type])
end
function C6Unlocked(type)
	return TestUnlockFlag(newUnlockFlags, campaignFlagTable[6][type])
end
function GetNewUnlockFlags()
	return newUnlockFlags
end
function SetNewUnlockFlags(flags)
	newUnlockFlags = flags
end
function ResetUnlockFlags()
	unlockFlags = GetUnlockFlags()
	unlockSeenFlags = GetUnlockSeenFlags()
	newUnlockFlags = 0
end
local factionUnlockFlags = {
	{UnlockFlag_SEConcepts, UnlockFlag_SEUnits},
	{UnlockFlag_WFConcepts, UnlockFlag_WFUnits},
	{UnlockFlag_AIConcepts, UnlockFlag_AIUnits},
	{UnlockFlag_ILConcepts, UnlockFlag_ILUnits},
	{UnlockFlag_TTConcepts, UnlockFlag_TTUnits},
	{UnlockFlag_XConcepts, UnlockFlag_XUnits}
}
local function testSeenFlagAndSet(faction, type)
	local thisFlag = factionUnlockFlags[faction][type]
	unlockFlags = GetUnlockFlags()
	unlockSeenFlags = GetUnlockSeenFlags()
	if TestUnlockFlag(unlockSeenFlags, thisFlag) then
		return false
	end
	SetUnlockSeenFlags(AddUnlockFlag(unlockSeenFlags, thisFlag))
	newUnlockFlags = unlockFlags - unlockSeenFlags
	return true
end
function AddFactionUnlockUnitsFlag(faction)
	return testSeenFlagAndSet(faction, UnlockUnits)
end
function AddFactionUnlockConceptFlag(faction)
	return testSeenFlagAndSet(faction, UnlockConcept)
end
function GetCampaignUnlockLevel(campaign)
	if getUnlockStatus(campaign, GRADE.S) then
		return 3
	elseif getUnlockStatus(campaign, GRADE.A) then
		return 2
	else
		return 1
	end
end
function Unlocking_end()
end
