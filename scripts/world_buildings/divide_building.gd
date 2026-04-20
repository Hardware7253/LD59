extends GraphicBuilding
class_name DivideBuilding

func init_grid_item():
	my_grid_item = Divisor.new(
		get_connection_grid_pos(output_positions[0]),
		get_connection_grid_pos(input_positions[0]),
		get_connection_grid_pos(input_positions[1]),
		self
	)
