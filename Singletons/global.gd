extends Node


signal dry_food_count_changed(dry_food_count: int)
signal aliens_attacking_count_changed(aliens_attacking_count: int)

@export var dry_food_count: int = 0 if not Debug.override_dry_food_count else Debug.override_dry_food_count_amount

var main: Main
var aliens_attacking_count := 0
var storage: BuildingStorage
var mines: Array[BuildingMine]
var mines_by_distance_to_storage: Array[BuildingMine]
var altar_selected: AltarData = null
var mouse_over_cat_warrior := false
var cat_warrior_selected: CatWarrior = null: set = _set_cat_warrior_selected


func _set_cat_warrior_selected(_new_cat_warrior_selected):
	if cat_warrior_selected and not _new_cat_warrior_selected == cat_warrior_selected:
		cat_warrior_selected.deselect()

	cat_warrior_selected = _new_cat_warrior_selected


func add_dry_food(amount: int) -> void:
	dry_food_count = dry_food_count + amount
	dry_food_count_changed.emit(dry_food_count)


func remove_dry_food(amount: int) -> void:
	dry_food_count = dry_food_count - amount
	dry_food_count_changed.emit(dry_food_count)


func set_aliens_attacking_count(amount: int) -> void:
	aliens_attacking_count = aliens_attacking_count + amount
	aliens_attacking_count_changed.emit(aliens_attacking_count)


func add_mine(mine: BuildingMine) -> void:
	mines.push_back(mine)
	_update_mines_by_distance_to_center()

func remove_mine(mine: BuildingMine) -> void:
	mines.erase(mine)
	_update_mines_by_distance_to_center()


func get_all_mines() -> Array[BuildingMine]:
	return mines


func sort_mines_by_distance_to_center(a: BuildingMine, b: BuildingMine) -> bool:
	return a.global_position.distance_squared_to(storage.global_position) < b.global_position.distance_squared_to(storage.global_position)


func _update_mines_by_distance_to_center():
	var mines_sorted := mines.duplicate()
	mines_sorted.sort_custom(sort_mines_by_distance_to_center)
	mines_by_distance_to_storage = mines_sorted
