extends Control
class_name Hotbar

@export var hbox: HBoxContainer
@export var hotbar_button_scene: PackedScene

@export var hotbar_buttons: Array[HotbarButton] = []

var hotbar_buildings: Array[BuildingType] = [
	BuildingType.new("wire", preload("res://scenes/buildings/wire_building.tscn")),
	BuildingType.new("oscilloscope", preload("res://scenes/buildings/scope_building.tscn")),
	BuildingType.new("wave generator", preload("res://scenes/buildings/gen_building.tscn")),
]

const HOTBAR_KEYS := [
	"hotbar_1",
	"hotbar_2",
	"hotbar_3",
	"hotbar_4",
	"hotbar_5",
	"hotbar_6",
	"hotbar_7",
	"hotbar_8",
    "hotbar_9"
]

var is_building_selected := false
var active_building: BuildingType

# For polling for signal
var last_is_building_selected := false
var last_active_building: BuildingType

signal new_hotbar_building(building: BuildingType) # Called when the hotbar building changes
signal hotbar_deselect() # Called when once when the hotbar is deselected

func _ready() -> void:

	# Instantiate hotbar buttons
	for i in range(0, len(hotbar_buildings)):
		var building = hotbar_buildings[i]

		var button: HotbarButton = hotbar_button_scene.instantiate()
		hbox.add_child(button)

		# Set button text
		button.text = building.name
		button.hotbar_index = len(hotbar_buttons)
		button.building_array_index = i
		hotbar_buttons.append(button)
		button.update_text()

		button.connect("hotbar_button_pressed", _on_hotbar_button_pressed)

# Update active building with user pressing hotbar buttons
func _on_hotbar_button_pressed(index: int) -> void:
	var button = hotbar_buttons[index]
	_unset_buttons(button)

	# Condition needs to be inverted because it gets updated for the buttons in the wrong order
	_update_active_building(button, true) 

# Update the active building variables when a button is pressed or unpressed
func _update_active_building(button: HotbarButton, invert_condition: bool = false):

	# Godot doesn't have an XOR operator
	is_building_selected = button.button_pressed 
	if invert_condition: 
		is_building_selected = !is_building_selected

	if is_building_selected:
		active_building = hotbar_buildings[button.building_array_index]
	else:
		active_building = null

func _process(_delta: float) -> void:

	# Update active building with user pressing hotbar hotkeys
	for i in range(0, len(hotbar_buttons)):
		var hotbar_key = HOTBAR_KEYS[i]

		if Input.is_action_just_pressed(hotbar_key):
			var button = hotbar_buttons[i]
			button.button_pressed = !button.button_pressed 
			_unset_buttons(button)
			_update_active_building(button)

			# Play sound 
			MenuSfx._on_click()

	# Poll and send signals
	if !is_building_selected && last_is_building_selected:
		emit_signal("hotbar_deselect")

	if active_building != last_active_building && is_building_selected:
		emit_signal("new_hotbar_building", active_building)

	last_active_building = active_building
	last_is_building_selected = is_building_selected


# Unsets all buttons except for an exclude button
func _unset_buttons(exclude_button: HotbarButton):
	for button in hotbar_buttons:
		if button != exclude_button:
			button.button_pressed = false
