class_name Goal 
extends Building

const INPUT_INDEX := 0
var goal_waveform: Waveform

# A goal is passive and only reads its input
func _init(input_pos: Vector2i, _goal_waveform: Waveform):
	var new_connections: Array[Connection] = []
	new_connections.append(Connection.new(self, ConnectionType.INPUT, input_pos))

	connections = new_connections
	goal_waveform = _goal_waveform

# Returns true if the input wave is the same as the goal wave
func is_goal_complete() -> bool:
	return wave_params.are_waves_same(connections[INPUT_INDEX].waveform, goal_waveform)
