extends Node


@export var override_mining_time := false
@export var override_mining_time_amount := 1.0
@export var override_dry_food_count := false
@export var override_dry_food_count_amount := 10000
@export var hide_all_debug_panel := false
@export var allways_show_miners := false


func _ready() -> void:
	if hide_all_debug_panel:
		for node in get_tree().get_nodes_in_group("debug_panel"):
			node.hide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_0"):
		for node in get_tree().get_nodes_in_group("debug_panel"):
				node.show()

	if event.is_action_pressed("debug_1"):
		for node in get_tree().get_nodes_in_group("debug_panel"):
				node.hide()
