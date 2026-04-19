class_name SignalGenerator
extends Building

const OUTPUT_INDEX := 0

# A signal generator always outputs its wave
func _init(output_pos: Vector2i, output_wave: Waveform, _building_base_instance: BuildingBase):
	var new_connections: Array[Connection] = []
	new_connections.append(Connection.new(self, ConnectionType.OUTPUT, output_pos, output_wave))
	building_base_instance = _building_base_instance

	connections = new_connections
	conditional_output = false 
