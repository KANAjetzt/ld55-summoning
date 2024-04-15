class_name UIShopButtonItem
extends HBoxContainer


signal item_selected(button: UIShopButtonItem, item_data: AltarData)

@export var item_data: AltarData

@onready var button: Button = %Button
@onready var label: Label = %Label
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
	if item_data.icon:
		button.icon = item_data.icon
	label.text = str(item_data.cost)


func play_shake() -> void:
	animation_player.play("shake")


func _on_button_pressed() -> void:
	item_selected.emit(self, item_data)
