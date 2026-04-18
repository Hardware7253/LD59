class_name Divisor 
extends MathBuilding

# Set the output wave to be input wave 1 / input wave 2
func building_operation():
    connections[OUTPUT_INDEX].waveform = CompositeWave.new(connections[INPUT_1_INDEX].waveform, CompositeWave.WaveOperators.DIV, connections[INPUT_2_INDEX].waveform)