extends Node

const BUILDING_COLOR := Color("#252525")
const BUILDING_INPUT_COLOR := Color("#a8661a")
const BUILDING_OUTPUT_COLOR := Color("#2691b1")

const WIRE_COLOR := Color("#54a83b")

const WAVE_VIEWER_LINE_SIZE := 0.5
const WAVE_VIEWER_ORIGIN_LINE_SIZE := 0.15
const GOAL_LINE_COLOR := Color("#74c2c2")
const GEN_LINE_COLOR := Color("#c274c2")
const OSCILLOSCOPE_LINE_COLOR := Color("#74c274")
const ORIGIN_LINE_COLOR := Color("#ffffff")

const RESET_MODULATION_COLOR := Color("#ffffff")
const GHOST_MODULATION_COLOR := Color("ffffff99")
const GHOST_ERROR_MODULATION_COLOR := Color("ff404099")

const GAME_BG_COLOR := Color("#202020")

# For the in-game message board
const ERROR_MSG_FONT_COLOR := Color("#c27474")
const MSG_FONT_COLOR := Color("#ffffff")


func _ready() -> void:
	RenderingServer.set_default_clear_color(GAME_BG_COLOR)   
