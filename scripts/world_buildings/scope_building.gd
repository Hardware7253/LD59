extends WaveViewerBase
class_name OscilloscopeBuilding


func _ready() -> void:
	my_grid_item = Oscilloscope.new(
		get_connection_grid_pos(input_positions[0]),
		self
	)

	super._ready()

func update_building():
	display_waveform = my_grid_item.input_connections[0].waveform
