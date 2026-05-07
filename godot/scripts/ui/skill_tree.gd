# ============================================================

# skill_tree.gd — Graffiti Wall Skill Tree UI

# Barrio Sin Ley Online (BSLO)

# CanvasLayer que muestra el arbol de habilidades por clase.

# Abierto con tecla K. 3 ramas (A/B/C), 5 skills cada una.

# Maximo 5 rangos por skill, 1 punto por rango.

# Incluye display de habilidades activas (hotbar) con detalles.

# ============================================================

extends CanvasLayer



# Referencias a nodos de la UI

@onready var title_label: Label = $CenterPanel/MarginContainer/VBoxMain/TitleLabel

@onready var header_a: Label = $CenterPanel/MarginContainer/VBoxMain/ColumnsContainer/ColumnA/HeaderA/HeaderLabelA

@onready var header_b: Label = $CenterPanel/MarginContainer/VBoxMain/ColumnsContainer/ColumnB/HeaderB/HeaderLabelB

@onready var header_c: Label = $CenterPanel/MarginContainer/VBoxMain/ColumnsContainer/ColumnC/HeaderC/HeaderLabelC

@onready var skills_a: VBoxContainer = $CenterPanel/MarginContainer/VBoxMain/ColumnsContainer/ColumnA/SkillsA

@onready var skills_b: VBoxContainer = $CenterPanel/MarginContainer/VBoxMain/ColumnsContainer/ColumnB/SkillsB

@onready var skills_c: VBoxContainer = $CenterPanel/MarginContainer/VBoxMain/ColumnsContainer/ColumnC/SkillsC

@onready var points_label: Label = $CenterPanel/MarginContainer/VBoxMain/BottomBar/PointsLabel

@onready var close_button: Button = $CenterPanel/MarginContainer/VBoxMain/BottomBar/CloseButton

@onready var vbox_main: VBoxContainer = $CenterPanel/MarginContainer/VBoxMain



# Datos de skills

var current_class_id: String = "tanque"

var current_class_name: String = "Tanque"

var available_points: int = 0

var branches: Dictionary = {}

var skill_nodes: Array[Dictionary] = []



# Contenedor de habilidades activas (creado dinamicamente)

var active_skills_container: VBoxContainer = null

var active_skills_data: Array = []  # Array[SkillData] para hotbar



# Skills por rama para la clase Maton (default/demo)

const DEFAULT_SKILLS = {

	"rama_a": {

		"name": "Muro",

		"skills": [

			{"id": "muro_1", "name": "Piel de Elefante", "desc": "+4% HP maximo", "level_req": 10, "max_rank": 5, "current_rank": 0},

			{"id": "muro_2", "name": "Postura Firme", "desc": "+2% resistencia a CC", "level_req": 15, "max_rank": 5, "current_rank": 0},

			{"id": "muro_3", "name": "Segunda Piel", "desc": "+4% HP maximo", "level_req": 20, "max_rank": 5, "current_rank": 0},

			{"id": "muro_4", "name": "Inamovible", "desc": "+2% resistencia a CC", "level_req": 25, "max_rank": 5, "current_rank": 0},

			{"id": "muro_5", "name": "Muro Humano", "desc": "+8% HP maximo, +4% resist CC", "level_req": 30, "max_rank": 5, "current_rank": 0}

		]

	},

	"rama_b": {

		"name": "Carnicero",

		"skills": [

			{"id": "car_1", "name": "Golpes Fuertes", "desc": "+3% danio melee", "level_req": 10, "max_rank": 5, "current_rank": 0},

			{"id": "car_2", "name": "Provocador", "desc": "+4% generacion de amenaza", "level_req": 15, "max_rank": 5, "current_rank": 0},

			{"id": "car_3", "name": "Manos Pesadas", "desc": "+3% danio melee", "level_req": 20, "max_rank": 5, "current_rank": 0},

			{"id": "car_4", "name": "Sed de Sangre", "desc": "+4% generacion de amenaza", "level_req": 25, "max_rank": 5, "current_rank": 0},

			{"id": "car_5", "name": "Carnicero Mayor", "desc": "+6% danio y amenaza", "level_req": 30, "max_rank": 5, "current_rank": 0}

		]

	},

	"rama_c": {

		"name": "Protector",

		"skills": [

			{"id": "pro_1", "name": "Escudo Aliado", "desc": "+2% defensa compartida", "level_req": 10, "max_rank": 5, "current_rank": 0},

			{"id": "pro_2", "name": "Presencia", "desc": "Rango de aura +1m", "level_req": 15, "max_rank": 5, "current_rank": 0},

			{"id": "pro_3", "name": "Guardia Leal", "desc": "+2% defensa compartida", "level_req": 20, "max_rank": 5, "current_rank": 0},

			{"id": "pro_4", "name": "Aura Amplia", "desc": "Rango de aura +1m", "level_req": 25, "max_rank": 5, "current_rank": 0},

			{"id": "pro_5", "name": "Protector Supremo", "desc": "+4% defensa, +2m rango", "level_req": 30, "max_rank": 5, "current_rank": 0}

		]

	}

}



