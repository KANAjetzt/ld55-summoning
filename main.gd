class_name Main
extends Node2D


var alien_storage_attacker_scene: PackedScene = load("res://Entities/Aliens/alien_storage_attacker.tscn")

@onready var camera_main: PhantomCamera2D = %CameraMain
@onready var altar_preview: AltarPreview = %AltarPreview
@onready var altars: Node = %Altars
@onready var cats: Node = %Cats
@onready var projectiles: Node2D = %Projectiles
@onready var game_over: UIGameOver = $CanvasLayer/GameOver
@onready var alien_spawn_points: Node = %AlienSpawnPoints
@onready var aliens: Node = %Aliens
@onready var timer_spawn_alien: Timer = %TimerSpawnAlien


func _ready() -> void:
	Global.main = self
	Global.alien_spawn_points.assign(alien_spawn_points.get_children())


func _process(delta: float) -> void:
	if Global.altar_selected and Input.is_action_just_pressed("select"):
		handle_altar_placemend()

	if Global.cat_warrior_selected and not Global.mouse_over_cat_warrior and Input.is_action_just_pressed("deselect"):
		Global.cat_warrior_selected.deselect()
		Global.cat_warrior_selected = null

	if Input.is_action_just_pressed("zoom_in"):
		if not camera_main.get_zoom() * 1.1 > Vector2(3.0, 3.0):
			camera_main.set_zoom(camera_main.get_zoom() * 1.1)

	if Input.is_action_just_pressed("zoom_out"):
		if not camera_main.get_zoom() * 0.9 < Vector2(0.1, 0.1):
			camera_main.set_zoom(camera_main.get_zoom() * 0.9)


func _unhandled_input(event: InputEvent) -> void:
	if Global.cat_warrior_selected and event.is_action_pressed("select") and not Global.mouse_over_cat_warrior and not Global.altar_selected:
		handle_warrior_placemend()


func _on_shop_altar_bought(item_data: AltarData) -> void:
	altar_preview.texture = item_data.icon


func handle_altar_placemend() -> void:
	var new_altar: Altar = Global.altar_selected.scene.instantiate()
	new_altar.data = Global.altar_selected
	new_altar.global_position = get_global_mouse_position()
	altars.add_child(new_altar)
	new_altar.cat_ready.connect(_on_altar_cat_ready)
	Global.altar_selected = null
	altar_preview.remove_preview()


func handle_warrior_placemend() -> void:
	var selected_warrior: CatWarrior = Global.cat_warrior_selected
	selected_warrior.set_target_position(get_global_mouse_position())
	Global.cat_warrior_count = Global.cat_warrior_count + 1

	if Utils.is_int_in_range(Global.cat_warrior_count, 0, 2):
		return
	if Utils.is_int_in_range(Global.cat_warrior_count, 3, 5):
		timer_spawn_alien.wait_time = 20
		if timer_spawn_alien.is_stopped():
			timer_spawn_alien.start()
	if Utils.is_int_in_range(Global.cat_warrior_count, 6, 8):
		timer_spawn_alien.wait_time = 15
	if Utils.is_int_in_range(Global.cat_warrior_count, 9, 12):
		timer_spawn_alien.wait_time = 10
	if Global.cat_warrior_count > 12:
		timer_spawn_alien.wait_time = 3


func _on_altar_cat_ready(altar: Altar) -> void:
	var new_cat: Cat = altar.data.scene_cat.instantiate()
	new_cat.global_position = altar.global_position
	cats.add_child(new_cat)


func _on_timer_spawn_alien_timeout() -> void:
	var new_alien_storage_attacker: AlienStorageAttacker = alien_storage_attacker_scene.instantiate()
	new_alien_storage_attacker.global_position = Global.alien_spawn_points.pick_random().global_position
	aliens.add_child(new_alien_storage_attacker)
