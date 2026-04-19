extends WaveViewerBase
class_name GenBuilding

@export var output_wave_type := PrimitiveWave.WaveType.SINE
@export var output_wave_freq := 1.0
@export var output_wave_mag := 1.0

# Reinitialize the waveform when the object is ready
func _ready() -> void:
	var output_wave := PrimitiveWave.new(output_wave_mag, output_wave_type, output_wave_freq)
	display_waveform = output_wave

	building_type = SignalGenerator.new(
		get_connection_grid_pos(output_positions[0]),
		output_wave
	)

	super._ready()
