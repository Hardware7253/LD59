class_name SignalGenerator
extends Building

const OUTPUT_INDEX := 0

# A signal generator always outputs its wave
func _init(output_pos: Vector2i, output_wave: Waveform):
	var new_connections: Array[Connection] = []
	new_connections.append(Connection.new(self, ConnectionType.OUTPUT, output_pos, output_wave))

	connections = new_connections
	conditional_output = false 
