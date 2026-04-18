extends Node

var root_signal_generator_pos: Vector2i
var goal: Goal 
var grid_dict = {}

const ADJACENT_DIRECTIONS := [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]

# Adds the grid item to the grid dictionary
func add_to_grid(grid_item: GridItem, pos: Vector2i):
	grid_dict[pos] = grid_item

# Erases the item at the position if it exists
func erase_from_grid(pos: Vector2i):
	if grid_dict.has(pos):
		grid_dict.erase(pos)

# Returns the grid item at the positon
# Returns null if the item does not exist
func get_grid_item(pos: Vector2i) -> GridItem:
	if grid_dict.has(pos):
		return grid_dict[pos]
	return null


# This should be run everytime the grid is changed
# It will evaluate the entire network
# After running the goal waveform can be read
func evaluate() -> Result:
	_pre_evaluate()

	var start_gen := get_grid_item(root_signal_generator_pos)
	if not start_gen is SignalGenerator:
		return Result.new(Result.ResultType.ERROR, "root signal generator is non-existant")

	# Updating the root signal generator will update the entire system
	var update_result: Result = start_gen.update_building()
	if update_result.type == Result.ResultType.ERROR:
		return update_result

	return Result.new(Result.ResultType.OK)

# Run the pre evaluate function on all items in the grid
func _pre_evaluate():
	for key in grid_dict:
		var grid_item: GridItem = grid_dict[key]
		grid_item.pre_evaluate()


# Returns an array of valid neighbor positions (each position is a valid grid_dict key)
# Any directions in the exclude dirs array will not be checked 
func get_neighbor_positions(pos: Vector2i) -> Array[Vector2i]:
	var neighbor_positions: Array[Vector2i] = []

	for adjacent_dir in ADJACENT_DIRECTIONS:
		var neighbor_pos = pos + adjacent_dir
		if grid_dict.has(neighbor_pos):
			neighbor_positions.append(neighbor_pos)

	return neighbor_positions
