extends CharacterBody3D

@export var speed = 5.0

func _physics_process(delta: float) -> void:
	move_and_slide()
