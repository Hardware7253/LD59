extends Node2D
class_name WaveViewer

var input_wave: Waveform = PrimitiveWave.new(5.0, PrimitiveWave.WaveType.SINE, 1.0)

# Test
# var wave_1: Waveform = PrimitiveWave.new(1.0, PrimitiveWave.WaveType.SINE, 1.0)
# var wave_2: Waveform = PrimitiveWave.new(1.0, PrimitiveWave.WaveType.SINE, 2.0)
# var input_wave: Waveform = CompositeWave.new(wave_1, CompositeWave.WaveOperators.ADD, wave_2)

# Pixel size of the waveform view
var wave_viewer_size := Vector2(200, 200)

var line_color := Color.WHITE
var line_width := game_graphics.WAVE_VIEWER_LINE_SIZE

# Draw the waveform
# Use queue_redraw() to redraw
func _draw():

	var time := 0.0 
	var last_point := Vector2(time, input_wave.evaluate(time))

	while time < wave_params.EVAL_T_END:
		time += wave_params.EVAL_TIME_STEP 
		var new_point := Vector2(time, input_wave.evaluate(time))
		draw_segment(last_point, new_point)

		last_point = new_point

# Draws a segment between two graph points
func draw_segment(gp1: Vector2, gp2: Vector2):
	draw_line(
		graph_point_to_pixel_point(gp1),
		graph_point_to_pixel_point(gp2),
		line_color, 
		line_width,
		true
	)

# Converts a point on the graph to a point in the wave viewer
# The wave is drawn such that it is centered in the node
func graph_point_to_pixel_point(gp: Vector2) -> Vector2:

	# Clip if the graph point goes outside the range
	gp.x = clamp(gp.x, 0.0, wave_params.EVAL_T_END)
	gp.y = clamp(gp.y, -wave_params.MAX_MAG, wave_params.MAX_MAG)

	return Vector2(
		gp.x * wave_viewer_size.x / wave_params.EVAL_T_END - wave_viewer_size.x / 2,
		gp.y * wave_viewer_size.y / (wave_params.MAX_MAG * -2), # The max pk - pk is double the max magnitude, so we need to account for this when scaling
	)
