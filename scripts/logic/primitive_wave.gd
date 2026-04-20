class_name PrimitiveWave
extends Waveform

var magnitude: float # No units
var frequency: float # Hz
var phase: float = 0 # Radians
var wave_type: WaveType

enum WaveType {SINE, SQUARE, DC, NONE}

func _init(
	_magnitude: float = 0.0,
	_wave_type: WaveType = WaveType.NONE,
	_frequency: float = 1.0,
	_phase: float = 0.0
):
	self.magnitude = _magnitude
	self.frequency = _frequency
	self.phase = _phase 
	self.wave_type = _wave_type

func evaluate(t: float) -> float:
	var output := 0.0
	match wave_type:
		WaveType.SINE:
			output = magnitude * sin(2.0 * PI * frequency * t + phase)
		WaveType.SQUARE:
			output = magnitude * sign(sin(2.0 * PI * frequency * t + phase))
		WaveType.DC:
			output = magnitude
		WaveType.NONE:
			output = 0.0 

	return clamp(output, -wave_params.MAX_MAG, wave_params.MAX_MAG)
