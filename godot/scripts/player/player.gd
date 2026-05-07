# ============================================================
# player.gd -- Controlador principal del personaje
# Barrio Sin Ley Online (BSLO)
# CharacterBody3D con movimiento, camara, habilidades, muerte/respawn
# ============================================================
extends CharacterBody3D

signal player_died(position: Vector3)
signal player_respawned()
signal player_took_damage(amount: int, damage_type: String, attacker: Node)
signal stats_changed(stat_name: String, new_value: int)
signal health_changed(current_hp: int, max_hp: int)
signal stamina_changed(current_stamina: int, max_stamina: int)
signal camera_toggled(is_first_person: bool)
signal rolled()

@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera_3d: Camera3D = $CameraPivot/Camera3D
@onready var character_body: Node3D = $CharacterBody
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@export var walk_speed: float = 3.5
@export var sprint_speed: float = 6.5
@export var roll_speed: float = 8.0
@export var acceleration: float = 5.0
@export var sprint_ramp_up_time: float = 0.35
@export var sprint_ramp_down_time: float = 0.25
@export var air_control: float = 0.3
@export var jump_velocity: float = 4.5
@export var mouse_sensitivity: float = 0.0012
@export var camera_distance: float = 5.0
@export var camera_min_distance: float = 3.0
@export var camera_max_distance: float = 8.0
@export var camera_angle_min: float = -40.0
@export var camera_angle_max: float = 70.0
@export var camera_smooth_speed: float = 7.0

enum PlayerState { IDLE, WALKING, SPRINTING, ROLLING, DEAD, STUNNED }

@export var current_state: PlayerState = PlayerState.IDLE
var is_first_person: bool = false
var is_moving: bool = false
var is_grounded: bool = true
var can_move: bool = true
var input_dir: Vector2 = Vector2.ZERO
var mouse_motion: Vector2 = Vector2.ZERO
var camera_rotation_x: float = 0.0
var camera_rotation_y: float = 0.0
var last_directional_key_time: float = 0.0
var last_directional_key: String = ""
const DOUBLE_TAP_TIME: float = 0.25
var is_rolling: bool = false
var roll_direction: Vector3 = Vector3.FORWARD
var roll_timer: float = 0.0
const ROLL_DURATION: float = 0.4
var attack_cooldown_timer: float = 0.0
const ATTACK_COOLDOWN: float = 0.5
const ATTACK_RANGE: float = 3.0
var is_attacking: bool = false
var attack_lunge_mesh_z: float = 0.0
var is_sprinting: bool = false
var _current_move_speed: float = 0.0
var _stamina_drain_accumulator: float = 0.0
var _stamina_regen_accumulator: float = 0.0
const SPRINT_STAMINA_DRAIN_PER_SEC: float = 8.0
const STAMINA_REGEN_PER_SEC: float = 5.0
var current_hp: int = 100
var max_hp: int = 100
var current_stamina: int = 50
var max_stamina: int = 50
var footstep_timer: float = 0.0
const FOOTSTEP_INTERVAL: float = 0.5
var debug_overlay_visible: bool = false
var debug_key_was_pressed: bool = false
var hud_node: CanvasLayer = null
var target_camera_distance: float = 5.0
var current_camera_distance: float = 5.0
var flash_overlay: ColorRect = null
var current_class_id: String = "tanque"
var player_faction: String = "YAKUZA"
var _class_setup_done: bool = false
var class_skills: Array = []
var skill_cooldowns: Dictionary = {}
enum SkillType { MELEE, RANGED, AREA, SUPPORT }
const PROJECTILE_SCENE: String = "res://scenes/combat/projectile.tscn"
var skill_tree_overlay: CanvasLayer = null
var stats_panel_overlay: CanvasLayer = null
var settings_menu_overlay: CanvasLayer = null
var _death_screen: CanvasLayer = null
var _is_respawning: bool = false
const RESPAWN_POSITION: Vector3 = Vector3(0, 1.0, 5)
const SAFE_MIN_SPAWN_Y: float = 1.0
var _space_key_was_pressed: bool = false

func _enter_tree():
	add_to_group("players")
	print("PLAYER _enter_tree()")

func _ready():
	print("PLAYER _ready() START")
	add_to_group("players")
	if global_position.y < SAFE_MIN_SPAWN_Y:
		global_position.y = SAFE_MIN_SPAWN_Y
	if GameSettings:
		GameSettings.apply_to_player(self)
	_current_move_speed = walk_speed
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_apply_faction_colors()
	if StatsManager:
		StatsManager.health_changed.connect(_on_stats_health_changed)
		StatsManager.stamina_changed.connect(_on_stats_stamina_changed)
		StatsManager.player_died.connect(_on_player_died_from_stats)
		StatsManager.leveled_up.connect(_on_leveled_up)
		StatsManager.pb_changed.connect(_on_pb_changed)
		current_hp = StatsManager.current_hp
		max_hp = StatsManager.max_hp
		current_stamina = StatsManager.current_stamina
		max_stamina = StatsManager.max_stamina
	call_deferred("_find_hud")
	call_deferred("_find_ui_overlays")
	call_deferred("_setup_class")
	call_deferred("_ensure_mouse_capture")
	print("PLAYER _ready() COMPLETE")

