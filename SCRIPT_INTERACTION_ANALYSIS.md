# Battalion Wars 2 Menu System - Script Interaction Flow Analysis

## Introduction
This document analyzes the specific interaction patterns and data flows between different Lua scripts in the Battalion Wars 2 menu system, providing detailed call graphs and state transition diagrams.

## Core Navigation Flow

### Main Entry Point Flow
```
Application Start
↓
Main.lua.Main()
├── Initialize cursor system
├── Set up main menu functions
├── Register button callbacks
└── Enter main menu loop

Main Menu User Actions:
├── gotoSave() → Campaign/Story Mode
├── gotoMP() → Multiplayer Mode  
├── gotoGO() → Game Options
├── gotoExtras() → Extras Menu
└── gotoGlobeSelect() → Debug Globe (non-final builds)
```

### PageStack Navigation Pattern
```lua
-- Forward Navigation
function navigateToPage(targetPage)
    PushPageStack(targetPage)
    -- PageStack.lua handles:
    -- 1. PageStackTop increment
    -- 2. Store current page in stack
    -- 3. Set NextPage = targetPage
    -- 4. Set PageDone = true (triggers page transition)
end

-- Backward Navigation  
function goBack()
    PopPageStack()
    -- PageStack.lua handles:
    -- 1. Remove current page from stack
    -- 2. Decrement PageStackTop
    -- 3. Set NextPage = previous page
    -- 4. Set PageDone = true
end
```

## Campaign System Flow

### Campaign Selection and Loading
```
Main.lua.gotoSave()
↓
Check GetLevelsDone()
├── If 0 (First Time):
│   ├── SelectedLevel = 1
│   ├── SelectedCampaign = 1  
│   ├── GlobeSetTarget(4)
│   ├── SetMissionStatus(GAMESTATUS.TRAINING)
│   └── PushPageStack("CutsceneIn")
└── Else (Returning Player):
    ├── MapPreFade(true)
    └── PushPageStack("MapPre")
```

### Campaign Script Hierarchy
```
Campaign.lua (Base Logic)
├── Campaign state management
├── Mission position calculations
├── Level progression tracking
└── Faction-specific delegation

Per-Faction Scripts:
├── CampaignAI.lua → Anglo Isles
├── CampaignIL.lua → Iron Legion
├── CampaignS.lua → Solar Empire  
├── CampaignT.lua → Tundran Territories
└── CampaignWF.lua → Western Frontier

Each Faction Has:
├── [Faction]Info.lua → Mission briefings and data
├── [Faction]Loading.lua → Loading screen management
└── Shared mission configuration tables
```

### Mission Data Flow
```lua
-- Campaign.lua mission position mapping
MissionPositionTable = {
    -- Campaign 1 (Western Frontier)
    {
        {X = 92, Y = 209},   -- Mission 1-1
        {X = 213, Y = 148},  -- Mission 1-2
        -- ... more positions
    },
    -- Campaign 2, 3, 4, 5...
}

-- Mission unit configuration arrays
local missionUnitsTable = {
    {
        GUI_Custom_Widget.Mission_Units_1_1,      -- Player units
        GUI_Custom_Widget.Mission_Units_1_1_E     -- Enemy units
    },
    -- ... for each mission
}
```

## Multiplayer System Flow

### Multiplayer Entry and Profile Loading
```
Main.lua.gotoMP()
↓
Set MPProfileLoading = true
↓
PushPageStack(GetMPPageFromCode())
↓
Multiplayer Hub
├── Search.lua (Game Matching)
├── Friendlist.lua (Friend Management)
├── Profile.lua (Player Profile)
├── Gametype.lua (Game Type Selection)
└── Levels.lua (Map Selection)
```

