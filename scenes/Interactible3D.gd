class_name Interactible3D
extends Area3D

## Base for all objects that player can interact with by pressing E (or some other button)

## Text that shows up when player hovers over the Interactible3D
@export var InteractText : String = "Press [E] to interact"

## Self-explanatory. If you have eyes, you know what it does.
@export var CanInteract : bool = true

## Emitted when player presses the "interact" action while glazing at this beautiful Interactible3D
signal OnInteract

## Override function. Called when OnInteract is fired. Does nothing, since you're supposed to override it
func _interact() -> void:
	pass

func _ready() -> void:
	OnInteract.connect(_interact.bind())
