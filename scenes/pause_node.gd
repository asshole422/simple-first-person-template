extends Control

@onready var settingsPanel = $Settings
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

func _quit() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")

func _actually_quit() -> void:
	get_tree().quit()

func _on_close_button() -> void:
	settingsPanel.hide()
	mainPanel.show() 


#endregion