### Search and Matchmaking Flow
```lua
-- Search.lua workflow
function Search.Open()
    -- Initialize search parameters
    local timeLimit = 20 * GetFramesPerSecond()
    local timeLeft = timeLimit
    
    -- Start matchmaking process
    StartMatchMaking(searchParameters)
    
    -- Show search dialog
    StartWidget(tableData, GUI_Dialog_Box_1.ShowStatus_animation, true)
end

function Search.Update()
    -- Poll matchmaking status
    status = CheckMatchMaking()
    
    -- Handle different status states
    if status == eWiiMatchingStatus.Success then
        -- Handle successful match
        handleMatchFound()
    elseif status == eWiiMatchingStatus.Failure then
        -- Handle search failure  
        handleSearchFailure()
    elseif status == eWiiMatchingStatus.Connecting then
        -- Show connecting dialog
        showConnectingDialog()
    end
    
    -- Update UI accordingly
    updateStatusDisplay()
end
```

### Friend System Integration
```
Friendlist.lua
├── Display friend list
├── Friend status monitoring
├── Challenge sending/receiving
└── Friend-specific matchmaking

Friend.lua  
├── Individual friend actions
├── Profile viewing
├── Challenge management
└── Status updates

Friendmatch.lua
├── Friend-specific game setup
├── Challenge acceptance
├── Private match creation
└── Friend invitation system
```

## Dialog System Interactions

### NANDDialog Save/Load System
```lua
-- NANDDialog.lua manages save/load operations
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
```

### Dialog State Management
```
NANDDialog Error Handling Flow:
├── Check operation status (CARD.*)
├── Map status to dialog configuration
├── Display appropriate dialog box
│   ├── GUI_Dialog_Box_0.NANDDialog_0
│   ├── GUI_Dialog_Box_1.NANDDialog_1
│   ├── GUI_Dialog_Box_2.NANDDialog_2
│   └── GUI_Dialog_Box_3.NANDDialog_3
├── Present user options (Continue/Delete/Retry)
└── Execute selected action
```

### YesNoDialog Pattern
```lua
-- YesNoDialog.lua provides reusable confirmation dialogs
function ShowYesNoDialog(title, message, yesCallback, noCallback)
    -- Set dialog content
    setDialogTitle(title)
    setDialogMessage(message)
    
    -- Register callbacks
    registerYesAction(yesCallback)
    registerNoAction(noCallback)
    
    -- Show dialog
    StartWidget(owner, GUI_Dialog_Box_2.YesNo, true)
end
```

## Game Options System Flow

### Options Hierarchy
```
GO.lua (Main Options Hub)
├── Audio options → GO1.lua
├── Video options → GO2.lua
├── Control options → GO3.lua
└── Advanced options → GO4.lua

Each Options Page:
├── Load current settings
├── Present adjustment controls (sliders, toggles)
├── Apply changes in real-time
├── Save/revert functionality
└── Return to main options
```

### Settings Management Pattern
```lua
-- GO1.lua (Audio Options) example
function GO1.Open()
    -- Load current audio settings
    local musicVolume = GetMusicVolume()
    local sfxVolume = GetSFXVolume()
    local voiceVolume = GetVoiceVolume()
    
    -- Initialize sliders
    initSlider(GUI_Slider.GO_Music_Volume, musicVolume)
    initSlider(GUI_Slider.GO_SFX_Volume, sfxVolume)
    initSlider(GUI_Slider.GO_CO_Voice_Volume, voiceVolume)
end

function GO1.Update()
    -- Monitor slider changes
    if sliderChanged(GUI_Slider.GO_Music_Volume) then
        local newVolume = getSliderValue(GUI_Slider.GO_Music_Volume)
        SetMusicVolume(newVolume)
        -- Real-time preview
    end
    -- ... handle other sliders
end
```

## State Synchronization Patterns

### Global State Variables
```lua
-- Global.lua maintains shared state
SelectedLevel = 0        -- Current level selection
SelectedCampaign = 0     -- Active campaign  
SelectedSlot = 0         -- Save slot selection
MStatus = GAMESTATUS.NONE     -- Mission status
MPStatus = GAMESTATUS.NONE    -- Multiplayer status
GameType = GAMETYPE.Skirmish  -- Current game type

-- Faction constants
SolarEmpireID = 1
WesternFrontierID = 2
AngloIslesID = 3
IronLegionID = 4
TundranTerritoriesID = 5
XylvaniaID = 6
```

