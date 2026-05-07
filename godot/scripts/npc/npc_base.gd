extends CharacterBody3D



signal npc_died(position: Vector3, xp: int)



signal npc_interacted()



@export var npc_name: String = "NPC"



@export var faction: String = "CHOLOS"



@export var dialogue_lines: PackedStringArray = []



@export var is_hostile: bool = false



@export var hp: int = 50



@export var max_hp: int = 50



@export var level: int = 1



@export var damage: int = 8



@export var detection_range: float = 15.0



@export var interaction_range: float = 3.0

@export var is_shopkeeper: bool = false



@export var attack_range: float = 2.0



@export var attack_cooldown: float = 1.5


@export var is_quest_giver: bool = false


@export var offered_quest_id: String = ""



@export var patrol_speed: float = 1.0



@export var chase_speed: float = 3.0



# ============================================================
# BEHAVIOR SYSTEM
# ============================================================
# 0=PATROL, 1=GUARD, 2=CHASE, 3=FLEE, 4=BERSERK, 5=CALL_HELP
@export var behavior: int = 2



# Array of Vector3 waypoints for PATROL behavior
@export var patrol_path: Array = []



# ============================================================
# INSTANCE VARIABLES
# ============================================================

var is_alive: bool = true



var player_ref: Node = null



var _attack_timer: float = 0.0



var _dialogue_index: int = 0



var _patrol_target: Vector3 = Vector3.ZERO



var _patrol_forward: bool = true



var _flash_timer: float = 0.0



const FLASH_DURATION: float = 0.1



var _is_dying: bool = false



var _death_timer: float = 0.0



const DEATH_FADE_DURATION: float = 1.0



# Behavior state variables
var _patrol_wp_index: int = 0
var _patrol_wp_dir: int = 1  # 1=forward, -1=backward
var _berserk_active: bool = false
var _help_called: bool = false
var _base_damage_saved: int = 0
var _base_speed_saved: float = 0.0
var _berserk_flash_timer: float = 0.0



@onready var mesh_body: MeshInstance3D = $Body
@onready var mesh_head: MeshInstance3D = $Head



@onready var collision_shape: CollisionShape3D = $CollisionShape3D



@onready var health_bar: Node3D = $HealthBar



const FACE_SPEED: float = 5.0



const FRIENDLY_FACE_RANGE: float = 5.0



const FLOAT_TEXT_DURATION: float = 1.5



# Referencia al ShopScreen (se busca en la escena)
var _shop_screen: CanvasLayer = null



const CALL_HELP_RANGE: float = 15.0



const BERSERK_HP_THRESHOLD: float = 0.3



const FLEE_HP_THRESHOLD: float = 0.2



func _ready():



	add_to_group("npcs")
	if is_hostile:
		add_to_group("enemies")
	else:
		add_to_group("friendlies")



	# Setup faction colors on body mesh
	_apply_faction_material()



	hp = max_hp



	set_collision_layer_value(3, true)



	set_collision_mask_value(1, true)



	set_collision_mask_value(2, true)



	_patrol_target = global_position + Vector3(5, 0, 0)

	
	# Save base stats for berserk reset
	_base_damage_saved = damage
	_base_speed_saved = chase_speed


	# Setup health bar
	if health_bar and health_bar.has_method("setup"):
		health_bar.setup(npc_name, hp, max_hp)

	
	# Check for EnemyBehavior companion node
	var behav_node = get_node_or_null("EnemyBehavior")
	if behav_node:
		behavior = behav_node.get("behavior")
		patrol_path = behav_node.get("patrol_path")


	print("NPC [%s] inicializado. HP:%d Nv:%d Hostil:%s Comportamiento:%s" % [npc_name, hp, level, str(is_hostile), _get_behavior_name()])