func _ready():

	"""Configura callbacks y contenedores."""

	close_button.pressed.connect(close_skill_tree)

	process_mode = PROCESS_MODE_ALWAYS

	

	# Cargar datos de skills desde ClassManager si existe

	_load_skills_from_class_manager()

	

	# Crear seccion de habilidades activas dinamicamente

	_create_active_skills_section()

	

	# Construir UI inicial

	_build_skill_tree()

	

	print("SkillTree: Inicializado")



func _load_skills_from_class_manager():

	"""Carga skills desde ClassManager; fallback a defaults."""

	var cm = _get_class_manager()

	active_skills_data.clear()

	

	if cm and cm.has_method("get_class_data"):

		var cd = cm.get_class_data(current_class_id)

		if cd and cd.skills and cd.skills.size() > 0:

			branches = _convert_class_skills_to_branches(cd)

			# Guardar habilidades activas (hotbar) para display

			for skill in cd.skills:

				if skill.hotbar_slot >= 1 and skill.hotbar_slot <= 5:

					active_skills_data.append(skill)

			active_skills_data.sort_custom(func(a, b): return a.hotbar_slot < b.hotbar_slot)

			return

	

	branches = DEFAULT_SKILLS



func _get_class_manager():

	"""Retorna el ClassManager autoload si existe."""

	return ClassManager if ClassManager else null



func _create_active_skills_section():

	"""Crea dinamicamente la seccion de habilidades activas (hotbar)."""

	if active_skills_container:

		return

	

	var columns = $CenterPanel/MarginContainer/VBoxMain/ColumnsContainer

	

	active_skills_container = VBoxContainer.new()

	active_skills_container.name = "ActiveSkillsContainer"

	active_skills_container.add_theme_constant_override("separation", 4)

	

	# Header de la seccion

	var header = Label.new()

	header.name = "ActiveSkillsHeader"

	header.text = "HABILIDADES ACTIVAS (Hotbar 1-5)"

	header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	header.add_theme_color_override("font_color", Color(0.0, 0.8, 0.8, 1.0))

	header.add_theme_font_size_override("font_size", 15)

	active_skills_container.add_child(header)

	

	# Separador

	var sep = HSeparator.new()

	active_skills_container.add_child(sep)

	

	# HBox para los slots de habilidades activas

	var active_hbox = HBoxContainer.new()

	active_hbox.name = "ActiveSkillsHBox"

	active_hbox.alignment = BoxContainer.ALIGNMENT_CENTER

	active_hbox.add_theme_constant_override("separation", 8)

	active_skills_container.add_child(active_hbox)

	

	# Insertar antes de las columnas de ramas pasivas

	vbox_main.add_child(active_skills_container)

	vbox_main.move_child(active_skills_container, vbox_main.get_children().find(columns))



