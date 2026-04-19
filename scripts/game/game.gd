extends Control 


@export var grid_size := Vector2i(12, 8)
@export var hotbar: Hotbar

@export var cell_texture: Texture
@export var cell_container: Node2D
@export var building_container: Node2D

var grid_top_left: Vector2i # Position of the top left grid element
var ghost_instance: BuildingBase

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
	if ghost_instance:
		ghost_instance.show()

		var mouse_pos = get_global_mouse_position()
		var m_grid_pos = grid.world_to_grid(mouse_pos)
		ghost_instance.position = grid.grid_to_world(m_grid_pos)
		
		if can_place_ghost():
			ghost_instance.modulate = game_colors.GHOST_MODULATION_COLOR

			# If the placement button is pressed the ghost can be added to the grid
			if Input.is_action_just_pressed("place_button"):
				ghost_instance.modulate = game_colors.RESET_MODULATION_COLOR
				ghost_instance.add_to_grid()
				ghost_instance = null

				_on_new_hotbar_building(hotbar.active_building)
		else:
			ghost_instance.modulate = game_colors.GHOST_ERROR_MODULATION_COLOR

			# var blocking_grid_item := grid.get_grid_item(m_grid_pos)
			# if blocking_grid_item && Input.is_action_just_pressed("delete_button"):
			# 	blocking_grid_item

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




# # updating ghost visuals
# func _process(_delta: float) -> void:
# 	if hotbar.is_building_selected:
# 		var mouse_pos = get_global_mouse_position()
# 		var m_grid_pos = world_to_grid(mouse_pos)
# 		ghost.position = grid_to_world(m_grid_pos)
		
# 		var b_size = get_building_size(ghost)
# 		ghost.modulate = Color(1, 1, 1, 0.5) if can_place(m_grid_pos, b_size) else Color(1, 0.3, 0.3, 0.5)





# # ------------------------ my stuff
# func _ready() -> void:
	
# 	# not sure of a better way to wait for the level scene to load
# 	if not cell_scene:
# 		return
		
# 	if hotbar:
# 		hotbar.build_selected.connect(_on_build_selected)
	
# 	generate_grid()

# # init grid
# func generate_grid() -> void:
# 	for x in range(grid_size.x):
# 		for y in range(grid_size.y):
# 			var grid_pos = Vector2i(x, y)
# 			grid_dict[grid_pos] = null # set each cell to null initially
			
# 			# draw cell visuals
# 			var cell = cell_scene.instantiate() 
# 			cell.position = grid_to_world(grid_pos)
# 			add_child(cell)

# # updating ghost visuals
# func _process(_delta: float) -> void:
# 	if ghost:
# 		var mouse_pos = get_global_mouse_position()
# 		var m_grid_pos = world_to_grid(mouse_pos)
# 		ghost.position = grid_to_world(m_grid_pos)
		
# 		var b_size = get_building_size(ghost)
# 		ghost.modulate = Color(1, 1, 1, 0.5) if can_place(m_grid_pos, b_size) else Color(1, 0.3, 0.3, 0.5)

# # update ghost model
# func _on_build_selected(type: int):
# 	current_build = type as BuildType
# 	update_ghost()

# func update_ghost():
# 	if ghost:
# 		ghost.queue_free()
# 		ghost = null
	
# 	if current_build == BuildType.NONE:
# 		return
	
# 	var scene = get_building_scene(current_build)
# 	if scene:
# 		ghost = scene.instantiate()
# 		add_child(ghost)
# 		ghost.set_process(false)

# # find building by name
# func get_building_scene(build_type: int) -> PackedScene:
# 	var build_name = BuildType.keys()[build_type].to_lower()
	
# 	var path = "res://scenes/buildings/%s.tscn" % build_name
# 	return load(path) if FileAccess.file_exists(path) else null

# # using metadata for size
# func get_building_size(node: Node) -> Vector2i:
# 	if node.has_meta("Size"):
# 		return node.get_meta("Size")
# 	return Vector2i(10, 10)

# ## draw visuals and update dict
# func place_building(grid_pos: Vector2i, scene: PackedScene) -> void:
# 	var temp_instance = scene.instantiate()
# 	var b_size = get_building_size(temp_instance)
	
# 	if not can_place(grid_pos, b_size):
# 		print("Placement blocked at: ", grid_pos, " for size: ", b_size)
# 		temp_instance.queue_free()
# 		return
	
# 	temp_instance.position = grid_to_world(grid_pos)
# 	temp_instance.set_meta("grid_pos", grid_pos)
# 	add_child(temp_instance)
	
# 	for x in range(b_size.x):
# 		for y in range(b_size.y):
# 			var target_pos = grid_pos + Vector2i(x, y)
# 			grid_dict[target_pos] = temp_instance
	
# 	if temp_instance is GridItem:
# 		evaluate()

# func delete_building(target_pos: Vector2i) -> void:
# 	var target = grid_dict.get(target_pos)
# 	if target != null:
# 		var origin = target.get_meta("grid_pos")
# 		var b_size = get_building_size(target)
		
# 		for x in range(b_size.x):
# 			for y in range(b_size.y):
# 				var pos_to_clear = origin + Vector2i(x, y)
# 				grid_dict[pos_to_clear] = null
		
# 		target.queue_free()

# # handle key/mouse input
# func _input(event: InputEvent) -> void:
# 	if event is InputEventMouseButton and event.pressed:
# 		var m_grid_pos = world_to_grid(get_global_mouse_position())
		
# 		if event.button_index == MOUSE_BUTTON_LEFT:
# 			if current_build != BuildType.NONE:
# 				var scene = get_building_scene(current_build)
# 				if scene: place_building(m_grid_pos, scene)
		
# 		elif event.button_index == MOUSE_BUTTON_RIGHT:
# 			delete_building(m_grid_pos)