func _apply_faction_material():
	var colors = {
		"YAKUZA": Color(0.05, 0.05, 0.15),
		"CARTEL": Color(0.30, 0.15, 0.05),
		"MAFIA": Color(0.08, 0.02, 0.02),
		"POLICIA": Color(0.05, 0.08, 0.20),
		"CHOLOS": Color(0.15, 0.02, 0.20),
		"SIN_LEGAJA": Color(0.15, 0.15, 0.10),
	}
	var mat = StandardMaterial3D.new()
	mat.albedo_color = colors.get(faction, Color(0.2, 0.2, 0.2))
	mat.roughness = 0.75
	if mesh_body:
		mesh_body.material_override = mat
	if mesh_head:
		mesh_head.material_override = mat



func _process(delta):



	if _is_dying:
		_process_death_fade(delta)
		return



	if not is_alive:
		return



	if _flash_timer > 0.0:
		_flash_timer -= delta
		if _flash_timer <= 0.0:
			_restore_materials()



	# Berserk visual pulse
	if _berserk_active:
		_berserk_flash_timer += delta
		if _berserk_flash_timer > 0.25:
			_berserk_flash_timer = 0.0
			_flash_red()



	if not player_ref or not is_instance_valid(player_ref):
		_find_player()



	_update_facing(delta)
	_check_interaction()



	if player_ref and is_hostile:
		var dist = global_position.distance_to(player_ref.global_position)
		var hp_ratio = float(hp) / float(max(max_hp, 1))

		# Determine effective behavior based on HP thresholds
		var effective_behavior = _get_effective_behavior(hp_ratio)

		match effective_behavior:
			0:  # PATROL - walk waypoints, ignore player
				_patrol_waypoints(delta)
			1:  # GUARD - stand still, face player
				_guard_behavior(delta)
			2, 4, 5:  # CHASE, BERSERK, CALL_HELP
				if dist < detection_range:
					_chase_player(delta, dist)
				else:
					_patrol_waypoints(delta)
			3:  # FLEE - run away from player
				_flee_from_player(delta, dist)
			_:
				_patrol_waypoints(delta)
	else:
		_patrol_waypoints(delta)



func _physics_process(_delta):



	if not is_alive or _is_dying:
		return



	move_and_slide()



func _find_player():



	var players = get_tree().get_nodes_in_group("players")
	if players.size() > 0:
		player_ref = players[0]



func _update_facing(delta):



	if not player_ref or not is_instance_valid(player_ref):
		return



	var dist = global_position.distance_to(player_ref.global_position)
	var should_face = false



	if is_hostile and dist < detection_range:
		should_face = true
	elif not is_hostile and dist < FRIENDLY_FACE_RANGE:
		should_face = true



	if should_face:
		var dir = player_ref.global_position - global_position
		dir.y = 0
		if dir.length() > 0.1:
			var target_angle = atan2(dir.x, dir.z)
			rotation.y = lerp_angle(rotation.y, target_angle, FACE_SPEED * delta)



func _check_interaction():



	if not is_alive or _is_dying:
		return
	if not player_ref or not is_instance_valid(player_ref):
		return
	if not Input.is_action_just_pressed("interact"):
		return
	var dist = global_position.distance_to(player_ref.global_position)
	if dist > interaction_range:
		return



	if is_shopkeeper:
		_open_shop()
		return

	if is_hostile:
		_show_floating_text(npc_name + " te mira con odio", Color.RED)
	elif is_quest_giver and offered_quest_id != "" and QuestManager:
		_interact_quest_giver()
	else:
		_speak()



# ============================================================
# BEHAVIOR METHODS
# ============================================================

func _get_effective_behavior(hp_ratio: float) -> int:
	"""Determine the effective behavior considering HP thresholds."""
	# BERSERK behavior or low HP triggers berserk
	if behavior == 4:  # BERSERK
		if not _berserk_active:
			_activate_berserk()
		return 4
	if hp_ratio <= BERSERK_HP_THRESHOLD:
		if not _berserk_active:
			_activate_berserk()
		return 4

	# CALL_HELP: alert allies when HP < 50%
	if hp_ratio <= 0.5 and not _help_called:
		_call_for_help()

	# FLEE when HP critically low (unless already berserk)
	if behavior == 3:  # FLEE
		return 3
	if hp_ratio <= FLEE_HP_THRESHOLD:
		return 3

	return behavior