func _unhandled_input(event: InputEvent):

	"""Maneja tecla K para abrir/cerrar y ESC para cerrar."""

	if event.is_action_pressed("ui_cancel") and visible:

		close_skill_tree()

		get_viewport().set_input_as_handled()

		return

	

	if event is InputEventKey and event.pressed:

		if event.keycode == KEY_K and not visible:

			open_skill_tree(current_class_id)

			get_viewport().set_input_as_handled()

		elif event.keycode == KEY_K and visible:

			close_skill_tree()

			get_viewport().set_input_as_handled()



# ============================================================

# METODOS PUBLICOS

# ============================================================



func open_skill_tree(class_id: String = ""):

	"""Abre el arbol de habilidades para la clase actual del jugador.

	

	Parametros:

		class_id: ID de la clase a mostrar. Si vacio, usa la actual.

	"""

	if class_id != "":

		current_class_id = class_id

	

	_load_skills_from_class_manager()

	_update_available_points()

	_refresh_skill_tree()

	visible = true

	

	print("SkillTree: Abierto para clase ", current_class_id)



func close_skill_tree():

	"""Cierra el arbol de habilidades."""

	visible = false

	print("SkillTree: Cerrado")



func _build_skill_tree():

	"""Construye el arbol de habilidades completo (activas + pasivas)."""

	_build_active_skills_display()

	_build_branch(skills_a, branches.get("rama_a", {}))

	_build_branch(skills_b, branches.get("rama_b", {}))

	_build_branch(skills_c, branches.get("rama_c", {}))

	

	# Actualizar headers

	if branches.has("rama_a"):

		header_a.text = branches.rama_a.get("name", "Rama A")

	if branches.has("rama_b"):

		header_b.text = branches.rama_b.get("name", "Rama B")

	if branches.has("rama_c"):

		header_c.text = branches.rama_c.get("name", "Rama C")



func _refresh_skill_tree():

	"""Refresca la UI del arbol (colores, textos) sin reconstruir."""

	_update_available_points()

	_refresh_active_skills_display()

	_refresh_branch(skills_a, branches.get("rama_a", {}))

	_refresh_branch(skills_b, branches.get("rama_b", {}))

	_refresh_branch(skills_c, branches.get("rama_c", {}))

	

	if branches.has("rama_a"):

		header_a.text = branches.rama_a.get("name", "Rama A")

	if branches.has("rama_b"):

		header_b.text = branches.rama_b.get("name", "Rama B")

	if branches.has("rama_c"):

		header_c.text = branches.rama_c.get("name", "Rama C")



# ============================================================

# DISPLAY DE HABILIDADES ACTIVAS (HOTBAR)

# ============================================================



func _build_active_skills_display():

	"""Construye los slots de habilidades activas en la UI."""

	if not active_skills_container:

		_create_active_skills_section()

	if not active_skills_container:

		return

	

	var active_hbox = active_skills_container.get_node_or_null("ActiveSkillsHBox")

	if not active_hbox:

		return

	

	# Limpiar hijos anteriores

	for child in active_hbox.get_children():

		active_hbox.remove_child(child)

		child.queue_free()

	

	# Crear un slot por cada habilidad activa

	for i in range(active_skills_data.size()):

		var skill = active_skills_data[i]

		var slot = _create_active_skill_slot(skill, i)

		active_hbox.add_child(slot)



func _refresh_active_skills_display():

	"""Refresca el display de habilidades activas."""

	if not active_skills_container:

		return

	

	var active_hbox = active_skills_container.get_node_or_null("ActiveSkillsHBox")

	if not active_hbox:

		return

	

	# Reconstruir si el numero de skills cambio

	if active_hbox.get_child_count() != active_skills_data.size():

		_build_active_skills_display()

		return



