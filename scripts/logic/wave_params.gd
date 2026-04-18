extends Node

# Wave visualisers will be scaled to fit the max magnitude and full time window
const MAX_MAG := 5.0

# Eval t start is 0 implicitly
const EVAL_T_END := 5.0
const EVAL_TIME_STEP := EVAL_T_END / 1000

# Returns true if the waves are the same
func are_waves_same(wave_1: Waveform, wave_2: Waveform) -> bool:

	var time := 0.0 
	while time < EVAL_T_END:

		var p1 = wave_1.evaluate(time)
		var p2 = wave_2.evaluate(time)

		if !is_equal_approx(p1, p2):
			return false

		time += EVAL_TIME_STEP 


	return true
