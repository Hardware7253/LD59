class_name BuildingType
# Building type class used by hotbar and level for placing buildings in the world

var name: String 
var packed_scene: PackedScene

func _init(_name: String, _packed_scene: PackedScene) -> void:
	name = _name
	packed_scene = _packed_scene