func _create_active_skill_slot(skill: Resource, index: int) -> Control:

	"""Crea un slot detallado para una habilidad activa (hotbar).

	

	Muestra: nombre, descripcion, multiplicador, cooldown, stamina, rango,

	numero de slot en la hotbar destacado.

	

	Parametros:

		skill: SkillData resource con los datos completos

		index: Indice en el array de habilidades activas

	Returns:

		Control: Contenedor con toda la info de la habilidad

	"""

	var slot_container = VBoxContainer.new()

	slot_container.name = "ActiveSkill_" + skill.skill_id

	slot_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	slot_container.custom_minimum_size = Vector2(150, 0)

	slot_container.add_theme_constant_override("separation", 3)

	

	# Crear StyleBox segun estado

	var sb = StyleBoxFlat.new()

	sb.bg_color = Color(0.1, 0.08, 0.18, 0.9)

	sb.border_width_left = 1

	sb.border_width_top = 1

	sb.border_width_right = 1

	sb.border_width_bottom = 1

	sb.border_color = Color(0.0, 0.8, 0.8, 0.6)

	sb.corner_radius_top_left = 6

	sb.corner_radius_top_right = 6

	sb.corner_radius_bottom_right = 6

	sb.corner_radius_bottom_left = 6

	

	var panel = Panel.new()

	panel.name = "SkillPanel"

	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL

	panel.add_theme_stylebox_override("panel", sb)

	slot_container.add_child(panel)

	

	var vbox = VBoxContainer.new()

	vbox.name = "SkillInfo"

	vbox.add_theme_constant_override("separation", 2)

	vbox.offset_left = 6

	vbox.offset_top = 6

	vbox.offset_right = -6

	vbox.offset_bottom = -6

	panel.add_child(vbox)

	

	# Numero de slot en la hotbar (destacado)

	var slot_label = Label.new()

	slot_label.name = "SlotNumber"

	slot_label.text = "[%d]" % skill.hotbar_slot

	slot_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	slot_label.add_theme_color_override("font_color", Color(1.0, 0.0, 0.667, 1.0))

	slot_label.add_theme_font_size_override("font_size", 20)

	vbox.add_child(slot_label)

	

	# Nombre de la habilidad

	var name_label = Label.new()

	name_label.name = "SkillName"

	name_label.text = skill.skill_name

	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	name_label.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))

	name_label.add_theme_font_size_override("font_size", 13)

	vbox.add_child(name_label)

	

	# Descripcion

	var desc_label = Label.new()

	desc_label.name = "Description"

	desc_label.text = skill.description

	desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	desc_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	desc_label.add_theme_color_override("font_color", Color(0.65, 0.65, 0.7, 1.0))

	desc_label.add_theme_font_size_override("font_size", 9)

	desc_label.custom_minimum_size = Vector2(0, 30)

	vbox.add_child(desc_label)

	

	# Stats en row

	var stats_hbox = HBoxContainer.new()

	stats_hbox.name = "StatsRow"

	stats_hbox.alignment = BoxContainer.ALIGNMENT_CENTER

	stats_hbox.add_theme_constant_override("separation", 6)

	vbox.add_child(stats_hbox)

	

	# Multiplicador de danio

	if skill.damage_multiplier > 0.0:

		var dmg_label = Label.new()

		dmg_label.text = "x%.1f danio" % skill.damage_multiplier

		dmg_label.add_theme_color_override("font_color", Color(1.0, 0.4, 0.2, 1.0))

		dmg_label.add_theme_font_size_override("font_size", 9)

		stats_hbox.add_child(dmg_label)

	

	# Cooldown

	var cd_label = Label.new()

	cd_label.text = "CD: %.1fs" % skill.cooldown

	cd_label.add_theme_color_override("font_color", Color(0.5, 0.5, 0.6, 1.0))

	cd_label.add_theme_font_size_override("font_size", 9)

	stats_hbox.add_child(cd_label)

	

	# Stamina

	var stam_label = Label.new()

	stam_label.text = "Stam: %d" % skill.stamina_cost

	stam_label.add_theme_color_override("font_color", Color(0.9, 0.75, 0.05, 1.0))

	stam_label.add_theme_font_size_override("font_size", 9)

	stats_hbox.add_child(stam_label)

	

	# Rango de area

	if skill.area_radius > 0.0:

		var area_label = Label.new()

		area_label.text = "%.1fm" % skill.area_radius

		area_label.add_theme_color_override("font_color", Color(0.0, 0.7, 0.7, 1.0))

		area_label.add_theme_font_size_override("font_size", 9)

		stats_hbox.add_child(area_label)

	

	# Duracion

	if skill.duration > 0.0:

		var dur_label = Label.new()

		dur_label.text = "%.1fs" % skill.duration

		dur_label.add_theme_color_override("font_color", Color(0.5, 0.8, 0.5, 1.0))

		dur_label.add_theme_font_size_override("font_size", 9)

		stats_hbox.add_child(dur_label)

	

	# Rango actual / maximo

	var rank_label = Label.new()

	rank_label.name = "RankInfo"

	rank_label.text = "Rango 0/%d" % skill.max_rank

	rank_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	rank_label.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6, 1.0))

	rank_label.add_theme_font_size_override("font_size", 9)

	vbox.add_child(rank_label)

	

	return slot_container



