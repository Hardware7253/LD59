extends GraphicBuilding
class_name SubtractBuilding

func init_grid_item():
	my_grid_item = Subtractor.new(
		get_connection_grid_pos(output_positions[0]),
		get_connection_grid_pos(input_positions[0]),
		get_connection_grid_pos(input_positions[1]),
		self
	)