func _ensure_mouse_capture():
	if current_state != PlayerState.DEAD and not _is_ui_mouse_active():
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _apply_faction_colors():
	var colors = {
		"YAKUZA": Color(0.05, 0.05, 0.15),
		"CARTEL": Color(0.3, 0.15, 0.05),
		"MAFIA": Color(0.08, 0.02, 0.02),
		"POLICIA": Color(0.05, 0.08, 0.2),
		"CHOLOS": Color(0.15, 0.02, 0.2),
		"SIN_LEGAJA": Color(0.15, 0.15, 0.1),
	}
	var color = colors.get(player_faction, Color(0.15, 0.15, 0.2))
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = 0.7
	if character_body:
		character_body.material_override = mat

func _find_hud():
	var huds = get_tree().get_nodes_in_group("hud")
	if huds.size() > 0:
		hud_node = huds[0]
		print("Player: HUD encontrado")

func _setup_class():
	if _class_setup_done:
		return
	if current_class_id == "":
		return
	if not ClassManager:
		push_error("Player: ClassManager no disponible")
		return
	var class_data = ClassManager.get_class_data(current_class_id)
	if class_data == null:
		push_error("Player: Clase no encontrada: ", current_class_id)
		return
	if StatsManager:
		StatsManager.apply_class_modifiers(class_data)
	class_skills.clear()
	skill_cooldowns.clear()
	for skill in class_data.skills:
		if skill.hotbar_slot >= 1:
			class_skills.append(skill)
			skill_cooldowns[skill.skill_id] = 0.0
	class_skills.sort_custom(func(a, b): return a.hotbar_slot < b.hotbar_slot)
	if hud_node:
		if hud_node.has_method("set_class_name"):
			hud_node.set_class_name(class_data.get("class_name_str"))
		if hud_node.has_method("set_faction_name"):
			hud_node.set_faction_name(player_faction)
		if hud_node.has_method("set_available_skills"):
			hud_node.set_available_skills(class_skills.size())
	_update_hotbar_labels()
	_find_ui_overlays()
	_class_setup_done = true
	print("Player: Clase configurada - ", class_data.get("class_name_str"), " [", player_faction, "] | Habilidades activas: ", class_skills.size())

func _find_ui_overlays():
	var root = get_tree().current_scene
	if root:
		skill_tree_overlay = root.get_node_or_null("SkillTree")
		stats_panel_overlay = root.get_node_or_null("StatsPanel")
		settings_menu_overlay = root.get_node_or_null("SettingsMenu")