# ============================================================

# CONSTRUCCION DE RAMAS PASIVAS

# ============================================================



func _build_branch(container: VBoxContainer, branch_data: Dictionary):

	"""Construye la columna UI para una rama pasiva.

	

	Parametros:

		container: VBoxContainer donde colocar los skill slots

		branch_data: Diccionario con los datos de la rama (skills array)

	"""

	# Limpiar hijos anteriores

	for child in container.get_children():

		container.remove_child(child)

		child.queue_free()

	

	var skills = branch_data.get("skills", [])

	for i in range(skills.size()):

		var skill = skills[i]

		var skill_slot = _create_skill_slot(skill, i)

		container.add_child(skill_slot)



func _create_skill_slot(skill: Dictionary, index: int) -> Control:

	"""Crea un slot de habilidad pasiva como nodo UI (Button con labels internos).

	

	Parametros:

		skill: Diccionario con los datos de la habilidad

		index: Indice del slot en su rama

	

	Returns:

		Control: Nodo contenedor con el boton y labels

	"""

	# Contenedor del slot

	var slot_container = VBoxContainer.new()

	slot_container.name = "SkillSlot_" + skill.get("id", str(index))

	slot_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	slot_container.custom_minimum_size = Vector2(0, 82)

	slot_container.add_theme_constant_override("separation", 2)

	

	# Boton principal

	var btn = Button.new()

	btn.name = "SkillButton"

	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	btn.size_flags_vertical = Control.SIZE_EXPAND_FILL

	btn.text = skill.get("name", "Skill")

	btn.add_theme_font_size_override("font_size", 14)

	btn.expand_icon = true

	btn.set_meta("skill_id", skill.get("id", ""))

	btn.set_meta("skill_index", index)

	btn.set_meta("branch", skill.get("branch", ""))

	btn.pressed.connect(_on_skill_clicked.bind(skill.get("id", "")))

	slot_container.add_child(btn)

	

	# Label de descripcion

	var desc_label = Label.new()

	desc_label.name = "Description"

	desc_label.text = skill.get("desc", "")

	desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	desc_label.add_theme_font_size_override("font_size", 10)

	desc_label.add_theme_color_override("font_color", Color(0.6, 0.6, 0.7, 1))

	desc_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	slot_container.add_child(desc_label)

	

	# HBox para requisito y rango

	var info_hbox = HBoxContainer.new()

	info_hbox.name = "InfoBox"

	info_hbox.alignment = BoxContainer.ALIGNMENT_CENTER

	info_hbox.add_theme_constant_override("separation", 8)

	

	var req_label = Label.new()

	req_label.name = "LevelReq"

	req_label.text = "Nv " + str(skill.get("level_req", 1))

	req_label.add_theme_font_size_override("font_size", 10)

	req_label.add_theme_color_override("font_color", Color(0.5, 0.5, 0.6, 1))

	info_hbox.add_child(req_label)

	

	var rank_label = Label.new()

	rank_label.name = "RankLabel"

	rank_label.text = str(skill.get("current_rank", 0)) + "/" + str(skill.get("max_rank", 5))

	rank_label.add_theme_font_size_override("font_size", 10)

	rank_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7, 1))

	info_hbox.add_child(rank_label)

	

	slot_container.add_child(info_hbox)

	

	# Aplicar color segun estado

	_apply_skill_style(btn, skill)

	

	return slot_container



