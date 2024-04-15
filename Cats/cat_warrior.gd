class_name  CatWarrior
extends Cat


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
var is_moving := false
var target_position: Vector2

@onready var click_listener: Area2D = %ClickListener
@onready var highlighted: TextureRect = $Highlighted
@onready var debug_panel: UIDebugPanel = %DebugPanel


func _ready() -> void:
	debug_panel.add_label("")
	debug_panel.add_label("")


func _process(delta: float) -> void:
	if not is_highlight_preview_visible and is_mouse_over:
		show_highlight_preview()

	if is_highlight_preview_visible and not is_mouse_over and not is_selected:
		hide_highlight_preview()

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


func show_highlight_preview() -> void:
	is_highlight_preview_visible = true
	animation_player.play("show_highlighting_preview")


func hide_highlight_preview() -> void:
	is_highlight_preview_visible = false
	animation_player.play_backwards("show_highlighting_preview")


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
