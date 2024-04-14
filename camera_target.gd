extends Node2D


@export var speed := 1000
@export_range(0.0, 10.0, 0.01) var speed_multiplier := 1.0


func _process(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "top", "bottom")
	if not direction == Vector2.ZERO:
		position += direction * speed * speed_multiplier * delta