func _apply_skill_style(btn: Button, skill: Dictionary):

	"""Aplica el estilo visual correcto al boton de skill.

	

	Colores:

		- Bloqueado (nivel insuficiente o sin puntos): gris/dimmed

		- Disponible (puede desbloquear/mejorar): blanco/cyan

		- Desbloqueado (rango > 0, < max): magenta

		- Maximo rango: dorado

	"""

	var current_rank = skill.get("current_rank", 0)

	var max_rank = skill.get("max_rank", 5)

	var level_req = skill.get("level_req", 1)

	var player_level = _get_player_level()

	

	# Maximo rango

	if current_rank >= max_rank:

		btn.add_theme_color_override("font_color", Color(1.0, 0.85, 0.0, 1))

		btn.add_theme_stylebox_override("normal", _get_stylebox("max"))

		btn.add_theme_stylebox_override("hover", _get_stylebox("max"))

		return

	

	# Bloqueado (nivel insuficiente)

	if player_level < level_req:

		btn.add_theme_color_override("font_color", Color(0.35, 0.35, 0.35, 1))

		btn.add_theme_stylebox_override("normal", _get_stylebox("locked"))

		btn.add_theme_stylebox_override("hover", _get_stylebox("locked"))

		return

	

	# Sin puntos disponibles (para desbloquear rank 0 -> 1)

	if current_rank == 0 and available_points <= 0:

		btn.add_theme_color_override("font_color", Color(0.35, 0.35, 0.35, 1))

		btn.add_theme_stylebox_override("normal", _get_stylebox("locked"))

		btn.add_theme_stylebox_override("hover", _get_stylebox("locked"))

		return

	

	# Ya desbloqueado pero sin puntos para subir

	if current_rank > 0 and available_points <= 0:

		btn.add_theme_color_override("font_color", Color(1.0, 0.0, 0.667, 1))

		btn.add_theme_stylebox_override("normal", _get_stylebox("unlocked"))

		btn.add_theme_stylebox_override("hover", _get_stylebox("unlocked"))

		return

	

	# Disponible para desbloquear o mejorar

	btn.add_theme_color_override("font_color", Color(0.95, 0.95, 1.0, 1))

	btn.add_theme_stylebox_override("normal", _get_stylebox("available"))

	btn.add_theme_stylebox_override("hover", _get_stylebox("available"))



func _get_stylebox(state: String) -> StyleBoxFlat:

	"""Crea un StyleBoxFlat segun el estado de la skill."""

	var sb = StyleBoxFlat.new()

	match state:

		"locked":

			sb.bg_color = Color(0.15, 0.15, 0.15, 0.9)

			sb.border_width_left = 1

			sb.border_width_top = 1

			sb.border_width_right = 1

			sb.border_width_bottom = 1

			sb.border_color = Color(0.3, 0.3, 0.3, 1)

		"available":

			sb.bg_color = Color(0.18, 0.18, 0.24, 0.9)

			sb.border_width_left = 1

			sb.border_width_top = 1

			sb.border_width_right = 1

			sb.border_width_bottom = 1

			sb.border_color = Color(0.0, 0.8, 0.8, 0.8)

		"unlocked":

			sb.bg_color = Color(0.2, 0.05, 0.15, 0.9)

			sb.border_width_left = 2

			sb.border_width_top = 2

			sb.border_width_right = 2

			sb.border_width_bottom = 2

			sb.border_color = Color(1.0, 0.0, 0.667, 0.9)

		"max":

			sb.bg_color = Color(0.15, 0.12, 0.02, 0.9)

			sb.border_width_left = 2

			sb.border_width_top = 2

			sb.border_width_right = 2

			sb.border_width_bottom = 2

			sb.border_color = Color(1.0, 0.8, 0.0, 0.9)

	sb.corner_radius_top_left = 6

	sb.corner_radius_top_right = 6

	sb.corner_radius_bottom_right = 6

	sb.corner_radius_bottom_left = 6

	return sb



