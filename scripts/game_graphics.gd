extends Node

const BUILDING_COLOR := Color("#30343e")
const BUILDING_INPUT_COLOR := Color("#cfb63c")
const BUILDING_OUTPUT_COLOR := Color("#37579c")

const WIRE_COLOR := Color("#6fe287")

const WAVE_VIEWER_LINE_SIZE := 0.5
const WAVE_VIEWER_ORIGIN_LINE_SIZE := 0.5
const GOAL_LINE_COLOR := Color("#65bdce")
const GEN_LINE_COLOR := Color("#a06fe2")
const OSCILLOSCOPE_LINE_COLOR := Color("#6fe287")
const ORIGIN_LINE_COLOR := Color("#dde4e5")

const RESET_MODULATION_COLOR := Color("#ffffff")
const GHOST_MODULATION_COLOR := Color("ffffff99")
const GHOST_ERROR_MODULATION_COLOR := Color("ff404099")

const GAME_BG_COLOR := Color("#2F3E46")

# For the in-game message board
const ERROR_MSG_FONT_COLOR := Color("#e27b6f")
const MSG_FONT_COLOR := Color("#dde4e5")


func _ready() -> void:
	RenderingServer.set_default_clear_color(GAME_BG_COLOR)   
