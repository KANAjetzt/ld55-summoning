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
