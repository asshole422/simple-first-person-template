extends Control

@onready var settings = $Settings
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

func _on_close_button() -> void:
	settings.hide()
	buttons.show() 
