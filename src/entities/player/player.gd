extends CharacterBody3D

@export var speed = 5.0
@export var jump_speed = 5.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera_node = $Camera/SpringArm3D/Camera3D

func _physics_process(delta: float) -> void:
		_handle_player_action(delta)

func _handle_player_action(delta: float) -> void:
	_handle_player_gravity(delta)
	_handle_player_deplacement()

func _handle_player_gravity(delta: float) -> void:
	if (not is_on_floor()):
		velocity.y -= gravity * delta

func _handle_player_deplacement() -> void:
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
	direction = direction.normalized()
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	if (Input.is_action_just_pressed("jump") and is_on_floor()):
		velocity.y = jump_speed
	move_and_slide()
