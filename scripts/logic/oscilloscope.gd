class_name Oscilloscope 
extends Building

const INPUT_INDEX := 0

# An oscillocope is passive and only reads its input
func _init(input_pos: Vector2i, _building_base_instance: BuildingBase):
    var new_connections: Array[Connection] = []
    new_connections.append(Connection.new(self, ConnectionType.INPUT, input_pos))
    building_base_instance = _building_base_instance

    connections = new_connections