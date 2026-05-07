
# ============================================================
# hud.gd — HUD overlay script
# Barrio Sin Ley Online (BSLO)
# CanvasLayer que muestra HP, Stamina, dinero, nivel, hotbar, etc.
# Se conecta al jugador via senales y recibe updates cada frame.
# Incluye soporte para PB (dinero), clase, faccion, hotkey hints,
# combat log y display de cooldowns en la hotbar.
# ============================================================
extends CanvasLayer

@onready var player_name_label = get_node_or_null("MainContainer/PlayerInfo/VBoxInfo/PlayerName")
@onready var class_name_label = get_node_or_null("MainContainer/PlayerInfo/VBoxInfo/ClassNameLabel")
@onready var faction_name_label = get_node_or_null("MainContainer/PlayerInfo/VBoxInfo/FactionRow/FactionNameLabel")
@onready var level_label = get_node_or_null("MainContainer/PlayerInfo/VBoxInfo/LevelLabel")
@onready var health_bar = get_node_or_null("MainContainer/PlayerInfo/VBoxInfo/HealthBar")
@onready var stamina_bar = get_node_or_null("MainContainer/PlayerInfo/VBoxInfo/StaminaBar")
@onready var money_label = get_node_or_null("MainContainer/MoneyDisplay/MoneyLabel")
@onready var wanted_label = get_node_or_null("MainContainer/WantedContainer/WantedLabel")
@onready var hotbar_container: HBoxContainer = $MainContainer/HotbarContainer/Hotbar
@onready var minimap_placeholder = get_node_or_null("MainContainer/Minimap")
@onready var combat_log_label = get_node_or_null("MainContainer/CombatLog")
@onready var xp_bar: TextureProgressBar = get_node_or_null("MainContainer/PlayerInfo/VBoxInfo/XpBar")
@onready var xp_label: Label = get_node_or_null("MainContainer/PlayerInfo/VBoxInfo/XpLabel")
@onready var debug_panel: Panel = $DebugPanel
@onready var debug_label: Label = $DebugPanel/DebugLabel

var player_node: Node = null
var is_debug_visible: bool = false
var combat_log_timer: float = 0.0
const COMBAT_LOG_DURATION: float = 3.0
var nearest_enemy_label: Label = null
var interaction_focus_label: Label = null
const INTERACTION_FOCUS_DISTANCE: float = 20.0

func _ready():
	add_to_group("hud")
	if not wanted_label:
		wanted_label = get_node_or_null("MainContainer/WantedStars/WantedLabel")
	if not combat_log_label:
		_create_combat_log()
	_connect_player()
	_connect_stats_manager()
	_create_minimap_dot()
	_create_crosshair()
	_create_interaction_focus_label()
	_create_xp_bar()
	_create_stat_labels()
	_create_nearest_enemy_label()
	print("HUD: Inicializado")

func _process(delta: float):
	if combat_log_timer > 0.0:
		combat_log_timer -= delta
		if combat_log_label:
			var alpha = clampf(combat_log_timer / COMBAT_LOG_DURATION, 0.0, 1.0)
			combat_log_label.modulate.a = alpha
		if combat_log_timer <= 0.0 and combat_log_label:
			combat_log_label.text = ""
	# Update minimap player dot
	_update_minimap_dot()
	_update_nearest_enemy_label()
	_update_interaction_focus_label()

var _connect_attempts: int = 0

func _connect_player():
	_connect_attempts += 1
	var players = get_tree().get_nodes_in_group("players")
	if players.size() > 0:
		player_node = players[0]
		if player_node.has_signal("health_changed"):
			player_node.health_changed.connect(update_hp)
		if player_node.has_signal("stamina_changed"):
			player_node.stamina_changed.connect(update_stamina)
		if player_node.has_signal("player_died"):
			player_node.player_died.connect(_on_player_died)
		print("HUD: Conectado al jugador: ", player_node.name)
	elif _connect_attempts < 10:
		await get_tree().process_frame
		_connect_player()
	else:
		print("HUD: No se encontro jugador tras 10 intentos")

func _connect_stats_manager():
	"""Conecta al StatsManager para recibir cambios de PB."""
	if StatsManager:
		if StatsManager.has_signal("pb_changed"):
			StatsManager.pb_changed.connect(_on_pb_changed)
		# Sincronizar PB inicial
		call_deferred("_on_pb_changed", StatsManager.carried_pb)

func _on_player_died():
	if debug_label:
		debug_label.text = "YOU DIED"

