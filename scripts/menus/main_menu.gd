extends Control

func _on_options_button_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/options.tscn")


func _on_credits_button_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/credits.tscn")


func _on_quit_button_button_down() -> void:
	get_tree().quit()


func _on_play_button_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/level_select.tscn")
