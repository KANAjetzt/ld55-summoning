extends Node2D


@onready var camera_main: PhantomCamera2D = %CameraMain
@onready var altar_preview: AltarPreview = %AltarPreview
@onready var altars: Node = %Altars
@onready var cats: Node = %Cats


func _on_shop_altar_bought(item_data: AltarData) -> void:
	altar_preview.texture = item_data.icon


func _process(delta: float) -> void:
	if Global.altar_selected and Input.is_action_just_pressed("select"):
		var new_altar: AltarAppearance = Global.altar_selected.appearance.instantiate()
		new_altar.global_position = get_global_mouse_position()
		altars.add_child(new_altar)
		Global.altar_selected = null
		altar_preview.remove_preview()