func _get_behavior_name() -> String:
	match behavior:
		0: return "PATROL"
		1: return "GUARD"
		2: return "CHASE"
		3: return "FLEE"
		4: return "BERSERK"
		5: return "CALL_HELP"
	return "UNKNOWN"


func _patrol_waypoints(_delta):
	"""Walk between patrol waypoints (back-and-forth). If no waypoints, stand still."""
	if patrol_path.size() == 0:
		velocity = Vector3.ZERO
		return

	var target: Vector3 = patrol_path[_patrol_wp_index]
	target.y = global_position.y  # Keep on same Y level
	var dir_to_target = target - global_position
	dir_to_target.y = 0

	if dir_to_target.length() < 0.8:
		# Reached waypoint, advance to next
		_patrol_wp_index += _patrol_wp_dir
		if _patrol_wp_index >= patrol_path.size():
			_patrol_wp_index = patrol_path.size() - 2
			if _patrol_wp_index < 0:
				_patrol_wp_index = 0
			_patrol_wp_dir = -1
		elif _patrol_wp_index < 0:
			_patrol_wp_index = 1
			if _patrol_wp_index >= patrol_path.size():
				_patrol_wp_index = 0
			_patrol_wp_dir = 1
		velocity = Vector3.ZERO
	else:
		velocity = dir_to_target.normalized() * patrol_speed


func _guard_behavior(_delta):
	"""Stand still, facing handled by _update_facing."""
	velocity = Vector3.ZERO


func _flee_from_player(_delta, dist: float):
	"""Run AWAY from the player."""
	if not player_ref:
		velocity = Vector3.ZERO
		return
	
	var away_dir = global_position - player_ref.global_position
	away_dir.y = 0
	if away_dir.length() > 0.1:
		velocity = away_dir.normalized() * chase_speed * 1.2
	else:
		# If too close, pick a random direction
		velocity = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized() * chase_speed * 1.2


func _activate_berserk():
	"""Enter berserk mode: +50% damage, +30% speed, red flashing."""
	if _berserk_active:
		return
	_berserk_active = true
	_base_damage_saved = damage
	_base_speed_saved = chase_speed
	damage = int(float(damage) * 1.5)
	chase_speed = chase_speed * 1.3
	patrol_speed = patrol_speed * 1.3
	print("[NPC] %s entra en MODO BERSERK! Danio x1.5, Velocidad x1.3" % npc_name)


func _deactivate_berserk():
	"""Exit berserk mode and restore original stats."""
	if not _berserk_active:
		return
	_berserk_active = false
	damage = _base_damage_saved
	chase_speed = _base_speed_saved


func _call_for_help():
	"""Alert nearby hostile NPCs to join the fight."""
	if _help_called:
		return
	_help_called = true

	var all_npcs = get_tree().get_nodes_in_group("npcs")
	var called_count: int = 0
	for other in all_npcs:
		if not is_instance_valid(other):
			continue
		if other == self:
			continue
		if not other.get("is_hostile"):
			continue
		if not other.get("is_alive"):
			continue
		var dist = global_position.distance_to(other.global_position)
		if dist <= CALL_HELP_RANGE:
			if other.has_method("_alert_nearby"):
				other._alert_nearby(global_position)
			called_count += 1

	if called_count > 0:
		print("[NPC] %s pide ayuda! %d aliados alertados en rango %.1fm" % [npc_name, called_count, CALL_HELP_RANGE])


