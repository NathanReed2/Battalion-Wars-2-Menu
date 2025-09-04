#!/usr/bin/env python3
"""
Menu Navigation CLI Tool for Battalion Wars 2

A command-line interface for analyzing and organizing button navigation
in the Battalion Wars 2 menu system.
"""

import argparse
import sys
import os
from pathlib import Path
from button_organizer import ButtonOrganizer
from button_visualizer import ButtonVisualizer

def run_full_analysis(args):
    """Run complete analysis and generate all reports"""
    print("🔍 Running full analysis...")
    
    # Run button organizer
    organizer = ButtonOrganizer(args.path)
    organizer.parse_xml_buttons()
    organizer.parse_lua_navigation()  
    organizer.build_page_mapping()
    organizer.save_report()
    organizer.print_summary()
    
    # Run visualizer
    print("\n" + "="*50)
    visualizer = ButtonVisualizer()
    visualizer.save_html_report()
    flow_diagram = visualizer.generate_flow_diagram()
    print(flow_diagram)
    
    print(f"\n✅ Full analysis complete!")
    print(f"   📄 JSON report: button_organization_report.json")
    print(f"   🌐 HTML report: button_organization_report.html")

def search_navigation(args):
    """Search for specific navigation patterns"""
    print(f"🔍 Searching for navigation patterns: '{args.pattern}'")
    
    if not Path("button_organization_report.json").exists():
        print("❌ Report file not found. Run full analysis first.")
        return
    
    visualizer = ButtonVisualizer()
    data = visualizer.data
    
    pattern = args.pattern.lower()
    found_paths = []
    
    # Search in navigation paths
    for path in data['navigation_paths']:
        if (pattern in path['function_name'].lower() or
            pattern in path['source_file'].lower() or
            (path['target_page'] and pattern in path['target_page'].lower())):
            found_paths.append(path)
    
    if found_paths:
        print(f"\n📋 Found {len(found_paths)} matching navigation paths:")
        for path in found_paths:
            target = path['target_page'] or 'Unknown'
            print(f"   • {path['source_file']} → {target} (via {path['function_name']})")
            if path['conditions']:
                print(f"     Conditions: {', '.join(path['conditions'])}")
    else:
        print(f"❌ No navigation paths found matching '{args.pattern}'")

def analyze_page(args):
    """Analyze a specific page in detail"""
    print(f"🔍 Analyzing page: '{args.page}'")
    
    if not Path("button_organization_report.json").exists():
        print("❌ Report file not found. Run full analysis first.")
        return
    
    visualizer = ButtonVisualizer()
    data = visualizer.data
    
    # Find the page
    target_page = None
    for page in data['pages']:
        if page['name'].lower() == args.page.lower():
            target_page = page
            break
    
    if not target_page:
        print(f"❌ Page '{args.page}' not found")
        print("Available pages:")
        for page in sorted(data['pages'], key=lambda x: x['name'])[:10]:
            print(f"   • {page['name']}")
        print("   ... and more")
        return
    
    print(f"\n📄 Page Details: {target_page['name']}")
    print("="*50)
    print(f"📝 File: {target_page['lua_file']}")
    print(f"🔗 Navigation Functions: {len(target_page['navigation_functions'])}")
    print(f"⬅️ Incoming Paths: {len(target_page['incoming_paths'])}")
    print(f"➡️ Outgoing Paths: {len(target_page['outgoing_paths'])}")
    
    if target_page['navigation_functions']:
        print(f"\n🎯 Navigation Functions:")
        for func in target_page['navigation_functions']:
            target = func['target_page'] or 'Unknown'
            print(f"   • {func['function_name']}() → {target}")
            if func['conditions']:
                print(f"     Conditions: {', '.join(func['conditions'])}")
            if func['actions']:
                print(f"     Actions: {', '.join(func['actions'][:3])}")
    
    if target_page['incoming_paths']:
        print(f"\n⬅️ Incoming From:")
        for incoming in target_page['incoming_paths']:
            print(f"   • {incoming}")
    
    if target_page['outgoing_paths']:
        print(f"\n➡️ Outgoing To:")
        for outgoing in target_page['outgoing_paths']:
            print(f"   • {outgoing}")

def list_pages(args):
    """List all pages with summary information"""
    if not Path("button_organization_report.json").exists():
        print("❌ Report file not found. Run full analysis first.")
        return
    
    visualizer = ButtonVisualizer()
    data = visualizer.data
    
    print(f"📄 All Menu Pages ({len(data['pages'])} total)")
    print("="*60)
    
    # Sort by various criteria based on args
    if args.sort == 'name':
        sorted_pages = sorted(data['pages'], key=lambda x: x['name'])
    elif args.sort == 'functions':
        sorted_pages = sorted(data['pages'], key=lambda x: len(x['navigation_functions']), reverse=True)
    elif args.sort == 'connections':
        sorted_pages = sorted(data['pages'], key=lambda x: len(x['incoming_paths']) + len(x['outgoing_paths']), reverse=True)
    else:
        sorted_pages = data['pages']
    
    for page in sorted_pages:
        func_count = len(page['navigation_functions'])
        in_count = len(page['incoming_paths'])
        out_count = len(page['outgoing_paths'])
        total_connections = in_count + out_count
        
        print(f"{page['name']:<20} | Functions: {func_count:>2} | In: {in_count:>2} | Out: {out_count:>2} | Total: {total_connections:>2}")

def main():
    """Main CLI function"""
    parser = argparse.ArgumentParser(
        description="Battalion Wars 2 Menu Navigation Analysis Tool",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python menu_cli.py analyze                    # Run full analysis
  python menu_cli.py search "goto"              # Search for navigation patterns
  python menu_cli.py page Main                  # Analyze Main page in detail
  python menu_cli.py list --sort functions      # List pages sorted by function count
        """
    )
    
    subparsers = parser.add_subparsers(dest='command', help='Available commands')
    
    # Full analysis command
    analyze_parser = subparsers.add_parser('analyze', help='Run full analysis and generate reports')
    analyze_parser.add_argument('--path', default='.', help='Path to repository (default: current directory)')
    
    # Search command
    search_parser = subparsers.add_parser('search', help='Search for navigation patterns')
    search_parser.add_argument('pattern', help='Pattern to search for in navigation functions')
    
    # Page analysis command
    page_parser = subparsers.add_parser('page', help='Analyze a specific page in detail')
    page_parser.add_argument('page', help='Name of the page to analyze')
    
    # List pages command
    list_parser = subparsers.add_parser('list', help='List all pages with summary')
    list_parser.add_argument('--sort', choices=['name', 'functions', 'connections'], 
                           default='name', help='Sort criteria for pages')
    
    args = parser.parse_args()
    
    if not args.command:
        parser.print_help()
        return
    
    print("🎮 Battalion Wars 2 - Menu Navigation CLI")
    print("="*45)
    
    try:
        if args.command == 'analyze':
            run_full_analysis(args)
        elif args.command == 'search':
            search_navigation(args)
        elif args.command == 'page':
            analyze_page(args)
        elif args.command == 'list':
            list_pages(args)
    except KeyboardInterrupt:
        print("\n❌ Operation cancelled by user")
    except Exception as e:
        print(f"❌ Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()