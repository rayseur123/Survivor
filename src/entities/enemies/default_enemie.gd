extends CharacterBody3D
@export var speed = 2.0
@export var stop_distance = 2.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float) -> void:
	if not multiplayer.is_server():
		return
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var target = PlayerManager.get_nearest_player(global_position)
	if target:
		var distance = global_position.distance_to(target.global_position)
		if distance > stop_distance:
			var direction = (target.global_position - global_position).normalized()
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = 0
			velocity.z = 0
	
	move_and_slide()