func _input(event: InputEvent):
	if event.is_action_pressed("toggle_settings"):
		_toggle_settings_menu()
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed("ui_cancel") and settings_menu_overlay and settings_menu_overlay.visible:
		_toggle_settings_menu()
		get_viewport().set_input_as_handled()
		return
	if event is InputEventMouseButton and event.pressed:
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED and current_state != PlayerState.DEAD and not _is_ui_mouse_active():
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		return
	if event.is_action_pressed("toggle_inventory"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("toggle_skills"):
		_toggle_skill_tree()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if skill_tree_overlay and skill_tree_overlay.visible else Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("toggle_stats"):
		_toggle_stats_panel()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if stats_panel_overlay and stats_panel_overlay.visible else Input.MOUSE_MODE_CAPTURED
	if current_state == PlayerState.DEAD:
		return
	_handle_hotbar_input(event)
	if event.is_action_pressed("primary_attack"):
		_try_primary_attack()
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		camera_rotation_y -= event.relative.x * mouse_sensitivity
		camera_rotation_x -= event.relative.y * mouse_sensitivity
		camera_rotation_x = deg_to_rad(clampf(rad_to_deg(camera_rotation_x), camera_angle_min, camera_angle_max))
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_camera_distance = clampf(target_camera_distance - 0.5, camera_min_distance, camera_max_distance)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_camera_distance = clampf(target_camera_distance + 0.5, camera_min_distance, camera_max_distance)
	if event.is_action_pressed("toggle_camera"):
		toggle_camera_view()

func _is_ui_mouse_active() -> bool:
	if InventoryManager and InventoryManager.is_open:
		return true
	if skill_tree_overlay and skill_tree_overlay.visible:
		return true
	if stats_panel_overlay and stats_panel_overlay.visible:
		return true
	if settings_menu_overlay and settings_menu_overlay.visible:
		return true

	var root = get_tree().current_scene
	if root:
		var quest_log = root.get_node_or_null("QuestLog")
		if quest_log and quest_log.visible:
			return true
		var shop_screen = root.get_node_or_null("ShopScreen")
		if shop_screen and shop_screen.visible:
			return true

	if _death_screen and is_instance_valid(_death_screen) and _death_screen.visible:
		return true

	return false

func _get_move_input() -> Vector2:
	var move = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	if move != Vector2.ZERO:
		return move

	var ui_move = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if ui_move != Vector2.ZERO:
		return ui_move

	var raw = Vector2.ZERO
	if Input.is_physical_key_pressed(KEY_A) or Input.is_physical_key_pressed(KEY_LEFT):
		raw.x -= 1.0
	if Input.is_physical_key_pressed(KEY_D) or Input.is_physical_key_pressed(KEY_RIGHT):
		raw.x += 1.0
	if Input.is_physical_key_pressed(KEY_W) or Input.is_physical_key_pressed(KEY_UP):
		raw.y -= 1.0
	if Input.is_physical_key_pressed(KEY_S) or Input.is_physical_key_pressed(KEY_DOWN):
		raw.y += 1.0

	if raw.length() > 1.0:
		raw = raw.normalized()
	return raw

func _process(delta: float):
	if current_state == PlayerState.DEAD:
		return
	var f1_pressed = Input.is_key_pressed(KEY_F1)
	if f1_pressed and not debug_key_was_pressed:
		debug_overlay_visible = not debug_overlay_visible
		if hud_node and hud_node.has_method("toggle_debug"):
			hud_node.toggle_debug()
	debug_key_was_pressed = f1_pressed
	_update_hud()
	_update_footsteps(delta)
	_update_skill_cooldowns(delta)
	_update_hotbar_cooldown_display()
	_update_attack_cooldown(delta)
	_update_attack_lunge(delta)
	if debug_overlay_visible and hud_node and hud_node.has_method("update_debug"):
		hud_node.update_debug(current_hp, max_hp, current_stamina, max_stamina, PlayerState.keys()[current_state], global_position)

func _update_hud():
	if not hud_node:
		return
	if hud_node.has_method("update_hp"):
		hud_node.update_hp(current_hp, max_hp)
	if hud_node.has_method("update_stamina"):
		hud_node.update_stamina(current_stamina, max_stamina)
	if hud_node.has_method("update_pb"):
		var pb = 0
		if StatsManager:
			pb = StatsManager.carried_pb
		hud_node.update_pb(pb)
	if hud_node.has_method("update_money"):
		var pb = 0
		if StatsManager:
			pb = StatsManager.carried_pb
		hud_node.update_money(pb)
	if hud_node.has_method("update_level"):
		var lvl = 1
		if StatsManager:
			lvl = StatsManager.level
		hud_node.update_level(lvl)
	if hud_node.has_method("update_xp") and StatsManager:
		hud_node.update_xp(StatsManager.current_xp, StatsManager.xp_to_next_level)
	if hud_node.has_method("update_skill_points") and StatsManager:
		hud_node.update_skill_points(StatsManager.skill_points)
	if hud_node.has_method("update_wanted"):
		hud_node.update_wanted(0)

func _update_footsteps(delta: float):
	if not is_moving or not is_on_floor():
		footstep_timer = 0.0
		return
	footstep_timer += delta
	if footstep_timer >= FOOTSTEP_INTERVAL:
		footstep_timer -= FOOTSTEP_INTERVAL
		print("footstep")

func _update_skill_cooldowns(delta: float):
	for skill_id in skill_cooldowns:
		if skill_cooldowns[skill_id] > 0.0:
			skill_cooldowns[skill_id] = maxf(0.0, skill_cooldowns[skill_id] - delta)

func _update_hotbar_labels():
	if not hud_node:
		return
	for i in range(class_skills.size()):
		var skill = class_skills[i]
		var slot_index = skill.hotbar_slot - 1
		if slot_index >= 0 and slot_index < 10:
			if hud_node.has_method("set_hotbar_item"):
				hud_node.set_hotbar_item(slot_index, skill.skill_name, 0)

func _update_hotbar_cooldown_display():
	if not hud_node:
		return
	for i in range(class_skills.size()):
		var skill = class_skills[i]
		var slot_index = skill.hotbar_slot - 1
		if slot_index >= 0 and slot_index < 10:
			var remaining = skill_cooldowns.get(skill.skill_id, 0.0)
			if hud_node.has_method("set_hotbar_cooldown"):
				hud_node.set_hotbar_cooldown(slot_index, remaining, skill.cooldown)

func _handle_hotbar_input(event: InputEvent):
	if not event is InputEventKey or not event.pressed:
		return
	var slot = -1
	match event.keycode:
		KEY_1: slot = 0
		KEY_2: slot = 1
		KEY_3: slot = 2
		KEY_4: slot = 3
		KEY_5: slot = 4
	if slot >= 0:
		use_skill(slot)

func can_use_skill(slot: int) -> bool:
	if slot < 0 or slot >= class_skills.size():
		return false
	var skill = class_skills[slot]
	if skill_cooldowns.has(skill.skill_id) and skill_cooldowns[skill.skill_id] > 0.0:
		return false
	if StatsManager and StatsManager.current_stamina < skill.stamina_cost:
		return false
	if StatsManager and StatsManager.level < skill.unlock_level:
		return false
	return true

func use_skill(slot: int):
	if not can_use_skill(slot):
		return
	var skill = class_skills[slot]
	if StatsManager:
		StatsManager.use_stamina(skill.stamina_cost)
	skill_cooldowns[skill.skill_id] = skill.cooldown
	var damage = _calculate_skill_base_damage(skill)
	var skill_type = _get_skill_type(skill)
	match skill_type:
		SkillType.MELEE:
			_execute_melee_skill(skill, damage)
		SkillType.RANGED:
			_execute_ranged_skill(skill, damage)
		SkillType.AREA:
			_execute_area_skill(skill, damage)
		SkillType.SUPPORT:
			_execute_support_skill(skill)
	_show_skill_feedback(skill.skill_name, skill_type)
	_update_hud()

func _get_skill_type(skill: Resource) -> int:
	if skill.damage_multiplier == 0.0:
		return SkillType.SUPPORT
	if skill.area_radius > 0.0:
		return SkillType.AREA
	var role = _get_player_class_role()
	if role in ["RANGED"]:
		return SkillType.RANGED
	return SkillType.MELEE

func _get_player_class_role() -> String:
	if not ClassManager:
		return "MELEE"
	var class_data = ClassManager.get_class_data(current_class_id)
	if class_data:
		return class_data.role
	return "MELEE"

func _calculate_skill_base_damage(skill: Resource) -> int:
	var base = 15
	if StatsManager:
		var class_data = null
		if ClassManager:
			class_data = ClassManager.get_class_data(current_class_id)
		var primary_stat = "STR"
		if class_data:
			primary_stat = class_data.primary_stat
		var stat_value = StatsManager.get_stat(primary_stat)
		base = maxi(5, int(float(stat_value) * 2.5))
		base += StatsManager.level
	return maxi(1, int(float(base) * skill.damage_multiplier))

func _execute_melee_skill(skill: Resource, damage: int):
	var forward = -camera_pivot.global_transform.basis.z
	forward.y = 0.0
	forward = forward.normalized()
	var hit_enemy = _find_nearest_enemy_in_front(3.0, forward)
	if hit_enemy:
		if hit_enemy.has_method("take_damage"):
			hit_enemy.take_damage(damage)
		_show_combat_feedback("Golpeas con %s - %d danio" % [skill.skill_name, damage])
	else:
		_show_combat_feedback("Golpeas al aire con %s" % skill.skill_name)

func _execute_ranged_skill(skill: Resource, damage: int):
	var forward = -camera_pivot.global_transform.basis.z
	forward.y = 0.0
	forward = forward.normalized()
	var projectile_scene = load(PROJECTILE_SCENE)
	if not projectile_scene:
		return
	var projectile = projectile_scene.instantiate()
	projectile.setup(forward, damage, self, "physical")
	projectile.global_position = global_position + Vector3(0.0, 1.2, 0.0) + forward * 1.0
	var current_scene = get_tree().current_scene
	if current_scene:
		current_scene.add_child(projectile)
		var pmesh = projectile.get_node_or_null("MeshInstance3D")
		if pmesh:
			pmesh.scale = Vector3.ONE * clampf(0.5 + damage * 0.015, 0.5, 2.5)
		_show_combat_feedback("Disparas %s - %d danio" % [skill.skill_name, damage])

func _execute_area_skill(skill: Resource, damage: int):
	var radius = skill.area_radius
	var enemies = get_tree().get_nodes_in_group("enemies")
	var hit_count = 0
	for enemy in enemies:
		if not _is_valid_attack_target(enemy):
			continue
		if not enemy is Node3D:
			continue
		var enemy_node := enemy as Node3D
		var dist = global_position.distance_to(enemy_node.global_position)
		if dist <= radius:
			enemy.take_damage(damage)
			hit_count += 1
	if hit_count > 0:
		_show_combat_feedback("%s golpea a %d enemigos - %d danio" % [skill.skill_name, hit_count, damage])
	else:
		_show_combat_feedback("%s: sin enemigos en area" % skill.skill_name)

func _execute_support_skill(skill: Resource):
	var heal_amount = 15
	if StatsManager:
		heal_amount = maxi(10, int(float(StatsManager.max_hp) * 0.1))
		StatsManager.heal(heal_amount)
	_show_combat_feedback("Usas %s (+%d HP)" % [skill.skill_name, heal_amount])

func _find_nearest_enemy_in_front(range_val: float, direction: Vector3) -> Node:
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() == 0:
		enemies = get_tree().get_nodes_in_group("npcs")
	var best_enemy: Node = null
	var best_dist = range_val
	for enemy in enemies:
		if not _is_valid_attack_target(enemy):
			continue
		if not enemy is Node3D:
			continue
		var enemy_node := enemy as Node3D
		var to_enemy = enemy_node.global_position - global_position
		to_enemy.y = 0.0
		var dist = to_enemy.length()
		if dist > range_val:
			continue
		var dot = direction.dot(to_enemy.normalized())
		if dot > 0.3:
			if dist < best_dist:
				best_dist = dist
				best_enemy = enemy
	return best_enemy

func _is_valid_attack_target(target: Node) -> bool:
	if not target or not is_instance_valid(target):
		return false
	if target == self:
		return false
	if not target.has_method("take_damage"):
		return false
	if target.has_method("is_alive_check") and not target.is_alive_check():
		return false
	if "is_hostile" in target and not bool(target.get("is_hostile")):
		return false
	return true

func _resolve_attack_target_from_collider(collider: Object) -> Node:
	if not collider or not (collider is Node):
		return null
	var current: Node = collider
	while current:
		if _is_valid_attack_target(current):
			return current
		current = current.get_parent()
	return null

func _show_combat_feedback(message: String):
	if hud_node and hud_node.has_method("show_combat_log"):
		hud_node.show_combat_log(message)

func _show_skill_feedback(skill_name: String, skill_type: int):
	var color: Color
	match skill_type:
		SkillType.MELEE:   color = Color(1.0, 0.4, 0.1, 1.0)
		SkillType.RANGED:  color = Color(1.0, 0.85, 0.1, 1.0)
		SkillType.AREA:    color = Color(1.0, 0.1, 0.5, 1.0)
		SkillType.SUPPORT: color = Color(0.1, 0.9, 0.3, 1.0)
		_:                 color = Color.WHITE
	var label = Label3D.new()
	label.text = skill_name
	label.font_size = 36
	label.modulate = color
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.outline_size = 1
	label.outline_modulate = Color.BLACK
	var root = get_tree().current_scene
	if root:
		label.global_position = global_position + Vector3(0.0, 2.5, 0.0)
		root.add_child(label)
		var tween = label.create_tween()
		tween.set_parallel(true)
		tween.tween_property(label, "position:y", label.position.y + 2.0, 1.2)
		tween.tween_property(label, "modulate:a", 0.0, 1.0)
		tween.chain()
		tween.tween_callback(label.queue_free)

func _toggle_skill_tree():
	if GameManager:
		if GameManager.is_skill_tree_open:
			GameManager.close_skill_tree()
		else:
			GameManager.open_skill_tree()
	if skill_tree_overlay:
		skill_tree_overlay.visible = not skill_tree_overlay.visible

func _toggle_stats_panel():
	if GameManager:
		if GameManager.is_stats_panel_open:
			GameManager.close_stats_panel()
		else:
			GameManager.open_stats_panel()
	if stats_panel_overlay:
		stats_panel_overlay.visible = not stats_panel_overlay.visible

func _toggle_settings_menu():
	if not settings_menu_overlay:
		_find_ui_overlays()
	if not settings_menu_overlay:
		return
	if settings_menu_overlay.has_method("toggle_menu"):
		settings_menu_overlay.toggle_menu()
	else:
		settings_menu_overlay.visible = not settings_menu_overlay.visible
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if settings_menu_overlay.visible else Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float):
	if current_state == PlayerState.DEAD:
		return
	if current_hp <= 0 and current_state != PlayerState.DEAD:
		_on_player_died()
		return
	input_dir = _get_move_input()
	var jump_pressed = _is_jump_just_pressed()
	is_moving = input_dir.length() > 0.1
	_handle_double_tap_roll(delta)
	if current_state == PlayerState.ROLLING:
		_process_roll_state(delta)
		return
	var wants_sprint = Input.is_action_pressed("sprint") and is_moving and current_stamina > 0
	is_sprinting = wants_sprint
	if is_sprinting and StatsManager:
		_stamina_drain_accumulator += SPRINT_STAMINA_DRAIN_PER_SEC * delta
		var stamina_to_drain = int(_stamina_drain_accumulator)
		if stamina_to_drain > 0:
			_stamina_drain_accumulator -= float(stamina_to_drain)
			if not StatsManager.use_stamina(stamina_to_drain):
				is_sprinting = false
	else:
		_stamina_drain_accumulator = 0.0
	var target_speed: float = walk_speed
	if is_sprinting:
		target_speed = sprint_speed
		current_state = PlayerState.SPRINTING
	elif is_moving:
		current_state = PlayerState.WALKING
	else:
		current_state = PlayerState.IDLE
	var ramp_time = sprint_ramp_up_time if target_speed > _current_move_speed else sprint_ramp_down_time
	var ramp_weight = clampf(delta / maxf(ramp_time, 0.001), 0.0, 1.0)
	_current_move_speed = lerpf(_current_move_speed, target_speed, ramp_weight)
	var forward = -camera_pivot.global_transform.basis.z
	forward.y = 0.0
	forward = forward.normalized()
	var right = camera_pivot.global_transform.basis.x
	right.y = 0.0
	right = right.normalized()
	var move_direction = Vector3.ZERO
	if input_dir.length() > 0:
		move_direction = (forward * -input_dir.y + right * input_dir.x).normalized()
	if is_on_floor():
		is_grounded = true
		if jump_pressed:
			velocity.y = jump_velocity
		else:
			var target_velocity = move_direction * _current_move_speed
			velocity.x = move_toward(velocity.x, target_velocity.x, acceleration * delta)
			velocity.z = move_toward(velocity.z, target_velocity.z, acceleration * delta)
	else:
		is_grounded = false
		var air_velocity = move_direction * _current_move_speed * air_control
		velocity.x = move_toward(velocity.x, air_velocity.x, acceleration * air_control * delta)
		velocity.z = move_toward(velocity.z, air_velocity.z, acceleration * air_control * delta)
	if not is_on_floor():
		velocity.y -= 24.0 * delta
	if current_state != PlayerState.ROLLING:
		# Body yaw follows camera yaw so WASD is always relative to mouse look.
		rotation.y = lerp_angle(rotation.y, camera_rotation_y, 12.0 * delta)
	move_and_slide()
	_update_camera(delta)
	if not is_sprinting and StatsManager:
		_stamina_regen_accumulator += STAMINA_REGEN_PER_SEC * delta
		var stamina_to_regen = int(_stamina_regen_accumulator)
		if stamina_to_regen > 0:
			_stamina_regen_accumulator -= float(stamina_to_regen)
			StatsManager.restore_stamina(stamina_to_regen)
	else:
		_stamina_regen_accumulator = 0.0

