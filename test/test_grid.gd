extends GutTest

func before_each() -> void:
	var connection_positions: Array[Vector2i] = []

	# Add signal gen 1 to grid
	connection_positions = [Vector2i(2, 6)]
	var signal_gen_1 := SignalGenerator.new(connection_positions[0], PrimitiveWave.new(2.0, PrimitiveWave.WaveType.SINE, 1.0))
	add_to_grid(signal_gen_1, connection_positions)
	grid.root_signal_generator_pos = connection_positions[0]

	# Add signal gen 2 to grid
	connection_positions = [Vector2i(2, 1)]
	var signal_gen_2 := SignalGenerator.new(connection_positions[0], PrimitiveWave.new(1.0, PrimitiveWave.WaveType.SINE, 2.0))
	add_to_grid(signal_gen_2, connection_positions)

	# Add adder to grid
	connection_positions = [Vector2i(8, 4), Vector2i(6, 5), Vector2i(6, 3)] # output, input_1, input_2
	var adder := Adder.new(connection_positions[0], connection_positions[1], connection_positions[2])
	add_to_grid(adder, connection_positions)

	# Add scope to grid
	connection_positions = [Vector2i(10, 7)]
	var scope := Oscilloscope.new(connection_positions[0])
	add_to_grid(scope, connection_positions)

	# Add goal to grid
	connection_positions = [Vector2i(12, 4)]
	var wave_1: Waveform = PrimitiveWave.new(2.0, PrimitiveWave.WaveType.SINE, 1.0)
	var wave_2: Waveform = PrimitiveWave.new(1.0, PrimitiveWave.WaveType.SINE, 2.0)
	var goal_waveform: Waveform = CompositeWave.new(wave_1, CompositeWave.WaveOperators.ADD, wave_2)
	var goal := Goal.new(connection_positions[0], goal_waveform)
	add_to_grid(goal, connection_positions)
	grid.goal = goal

	# Add wires connecting signal_gen_1 to adder 
	grid.add_to_grid(Wire.new(), Vector2i(3, 6))
	grid.add_to_grid(Wire.new(), Vector2i(4, 6))
	grid.add_to_grid(Wire.new(), Vector2i(4, 5))
	grid.add_to_grid(Wire.new(), Vector2i(5, 5))

	# Add wires connecting signal_gen_2 to adder 
	grid.add_to_grid(Wire.new(), Vector2i(3, 1))
	grid.add_to_grid(Wire.new(), Vector2i(4, 1))
	grid.add_to_grid(Wire.new(), Vector2i(5, 1))
	grid.add_to_grid(Wire.new(), Vector2i(4, 2))
	grid.add_to_grid(Wire.new(), Vector2i(5, 2))
	grid.add_to_grid(Wire.new(), Vector2i(5, 3))

	# Add wires connecting adder to scope and goal
	grid.add_to_grid(Wire.new(), Vector2i(9, 4))
	grid.add_to_grid(Wire.new(), Vector2i(10, 4))
	grid.add_to_grid(Wire.new(), Vector2i(11, 4))
	grid.add_to_grid(Wire.new(), Vector2i(10, 5))
	grid.add_to_grid(Wire.new(), Vector2i(10, 6))


# Adds a reference to the building in the grid wherever there is a connection
func add_to_grid(grid_item: GridItem, connection_positions: Array[Vector2i]):
	for connection_pos in connection_positions:
		grid.add_to_grid(grid_item, connection_pos)


func after_each() -> void:
	grid.grid_dict = {}

func test_1() -> void:
	grid.evaluate()
	var goal_complete := grid.goal.is_goal_complete()

	assert_eq(goal_complete, true)
