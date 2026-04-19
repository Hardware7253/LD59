extends Node2D
class_name BuildingBase

@export var main_color := game_colors.BUILDING_COLOR

# How many grid spaces the building occupies
@export var building_grid_size := Vector2i(3, 3)

# Positions of the inputs and output relative to the bottom left grid space of this building
@export var input_positions: Array[Vector2i]
@export var output_positions: Array[Vector2i]

var building_type: Building = null

func _ready() -> void:
	var building_scale = Vector2(building_grid_size) * grid.GRID_PIXELS - Vector2(grid.PAD_PIXELS, grid.PAD_PIXELS)
	add_rectangle(Vector2(0, 0), building_scale, main_color, 1)
	add_io(input_positions, game_colors.BUILDING_INPUT_COLOR)
	add_io(output_positions, game_colors.BUILDING_OUTPUT_COLOR)

	add_to_grid()

# To be implemented by subclass when needed (e.g. to update graphics after evaluation)
func update_building():
	pass

# Draws the IO rectangles underneath the main one
func add_io(rel_pos_array: Array[Vector2i], color: Color):
	for rel_grid_pos in rel_pos_array:
		
		var pixel_pos = _get_bottom_left_pos(false) + _grid_to_world_offset(rel_grid_pos)

		var io_size = Vector2(grid.GRID_PIXELS, grid.GRID_PIXELS)
		add_rectangle(pixel_pos, io_size, color)
	
# Gets the bottom left pos of the building
# If get_global is false the local coordinate system is used
func _get_bottom_left_pos(get_global := true) -> Vector2:
	var bottom_left_pos := Vector2.ZERO
	if get_global:
		bottom_left_pos = global_position

	var left_corner_offset := -Vector2(building_grid_size * grid.GRID_PIXELS) / 2 
	left_corner_offset.y = -left_corner_offset.y
	bottom_left_pos += left_corner_offset
	bottom_left_pos += Vector2(grid.GRID_PIXELS, -grid.GRID_PIXELS) / 2
	return bottom_left_pos

func _grid_to_world_offset(grid_offset: Vector2i) -> Vector2:
		return Vector2(Vector2i(grid_offset.x, -grid_offset.y) * grid.GRID_PIXELS)


func add_rectangle(pos: Vector2, size: Vector2, color: Color, z := 0):
	var sprite = Sprite2D.new()
	add_child(sprite)

	sprite.position = pos
	sprite.z_index = z

	var img = Image.create(1, 1, false, Image.FORMAT_RGBA8)
	img.fill(color)

	var tex = ImageTexture.create_from_image(img)
	sprite.texture = tex

	sprite.scale = size

# Gets an array grid positions this building occupies
# Based on the buildings position in the world
func get_grid_positions() -> Array[Vector2i]:
	var grid_positions: Array[Vector2i] = []

	# Start the pos in the bottom left 
	var bottom_left_pos := _get_bottom_left_pos(false)

	for x in range(building_grid_size.x):
		for y in range(building_grid_size.y):
			var pos := bottom_left_pos + Vector2(x * grid.GRID_PIXELS, y * -grid.GRID_PIXELS)

			grid_positions.append(grid.world_to_grid(pos))
	return grid_positions



# Adds each position occupied by this building to the grid dictionary
func add_to_grid():
	for pos in get_grid_positions():
		if building_type != null:
			grid.add_to_grid(building_type, pos)

# Erase each position occupied by this building from the grid dictionary
func erase_from_grid():
	for pos in get_grid_positions():
		if building_type != null:
			grid.erase_from_grid(pos)

# Gets the grid position of a connection position relative to this building
func get_connection_grid_pos(connection_rel_pos: Vector2i) -> Vector2i:
	var connection_global_pos = _get_bottom_left_pos() + _grid_to_world_offset(connection_rel_pos)
	return grid.world_to_grid(connection_global_pos)
