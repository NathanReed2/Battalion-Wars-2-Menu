function NANDDialog(owner)
end
local NANDDialogTable = {}
local openDone = false
local homebuttonBlock = false
local requestNone = 0
local requestLoad = 1
local requestSave = 2
local requestCreate = 3
local requestDelete = 4
local requestCheck = 5
local request = requestNone
local status = CARD.NONE
local lastStatus = CARD.NONE
local dialog = 0
local fadeUp = 0
local fadeDown = 1
local fadeStop = 2
local fadeDir = fadeStop
local fadeCount = 180
local fadeRate = 180 / (GetFramesPerSecond() * 0.25)
local delay = 0
local delayTime = GetFramesPerSecond() * 1.5
local loadFunc = 1
local createFunc = 2
local deleteFunc = 3
local functionPtr = 1
local titleID = 2
local messageID = 3
local titleString = 0
local messageString = 0
local autoCreate = false
NANDSubMsgSPData = 1
NANDSubMsgMPData = 2
local dDataSubMsg = NANDSubMsgSPData
local fptrTitleTable = {
	{
		0,
		0,
		0
	},
	{
		0,
		0,
		0
	},
	{
		0,
		0,
		0
	}
}
local function doCallLoadFunc()
	request = requestLoad
	titleString = fptrTitleTable[loadFunc][titleID]
	messageString = fptrTitleTable[loadFunc][messageID]
	fptrTitleTable[loadFunc][functionPtr]()
end
local function doCallCreateFunc()
	request = requestCreate
	titleString = fptrTitleTable[createFunc][titleID]
	messageString = fptrTitleTable[createFunc][messageID]
	fptrTitleTable[createFunc][functionPtr]()
end
local function doCallDeleteFunc()
	request = requestDelete
	titleString = fptrTitleTable[deleteFunc][titleID]
	messageString = fptrTitleTable[deleteFunc][messageID]
	fptrTitleTable[deleteFunc][functionPtr]()
end
local callbackStatusFunc = 0
local function callStatusCallback(whatHappened)
	if callbackStatusFunc ~= 0 then
		callbackStatusFunc(whatHappened)
		if not whatHappened then
			callbackStatusFunc = 0
		end
	end
end
function NANDDialogGetColour()
	return cos(fadeCount) * 127.5 + 127.5
end
local clearError = false
local function updateDFade()
	if fadeDir == fadeDown then
		fadeCount = fadeCount + fadeRate
		if 180 < fadeCount then
			fadeCount = 180
			fadeDir = fadeStop
		end
	elseif fadeDir == fadeUp then
		fadeCount = fadeCount - fadeRate
		if fadeCount < 0 then
			fadeCount = 0
			fadeDir = fadeStop
		end
	end
end
local function startFadeUp()
	fadeDir = fadeUp
	fadeCount = 180
end
local function startFadeDown()
	fadeDir = fadeDown
	fadeCount = 0
end
local dDataType = 1
local dDataMsg = 2
local dDataLbl1 = 3
local dDataAction1 = 4
local dDataLbl2 = 5
local dDataAction2 = 6
local dDataLbl3 = 7
local dDataAction3 = 8
local actionClearDone = false
local function actionClear()
	if not actionClearDone then
		actionClearDone = true
		ClearCardError()
		delay = 0
		callStatusCallback(false)
	end
end
local actionCreateDone = false
local function actionCreate()
	if not actionCreateDone then
		actionCreateDone = true
		if fptrTitleTable[createFunc][functionPtr] ~= 0 then
			doCallCreateFunc()
		end
	end
end
local actionDeleteDone = false
local function actionDelete()
	if not actionDeleteDone then
		actionDeleteDone = true
		if fptrTitleTable[deleteFunc][functionPtr] ~= 0 then
			doCallDeleteFunc()
		end
	end
end
local gotoIPL = function()
	ResetToIPL()
