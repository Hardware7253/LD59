extends BuildingBase
class_name WaveViewerBase

var display_waveform: Waveform = PrimitiveWave.new()

@export var wave_viewer: WaveViewer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()

	var wave_viewer_size = building_grid_size * grid.GRID_PIXELS - Vector2i(grid.PAD_PIXELS, grid.PAD_PIXELS) * 5
	wave_viewer.position = get_rel_center_pos()
	wave_viewer.input_wave = display_waveform
	wave_viewer.wave_viewer_size = Vector2(wave_viewer_size)
	wave_viewer.line_color = game_colors.get_random_wave_viewer_color()

# Redraw the waveform
func redraw():
	wave_viewer.input_wave = display_waveform
	wave_viewer.queue_redraw()
