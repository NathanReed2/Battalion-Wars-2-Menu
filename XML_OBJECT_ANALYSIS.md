# Battalion Wars 2 Menu System - XML Object Analysis

## XML Object Inventory and Mapping

This document provides a comprehensive breakdown of all XML objects defined in `Frontend2_Level.xml` and their usage patterns throughout the Lua script ecosystem.

## Object Type Summary

### GUI Widget Objects (Total: 1,745 objects)

#### 1. cGUICustomWidget (528 instances)
**Purpose**: Complex, reusable UI components with custom behavior
**Key Examples**:
- `Mission_Units_*` series (Mission unit display widgets)
- `Campaign_*_navigation` (Campaign navigation controls)
- `ICON_*` widgets (Icon display components)
- `Mission_tool_tip` (Tooltip displays)

**Usage Pattern**:
```lua
GUI_Custom_Widget.Mission_Units_1_1 = RegisterReflectionId("20001913")
GUI_Custom_Widget.Campaign_AI_navigation = RegisterReflectionId("20001809")
```

#### 2. cGUITextBoxWidget (497 instances)
**Purpose**: Text display and input components
**Categories**:
- Status text displays
- Button labels
- Information panels
- Input fields

#### 3. cGUITextureWidget (410 instances)
**Purpose**: Image and texture display elements
**Key Categories**:
- Background textures
- UI panel graphics
- Button graphics (normal, active, selected states)
- Grade/ranking displays
- Faction emblems

**Example Usage**:
```lua
GUI_Texture.Campaign_Grade_BG = RegisterReflectionId("780000704")
GUI_Texture.Grade_Badge_S = RegisterReflectionId("780000415")
```

#### 4. cGUIButtonWidget (213 instances)
**Purpose**: Interactive button controls
**Patterns**:
- Navigation buttons
- Selection toggles
- Action triggers
- Menu options

#### 5. cGUISpriteWidget (167 instances)
**Purpose**: Animated and static sprite displays
**Categories**:
- Character portraits (`Mission_CO_*` series)
- Faction icons (`Mobility_Faction_*_Icon`)
- Mission thumbnails (`Movies_Thumb_*`)
- Cursor sprites (`FE_RevCon_Cursor*`)

**Example Mapping**:
```lua
GUI_Sprite.Mission_CO_Herman = RegisterReflectionId("780000774")
GUI_Sprite.Mission_CO_Nova = RegisterReflectionId("780000787")
```

#### 6. cGUIEventHandler (251 instances)
**Purpose**: Event processing and response management
**Function**: Links user interactions to Lua callback functions

### Resource Objects

#### 1. cTextureResource (434 instances)
**Purpose**: Texture asset definitions
**Categories**:
- UI Panel textures (`panel_*`, `PNL_*`)
- Button state textures (`button*_n`, `button*_a`, `button*_s`)
- Map textures (`MAP_*`, `Map_*`)
- Icon textures (`ICON_*`)
- Grade badges (`Grade_Badge_*`)

**Naming Conventions**:
- `_n`: Normal state
- `_a`: Active/hover state  
- `_s`: Selected state
- `_d`: Disabled state

#### 2. cGameScriptResource (95 instances)
**Purpose**: Lua script file registration
**Complete Script Mapping**:

##### Core Navigation Scripts:
- `Main` (1300000200) → Main.lua
- `PageStack` (2144902928) → PageStack.lua
- `Global` (1300001278) → Global.lua
- `Start` (1300000170) → Start.lua

##### Campaign Scripts:
- `Campaign` (20001686) → Campaign.lua
- `CampaignAI` (20001677) → CampaignAI.lua
- `CampaignIL` (20001675) → CampaignIL.lua
- `CampaignS` (20001674) → CampaignS.lua
- `CampaignT` (20001667) → CampaignT.lua
- `CampaignWF` (2144912299) → CampaignWF.lua
- `GlobeSelect` (2144913664) → GlobeSelect.lua

##### Campaign Info Scripts:
- `CampaignAIInfo` (2144913530) → CampaignAIInfo.lua
- `CampaignILInfo` (2144913531) → CampaignILInfo.lua
- `CampaignSInfo` (2144913507) → CampaignSInfo.lua
- `CampaignTInfo` (2144913532) → CampaignTInfo.lua
- `CampaignWFInfo` (2144913533) → CampaignWFInfo.lua

