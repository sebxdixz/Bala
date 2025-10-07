extends Node
class_name GameManager

## Manager principal del juego
## Maneja estados globales, configuración y sistemas principales

signal game_started
signal game_paused
signal game_ended

enum GameState {
	MENU,
	PLAYING,
	PAUSED,
	INVENTORY,
	SETTINGS
}

var current_state: GameState = GameState.MENU
var player: Player = null
var game_time: float = 0.0

@onready var ui_manager: Node = $UIManager
@onready var audio_manager: Node = $AudioManager

func _ready():
	print("🎮 Game Manager initialized")
	configure_for_pixel_art()
	connect_signals()

func _process(delta):
	if current_state == GameState.PLAYING:
		game_time += delta
	
	# Inputs globales
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()

func configure_for_pixel_art():
	# Configurar settings para pixel art 3D
	get_viewport().scaling_3d_mode = Viewport.SCALING_3D_MODE_FSR
	print("🎨 Pixel art settings configured")

func connect_signals():
	# Conectar señales importantes del juego
	pass

func start_game():
	current_state = GameState.PLAYING
	game_started.emit()
	print("🚀 Game started!")

func pause_game():
	current_state = GameState.PAUSED
	get_tree().paused = true
	game_paused.emit()
	print("⏸️ Game paused")

func resume_game():
	current_state = GameState.PLAYING
	get_tree().paused = false
	print("▶️ Game resumed")

func toggle_pause():
	if current_state == GameState.PLAYING:
		pause_game()
	elif current_state == GameState.PAUSED:
		resume_game()

func set_player(new_player: Player):
	player = new_player
	player.add_to_group("player")
	print("👤 Player set: %s" % player.name)

func show_notification(message: String, duration: float = 3.0):
	print("📢 Notification: %s" % message)
	# TODO: Mostrar en UI

func get_formatted_game_time() -> String:
	var minutes = int(game_time) / 60
	var seconds = int(game_time) % 60
	return "%02d:%02d" % [minutes, seconds]
