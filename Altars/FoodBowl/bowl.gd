class_name AltarBowl
extends Altar


@onready var sfx_player: SFXPlayer = %SFXPlayer


func _ready() -> void:
	super()
	timer_spawn_cat.start()
	sfx_player.start()


func _on_timer_spawn_cat_timeout() -> void:
	cat_ready.emit(self)
	despawn()
