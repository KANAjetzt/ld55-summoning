class_name Alien
extends Entity


var current_target: Building
var damage_delt := false

@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
	attack()


func _process(delta: float) -> void:
	if current_target:
		move_towards_next_building(delta)


func despawn() -> void:
	animation_player.play_backwards("spawn")


func attack() -> void:
	current_target = Utils.get_closest_building(global_position)


func move_towards_next_building(delta: float) -> void:
	var direction := global_position.direction_to(current_target.global_position)
	global_position = global_position + direction * speed * speed_multiplier * delta


func _on_collider_buildings_area_entered(area: Area2D) -> void:
	var take_damage_zone: BuildingTakeDamageZone = null
	if area is BuildingTakeDamageZone:
		take_damage_zone = area

		if not damage_delt:
			take_damage_zone.building.take_damage(1)
			damage_delt = true
			despawn()
