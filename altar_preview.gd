class_name AltarPreview
extends Sprite2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if texture:
		global_position = get_global_mouse_position()


func set_preview(preview_texture: Texture) -> void:
	texture = preview_texture


func remove_preview() -> void:
	texture = null
