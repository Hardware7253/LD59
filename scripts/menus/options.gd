extends Control


@export var music_slider: HSlider
@export var sfx_slider: HSlider


var music_bus_index: int
var sfx_bus_index: int

func _ready():
	music_bus_index = AudioServer.get_bus_index("Music")
	var music_volume = AudioServer.get_bus_volume_linear(music_bus_index)
	music_slider.value = music_volume 

	sfx_bus_index = AudioServer.get_bus_index("Sfx")
	var sfx_volume = AudioServer.get_bus_volume_linear(sfx_bus_index)
	sfx_slider.value = sfx_volume 

func _process(_delta: float) -> void:
	var is_root = self == get_tree().current_scene
	if Input.is_action_just_pressed("ui_cancel"):
		
		if is_root:
			get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")

func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(music_bus_index, value)


func _on_sounds_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(sfx_bus_index, value)
