extends Node

const BUILDING_COLOR := Color("#252525")
const BUILDING_INPUT_COLOR := Color("#a8661a")
const BUILDING_OUTPUT_COLOR := Color("#2691b1")

const WIRE_COLOR := Color("#54a83b")

const WAVE_VIEWER_COLORS := [Color("#c27474"), Color("#74c2c2"), Color("#74c274"), Color("#c274c2")]

const GHOST_MODULATION_COLOR := Color("ffffff99")
const GHOST_ERROR_MODULATION_COLOR := Color("ff404099")

func get_random_wave_viewer_color() -> Color:
	return WAVE_VIEWER_COLORS[randi() % WAVE_VIEWER_COLORS.size()]
