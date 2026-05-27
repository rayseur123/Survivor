extends SpringArm3D

@export var sensibility = 1000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x / sensibility
		rotation.x -= event.relative.y / sensibility
