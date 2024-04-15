class_name AlienStorageAttacker
extends Alien


func _ready() -> void:
	super()
	current_target = Global.storage
	animation_player.play("spawn")

