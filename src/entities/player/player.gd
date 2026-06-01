extends CharacterBody3D

@export var speed = 5.0
@export var jump_speed = 5.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var camera_node

func _enter_tree() -> void:
	set_multiplayer_authority(str(name).to_int())

func _ready() -> void:
	camera_node = $Camera/SpringArm3D/Camera3D
	if not is_multiplayer_authority():
		camera_node.current = false 
		return	
	camera_node.current = true

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		return
	_handle_player_action(delta)

func _handle_player_action(delta: float) -> void:
	_handle_player_gravity(delta)
	_handle_player_deplacement()
	move_and_slide()

func _handle_player_gravity(delta: float) -> void:
	if (not is_on_floor()):
		velocity.y -= gravity * delta

func _handle_player_deplacement() -> void:
	if not camera_node:
		return
	
	var forward = -camera_node.global_transform.basis.z
	var right = camera_node.global_transform.basis.x
	forward.y = 0
	right.y = 0
	
	var direction = Vector3.ZERO
	if (Input.is_action_pressed("move_forward")):
		direction += forward
	if (Input.is_action_pressed("move_backward")):
		direction += -forward
	if (Input.is_action_pressed("move_right")):
		direction += right
	if (Input.is_action_pressed("move_left")):
		direction += -right
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = 0
		velocity.z = 0
	if (Input.is_action_just_pressed("jump") and is_on_floor()):
		velocity.y = jump_speed
