extends WaveViewerBase
class_name GenBuilding

@export var output_wave_type := PrimitiveWave.WaveType.SINE
@export var output_wave_freq := 1.0
@export var output_wave_mag := 1.0

# Allow the exported primitive waveform to be overwritten
var waveform: Waveform = null

func _ready() -> void:

	if not waveform:
		waveform = PrimitiveWave.new(output_wave_mag, output_wave_type, output_wave_freq)

	display_waveform = waveform 

	super._ready()

func init_grid_item():
	my_grid_item = SignalGenerator.new(
		get_connection_grid_pos(output_positions[0]),
		waveform,
		self
	)
