extends Node

class BuildingType:
	var name: String 
	var packed_scene: PackedScene
	var hotbar_building: bool 

	func _init(_name: String, _packed_scene: PackedScene, _hotbar_building: bool) -> void:
		name = _name
		packed_scene = _packed_scene
		hotbar_building = _hotbar_building

var buildings_array: Array[BuildingType] = [
	BuildingType.new("wire", preload("res://scenes/buildings/wire_building.tscn"), true),
	BuildingType.new("oscilloscope", preload("res://scenes/buildings/scope_building.tscn"), true),
	BuildingType.new("wave generator", preload("res://scenes/buildings/gen_building.tscn"), true),
]
