class_name UIGameOver
extends PanelContainer


@onready var label: Label = %Label
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func init() -> void:
	var stats: StatsData = Global.stats
	label.text = label.text % [stats.dry_food_collected, stats.time_played, stats.removed_aliens, stats.lost_buildings]
	play_fade_in()


func play_fade_in() -> void:
	animation_player.play("fade_in")
