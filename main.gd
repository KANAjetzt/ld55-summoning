extends Node2D


@onready var camera_main: PhantomCamera2D = %CameraMain
@onready var altar_preview: AltarPreview = %AltarPreview
@onready var altars: Node = %Altars
@onready var cats: Node = %Cats


func _on_shop_altar_bought(item_data: AltarData) -> void:
	altar_preview.texture = item_data.icon


func _process(delta: float) -> void:
	if Global.altar_selected and Input.is_action_just_pressed("select"):
		var new_altar: Altar = Global.altar_selected.scene.instantiate()
		new_altar.data = Global.altar_selected
		new_altar.global_position = get_global_mouse_position()
		altars.add_child(new_altar)
		new_altar.cat_ready.connect(_on_altar_cat_ready)
		Global.altar_selected = null
		altar_preview.remove_preview()


func _on_altar_cat_ready(altar: Altar) -> void:
	var new_cat: Cat = altar.data.scene_cat.instantiate()
	new_cat.global_position = altar.global_position
	cats.add_child(new_cat)