func _alert_nearby(alert_pos: Vector3):
	"""Called when a nearby ally requests help. Switch to CHASE if PATROL or GUARD."""
	if not is_hostile or not is_alive:
		return
	if behavior == 0 or behavior == 1:  # PATROL or GUARD
		var old_behavior = _get_behavior_name()
		behavior = 2  # Switch to CHASE
		# Set patrol target to alert position so they investigate
		_patrol_target = alert_pos
		print("[NPC] %s ALERTADO! Cambia de %s a CHASE" % [npc_name, old_behavior])



# ============================================================
# ORIGINAL CHASE / ATTACK
# ============================================================



func _interact_quest_giver():
	"""Handle quest giver dialogue: offer, progress check, or completion."""
	var qdata = QuestManager.get_quest_data(offered_quest_id)
	if not qdata:
		_speak()
		return

	if QuestManager.is_quest_active(offered_quest_id):
		var progress: QuestManager.QuestProgress = QuestManager.active_quests[offered_quest_id]
		if progress.is_complete():
			_show_floating_text(qdata.completion_dialogue, Color(0.3, 1.0, 0.3))
			QuestManager.complete_quest(offered_quest_id)
		else:
			_show_floating_text("Vuelve cuando hayas terminado, chaval.", Color(0.9, 0.9, 0.3))
	elif QuestManager.is_quest_complete(offered_quest_id) and not qdata.is_repeatable:
		_show_floating_text("Ya hiciste lo tuyo. Gracias.", Color(0.7, 0.7, 0.7))
	else:
		if StatsManager and StatsManager.level < qdata.required_level:
			_show_floating_text("Necesitas ser nivel %d para esta mision, chaval." % qdata.required_level, Color(1.0, 0.5, 0.3))
			return
		_show_floating_text("[MISION] " + qdata.quest_name + " - Presiona F para aceptar", Color(0.3, 1.0, 0.3))
		print("[Quest Giver %s] Ofrece mision: %s" % [npc_name, qdata.quest_name])
		_wait_for_accept(qdata)


func _wait_for_accept(qdata: Resource):
	"""Wait for player to press F again to accept the quest."""
	var timeout = 0.0
	const ACCEPT_TIMEOUT = 5.0
	while timeout < ACCEPT_TIMEOUT:
		await get_tree().process_frame
		timeout += get_process_delta_time()
		if not is_instance_valid(self) or not is_alive:
			return
		if not is_instance_valid(player_ref):
			return
		if Input.is_action_just_pressed("interact"):
			var dist = global_position.distance_to(player_ref.global_position)
			if dist <= interaction_range:
				if QuestManager.accept_quest(offered_quest_id):
					_show_floating_text("Mision aceptada: " + qdata.quest_name, Color(0.3, 1.0, 0.3))
					print("[Quest Giver %s] Mision aceptada: %s" % [npc_name, qdata.quest_name])
				return


func _chase_player(delta, dist):



	if dist < attack_range:
		_attack_timer -= delta
		if _attack_timer <= 0 and player_ref:
			if is_instance_valid(player_ref) and player_ref.has_method("take_damage"):
				player_ref.take_damage(damage)
				print("NPC [%s] golpea al jugador por %d dano!" % [npc_name, damage])
			_attack_timer = attack_cooldown
	else:
		var dir = (player_ref.global_position - global_position).normalized()
		velocity = dir * chase_speed



func take_damage(amount: int):



	if not is_alive:
		return



	hp -= amount



	print("NPC [%s] recibe %d dano! HP: %d/%d" % [npc_name, amount, hp, max_hp])



	_flash_red()
	_show_floating_text("-%d" % amount, Color.RED)

	
	# Switch PATROL/GUARD enemies to CHASE when attacked
	if is_hostile and (behavior == 0 or behavior == 1):
		var old_beh = _get_behavior_name()
		behavior = 2
		print("[NPC] %s atacado! Cambia de %s a CHASE" % [npc_name, old_beh])
	
	# Trigger call for help when hurt
	if is_hostile and behavior == 5 and not _help_called:  # CALL_HELP
		_call_for_help()


	# Update floating health bar
	if health_bar and health_bar.has_method("update_hp"):
		health_bar.update_hp(hp)



	if hp <= 0:
		_die()



