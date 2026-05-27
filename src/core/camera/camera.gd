@tool 
extends Marker3D

@onready var spring_arm: SpringArm3D = $SpringArm3D

@export var camera_distance: float = 1.0:
	set(value):
		camera_distance = value
		if has_node("SpringArm3D"):
			$SpringArm3D.spring_length = value

func _ready() -> void:
	if spring_arm:
		spring_arm.spring_length = camera_distance