func _get_player_level() -> int:

	"""Obtiene el nivel actual del jugador desde StatsManager."""

	if StatsManager:

		return StatsManager.level

	return 1



func _update_available_points():

	"""Calcula puntos disponibles basado en el nivel del jugador.

	

	Los puntos se obtienen: 1 por nivel a partir del nivel 10.

	total_gained = max(0, level - 9)

	Los puntos gastados se restan.

	"""

	var player_level = _get_player_level()

	# Sync with StatsManager (real skill points)
	if StatsManager:
		available_points = StatsManager.skill_points
	else:
		var points_spent = _count_spent_points()
		var total_gained = maxi(0, player_level - 9)
		available_points = maxi(0, total_gained - points_spent)

	points_label.text = "Puntos disponibles: " + str(available_points)



func _count_spent_points() -> int:

	"""Cuenta cuantos puntos se han gastado en todas las ramas."""

	var total = 0

	for branch_key in branches.keys():

		var branch = branches[branch_key]

		var skills = branch.get("skills", [])

		for skill in skills:

			total += skill.get("current_rank", 0)

	return total



func _refresh_branch(container: VBoxContainer, branch_data: Dictionary):

	"""Refresca los colores y textos de los slots de una rama."""

	var skills = branch_data.get("skills", [])

	var children = container.get_children()

	

	for i in range(min(skills.size(), children.size())):

		var skill = skills[i]

		var slot_container = children[i]

		

		# Actualizar textos

		_update_skill_texts(slot_container, skill)

		

		# Actualizar estilo del boton

		var btn = slot_container.get_node_or_null("SkillButton")

		if btn and btn is Button:

			_apply_skill_style(btn, skill)



func _update_skill_texts(slot_container: Control, skill: Dictionary):

	"""Actualiza los textos de un slot de habilidad pasiva."""

	var desc_label = slot_container.get_node_or_null("Description")

	if desc_label:

		desc_label.text = skill.get("desc", "")

	

	var info_box = slot_container.get_node_or_null("InfoBox")

	if info_box:

		var req_label = info_box.get_node_or_null("LevelReq")

		if req_label:

			req_label.text = "Nv " + str(skill.get("level_req", 1))

		

		var rank_label = info_box.get_node_or_null("RankLabel")

		if rank_label:

			var cr = skill.get("current_rank", 0)

			var mr = skill.get("max_rank", 5)

			rank_label.text = str(cr) + "/" + str(mr)

			if cr >= mr:

				rank_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.0, 1))

			elif cr > 0:

				rank_label.add_theme_color_override("font_color", Color(1.0, 0.0, 0.667, 1))

			else:

				rank_label.add_theme_color_override("font_color", Color(0.5, 0.5, 0.6, 1))



# ============================================================

# MANEJO DE CLICKS

# ============================================================



