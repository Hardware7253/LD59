
var root_signal_generator_pos: Vector2i
var main_output_pos: Vector2i
var output_wave: Waveform = PrimitiveWave.new(0.0, PrimitiveWave.WaveType.NONE)
var grid_dict = {}

# Adds the grid item to the grid dictionary
func add_to_grid(grid_item: GridItem, pos: Vector2i):
    grid_dict[pos] = grid_item

# Erases the item at the position if it exists
func erase_from_grid(pos: Vector2i):
    if grid_dict.has(pos):
        grid_dict.erase(pos)

# This should be run everytime the grid is changed
# It computes the output waveform based on what is placed down on the grid
# func evaluate():

# Returns an array of positions occoupied that are adjacent to the current position
# func get_neighbors(pos: Vector2i):