func _process_roll_state(delta: float):
	roll_timer -= delta
	if roll_timer <= 0.0:
		current_state = PlayerState.IDLE
		is_rolling = false
		can_move = true
		return
	velocity = roll_direction * roll_speed
	velocity.y = 0.0
	move_and_slide()

func _handle_double_tap_roll(_delta: float):
	var current_key = ""
	if Input.is_action_just_pressed("move_forward"):
		current_key = "forward"
	elif Input.is_action_just_pressed("move_back"):
		current_key = "back"
	elif Input.is_action_just_pressed("move_left"):
		current_key = "left"
	elif Input.is_action_just_pressed("move_right"):
		current_key = "right"
	if current_key == "":
		return
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_key == last_directional_key and (current_time - last_directional_key_time) < DOUBLE_TAP_TIME:
		if StatsManager and StatsManager.use_stamina(20):
			_start_roll(current_key)
	last_directional_key = current_key
	last_directional_key_time = current_time

func _start_roll(key: String):
	var forward = -camera_pivot.global_transform.basis.z
	forward.y = 0.0
	forward = forward.normalized()
	var right = camera_pivot.global_transform.basis.x
	right.y = 0.0
	right = right.normalized()
	match key:
		"forward":
			roll_direction = forward
		"back":
			roll_direction = -forward
		"left":
			roll_direction = -right
		"right":
			roll_direction = right
	current_state = PlayerState.ROLLING
	is_rolling = true
	can_move = false
	roll_timer = ROLL_DURATION
	rolled.emit()

