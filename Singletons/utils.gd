extends Node


func get_closest_node2D(from: Vector2, nodes_to_check: Array[Node2D]) -> Node2D:
	var closest_node: Node2D = null
	var closest_distance_squared: float = INF

	for node in nodes_to_check:
		if node is Node2D:
			var distance_squared = from.distance_squared_to(node.global_position)

			if distance_squared < closest_distance_squared:
				closest_distance_squared = distance_squared
				closest_node = node

	return closest_node


func get_closest_building(from: Vector2) -> Building:
	var all_buildings: Array[Node2D]

	all_buildings.assign(Global.mines)
	all_buildings.push_back(Global.storage)

	return get_closest_node2D(from, all_buildings) as Building


func get_closest_mine_from_storage_with_space() -> BuildingMine:
	var closest_mine: BuildingMine = null

	for mine in Global.mines_by_distance_to_storage:
		if mine.capacity_target == mine.capacity_max:
			continue

		closest_mine = mine
		break

	return closest_mine


func spawn_projectile(projectile_data: ProjectileData, start_position: Vector2, target_position: Vector2) -> void:
	var new_projectile: ProjectileLaser = projectile_data.scene.instantiate()
	new_projectile.global_position = start_position
	new_projectile.data = projectile_data
	new_projectile.target_position = target_position
	Global.main.projectiles.add_child(new_projectile)


func show_game_over() -> void:
	Global.stats.time_played = Time.get_ticks_msec() / 1000 / 60
	Global.main.game_over.init()


func is_int_in_range(value: int, min_value: int, max_value: int) -> bool:
	return value >= min_value and value <= max_value
