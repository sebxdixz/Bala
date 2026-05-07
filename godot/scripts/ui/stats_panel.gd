# ============================================================
# stats_panel.gd — Player Stats Panel UI
# Barrio Sin Ley Online (BSLO)
# CanvasLayer que muestra los 6 stats, clase, faccion y XP.
# Toggle con tecla P.
# Se conecta a StatsManager para actualizaciones en tiempo real.
# ============================================================
extends CanvasLayer

# Nodos principales
@onready var main_panel: Panel = $MainPanel
@onready var class_label: Label = $MainPanel/MarginContainer/VBoxMain/InfoContainer/ClassLabel
@onready var faction_label: Label = $MainPanel/MarginContainer/VBoxMain/InfoContainer/FactionLabel
@onready var level_label: Label = $MainPanel/MarginContainer/VBoxMain/InfoContainer/LevelLabel
@onready var xp_bar: TextureProgressBar = $MainPanel/MarginContainer/VBoxMain/InfoContainer/XpBar
@onready var xp_text: Label = $MainPanel/MarginContainer/VBoxMain/InfoContainer/XpText

# Referencias a las filas de stats (nombre callejero + valor + bonus de clase)
var stat_rows: Dictionary = {}

# Valores actuales
var current_stats: Dictionary = {}
var current_class: String = ""
var current_faction: String = ""
var current_level: int = 1
var current_xp: int = 0
var current_xp_max: int = 100

func _ready():
	"""Inicializa el panel: conecta signals, posiciona el panel a la derecha."""
	process_mode = PROCESS_MODE_ALWAYS
	
	# Construir diccionario de referencias a las filas de stats
	_cache_stat_rows()
	
	# Posicionar panel a la derecha de la pantalla
	_position_panel_right()
	
	# Conectar a StatsManager
	_connect_stats_manager()
	
	# Cargar valores iniciales
	_load_initial_values()
	
	print("StatsPanel: Inicializado")

func _cache_stat_rows():
	"""Guarda referencias a los nodos de cada fila de stat."""
	var stats_container = $MainPanel/MarginContainer/VBoxMain/StatsContainer
	var stat_ids = ["STR", "DEX", "CON", "INT", "WIS", "CHA"]
	
	for stat_id in stat_ids:
		var row = stats_container.get_node_or_null("StatRow_" + stat_id)
		if row:
			var name_label = row.get_node_or_null("Name" + stat_id)
			var value_label = row.get_node_or_null("Value" + stat_id)
			var bonus_label = row.get_node_or_null("Bonus" + stat_id)
			stat_rows[stat_id] = {
				"name_label": name_label,
				"value_label": value_label,
				"bonus_label": bonus_label
			}

func _position_panel_right():
	"""Posiciona el panel en la parte superior derecha de la pantalla."""
	var viewport_size = get_viewport().get_visible_rect().size
	var panel_width = 260.0
	main_panel.offset_left = viewport_size.x - panel_width - 20.0
	main_panel.offset_right = viewport_size.x - 20.0
	main_panel.offset_top = 80.0
	main_panel.offset_bottom = 600.0

func _unhandled_input(event: InputEvent):
	"""Maneja tecla P para toggle del panel."""
	if event is InputEventKey and event.pressed and event.keycode == KEY_P:
		toggle_panel()
		get_viewport().set_input_as_handled()

# ============================================================
# CONEXION A STATSMANAGER
# ============================================================

func _connect_stats_manager():
	"""Conecta a las seniales del StatsManager autoload."""
	if not StatsManager:
		call_deferred("_connect_stats_manager")
		return
	
	if StatsManager.has_signal("stats_changed"):
		StatsManager.stats_changed.connect(_on_stats_changed)
	if StatsManager.has_signal("health_changed"):
		StatsManager.health_changed.connect(_on_health_changed)
	if StatsManager.has_signal("leveled_up"):
		StatsManager.leveled_up.connect(_on_leveled_up)

func _load_initial_values():
	"""Carga los valores iniciales desde StatsManager."""
	if not StatsManager:
		return
	
	var stats_dict = {
		"STR": StatsManager.get_stat("STR"),
		"DEX": StatsManager.get_stat("DEX"),
		"CON": StatsManager.get_stat("CON"),
		"INT": StatsManager.get_stat("INT"),
		"WIS": StatsManager.get_stat("WIS"),
		"CHA": StatsManager.get_stat("CHA")
	}
	update_stats(stats_dict)
	update_level(StatsManager.level, StatsManager.current_xp, StatsManager.xp_to_next_level)

