extends Interactible3D

# i am lazy
@onready var cat = get_tree().get_root().get_node("Node3D/TestPlace/MeshInstance3D")
@onready var audioPlayer := $AudioStreamPlayer


func _interact():
	cat.show()
	audioPlayer.play()
	self.CanInteract = false
