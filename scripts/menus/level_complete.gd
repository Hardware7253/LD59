extends Control

@export var pause_menus: PauseMenus
var last_level_completed_state := false

func _ready() -> void:
	last_level_completed_state = levels.selected_level.level_completed

# Show self the first time the current level is completed
func _process(_delta: float) -> void:
	var level_completed_state := levels.selected_level.level_completed
	if level_completed_state && !last_level_completed_state:
		get_tree().paused = true 
		self.show()

		if pause_menus:
			pause_menus.disable_pause_menus = true 

	last_level_completed_state = level_completed_state

	if self.visible and Input.is_action_just_pressed("ui_cancel"):
		_on_continue_button_button_down()

# Continue playing the level
func _on_continue_button_button_down() -> void:
	if pause_menus:
		pause_menus.disable_pause_menus = false
	get_tree().paused = false 
	self.hide()

# Load the next level
func _on_next_button_button_down() -> void:
	get_tree().paused = false 
	levels.inc_level()
	get_tree().change_scene_to_file("res://scenes/level.tscn")

# Go to level select screen
func _on_level_select_button_button_down() -> void:
	get_tree().paused = false 
	get_tree().change_scene_to_file("res://scenes/menus/level_select.tscn")
