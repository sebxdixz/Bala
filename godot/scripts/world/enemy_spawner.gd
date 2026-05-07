extends Node

const NPC_SCENE = "res://scenes/npc/npc_base.tscn"

var _spawned_enemies: Array = []
var _spawned_friendlies: Array = []
var _spawn_points: Array = []
var _npc_scene: PackedScene = null
var _vendor_spawn_point = null
var _guide_spawn_point = null
var _patrol_paths: Dictionary = {}
var _spawn_registry: Dictionary = {}
var _pending_respawns: Dictionary = {}
const RESPAWN_DELAY = 30.0

func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	await get_tree().process_frame
	_npc_scene = load(NPC_SCENE)
	if not _npc_scene:
		print("EnemySpawner: No se pudo cargar npc_base.tscn")
		return
	_scan_spawn_points()
	_scan_patrol_waypoints()
	_spawn_initial_enemies()
	_spawn_friendly_npcs()
	print("EnemySpawner: %d enemigos, %d amistosos" % [_spawned_enemies.size(), _spawned_friendlies.size()])

func _process(delta):
	if _pending_respawns.size() == 0:
		return
	var to_remove: Array = []
	for spawn_name in _pending_respawns:
		var data = _pending_respawns[spawn_name]
		data["timer"] -= delta
		if data["timer"] <= 0.0:
			_respawn_enemy(spawn_name, data["config"], data["marker"])
			to_remove.append(spawn_name)
	for name in to_remove:
		_pending_respawns.erase(name)

func _scan_spawn_points():
	_spawn_points.clear()
	var root = get_tree().current_scene
	if not root:
		return
	var all_markers = root.find_children("*", "Marker3D", true, false)
	for marker in all_markers:
		if marker.name.begins_with("EnemySpawn"):
			_spawn_points.append(marker)
		elif marker.name == "VendorSpawn":
			_vendor_spawn_point = marker
		elif marker.name == "GuideSpawn":
			_guide_spawn_point = marker
	print("EnemySpawner: %d spawns, Vendor=%s Guide=%s" % [_spawn_points.size(), str(_vendor_spawn_point != null), str(_guide_spawn_point != null)])

func _scan_patrol_waypoints():
	var root = get_tree().current_scene
	if not root:
		return
	var all_markers = root.find_children("*", "Marker3D", true, false)
	for marker in all_markers:
		if marker.name.begins_with("PatrolWP_"):
			var parts = marker.name.trim_prefix("PatrolWP_").split("_")
			if parts.size() >= 2:
				var zone = parts[0]
				if not _patrol_paths.has(zone):
					_patrol_paths[zone] = []
				_patrol_paths[zone].append(marker.global_position)
	for zone in _patrol_paths:
		print("EnemySpawner: %s tiene %d waypoints" % [zone, _patrol_paths[zone].size()])

func _spawn_initial_enemies():
	var types_ref = load("res://scripts/npc/enemy_types.gd")
	var all_types = types_ref.get_all_types()
	for i in range(_spawn_points.size()):
		var point = _spawn_points[i]
		var type_data = all_types[i % all_types.size()]
		var zone = _determine_zone(point.name)
		_spawn_typed_enemy(point, type_data, zone)

func _determine_zone(spawn_name: String) -> String:
	if spawn_name.contains("Plaza"):
		return "Plaza"
	elif spawn_name.contains("Shop") or spawn_name.contains("Comm"):
		return "Comm"
	elif spawn_name.contains("Alley"):
		return "Alley"
	return "Plaza"

