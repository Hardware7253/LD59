extends BuildingBase 
class_name WireBuilding

func _ready() -> void:
	my_grid_item = Wire.new(self)
	main_color = game_colors.WIRE_COLOR
	super._ready()
