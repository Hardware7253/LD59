extends Node

@export var game_ui: Control
@export var pause_menus: Control

func _ready() -> void:
	update_menus_visibility()
	
func _process(_delta: float) -> void:
	update_menus_visibility()

# Update the visibility of the menus based on the paused state
func update_menus_visibility() -> void:
	if get_tree().paused:
		game_ui.hide()
		pause_menus.show()
	else:
		game_ui.show()
		pause_menus.hide()
