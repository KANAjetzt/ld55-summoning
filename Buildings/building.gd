class_name Building
extends Node2D


signal damage_taken(new_health: int)

@export var health_max := 1

@onready var health_current := health_max


func take_damage(amount := 1) -> void:
	health_current = health_current - amount
	damage_taken.emit(health_current)
