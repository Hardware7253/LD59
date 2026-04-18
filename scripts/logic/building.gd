class_name Building 
extends GridItem

var building_updated := false

enum ConnectionType {INPUT, OUTPUT}
class Connection:
    var building: Building                  # The building this connection is from
    var connection_type: ConnectionType     # I / O
    var pos: Vector2i                       # Position of the connection (global not relative to the object)
    var waveform: Waveform                  # The waveform being received or output
    var input_updated: bool                 # True if this input has already been updated 

var connections: Array[Connection]
var output_index := 0 # The index of the output connection in the connections array

func pre_evaluate():
    for connection in connections:
        connection.input_updated = false

# Carries the signal from this buildings output to the next connected buildings input
func scan_from_output() -> Result:
    var start_connection := connections[output_index]
    var connections_array := _get_connections(start_connection)

    # Set connected inputs to the output waveform
    for connection in connections_array:
        if connection.connection_type == ConnectionType.OUTPUT:
            return Result.new(Result.ResultType.ERROR, "multiply driven wire")
        else:
            connection.waveform = start_connection.waveform
            connection.input_updated = true
            
    # Update the connected buildings
    for connection in connections_array:
        connection.building.building_update()

    return Result.new(Result.ResultType.OK)
    

# Scans for the output connected to this buildings input
# Then updates that building
func scan_from_input() -> Result:

    return Result.new(Result.ResultType.OK)


# Base building update function for: 
# 1. Gathering inputs
# 2. Performing operation
# 3. Outputting
func building_update() -> Result:
    if building_updated:
        return

    building_updated = true

    # 1
    for connection in connections:
        if connection.connection_type == ConnectionType.INPUT:
            pass


    # 2
    building_operation()


    # 3

    return Result.new(Result.ResultType.OK)


# Implemented by building subclass
func building_operation():
    pass

# Returns the position of the start wire next to an input/output position
# Will return Vector2i.MIN if there is no start wire
func _get_start_wire_pos(connection_pos: Vector2i) -> Vector2i:
    for neighbor_pos in grid.get_neighbor_positions(connection_pos):
        var grid_item: GridItem = grid.grid_dict[neighbor_pos]

        if grid_item is Wire:
            return neighbor_pos

    return Vector2i.MIN 

# Returns an array of connections that are connected to the start connection
func _get_connections(start_connection: Connection) -> Array[Connection]:
    var start_wire_pos := _get_start_wire_pos(start_connection.pos)
    return _get_wire_connections(start_wire_pos, start_connection)


# Returns an array of Connections that are connected to a wire network starting at pos
# The start connection will be excluded from the output
func _get_wire_connections(pos: Vector2i, start_connection: Connection) -> Array[Connection]:
    var wire_connections: Array[Connection] = []

    for neighbor_pos in grid.get_neighbor_positions(pos):
        var grid_item: GridItem = grid.grid_dict[neighbor_pos]

        if grid_item is Wire:

            # Recurse to continue scanning connected wires
            if not grid_item.wire_scanned:
                wire_connections.append_array(_get_wire_connections(neighbor_pos, start_connection))

        elif grid_item is Building:
            for connection in grid_item.connections:
                if connection != start_connection && connection.pos == neighbor_pos:
                    wire_connections.append(connection)

    return wire_connections

func _check_valid_connections(connections_array: Array[Connection]) -> Result:


    return Result.new(Result.ResultType.OK)

