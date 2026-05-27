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
	
	
	print("forward : ", forward)
	print("right : ", right)
	pass
