class_name PlayerCharacter
extends CharacterBody3D

enum CharacterState {
	WALKING = 0,
	SPRINTING = 1,
	CROUCHING = 2
}

# All of the actually important stuff
@onready var head := $head
@onready var plrGUI := $PlayerGUI
@onready var InteractRaycast := $head/RayCast3D
@onready var camera := $head/Camera3D
@onready var animator := $AnimationPlayer
var currentBody : Interactible3D = null
var currentState : CharacterState = CharacterState.WALKING
@onready var SPEED = DEFAULT_SPEED # DEFAULT_SPEED doesn't load until _ready(), so we have to use @onready (you could also just move SPEED a bit to the bottom)

# Options
@export var DEFAULT_SPEED := 3
@export var JUMP_VELOCITY := 2.5
@export var mouse_sensitivity := 0.1
@export var SPRINT_SPEED := 3.5
@export var CROUCH_SPEED := 1.5
var inputEnabled := true # can the player move?
var aimlookEnabled := true # can the player look around?
var interactionsEnabled := true # can the player interact with Interactibles3D?

#region Main control flow 

func _ready():
	$MeshInstance3D.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GameManager.player = self

func _physics_process(delta: float) -> void:
	if !inputEnabled:
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED) 
	
	# All of the other processing functions go here
	_process_interact()
	_handle_states()
	
	move_and_slide()

#endregion

#region Processing input

func _process_interact():
	if !interactionsEnabled:
		return
	if not InteractRaycast.is_colliding():
		plrGUI.update_text("")
		return
	var collider = InteractRaycast.get_collider()
	if not collider is Interactible3D:
		plrGUI.update_text("")
		return
	if collider == currentBody and not Input.is_action_just_pressed("interact"): # This is a bit hacky imo, but works
		plrGUI.update_text(currentBody.InteractText)
		return
	
	currentBody = collider
	plrGUI.update_text(currentBody.InteractText)
	if Input.is_action_just_pressed("interact") && currentBody.CanInteract:
		currentBody.OnInteract.emit()

# Handles the mouse 🐁🐁🐁🐁🐁🐁🐁🐁
func _unhandled_input(event : InputEvent):
	if !aimlookEnabled:
		return
	
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var mouseInput : Vector2
		mouseInput.x += event.relative.x
		mouseInput.y += event.relative.y
		self.rotation_degrees.y -= mouseInput.x * mouse_sensitivity
		head.rotation_degrees.x -= mouseInput.y * mouse_sensitivity

#endregion

#region Processing Character States

## Handles the input for character state changing. 
func _handle_states():
	if Input.is_action_just_pressed("crouch"):
		if currentState == CharacterState.CROUCHING:
			change_state(CharacterState.WALKING)
		else:
			change_state(CharacterState.CROUCHING)
	elif Input.is_action_pressed("sprint"):
		if currentState == CharacterState.CROUCHING:
			return
		if currentState == CharacterState.SPRINTING:
			return
		change_state(CharacterState.SPRINTING)
	else:
		if currentState != CharacterState.WALKING and currentState != CharacterState.CROUCHING:
			change_state(CharacterState.WALKING)

## Handles the state changing itself. This function must be fired only once, and not run every single frame. 
func change_state(state : CharacterState):
	match state:
		CharacterState.CROUCHING:
			animator.play("crouch")
			SPEED = CROUCH_SPEED
		CharacterState.SPRINTING:
			SPEED = SPRINT_SPEED
			animator.play("sprint")
		CharacterState.WALKING:
			if currentState == CharacterState.CROUCHING:
				animator.play_backwards("crouch")
			elif currentState == CharacterState.SPRINTING:
				animator.play_backwards("sprint")
			SPEED = DEFAULT_SPEED
	
	currentState = state

#endregion
