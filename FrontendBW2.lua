function FrontendBW2(owner)
	DebugOut("Frontend ticked ***")
	SetFontKernFactor(1, 1.02)
	SetFontKernFactor(3, 1.02)
	local Pages = {
		Attract = GetAttractPage,
		CampaignAI = GetCampaignAIPage,
		CampaignAIInfo = GetCampaignAIInfoPage,
		CampaignAILoading = GetCampaignAILoadingPage,
		CampaignIL = GetCampaignILPage,
		CampaignILInfo = GetCampaignILInfoPage,
		CampaignILLoading = GetCampaignILLoadingPage,
		CampaignS = GetCampaignSPage,
		CampaignSInfo = GetCampaignSInfoPage,
		CampaignSLoading = GetCampaignSLoadingPage,
		CampaignT = GetCampaignTPage,
		CampaignTInfo = GetCampaignTInfoPage,
		CampaignTLoading = GetCampaignTLoadingPage,
		CampaignWF = GetCampaignWFPage,
		CampaignWFInfo = GetCampaignWFInfoPage,
		CampaignWFLoading = GetCampaignWFLoadingPage,
		CampaignBriefing = GetCampaignBriefingPage,
		CampaignBriefing1st = GetCampaignBriefing1stPage,
		CutsceneIn = GetCutsceneInPage,
		CutsceneOut = GetCutsceneOutPage,
		Defeat = GetDefeatPage,
		DefeatMP = GetDefeatMPPage,
		Extras = GetExtrasPage,
		Factions = GetFactionsPage,
		FMV = GetFMVPage,
		GO = GetGOPage,
		GO1 = GetGO1Page,
		GO2 = GetGO2Page,d
		GO3 = GetGO3Page,
		GO4 = GetGO4Page,
		Game = GetGamePage,
		LoadCampaignData = GetLoadCampaignDataPage,
		Loading = GetLoadingPage,
		LoadMPData = GetLoadMPDataPage,
		Logo = GetLogoPage,
		Main = GetMainPage,
		MainPre = GetMainPrePage,
		Map = GetMapPage,
		MapPost = GetMapPostPage,
		Map2 = GetMap2Page,
		Movies = GetMoviesPage,
		Save = GetSavePage,
		SavingPostMP = GetSavingPostMPPage,
		SavingPostSearch = GetSavingPostSearchPage,
		Start = GetStartPage,
		StartPre = GetStartPrePage,
		Unlock = GetUnlockPage,
		Victory = GetVictoryPage,
		VictoryMP = GetVictoryMPPage,
		MapPre = GetMapPrePage,
		Challenge = GetChallengePage,
		ChooseArmy = GetChooseArmyPage,
		Friend = GetFriendPage,
		Friendlist = GetFriendlistPage,
		Friendmatch = GetFriendmatchPage,
		Gametype = GetGametypePage,
		Levels = GetLevelsPage,
		Message = GetMessagePage,
		MPLoading = GetMPLoadingPage,
		Name = GetNamePage,
		Play = GetPlayPage,
		Profile = GetProfilePage,
		Rematch = GetRematchPage,
		Saving = GetSavingPage,
		Search = GetSearchPage,
		WO = GetWOPage,
		GOPre = GetGOPrePage,
		GO1Pre = GetGO1PrePage,
		GO2Pre = GetGO2PrePage,
		GO4Pre = GetGO4PrePage,
		Profile2Pre = GetProfile2PrePage,
		FriendMatchPre = GetFriendMatchPrePage,
		NamePre = GetNamePrePage,
		ExtrasPre = GetExtrasPrePage,
		FactionsPre = GetFactionsPrePage,
		ConceptPre = GetConceptPrePage,
		CreditsPre = GetCreditsPrePage,
		PlayPre = GetPlayPrePage,
		GametypePre = GetGametypePrePage,
		LevelsPre = GetLevelsPrePage,
		ProfilePlayPre = GetProfilePlayPrePage,
		FriendMatchPlayPre = GetFriendMatchPlayPrePage
	}
	MPStatus = GetIsClientOrServer()
	if MPStatus == GAMESTATUS.CLIENT then
		SetIsClientOrServer(GAMESTATUS.NONE)
	elseif MPStatus == GAMESTATUS.SERVER then
		SetIsClientOrServer(GAMESTATUS.NONE)
	end
	print("Waiting for init ...")
	WaitFor(0)
	print("Init done, entering frontend ...")
	LevelsDone, SelectedLevel, SelectedSlot = GetPersistentData()
	InitCurrentSelectedCampaign()
	local presetStackToMain = function()
		ResetPageStack("Start")
		PushPageStack("LoadCampaignData")
		PushPageStack("LoadMPData")
		PushPageStack("Save")
		PushPageStack("MainPre")
		PushPageStack("Main")
	end
	local function presetStackToMap()
		presetStackToMain()
		PushPageStack("MapPre")
		PushPageStack("Map")
	end
	local function presetStackForMP()
		presetStackToMain()
		PushPageStack("Play")
	end
	local function closeAndPresetForMP()
		presetStackForMP()
		PushPageStack("Message")
		PushPageStack("Saving")
		LeaveMPGame()
	end
	local function presetStackToExtras()
		presetStackToMain()
		PushPageStack("ExtrasPre")
		PushPageStack("Extras")
	end
	local campaignNameTable = {
		"CampaignS",
		"CampaignWF",
		"CampaignAI",
		"CampaignIL",
		"CampaignT"
	}
	if TestMissionStatus(GAMESTATUS.WIN) then
		if TestMissionStatus(GAMESTATUS.PROLOGUE) then
			DebugOut("init page stack GAMESTATUS.PROLOGUE - WIN")
			presetStackToExtras()
		end
		PushPageStack("Victory")
		PushPageStack("CutsceneOut")
	elseif TestMissionStatus(GAMESTATUS.LOSE) then
		if TestMissionStatus(GAMESTATUS.PROLOGUE) then
			DebugOut("init page stack GAMESTATUS.PROLOGUE - LOSE")
			presetStackToExtras()
		elseif TestMissionStatus(GAMESTATUS.TRAINING) then
			DebugOut("init page stack GAMESTATUS.TRAINING - LOSE")
			presetStackToMain()
		end
		PushPageStack("Defeat")
	elseif TestMissionStatus(GAMESTATUS.QUIT) then
		UpdateMPMapUnlocked()
		UpdateMPRankStatus()
		if MPStatus == GAMESTATUS.CLIENT or MPStatus == GAMESTATUS.SERVER then
			DebugOut("init page stack GAMESTATUS.QUIT - MP")
			RequestNetworkClose()
			presetStackToMain()
		elseif TestMissionStatus(GAMESTATUS.PROLOGUE) then
			DebugOut("init page stack GAMESTATUS.PROLOGUE - QUIT")
			presetStackToExtras()
		elseif TestMissionStatus(GAMESTATUS.TRAINING) then
			DebugOut("init page stack GAMESTATUS.TRAINING - QUIT")
			presetStackToMain()
		else
			DebugOut("init page stack GAMESTATUS.QUIT - SP")
			presetStackToMap()
			PushPageStack("MapPost")
			PushPageStack(campaignNameTable[SelectedCampaign])
			GlobeSetTarget(SelectedCampaign)
		end
		EnableControllerErrorMessages(true)
	elseif TestMissionStatus(GAMESTATUS.MPLOBBY) then
		DebugOut("init page stack GAMESTATUS.MPLOBBY")
		UpdateMPMapUnlocked()
		UpdateMPRankStatus()
		closeAndPresetForMP()
		EnableControllerErrorMessages(true)
	elseif TestMissionStatus(GAMESTATUS.MPWIN) then
		DebugOut("init page stack GAMESTATUS.MPWIN")
		UpdateMPStatistics()
		UpdateMPMapUnlocked()
		UpdateMPRankStatus()
		presetStackForMP()
		local gameType = GetLevelGameType(SelectedLevel)
		PushPageStack("Rematch")
		PushPageStack("VictoryMP")
		PushPageStack("SavingPostMP")
	elseif TestMissionStatus(GAMESTATUS.MPLOSE) then
		DebugOut("init page stack GAMESTATUS.MPLOSE")
		UpdateMPStatistics()
		UpdateMPMapUnlocked()
		UpdateMPRankStatus()
		presetStackForMP()
		PushPageStack("Rematch")
		PushPageStack("DefeatMP")
		PushPageStack("SavingPostMP")
	elseif TestMissionStatus(GAMESTATUS.PROLOGUE) then
		DebugOut("init page stack GAMESTATUS.PROLOGUE")
		presetStackToExtras()
		PushPageStack("CutsceneOut")
	elseif TestMissionStatus(GAMESTATUS.UNITS) then
		DebugOut("init page stack GAMESTATUS.TRAINING")
		presetStackToExtras()
		PushPageStack("FactionsPre")
		PushPageStack("Factions")
	elseif TestMissionStatus(GAMESTATUS.CONCEPT) then
		DebugOut("init page stack GAMESTATUS.CONCEPT")
		presetStackToExtras()
	elseif TestMissionStatus(GAMESTATUS.ENDCREDITS) then
		DebugOut("init page stack GAMESTATUS.ENDCREDITS")
		presetStackToMain()
	elseif TestMissionStatus(GAMESTATUS.CREDITS) then
		DebugOut("init page stack GAMESTATUS.CREDITS")
		presetStackToExtras()
	elseif GetNetworkStatus() == NETWORK.OK then
		DebugOut("init page stack MULTIPLAYER")
		closeAndPresetForMP()
	else
		DebugOut("init page stack for app. start")
		SetGeneralPurposeFlags(0)
		GameSaveLoaded = false
		MPSaveLoaded = false
		ResetPageStack("Logo")
	end
	local bTestMessagePage = false
	if bTestMessagePage then
		UpdateMPStatistics()
		UpdateMPMapUnlocked()
		UpdateMPRankStatus()
		ResetPageStack("Main")
		PushPageStack("Message")
	end
	local Page = {}
	while FrontendDone == false do
		Page = Pages[NextPage]()
		OpenPage(Page)
		PageDone = false
		while PageDone == false do
			UpdatePage(Page)
			RenderPage(Page)
			WaitFor(0)
		end
		ClosePage(Page)
	end
	DebugOut("Starting level: " .. SelectedLevel)
	RunLevel(SelectedLevel)
end
