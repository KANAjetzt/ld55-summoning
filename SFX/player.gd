class_name SFXPlayer
extends AudioStreamPlayer


@export var sounds: Array[AudioStream] = []


func start() -> void:
	stream = sounds.pick_random()
	pitch_scale = randf_range(0.85, 1.15)
	play()
