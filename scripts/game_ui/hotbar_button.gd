extends Button
class_name HotbarButton

var hotbar_index: int = 0
var building_array_index: int = 0

signal hotbar_button_pressed(index: int)

func update_text():
	get_child(0).text = str(hotbar_index + 1)


# Emit the signal with the hotbar_index so the button can be identified
func _on_button_down() -> void:
	emit_signal("hotbar_button_pressed", hotbar_index)  
