extends Node

var wave_gen_building := BuildingType.new("wave generator", preload("res://scenes/buildings/gen_building.tscn"))
var goal_building := BuildingType.new("goal", preload("res://scenes/buildings/goal_building.tscn"))
var wire_building := BuildingType.new("wire", preload("res://scenes/buildings/wire_building.tscn"))
var oscilloscope_building := BuildingType.new("oscilloscope", preload("res://scenes/buildings/scope_building.tscn"))
var adder_building := BuildingType.new("adder", preload("res://scenes/buildings/add_building.tscn"))
var subtractor_building := BuildingType.new("subtractor", preload("res://scenes/buildings/subtract_building.tscn"))
var multiplier_building := BuildingType.new("multiplier", preload("res://scenes/buildings/multiply_building.tscn"))
var divider_building := BuildingType.new("divider", preload("res://scenes/buildings/divide_building.tscn"))

var all_buildings = [
	wire_building,
	oscilloscope_building,
	adder_building,
	subtractor_building,
	multiplier_building,
	divider_building
] as Array[BuildingType]

class LevelBuilding:
	var offset: Vector2i # Grid offset of this building from the bottom left of the grid
	var building: BuildingType

	# Input / output waveform
	var waveform: Waveform

	func _init(_building: BuildingType, _waveform: Waveform, _offset: Vector2i) -> void:
		offset = _offset
		waveform = _waveform
		building = _building

class Level:
	var grid_size: Vector2i 					 # Size of the grid the player can place on
	var wave_gens: Array[LevelBuilding]			 # Unbreakable level wave gens
	var goal: LevelBuilding						 # Unbreakable level goal
	var hotbar_buildings: Array[BuildingType] 	 # Buildings the player has available in this level
	var level_completed: bool					 # True once the user has beat the level oncce

	var hint_message: String

	func _init(
		_grid_size: Vector2i,
		_hotbar_buildings: Array[BuildingType],
		_goal: LevelBuilding,
		_wave_gens: Array[LevelBuilding],
		_hint_message: String = "  No hints available  ",
	) -> void:
		grid_size = _grid_size
		goal = _goal
		wave_gens = _wave_gens
		hint_message = _hint_message
		hotbar_buildings = _hotbar_buildings
		level_completed = false

# Increments the selected level index and the selected level
func inc_level():
	selected_level_index += 1
	if selected_level_index >= len(levels):
		selected_level_index = len(levels) - 1

	selected_level = levels[selected_level_index]

# The currently selected level
var selected_level_index := 0
var selected_level: Level = null