func _flash_red():
	var white_mat = StandardMaterial3D.new()
	white_mat.albedo_color = Color.WHITE
	white_mat.emission_enabled = true
	white_mat.emission = Color.WHITE
	white_mat.emission_energy_multiplier = 1.5
	if mesh_body:
		mesh_body.material_override = white_mat
	if mesh_head:
		mesh_head.material_override = white_mat
	_flash_timer = FLASH_DURATION



func _restore_materials():
	_apply_faction_material()



func _die():



	if not is_alive:
		return



	is_alive = false
	hp = 0
	_is_dying = true
	_death_timer = 0.0
	_deactivate_berserk()



	# XP reward
	var xp_reward = level * 20 + 10
	print("[NPC] recompensa %d XP" % xp_reward)



	if player_ref and StatsManager:
		StatsManager.add_xp(xp_reward)

	# Notify QuestManager of enemy kill
	if QuestManager:
		QuestManager.update_progress_kill(npc_name)



	# Spawn loot on the ground
	_spawn_loot()



	if health_bar:
		health_bar.hide_bar()

	print("NPC [%s] ha muerto!" % npc_name)



	if collision_shape:
		collision_shape.disabled = true



	_spawn_death_particles()



	npc_died.emit(global_position, xp_reward)



func _process_death_fade(delta):



	_death_timer += delta
	var progress = clampf(_death_timer / DEATH_FADE_DURATION, 0.0, 1.0)
	var alpha = 1.0 - progress



	if mesh_body:
		var body_mat = mesh_body.material_override
		if not body_mat or not (body_mat is StandardMaterial3D):
			body_mat = StandardMaterial3D.new()
			body_mat.albedo_color = Color(1.0, 1.0, 1.0, 1.0)
			mesh_body.material_override = body_mat
		body_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		body_mat.albedo_color.a = alpha
	if mesh_head:
		var head_mat = mesh_head.material_override
		if not head_mat or not (head_mat is StandardMaterial3D):
			head_mat = StandardMaterial3D.new()
			head_mat.albedo_color = Color(1.0, 1.0, 1.0, 1.0)
			mesh_head.material_override = head_mat
		head_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		head_mat.albedo_color.a = alpha



	if _death_timer >= DEATH_FADE_DURATION:
		queue_free()



func _spawn_death_particles():



	var colors = [
		Color.RED,
		Color.ORANGE,
		Color.YELLOW,
		Color(0.8, 0.2, 0.8),
		Color(0.2, 0.8, 0.8)
	]



	for i in range(5):
		var square = MeshInstance3D.new()
		var box_mesh = BoxMesh.new()
		box_mesh.size = Vector3(0.2, 0.2, 0.2)
		square.mesh = box_mesh



		var mat = StandardMaterial3D.new()
		mat.albedo_color = colors[i % colors.size()]
		mat.emission_enabled = true
		mat.emission = mat.albedo_color
		mat.emission_energy_multiplier = 2.0
		square.material_override = mat



		square.position = Vector3(0.0, 1.0, 0.0)
		square.rotation = Vector3(randf() * TAU, randf() * TAU, randf() * TAU)
		add_child(square)



		var tween = create_tween()
		tween.set_parallel(true)
		var random_dir = Vector3(
			randf_range(-1.0, 1.0),
			randf_range(0.5, 2.0),
			randf_range(-1.0, 1.0)
		).normalized()
		var target_pos = random_dir * randf_range(1.5, 3.0)
		tween.tween_property(square, "position", target_pos, 0.6).set_ease(Tween.EASE_OUT)
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		tween.tween_property(mat, "albedo_color:a", 0.0, 0.5)
		tween.tween_property(square, "scale", Vector3(0.05, 0.05, 0.05), 0.6)
		tween.chain()
		tween.tween_callback(square.queue_free)



