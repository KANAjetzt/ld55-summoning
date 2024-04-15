extends Node


@export var override_mining_time := false
@export var override_mining_time_amount := 1.0
@export var override_dry_food_count := false
@export var override_dry_food_count_amount := 10000
@export var hide_all_debug_panel := false


func _ready() -> void:
	if hide_all_debug_panel:
		for node in get_tree().get_nodes_in_group("debug_panel"):
			node.hide()