##### Campaign Loading Scripts:
- `CampaignAILoading` (2144913603) → CampaignAILoading.lua
- `CampaignILLoading` (2144913604) → CampaignILLoading.lua
- `CampaignSLoading` (2144913605) → CampaignSLoading.lua
- `CampaignTLoading` (2144913606) → CampaignTLoading.lua
- `CampaignWFLoading` (2144913607) → CampaignWFLoading.lua

##### Multiplayer Scripts:
- `Search` (310002158) → Search.lua
- `Friendlist` (310002159) → Friendlist.lua
- `Friend` (310002160) → Friend.lua
- `Friendmatch` (310002619) → Friendmatch.lua
- `Profile` (310002162) → Profile.lua
- `Gametype` (310002599) → Gametype.lua
- `Levels` (310002157) → Levels.lua
- `ChooseArmy` (310100147) → ChooseArmy.lua
- `Map` (310002026) → Map.lua
- `Map2` (2144913674) → Map2.lua
- `MPLoading` (310002779) → MPLoading.lua
- `Challenge` (310002645) → Challenge.lua
- `Rematch` (310002865) → Rematch.lua

##### Game Options Scripts:
- `GO` (310002024) → GO.lua
- `GO1` (20001965) → GO1.lua
- `GO2` (20001967) → GO2.lua
- `GO3` (20001966) → GO3.lua
- `GO4` (840000213) → GO4.lua

##### Support Scripts:
- `Extras` (310002025) → Extras.lua
- `Save` (310002022) → Save.lua
- `Saving` (310100186) → Saving.lua
- `Loading` (2144913213) → Loading.lua
- `Victory` (1300000653) → Victory.lua
- `Defeat` (1300000654) → Defeat.lua
- `VictoryMP` (2144913731) → VictoryMP.lua
- `DefeatMP` (250012968) → DefeatMP.lua

##### Dialog and Message Scripts:
- `NANDDialog` (2144912666) → NANDDialog.lua
- `YesNoDialog` (2144912999) → YesNoDialog.lua
- `Message` (310100000) → Message.lua

##### Audio/Visual Scripts:
- `Music` (2144912010) → Music.lua
- `Movies` (2144912301) → Movies.lua
- `FMV` (2144912306) → FMV.lua
- `Backgrounds` (2144902887) → Backgrounds.lua
- `SpriteTravel` (2144912058) → SpriteTravel.lua

##### Utility Scripts:
- `Unlock` (2144912308) → Unlock.lua
- `Unlocking` (2144914262) → Unlocking.lua
- `Factions` (2144912303) → Factions.lua
- `Game` (1300000655) → Game.lua
- `Attract` (1300000954) → Attract.lua

#### 3. cNodeHierarchyResource (37 instances)
**Purpose**: 3D model and hierarchy definitions
**Categories**:
- Globe models (`Globe_*` series)
- Border graphics (`border_*`, `globe_bor_*`)
- Faction icons (`globe_icon_*`)
- Environmental elements (`Globe_stars1`, `Globe_atmos`)

#### 4. sSampleResource (27 instances)
**Purpose**: Audio sample definitions
**Categories**:
- UI sounds (`UI_FE_*`, `ui_addfriend_*`)
- Game effects (`DE_*`, `PE_*`)
- Musical elements (`bugle_03`)

### Dialog Box System

#### Dialog Box Types:
1. **cGUIDialogBox0Widget** (5 instances)
   - `ShowStatus` (310002401)
   - `ShowStatusConnecting` (250013127)
   - `NANDDialog_0` (2144912667)

2. **cGUIDialogBox1Widget** (4 instances)
   - `ShowStatus` (310002504)
   - `NANDDialog_1` (780000103)
   - `ShowStatus_animation` (840001750)
   - `NANDDialog_1b` (840002262)

3. **cGUIDialogBox2Widget** (2 instances)
   - `YesNo` (310002305)
   - `NANDDialog_2` (780000080)

4. **cGUIDialogBox3Widget** (1 instance)
   - `NANDDialog_3` (780000096)

