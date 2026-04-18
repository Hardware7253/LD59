class_name PrimitiveWave
extends Waveform

var magnitude: float # No units
var frequency: float # Hz
var phase: float = 0 # Radians
var wave_type: WaveType

enum WaveType {SINE, SQUARE, DC, NONE}

func _init(mag: float = 0.0, type: WaveType = WaveType.NONE, freq: float = 1.0):
    self.magnitude = mag
    self.frequency = freq
    self.phase = 0 
    self.wave_type = type 

func evaluate(t: float) -> float:
    match wave_type:
        WaveType.SINE:
            return magnitude * sin(2.0 * PI * frequency * t + phase)
        WaveType.SQUARE:
            return magnitude * sign(sin(2.0 * PI * frequency * t + phase))
        WaveType.DC:
            return magnitude
        WaveType.NONE:
            return 1.0 
    return 0.0
