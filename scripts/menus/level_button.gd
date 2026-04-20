extends Button
class_name LevelButton

var level_index: int = 0

signal level_button_pressed(index: int)

func update_text(level_complete: bool):
	text = "Level " + str(level_index + 1)
	get_child(0).visible = level_complete


# Emit the signal with the level_index so the button can be identified
func _on_button_down() -> void:
	emit_signal("level_button_pressed", level_index)  
