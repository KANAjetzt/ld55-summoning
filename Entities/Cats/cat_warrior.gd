class_name  CatWarrior
extends Cat


@export var projectile: ProjectileData

var is_mouse_over := false:
	set(new_is_mouse_over):
			is_mouse_over = new_is_mouse_over
			if debug_panel:
				debug_panel.update_label(0, "is_mouse_over: %s" % is_mouse_over)
var is_selected := false:
	set(new_is_selected):
			is_selected = new_is_selected
			if debug_panel:
				debug_panel.update_label(1, "is_selected: %s" % is_selected)
var is_highlight_preview_visible := false
var is_awarness_preview_visible := false
var is_moving := false
var target_position: Vector2
var target_enemy: Alien:
	set(new_target_enemy):
			target_enemy = new_target_enemy
			if debug_panel:
				debug_panel.update_label(2, "target_enemy: %s" % target_enemy)
var enemies_in_range: Array[Alien] = []

@onready var click_listener: Area2D = %ClickListener
@onready var highlighted: TextureRect = $Highlighted
@onready var debug_panel: UIDebugPanel = %DebugPanel
@onready var timer_laser: Timer = %TimerLaser
@onready var animation_player_2: AnimationPlayer = %AnimationPlayer2


func _ready() -> void:
	debug_panel.add_label("")
	debug_panel.add_label("")
	debug_panel.add_label("")


func _process(delta: float) -> void:
	if not is_highlight_preview_visible and is_mouse_over:
		show_highlight_preview()

	if not is_awarness_preview_visible and is_mouse_over:
		show_awarness_preview()

	if is_highlight_preview_visible and not is_mouse_over and not is_selected:
		hide_highlight_preview()

	if is_awarness_preview_visible and not is_mouse_over and not is_selected:
		hide_awarness_preview()

	if Input.is_action_just_pressed("select") and is_mouse_over:
		Global.cat_warrior_selected = self
		show_highlight()
		is_selected = true

	if is_moving:
		move_towards_target_position(delta)


func set_target_position(new_target_position: Vector2) -> void:
	target_position = new_target_position
	is_moving = true


func move_towards_target_position(delta: float) -> void:
	var direction := global_position.direction_to(target_position)
	global_position = global_position + direction * speed * speed_multiplier * delta

	if global_position.distance_squared_to(target_position) < 100:
		is_moving = false


func deselect() -> void:
	is_selected = false
	hide_highlight()


func fire_laser() -> void:
	Utils.spawn_projectile(projectile, global_position, predict_enemy_position())
	timer_laser.start()


func predict_enemy_position() -> Vector2:
	var time_to_reach = (target_enemy.global_position.distance_to(global_position)) / projectile.speed
	return target_enemy.global_position + target_enemy.velocity * time_to_reach


func show_highlight_preview() -> void:
	is_highlight_preview_visible = true
	var tween := create_tween()
	tween.tween_property(highlighted, "modulate:a", 0.2, 0.15)


func hide_highlight_preview() -> void:
	is_highlight_preview_visible = false
	var tween := create_tween()
	tween.tween_property(highlighted, "modulate:a", 0.0, 0.2)


func show_awarness_preview() -> void:
	is_awarness_preview_visible = true
	animation_player.play("show_awarness_preview")


func hide_awarness_preview() -> void:
	is_awarness_preview_visible = false
	animation_player.play_backwards("show_awarness_preview")


func show_highlight() -> void:
	var tween := create_tween()
	tween.tween_property(highlighted, "modulate:a", 1.0, 0.1)


func hide_highlight() -> void:
	var tween := create_tween()
	tween.tween_property(highlighted, "modulate:a", 0.0, 0.2)


func _on_click_listener_mouse_entered() -> void:
	is_mouse_over = true
	Global.mouse_over_cat_warrior = true


func _on_click_listener_mouse_exited() -> void:
	is_mouse_over = false
	Global.mouse_over_cat_warrior = false


func _on_awarnesse_area_entered(area: Area2D) -> void:
	var entity_visiblity_zone: EntityVisiblityZone
	var alien: Alien

	if area is EntityVisiblityZone:
		entity_visiblity_zone = area
		if entity_visiblity_zone.entity is Alien:
			alien = entity_visiblity_zone.entity
			if is_instance_valid(alien):
				enemies_in_range.push_back(alien)
				if not target_enemy:
					target_enemy = alien
					target_enemy.despawning.connect(_on_target_enemy_despawning)
					fire_laser()


func _on_awarnesse_area_exited(area: Area2D) -> void:
	var entity_visiblity_zone: EntityVisiblityZone
	var alien: Alien

	if area is EntityVisiblityZone:
		entity_visiblity_zone = area
		if entity_visiblity_zone.entity is Alien:
			alien = entity_visiblity_zone.entity
			if is_instance_valid(alien):
				if alien == target_enemy:
					target_enemy = null

				enemies_in_range.erase(alien)


func _on_timer_laser_timeout() -> void:
	if target_enemy:
		fire_laser()


func _on_target_enemy_despawning(alien: Alien) -> void:
	target_enemy = null
	enemies_in_range.erase(alien)
	if not enemies_in_range.is_empty():
		target_enemy = enemies_in_range[0]