func _update_camera(delta: float):
	current_camera_distance = lerpf(current_camera_distance, target_camera_distance, camera_smooth_speed * delta)
	if is_first_person:
		camera_pivot.position = Vector3(0.0, 1.7, 0.0)
		camera_pivot.rotation = Vector3(camera_rotation_x, 0.0, 0.0)
		camera_3d.position = Vector3.ZERO
		camera_3d.rotation = Vector3.ZERO
	else:
		camera_pivot.position = Vector3.ZERO
		camera_pivot.rotation.x = lerp_angle(camera_pivot.rotation.x, camera_rotation_x, camera_smooth_speed * delta)
		# Keep mouse yaw as global reference by compensating parent (player) rotation.
		var local_yaw_target = camera_rotation_y - rotation.y
		camera_pivot.rotation.y = lerp_angle(camera_pivot.rotation.y, local_yaw_target, camera_smooth_speed * delta)
		var target_pos = Vector3(0.0, 1.5, current_camera_distance)
		var space_state = get_world_3d().direct_space_state
		if space_state:
			var from = global_position + Vector3(0.0, 1.5, 0.0)
			var to = camera_pivot.to_global(target_pos)
			var query = PhysicsRayQueryParameters3D.create(from, to)
			query.exclude = [self]
			query.collision_mask = 1
			var result = space_state.intersect_ray(query)
			if result:
				var hit_distance = from.distance_to(result.position) - 0.3
				if hit_distance < current_camera_distance:
					target_pos.z = hit_distance
		camera_3d.position = target_pos
		camera_3d.look_at(global_position + Vector3(0.0, 1.5, 0.0), Vector3.UP)

