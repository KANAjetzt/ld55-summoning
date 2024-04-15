class_name Alien
extends Entity


signal despawning

@export var max_health := 3

var current_target: Building
var damage_delt := false
var current_health := max_health
var previous_position := Vector2.ZERO
var velocity := Vector2.ZERO

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var entity_visiblity_zone: EntityVisiblityZone = %EntityVisiblityZone


func _ready() -> void:
	entity_visiblity_zone.entity = self
	attack()


func _process(delta: float) -> void:
	if current_target:
		move_towards_next_building(delta)


func despawn() -> void:
	despawning.emit()
	animation_player.play_backwards("spawn")
	queue_free()


func attack() -> void:
	current_target = Utils.get_closest_building(global_position)


func take_damage(amount: int) -> void:
	current_health = current_health - amount
	if current_health == 0:
		# Prevent damage dealing after death
		damage_delt = true
		despawn()


func move_towards_next_building(delta: float) -> void:
	var direction := global_position.direction_to(current_target.global_position)
	global_position = global_position + direction * speed * speed_multiplier * delta

	velocity = (global_position - previous_position) / delta
	previous_position = global_position


func _on_collider_buildings_area_entered(area: Area2D) -> void:
	var take_damage_zone: BuildingTakeDamageZone = null
	if area is BuildingTakeDamageZone:
		take_damage_zone = area

		if not damage_delt:
			take_damage_zone.building.take_damage(1)
			damage_delt = true
			despawn()
