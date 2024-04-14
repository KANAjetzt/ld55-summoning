class_name UIInfoBar
extends PanelContainer


@onready var label_health: Label = %LabelHealth
@onready var label_capacity: Label = %LabelCapacity


func set_health(current: int, max: int) -> void:
	label_health.text = label_health.text % [current, max]


func set_capacity(current: int, max: int) -> void:
	label_capacity.text = label_capacity.text % [current, max]


func hide_capacity() -> void:
	label_capacity.hide()
