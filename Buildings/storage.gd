class_name BuildingStorage
extends Building


@export var storing_time: float = 3.0

@onready var info_bar: UIInfoBar = %InfoBar

func _ready() -> void:
	Global.storage = self

	info_bar.set_health(health_current, health_max)
	info_bar.hide_capacity()


func take_damage(amount := 1) -> void:
	super()
	info_bar.set_health(health_current, health_max)


func _on_awarnesse_body_entered(body: Node2D) -> void:
	var miner: CatMiner
	if body is CatMiner:
		miner = body

		if miner.just_exited_area or miner.food_carrying == 0:
			return

		miner.store_food()
		miner.timer_storing.wait_time = storing_time


func _on_awarnesse_body_exited(body: Node2D) -> void:
	var miner: CatMiner
	if body is CatMiner:
		miner = body
		miner.is_at_storage = false
		miner.just_exited_area = true
