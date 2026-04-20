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
	draw_waveform(PrimitiveWave.new(0.0, PrimitiveWave.WaveType.DC), game_graphics.WAVE_VIEWER_ORIGIN_LINE_SIZE, game_graphics.ORIGIN_LINE_COLOR)
	draw_waveform(input_wave, line_width, line_color, 0.9)

func draw_waveform(waveform: Waveform, width: float, color: Color, shrink_factor := 1.0):
	var points := []
	var time := 0.0

	while time < wave_params.EVAL_T_END:
		var new_point := Vector2(time, waveform.evaluate(time))
		points.append(graph_point_to_pixel_point(new_point, shrink_factor))
		time += wave_params.EVAL_TIME_STEP

	# Draw all points in a polyline
	draw_polyline(points, color, width, false)

# Converts a point on the graph to a point in the wave viewer
# The wave is drawn such that it is centered in the node
func graph_point_to_pixel_point(gp: Vector2, shrink_factor := 1.0) -> Vector2:

	# Clip if the graph point goes outside the range
	gp.x = clamp(gp.x, 0.0, wave_params.EVAL_T_END)
	gp.y = clamp(gp.y, -wave_params.MAX_MAG, wave_params.MAX_MAG)

	# Scale pixel point so max mag and time fit within the window
	return Vector2(
		(gp.x * wave_viewer_size.x / wave_params.EVAL_T_END - wave_viewer_size.x / 2) * shrink_factor,
		(gp.y * wave_viewer_size.y / (wave_params.MAX_MAG * -2)) * shrink_factor, 
	)
