#!/usr/bin/env python3
"""
Button Visualizer for Battalion Wars 2 Menu System

This tool creates HTML reports and visual flowcharts to help organize and understand
the button structure and logical paths in the menu system.
"""

import json
import os
from pathlib import Path
from typing import Dict, List, Any
from datetime import datetime

class ButtonVisualizer:
    """Creates visual reports from button organization data"""
    
    def __init__(self, report_file: str = "button_organization_report.json"):
        self.report_file = Path(report_file)
        self.data = self._load_report()
        
    def _load_report(self) -> Dict[str, Any]:
        """Load the JSON report file"""
        if not self.report_file.exists():
            raise FileNotFoundError(f"Report file not found: {self.report_file}")
        
        with open(self.report_file, 'r', encoding='utf-8') as f:
            return json.load(f)
    
    def generate_html_report(self) -> str:
        """Generate a comprehensive HTML report"""
        html = f"""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Battalion Wars 2 - Button Organization Report</title>
    <style>
        body {{
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background: #f5f5f5;
        }}
        .header {{
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }}
        .summary-grid {{
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }}
        .summary-card {{
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
        }}
        .summary-number {{
            font-size: 2em;
            font-weight: bold;
            color: #667eea;
        }}
        .section {{
            background: white;
            margin-bottom: 20px;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }}
        .section-header {{
            background: #667eea;
            color: white;
            padding: 15px 20px;
            font-weight: bold;
            font-size: 1.1em;
        }}
        .section-content {{
            padding: 20px;
        }}
        .navigation-flow {{
            display: flex;
            align-items: center;
            margin-bottom: 10px;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 5px;
            border-left: 4px solid #667eea;
        }}
        .arrow {{
            margin: 0 10px;
            color: #667eea;
            font-weight: bold;
        }}
        .page-name {{
            background: #e7f0ff;
            padding: 2px 8px;
            border-radius: 15px;
            font-weight: bold;
            color: #0066cc;
        }}
        .function-name {{
            background: #fff2cc;
            padding: 2px 8px;
            border-radius: 15px;
            font-size: 0.9em;
            margin-left: 10px;
        }}
        .condition {{
            background: #ffe6e6;
            padding: 2px 8px;
            border-radius: 15px;
            font-size: 0.8em;
            margin: 2px;
            display: inline-block;
        }}
        .button-grid {{
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 15px;
        }}
        .button-card {{
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            background: #f9f9f9;
        }}
        .button-id {{
            font-family: monospace;
            background: #e1e1e1;
            padding: 2px 6px;
            border-radius: 3px;
            font-size: 0.9em;
        }}
        .page-list {{
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 15px;
        }}
        .page-card {{
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            background: #ffffff;
        }}
        .page-title {{
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
            font-size: 1.1em;
        }}
        .connections {{
            font-size: 0.9em;
            color: #666;
        }}
        .network-diagram {{
            text-align: center;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
            margin: 20px 0;
        }}
        .timestamp {{
            text-align: center;
            color: #666;
            font-size: 0.9em;
            margin-top: 30px;
        }}
        table {{
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }}
        th, td {{
            text-align: left;
            padding: 8px;
            border-bottom: 1px solid #ddd;
        }}
        th {{
            background-color: #f2f2f2;
            font-weight: bold;
        }}
        .search-box {{
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            margin-bottom: 15px;
            font-size: 16px;
        }}
    </style>
    <script>
        function filterPages() {{
            const input = document.getElementById('pageSearch');
            const filter = input.value.toLowerCase();
            const cards = document.getElementsByClassName('page-card');
            
            for (let i = 0; i < cards.length; i++) {{
                const title = cards[i].getElementsByClassName('page-title')[0];
                if (title.textContent.toLowerCase().indexOf(filter) > -1) {{
                    cards[i].style.display = "";
                }} else {{
                    cards[i].style.display = "none";
                }}
            }}
        }}
        
        function filterNavigations() {{
            const input = document.getElementById('navSearch');
            const filter = input.value.toLowerCase();
            const flows = document.getElementsByClassName('navigation-flow');
            
            for (let i = 0; i < flows.length; i++) {{
                if (flows[i].textContent.toLowerCase().indexOf(filter) > -1) {{
                    flows[i].style.display = "";
                }} else {{
                    flows[i].style.display = "none";
                }}
            }}
        }}
    </script>
</head>
<body>
    <div class="header">
        <h1>🎮 Battalion Wars 2 - Menu Navigation Analysis</h1>
        <p>Comprehensive analysis of button organization and logical paths</p>
    </div>
    
    <div class="summary-grid">
        <div class="summary-card">
            <div class="summary-number">{self.data['summary']['total_buttons']}</div>
            <div>Total Buttons</div>
        </div>
        <div class="summary-card">
            <div class="summary-number">{self.data['summary']['total_navigation_functions']}</div>
            <div>Navigation Functions</div>
        </div>
        <div class="summary-card">
            <div class="summary-number">{self.data['summary']['total_pages']}</div>
            <div>Menu Pages</div>
        </div>
        <div class="summary-card">
            <div class="summary-number">{self.data['summary']['lua_files_analyzed']}</div>
            <div>Lua Files Analyzed</div>
        </div>
    </div>
"""
        
        # Navigation flows section
        html += self._generate_navigation_flows_section()
        
        # Pages overview section  
        html += self._generate_pages_section()
        
        # Network diagram placeholder
        html += self._generate_network_diagram_section()
        
        # Navigation paths table
        html += self._generate_navigation_table()
        
        html += f"""
    <div class="timestamp">
        Report generated on {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
    </div>
</body>
</html>
"""
        return html
    
    def _generate_navigation_flows_section(self) -> str:
        """Generate the navigation flows section"""
        html = f"""
    <div class="section">
        <div class="section-header">🔗 Navigation Flows</div>
        <div class="section-content">
            <input type="text" id="navSearch" class="search-box" onkeyup="filterNavigations()" 
                   placeholder="Search navigation flows...">
"""
        
        # Group navigation paths by source page
        flows_by_page = {}
        for path in self.data['navigation_paths']:
            source = path['source_file']
            if source not in flows_by_page:
                flows_by_page[source] = []
            flows_by_page[source].append(path)
        
        # Display flows
        for source_page in sorted(flows_by_page.keys()):
            for path in flows_by_page[source_page]:
                target = path['target_page'] or 'Unknown'
                conditions_html = ''.join([f'<span class="condition">{cond}</span>' for cond in path['conditions']])
                
                html += f"""
            <div class="navigation-flow">
                <span class="page-name">{source_page}</span>
                <span class="arrow">→</span>
                <span class="page-name">{target}</span>
                <span class="function-name">{path['function_name']}</span>
                {f'<br><small>Conditions: {conditions_html}</small>' if conditions_html else ''}
            </div>
"""
        
        html += """
        </div>
    </div>
"""
        return html
    
    def _generate_pages_section(self) -> str:
        """Generate the pages overview section"""
        html = f"""
    <div class="section">
        <div class="section-header">📄 Menu Pages Overview</div>
        <div class="section-content">
            <input type="text" id="pageSearch" class="search-box" onkeyup="filterPages()" 
                   placeholder="Search pages...">
            <div class="page-list">
"""
        
        # Sort pages by number of navigation functions
        sorted_pages = sorted(
            self.data['pages'], 
            key=lambda x: len(x['navigation_functions']), 
            reverse=True
        )
        
        for page in sorted_pages:
            func_count = len(page['navigation_functions'])
            incoming_count = len(page['incoming_paths'])
            outgoing_count = len(page['outgoing_paths'])
            
            # Generate function list
            functions_html = ""
            if page['navigation_functions']:
                functions_html = "<br><strong>Functions:</strong><br>"
                for func in page['navigation_functions'][:5]:  # Show first 5
                    functions_html += f"• {func['function_name']}<br>"
                if len(page['navigation_functions']) > 5:
                    functions_html += f"... and {len(page['navigation_functions']) - 5} more"
            
            html += f"""
                <div class="page-card">
                    <div class="page-title">{page['name']}</div>
                    <div class="connections">
                        📝 {func_count} navigation functions<br>
                        ⬅️ {incoming_count} incoming paths<br>
                        ➡️ {outgoing_count} outgoing paths
                    </div>
                    {functions_html}
                </div>
"""
        
        html += """
            </div>
        </div>
    </div>
"""
        return html
    
    def _generate_network_diagram_section(self) -> str:
        """Generate network diagram section with placeholder"""
        graph = self.data['navigation_graph']
        
        html = f"""
    <div class="section">
        <div class="section-header">🌐 Navigation Network</div>
        <div class="section-content">
            <div class="network-diagram">
                <h3>Network Overview</h3>
                <p><strong>Nodes:</strong> {len(graph['nodes'])} pages</p>
                <p><strong>Edges:</strong> {len(graph['edges'])} navigation paths</p>
                <p><em>Interactive network diagram would be displayed here with a visualization library like D3.js or vis.js</em></p>
            </div>
        </div>
    </div>
"""
        return html
    
    def _generate_navigation_table(self) -> str:
        """Generate detailed navigation paths table"""
        html = f"""
    <div class="section">
        <div class="section-header">📋 Detailed Navigation Paths</div>
        <div class="section-content">
            <table>
                <thead>
                    <tr>
                        <th>Source Page</th>
                        <th>Function</th>
                        <th>Target Page</th>
                        <th>Conditions</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
"""
        
        for path in sorted(self.data['navigation_paths'], key=lambda x: x['source_file']):
            conditions = ', '.join(path['conditions']) if path['conditions'] else 'None'
            actions = ', '.join(path['actions'][:2]) if path['actions'] else 'None'  # Show first 2 actions
            if len(path['actions']) > 2:
                actions += '...'
            
            html += f"""
                    <tr>
                        <td>{path['source_file']}</td>
                        <td><code>{path['function_name']}</code></td>
                        <td>{path['target_page'] or 'Unknown'}</td>
                        <td><small>{conditions}</small></td>
                        <td><small>{actions}</small></td>
                    </tr>
"""
        
        html += """
                </tbody>
            </table>
        </div>
    </div>
"""
        return html
    
    def save_html_report(self, output_file: str = "button_organization_report.html") -> None:
        """Save the HTML report to file"""
        html_content = self.generate_html_report()
        
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(html_content)
        
        print(f"📄 HTML report saved to: {output_file}")
    
    def generate_flow_diagram(self) -> str:
        """Generate a text-based flow diagram"""
        print("\n🔄 MENU NAVIGATION FLOW DIAGRAM")
        print("=" * 50)
        
        # Find main entry points (pages with no incoming paths)
        entry_points = []
        all_targets = {path['target_page'] for path in self.data['navigation_paths'] if path['target_page']}
        
        for page in self.data['pages']:
            if page['name'] not in all_targets and page['navigation_functions']:
                entry_points.append(page['name'])
        
        diagram = "\n📍 Entry Points:\n"
        for entry in entry_points[:5]:  # Show top 5
            diagram += f"   • {entry}\n"
        
        diagram += "\n🔗 Main Navigation Paths:\n"
        
        # Group by source and show connections
        connections = {}
        for path in self.data['navigation_paths']:
            source = path['source_file']
            target = path['target_page'] or 'Unknown'
            func = path['function_name']
            
            if source not in connections:
                connections[source] = []
            connections[source].append((target, func))
        
        # Show top connected pages
        for source in sorted(connections.keys(), key=lambda x: len(connections[x]), reverse=True)[:10]:
            diagram += f"\n📄 {source}:\n"
            for target, func in connections[source][:3]:  # Show first 3 connections
                diagram += f"   ├─ {func}() → {target}\n"
            if len(connections[source]) > 3:
                diagram += f"   └─ ... and {len(connections[source]) - 3} more\n"
        
        return diagram

def main():
    """Main function to generate visual reports"""
    print("Battalion Wars 2 Menu - Button Visualizer")
    print("=" * 45)
    
    try:
        visualizer = ButtonVisualizer()
        
        # Generate HTML report
        visualizer.save_html_report()
        
        # Generate and print flow diagram
        flow_diagram = visualizer.generate_flow_diagram()
        print(flow_diagram)
        
        print(f"\n✅ Visualization complete!")
        print(f"   📄 Open 'button_organization_report.html' in your browser for the full interactive report")
        
    except FileNotFoundError as e:
        print(f"❌ Error: {e}")
        print("   Please run 'button_organizer.py' first to generate the data file")
    except Exception as e:
        print(f"❌ Unexpected error: {e}")

if __name__ == "__main__":
    main()