class_name BuildingMine
extends Building


signal entered(capacity_current)
signal exited(capacity_current)
signal despawning(mine: BuildingMine)

@export var capacity_max := 3
@export var mining_time: float = 10 if not Debug.override_mining_time else Debug.override_mining_time_amount

var capacity_current := 0
var capacity_target := 0:
	set(_new_capacity_target):
		capacity_target = _new_capacity_target
		if debug_panel:
			debug_panel.update_label(0, "capacity_target: %s" % _new_capacity_target)

@onready var info_bar: UIInfoBar = %InfoBar
@onready var entrance: Area2D = %Entrance
@onready var entrance_shape: CollisionShape2D = %EntranceShape
@onready var take_damage_zone: BuildingTakeDamageZone = %TakeDamageZone
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var debug_panel: UIDebugPanel = %DebugPanel


func _ready() -> void:
	Global.add_mine(self)
	info_bar.set_health(health_current, health_max)
	info_bar.set_capacity(capacity_current, capacity_max)
	take_damage_zone.building = self


func _exit_tree() -> void:
	Global.remove_mine(self)


func take_damage(amount := 1) -> void:
	super()
	info_bar.set_health(health_current, health_max)
	if health_current == 0:
		animation_player.play("despawn")


func target() -> void:
	capacity_target = capacity_target + 1


func enter() -> bool:
	if capacity_current + 1 > capacity_max:
		return false

	capacity_current = capacity_current + 1
	if capacity_target < capacity_current:
		capacity_target = capacity_current

	info_bar.set_capacity(capacity_current, capacity_max)

	entered.emit(capacity_current)

	return true


func exit() -> void:
	capacity_current = capacity_current - 1
	capacity_target = capacity_target - 1

	info_bar.set_capacity(capacity_current, capacity_max)

	exited.emit(capacity_current)


func _on_awarnesse_body_entered(body: Node2D) -> void:
	var miner: CatMiner

	if body is CatMiner:
		miner = body
		var allowed := enter()
		if not allowed:
			miner.search_mine()
			return

		miner.is_at_mine = true
		miner.mine_current = self
		miner.mine_target = self
		miner.move_to_mine_entrance(entrance_shape.global_position)
		miner.timer_mining.wait_time = mining_time


func _on_awarnesse_body_exited(body: Node2D) -> void:
	var miner: CatMiner

	if body is CatMiner:
		miner = body
		if not miner.mine_target:
			exit()

		miner.is_at_mine = false
		miner.mine_current = null


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "despawn":
		Global.stats.lost_buildings = Global.stats.lost_buildings + 1
		queue_free()