### Slider Controls

#### cGUISliderWidget (7 instances)
**Purpose**: Adjustable value controls for game options
- `GO_Music_Volume` (20002009)
- `GO_SFX_Volume` (20002030)
- `GO_CO_Voice_Volume` (20002056)
- Various other option sliders

### List Box Widgets

#### cGUIListBoxWidget (2 instances)
- `Friendmatch_list` (310002634)
- `Friendlist_list` (310002435)

## Object Usage Patterns in Lua Scripts

### 1. Widget Lifecycle Management
```lua
-- Activation
StartWidget(owner, GUI_Dialog_Box_0.ShowStatus, true)

-- Deactivation  
StopWidget(GUI_Dialog_Box_1.ShowStatus_animation)

-- State checking
if GetWidgetActive(widgetID) then
    -- Widget is currently active
end
```

### 2. Campaign Mission Units
The `Mission_Units_*` series follows a structured pattern:
```lua
-- Pattern: Mission_Units_[Campaign]_[Mission][_E for enemy]
GUI_Custom_Widget.Mission_Units_1_1 = RegisterReflectionId("20001913")
GUI_Custom_Widget.Mission_Units_1_1_E = RegisterReflectionId("2144913083")
GUI_Custom_Widget.Mission_Units_1_2 = RegisterReflectionId("2144913082")
```

### 3. Character/CO Sprites
Commander (CO) portraits follow faction-based naming:
```lua
-- Format: Mission_CO_[Name][_E for enemy version]
GUI_Sprite.Mission_CO_Herman = RegisterReflectionId("780000774")
GUI_Sprite.Mission_CO_Nova = RegisterReflectionId("780000787")
GUI_Sprite.Mission_CO_Herman_E = RegisterReflectionId("2144913743")
```

### 4. Faction Icons
```lua
-- Mobility faction icons
GUI_Sprite.Mobility_Faction_WF_Icon = RegisterReflectionId("2144912759")
GUI_Sprite.Mobility_Faction_S_Icon = RegisterReflectionId("2144912762")
GUI_Sprite.Mobility_Faction_IL_Icon = RegisterReflectionId("2144912763")
```

### 5. Grade/Ranking System
```lua
-- Performance grades
GUI_Texture.Grade_Badge_S = RegisterReflectionId("780000415")
GUI_Texture.Grade_Badge_A = RegisterReflectionId("780000413")
GUI_Texture.Grade_Badge_B = RegisterReflectionId("780000411")
GUI_Texture.Grade_Badge_C = RegisterReflectionId("780000409")
```

## Cross-Script Object Usage

### Search.lua Usage Example
```lua
-- Dialog management in multiplayer search
StopWidget(GUI_Dialog_Box_0.ShowStatus)
StopWidget(GUI_Dialog_Box_0.ShowStatusConnecting)
StartWidget(tableData, GUI_Dialog_Box_1.ShowStatus_animation, true)
```

### Campaign.lua Usage Example
```lua
-- Mission unit widget arrays for different campaigns
local missionUnitsTable = {
    {
        GUI_Custom_Widget.Mission_Units_1_1,
        GUI_Custom_Widget.Mission_Units_1_1_E
    },
    {
        GUI_Custom_Widget.Mission_Units_1_2,
        GUI_Custom_Widget.Mission_Units_1_2_E
    }
    -- ... continues for all missions
}
```

## Technical Implementation Notes

### Reflection ID System
- Each XML object gets a unique numeric ID
- `RegisterReflectionId()` creates Lua variable mapping
- Enables type-safe object reference from scripts
- Maintains separation between XML definition and script logic

### Widget State Management
- Widgets can be started/stopped dynamically
- State changes trigger visual updates
- Multiple widgets can be active simultaneously
- Parent-child relationships maintained through XML hierarchy

### Resource Loading
- Textures loaded on-demand based on script requirements
- Audio samples cached for immediate playback
- 3D models instantiated as needed for globe interface
- Script resources loaded dynamically via page navigation

This comprehensive mapping shows how the XML object definitions create a rich, interconnected system where Lua scripts can dynamically control complex UI behaviors through well-defined object interfaces.