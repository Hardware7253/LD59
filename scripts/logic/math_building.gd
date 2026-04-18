class_name MathBuilding 
extends Building

const OUTPUT_INDEX := 0
const INPUT_1_INDEX := 1
const INPUT_2_INDEX := 2

# A math building is a building with an output and two inputs
func _init(output_pos: Vector2i, input_1_pos: Vector2i, input_2_pos: Vector2i):
    var new_connections: Array[Connection] = []

    new_connections.append(Connection.new(self, ConnectionType.OUTPUT, output_pos))
    new_connections.append(Connection.new(self, ConnectionType.INPUT, input_1_pos))
    new_connections.append(Connection.new(self, ConnectionType.INPUT, input_2_pos))

    connections = new_connections
    conditional_output = true
