extends Node2D

var pixels_per_grid_space := 50

var building_shrink_pixels := 10

@export var main_color := game_colors.BUILDING_COLOR

# How many grid spaces the building occupies
@export var building_grid_size := Vector2i(3, 3)

# Positions of the inputs and output relative to the bottom left grid space of this building
@export var input_positions: Array[Vector2i]
@export var output_positions: Array[Vector2i]

func _ready() -> void:
	var building_scale = Vector2(building_grid_size) * pixels_per_grid_space - Vector2(building_shrink_pixels, building_shrink_pixels)
	add_rectangle(Vector2(0, 0), building_scale, main_color, 1)
	add_io(input_positions, game_colors.BUILDING_INPUT_COLOR)
	add_io(output_positions, game_colors.BUILDING_OUTPUT_COLOR)

func add_io(rel_pos_array: Array[Vector2i], color: Color):
	for grid_pos in rel_pos_array:

		# Convert the offset relative to the bottom left to an offset relative to the center
		# var pos := Vector2(grid_pos) - Vector2(building_grid_size) / 2

		var bottom_left_offset := Vector2(0.5, 0.5) - Vector2(building_grid_size) / 2

		var pos := Vector2(grid_pos) + bottom_left_offset
		pos.y = -pos.y

		# # Convert grid space → pixel space
		var pixel_pos = pos * pixels_per_grid_space

		# Make IO smaller than a full grid cell
		var io_size = Vector2(
			pixels_per_grid_space,
			pixels_per_grid_space
		)

		add_rectangle(pixel_pos, io_size, color)


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
