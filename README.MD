# Godot Plugin Refresh Tool

[![Godot 4.x](https://img.shields.io/badge/Godot-4.x-%23478cbf)](https://godotengine.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![GitHub last commit](https://img.shields.io/github/last-commit/lithiumfury/PluginRefreshTool)](https://github.com/lithiumfury/PluginRefreshTool/commits/main)
[![GitHub Release](https://img.shields.io/github/release/lithiumfury/PluginRefreshTool)](https://github.com/lithiumfury/PluginRefreshTool/releases/latest)

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/X8X8O42I7)

A type-safe, simplified plugin refresh tool for Godot 4, inspired by [willnationsdev's Godot Plugin Refresher](https://github.com/willnationsdev/godot-plugin-refresher).

I disabled *ignoring* the `addons` folder while developing a plugin. Bad idea—my strict GDScript settings then enforced type checks on third-party plugins, causing errors that locked my workflow.

## Getting Started

## Installation

1. Download the [latest release](https://github.com/lithiumfury/PluginRefreshTool/releases/latest/)
2. Extract to `res://addons/PluginRefreshTool/`
3. Enable in **Project → Project Settings → Plugins**

**Alternatively**
You can search for `PluginRefreshTool` in the **AssetLib** tab within **Godot's editor**
or in **https://godotengine.org/asset-library/asset** if I uploaded the plugin to the asset library.

## Features

- **One-click plugin refreshing**
- **Auto-detects all installed plugins**
- **Handles duplicate plugin names**
- **Confirmation for disabled plugins**
- **Type-safe implementation**

## Changelog

See [CHANGELOG.MD](CHANGELOG.MD) for details.

## Usage

1. The tool appears in the editor toolbar
2. Select a plugin from the dropdown
3. Click the refresh button (circular arrow)
4. Confirm if refreshing a disabled plugin

## Compatibility

- Godot 4.0+
- Tested on Windows

## License

MIT License - See [LICENSE](LICENSE) file

---

**Note**: This is a rewritten version focused on stability and type safety, not a fork of the original project.

