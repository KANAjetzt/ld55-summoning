class_name UIDebugPanel
extends PanelContainer


@onready var labels: VBoxContainer = %Labels


func add_label(text := "") -> int:
	var new_label := Label.new()
	new_label.text = text
	labels.add_child(new_label)

	return labels.get_child_count()


func update_label(row: int, text: String) -> void:
	var current_label_count := labels.get_child_count()

	if not labels:
		return
	if current_label_count < row + 1:
		for i in (row + 1) - current_label_count:
			add_label()
	labels.get_child(row).text = text
