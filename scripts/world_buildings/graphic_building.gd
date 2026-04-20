extends BuildingBase
class_name GraphicBuilding

@export var texture: Texture

# Spawn the sprite associated with this building
func _ready() -> void:
	if texture:
		var sprite = Sprite2D.new()
		sprite.z_index = 2
		sprite.texture = texture 
		sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

		# Scale sprite to fit in building
		var target_size = Vector2(building_grid_size * grid.GRID_PIXELS) - Vector2(grid.PAD_PIXELS, grid.PAD_PIXELS) * 4
		sprite.scale = Vector2(target_size.x / sprite.texture.get_width(), target_size.y / sprite.texture.get_height())

		sprite.position = get_rel_center_pos()
		self.add_child(sprite)

	super._ready()