func _is_jump_just_pressed() -> bool:
	var action_jump = Input.is_action_just_pressed("jump")
	var space_pressed = Input.is_physical_key_pressed(KEY_SPACE)
	var space_jump = space_pressed and not _space_key_was_pressed
	_space_key_was_pressed = space_pressed
	return action_jump or space_jump

func toggle_camera_view():
	is_first_person = not is_first_person
	camera_toggled.emit(is_first_person)
	if is_first_person:
		character_body.visible = false
	else:
		character_body.visible = true

func _on_stats_health_changed(hp: int, max_hp_val: int):
	current_hp = hp
	max_hp = max_hp_val
	health_changed.emit(hp, max_hp_val)
	if hp <= 0 and current_state != PlayerState.DEAD:
		_on_player_died()

func _on_stats_stamina_changed(stamina: int, max_stamina_val: int):
	current_stamina = stamina
	max_stamina = max_stamina_val
	stamina_changed.emit(stamina, max_stamina_val)

func _on_pb_changed(new_amount: int):
	if hud_node and hud_node.has_method("update_pb"):
		hud_node.update_pb(new_amount)
	if hud_node and hud_node.has_method("update_money"):
		hud_node.update_money(new_amount)

func _on_player_died_from_stats():
	if current_state != PlayerState.DEAD:
		_on_player_died()