end
local dData = {}
local function initdData()
	local table = {
		{
			1,
			{
				StringID.Access
			},
			StringID.ContinueNoSave,
			actionClear
		},
		{
			1,
			{
				StringID.AllocFailed
			},
			StringID.ContinueNoSave,
			actionClear
		},
		{
			0,
			{
				StringID.Busy
			}
		},
		{
			2,
			{
				StringID.Corrupt
			},
			StringID.ContinueNoSave,
			actionClear,
			StringID.Delete,
			actionDelete
		},
		{
			2,
			{
				StringID.ECCCritical
			},
			StringID.ContinueNoSave,
			actionClear,
			StringID.Delete,
			actionDelete
		},
		{
			1,
			{
				StringID.Exists
			},
			StringID.ContinueNoSave,
			actionClear
		},
		{
			2,
			{
				StringID.Invalid
			},
			StringID.ContinueNoSave,
			actionClear,
			StringID.Delete,
			actionDelete
		},
		{
			2,
			{
				StringID.NoBlocks,
				StringID.NoBlocksMP
			},
			StringID.ContinueNoSave,
			actionClear,
			StringID.QuitToIPL,
			gotoIPL
		},
		{
			1,
			{
				StringID.MaxFD
			},
			StringID.ContinueNoSave,
			actionClear
		},
		{
			2,
			{
				StringID.NoInodes
			},
			StringID.ContinueNoSave,
			actionClear,
			StringID.QuitToIPL,
			gotoIPL
		},
		{
			5,
			{
				StringID.NoExists
			},
			StringID.Create,
			actionCreate
		},
		{
			1,
			{
				StringID.NotEmpty
			},
			StringID.ContinueNoSave,
			actionClear
		},
		{
			1,
			{
				StringID.OpenFD
			},
			StringID.ContinueNoSave,
			actionClear
		},
		{
			1,
			{
				StringID.Authentication
			},
			StringID.ContinueNoSave,
			actionClear
		},
		{
			1,
			{
				StringID.Unknown
			},
			StringID.ContinueNoSave,
			actionClear
		},
		{
			1,
			{
				StringID.FatalError
			},
			StringID.ContinueNoSave,
			actionClear
		},
		{
			1,
			{
				StringID.NotReady
			},
			StringID.ContinueNoSave,
			actionClear
		},
		{
			1,
			{
				StringID.InitFailed
			},
			StringID.ContinueNoSave,
			actionClear
		},
		{
			1,
			{
				StringID.NoMemory
			},
			StringID.ContinueNoSave,
			actionClear
		},
		{
			2,
			{
				StringID.NoInodes
			},
			StringID.ContinueNoSave,
			actionClear,
			StringID.QuitToIPL,
			gotoIPL
		},
		{
			2,
			{
				StringID.NoBlocks,
				StringID.NoBlocksMP
			},
			StringID.ContinueNoSave,
			actionClear,
			StringID.QuitToIPL,
			gotoIPL
		},
		{
			1,
			{
				StringID.WriteError
			},
			StringID.ContinueNoSave,
			actionClear
		},
		{
			2,
			{
				StringID.ReadError
			},
			StringID.ContinueNoSave,
			actionClear,
			StringID.Delete,
			actionDelete
		},
		{
			2,
			{
				StringID.CRCError
			},
			StringID.ContinueNoSave,
			actionClear,
			StringID.Delete,
			actionDelete
		},
		{
			1,
			{
				StringID.UnknownOp
			},
			StringID.ContinueNoSave,
			actionClear
		},
		{
			1,
			{
				StringID.UnknownOpState
			},
			StringID.ContinueNoSave,
			actionClear
		},
		{
			1,
			{
				StringID.UnknownError
			},
			StringID.ContinueNoSave,
			actionClear
		}
	}
	dData = table
end
local titlesData = {}
local function initTitleData()
	local table = {
		StringID.Loading,
		StringID.Saving,
		StringID.Creating,
		StringID.Deleting,
		StringID.Checking
	}
	titlesData = table
end
local function titles(id)
	return titlesData[id]
end
local requestOKMessagesData = {}
local function initRequestOKMessageData()
	local table = {
		StringID.OpSuccessful,
		StringID.OpSuccessful,
		StringID.OpSuccessful,
		StringID.OpSuccessful,
		StringID.OpSuccessful
	}
	requestOKMessagesData = table
end
local function requestOKMessages(id)
	return requestOKMessagesData[id]
end
local requestBusyMessagesData = {}
local function initRequestBusyMessageData()
	local table = {
		StringID.DoNotTurnOffPower,
		StringID.DoNotTurnOffPower,
		StringID.DoNotTurnOffPower,
		StringID.DoNotTurnOffPower,
		StringID.DoNotTurnOffPower
	}
	requestBusyMessagesData = table
end
local function requestBusyMessages(id)
	if messageString ~= 0 then
		return messageString
	end
	return requestBusyMessagesData[id]
end
local getDialogType = function(s)
	local dialogTypes = {
		GUI_Dialog_Box_0.NANDDialog_0,
		GUI_Dialog_Box_1.NANDDialog_1b,
		GUI_Dialog_Box_2.NANDDialog_2,
		GUI_Dialog_Box_3.NANDDialog_3,
		GUI_Dialog_Box_1.NANDDialog_1
	}
	if 0 < s then
		EnableControllerErrorMessages(true)
	end
	return dialogTypes[s + 1]
