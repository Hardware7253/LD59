extends Node

# Wave visualisers will be scaled to fit the max magnitude and full time window
const MAX_MAG := 5.0

# Eval t start is 0 implicitly
const EVAL_T_END := 5.0
const EVAL_STEPS := 1000
const EVAL_TIME_STEP := EVAL_T_END / EVAL_STEPS
const WAVE_SIMILARITY_PERCENT = 99.0 # 99 % of samples in the waveform must be the same for the waves to be considered the same

# Returns true if the waves are the same or very similar
func are_waves_same(wave_1: Waveform, wave_2: Waveform) -> bool:

	var not_same_values := 0

	var time := 0.0 
	while time < EVAL_T_END:

		var p1 = wave_1.evaluate(time)
		var p2 = wave_2.evaluate(time)

		if !is_equal_approx(p1, p2):
			not_same_values += 1

		time += EVAL_TIME_STEP 

	var similarity_percent := (1 - (not_same_values / float(EVAL_STEPS))) * 100.0
	return similarity_percent > WAVE_SIMILARITY_PERCENT
