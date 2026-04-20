extends WaveViewerBase
class_name OscilloscopeBuilding

func _ready() -> void:
	wave_color = game_graphics.OSCILLOSCOPE_LINE_COLOR

	super._ready()

func init_grid_item():
	my_grid_item = Oscilloscope.new(
		get_connection_grid_pos(input_positions[0]),
		self
	)

func update_building():
	display_waveform = my_grid_item.connections[0].waveform
	redraw()
