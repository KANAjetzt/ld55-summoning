class_name Altar
extends Node2D


signal cat_ready(altar: Altar)

var data: AltarData

@onready var timer_spawn_cat: Timer = %TimerSpawnCat
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var spawn_indicator: ColorRect = %SpawnIndicator


func _ready() -> void:
	var tween := create_tween()
	tween.tween_property(self, "spawn_indicator:size:x", 0, timer_spawn_cat.wait_time)


func despawn() -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.5)
	await tween.finished
	queue_free()
