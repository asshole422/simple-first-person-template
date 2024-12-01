extends Node

## Handles the settings file, applying settings everywhere, etc

var SettingsDict : Dictionary

const SETTINGS_FILE_PATH = "user://settings.sav"
const DEFAULT_SETTINGS = {"resolution": [1152, 648], "vsync": true, "fullscreen": false} # Settings that are set by default, in case if settings file does not exist

func _ready():
	await _load_settings()
	_apply_settings()

## Applies settings from SettingsDict
func _apply_settings():
	DisplayServer.window_set_size(Vector2(SettingsDict.resolution[0], SettingsDict.resolution[1]))
	if SettingsDict.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
	
	if SettingsDict.vsync:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

## Loads settings from settings file
func _load_settings():
	var file = FileAccess.open(SETTINGS_FILE_PATH, FileAccess.READ)
	if file == null:
		SettingsDict = DEFAULT_SETTINGS
		_save_settings()
		return
	SettingsDict = JSON.parse_string(file.get_as_text())

## Saves settings in settings file
func _save_settings():
	var file = FileAccess.open(SETTINGS_FILE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(SettingsDict))
	return
