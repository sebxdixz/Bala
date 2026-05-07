extends Node
# GameManager - Global game state manager for BSLO
# Autoload: GameManager

enum GameState { MENU, LOADING, PLAYING, PAUSED, DEATH, CUTSCENE }

var current_state: GameState = GameState.PLAYING
var is_skill_tree_open: bool = false
var is_stats_panel_open: bool = false

signal skill_tree_toggled(visible: bool)
signal stats_panel_toggled(visible: bool)

func _ready():
	print("GameManager: Inicializado. Estado: ", current_state)

func register_player(player):
	pass

func open_skill_tree():
	is_skill_tree_open = true
	skill_tree_toggled.emit(true)

func close_skill_tree():
	is_skill_tree_open = false
	skill_tree_toggled.emit(false)

func open_stats_panel():
	is_stats_panel_open = true
	stats_panel_toggled.emit(true)

func close_stats_panel():
	is_stats_panel_open = false
	stats_panel_toggled.emit(false)

func change_scene(path: String):
	get_tree().change_scene_to_file(path)
