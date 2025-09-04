#!/usr/bin/env python3
"""
Button Organization Tool for Battalion Wars 2 Menu System

This tool analyzes the XML GUI definitions and Lua navigation logic to create
a structured mapping of buttons and their logical paths through the menu system.
"""

import xml.etree.ElementTree as ET
import re
import json
import os
from pathlib import Path
from typing import Dict, List, Set, Optional, Tuple
from dataclasses import dataclass, asdict
from collections import defaultdict

@dataclass
class ButtonInfo:
    """Information about a button from XML definition"""
    id: str
    name: str
    object_type: str
    attributes: Dict[str, str]
    event_handlers: List[str]

@dataclass
class NavigationPath:
    """Information about a navigation path from Lua logic"""
    function_name: str
    source_file: str
    target_page: Optional[str]
    conditions: List[str]
    actions: List[str]

@dataclass
class MenuPage:
    """Information about a menu page"""
    name: str
    lua_file: str
    buttons: List[ButtonInfo]
    navigation_functions: List[NavigationPath]
    incoming_paths: List[str]
    outgoing_paths: List[str]

class ButtonOrganizer:
    """Main class for organizing buttons and navigation paths"""
    
    def __init__(self, repo_path: str):
        self.repo_path = Path(repo_path)
        self.buttons: Dict[str, ButtonInfo] = {}
        self.navigation_paths: Dict[str, NavigationPath] = {}
        self.pages: Dict[str, MenuPage] = {}
        self.xml_file = self.repo_path / "Frontend2_Level.xml"
        
    def parse_xml_buttons(self) -> None:
        """Parse XML file to extract button definitions"""
        print("Parsing XML file for button definitions...")
        
        if not self.xml_file.exists():
            print(f"Warning: XML file not found at {self.xml_file}")
            return
            
        try:
            tree = ET.parse(self.xml_file)
            root = tree.getroot()
            
            # Find all GUI button objects
            for obj in root.findall(".//Object[@type='cGUIButtonWidget']"):
                button_id = obj.get('id', 'unknown')
                button_name = f"Button_{button_id}"
                
                # Extract attributes
                attributes = {}
                for attr in obj.findall('Attribute'):
                    attr_name = attr.get('name', '')
                    attr_type = attr.get('type', '')
                    items = [item.text for item in attr.findall('Item') if item.text]
                    if items:
                        attributes[attr_name] = f"{attr_type}: {', '.join(items)}"
                
                # Extract event handlers
                event_handlers = []
                for pointer in obj.findall('Pointer[@name="mpEventHandler"]'):
                    items = [item.text for item in pointer.findall('Item') if item.text and item.text != '0']
                    event_handlers.extend(items)
                
                self.buttons[button_id] = ButtonInfo(
                    id=button_id,
                    name=button_name,
                    object_type='cGUIButtonWidget',
                    attributes=attributes,
                    event_handlers=event_handlers
                )
                
            print(f"Found {len(self.buttons)} buttons in XML")
            
        except ET.ParseError as e:
            print(f"Error parsing XML: {e}")
        except Exception as e:
            print(f"Unexpected error parsing XML: {e}")
    
    def parse_lua_navigation(self) -> None:
        """Parse Lua files to extract navigation logic"""
        print("Parsing Lua files for navigation logic...")
        
        lua_files = list(self.repo_path.glob("*.lua"))
        
        for lua_file in lua_files:
            try:
                with open(lua_file, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()
                
                # Extract goto functions
                goto_pattern = r'function\s+tableData\.(\w*goto\w*)\(\)'
                goto_matches = re.finditer(goto_pattern, content)
                
                for match in goto_matches:
                    func_name = match.group(1)
                    
                    # Find the function body
                    start_pos = match.end()
                    brace_count = 0
                    end_pos = start_pos
                    
                    # Simple function body extraction
                    lines = content[start_pos:].split('\n')
                    function_body = []
                    
                    for line in lines:
                        if 'end' in line and not line.strip().startswith('--'):
                            function_body.append(line.strip())
                            break
                        function_body.append(line.strip())
                    
                    # Extract target pages from PushPageStack calls
                    body_text = '\n'.join(function_body)
                    push_pattern = r'PushPageStack\("([^"]+)"\)'
                    push_matches = re.findall(push_pattern, body_text)
                    
                    target_page = push_matches[0] if push_matches else None
                    
                    # Extract conditions (if statements)
                    conditions = []
                    if_pattern = r'if\s+([^then]+)\s+then'
                    if_matches = re.findall(if_pattern, body_text)
                    conditions.extend([m.strip() for m in if_matches])
                    
                    # Extract actions (assignments, function calls)
                    actions = []
                    for line in function_body:
                        if ('=' in line and not line.strip().startswith('--') and 
                            'if' not in line and 'then' not in line and 'end' not in line):
                            actions.append(line.strip())
                    
                    path_key = f"{lua_file.stem}:{func_name}"
                    self.navigation_paths[path_key] = NavigationPath(
                        function_name=func_name,
                        source_file=lua_file.stem,
                        target_page=target_page,
                        conditions=conditions,
                        actions=actions
                    )
                
            except Exception as e:
                print(f"Error parsing {lua_file}: {e}")
        
        print(f"Found {len(self.navigation_paths)} navigation functions")
    
    def build_page_mapping(self) -> None:
        """Build mapping of pages and their relationships"""
        print("Building page mapping...")
        
        # Get all lua files that likely represent pages
        lua_files = list(self.repo_path.glob("*.lua"))
        
        for lua_file in lua_files:
            page_name = lua_file.stem
            
            # Find navigation functions for this page
            page_nav_functions = [
                path for key, path in self.navigation_paths.items()
                if path.source_file == page_name
            ]
            
            # Find buttons for this page (simplified - would need more complex mapping in real scenario)
            page_buttons = []
            
            # Find incoming and outgoing paths
            outgoing_paths = [path.target_page for path in page_nav_functions if path.target_page]
            incoming_paths = [
                path.source_file for path in self.navigation_paths.values()
                if path.target_page == page_name
            ]
            
            self.pages[page_name] = MenuPage(
                name=page_name,
                lua_file=lua_file.name,
                buttons=page_buttons,
                navigation_functions=page_nav_functions,
                incoming_paths=list(set(incoming_paths)),
                outgoing_paths=list(set(filter(None, outgoing_paths)))
            )
    
    def generate_report(self) -> Dict:
        """Generate a structured report of the button organization"""
        print("Generating report...")
        
        report = {
            'summary': {
                'total_buttons': len(self.buttons),
                'total_navigation_functions': len(self.navigation_paths),
                'total_pages': len(self.pages),
                'xml_file': str(self.xml_file.name),
                'lua_files_analyzed': len(list(self.repo_path.glob("*.lua")))
            },
            'buttons': [asdict(button) for button in self.buttons.values()],
            'navigation_paths': [asdict(path) for path in self.navigation_paths.values()],
            'pages': [asdict(page) for page in self.pages.values()],
            'navigation_graph': self._build_navigation_graph()
        }
        
        return report
    
    def _build_navigation_graph(self) -> Dict:
        """Build a graph representation of navigation flows"""
        graph = {
            'nodes': [],
            'edges': []
        }
        
        # Add page nodes
        for page_name, page in self.pages.items():
            graph['nodes'].append({
                'id': page_name,
                'label': page_name,
                'type': 'page',
                'function_count': len(page.navigation_functions),
                'button_count': len(page.buttons)
            })
        
        # Add navigation edges
        for path in self.navigation_paths.values():
            if path.target_page:
                graph['edges'].append({
                    'source': path.source_file,
                    'target': path.target_page,
                    'label': path.function_name,
                    'conditions': path.conditions,
                    'actions': path.actions
                })
        
        return graph
    
    def save_report(self, output_file: str = "button_organization_report.json") -> None:
        """Save the report to a JSON file"""
        report = self.generate_report()
        output_path = self.repo_path / output_file
        
        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(report, f, indent=2, ensure_ascii=False)
        
        print(f"Report saved to: {output_path}")
    
    def print_summary(self) -> None:
        """Print a summary of the analysis"""
        print("\n" + "="*60)
        print("BUTTON ORGANIZATION SUMMARY")
        print("="*60)
        
        print(f"📊 Analysis Results:")
        print(f"   • Total Buttons: {len(self.buttons)}")
        print(f"   • Navigation Functions: {len(self.navigation_paths)}")
        print(f"   • Menu Pages: {len(self.pages)}")
        
        print(f"\n🔍 Top Pages by Navigation Functions:")
        sorted_pages = sorted(
            self.pages.items(), 
            key=lambda x: len(x[1].navigation_functions), 
            reverse=True
        )[:5]
        
        for page_name, page in sorted_pages:
            print(f"   • {page_name}: {len(page.navigation_functions)} functions")
        
        print(f"\n🔗 Navigation Flow Examples:")
        for i, (key, path) in enumerate(list(self.navigation_paths.items())[:5]):
            arrow = "→" if path.target_page else "?"
            target = path.target_page or "unknown"
            print(f"   • {path.source_file} {arrow} {target} (via {path.function_name})")
        
        print(f"\n💡 Most Connected Pages:")
        connectivity = {}
        for page_name, page in self.pages.items():
            connectivity[page_name] = len(page.incoming_paths) + len(page.outgoing_paths)
        
        sorted_connectivity = sorted(connectivity.items(), key=lambda x: x[1], reverse=True)[:5]
        for page_name, connections in sorted_connectivity:
            print(f"   • {page_name}: {connections} connections")

def main():
    """Main function to run the button organizer"""
    repo_path = os.path.dirname(os.path.abspath(__file__))
    
    print("Battalion Wars 2 Menu - Button Organization Tool")
    print("=" * 50)
    
    organizer = ButtonOrganizer(repo_path)
    
    # Parse XML and Lua files
    organizer.parse_xml_buttons()
    organizer.parse_lua_navigation()
    organizer.build_page_mapping()
    
    # Generate and save report
    organizer.save_report()
    
    # Print summary
    organizer.print_summary()
    
    print(f"\n✅ Analysis complete! Check 'button_organization_report.json' for full details.")

if __name__ == "__main__":
    main()