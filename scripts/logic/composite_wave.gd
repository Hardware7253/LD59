class_name CompositeWave
extends Waveform

enum WaveOperators {ADD, SUB, MULT, DIV}

var wave_1: Waveform 
var operator: WaveOperators
var wave_2: Waveform 


func _init(w1: Waveform, op: WaveOperators, w2: Waveform):
	wave_1 = w1
	operator = op
	wave_2 = w2

func evaluate(t: float) -> float:
	var a: float = wave_1.evaluate(t)
	var b: float = wave_2.evaluate(t)

	match operator:
		WaveOperators.ADD:
			return a + b
		WaveOperators.SUB:
			return a - b
		WaveOperators.MULT:
			return a * b
		WaveOperators.DIV:
			if is_equal_approx(a, b):
				return 1.0
			return a / b

	return 0.0
