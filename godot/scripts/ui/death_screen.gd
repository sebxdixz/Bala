# ============================================================
# death_screen.gd — Death Screen Overlay
# Barrio Sin Ley Online (BSLO)
# Muestra pantalla de muerte con "HAS MUERTO", perdidas y tip.
# Auto-oculta tras 3 segundos y emite senal para respawn.
# ============================================================
extends CanvasLayer

# Senales
signal respawn_requested()

# Referencias a nodos
@onready var death_message: Label = $DeathMessage
@onready var loss_info: Label = $LossInfo
@onready var tip_label: Label = $TipLabel
@onready var timer_label: Label = $RespawnTimer
@onready var overlay: TextureRect = $Overlay

# Tips de muerte (sabor del barrio)
const DEATH_TIPS: Array[String] = [
	"El barrio no perdona... pero siempre da otra oportunidad.",
	"La proxima vez, lleva mas vendajes.",
	"Los cholos se rien de tu cadaver. No les des el gusto.",
	"Dicen que El Ferretero vende adrenalina... por si acaso.",
	"En el barrio, hasta la muerte tiene precio.",
	"Firulais te habria protegido. Consiguele un taco.",
	"Los yakuza controlan el norte. Evita sus calles de noche.",
	"El Viejo del Barrio te lo advirtio...",
	"Las balas son mas rapidas que los puños. Compra una pistola.",
	"Nadie sale vivo del barrio... pero puedes intentarlo de nuevo.",
	"Respira hondo. El barrio te espera.",
	"La muerte es solo un negocio mas en estas calles.",
	"Perdiste PB... pero ganaste experiencia. Literalmente no.",
	"El Cartel no olvida. Pero tu tampoco deberias.",
	"Un taco callejero te habria salvado. La proxima compra uno."
]

var _display_timer: float = 0.0
const DISPLAY_DURATION: float = 3.0
var _xp_lost: int = 0
var _pb_lost: int = 0
var _is_active: bool = false

func _ready():
	"""Configura la pantalla de muerte oculta inicialmente."""
	visible = false
	process_mode = PROCESS_MODE_ALWAYS
	
	if loss_info and not is_instance_valid(loss_info):
		# loss_info doesn't exist in scene, create dynamically
		pass

func _process(delta: float):
	"""Cuenta regresiva de 3 segundos para auto-respawn."""
	if not _is_active:
		return
	
	_display_timer -= delta
	
	# Actualizar cuenta regresiva
	if timer_label:
		var remaining = maxi(0, int(ceil(_display_timer)))
		timer_label.text = "Reapareciendo en %ds..." % remaining
	
	if _display_timer <= 0.0:
		_trigger_respawn()

func show_death(xp_lost: int, pb_lost: int):
	"""Muestra la pantalla de muerte con informacion de perdidas.
	
	Parametros:
		xp_lost: Cantidad de XP perdida
		pb_lost: Cantidad de PB perdida
	"""
	_xp_lost = xp_lost
	_pb_lost = pb_lost
	_display_timer = DISPLAY_DURATION
	_is_active = true
	
	# Mensaje principal
	if death_message:
		death_message.text = "HAS MUERTO"
		death_message.add_theme_color_override("font_color", Color(1.0, 0.0, 0.0, 1.0))
		death_message.add_theme_font_size_override("font_size", 56)
		death_message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	# Informacion de perdidas (crear si no existe en escena)
	if loss_info:
		loss_info.text = "Perdiste %d XP y %d PB" % [xp_lost, pb_lost]
	else:
		_create_loss_label()
	
	# Tip aleatorio
	if tip_label:
		var tip = DEATH_TIPS[randi() % DEATH_TIPS.size()]
		tip_label.text = '"%s"' % tip
	else:
		_create_tip_label()
	
	# Cuenta regresiva
	if timer_label:
		timer_label.text = "Reapareciendo en %ds..." % int(DISPLAY_DURATION)
	
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _create_loss_label():
	"""Crea el label de perdidas dinamicamente."""
	loss_info = Label.new()
	loss_info.name = "LossInfo"
	loss_info.text = "Perdiste %d XP y %d PB" % [_xp_lost, _pb_lost]
	loss_info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	loss_info.add_theme_color_override("font_color", Color(1.0, 0.6, 0.0, 1.0))
	loss_info.add_theme_font_size_override("font_size", 22)
	loss_info.set_anchors_preset(Control.PRESET_CENTER_TOP)
	loss_info.position = Vector2(-200, 340)
	loss_info.size = Vector2(400, 50)
	add_child(loss_info)

func _create_tip_label():
	"""Crea el label de tip dinamicamente."""
	tip_label = Label.new()
	tip_label.name = "TipLabel"
	var tip = DEATH_TIPS[randi() % DEATH_TIPS.size()]
	tip_label.text = '"%s"' % tip
	tip_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tip_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7, 0.9))
	tip_label.add_theme_font_size_override("font_size", 16)
	tip_label.set_anchors_preset(Control.PRESET_CENTER_TOP)
	tip_label.position = Vector2(-300, 390)
	tip_label.size = Vector2(600, 60)
	add_child(tip_label)

func _trigger_respawn():
	"""Oculta la pantalla y emite la senal de respawn."""
	_is_active = false
	visible = false
	respawn_requested.emit()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func hide_death():
	"""Oculta la pantalla de muerte manualmente."""
	_is_active = false
	visible = false
