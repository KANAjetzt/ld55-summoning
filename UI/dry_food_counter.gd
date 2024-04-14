extends HBoxContainer


@onready var label: Label = %Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.dry_food_count_changed.connect(update_dry_food_counter)
	update_dry_food_counter(Global.dry_food_count)


func update_dry_food_counter(dry_food_count: int) -> void:
	label.text = str(dry_food_count)
