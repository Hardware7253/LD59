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
	add_rectangle(get_rel_center_pos(), building_scale, main_color, 1)
	add_io(input_positions, game_colors.BUILDING_INPUT_COLOR)
	add_io(output_positions, game_colors.BUILDING_OUTPUT_COLOR)

	add_to_grid()

# To be implemented by subclass when needed (e.g. to update graphics after evaluation)
func update_building():
	pass

# Draws the IO rectangles underneath the main one
func add_io(rel_pos_array: Array[Vector2i], color: Color):
	for rel_grid_pos in rel_pos_array:
		
		var pixel_pos = _grid_to_world_offset(rel_grid_pos)

		var io_size = Vector2(grid.GRID_PIXELS, grid.GRID_PIXELS)
		add_rectangle(pixel_pos, io_size, color)

# Get center pos relative to bottom left pos
# Bottom left is at 0, 0 (node not world coordinate)
func get_rel_center_pos() -> Vector2:
	var center_offset := Vector2(building_grid_size * grid.GRID_PIXELS) / 2 
	center_offset -= Vector2(grid.GRID_PIXELS, grid.GRID_PIXELS) / 2
	center_offset.y = -center_offset.y

	return center_offset 

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

	for x in range(building_grid_size.x):
		for y in range(building_grid_size.y):
			var pos := Vector2(x * grid.GRID_PIXELS, y * -grid.GRID_PIXELS)

			# add_rectangle(pos, Vector2.ONE * 8, Color.WHITE, 4) # Debug markers
			grid_positions.append(grid.world_to_grid(global_position + pos))
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
	var connection_global_pos = _grid_to_world_offset(connection_rel_pos)
	return grid.world_to_grid(connection_global_pos)
