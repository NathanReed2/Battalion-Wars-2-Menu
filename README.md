# Battalion Wars 2 Menu - Button Organization Tools

A comprehensive toolkit for analyzing and organizing the button structure and logical navigation paths in the Battalion Wars 2 menu system.

## Overview

This toolkit provides three main tools to help understand and organize the complex menu navigation system:

1. **Button Organizer** (`button_organizer.py`) - Analyzes XML and Lua files to extract button definitions and navigation logic
2. **Button Visualizer** (`button_visualizer.py`) - Creates visual HTML reports and flow diagrams  
3. **Menu CLI** (`menu_cli.py`) - Command-line interface for interactive analysis

## Features

- 📊 **Complete Analysis**: Extracts 213+ buttons and 148+ navigation functions from XML and Lua files
- 🔗 **Navigation Mapping**: Maps logical paths between 96+ menu pages
- 📄 **Multiple Output Formats**: JSON data, HTML reports, and command-line interface
- 🔍 **Search & Filter**: Find specific navigation patterns and analyze individual pages
- 📈 **Visual Reports**: Interactive HTML reports with search and filtering capabilities

## Quick Start

### 1. Run Full Analysis

```bash
# Analyze all files and generate reports
python3 menu_cli.py analyze

# This generates:
# - button_organization_report.json (raw data)
# - button_organization_report.html (interactive report)
```

### 2. Search Navigation Patterns

```bash
# Search for specific navigation functions
python3 menu_cli.py search "goto"
python3 menu_cli.py search "Save"
python3 menu_cli.py search "Main"
```

### 3. Analyze Specific Pages

```bash
# Get detailed analysis of a specific page
python3 menu_cli.py page Main
python3 menu_cli.py page ExtrasPre
python3 menu_cli.py page Map2
```

### 4. List All Pages

```bash
# List pages sorted by different criteria
python3 menu_cli.py list --sort functions    # By function count
python3 menu_cli.py list --sort connections  # By total connections
python3 menu_cli.py list --sort name         # Alphabetically
```

## Tool Details

### Button Organizer (`button_organizer.py`)

**Purpose**: Core analysis engine that parses XML GUI definitions and Lua navigation logic.

**Key Features**:
- Extracts button definitions from `Frontend2_Level.xml`
- Parses navigation functions from all `.lua` files  
- Identifies page relationships and navigation flows
- Generates structured JSON report with complete data

**Usage**:
```bash
python3 button_organizer.py
```

**Output**: `button_organization_report.json`

### Button Visualizer (`button_visualizer.py`)

**Purpose**: Creates visual representations and user-friendly reports.

**Key Features**:
- Generates interactive HTML report with search and filtering
- Creates text-based flow diagrams
- Provides navigation network overview
- Displays detailed page relationships

**Usage**:
```bash
python3 button_visualizer.py
```

**Output**: `button_organization_report.html`

### Menu CLI (`menu_cli.py`)

**Purpose**: Command-line interface for interactive analysis and querying.

**Available Commands**:

| Command | Description | Example |
|---------|-------------|---------|
| `analyze` | Run full analysis | `python3 menu_cli.py analyze` |
| `search <pattern>` | Search navigation patterns | `python3 menu_cli.py search "goto"` |
| `page <name>` | Analyze specific page | `python3 menu_cli.py page Main` |
| `list [--sort]` | List all pages | `python3 menu_cli.py list --sort functions` |

## File Structure

```
Battalion-Wars-2-Menu/
├── Frontend2_Level.xml          # GUI object definitions
├── *.lua                        # Menu logic and navigation
├── button_organizer.py          # Core analysis tool
├── button_visualizer.py         # Visualization tool  
├── menu_cli.py                  # Command-line interface
├── button_organization_report.json  # Generated data
├── button_organization_report.html # Generated HTML report
└── README.md                    # This file
```

## Analysis Results Summary

The tools have analyzed the complete Battalion Wars 2 menu system and found:

- **213 GUI Buttons** defined in XML
- **148 Navigation Functions** across Lua files  
- **96 Menu Pages** with various connection patterns
- **Complex Navigation Network** with multiple entry points and interconnected flows

### Key Findings

**Most Connected Pages**:
- `Map2`: 7 connections (main campaign selection hub)
- `CampaignBriefing`: 5 connections (central briefing system)
- `Main`: 4 connections (main menu entry point)
- `GO`: 4 connections (game options hub)
- `Play`: 4 connections (gameplay mode selection)

**Top Pages by Navigation Functions**:
- `ExtrasPre`: 13 functions (extras menu system)
- `FriendMatchPre`: 10 functions (multiplayer friend matching)
- `MapPre`: 10 functions (map selection interface)
- `Profile2Pre`: 9 functions (profile management)
- `GOPre`: 8 functions (game options interface)

**Main Navigation Flow**:
```
Start → Main → [Save/MP/GO/Extras]
         ↓
    Map2 → Campaign[S/WF/AI/IL/T]
         ↓  
    CampaignBriefing → Game
```

## Understanding the Menu System

### XML Structure
The `Frontend2_Level.xml` file defines GUI objects including:
- `cGUIButtonWidget`: Interactive buttons
- `cGUIPage`: Menu page containers  
- `cGUIEventHandler`: Event handling logic
- Various other GUI elements with positioning and styling

### Lua Logic
Each `.lua` file typically represents a menu page and contains:
- Navigation functions (e.g., `gotoSave()`, `gotoMP()`)
- Page stack management (`PushPageStack()`, `PopPageStack()`)
- Conditional logic for button availability
- Animation and visual effect controls

### Navigation Patterns
Common navigation patterns found:
- **goto Functions**: Direct page transitions
- **Conditional Navigation**: Different paths based on game state
- **Page Stack System**: Hierarchical menu navigation
- **Return Paths**: Back button and menu exit handling

## Extending the Tools

### Adding New Analysis Features

1. **Button Mapping**: Enhance XML parsing to better map buttons to Lua functions
2. **Visual Network Graphs**: Add D3.js or vis.js for interactive network diagrams
3. **Dead Code Detection**: Identify unused navigation functions
4. **Path Optimization**: Suggest improvements to navigation efficiency

### Custom Analysis Scripts

The JSON output can be used with custom scripts:

```python
import json

# Load analysis data
with open('button_organization_report.json', 'r') as f:
    data = json.load(f)

# Custom analysis example
pages = data['pages']
high_function_pages = [p for p in pages if len(p['navigation_functions']) > 5]
print(f"Found {len(high_function_pages)} complex pages")
```

## Troubleshooting

### Common Issues

**"Report file not found"**: Run `python3 menu_cli.py analyze` first to generate the data file.

**"XML parsing errors"**: Ensure `Frontend2_Level.xml` is present and properly formatted.

**"Missing navigation targets"**: Some functions may have dynamic targets that require runtime analysis.

### Requirements

- Python 3.6+
- Standard library modules (no external dependencies required)
- Access to the Battalion Wars 2 menu source files

## License

This tool is designed for analyzing the Battalion Wars 2 menu system structure. It reads and analyzes existing files without modifying the game logic.

---

*Generated by the Battalion Wars 2 Menu Button Organization Toolkit*