class_name Building 
extends GridItem

var building_updated := false
var conditional_output := true 

enum ConnectionType {INPUT, OUTPUT}
class Connection:
	var building: Building                  # The building this connection is from
	var connection_type: ConnectionType     # I / O
	var pos: Vector2i                       # Position of the connection (global not relative to the object)
	var waveform: Waveform                  # The waveform being received or output
	var input_updated: bool                 # True if this input has already been updated 

	func _init(_building: Building, _connection_type: ConnectionType, _pos: Vector2i, _waveform: Waveform = PrimitiveWave.new()):
		self.building = _building
		self.connection_type = _connection_type
		self.pos = _pos
		self.waveform = _waveform
		self.input_updated = false

var connections: Array[Connection] = []

func pre_evaluate():
	building_updated = false
	for connection in connections:
		connection.input_updated = false

		# Reset the output waveform if it needs to be calculated from the inputs
		if conditional_output and connection.connection_type == ConnectionType.OUTPUT:
			connection.waveform = PrimitiveWave.new()

# Gets the output connection
# Returns null if there is none
func get_output() -> Connection:
	for connection in connections:
		if connection.connection_type == ConnectionType.OUTPUT:
			return connection
	return null


# Carries the signal from this buildings output to the next connected buildings input
func scan_from_output() -> Result:

	# Get the output, or return early if we don't have one
	var start_connection := get_output()
	if start_connection == null:
		return Result.new(Result.ResultType.OK)

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
		var update_result := connection.building.update_building()
		if update_result.type == Result.ResultType.ERROR:
			return update_result

	return Result.new(Result.ResultType.OK)
	

# Scans for the output connected to the given input 
# Then updates that building
func scan_from_input(input_connection: Connection) -> Result:

	# Skip over inputs that have already been updated
	if input_connection.input_updated:
		return Result.new(Result.ResultType.OK)

	# Update connected output
	var connections_array := _get_connections(input_connection)
	for connection in connections_array:
		if connection.connection_type == ConnectionType.OUTPUT:
			if connection.building == input_connection.building:
				return Result.new(Result.ResultType.ERROR, "building output connected to its input")

			var update_result := connection.building.update_building()
			if update_result.type == Result.ResultType.ERROR:
				return update_result

	return Result.new(Result.ResultType.OK)


# Base building update function for: 
# 1. Gathering inputs
# 2. Performing operation
# 3. Outputting
func update_building() -> Result:
	if building_updated:
		return Result.new(Result.ResultType.OK)

	building_updated = true

	# 1. Gathering inputs
	for connection in connections:
		if connection.connection_type == ConnectionType.INPUT:
			var scan_i_result := scan_from_input(connection)
			if scan_i_result.type == Result.ResultType.ERROR:
				return scan_i_result 


	# 2. Performing operation
	building_operation()


	# 3. Outputting
	var scan_o_result := scan_from_output()
	if scan_o_result.type == Result.ResultType.ERROR:
		return scan_o_result 


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
func _get_wire_connections(pos: Vector2i, start_connection: Connection, scanned_wires := {}) -> Array[Connection]:
	var wire_connections: Array[Connection] = []

	for neighbor_pos in grid.get_neighbor_positions(pos):
		var grid_item: GridItem = grid.grid_dict[neighbor_pos]

		if grid_item is Wire:


			# Check we haven't already scanned this wire
			if not scanned_wires.has(neighbor_pos):

				# Recurse to continue scanning connected wires
				scanned_wires[neighbor_pos] = true
				wire_connections.append_array(_get_wire_connections(neighbor_pos, start_connection, scanned_wires))

		elif grid_item is Building:
			for connection in grid_item.connections:
				if connection != start_connection && connection.pos == neighbor_pos:
					wire_connections.append(connection)

	return wire_connections
