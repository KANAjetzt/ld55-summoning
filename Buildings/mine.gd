class_name BuildingMine
extends Building


signal entered(capacity_current)

@export var capacity_max := 3

@onready var info_bar: UIInfoBar = %InfoBar

var capacity_current := 0


func _ready() -> void:
	info_bar.set_health(health_current, health_max)
	info_bar.set_capacity(capacity_current, capacity_max)


func take_damage(amount := 1) -> void:
	super()
	info_bar.set_health(health_current, health_max)


func enter() -> bool:
	if capacity_current + 1 > capacity_max:
		return false

	capacity_current = capacity_current + 1

	info_bar.set_capacity(capacity_current, capacity_max)

	entered.emit(capacity_current)

	return true
