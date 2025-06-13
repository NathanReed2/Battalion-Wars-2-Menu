function LoadCampaignData(owner)
	local tableData = {}
	tableData.revConCursor = GetMainCursor()
	local nandDialog
	local fileStageNone = 0
	local fileStageSP = 1
	local fileStageSPDone = 2
	local fileStageMP = 3
	local fileStageMPDone = 4
	local fileStage = fileStageNone
	local createInProgress = false
	local function loadCallbackSP(status)
		SetGameSaveValid(SPSaveStatus, status)
		fileStage = fileStageSPDone
	end
	local function loadCallbackMP(status)
		SetGameSaveValid(MPSaveStatus, status)
		fileStage = fileStageMPDone
		GameSaveLoaded = true
	end
	local function create()
		if not createInProgress then
			createInProgress = true
			local inodes = 1 + 1 + 1 + 1
			local blocks = 4 + 1 + 5
			RequestCreateMultiPlayer()
			CreateSaveFile()
			CheckNANDResources(inodes, blocks)
		end
	end
	local function doLoadSP()
		local table = {
			{
				CheckSaveFile,
				StringID.LoadingSP,
				StringID.LoadingSPMessg
			},
			{
				create,
				StringID.CreatingSP,
				StringID.CreatingSPMessg
			},
			{
				DeleteSaveFile,
				StringID.DeletingSP,
				StringID.DeletingSPMessg
			}
		}
		fileStage = fileStageSP
		nandDialog.Load(table, loadCallbackSP, true, NANDSubMsgSPData)
	end
	local function doLoadMP()
		local table = {
			{
				RequestLoadMultiPlayer,
				StringID.LoadingMP,
				StringID.LoadingMPMessg
			},
			{
				RequestCreateMultiPlayer,
				StringID.CreatingMP,
				StringID.CreatingMPMessg
			},
			{
				RequestDeleteMultiPlayer,
				StringID.DeletingMP,
				StringID.DeletingMPMessg
			}
		}
		if GetGameSaveValid(SPSaveStatus) then
			fileStage = fileStageMP
			nandDialog.Load(table, loadCallbackMP, true, NANDSubMsgMPData)
		else
			fileStage = fileStageMPDone
			GameSaveLoaded = true
		end
	end
	function tableData.Open()
		nandDialog = GetNANDDialog()
		nandDialog.Open()
		createInProgress = false
	end
	local homebuttonBlock = false
	function tableData.Update()
		if GameSaveLoaded then
			PushPageStack("Save")
		else
			if fileStage == fileStageNone then
				if not homebuttonBlock then
					homebuttonBlock = true
					BlockHomebutton()
				end
				doLoadSP()
			elseif fileStage == fileStageSPDone then
				doLoadMP()
			end
			nandDialog.Update()
			pollTitleLoop()
		end
	end
	function tableData.Close()
		nandDialog.Close()
		if homebuttonBlock then
			homebuttonBlock = false
			UnblockHomebutton()
		end
		EnableControllerErrorMessages(true)
	end
	function GetLoadCampaignDataPage()
		return tableData
	end
	DebugOut("LoadCampaign page ticked ***")
end
