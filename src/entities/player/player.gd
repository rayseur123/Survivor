extends CharacterBody3D

const SPEED = 5.0

@onready var camera_node = $Camera/SpringArm3D/Camera3D

func _physics_process(delta: float) -> void:
		_handle_player_action(delta)

func _handle_player_action(delta: float) -> void:
	_handle_player_deplacement(delta)
	
func _handle_player_deplacement(delta: float) -> void:
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
	velocity = direction.normalized() * SPEED
	move_and_slide()
	pass
