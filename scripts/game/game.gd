extends Control 

@export var grid_size := Vector2i(12, 8)
@export var hotbar: Hotbar

@export var cell_texture: Texture
@export var cell_container: Node2D
@export var building_container: Node2D

@export var hover_sound: AudioStreamPlayer
@export var place_sound: AudioStreamPlayer

@export var message_board: MessageBoard

var grid_bottom_left: Vector2i # Position of the bottom left grid element
var ghost_instance: BuildingBase

# Used to detect when hover position changes to play sound
var last_mouse_grid_pos: Vector2i

func _ready() -> void:
	load_level(levels.selected_level)

func load_level(level: levels.Level):
	grid_size = level.grid_size
	generate_grid()
	center_grid()

	# Remove old level data
	grid.reset_grid()

	hotbar.connect("new_hotbar_building", _on_new_hotbar_building)
	hotbar.connect("hotbar_deselect", _on_hotbar_deselect)

	# Place wave generator buildings 
	for wave_gen in level.wave_gens:
		place_level_building(wave_gen)

	# Place goal building
	var goal_building: BuildingBase = place_level_building(level.goal)
	if goal_building.my_grid_item is Goal:
		grid.goal = goal_building.my_grid_item

	# Tell the user if they have already played this level
	if message_board:
		if levels.selected_level.level_completed:
			message_board.display_message("  You have already beat this level  ", game_graphics.MSG_FONT_COLOR)


# Places the building in the level and returns its instance
func place_level_building(level_building: levels.LevelBuilding) -> BuildingBase:
	var building_instance: BuildingBase = level_building.building.packed_scene.instantiate()

	# Init building instance goal / output waveform
	if building_instance is GoalBuilding or building_instance is GenBuilding:
		building_instance.waveform = level_building.waveform

	building_instance.global_position += grid.grid_to_world(grid_bottom_left + level_building.offset)
	building_container.add_child(building_instance)
	building_instance.add_to_grid()

	# Level buildings are not deletable
	building_instance.deletable = false

	return building_instance

# Init grid
func generate_grid() -> void:
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			var grid_pos = Vector2i(x, y)

			# Create a new sprite for each cell
			var sprite = Sprite2D.new()
			sprite.z_index = -1
			sprite.texture = cell_texture
			sprite.scale = Vector2(grid.GRID_PIXELS / float(sprite.texture.get_width()), grid.GRID_PIXELS / float(sprite.texture.get_height()))
			sprite.position = grid.grid_to_world(grid_pos)
			sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			cell_container.add_child(sprite)


# Center grid in viewport
func center_grid() -> void:
	var viewport_size : Vector2i = get_viewport().get_visible_rect().size
	var half_world_grid_size: Vector2 = grid_size * (grid.GRID_PIXELS / 2.0)
	var center_pos := viewport_size / 2.0

	cell_container.position += grid.snap_to_grid(center_pos + Vector2(-half_world_grid_size.x, half_world_grid_size.y))
	grid_bottom_left = grid.world_to_grid(cell_container.position) 


func is_within_bounds(grid_pos: Vector2i) -> bool:
	var in_x := grid_pos.x >= grid_bottom_left.x and grid_pos.x < grid_bottom_left.x + grid_size.x
	var in_y := grid_pos.y >= grid_bottom_left.y and grid_pos.y < grid_bottom_left.y + grid_size.y
	return in_x and in_y

# Spawn new ghost building
func _on_new_hotbar_building(building: BuildingType):
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
			ghost_instance.modulate = game_graphics.GHOST_MODULATION_COLOR

			# If the placement button is pressed the ghost can be added to the grid
			if Input.is_action_pressed("place_button"):
				ghost_instance.modulate = game_graphics.RESET_MODULATION_COLOR
				ghost_instance.add_to_grid()
				ghost_instance = null

				if place_sound:
					place_sound.play()

				evaluate()

				# Make a new ghost instance
				_on_new_hotbar_building(hotbar.active_building)
		else:
			ghost_instance.modulate = game_graphics.GHOST_ERROR_MODULATION_COLOR
	
	# Delete buildings
	var blocking_grid_item := grid.get_grid_item(m_grid_pos)
	if blocking_grid_item && Input.is_action_pressed("delete_button"):

		var building := blocking_grid_item.building_base_instance
		if building.deletable:
			building.erase_from_grid()
			building.queue_free()

			evaluate()

	# Play hover sound
	if m_grid_pos != last_mouse_grid_pos && is_within_bounds(m_grid_pos):
		if hover_sound:
			hover_sound.play()
	last_mouse_grid_pos = m_grid_pos

# Evaluate the grid and handle errors
func evaluate():
	var eval_result := grid.evaluate()
	if eval_result.type == Result.ResultType.ERROR:
		print(eval_result.error_msg)

		# Propogate the error message to the user
		if message_board:
			message_board.display_message("  Error : " + eval_result.error_msg + "  ", game_graphics.ERROR_MSG_FONT_COLOR)

	else:
		var goal_complete := grid.goal.is_goal_complete()

		if goal_complete:

			# Let the user know they have resolved the level since the level complete screen won't show up anymore
			if levels.selected_level.level_completed:
				message_board.display_message("  Level Complete   ", game_graphics.MSG_FONT_COLOR)

			levels.selected_level.level_completed = true

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
