extends Panel

## Settings panel that does settings things

@onready var ResolutionOption = $OptionButton
@onready var FullscreenToggle = $CheckBox
@onready var VSyncToggle = $CheckBox2
@onready var AudioSlider = $HSlider

signal Closing

func _ready():
	# yeahhhh this is probably not the best way to do this
	for i in range(4):
		var text = ResolutionOption.get_item_text(i)
		var r = SettingsHandler._get_resolution_as_str()
		if text == r:
			ResolutionOption.selected = i
			break
	FullscreenToggle.button_pressed = SettingsHandler.get_value("fullscreen")
	VSyncToggle.button_pressed = SettingsHandler.get_value("vsync")
	AudioSlider.value = SettingsHandler.get_value("volume")

func _on_apply_settings() -> void:
	var resolution = ResolutionOption.get_item_text(ResolutionOption.selected)
	var fullscreen = FullscreenToggle.button_pressed
	var vsync = VSyncToggle.button_pressed
	resolution = resolution.split("x")
	resolution = [int(resolution[0]), int(resolution[1])]
	SettingsHandler.SettingsDict = {"resolution": resolution, "vsync": vsync, "fullscreen": fullscreen, "volume": AudioSlider.value}
	
	SettingsHandler._apply_settings()
	SettingsHandler._save_settings()

func _on_close():
	Closing.emit()
	self.hide()
