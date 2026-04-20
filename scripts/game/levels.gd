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

	func _init(_grid_size: Vector2i, _goal: LevelBuilding, _wave_gens: Array[LevelBuilding]) -> void:
		grid_size = _grid_size
		goal = _goal
		wave_gens = _wave_gens

var levels: Array[Level] = [

	# Level 1
	Level.new(
		Vector2i(10, 3),
		LevelBuilding.new(goal_building, PrimitiveWave.new(1.0, PrimitiveWave.WaveType.SINE, 1.0), Vector2i(7, 0)),

		[
			LevelBuilding.new(wave_gen_building, PrimitiveWave.new(1.0, PrimitiveWave.WaveType.SINE, 1.0), Vector2i(0, 0)),
		]
	),

	# Level 2
	Level.new(
		Vector2i(10, 10),
		LevelBuilding.new(goal_building, PrimitiveWave.new(1.0, PrimitiveWave.WaveType.SINE, 1.0), Vector2i(7, 0)),

		[
			LevelBuilding.new(wave_gen_building, PrimitiveWave.new(1.0, PrimitiveWave.WaveType.SINE, 1.0), Vector2i(0, 0)),
		]
	)
]
