class_name CatMiner
extends Cat


var mine_target: BuildingMine
var mine_current: BuildingMine
var food_carrying := 0:
	set(new_val):
		food_carrying = new_val
		if debug_panel:
			debug_panel.update_label(4, "food: %s" % food_carrying)
var is_at_mine := false:
	set(new_val):
		is_at_mine = new_val
		if debug_panel:
			debug_panel.update_label(0, "is_at_mine: %s" % new_val)
var is_mining := false:
	set(new_val):
		is_mining = new_val
		if debug_panel:
			debug_panel.update_label(1, "is_mining: %s" % new_val)
var is_at_storage = false:
	set(new_val):
		is_at_storage = new_val
		if debug_panel:
			debug_panel.update_label(2, "is_at_storage: %s" % new_val)
var is_storing := false:
	set(new_val):
		is_storing = new_val
		if debug_panel:
			debug_panel.update_label(3, "is_storing: %s" % new_val)

@onready var timer_mining: Timer = %TimerMining
@onready var timer_storing: Timer = %TimerStoring
@onready var debug_panel: UIDebugPanel = %DebugPanel
@onready var audio_stoped_mining: SFXPlayer = %AudioStopedMining
@onready var audio_stoped_storing: SFXPlayer = %AudioStopedStoring
@onready var timer_search_mine: Timer = %TimerSearchMine


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	search_mine()
	debug_panel.add_label("")
	debug_panel.add_label("")
	debug_panel.add_label("")
	debug_panel.add_label("")
	debug_panel.add_label("")


func _physics_process(delta: float) -> void:
	if mine_target and not is_at_mine:
		move_towards_mine(delta)
		return

	if is_at_mine and mine_target and not mine_current == mine_target:
		move_towards_mine(delta)
		return

	if food_carrying > 0 and not is_at_storage:
		move_towards_storage(delta)


func search_mine() -> bool:
	mine_target = Utils.get_closest_mine_from_storage_with_space()
	if not mine_target:
		timer_search_mine.start()
		return false

	mine_target.target()
	mine_target.despawning.connect(_on_mine_target_despawning)

	return true


func move_towards_mine(delta: float) -> void:
	var direction := global_position.direction_to(mine_target.global_position)
	global_position = global_position + direction * speed * speed_multiplier * delta


func move_to_mine_entrance(entreance_position: Vector2) -> void:
	var tween := create_tween()
	tween.tween_property(self, "global_position", entreance_position, 1.0)
	await tween.finished
	start_mining()


func move_towards_storage(delta: float) -> void:
	var direction := global_position.direction_to(Global.storage.global_position)
	global_position = global_position + direction * speed * speed_multiplier * delta


func start_mining() -> void:
	var tween := create_tween()
	tween.tween_property(self, "global_position", global_position + Vector2(0, -50), 0.5)
	if not Debug.allways_show_miners:
		tween.parallel().tween_property(self, "modulate:a", 0.0, 0.5)
	await tween.finished
	timer_mining.start()
	is_mining = true


func stop_mining() -> void:
	audio_stoped_mining.start()
	var tween := create_tween()
	tween.tween_property(self, "global_position", global_position + Vector2(0, 50), 0.5)
	tween.parallel().tween_property(self, "modulate:a", 1.0, 0.5)

	is_mining = false
	mine_target = null

	food_carrying = food_carrying + 1


func store_food() -> void:
	is_at_storage = true

	var tween := create_tween()
	tween.tween_property(self, "global_position", global_position + (135 * global_position.direction_to(Global.storage.global_position)), 1.0)
	await tween.finished

	timer_storing.start()
	is_storing = true
	Global.stats.dry_food_collected = Global.stats.dry_food_collected + 1


func stop_storing() -> void:
	is_storing = false
	audio_stoped_storing.start()
	var tween := create_tween()
	tween.tween_property(self, "global_position", global_position - (135.0 * global_position.direction_to(Global.storage.global_position)), 1.0)
	await tween.finished

	search_mine()


func _on_timer_mining_timeout() -> void:
	stop_mining()


func _on_timer_storing_timeout() -> void:
	food_carrying = food_carrying - 1
	Global.add_dry_food(1)
	stop_storing()


func _on_mine_target_despawning(mine: BuildingMine) -> void:
	search_mine()


func _on_timer_search_mine_timeout() -> void:
	var success := search_mine()
	if success:
		timer_search_mine.stop()