# ============================================================
# METODOS PUBLICOS
# ============================================================

func toggle_panel():
	"""Alterna la visibilidad del panel de stats."""
	visible = not visible
	if visible:
		_load_initial_values()

func update_stats(stats_dict: Dictionary):
	"""Refresca todos los displays de estadisticas.
	
	Parametros:
		stats_dict: Diccionario { "STR": 10, "DEX": 8, ... }
	"""
	current_stats = stats_dict
	
	for stat_id in stat_rows.keys():
		var row_refs = stat_rows[stat_id]
		var total_value = stats_dict.get(stat_id, 5)
		
		# Obtener valor base y modificador desde StatsManager
		var base_value = 5
		var modifier = 0
		if StatsManager:
			base_value = StatsManager.get("base_" + stat_id.to_lower())
			modifier = StatsManager.get("mod_" + stat_id.to_lower())
		
		# Actualizar label de valor
		if row_refs.value_label:
			row_refs.value_label.text = str(total_value)
		
		# Actualizar bonus de clase
		if row_refs.bonus_label and modifier != 0:
			var sign = "+" if modifier >= 0 else ""
			row_refs.bonus_label.text = sign + str(modifier)
			row_refs.bonus_label.visible = true
		elif row_refs.bonus_label:
			row_refs.bonus_label.text = "+0"
			row_refs.bonus_label.visible = true

func update_class_info(cls_name: String, faction_name: String):
	"""Muestra el nombre de clase y faccion actual.
	
	Parametros:
		class_name: Nombre de la clase (ej. "Maton", "Gatillero")
		faction_name: Nombre de la faccion (ej. "Yakuza", "Mafia")
	"""
	current_class = cls_name
	current_faction = faction_name
	
	if class_label:
		class_label.text = "Clase: " + cls_name
	
	if faction_label:
		faction_label.text = "Facción: " + faction_name

func update_level(level: int, xp_current: int, xp_max: int):
	"""Actualiza la barra de XP y labels de nivel.
	
	Parametros:
		level: Nivel actual del jugador
		xp_current: XP acumulada en el nivel actual
		xp_max: XP necesaria para subir de nivel
	"""
	current_level = level
	current_xp = xp_current
	current_xp_max = xp_max
	
	if level_label:
		level_label.text = "Nivel " + str(level)
	
	if xp_bar:
		xp_bar.max_value = float(max(xp_max, 1))
		xp_bar.value = float(clamp(xp_current, 0, xp_max))
	
	if xp_text:
		xp_text.text = "XP: " + str(xp_current) + " / " + str(xp_max)

# ============================================================
# CALLBACKS DE SIGNALS
# ============================================================

func _on_stats_changed(stat_name: String, new_value: int):
	"""Callback cuando un stat cambia en StatsManager."""
	if not visible:
		return
	
	# Actualizar el stat especifico
	var row_refs = stat_rows.get(stat_name.to_upper())
	if row_refs and row_refs.value_label:
		row_refs.value_label.text = str(new_value)
	
	# Actualizar modificador si es necesario
	if StatsManager:
		var modifier = StatsManager.get("mod_" + stat_name.to_lower())
		if row_refs and row_refs.bonus_label:
			var sign = "+" if modifier >= 0 else ""
			row_refs.bonus_label.text = sign + str(modifier)
	
	# Si cambio el nivel, actualizar XP
	if stat_name.to_lower() == "level":
		if StatsManager:
			update_level(StatsManager.level, StatsManager.current_xp, StatsManager.xp_to_next_level)

func _on_health_changed(_current_hp: int, _max_hp: int):
	"""Callback cuando cambia el HP (podriamos mostrar HP aqui tambien)."""
	pass  # El HP se muestra en el HUD principal

func _on_leveled_up(new_level: int):
	"""Callback cuando el jugador sube de nivel."""
	if StatsManager:
		update_level(new_level, StatsManager.current_xp, StatsManager.xp_to_next_level)