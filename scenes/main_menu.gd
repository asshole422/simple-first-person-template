extends Control

@onready var settings = $Settings
@onready var ResolutionOption = $Settings/OptionButton
@onready var FullscreenToggle = $Settings/CheckBox
@onready var VSyncToggle = $Settings/CheckBox2
@onready var buttons = $VBoxContainer



## This template does not supply loading screens, so you have to make one yourself
func _play() -> void:
	get_tree().change_scene_to_file("res://main.tscn")

## literally copied from game pause settings smh
func _settings() -> void:
	settings.show()
	buttons.hide()

func _quit() -> void:
	self.get_tree().quit()

#region Settings stolen from pause_node.gd

func _ready():
	for i in range(4):
		var text = ResolutionOption.get_item_text(i)
		var r = SettingsHandler._get_resolution_as_str()
		if text == r:
			ResolutionOption.selected = i
			break
	FullscreenToggle.button_pressed = SettingsHandler.SettingsDict["fullscreen"]
	VSyncToggle.button_pressed = SettingsHandler.SettingsDict["vsync"]

func _on_apply_settings() -> void:
	var resolution = ResolutionOption.get_item_text(ResolutionOption.selected)
	var fullscreen = FullscreenToggle.button_pressed
	var vsync = VSyncToggle.button_pressed
	resolution = resolution.split("x")
	resolution = [int(resolution[0]), int(resolution[1])]
	SettingsHandler.SettingsDict = {"resolution": resolution, "vsync": vsync, "fullscreen": fullscreen}
	
	SettingsHandler._apply_settings()
	SettingsHandler._save_settings()

func _on_close_button() -> void:
	settings.hide()
	buttons.show() 

#endregion