func _spawn_typed_enemy(point: Marker3D, type_data: Dictionary, zone: String):
	if not _npc_scene:
		return
	var npc = _npc_scene.instantiate()
	npc.set("npc_name", type_data["display_name"])
	npc.set("faction", type_data["faction"])
	npc.set("is_hostile", true)
	npc.set("hp", type_data["hp"])
	npc.set("max_hp", type_data["hp"])
	npc.set("level", type_data.get("level", 1))
	npc.set("damage", type_data["damage"])
	npc.set("chase_speed", type_data["speed"])
	npc.set("patrol_speed", type_data["speed"] * 0.5)
	npc.set("behavior", type_data["behavior"])
	if type_data["behavior"] == 0 and _patrol_paths.has(zone):
		npc.set("patrol_path", _patrol_paths[zone])
	if not npc.npc_died.is_connected(_on_enemy_died):
		npc.npc_died.connect(_on_enemy_died)
	get_tree().current_scene.add_child(npc)
	npc.global_position = point.global_position
	_spawned_enemies.append(npc)
	_spawn_registry[npc.get_instance_id()] = {"point": point, "type": type_data, "zone": zone}

func _spawn_friendly_npcs():
	if _vendor_spawn_point:
		var vendor = _npc_scene.instantiate()
		vendor.set("npc_name", "El Ferretero")
		vendor.set("faction", "SIN_LEGAJA")
		vendor.set("is_hostile", false)
		vendor.set("hp", 80)
		vendor.set("max_hp", 80)
		vendor.set("level", 3)
		vendor.set("is_quest_giver", true)
		vendor.set("offered_quest_id", "recoleccion")
		vendor.set("is_shopkeeper", true)
		vendor.set("dialogue_lines", ["Bienvenido al barrio, forastero.", "Tengo las mejores herramientas.", "Si necesitas armas, habla conmigo."])
		get_tree().current_scene.add_child(vendor)
		vendor.global_position = _vendor_spawn_point.global_position
		_spawned_friendlies.append(vendor)

	if _guide_spawn_point:
		var guide = _npc_scene.instantiate()
		guide.set("npc_name", "El Viejo del Barrio")
		guide.set("faction", "CHOLOS")
		guide.set("is_hostile", false)
		guide.set("hp", 60)
		guide.set("max_hp", 60)
		guide.set("level", 5)
		guide.set("is_quest_giver", true)
		guide.set("offered_quest_id", "limpia_barrio")
		guide.set("dialogue_lines", ["Escuchame bien, chaval.", "Los cholos controlan la periferia.", "Si ves a Firulais, dale un taco."])
		get_tree().current_scene.add_child(guide)
		guide.global_position = _guide_spawn_point.global_position
		_spawned_friendlies.append(guide)

func _on_enemy_died(_pos: Vector3, _xp: int):
	for enemy in _spawned_enemies:
		if not is_instance_valid(enemy):
			var eid = enemy.get_instance_id() if enemy else 0
			if _spawn_registry.has(eid):
				var reg = _spawn_registry[eid]
				var spawn_name = reg["point"].name
				_pending_respawns[spawn_name] = {"config": reg["type"], "timer": RESPAWN_DELAY, "marker": reg["point"]}
				_spawn_registry.erase(eid)
				break

func _respawn_enemy(spawn_name: String, config: Dictionary, marker: Marker3D):
	var zone = _determine_zone(spawn_name)
	_spawn_typed_enemy(marker, config, zone)
	print("EnemySpawner: %s respawneado en %s" % [config["display_name"], spawn_name])

func get_enemy_count() -> int:
	var count = 0
	for enemy in _spawned_enemies:
		if is_instance_valid(enemy):
			count += 1
	return count

func get_friendly_count() -> int:
	var count = 0
	for friendly in _spawned_friendlies:
		if is_instance_valid(friendly):
			count += 1
	return count

func clear_enemies():
	for enemy in _spawned_enemies:
		if is_instance_valid(enemy):
			enemy.queue_free()
	_spawned_enemies.clear()
	_spawn_registry.clear()
	_pending_respawns.clear()
	for friendly in _spawned_friendlies:
		if is_instance_valid(friendly):
			friendly.queue_free()
	_spawned_friendlies.clear()
