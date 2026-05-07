extends Node

# ============================================================
# world_events.gd - World Events Autoload
# Barrio Sin Ley Online (BSLO)
# Manages random world events that occur periodically
# ============================================================

# Event intervals in seconds
const NIGHT_PATROL_INTERVAL: float = 300.0  # 5 min
const GANG_FIGHT_INTERVAL: float = 480.0    # 8 min
const LOOT_DROP_INTERVAL: float = 180.0     # 3 min
const RARE_ENEMY_INTERVAL: float = 600.0    # 10 min
const PURGE_HOUR_INTERVAL: float = 1800.0   # 30 min
const PURGE_HOUR_DURATION: float = 60.0     # 60 seconds

# Active events tracking
var active_events: Dictionary = {}
var event_timers: Dictionary = {}

# Flags
var _initialized: bool = false


func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	_initialize_timers()
	_initialized = true
	print("[WorldEvents] Sistema de eventos mundial inicializado")


func _initialize_timers():
	_create_event_timer("night_patrol", NIGHT_PATROL_INTERVAL)
	_create_event_timer("gang_fight", GANG_FIGHT_INTERVAL)
	_create_event_timer("loot_drop", LOOT_DROP_INTERVAL)
	_create_event_timer("rare_enemy", RARE_ENEMY_INTERVAL)
	_create_event_timer("purge_hour", PURGE_HOUR_INTERVAL)


func _create_event_timer(event_name: String, interval: float):
	var timer = Timer.new()
	timer.name = "Timer_" + event_name
	timer.wait_time = interval
	timer.one_shot = false
	timer.autostart = true
	timer.timeout.connect(_on_event_timer_timeout.bind(event_name))
	add_child(timer)
	event_timers[event_name] = timer
	print("[WorldEvents] Timer creado: %s (cada %.0fs)" % [event_name, interval])


func _on_event_timer_timeout(event_name: String):
	start_event(event_name)


func start_event(event_name: String):
	if active_events.has(event_name):
		print("[WorldEvents] Evento ya activo: %s" % event_name)
		return
	
	match event_name:
		"night_patrol":
			_start_night_patrol()
		"gang_fight":
			_start_gang_fight()
		"loot_drop":
			_start_loot_drop()
		"rare_enemy":
			_start_rare_enemy()
		"purge_hour":
			_start_purge_hour()
		_:
			print("[WorldEvents] Evento desconocido: %s" % event_name)
			return
	
	active_events[event_name] = true
	_announce_event(event_name)


func stop_event(event_name: String):
	if not active_events.has(event_name):
		return
	active_events.erase(event_name)
	print("[WorldEvents] EVENTO TERMINADO: %s" % _event_display_name(event_name))


func get_active_events() -> Array:
	var events: Array = []
	for ev in active_events:
		if active_events[ev]:
			events.append(ev)
	return events


func is_event_active(event_name: String) -> bool:
	return active_events.get(event_name, false)


func get_active_event_count() -> int:
	var count: int = 0
	for ev in active_events:
		if active_events[ev]:
			count += 1
	return count


func _event_display_name(event_name: String) -> String:
	match event_name:
		"night_patrol": return "PATRULLA POLICIAL NOCTURNA"
		"gang_fight": return "PELEA DE BANDAS"
		"loot_drop": return "BOTIN MISTERIOSO"
		"rare_enemy": return "ENEMIGO RARO"
		"purge_hour": return "HORA DE LA PURGA"
	return event_name


func _announce_event(event_name: String):
	var display = _event_display_name(event_name)
	match event_name:
		"night_patrol":
			print("[WorldEvents] *** ALERTA: Patrulla Policial Nocturna avistada en el barrio ***")
		"gang_fight":
			print("[WorldEvents] *** PELEA DE BANDAS detectada! Dos grupos se enfrentan en las calles ***")
		"loot_drop":
			print("[WorldEvents] *** Un botin misterioso ha aparecido en la ciudad! ***")
		"rare_enemy":
			print("[WorldEvents] *** ENEMIGO RARO: Un poderoso adversario acecha el barrio ***")
		"purge_hour":
			print("[WorldEvents] *** HORA DE LA PURGA! Todos los enemigos +50%% danio por 60s ***")


# ============================================================
# EVENT IMPLEMENTATIONS
# ============================================================

func _start_night_patrol():
	_spawn_event_enemies("policia_corrupto", 3, _get_random_city_position(), "PATROL")


func _start_gang_fight():
	var pos = _get_random_city_position()
	var pos1 = pos + Vector3(-6, 0, 0)
	var pos2 = pos + Vector3(6, 0, 0)
	_spawn_event_enemies("maton_callejero", 3, pos1, "CHASE")
	_spawn_event_enemies("sicario_narco", 3, pos2, "CHASE")
	_schedule_event_end("gang_fight", 60.0)


