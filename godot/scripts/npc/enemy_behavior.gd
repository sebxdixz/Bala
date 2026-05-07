extends Node

# ============================================================
# enemy_behavior.gd - Enemy AI Behavior Controller
# Barrio Sin Ley Online (BSLO)
# Companion node for npc_base.gd - attach as child of NPC
# ============================================================

enum EnemyBehavior {
	PATROL = 0,
	GUARD = 1,
	CHASE = 2,
	FLEE = 3,
	BERSERK = 4,
	CALL_HELP = 5
}

@export var behavior: int = EnemyBehavior.CHASE
@export var patrol_path: Array = []  # Array of Vector3 waypoints (global positions)
@export var flee_threshold: float = 0.2  # Flee when HP below 20%
@export var call_help_range: float = 15.0  # Radius to call nearby enemies
@export var berserk_threshold: float = 0.3  # Go berserk when HP below 30%

var current_patrol_index: int = 0
var patrol_direction: int = 1  # 1=forward, -1=backward

var _berserk_active: bool = false
var _help_called: bool = false

# Base stats saved before berserk modifications
var _base_damage: int = 0
var _base_speed: float = 0.0

# Reference to parent NPC (npc_base.gd)
var npc_ref: Node = null


func _ready():
	if get_parent():
		npc_ref = get_parent()
		_base_damage = npc_ref.get("damage") if npc_ref else 0
		_base_speed = npc_ref.get("chase_speed") if npc_ref else 0.0


func get_behavior_name() -> String:
	match behavior:
		EnemyBehavior.PATROL: return "PATROL"
		EnemyBehavior.GUARD: return "GUARD"
		EnemyBehavior.CHASE: return "CHASE"
		EnemyBehavior.FLEE: return "FLEE"
		EnemyBehavior.BERSERK: return "BERSERK"
		EnemyBehavior.CALL_HELP: return "CALL_HELP"
	return "UNKNOWN"


func get_current_patrol_target() -> Vector3:
	if patrol_path.size() == 0:
		if npc_ref:
			return npc_ref.global_position
		return Vector3.ZERO
	return patrol_path[current_patrol_index]


func advance_patrol_waypoint():
	if patrol_path.size() == 0:
		return
	current_patrol_index += patrol_direction
	if current_patrol_index >= patrol_path.size():
		current_patrol_index = patrol_path.size() - 2
		patrol_direction = -1
	elif current_patrol_index < 0:
		current_patrol_index = 1
		patrol_direction = 1


func activate_berserk():
	if _berserk_active:
		return
	_berserk_active = true
	if npc_ref:
		var current_dmg: int = npc_ref.get("damage")
		var current_speed: float = npc_ref.get("chase_speed")
		_base_damage = current_dmg
		_base_speed = current_speed
		npc_ref.set("damage", int(float(current_dmg) * 1.5))
		npc_ref.set("chase_speed", current_speed * 1.3)
		var name_str: String = npc_ref.get("npc_name")
		print("[EnemyBehavior] %s entra en MODO BERSERK! Danio x1.5, Velocidad x1.3" % name_str)


func deactivate_berserk():
	if not _berserk_active:
		return
	_berserk_active = false
	if npc_ref:
		npc_ref.set("damage", _base_damage)
		npc_ref.set("chase_speed", _base_speed)


func try_call_help(hp_ratio: float):
	if _help_called:
		return
	if hp_ratio > 0.5:
		return
	_help_called = true
	if not npc_ref:
		return
	if not npc_ref.is_inside_tree():
		return
	
	var all_npcs = npc_ref.get_tree().get_nodes_in_group("npcs")
	var called_count: int = 0
	for other in all_npcs:
		if not is_instance_valid(other):
			continue
		if other == npc_ref:
			continue
		if not other.get("is_hostile"):
			continue
		if not other.get("is_alive"):
			continue
		var dist: float = npc_ref.global_position.distance_to(other.global_position)
		if dist <= call_help_range:
			if other.has_method("_alert_nearby"):
				other._alert_nearby(npc_ref.global_position)
			called_count += 1
	
	if called_count > 0:
		var name_str: String = npc_ref.get("npc_name")
		print("[EnemyBehavior] %s pide ayuda! %d aliados alertados en rango %.1fm" % [name_str, called_count, call_help_range])


func get_effective_behavior(hp_ratio: float) -> int:
	"""Returns the effective behavior considering HP thresholds."""
	if behavior == EnemyBehavior.BERSERK:
		if not _berserk_active:
			activate_berserk()
		return EnemyBehavior.BERSERK
	if hp_ratio <= berserk_threshold:
		if not _berserk_active:
			activate_berserk()
		return EnemyBehavior.BERSERK
	
	if hp_ratio <= 0.5:
		try_call_help(hp_ratio)
	
	if behavior == EnemyBehavior.FLEE:
		return EnemyBehavior.FLEE
	if hp_ratio <= flee_threshold:
		return EnemyBehavior.FLEE
	
	return behavior