### State Update Patterns
```lua
-- Example: Campaign selection updates global state
function Campaign.selectMission(level, campaign)
    -- Update global state
    SelectedLevel = level
    SelectedCampaign = campaign
    
    -- Update mission-specific state
    updateMissionDisplay()
    
    -- Notify other systems
    notifyMissionChange()
end

-- Cross-script state queries
function getMissionInfo()
    return {
        level = SelectedLevel,
        campaign = SelectedCampaign,
        unlocked = GetLevelsDone() >= SelectedLevel
    }
end
```

## Audio/Visual System Integration

### Music System Flow
```lua
-- Music.lua manages background music
function Music.Update()
    -- Check current page/context
    local currentPage = GetPageAtTop()
    
    -- Select appropriate music
    if currentPage == "Main" then
        PollTitleMusicLoop()
    elseif currentPage:match("Campaign") then
        PollMapMusicLoop()
    elseif currentPage:match("MP") then
        PollMPMusicLoop()
    end
end
```

### Sprite Animation System
```lua
-- SpriteTravel.lua handles sprite animations
function SpriteTravel.animateSprite(spriteID, fromPos, toPos, duration)
    -- Set up animation parameters
    registerSpriteAnimation(spriteID, fromPos, toPos, duration)
    
    -- Start animation loop
    startSpriteAnimation()
end
```

## Error Handling and Recovery

### Save System Error Recovery
```lua
-- NANDDialog.lua error handling patterns
local function handleSaveError(errorCode)
    local errorDialogs = {
        [CARD.Corrupt] = {
            dialog = GUI_Dialog_Box_2.NANDDialog_2,
            buttons = {"Continue", "Delete"},
            actions = {actionClear, actionDelete}
        },
        [CARD.NoMemory] = {
            dialog = GUI_Dialog_Box_1.NANDDialog_1,
            buttons = {"Continue"},
            actions = {actionClear}
        }
        -- ... more error mappings
    }
    
    local errorConfig = errorDialogs[errorCode]
    if errorConfig then
        showErrorDialog(errorConfig)
    end
end
```

### Network Error Handling
```lua
-- Search.lua network error patterns
function handleConnectionError(status)
    if status == eWiiMatchingStatus.ConnectionProblem then
        -- Show connection problem dialog
        StopWidget(GUI_Dialog_Box_1.ShowStatus_animation)
        StartWidget(tableData, GUI_Dialog_Box_0.ShowStatusConnecting, true)
        
        -- Set retry timer
        showConnectDialogFrame = showConnectDialogMinFrames
    elseif status == eWiiMatchingStatus.Failure then
        -- Show failure dialog with retry option
        showFailureDialog()
    end
end
```

## Performance and Optimization Patterns

### Widget Management Optimization
```lua
-- Efficient widget lifecycle management
function optimizedWidgetUpdate()
    -- Only update active widgets
    if GetWidgetActive(widgetID) then
        updateWidget(widgetID)
    end
    
    -- Batch widget operations
    local widgetsToStart = {}
    local widgetsToStop = {}
    
    -- Collect operations
    collectWidgetOperations(widgetsToStart, widgetsToStop)
    
    -- Execute in batches
    for _, widget in ipairs(widgetsToStop) do
        StopWidget(widget)
    end
    for _, widget in ipairs(widgetsToStart) do
        StartWidget(owner, widget, true)
    end
end
```

### Memory Management
```lua
-- Cleanup patterns when leaving pages
function PageCleanup()
    -- Stop unnecessary widgets
    cleanupActiveWidgets()
    
    -- Clear temporary data
    clearPageSpecificData()
    
    -- Reset audio if needed
    if shouldResetAudio() then
        resetAudioState()
    end
end
```

This analysis shows how the Battalion Wars 2 menu system uses sophisticated interaction patterns to create a responsive, maintainable user interface with clear separation of concerns and robust error handling.