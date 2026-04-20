extends Node

var root_signal_generator: SignalGenerator 
var goal: Goal 
var grid_dict = {}

const ADJACENT_DIRECTIONS := [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]

const GRID_PIXELS := 50 	# Pixels per grid space
const PAD_PIXELS := 8 		# When something needs to be shrinked or expanded it's done by this ammount


func grid_to_world(grid_pos: Vector2i) -> Vector2:
	return Vector2(grid_pos.x * grid.GRID_PIXELS, -grid_pos.y * grid.GRID_PIXELS)

func world_to_grid(world_pos: Vector2) -> Vector2i:
	return Vector2i(Vector2(world_pos.x / grid.GRID_PIXELS, -(world_pos.y / grid.GRID_PIXELS)).round())

func snap_to_grid(world_pos: Vector2) -> Vector2:
	return grid_to_world(world_to_grid(world_pos))


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

	if not root_signal_generator:
		return Result.new(Result.ResultType.ERROR, "root signal generator is non-existant")

	# Updating the root signal generator will update the entire system
	var update_result: Result = root_signal_generator.update_building()
	if update_result.type == Result.ResultType.ERROR:
		return update_result

	return Result.new(Result.ResultType.OK)

# Run the pre evaluate function on all items in the grid
func _pre_evaluate():
	for key in grid_dict:
		var grid_item: GridItem = grid_dict[key]
		grid_item.pre_evaluate()

# Force updates grid_items adjacent to the provided position 
func update_adjacent_grid_items(pos: Vector2i):
	var neighbor_positions := get_neighbor_positions(pos)

	for neighbor_pos in neighbor_positions:
		var grid_item := get_grid_item(neighbor_pos)
		if grid_item is Building:
			grid_item.pre_evaluate()
			grid_item.update_building()


# Returns an array of valid neighbor positions (each position is a valid grid_dict key)
# Any directions in the exclude dirs array will not be checked 
func get_neighbor_positions(pos: Vector2i) -> Array[Vector2i]:
	var neighbor_positions: Array[Vector2i] = []

	for adjacent_dir in ADJACENT_DIRECTIONS:
		var neighbor_pos = pos + adjacent_dir
		if grid_dict.has(neighbor_pos):
			neighbor_positions.append(neighbor_pos)

	return neighbor_positions