func _on_player_died():
	if current_state == PlayerState.DEAD:
		return
	current_state = PlayerState.DEAD
	can_move = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	var xp_lost = 0
	var pb_lost = 0
	if StatsManager:
		xp_lost = StatsManager.lose_xp_on_death()
		pb_lost = StatsManager.lose_pb_on_death()
	print("YOU DIED - Perdiste %d XP y %d PB" % [xp_lost, pb_lost])
	var death_pos = global_position
	player_died.emit(death_pos)
	_play_death_fade()
	_show_death_overlay(xp_lost, pb_lost)
	var tween = create_tween()
	tween.tween_interval(3.0)
	tween.tween_callback(_respawn)

func _show_death_overlay(xp_lost: int, pb_lost: int):
	var root = get_tree().current_scene
	if not root:
		return
	var death_screen = root.get_node_or_null("DeathScreen")
	if death_screen and death_screen.has_method("show_death"):
		death_screen.show_death(xp_lost, pb_lost)
		_death_screen = death_screen
		if death_screen.has_signal("respawn_requested"):
			if not death_screen.respawn_requested.is_connected(_respawn):
				death_screen.respawn_requested.connect(_respawn)
		return
	_create_inline_death_overlay(xp_lost, pb_lost)

func _create_inline_death_overlay(xp_lost: int, pb_lost: int):
	var root = get_tree().current_scene
	if not root:
		return
	var death_overlay = CanvasLayer.new()
	death_overlay.name = "_DeathOverlay"
	death_overlay.layer = 100
	root.add_child(death_overlay)
	_death_screen = death_overlay
	var bg = ColorRect.new()
	bg.color = Color(0, 0, 0, 0.85)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	death_overlay.add_child(bg)
	var dead_label = Label.new()
	dead_label.text = "HAS MUERTO"
	dead_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	dead_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	dead_label.add_theme_font_size_override("font_size", 64)
	dead_label.add_theme_color_override("font_color", Color(1.0, 0.0, 0.0, 1.0))
	dead_label.set_anchors_preset(Control.PRESET_CENTER_TOP)
	dead_label.position = Vector2(-200, 180)
	dead_label.size = Vector2(400, 80)
	dead_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	death_overlay.add_child(dead_label)
	var loss_label = Label.new()
	loss_label.text = "Perdiste %d XP y %d PB" % [xp_lost, pb_lost]
	loss_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	loss_label.add_theme_font_size_override("font_size", 24)
	loss_label.add_theme_color_override("font_color", Color(1.0, 0.5, 0.0, 1.0))
	loss_label.set_anchors_preset(Control.PRESET_CENTER_TOP)
	loss_label.position = Vector2(-250, 280)
	loss_label.size = Vector2(500, 50)
	loss_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	death_overlay.add_child(loss_label)
	var timer_label = Label.new()
	timer_label.text = "Reapareciendo en 3s..."
	timer_label.name = "TimerLabel"
	timer_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	timer_label.add_theme_font_size_override("font_size", 18)
	timer_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7, 1.0))
	timer_label.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	timer_label.position = Vector2(-150, -100)
	timer_label.size = Vector2(300, 40)
	timer_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	death_overlay.add_child(timer_label)

func _play_death_fade():
	if character_body:
		var mat := StandardMaterial3D.new()
		mat.albedo_color = Color(1.0, 1.0, 1.0, 0.2)
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		character_body.material_override = mat

func _respawn():
	if _is_respawning:
		return
	_is_respawning = true
	if StatsManager:
		StatsManager.current_hp = StatsManager.max_hp
		StatsManager.current_stamina = StatsManager.max_stamina
		StatsManager.health_changed.emit(StatsManager.current_hp, StatsManager.max_hp)
		StatsManager.stamina_changed.emit(StatsManager.current_stamina, StatsManager.max_stamina)
	current_hp = max_hp
	current_stamina = max_stamina
	global_position = _get_respawn_position()
	velocity = Vector3.ZERO
	_apply_faction_colors()
	current_state = PlayerState.IDLE
	can_move = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_cleanup_death_overlay()
	print("Has resucitado en el barrio")
	player_respawned.emit()
	_is_respawning = false

func _cleanup_death_overlay():
	if _death_screen and is_instance_valid(_death_screen):
		_death_screen.queue_free()
		_death_screen = null
	var root = get_tree().current_scene
	if root:
		var death_screen_node = root.get_node_or_null("DeathScreen")
		if death_screen_node and death_screen_node.has_method("hide_death"):
			death_screen_node.hide_death()

func _get_respawn_position() -> Vector3:
	var fallback = RESPAWN_POSITION
	if fallback.y < SAFE_MIN_SPAWN_Y:
		fallback.y = SAFE_MIN_SPAWN_Y
	var root = get_tree().current_scene
	if not root:
		return fallback
	var marker = root.get_node_or_null("RespawnPoint")
	if marker and marker is Node3D:
		var marker_pos = marker.global_position
		if marker_pos.y < SAFE_MIN_SPAWN_Y:
			marker_pos.y = SAFE_MIN_SPAWN_Y
		return marker_pos
	return fallback

