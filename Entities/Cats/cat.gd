class_name Cat
extends Entity


var just_exited_area := false:
	set(new_value):
		just_exited_area = new_value
		if just_exited_area:
			await get_tree().create_timer(0.1).timeout
			just_exited_area = false

@onready var animation_player: AnimationPlayer = %AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
