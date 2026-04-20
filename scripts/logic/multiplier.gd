class_name Multiplier 
extends MathBuilding

# Set the output wave to be input wave 1 * input wave 2
func building_operation():
	if is_output_valid():
		connections[OUTPUT_INDEX].waveform = CompositeWave.new(connections[INPUT_1_INDEX].waveform, CompositeWave.WaveOperators.MULT, connections[INPUT_2_INDEX].waveform)
	else:
		connections[OUTPUT_INDEX].waveform = PrimitiveWave.new()