func _open_shop():
	"""Busca y abre la pantalla de tienda en la escena."""
	if not _shop_screen or not is_instance_valid(_shop_screen):
		var root = get_tree().current_scene
		if root:
			_shop_screen = root.get_node_or_null("ShopScreen")
	if _shop_screen and _shop_screen.has_method("open_shop"):
		_shop_screen.open_shop()
		print("NPC [%s]: Tienda abierta!" % npc_name)
	else:
		_show_floating_text("La tienda esta cerrada...", Color(0.9, 0.6, 0.2))
		print("NPC [%s]: No se encontro ShopScreen en la escena" % npc_name)

func _speak():



	if dialogue_lines.size() == 0:
		_show_floating_text("...", Color.WHITE)
		print("NPC [%s]: ..." % npc_name)
		npc_interacted.emit()
		if QuestManager:
			QuestManager.update_progress_talk(npc_name)
		return



	var line = dialogue_lines[_dialogue_index % dialogue_lines.size()]
	print("NPC [%s]: %s" % [npc_name, line])
	_dialogue_index += 1



	_show_floating_text(line, Color(0.9, 0.9, 0.3, 1.0))



	npc_interacted.emit()

	# Track talk quest progress
	if QuestManager:
		QuestManager.update_progress_talk(npc_name)



func _show_floating_text(text: String, color: Color):



	var label = Label3D.new()
	label.text = text
	label.font_size = 48
	label.modulate = color
	label.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
	label.outline_size = 2
	label.outline_modulate = Color.BLACK



	var root = get_tree().current_scene
	if root:
		label.global_position = global_position + Vector3(0.0, 2.2, 0.0)
		root.add_child(label)
	else:
		add_child(label)



	var tween = label.create_tween()
	tween.set_parallel(true)
	tween.tween_property(label, "position:y", label.position.y + 1.5, FLOAT_TEXT_DURATION)
	tween.tween_property(label, "modulate:a", 0.0, FLOAT_TEXT_DURATION * 0.8)
	tween.chain()
	tween.tween_callback(label.queue_free)



func is_alive_check() -> bool:



	return is_alive



func get_hp() -> int:



	return hp



func get_max_hp() -> int:



	return max_hp



func get_hp_ratio() -> float:



	return float(hp) / float(max(max_hp, 1))



func get_defense_rating() -> int:



	return 0



# ============================================================



# LOOT SYSTEM



# ============================================================



const CONSUMABLE_IDS = ["taco_callejero", "cerveza_barrio", "jarabe_abuela", "vendaje", "cocaina", "adrenalina"]



const LOOT_SCENE_PATH = "res://scenes/world/loot_item.tscn"



func _spawn_loot():



	"""Genera loot aleatorio al morir: 50% consumible, 30% PB, 20% nada."""



	var roll = randf()
	var loot_scene = load(LOOT_SCENE_PATH)
	if not loot_scene:
		push_error("NPC: No se pudo cargar loot_item.tscn")
		return



	if roll < 0.5:
		# 50%: consumible aleatorio
		var item_id = CONSUMABLE_IDS[randi() % CONSUMABLE_IDS.size()]
		var loot = loot_scene.instantiate()
		loot.item_id = item_id
		loot.quantity = randi_range(1, 2)
		loot.global_position = global_position + Vector3(randf_range(-0.5, 0.5), 1.2, randf_range(-0.5, 0.5))
		get_tree().current_scene.add_child(loot)
		print("[NPC] dejo caer: %s" % item_id)
	elif roll < 0.8:
		# 30%: PB money (10-50)
		var pb_amount = randi_range(10, 50)
		var loot = loot_scene.instantiate()
		loot.pb_amount = pb_amount
		loot.global_position = global_position + Vector3(randf_range(-0.5, 0.5), 1.2, randf_range(-0.5, 0.5))
		get_tree().current_scene.add_child(loot)
		print("[NPC] dejo caer: %d PB" % pb_amount)
