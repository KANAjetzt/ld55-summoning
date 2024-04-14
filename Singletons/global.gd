extends Node


signal dry_food_count_changed(dry_food_count: int)
signal  aliens_attacking_count_changed(aliens_attacking_count: int)

@export var dry_food_count := 0

var aliens_attacking_count := 0


func set_dry_fodd_count(amount: int) -> void:
	dry_food_count = dry_food_count + amount
	dry_food_count_changed.emit(dry_food_count)


func set_aliens_attacking_count(amount: int) -> void:
	aliens_attacking_count = aliens_attacking_count + amount
	aliens_attacking_count_changed.emit(aliens_attacking_count)