func _start_loot_drop():
	var pos = _get_random_city_position()
	_spawn_loot_crate(pos)


func _start_rare_enemy():
	var pos = _get_random_city_position()
	_spawn_event_enemies("maton_pesado", 1, pos, "BERSERK")
	_schedule_event_end("rare_enemy", 120.0)


func _start_purge_hour():
	_apply_purge_buff(true)
	_schedule_event_end("purge_hour", PURGE_HOUR_DURATION)


func _end_purge():
	_apply_purge_buff(false)
	print("[WorldEvents] *** La Hora de la Purga ha terminado ***")


func _apply_purge_buff(activate: bool):
	var root = get_tree().current_scene
	if not root:
		return
	var npcs = root.get_tree().get_nodes_in_group("npcs") if root else []
	var count: int = 0
	for npc in npcs:
		if not is_instance_valid(npc):
			continue
		if not npc.get("is_hostile"):
			continue
		if not npc.get("is_alive"):
			continue
		if activate:
			var current_dmg: int = npc.get("damage")
			npc.set("damage", int(float(current_dmg) * 1.5))
			count += 1
		else:
			var current_dmg: int = npc.get("damage")
			npc.set("damage", int(float(current_dmg) / 1.5))
			count += 1
	if count > 0:
		print("[WorldEvents] Purga %s a %d enemigos" % ["aplicada" if activate else "removida", count])


# ============================================================
# UTILITY METHODS
# ============================================================

func _get_random_city_position() -> Vector3:
	var x: float = randf_range(-60.0, 60.0)
	var z: float = randf_range(-80.0, 80.0)
	return Vector3(x, 0.2, z)


func _spawn_event_enemies(type_id: String, count: int, center: Vector3, behavior_override: String = ""):
	var type_data = _load_enemy_type_data(type_id)
	if type_data.is_empty():
		print("[WorldEvents] Tipo de enemigo no encontrado: %s" % type_id)
		return
	
	const NPC_SCENE = preload("res://scenes/npc/npc_base.tscn")
	var root = get_tree().current_scene
	if not root:
		return
	
	for i in range(count):
		var npc = NPC_SCENE.instantiate()
		npc.set("npc_name", type_data["display_name"] + " (Evento)")
		npc.set("faction", type_data["faction"])
		npc.set("is_hostile", true)
		npc.set("hp", type_data["hp"])
		npc.set("max_hp", type_data["hp"])
		npc.set("level", randi_range(3, 6))
		npc.set("damage", type_data["damage"])
		npc.set("chase_speed", type_data["speed"])
		npc.set("behavior", type_data["behavior"])
		
		var offset = Vector3(randf_range(-3, 3), 0, randf_range(-3, 3))
		npc.global_position = center + offset
		
		root.add_child(npc)
		
		# Apply color after one frame
		await root.get_tree().process_frame
		var body = npc.get_node_or_null("Body")
		if body and body is MeshInstance3D:
			var mat = StandardMaterial3D.new()
			mat.albedo_color = type_data["color"]
			body.material_override = mat
		
		print("[WorldEvents] Spawneado %s en evento %s" % [type_data["display_name"], behavior_override if behavior_override != "" else "default"])


func _spawn_loot_crate(position: Vector3):
	var root = get_tree().current_scene
	if not root:
		return
	
	const LOOT_SCENE = preload("res://scenes/world/loot_item.tscn")
	if not LOOT_SCENE:
		return
	
	var loot = LOOT_SCENE.instantiate()
	loot.pb_amount = randi_range(50, 200)
	loot.global_position = position + Vector3(0, 0.5, 0)
	root.add_child(loot)
	print("[WorldEvents] Caja de botin spawneada en (%.1f, %.1f, %.1f): %d PB" % [position.x, position.y, position.z, loot.pb_amount])


func _load_enemy_type_data(type_id: String) -> Dictionary:
	var script = load("res://scripts/npc/enemy_types.gd")
	if script:
		return script.get_type_by_id(type_id)
	return {}


func _schedule_event_end(event_name: String, delay: float):
	var timer = Timer.new()
	timer.name = "EndTimer_" + event_name
	timer.wait_time = delay
	timer.one_shot = true
	timer.autostart = true
	timer.timeout.connect(_on_end_timer_timeout.bind(event_name, timer))
	add_child(timer)


func _on_end_timer_timeout(event_name: String, timer: Timer):
	if event_name == "purge_hour":
		_end_purge()
	stop_event(event_name)
	timer.queue_free()