end
function NANDDialogGetTitle()
	if titleString ~= 0 then
		return titleString
	end
	return titles(request)
end
function NANDDialogGetMessage()
	if status == CARD.NONE then
		return requestOKMessages(request)
	elseif status == CARD.Busy then
		return requestBusyMessages(request)
	elseif dData[status][dDataMsg][dDataSubMsg] ~= nil then
		return dData[status][dDataMsg][dDataSubMsg]
	else
		return dData[status][dDataMsg][NANDSubMsgSPData]
	end
end
function NANDDialogGetLabel1()
	return dData[status][dDataLbl1]
end
function NANDDialogButton_1()
	dData[status][dDataAction1]()
end
function NANDDialogGetLabel2()
	return dData[status][dDataLbl2]
end
function NANDDialogButton_2()
	dData[status][dDataAction2]()
end
function NANDDialogGetLabel3()
	return dData[status][dDataLbl3]
end
function NANDDialogButton_3()
	dData[status][dDataAction3]()
end
local function updateStatus()
	local doDialog = false
	status = GetCardError()
	if status ~= lastStatus then
		lastStatus = status
		if dialog ~= 0 and status ~= CARD.NONE then
			doDialog = true
		end
	end
	if status == CARD.NONE then
		if dialog ~= 0 then
			if request == requestDelete then
				doCallCreateFunc()
			else
				callStatusCallback(true)
				request = requestNone
			end
			doDialog = true
		end
	elseif status == CARD.NoExists and autoCreate then
		doCallCreateFunc()
		doDialog = true
	elseif dialog == 0 then
		doDialog = true
	end
	if doDialog then
		if dialog ~= 0 then
			if homebuttonBlock then
				UnblockHomebutton()
				homebuttonBlock = false
			end
			StopWidget(dialog)
			dialog = 0
		else
			if not homebuttonBlock then
				BlockHomebutton()
				homebuttonBlock = true
			end
			dialog = getDialogType(dData[status][dDataType])
			StartWidget(NANDDialogTable, dialog, true)
			doDialog = false
			delay = delayTime
			startFadeUp()
		end
	end
end
local function updateStatusTest()
	if status ~= lastStatus then
		lastStatus = status
		if dialog ~= 0 and status ~= CARD.NONE then
			StopWidget(dialog)
			dialog = 0
		end
	end
	if status == CARD.NONE then
		if dialog ~= 0 then
			StopWidget(dialog)
			dialog = 0
		end
	elseif dialog == 0 then
		dialog = getDialogType(dData[status][dDataType])
		StartWidget(NANDDialogTable, dialog, true)
	end
end
function NANDDialogTable.Open()
	openDone = true
	clearError = false
	request = requestNone
	status = CARD.NONE
	lastStatus = CARD.NONE
	dialog = 0
	delay = 0
	fadeDir = fadeStop
	fadeCount = 0
	initdData()
	initTitleData()
	initRequestOKMessageData()
	initRequestBusyMessageData()
	actionClearDone = false
	actionDeleteDone = false
	actionCreateDone = false
end
function NANDDialogTable.Update()
	if not openDone then
		return
	end
	updateDFade()
	if fadeDir ~= fadeStop then
		return
	end
	if 0 < delay then
		delay = delay - 1
		return
	end
	updateStatus()
end
function NANDDialogTable.UpdateTest(test)
	if not openDone then
		return
	end
	status = test
	request = requestLoad
	callbackStatusFunc = 0
	updateStatusTest()
end
function NANDDialogTable.Close()
	if not openDone then
		return
	end
	openDone = false
	if homebuttonBlock then
		UnblockHomebutton()
		homebuttonBlock = false
	end
end
function NANDDialogTable.Load(table, funcPtrCallback, autoCreateFlag, subDataMsg)
	autoCreate = autoCreateFlag
	fptrTitleTable = table
	callbackStatusFunc = funcPtrCallback
	dDataSubMsg = subDataMsg
	doCallLoadFunc()
end
function NANDDialogTable.Save(funcPtrSave, funcPtrCallback)
	titleString = 0
	messageString = 0
	request = requestSave
	callbackStatusFunc = funcPtrCallback
	dDataSubMsg = NANDSubMsgSPData
	funcPtrSave()
end
function GetNANDDialog()
	return NANDDialogTable
end
DebugOut("NANDDialog ticked ***")
function NANDDialog_end()
end
