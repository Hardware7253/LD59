class_name MathBuilding 
extends Building

const OUTPUT_INDEX := 0
const INPUT_1_INDEX := 1
const INPUT_2_INDEX := 2

# A math building is a building with an output and two inputs
func _init(output_pos: Vector2i, input_1_pos: Vector2i, input_2_pos: Vector2i, _building_base_instance: BuildingBase):
	var new_connections: Array[Connection] = []

	new_connections.append(Connection.new(self, ConnectionType.OUTPUT, output_pos))
	new_connections.append(Connection.new(self, ConnectionType.INPUT, input_1_pos))
	new_connections.append(Connection.new(self, ConnectionType.INPUT, input_2_pos))

	building_base_instance = _building_base_instance

	connections = new_connections
	conditional_output = true

# Returns true if the output is valid
func is_output_valid() -> bool:

	# The output is not valid if any of the inputs have a none waveform
	for connection in connections:
		if connection.connection_type == Building.ConnectionType.INPUT:
			if connection.waveform is PrimitiveWave:
				if connection.waveform.wave_type == PrimitiveWave.WaveType.NONE:
					return false 

	return true 
