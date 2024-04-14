class_name BuildingStorage
extends Building


@onready var info_bar: UIInfoBar = %InfoBar


func _ready() -> void:
	info_bar.set_health(health_current, health_max)
	info_bar.hide_capacity()


func take_damage(amount := 1) -> void:
	super()
	info_bar.set_health(health_current, health_max)
