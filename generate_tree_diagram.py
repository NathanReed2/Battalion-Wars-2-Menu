#!/usr/bin/env python3
"""
Battalion Wars 2 Menu System Connection Tree Generator
Generates a visual representation of the system architecture and data flow
"""

import matplotlib.pyplot as plt
import matplotlib.patches as patches
from matplotlib.patches import FancyBboxPatch, ConnectionPatch
import numpy as np

def create_system_tree():
    fig, ax = plt.subplots(1, 1, figsize=(20, 24))
    ax.set_xlim(0, 20)
    ax.set_ylim(0, 24)
    ax.axis('off')
    
    # Color scheme
    colors = {
        'xml': '#FF6B6B',        # Red for XML
        'core': '#4ECDC4',       # Teal for core systems  
        'navigation': '#45B7D1',  # Blue for navigation
        'campaign': '#96CEB4',    # Green for campaign
        'multiplayer': '#FFEAA7', # Yellow for multiplayer
        'support': '#DDA0DD',     # Purple for support
        'dialog': '#F8BBD0',      # Pink for dialogs
        'audio': '#FFE0B2'        # Orange for audio/visual
    }
    
    # Title
    ax.text(10, 23, 'Battalion Wars 2 Menu System Architecture', 
            fontsize=24, fontweight='bold', ha='center')
    ax.text(10, 22.5, 'Connection Tree and Logical Flow Analysis', 
            fontsize=16, ha='center', style='italic')
    
    # Legend
    legend_y = 21.5
    legend_items = [
        ('XML Configuration', colors['xml']),
        ('Core Systems', colors['core']),
        ('Navigation', colors['navigation']),
        ('Campaign Systems', colors['campaign']),
        ('Multiplayer Systems', colors['multiplayer']),
        ('Support Systems', colors['support']),
        ('Dialog Systems', colors['dialog']),
        ('Audio/Visual', colors['audio'])
    ]
    
    for i, (label, color) in enumerate(legend_items):
        x_pos = 1 + (i % 4) * 4.5
        y_pos = legend_y - (i // 4) * 0.5
        rect = FancyBboxPatch((x_pos, y_pos-0.1), 0.3, 0.2, 
                             boxstyle="round,pad=0.02", 
                             facecolor=color, edgecolor='black', linewidth=0.5)
        ax.add_patch(rect)
        ax.text(x_pos + 0.4, y_pos, label, fontsize=10, va='center')
    
    # Level 1: XML Foundation
    xml_box = FancyBboxPatch((8, 19.5), 4, 1, boxstyle="round,pad=0.1",
                           facecolor=colors['xml'], edgecolor='black', linewidth=2)
    ax.add_patch(xml_box)
    ax.text(10, 20, 'Frontend2_Level.xml\n(Configuration Layer)', 
            fontsize=12, fontweight='bold', ha='center', va='center')
    
    # XML Components
    xml_components = [
        (6, 18.5, '528 Custom\nWidgets'),
        (8, 18.5, '434 Texture\nResources'),
        (10, 18.5, '95 Script\nResources'),
        (12, 18.5, '251 Event\nHandlers'),
        (14, 18.5, '55 3D Model\nArrays')
    ]
    
    for x, y, text in xml_components:
        box = FancyBboxPatch((x-0.7, y-0.3), 1.4, 0.6, boxstyle="round,pad=0.05",
                           facecolor=colors['xml'], edgecolor='black', alpha=0.7)
        ax.add_patch(box)
        ax.text(x, y, text, fontsize=9, ha='center', va='center')
        # Connect to main XML box
        ax.arrow(x, y+0.3, 0, 0.7, head_width=0.1, head_length=0.1, 
                fc='black', ec='black', alpha=0.6)
    
    # Level 2: Core Bridge Layer
    bridge_box = FancyBboxPatch((8, 16.5), 4, 1, boxstyle="round,pad=0.1",
                              facecolor=colors['core'], edgecolor='black', linewidth=2)
    ax.add_patch(bridge_box)
    ax.text(10, 17, 'EntityInitialise.lua\n(Reflection ID Bridge)', 
            fontsize=12, fontweight='bold', ha='center', va='center')
    
    # Connection from XML to Bridge
    ax.arrow(10, 19.4, 0, -1.8, head_width=0.2, head_length=0.2, 
            fc='red', ec='red', linewidth=3)
    
    # Level 3: Navigation Core
    nav_core = [
        (4, 15, 'PageStack.lua\n(Navigation Core)', colors['navigation']),
        (10, 15, 'Global.lua\n(State Management)', colors['core']),
        (16, 15, 'Main.lua\n(Entry Point)', colors['navigation'])
    ]
    
    for x, y, text, color in nav_core:
        box = FancyBboxPatch((x-1.2, y-0.4), 2.4, 0.8, boxstyle="round,pad=0.08",
                           facecolor=color, edgecolor='black', linewidth=1.5)
        ax.add_patch(box)
        ax.text(x, y, text, fontsize=11, fontweight='bold', ha='center', va='center')
        # Connect to bridge
        ax.arrow(x, y+0.4, 10-x, 1.6, head_width=0.1, head_length=0.1, 
                fc='gray', ec='gray', alpha=0.6)
    
    # Level 4: Main System Branches
    main_systems = [
        (2, 12.5, 'Campaign\nSystems', colors['campaign'], 2.5, 4),
        (7, 12.5, 'Multiplayer\nSystems', colors['multiplayer'], 3, 4),
        (12.5, 12.5, 'Support\nSystems', colors['support'], 2.5, 3),
        (16.5, 12.5, 'Dialog\nSystems', colors['dialog'], 2.5, 2.5),
        (1, 9, 'Audio/Visual\nSystems', colors['audio'], 2.5, 2)
    ]
    
    for x, y, text, color, width, height in main_systems:
        box = FancyBboxPatch((x-width/2, y-height/2), width, height, 
                           boxstyle="round,pad=0.1",
                           facecolor=color, edgecolor='black', linewidth=1.5, alpha=0.8)
        ax.add_patch(box)
        ax.text(x, y+height/2-0.3, text, fontsize=12, fontweight='bold', 
               ha='center', va='center')
    
    # Campaign System Details
    campaign_scripts = [
        'Campaign.lua (Base)',
        'CampaignAI.lua',
        'CampaignIL.lua', 
        'CampaignS.lua',
        'CampaignT.lua',
        'CampaignWF.lua',
        'CampaignBriefing.lua',
        'GlobeSelect.lua'
    ]
    
    for i, script in enumerate(campaign_scripts):
        y_pos = 11.5 - i * 0.4
        ax.text(2, y_pos, f'• {script}', fontsize=9, ha='center')
    
    # Multiplayer System Details  
    mp_scripts = [
        'Search.lua (Matching)',
        'Friendlist.lua',
        'Friend.lua',
        'Friendmatch.lua',
        'Profile.lua',
        'Gametype.lua',
        'Levels.lua',
        'ChooseArmy.lua',
        'Map.lua/Map2.lua',
        'MPLoading.lua'
    ]
    
    for i, script in enumerate(mp_scripts):
        y_pos = 11.5 - i * 0.35
        ax.text(7, y_pos, f'• {script}', fontsize=9, ha='center')
    
    # Support System Details
    support_scripts = [
        'GO.lua (Options)',
        'GO1.lua (Audio)',
        'GO2.lua (Video)', 
        'GO3.lua (Controls)',
        'Unlock.lua',
        'Victory.lua',
        'Defeat.lua',
        'Loading.lua'
    ]
    
    for i, script in enumerate(support_scripts):
        y_pos = 11.5 - i * 0.35
        ax.text(12.5, y_pos, f'• {script}', fontsize=9, ha='center')
    
    # Dialog System Details
    dialog_scripts = [
        'NANDDialog.lua',
        'YesNoDialog.lua',
        'Message.lua'
    ]
    
    for i, script in enumerate(dialog_scripts):
        y_pos = 11.5 - i * 0.4
        ax.text(16.5, y_pos, f'• {script}', fontsize=9, ha='center')
    
    # Audio/Visual Details
    av_scripts = [
        'Music.lua',
        'SpriteTravel.lua',
        'Backgrounds.lua',
        'FMV.lua'
    ]
    
    for i, script in enumerate(av_scripts):
        y_pos = 8.5 - i * 0.3
        ax.text(1, y_pos, f'• {script}', fontsize=9, ha='center')
    
    # Data Flow Arrows
    flow_connections = [
        (4, 14.6, 2, 12.5+2, 'Campaign Flow'),     # PageStack to Campaign
        (4, 14.6, 7, 12.5+2, 'MP Flow'),          # PageStack to Multiplayer  
        (10, 14.6, 12.5, 12.5+1.5, 'Support'),   # Global to Support
        (16, 14.6, 16.5, 12.5+1.25, 'Dialogs')   # Main to Dialogs
    ]
    
    for x1, y1, x2, y2, label in flow_connections:
        ax.annotate('', xy=(x2, y2), xytext=(x1, y1),
                   arrowprops=dict(arrowstyle='->', lw=2, color='darkblue'))
        mid_x, mid_y = (x1 + x2) / 2, (y1 + y2) / 2
        ax.text(mid_x, mid_y + 0.2, label, fontsize=8, ha='center', 
               bbox=dict(boxstyle="round,pad=0.2", facecolor='white', alpha=0.8))
    
    # Key Function Flow Box
    flow_box = FancyBboxPatch((5, 5.5), 10, 3, boxstyle="round,pad=0.2",
                            facecolor='lightgray', edgecolor='black', linewidth=2, alpha=0.9)
    ax.add_patch(flow_box)
    ax.text(10, 8, 'Key Function Flow Patterns', fontsize=14, fontweight='bold', ha='center')
    
    flow_patterns = [
        '1. User Input → Event Handler (XML) → Lua Function → State Change → UI Update',
        '2. Page Navigation: PushPageStack() → New Page Load → Widget Activation',
        '3. Campaign Flow: Main → Save Check → Tutorial/Map Selection → Mission Load',
        '4. Multiplayer Flow: Main → Profile Load → Matching → Game Launch',
        '5. Save System: NANDDialog → File Operations → Status Updates → Confirmation'
    ]
    
    for i, pattern in enumerate(flow_patterns):
        ax.text(5.2, 7.5 - i * 0.4, pattern, fontsize=10, ha='left')
    
    # XML Object Mapping Box
    mapping_box = FancyBboxPatch((5, 1.5), 10, 3.5, boxstyle="round,pad=0.2",
                               facecolor='lightyellow', edgecolor='black', linewidth=2, alpha=0.9)
    ax.add_patch(mapping_box)
    ax.text(10, 4.7, 'XML to Lua Object Mapping', fontsize=14, fontweight='bold', ha='center')
    
    mapping_examples = [
        'RegisterReflectionId() creates bridge between XML objects and Lua variables:',
        '',
        'GUI_Texture.Campaign_Grade_BG = RegisterReflectionId("780000704")',
        'GUI_Button.Main_Save = RegisterReflectionId("20002125")', 
        'GUI_Dialog_Box_0.ShowStatus = RegisterReflectionId("310002401")',
        '',
        'Usage in Scripts:',
        'StartWidget(tableData, GUI_Dialog_Box_0.ShowStatus, true)',
        'StopWidget(GUI_Dialog_Box_1.ShowStatus_animation)'
    ]
    
    for i, example in enumerate(mapping_examples):
        style = 'italic' if i in [0, 6] else 'normal'
        weight = 'bold' if i in [0, 6] else 'normal'
        ax.text(5.2, 4.3 - i * 0.25, example, fontsize=9, ha='left', 
               style=style, weight=weight)
    
    plt.tight_layout()
    return fig

def create_connection_diagram():
    """Create a detailed connection diagram showing object relationships"""
    fig, ax = plt.subplots(1, 1, figsize=(18, 12))
    ax.set_xlim(0, 18)
    ax.set_ylim(0, 12)
    ax.axis('off')
    
    ax.text(9, 11.5, 'Battalion Wars 2 Menu System - Object Connection Map', 
            fontsize=20, fontweight='bold', ha='center')
    
    # XML Objects Layer
    xml_objects = [
        (2, 9, 'cGUICustomWidget\n(528 instances)', '#FF6B6B'),
        (6, 9, 'cTextureResource\n(434 instances)', '#FF6B6B'),
        (10, 9, 'cGameScriptResource\n(95 instances)', '#FF6B6B'),
        (14, 9, 'cGUIEventHandler\n(251 instances)', '#FF6B6B')
    ]
    
    for x, y, text, color in xml_objects:
        box = FancyBboxPatch((x-1, y-0.5), 2, 1, boxstyle="round,pad=0.1",
                           facecolor=color, edgecolor='black', linewidth=1.5, alpha=0.8)
        ax.add_patch(box)
        ax.text(x, y, text, fontsize=10, ha='center', va='center', fontweight='bold')
    
    # Reflection ID Bridge
    bridge_box = FancyBboxPatch((7, 6.5), 4, 1, boxstyle="round,pad=0.1",
                              facecolor='#4ECDC4', edgecolor='black', linewidth=2)
    ax.add_patch(bridge_box)
    ax.text(9, 7, 'RegisterReflectionId()\nBridge Layer', 
            fontsize=12, fontweight='bold', ha='center', va='center')
    
    # Connection arrows from XML to bridge
    for x, y, _, _ in xml_objects:
        ax.arrow(x, y-0.5, 9-x, 6.5-y+0.5+0.5, head_width=0.2, head_length=0.2,
                fc='gray', ec='gray', alpha=0.7)
    
    # Lua Script Categories
    script_categories = [
        (3, 4, 'Navigation\nScripts', '#45B7D1', ['PageStack.lua', 'Main.lua']),
        (7, 4, 'Campaign\nScripts', '#96CEB4', ['Campaign.lua', 'CampaignAI.lua', 'GlobeSelect.lua']),
        (11, 4, 'Multiplayer\nScripts', '#FFEAA7', ['Search.lua', 'Friendlist.lua', 'Profile.lua']),
        (15, 4, 'Support\nScripts', '#DDA0DD', ['Global.lua', 'GO.lua', 'NANDDialog.lua'])
    ]
    
    for x, y, title, color, scripts in script_categories:
        # Main category box
        box = FancyBboxPatch((x-1.2, y-0.8), 2.4, 1.6, boxstyle="round,pad=0.1",
                           facecolor=color, edgecolor='black', linewidth=1.5, alpha=0.8)
        ax.add_patch(box)
        ax.text(x, y+0.5, title, fontsize=11, ha='center', va='center', fontweight='bold')
        
        # Script names
        for i, script in enumerate(scripts):
            ax.text(x, y - 0.2 - i*0.25, f'• {script}', fontsize=9, ha='center')
        
        # Connection from bridge to scripts
        ax.arrow(9, 6.4, x-9, 4.8-6.4, head_width=0.15, head_length=0.15,
                fc='darkblue', ec='darkblue', alpha=0.8)
    
    # Widget Usage Examples
    usage_box = FancyBboxPatch((1, 1), 16, 2, boxstyle="round,pad=0.2",
                             facecolor='lightgreen', edgecolor='black', linewidth=2, alpha=0.9)
    ax.add_patch(usage_box)
    ax.text(9, 2.7, 'Common Widget Usage Patterns', fontsize=14, fontweight='bold', ha='center')
    
    usage_examples = [
        'StartWidget(owner, GUI_Dialog_Box_0.ShowStatus, true) - Activate status dialog',
        'StopWidget(GUI_Dialog_Box_1.ShowStatus_animation) - Stop animation widget',
        'PlaySound(SoundID.UI_FE_Open) - Play UI sound effect',
        'PushPageStack("Search") - Navigate to search page'
    ]
    
    for i, example in enumerate(usage_examples):
        ax.text(1.5, 2.3 - i*0.3, f'• {example}', fontsize=10, ha='left')
    
    plt.tight_layout()
    return fig

if __name__ == "__main__":
    # Create the main system tree
    fig1 = create_system_tree()
    fig1.savefig('/home/runner/work/Battalion-Wars-2-Menu/Battalion-Wars-2-Menu/system_architecture_tree.png', 
                dpi=300, bbox_inches='tight', facecolor='white')
    
    # Create the connection diagram  
    fig2 = create_connection_diagram()
    fig2.savefig('/home/runner/work/Battalion-Wars-2-Menu/Battalion-Wars-2-Menu/object_connection_map.png',
                dpi=300, bbox_inches='tight', facecolor='white')
    
    print("Generated system architecture diagrams:")
    print("1. system_architecture_tree.png - Complete system tree")
    print("2. object_connection_map.png - Object connection mapping")