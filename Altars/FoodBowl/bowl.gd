class_name AltarBowl
extends Altar


func _ready() -> void:
	super()
	timer_spawn_cat.start()


func _on_timer_spawn_cat_timeout() -> void:
	cat_ready.emit(self)
	despawn()