func _on_pb_changed(new_amount: int):
	"""Actualiza el display de PB en el HUD."""
	update_pb(new_amount)

# ============================================================
# METODOS PUBLICOS DE ACTUALIZACION
# ============================================================

func update_hp(current: int, max_val: int):
	if health_bar:
		health_bar.max_value = float(max_val)
		health_bar.value = float(current)
		if hp_label:
			hp_label.text = "[ HP ]  %d / %d" % [current, max_val]
		var ratio = float(current) / float(max(max_val, 1))
		if ratio > 0.6:
			health_bar.tint_progress = Color(0.8, 0.1, 0.1, 1)
		elif ratio > 0.3:
			health_bar.tint_progress = Color(1.0, 0.6, 0.0, 1)
		else:
			health_bar.tint_progress = Color(0.9, 0.05, 0.05, 1)

func update_stamina(current: int, max_val: int):
	if stamina_bar:
		stamina_bar.max_value = float(max_val)
		stamina_bar.value = float(current)
		if stamina_label:
			stamina_label.text = "[ ST ]  %d / %d" % [current, max_val]

func update_money(amount: int):
	update_pb(amount)

func update_pb(amount: int):
	"""Actualiza la etiqueta de dinero (PB) en el HUD."""
	if money_label:
		money_label.text = "PB: " + str(amount)

func update_level(level: int):
	if level_label:
		level_label.text = "Nivel " + str(level)

func update_xp(current_xp: int, xp_to_next: int):
	if xp_bar:
		xp_bar.max_value = float(max(xp_to_next, 1))
		xp_bar.value = float(min(current_xp, xp_to_next))
	if xp_label:
		xp_label.text = "XP: %d / %d" % [current_xp, xp_to_next]

func update_wanted(stars: int):
	stars = clampi(stars, 0, 5)
	if wanted_label:
		var star_text = ""
		for i in range(5):
			if i < stars:
				star_text += "* "
			else:
				star_text += "- "
		wanted_label.text = star_text.strip_edges()
# Update wanted stars texture visibility

func set_class_name(name: String):
	if class_name_label:
		class_name_label.text = "Clase: " + name

func set_faction_name(name: String):
	if faction_name_label:
		faction_name_label.text = "Faccion: " + name

func update_debug(hp: int, max_hp: int, stamina: int, max_stamina: int, state: String, pos: Vector3):
	if not is_debug_visible:
		return
	if debug_label:
		debug_label.text = "HP: %d/%d\nStamina: %d/%d\nState: %s\nPos: (%.1f, %.1f, %.1f)" % [hp, max_hp, stamina, max_stamina, state, pos.x, pos.y, pos.z]

func set_hotbar_item(slot: int, item_name: String, quantity: int = 0):
	if slot < 0 or slot >= 10:
		return
	if not hotbar_container:
		return
	var children = hotbar_container.get_children()
	if slot < children.size():
		var slot_node = children[slot]
		slot_node.set_meta("skill_name", item_name)
		if quantity > 0:
			slot_node.text = item_name + " x" + str(quantity)
		else:
			slot_node.text = item_name

func set_hotbar_cooldown(slot: int, remaining: float, total: float):
	if slot < 0 or slot >= 10:
		return
	if not hotbar_container:
		return
	var children = hotbar_container.get_children()
	if slot < children.size():
		var slot_node = children[slot]
		if remaining > 0.0:
			slot_node.modulate = Color(0.25, 0.25, 0.25, 0.55)
			if remaining >= 1.0:
				slot_node.text = "%.1fs" % remaining
			else:
				slot_node.text = "%.1f" % remaining
		else:
			slot_node.modulate = Color(1.0, 1.0, 1.0, 1.0)
			var skill_name = slot_node.get_meta("skill_name", "")
			if skill_name != "":
				slot_node.text = skill_name

func clear_hotbar_slot(slot: int):
	if slot < 0 or slot >= 10:
		return
	if not hotbar_container:
		return
	var children = hotbar_container.get_children()
	if slot < children.size():
		var slot_node = children[slot]
		slot_node.text = "[" + str(slot + 1) + "]"
		slot_node.set_meta("skill_name", "")
		slot_node.modulate = Color(1.0, 1.0, 1.0, 1.0)

func update_skill_points(points: int):
	if level_label:
		var lvl = 1
		if StatsManager:
			lvl = StatsManager.level
		level_label.text = "Nivel %d | SP: %d" % [lvl, points]

