extends Control 

@export var grid_size := Vector2i(12, 8)
@export var hotbar: Hotbar

@export var cell_texture: Texture
@export var cell_container: Node2D
@export var building_container: Node2D

@export var hover_sound: AudioStreamPlayer
@export var place_sound: AudioStreamPlayer

var grid_top_left: Vector2i # Position of the top left grid element
var ghost_instance: BuildingBase

# Used to detect when hover position changes to paly sound
var last_mouse_grid_pos: Vector2i

func _ready() -> void:
	generate_grid()
	center_grid()

	hotbar.connect("new_hotbar_building", _on_new_hotbar_building)
	hotbar.connect("hotbar_deselect", _on_hotbar_deselect)

# Init grid
func generate_grid() -> void:
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			var grid_pos = Vector2i(x, y)

			# Create a new sprite for each cell
			var sprite = Sprite2D.new()
			sprite.z_index = -1
			sprite.texture = cell_texture
			sprite.scale = Vector2(grid.GRID_PIXELS / sprite.texture.get_width(), grid.GRID_PIXELS / sprite.texture.get_height())
			sprite.position = grid.grid_to_world(grid_pos)
			cell_container.add_child(sprite)

# Center grid in viewport
func center_grid() -> void:
	var viewport_size = get_viewport().get_size()
	var half_world_grid_size = (Vector2(grid_size) * float(grid.GRID_PIXELS)) / 2
	var center_pos = Vector2(viewport_size) / 2
	cell_container.position += grid.snap_to_grid(center_pos - half_world_grid_size)
	grid_top_left = grid.world_to_grid(cell_container.position)


func is_within_bounds(grid_pos: Vector2i) -> bool:
	var in_x := grid_pos.x >= grid_top_left.x and grid_pos.x < grid_top_left.x + grid_size.x
	var in_y := grid_pos.y >= grid_top_left.y and grid_pos.y < grid_top_left.y + grid_size.y
	return in_x and in_y

# Spawn new ghost building
func _on_new_hotbar_building(building: buildings.BuildingType):
	if ghost_instance:
		ghost_instance.queue_free()

	ghost_instance = building.packed_scene.instantiate()
	building_container.add_child(ghost_instance)
	ghost_instance.z_index = 4
	ghost_instance.global_position = Vector2(500, 300)
	ghost_instance.hide()

# Delete ghost building
func _on_hotbar_deselect():
	ghost_instance.queue_free()
	ghost_instance = null

func _process(_delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var m_grid_pos = grid.world_to_grid(mouse_pos)

	if ghost_instance:
		ghost_instance.show()

		ghost_instance.position = grid.grid_to_world(m_grid_pos)
		
		if can_place_ghost():
			ghost_instance.modulate = game_colors.GHOST_MODULATION_COLOR

			# If the placement button is pressed the ghost can be added to the grid
			if Input.is_action_pressed("place_button"): # Allow dragging while placing
				ghost_instance.modulate = game_colors.RESET_MODULATION_COLOR
				ghost_instance.add_to_grid()
				ghost_instance = null

				if place_sound:
					place_sound.play()

				grid.evaluate()

				# Make a new ghost instance
				_on_new_hotbar_building(hotbar.active_building)
		else:
			ghost_instance.modulate = game_colors.GHOST_ERROR_MODULATION_COLOR

	var blocking_grid_item := grid.get_grid_item(m_grid_pos)
	if blocking_grid_item && Input.is_action_pressed("delete_button"): # Allow dragging while deleting
		var building := blocking_grid_item.building_base_instance
		building.erase_from_grid()
		building.queue_free()

		grid.evaluate()

	if m_grid_pos != last_mouse_grid_pos && is_within_bounds(m_grid_pos):
		if hover_sound:
			hover_sound.play()

	last_mouse_grid_pos = m_grid_pos

# Return true if the ghost instance can be placed at it's current position
# Assumes the ghost instance is valid
func can_place_ghost() -> bool:
	var grid_positions: Array[Vector2i] = ghost_instance.get_grid_positions()
	for grid_pos in grid_positions:
		if not is_within_bounds(grid_pos):
			return false

		if grid.grid_dict.has(grid_pos):
			return false

	return true
