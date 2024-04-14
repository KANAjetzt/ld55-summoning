class_name BuildingStorage
extends Building


@export var storing_time: float = 3.0

var is_lid_open := false
var cat_miner_in_area := 0:
	set(_new_cat_miner_in_area):
		cat_miner_in_area = _new_cat_miner_in_area

		if cat_miner_in_area > 0 and not is_lid_open:
			lid_open()
		if cat_miner_in_area == 0 and is_lid_open:
			lid_close()

		debug_panel.update_label(0, "cat_miner_in_area: %s" % cat_miner_in_area)

@onready var info_bar: UIInfoBar = %InfoBar
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var debug_panel: UIDebugPanel = %DebugPanel
@onready var lid: Sprite2D = %Lid


func _ready() -> void:
	Global.storage = self

	info_bar.set_health(health_current, health_max)
	info_bar.hide_capacity()

	debug_panel.add_label("")


func take_damage(amount := 1) -> void:
	super()
	info_bar.set_health(health_current, health_max)


func lid_open() -> void:
	var tween := create_tween()
	tween.tween_property(lid, "position:x", -200, 1.0)
	await tween.finished
	is_lid_open = true


func lid_close() -> void:
	var tween := create_tween()
	tween.tween_property(lid, "position:x", 0, 1.0)
	await tween.finished
	is_lid_open = false


func _on_awarnesse_body_entered(body: Node2D) -> void:
	var miner: CatMiner
	if body is CatMiner:
		cat_miner_in_area = cat_miner_in_area + 1
		miner = body

		if miner.just_exited_area or miner.food_carrying == 0:
			return

		miner.store_food()
		miner.timer_storing.wait_time = storing_time


func _on_awarnesse_body_exited(body: Node2D) -> void:
	var miner: CatMiner
	if body is CatMiner:
		cat_miner_in_area = cat_miner_in_area - 1
		miner = body
		miner.is_at_storage = false
		miner.just_exited_area = true
