extends SpringArm3D

@export var sensibility = 1000
const MAX_ROTATION_TOP = 85
const MAX_ROTATION_BOT = -85

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x / sensibility
		rotation.x -= event.relative.y / sensibility
		rotation.x = clamp(rotation.x, deg_to_rad(MAX_ROTATION_BOT), deg_to_rad(MAX_ROTATION_TOP))