func toggle_debug():
	is_debug_visible = not is_debug_visible
	if debug_panel:
		debug_panel.visible = is_debug_visible

func set_available_skills(count: int):
	if hotbar_container:
		var children = hotbar_container.get_children()
		for i in range(children.size()):
			var slot_node = children[i]
			if i < count:
				slot_node.modulate = Color(1, 1, 1, 1)
			else:
				slot_node.modulate = Color(0.3, 0.3, 0.3, 0.5)


# CLI Ink terminal theme
const CLI_GREEN = Color(0.0, 1.0, 0.2, 1.0)
const CLI_CYAN = Color(0.0, 0.9, 1.0, 1.0)
const CLI_AMBER = Color(1.0, 0.7, 0.1, 1.0)
const CLI_RED = Color(1.0, 0.2, 0.2, 1.0)
const CLI_MAGENTA = Color(1.0, 0.0, 0.667, 1.0)
const CLI_DIM = Color(0.3, 0.35, 0.3, 0.8)
const CLI_BG = Color(0.05, 0.08, 0.05, 0.92)
var crosshair: Control = null
var _cli_font: FontFile = null
var minimap_player_dot: ColorRect = null


func _create_minimap_dot():
	var minimap = get_node_or_null("MainContainer/Minimap")
	if not minimap:
		return
	var existing_dot = minimap.get_node_or_null("PlayerDot")
	if existing_dot:
		minimap_player_dot = existing_dot
		return
	minimap_player_dot = ColorRect.new()
	minimap_player_dot.name = "PlayerDot"
	minimap_player_dot.color = Color(0, 1, 1, 1)
	minimap_player_dot.custom_minimum_size = Vector2(6, 6)
	minimap_player_dot.set_position(Vector2(72, 72))
	minimap.add_child(minimap_player_dot)

func _create_combat_log():
	var main_container = get_node_or_null("MainContainer")
	if not main_container:
		return
	var label = Label.new()
	label.name = "CombatLog"
	label.anchor_left = 0.0
	label.anchor_top = 1.0
	label.anchor_right = 0.0
	label.anchor_bottom = 1.0
	label.offset_left = 20.0
	label.offset_top = -150.0
	label.offset_right = 560.0
	label.offset_bottom = -20.0
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size", 16)
	label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.2, 1.0))
	main_container.add_child(label)
	combat_log_label = label

var hp_label: Label = null
var stamina_label: Label = null

func _create_stat_labels():
	var vbox = get_node("MainContainer/PlayerInfo/VBoxInfo")
	var hp_bar = get_node("MainContainer/PlayerInfo/VBoxInfo/HealthBar")
	var st_bar = get_node("MainContainer/PlayerInfo/VBoxInfo/StaminaBar")
	
	hp_label = Label.new()
	hp_label.text = "100 / 100"
	hp_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	hp_label.add_theme_font_size_override("font_size", 13)
	hp_label.add_theme_color_override("font_color", Color(1, 0.3, 0.3, 0.95))
	vbox.add_child(hp_label)
	vbox.move_child(hp_label, hp_bar.get_index())
	
	stamina_label = Label.new()
	stamina_label.text = "50 / 50"
	stamina_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	stamina_label.add_theme_font_size_override("font_size", 11)
	stamina_label.add_theme_color_override("font_color", Color(1, 0.85, 0.2, 0.9))
	vbox.add_child(stamina_label)
	vbox.move_child(stamina_label, st_bar.get_index())

func _apply_cli_style():
	var labels = find_children("*", "Label", true, false)
	for label in labels:
		if _cli_font:
			label.add_theme_font_override("font", _cli_font)
		label.add_theme_color_override("font_color", CLI_GREEN)
	
	var buttons = find_children("*", "Button", true, false)
	for btn in buttons:
		if _cli_font:
			btn.add_theme_font_override("font", _cli_font)
		btn.add_theme_color_override("font_color", CLI_CYAN)
	
	# CLI-style progress bars
	var hp = get_node_or_null("MainContainer/PlayerInfo/VBoxInfo/HealthBar")
	if hp:
		hp.tint_progress = CLI_GREEN
		hp.tint_under = Color(0.05, 0.1, 0.05, 0.9)
	
	var st = get_node_or_null("MainContainer/PlayerInfo/VBoxInfo/StaminaBar")
	if st:
		st.tint_progress = CLI_AMBER
		st.tint_under = Color(0.1, 0.08, 0.02, 0.9)
	
	var pname = get_node_or_null("MainContainer/PlayerInfo/VBoxInfo/PlayerName")
	if pname:
		pname.add_theme_color_override("font_color", CLI_CYAN)