var levels: Array[Level] = [

	# Teach the user what the signal generator and goal does
	Level.new(

		# Grid size
		Vector2i(10, 3),

		# Hotbar buildings
		[
			wire_building,
		] as Array[BuildingType],


		# Goal
		LevelBuilding.new(goal_building, PrimitiveWave.new(3.0, PrimitiveWave.WaveType.SINE, 1.0), Vector2i(7, 0)),

		# Wave gens
		[
			LevelBuilding.new(wave_gen_building, PrimitiveWave.new(3.0, PrimitiveWave.WaveType.SINE, 1.0), Vector2i(0, 0)),
		],

		# Hint message
		"  Seriously?  ",
	),

	# Encourage the player to experiment with scopes
	Level.new(

		# Grid size
		Vector2i(10, 10),

		# Hotbar buildings
		[
			wire_building,
			oscilloscope_building,
		] as Array[BuildingType],

		# Goal
		LevelBuilding.new(goal_building, PrimitiveWave.new(3.0, PrimitiveWave.WaveType.SINE, 1.0), Vector2i(7, 0)),

		# Wave gens
		[
			LevelBuilding.new(wave_gen_building, PrimitiveWave.new(3.0, PrimitiveWave.WaveType.SINE, 1.0), Vector2i(0, 3)),
			LevelBuilding.new(wave_gen_building, PrimitiveWave.new(2.0, PrimitiveWave.WaveType.SINE, 2.0), Vector2i(0, 0)),
		],

		# Hint message
		"  Seriously?  ",
	),

	# Adding multiple waves
	Level.new(

		# Grid size
		Vector2i(15, 10),

		# Hotbar buildings
		[
			wire_building,
			oscilloscope_building,
			adder_building,
		] as Array[BuildingType],


		# Goal
		LevelBuilding.new(goal_building, 
			CompositeWave.new(
				PrimitiveWave.new(2.5, PrimitiveWave.WaveType.SINE, 0.5),
				CompositeWave.WaveOperators.ADD,
				PrimitiveWave.new(2.5, PrimitiveWave.WaveType.SINE, 1.0),
			),
		Vector2i(12, 0)),

		# Wave gens
		[
			LevelBuilding.new(wave_gen_building, PrimitiveWave.new(2.5, PrimitiveWave.WaveType.SINE, 1.0), Vector2i(0, 0)),
			LevelBuilding.new(wave_gen_building, PrimitiveWave.new(2.5, PrimitiveWave.WaveType.SINE, 0.5), Vector2i(0, 3)),
		],

		# Hint message
		"  Addition  ",
	),

	# Multiplication
	# Multiply the wave by a constant
	Level.new(

		# Grid size
		Vector2i(9, 12),


		# Hotbar buildings
		[
			wire_building,
			oscilloscope_building,
			multiplier_building,
		] as Array[BuildingType],

		# Goal
		LevelBuilding.new(goal_building, PrimitiveWave.new(3.0, PrimitiveWave.WaveType.SINE, 1.0), Vector2i(6, 9)),

		# Wave gens
		[
			LevelBuilding.new(wave_gen_building, PrimitiveWave.new(1.0, PrimitiveWave.WaveType.SINE, 1.0), Vector2i(0, 0)),
			LevelBuilding.new(wave_gen_building, PrimitiveWave.new(3.0, PrimitiveWave.WaveType.DC), Vector2i(0, 6)),
		],

		# Hint message
		"  The required sine wave is 3x the input sine wave  ",
	),


	# Addition
	# Adding the same wave to itself
	Level.new(

		# Grid size
		Vector2i(15, 6),


		# Hotbar buildings
		[
			wire_building,
			oscilloscope_building,
			adder_building,
			multiplier_building,
		] as Array[BuildingType],

		# Goal
		LevelBuilding.new(goal_building, PrimitiveWave.new(4.0, PrimitiveWave.WaveType.SINE, 1.0), Vector2i(12, 0)),

		# Wave gens
		[
			LevelBuilding.new(wave_gen_building, PrimitiveWave.new(2.0, PrimitiveWave.WaveType.SINE, 1.0), Vector2i(0, 0)),
			LevelBuilding.new(wave_gen_building, PrimitiveWave.new(5.0, PrimitiveWave.WaveType.DC), Vector2i(0, 3)),
		],

		# Hint message
		"  No multiplication required  ",
	),

	# Subtraction 
	# Using subtraction to create zero
	Level.new(

		# Grid size
		Vector2i(9, 8),

		# Hotbar buildings
		all_buildings,

		# Goal
		LevelBuilding.new(goal_building, PrimitiveWave.new(0.0, PrimitiveWave.WaveType.DC), Vector2i(6, 5)),

		# Wave gens
		[
			LevelBuilding.new(wave_gen_building, PrimitiveWave.new(2.0, PrimitiveWave.WaveType.SINE, 0.5), Vector2i(0, 0)),
		],

		# Hint message
		"  1 - 1 = 0  ",
	),

	# Division to make a DC wave
	Level.new(

		# Grid size
		Vector2i(15, 12),

		# Hotbar buildings
		all_buildings,

		# Goal
		LevelBuilding.new(goal_building, PrimitiveWave.new(1.0, PrimitiveWave.WaveType.DC), Vector2i(12, 0)),

		# Wave gens
		[
			LevelBuilding.new(wave_gen_building, PrimitiveWave.new(4.0, PrimitiveWave.WaveType.SINE, 0.5), Vector2i(0, 0)),
		],

		# Hint message
		"  5 / 5 = 1  ",
	),

	# Introduce multiplication
	Level.new(

		# Grid size
		Vector2i(10, 10),

		# Hotbar buildings
		all_buildings,

		# Goal
		LevelBuilding.new(goal_building, 
			CompositeWave.new(
				PrimitiveWave.new(0.5, PrimitiveWave.WaveType.SINE, 1.0, 3 * PI / 2),
				CompositeWave.WaveOperators.ADD,
				PrimitiveWave.new(0.5, PrimitiveWave.WaveType.DC),
			),
		Vector2i(7, 7)),

		# Wave gens
		[
			LevelBuilding.new(wave_gen_building, PrimitiveWave.new(1.0, PrimitiveWave.WaveType.SINE, 0.5), Vector2i(0, 0)),
		],

		# Hint message
		"  A negative times a negative maks a positive  ",
	),

	# Apply a DC offset to wave
	Level.new(

		# Grid size
		Vector2i(16, 16),

		# Hotbar buildings
		all_buildings,

		# Goal
		LevelBuilding.new(goal_building, 
			CompositeWave.new(
				PrimitiveWave.new(1, PrimitiveWave.WaveType.SINE, 1.0),
				CompositeWave.WaveOperators.ADD,
				PrimitiveWave.new(3, PrimitiveWave.WaveType.DC),
			),
		Vector2i(13, 13)),

		# Wave gens
		[
			LevelBuilding.new(wave_gen_building, PrimitiveWave.new(1.0, PrimitiveWave.WaveType.SINE, 1.0), Vector2i(0, 0)),
		],

		# Hint message
		"  The output wave has a constant offset of 3, how can you produce a constant value?  ",
	),

	# Ampltude modulation with a DC offset
	Level.new(

		# Grid size
		Vector2i(19, 12),

		# Hotbar buildings
		all_buildings,

		# Goal
		LevelBuilding.new(goal_building, 
			CompositeWave.new(
				CompositeWave.new(
					PrimitiveWave.new(1, PrimitiveWave.WaveType.SINE, 10.0),
					CompositeWave.WaveOperators.MULT,
					PrimitiveWave.new(1, PrimitiveWave.WaveType.SINE, 0.2),
				),
				CompositeWave.WaveOperators.ADD,
				PrimitiveWave.new(1, PrimitiveWave.WaveType.DC),
			),
		Vector2i(16, 9)),

		# Wave gens
		[
			LevelBuilding.new(wave_gen_building, PrimitiveWave.new(1.0, PrimitiveWave.WaveType.SINE, 10), Vector2i(0, 3)),
			LevelBuilding.new(wave_gen_building, PrimitiveWave.new(1.0, PrimitiveWave.WaveType.SINE, 0.2), Vector2i(0, 0)),
		],

		# Hint message
		"  Amplitude Modulation  ",
	),

	# Adding and multiplying waves
	Level.new(

		# Grid size
		Vector2i(19, 18),

		# Hotbar buildings
		all_buildings,

		# Goal
		LevelBuilding.new(goal_building,
			CompositeWave.new(
				CompositeWave.new(
					PrimitiveWave.new(0.5, PrimitiveWave.WaveType.SINE, 2.0),
					CompositeWave.WaveOperators.ADD,
					PrimitiveWave.new(0.5, PrimitiveWave.WaveType.SINE, 0.3),
				),
				CompositeWave.WaveOperators.MULT,
				PrimitiveWave.new(4.0, PrimitiveWave.WaveType.DC),
			),
		Vector2i(16, 10)),

		# Wave gens
		[
			LevelBuilding.new(wave_gen_building, PrimitiveWave.new(0.5, PrimitiveWave.WaveType.SINE, 2.0), Vector2i(0, 0)),
			LevelBuilding.new(wave_gen_building, PrimitiveWave.new(0.5, PrimitiveWave.WaveType.SINE, 1.0), Vector2i(0, 3)),
			LevelBuilding.new(wave_gen_building, PrimitiveWave.new(0.5, PrimitiveWave.WaveType.SINE, 0.3), Vector2i(0, 6)),
		],

		# Hint message
		"  Does the sum of any the generator waves look similar to the goal?  ",
	),

	# Subtract signals to change phase
	Level.new(

		# Grid size
		Vector2i(16, 10),

		# Hotbar buildings
		all_buildings,

		# Goal
		LevelBuilding.new(goal_building, PrimitiveWave.new(2.5, PrimitiveWave.WaveType.SINE, 0.5, PI), Vector2i(12, 3)),

		# Wave gens
		[
			LevelBuilding.new(wave_gen_building, PrimitiveWave.new(5.0, PrimitiveWave.WaveType.SINE, 0.5), Vector2i(0, 6)),
			LevelBuilding.new(wave_gen_building, PrimitiveWave.new(3.0, PrimitiveWave.WaveType.DC), Vector2i(0, 3)),
			LevelBuilding.new(wave_gen_building, PrimitiveWave.new(2.5, PrimitiveWave.WaveType.SINE, 0.5), Vector2i(0, 0)),
		],

		# Hint message
		" Look at the peaks of each waveform, how can you combine the input peaks to achieve the goal peaks?  ",
	),

]
