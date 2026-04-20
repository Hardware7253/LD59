extends BuildingBase 
class_name WireBuilding

func _ready() -> void:
	main_color = game_graphics.WIRE_COLOR
	super._ready()

func init_grid_item():
	my_grid_item = Wire.new(self)