func _create_xp_bar():
	if not has_node("MainContainer/PlayerInfo/VBoxInfo/XpBar"):
		var xp_bar = TextureProgressBar.new()
		xp_bar.name = "XpBar"
		xp_bar.custom_minimum_size = Vector2(240, 8)
		xp_bar.value = 0.0
		xp_bar.max_value = 100.0
		xp_bar.fill_mode = 0
		xp_bar.tint_progress = Color(1.0, 0.85, 0.0, 1)
		xp_bar.tint_under = Color(0.12, 0.08, 0.02, 0.8)
		var vbox = get_node("MainContainer/PlayerInfo/VBoxInfo")
		vbox.add_child(xp_bar)
		vbox.move_child(xp_bar, vbox.get_child_count() - 1)


func _update_minimap_dot():
	if not minimap_player_dot:
		return
	var players = get_tree().get_nodes_in_group("players")
	if players.size() == 0:
		return
	var player = players[0]
	# Convert world position (-100..100) to minimap (0..150)
	var world_size = 100.0
	var map_size = 150.0
	var px = (player.global_position.x + world_size) / (world_size * 2.0) * map_size
	var pz = (player.global_position.z + world_size) / (world_size * 2.0) * map_size
	minimap_player_dot.set_position(Vector2(px - 3, pz - 3))
func _create_crosshair():
	crosshair = Control.new()
	crosshair.name = "Crosshair"
	crosshair.mouse_filter = Control.MOUSE_FILTER_IGNORE
	crosshair.set_anchors_preset(Control.PRESET_CENTER)
	var white = Color(1, 1, 1, 0.75)
	var pink = Color(1, 0, 0.667, 0.85)
	var top = ColorRect.new()
	top.set_position(Vector2(-1, -12)); top.set_size(Vector2(2, 7)); top.color = white
	crosshair.add_child(top)
	var bot = ColorRect.new()
	bot.set_position(Vector2(-1, 5)); bot.set_size(Vector2(2, 7)); bot.color = white
	crosshair.add_child(bot)
	var left = ColorRect.new()
	left.set_position(Vector2(-12, -1)); left.set_size(Vector2(7, 2)); left.color = white
	crosshair.add_child(left)
	var right = ColorRect.new()
	right.set_position(Vector2(5, -1)); right.set_size(Vector2(7, 2)); right.color = white
	crosshair.add_child(right)
	var center = ColorRect.new()
	center.set_position(Vector2(-1, -1)); center.set_size(Vector2(2, 2)); center.color = pink
	crosshair.add_child(center)
	add_child(crosshair)

func _create_nearest_enemy_label():
	if nearest_enemy_label and is_instance_valid(nearest_enemy_label):
		return
	var main_container = get_node_or_null("MainContainer")
	if not main_container:
		return
	nearest_enemy_label = Label.new()
	nearest_enemy_label.name = "NearestEnemyLabel"
	nearest_enemy_label.anchor_left = 0.5
	nearest_enemy_label.anchor_top = 0.0
	nearest_enemy_label.anchor_right = 0.5
	nearest_enemy_label.anchor_bottom = 0.0
	nearest_enemy_label.offset_left = -260.0
	nearest_enemy_label.offset_top = 20.0
	nearest_enemy_label.offset_right = 260.0
	nearest_enemy_label.offset_bottom = 44.0
	nearest_enemy_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	nearest_enemy_label.text = "Sin amenazas cercanas"
	nearest_enemy_label.add_theme_font_size_override("font_size", 15)
	nearest_enemy_label.add_theme_color_override("font_color", Color(1.0, 0.75, 0.2, 0.95))
	main_container.add_child(nearest_enemy_label)

func _create_interaction_focus_label():
	if interaction_focus_label and is_instance_valid(interaction_focus_label):
		return
	var main_container = get_node_or_null("MainContainer")
	if not main_container:
		return
	interaction_focus_label = Label.new()
	interaction_focus_label.name = "InteractionFocusLabel"
	interaction_focus_label.anchor_left = 0.5
	interaction_focus_label.anchor_top = 0.5
	interaction_focus_label.anchor_right = 0.5
	interaction_focus_label.anchor_bottom = 0.5
	interaction_focus_label.offset_left = -280.0
	interaction_focus_label.offset_top = 38.0
	interaction_focus_label.offset_right = 280.0
	interaction_focus_label.offset_bottom = 66.0
	interaction_focus_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	interaction_focus_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	interaction_focus_label.text = ""
	interaction_focus_label.visible = false
	interaction_focus_label.add_theme_font_size_override("font_size", 16)
	interaction_focus_label.add_theme_color_override("font_color", Color(0.95, 0.95, 0.85, 1.0))
	main_container.add_child(interaction_focus_label)

