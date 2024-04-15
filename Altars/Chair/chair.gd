class_name AltarChair
extends Altar


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "spawn":
		timer_spawn_cat.start()


func _on_timer_spawn_cat_timeout() -> void:
	cat_ready.emit(self)
	despawn()
