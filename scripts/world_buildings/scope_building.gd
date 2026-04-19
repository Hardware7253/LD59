extends WaveViewerBase
class_name OscilloscopeBuilding


func _ready() -> void:
	super._ready()

	building_type = Oscilloscope.new(
		get_connection_grid_pos(input_positions[0])
	)

func update_building():
	display_waveform = building_type.input_connections[0].waveform
