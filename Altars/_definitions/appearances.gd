class_name AltarAppearance
extends Node2D


func _exit_tree() -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.5)