func _on_skill_clicked(skill_id: String):

	"""Maneja el click en un slot de habilidad: intenta desbloquear o mejorar.

	

	Parametros:

		skill_id: ID de la habilidad clickeada

	"""

	var skill = _find_skill_by_id(skill_id)

	if not skill:

		print("SkillTree: Skill no encontrada: ", skill_id)

		return

	

	var current_rank = skill.get("current_rank", 0)

	var max_rank = skill.get("max_rank", 5)

	var level_req = skill.get("level_req", 1)

	var player_level = _get_player_level()

	

	# Verificar rango maximo

	if current_rank >= max_rank:

		print("SkillTree: ", skill.get("name"), " ya esta al maximo rango")

		return

	

	# Verificar nivel minimo

	if player_level < level_req:

		print("SkillTree: Nivel insuficiente. Requiere ", level_req, ", tienes ", player_level)

		return

	

	# Verificar puntos disponibles

	if available_points <= 0:

		print("SkillTree: Sin puntos disponibles")

		return

	

	# Desbloquear o mejorar

	skill["current_rank"] = current_rank + 1

	available_points -= 1
	# Sync back to StatsManager
	if StatsManager:
		StatsManager.skill_points = maxi(0, StatsManager.skill_points - 1)

	

	# Notificar a ClassManager si existe

	var cm = _get_class_manager()

	if cm and cm.has_method("unlock_skill"):

		cm.unlock_skill(current_class_id, skill_id, skill["current_rank"])

	

	print("SkillTree: ", skill.get("name"), " desbloqueado/mejorado a rango ", skill["current_rank"])

	

	# Refrescar UI

	_refresh_skill_tree()



# ============================================================

# CONVERTIR SKILLS DE CLASSDATA A BRANCHES

# ============================================================



func _convert_class_skills_to_branches(cd: Resource) -> Dictionary:

	"""Convierte los skills de ClassData al formato de branches del arbol.



	Las habilidades activas (hotbar_slot >= 1) se excluyen de las ramas

	y se muestran en la seccion de habilidades activas.



	Parametros:

		cd: ClassData resource

	Returns:

		Dictionary: Diccionario con ramas A/B/C pobladas

	"""

	var result: Dictionary = {}

	var branch_a_skills: Array = []

	var branch_b_skills: Array = []

	var branch_c_skills: Array = []

	var branch_a_name: String = "Rama A"

	var branch_b_name: String = "Rama B"

	var branch_c_name: String = "Rama C"



	for skill in cd.skills:

		if skill.hotbar_slot >= 1:

			continue  # Skip active/hotbar skills (se muestran arriba)

		var skill_dict = {

			"id": skill.skill_id,

			"name": skill.skill_name,

			"desc": skill.description,

			"level_req": skill.unlock_level,

			"max_rank": skill.max_rank,

			"current_rank": 0,

			"branch": skill.tree_branch

		}

		match skill.tree_branch:

			"A":

				branch_a_skills.append(skill_dict)

				if skill.skill_name != "":

					branch_a_name = skill.skill_name

			"B":

				branch_b_skills.append(skill_dict)

				if skill.skill_name != "":

					branch_b_name = skill.skill_name

			"C":

				branch_c_skills.append(skill_dict)

				if skill.skill_name != "":

					branch_c_name = skill.skill_name

			_:

				# Pasivas sin rama: distribuir equitativamente

				var idx = branch_a_skills.size() + branch_b_skills.size() + branch_c_skills.size()

				if idx % 3 == 0:

					branch_a_skills.append(skill_dict)

				elif idx % 3 == 1:

					branch_b_skills.append(skill_dict)

				else:

					branch_c_skills.append(skill_dict)



	result["rama_a"] = {"name": branch_a_name, "skills": branch_a_skills}

	result["rama_b"] = {"name": branch_b_name, "skills": branch_b_skills}

	result["rama_c"] = {"name": branch_c_name, "skills": branch_c_skills}

	return result



func _find_skill_by_id(skill_id: String) -> Dictionary:

	"""Busca una habilidad por su ID en todas las ramas.

	

	Parametros:

		skill_id: ID de la habilidad a buscar

	

	Returns:

		Dictionary: Skill encontrada o diccionario vacio

	"""

	for branch_key in branches.keys():

		var branch = branches[branch_key]

		var skills = branch.get("skills", [])

		for skill in skills:

			if skill.get("id", "") == skill_id:

				return skill

	return {}
