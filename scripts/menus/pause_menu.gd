extends Control

@export var options_menu: Node
@export var message_board: MessageBoard

var in_options := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:

	# Check if pause menus are disabled
	var parent := get_parent()
	if parent is PauseMenus:
		if parent.disable_pause_menus:
			return

	var is_paused = get_tree().paused

	if Input.is_action_just_pressed("ui_cancel"):

		if in_options: # Exit options menu
			self.show()
			options_menu.hide()
			in_options = false 
		else: # Toggle pause
			is_paused = !is_paused
			get_tree().paused = is_paused 
		
			if is_paused:
				self.show()
			else:
				self.hide()


func _on_resume_button_button_down() -> void:
	self.hide()
	get_tree().paused = false 

func _on_options_button_button_down() -> void:
	options_menu.show()
	self.hide()
	in_options = true

func _on_level_select_button_button_down() -> void:
	get_tree().paused = false 
	get_tree().change_scene_to_file("res://scenes/menus/level_select.tscn")


func _on_hint_button_button_down() -> void:
	if message_board:
		message_board.display_message(levels.selected_level.hint_message)


func _on_main_menu_button_button_down() -> void:
	get_tree().paused = false 
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
