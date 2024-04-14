class_name UIInfoBar
extends PanelContainer


@export var label_health_template_text: String = "Health: %s / %s"
@export var label_capacity_template_text: String = "Capacity: %s / %s"

@onready var label_health: Label = %LabelHealth
@onready var label_capacity: Label = %LabelCapacity


func set_health(current: int, max: int) -> void:
	label_health.text = label_health_template_text % [current, max]


func set_capacity(current: int, max: int) -> void:
	label_capacity.text = label_capacity_template_text % [current, max]


func hide_capacity() -> void:
	label_capacity.hide()
