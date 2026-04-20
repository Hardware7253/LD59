extends Control

@export var button_grid: GridContainer 
@export var level_button_scene: PackedScene

func _ready() -> void:

	# Instantiate level buttons
	for i in range(0, len(levels.levels)):

		var button: LevelButton = level_button_scene.instantiate()
		button_grid.add_child(button)

		# Set button parameters
		button.level_index = i
		button.update_text(levels.levels[i].level_completed)

		button.connect("level_button_pressed", _on_level_button_pressed)


# Load a level when a button is pressed
func _on_level_button_pressed(index: int) -> void:
	levels.selected_level_index = index
	levels.selected_level = levels.levels[index]
	get_tree().change_scene_to_file("res://scenes/level.tscn")
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
