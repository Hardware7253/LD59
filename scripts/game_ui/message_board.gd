extends Control
class_name MessageBoard

@export var label: Label
@export var animation_player: AnimationPlayer

func display_message(message: String, color: Color = game_graphics.MSG_FONT_COLOR):
	label.text = message
	label.add_theme_color_override("font_color", color)

	if !animation_player.is_playing():
		animation_player.play("slide")
