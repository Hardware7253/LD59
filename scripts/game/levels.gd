extends Node

var wave_gen_building := BuildingType.new("wave generator", preload("res://scenes/buildings/gen_building.tscn"))
var goal_building := BuildingType.new("goal", preload("res://scenes/buildings/goal_building.tscn"))

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
	var grid_size: Vector2i
	var wave_gens: Array[LevelBuilding]
	var goal: LevelBuilding
	var level_completed: bool

	func _init(_grid_size: Vector2i, _goal: LevelBuilding, _wave_gens: Array[LevelBuilding]) -> void:
		grid_size = _grid_size
		goal = _goal
		wave_gens = _wave_gens
		level_completed = false

var selected_level_index := 0

# Increments the selected level index and the selected level
func inc_level():
	selected_level_index += 1
	if selected_level_index >= len(levels):
		selected_level_index = len(levels) - 1

	selected_level = levels[selected_level_index]

# The currently selected level
# Initialise with a test level
var selected_level: Level = Level.new(
	Vector2i(15, 10),
	LevelBuilding.new(goal_building, PrimitiveWave.new(1.0, PrimitiveWave.WaveType.SINE, 1.0), Vector2i(12, 0)),

	[
		LevelBuilding.new(wave_gen_building, PrimitiveWave.new(1.0, PrimitiveWave.WaveType.SINE, 1.0), Vector2i(0, 0)),
	]
)

var levels: Array[Level] = [

	# Level 1
	# Teach the user what the signal generator and goal does
	Level.new(

		# Grid size
		Vector2i(10, 3),

		# Goal
		LevelBuilding.new(goal_building, PrimitiveWave.new(3.0, PrimitiveWave.WaveType.SINE, 1.0), Vector2i(7, 0)),

		# Wave gens
		[
			LevelBuilding.new(wave_gen_building, PrimitiveWave.new(3.0, PrimitiveWave.WaveType.SINE, 1.0), Vector2i(0, 0)),
		]
	),

	# Level 2
	# Adding multiple waves
	Level.new(

		# Grid size
		Vector2i(15, 10),

		# Goal
		LevelBuilding.new(goal_building, 
			CompositeWave.new(
				PrimitiveWave.new(2.5, PrimitiveWave.WaveType.SINE, 2.0),
				CompositeWave.WaveOperators.ADD,
				PrimitiveWave.new(2.5, PrimitiveWave.WaveType.SINE, 1.0),
			),
		Vector2i(12, 0)),

		# Wave gens
		[
			LevelBuilding.new(wave_gen_building, PrimitiveWave.new(2.5, PrimitiveWave.WaveType.SINE, 1.0), Vector2i(0, 0)),
			LevelBuilding.new(wave_gen_building, PrimitiveWave.new(2.5, PrimitiveWave.WaveType.SINE, 2.0), Vector2i(0, 3)),
		]
	),

	# Level 3
	# Addition
	Level.new(

		# Grid size
		Vector2i(15, 5),

		# Goal
		LevelBuilding.new(goal_building, PrimitiveWave.new(4.0, PrimitiveWave.WaveType.SINE, 1.0), Vector2i(12, 0)),

		# Wave gens
		[
			LevelBuilding.new(wave_gen_building, PrimitiveWave.new(2.0, PrimitiveWave.WaveType.SINE, 1.0), Vector2i(0, 0)),
		]
	),

	# Level 4
	# Division to make a DC wave
	Level.new(

		# Grid size
		Vector2i(15, 12),

		# Goal
		LevelBuilding.new(goal_building, PrimitiveWave.new(1.0, PrimitiveWave.WaveType.DC, 1.0), Vector2i(12, 0)),

		# Wave gens
		[
			LevelBuilding.new(wave_gen_building, PrimitiveWave.new(4.0, PrimitiveWave.WaveType.SINE, 0.5), Vector2i(0, 0)),
		]
	),


]
