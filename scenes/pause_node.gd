extends Control

@onready var settingsPanel = $Settings
@onready var ResolutionOption = $Settings/OptionButton
@onready var FullscreenToggle = $Settings/CheckBox
@onready var VSyncToggle = $Settings/CheckBox2
@onready var mainPanel = $Main

#region Main Panel

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("ui_cancel"):
		match Input.mouse_mode:
			Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				get_tree().paused = true
				self.show()
			Input.MOUSE_MODE_VISIBLE:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				get_tree().paused = false
				self.hide()


func _unpause() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
	self.hide()

func _settings() -> void:
	mainPanel.hide()
	settingsPanel.show()

func _actually_quit() -> void:
	get_tree().quit()

#endregion

#region Settings

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
	settingsPanel.hide()
	mainPanel.show() 

#endregion
