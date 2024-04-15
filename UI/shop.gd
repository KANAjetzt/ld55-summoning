extends Control


signal altar_bought(altar_data: AltarData)


func _on_button_pressed() -> void:
	if Global.dry_food_count >= 3:
		Global.shop_current_selection = "food_bowl"


func _on_button_2_pressed() -> void:
	if Global.dry_food_count >= 10:
		Global.shop_current_selection = "chair"


func _on_shop_button_item_selected(shop_button: UIShopButtonItem, item_data: AltarData) -> void:
	if item_data.cost > Global.dry_food_count:
		shop_button.play_shake()
		return

	Global.altar_selected = item_data

	altar_bought.emit(item_data)
