class_name UIDebugPanel
extends PanelContainer


@onready var labels: VBoxContainer = %Labels


func add_label(text: String) -> int:
	var new_label := Label.new()
	new_label.text = text
	labels.add_child(new_label)

	return labels.get_child_count()


func update_label(row: int, text: String) -> void:
	labels.get_child(row).text = text
