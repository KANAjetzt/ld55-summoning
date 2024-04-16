class_name ProjectileLaser
extends Node2D


signal alien_hited(alien: Alien)

@export var data: ProjectileData


var target_position: Vector2

@onready var sfx_impact: SFXPlayer = %SFXImpact
@onready var sfx_laser: SFXPlayer = $SFXLaser


func _ready() -> void:
	sfx_laser.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_towards_target_position(delta)


func move_towards_target_position(delta: float) -> void:
	var direction := global_position.direction_to(target_position)
	global_position = global_position + direction * data.speed * delta

	if global_position.distance_squared_to(target_position) < 10:
		queue_free()


func _on_collider_area_entered(area: Area2D) -> void:
	var entity_visiblity_zone: EntityVisiblityZone
	var alien: Alien

	if area is EntityVisiblityZone:
		entity_visiblity_zone = area
		if entity_visiblity_zone.entity is Alien:
			alien = entity_visiblity_zone.entity
			alien_hited.emit(alien)
			alien.take_damage(data.damage)