func _update_attack_cooldown(delta: float):
	if attack_cooldown_timer > 0.0:
		attack_cooldown_timer = maxf(0.0, attack_cooldown_timer - delta)

func _try_primary_attack():
	if attack_cooldown_timer > 0.0:
		return
	if current_state == PlayerState.DEAD:
		return
	if current_state == PlayerState.ROLLING:
		return
	if not can_move:
		return
	_primary_attack()

func _primary_attack():
	attack_cooldown_timer = ATTACK_COOLDOWN
	var forward = -camera_pivot.global_transform.basis.z
	forward.y = 0.0
	forward = forward.normalized()
	var space_state = get_world_3d().direct_space_state
	var origin = global_position + Vector3(0.0, 1.0, 0.0)
	var end = origin + forward * ATTACK_RANGE
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.exclude = [self]
	query.collision_mask = 4
	var result = space_state.intersect_ray(query)
	var hit_enemy: Node = _resolve_attack_target_from_collider(result.collider if result and result.collider else null)
	if not hit_enemy:
		hit_enemy = _find_nearest_enemy_in_front(ATTACK_RANGE + 0.8, forward)
	if hit_enemy:
		var damage = 10
		if StatsManager:
			damage += StatsManager.get_stat("STR")
		var enemy_name = hit_enemy.get("npc_name") if "npc_name" in hit_enemy else hit_enemy.name
		hit_enemy.take_damage(damage)
		_flash_hit_enemy(hit_enemy)
		_show_combat_feedback("Golpeas a %s - %d dano" % [enemy_name, damage])
	else:
		_show_combat_feedback("Golpeas al aire")
	_start_melee_lunge()

func _update_attack_lunge(_delta: float):
	pass

func _start_melee_lunge():
	if not character_body:
		return
	var original_pos = character_body.position
	character_body.position.z -= 1.0
	var tween = create_tween()
	tween.tween_interval(0.1)
	var restore_mesh_pos = func():
		if is_instance_valid(character_body):
			character_body.position = original_pos
	tween.tween_callback(restore_mesh_pos)

func _flash_hit_enemy(enemy: Node):
	if not enemy is Node3D:
		return
	var mesh_node: MeshInstance3D = null
	for child in enemy.get_children():
		if child is MeshInstance3D:
			mesh_node = child
			break
	if not mesh_node:
		return
	var original_mat = mesh_node.material_override
	if original_mat == null:
		original_mat = mesh_node.get_surface_override_material(0)
	var flash_mat = StandardMaterial3D.new()
	flash_mat.albedo_color = Color(1.0, 0.0, 0.0, 1.0)
	flash_mat.emission_enabled = true
	flash_mat.emission = Color(1.0, 0.0, 0.0, 1.0)
	flash_mat.emission_energy_multiplier = 2.0
	mesh_node.material_override = flash_mat
	var tween2 = create_tween()
	tween2.tween_interval(0.1)
	var restore_flash = func():
		if is_instance_valid(mesh_node):
			mesh_node.material_override = original_mat
	tween2.tween_callback(restore_flash)

func _show_level_up_text(lvl: int):
	var label = Label.new()
	label.text = "LEVEL UP!\nNivel " + str(lvl)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 48)
	label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.0, 1.0))
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var root = get_tree().current_scene
	if root:
		root.add_child(label)
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 1.0, 0.2)
	tween.tween_interval(2.5)
	tween.tween_property(label, "modulate:a", 0.0, 0.3)
	tween.tween_callback(label.queue_free)
	tween.play()

func _on_leveled_up(new_level: int):
	_flash_screen_green()
	_show_level_up_text(new_level)
	if CombatEffects:
		CombatEffects.spawn_level_up_effect(global_position)
	if hud_node:
		if hud_node.has_method("update_level"):
			hud_node.update_level(new_level)
		if hud_node.has_method("update_xp") and StatsManager:
			hud_node.update_xp(StatsManager.current_xp, StatsManager.xp_to_next_level)
	if stats_panel_overlay and stats_panel_overlay.has_method("update_level") and StatsManager:
		stats_panel_overlay.update_level(StatsManager.level, StatsManager.current_xp, StatsManager.xp_to_next_level)

func _flash_screen_green():
	if flash_overlay:
		flash_overlay.queue_free()
	flash_overlay = ColorRect.new()
	flash_overlay.color = Color(0.0, 1.0, 0.0, 0.3)
	flash_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	flash_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var root = get_tree().current_scene
	if root:
		root.add_child(flash_overlay)
	var tween = create_tween()
	tween.tween_property(flash_overlay, "color:a", 0.0, 0.5)
	tween.tween_callback(flash_overlay.queue_free)
	tween.play()

func take_damage(amount: int, damage_type: String = "physical", attacker: Node = null):
	if current_state == PlayerState.DEAD:
		return
	if StatsManager:
		var actual_damage = StatsManager.apply_damage(amount, damage_type)
		player_took_damage.emit(actual_damage, damage_type, attacker)

func heal(amount: int):
	if StatsManager:
		StatsManager.heal(amount)

func die():
	if StatsManager:
		StatsManager.current_hp = 0
		StatsManager.health_changed.emit(0, StatsManager.max_hp)
		_on_player_died()