func _update_nearest_enemy_label():
	if not nearest_enemy_label:
		return
	var players = get_tree().get_nodes_in_group("players")
	if players.size() == 0:
		nearest_enemy_label.text = "Sin jugador"
		return
	var player = players[0]
	if not player is Node3D:
		return
	var enemies = get_tree().get_nodes_in_group("enemies")
	var nearest: Node3D = null
	var best_dist := INF
	for enemy in enemies:
		if not enemy is Node3D:
			continue
		if "is_alive" in enemy and not bool(enemy.get("is_alive")):
			continue
		var dist = player.global_position.distance_to(enemy.global_position)
		if dist < best_dist:
			best_dist = dist
			nearest = enemy
	if not nearest:
		nearest_enemy_label.text = "Sin amenazas cercanas"
		return
	if best_dist > 35.0:
		nearest_enemy_label.text = "Zona relativamente segura"
	else:
		var enemy_name = nearest.get("npc_name") if "npc_name" in nearest else nearest.name
		nearest_enemy_label.text = "Amenaza: %s (%.1fm)" % [enemy_name, best_dist]

func _update_interaction_focus_label():
	if not interaction_focus_label:
		return
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		interaction_focus_label.visible = false
		return
	var players = get_tree().get_nodes_in_group("players")
	if players.size() == 0:
		interaction_focus_label.visible = false
		return
	var player = players[0]
	if not player is Node3D:
		interaction_focus_label.visible = false
		return
	var camera = get_viewport().get_camera_3d()
	if not camera:
		interaction_focus_label.visible = false
		return
	var from = camera.global_position
	var to = from + (-camera.global_transform.basis.z) * INTERACTION_FOCUS_DISTANCE
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.exclude = [player]
	query.collision_mask = 4 | 16
	query.collide_with_areas = true
	query.collide_with_bodies = true
	var result = camera.get_world_3d().direct_space_state.intersect_ray(query)
	if not result or not result.collider:
		interaction_focus_label.visible = false
		return
	var interactable = _resolve_interactable_node(result.collider)
	if not interactable or not interactable is Node3D:
		interaction_focus_label.visible = false
		return
	var interactable_node := interactable as Node3D
	var dist = player.global_position.distance_to(interactable_node.global_position)
	var prompt = _build_interaction_focus_prompt(player, interactable_node, dist)
	if prompt == "":
		interaction_focus_label.visible = false
		return
	interaction_focus_label.text = prompt
	interaction_focus_label.visible = true

func _resolve_interactable_node(collider: Object) -> Node:
	if not collider or not (collider is Node):
		return null
	var current = collider as Node
	while current:
		if current.is_in_group("loot_items") or current.is_in_group("npcs"):
			return current
		current = current.get_parent()
	return null

func _build_interaction_focus_prompt(player: Node3D, interactable: Node3D, dist: float) -> String:
	if interactable.is_in_group("loot_items"):
		var can_interact = false
		if interactable.has_method("can_player_interact"):
			can_interact = interactable.can_player_interact(player)
		if can_interact and interactable.has_method("get_interaction_prompt"):
			return interactable.get_interaction_prompt(true)
		if interactable.has_method("get_interaction_name"):
			return "%s (%.1fm)" % [interactable.get_interaction_name(), dist]
		return ""
	if interactable.is_in_group("npcs"):
		var npc_name = interactable.get("npc_name") if "npc_name" in interactable else interactable.name
		var npc_range = 3.0
		if "interaction_range" in interactable:
			npc_range = float(interactable.get("interaction_range"))
		if dist <= npc_range:
			return "[F] Hablar con %s" % npc_name
		return "%s (%.1fm)" % [npc_name, dist]
	return ""

func _on_inventory_opened():
	if crosshair: crosshair.visible = false

func _on_inventory_closed():
	if crosshair: crosshair.visible = true

func show_combat_log(message: String):
	if combat_log_label:
		combat_log_label.text = message
		combat_log_label.modulate.a = 1.0
		combat_log_timer = COMBAT_LOG_DURATION
