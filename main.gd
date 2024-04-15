class_name Main
extends Node2D


@onready var camera_main: PhantomCamera2D = %CameraMain
@onready var altar_preview: AltarPreview = %AltarPreview
@onready var altars: Node = %Altars
@onready var cats: Node = %Cats
@onready var projectiles: Node2D = %Projectiles


func _ready() -> void:
	Global.main = self


func _process(delta: float) -> void:
	if Global.altar_selected and Input.is_action_just_pressed("select"):
		handle_altar_placemend()

	if Global.cat_warrior_selected and Input.is_action_just_pressed("select") and not Global.mouse_over_cat_warrior:
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


func _on_altar_cat_ready(altar: Altar) -> void:
	var new_cat: Cat = altar.data.scene_cat.instantiate()
	new_cat.global_position = altar.global_position
	cats.add_child(new_cat)
