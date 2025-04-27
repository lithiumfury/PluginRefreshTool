@tool
extends EditorPlugin

const ADDONS_PATH: String = "res://addons/"
const PLUGIN_NAME: String = "Plugin Refresh"
const CONTAINER: int = EditorPlugin.CONTAINER_TOOLBAR

class PluginInfo extends RefCounted:
		var name: String
		var dir_name: String
		var path: String
		
		func _init(p_name: String, p_dir_name: String, p_path: String) -> void:
				name = p_name
				dir_name = p_dir_name
				path = p_path


var toolbar: HBoxContainer = HBoxContainer.new()
var plugin_dropdown: OptionButton = OptionButton.new()
var refresh_button: Button = Button.new()
var confirmation_dialog: ConfirmationDialog = ConfirmationDialog.new()


var plugins_data: Array[PluginInfo] = []

func _enter_tree() -> void:
		setup_ui()
		load_plugins()
		var filesystem: EditorFileSystem = EditorInterface.get_resource_filesystem()
		filesystem.filesystem_changed.connect(load_plugins)

func _exit_tree() -> void:
		if is_instance_valid(toolbar):
				remove_control_from_container(CONTAINER, toolbar)
				toolbar.queue_free()

func setup_ui() -> void:
		plugin_dropdown.custom_minimum_size = Vector2(200, 0)
		plugin_dropdown.tooltip_text = "Select plugin to refresh"
		toolbar.add_child(plugin_dropdown)
		
		refresh_button.icon = get_editor_icon("Reload")
		refresh_button.tooltip_text = "Refresh selected plugin"
		refresh_button.pressed.connect(_on_refresh_requested)
		toolbar.add_child(refresh_button)
		
		confirmation_dialog.confirmed.connect(_on_refresh_confirmed)
		confirmation_dialog.title = "Plugin Refresh"
		toolbar.add_child(confirmation_dialog)
		
		add_control_to_container(CONTAINER, toolbar)

func get_editor_icon(icon_name: String) -> Texture2D:
		return EditorInterface.get_editor_theme().get_icon(icon_name, "EditorIcons")

func load_plugins() -> void:
		plugins_data.clear()
		var dir: DirAccess = DirAccess.open(ADDONS_PATH)
		if not dir:
				push_error("Failed to access addons directory")
				return
		
		var err: Error = dir.list_dir_begin()
		if err != OK:
				push_error("Failed to list addons directory: Error %s" % error_string(err))
				return
		
		var addon_dir: String = dir.get_next()
		while addon_dir != "":
				if dir.current_is_dir() and not addon_dir.begins_with("."):
						process_plugin_dir(addon_dir)
				addon_dir = dir.get_next()
		
		update_dropdown()

func process_plugin_dir(dir_name: String) -> void:
		var cfg_path: String = ADDONS_PATH.path_join(dir_name).path_join("plugin.cfg")
		if not FileAccess.file_exists(cfg_path):
				return
		
		var cfg: ConfigFile = ConfigFile.new()
		var err: Error = cfg.load(cfg_path)
		if err != OK:
				push_error("Failed to load plugin config at %s: Error %s" % [cfg_path, error_string(err)])
				return
		
		var plugin_name: String = cfg.get_value("plugin", "name", "")
		if plugin_name != PLUGIN_NAME: # Explicitly skip self
				plugins_data.append(PluginInfo.new(plugin_name, dir_name, cfg_path))


func update_dropdown() -> void:
		plugin_dropdown.clear()

		plugins_data.sort_custom(_sort_plugins)

		var name_counts: Dictionary = {}
		for plugin: PluginInfo in plugins_data:
				name_counts[plugin.name] = name_counts.get(plugin.name, 0) + 1
		
		for i: int in plugins_data.size():
				var plugin: PluginInfo = plugins_data[i]
				var display_name: String = plugin.name
				if name_counts[plugin.name] > 1:
						display_name += " (%s)" % plugin.dir_name
				
				plugin_dropdown.add_item(display_name, i)
				plugin_dropdown.set_item_metadata(i, plugin.path)
		

func _sort_plugins(a: PluginInfo, b: PluginInfo) -> bool:
		return a.name.to_lower() < b.name.to_lower()

func _on_refresh_requested() -> void:
		var selected_idx: int = plugin_dropdown.selected
		if selected_idx == -1:
			return
		
		var plugin_path: String = plugin_dropdown.get_item_metadata(selected_idx)

		if not EditorInterface.is_plugin_enabled(plugin_path):
				confirmation_dialog.dialog_text = "Plugin is disabled. Enable and refresh?"
				confirmation_dialog.popup_centered()
		else:
				refresh_plugin(plugin_path)

func _on_refresh_confirmed() -> void:
		var selected_idx: int = plugin_dropdown.selected
		if selected_idx != -1:
				var plugin_path: String = plugin_dropdown.get_item_metadata(selected_idx)
				refresh_plugin(plugin_path)

func refresh_plugin(plugin_path: String) -> void:
	if EditorInterface.is_plugin_enabled(plugin_path):
		EditorInterface.set_plugin_enabled(plugin_path, false)
	EditorInterface.set_plugin_enabled(plugin_path, true)
	print("Refreshed plugin: %s" % plugin_path.get_slice("/", 3))
