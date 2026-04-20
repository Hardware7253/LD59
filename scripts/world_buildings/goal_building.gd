extends WaveViewerBase
class_name GoalBuilding

@export var goal_wave_type := PrimitiveWave.WaveType.SINE
@export var goal_wave_freq := 1.0
@export var goal_wave_mag := 1.0

# Allow the exported primitive waveform to be overwritten
var waveform: Waveform = null

func _ready() -> void:

	if not waveform:
		waveform = PrimitiveWave.new(goal_wave_mag, goal_wave_type, goal_wave_freq)

	display_waveform = waveform 

	super._ready()

func init_grid_item():
	my_grid_item = Goal.new(
		get_connection_grid_pos(input_positions[0]),
		waveform,
		self
	)
