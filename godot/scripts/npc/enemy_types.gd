extends Resource

# ============================================================
# enemy_types.gd - Enemy Type Definitions
# Barrio Sin Ley Online (BSLO)
# Resource that defines 6 enemy archetypes with stats & behavior
# ============================================================

@export var type_id: String = ""
@export var display_name: String = ""
@export var hp: int = 50
@export var damage: int = 5
@export var speed: float = 2.0
@export var behavior: int = 2  # CHASE
@export var faction: String = "CHOLOS"
@export var xp: int = 30
@export var color: Color = Color.GRAY
@export var has_ranged: bool = false
@export var drops_better_loot: bool = false
@export var drops_extra_pb: bool = false


# Static method returning all predefined enemy type definitions
static func get_all_types() -> Array:
	return [
		{
			"type_id": "maton_callejero",
			"display_name": "Maton Callejero",
			"hp": 70,
			"damage": 8,
			"speed": 3.0,
			"behavior": 0,  # PATROL
			"faction": "CHOLOS",
			"xp": 30,
			"color": Color(0.8, 0.2, 0.2),
			"has_ranged": false,
			"drops_better_loot": false,
			"drops_extra_pb": false
		},
		{
			"type_id": "sicario_narco",
			"display_name": "Sicario Narco",
			"hp": 40,
			"damage": 15,
			"speed": 4.0,
			"behavior": 2,  # CHASE
			"faction": "CARTEL",
			"xp": 50,
			"color": Color(0.2, 0.7, 0.2),
			"has_ranged": true,
			"drops_better_loot": false,
			"drops_extra_pb": false
		},
		{
			"type_id": "guardia_yakuza",
			"display_name": "Guardia Yakuza",
			"hp": 90,
			"damage": 12,
			"speed": 2.5,
			"behavior": 1,  # GUARD
			"faction": "YAKUZA",
			"xp": 60,
			"color": Color(0.1, 0.1, 0.9),
			"has_ranged": false,
			"drops_better_loot": false,
			"drops_extra_pb": false
		},
		{
			"type_id": "maton_pesado",
			"display_name": "Maton Pesado",
			"hp": 120,
			"damage": 20,
			"speed": 1.5,
			"behavior": 4,  # BERSERK
			"faction": "CHOLOS",
			"xp": 100,
			"color": Color(0.6, 0.1, 0.6),
			"has_ranged": false,
			"drops_better_loot": false,
			"drops_extra_pb": false
		},
		{
			"type_id": "policia_corrupto",
			"display_name": "Policia Corrupto",
			"hp": 80,
			"damage": 10,
			"speed": 3.0,
			"behavior": 5,  # CALL_HELP
			"faction": "POLICIA",
			"xp": 70,
			"color": Color(0.1, 0.2, 0.8),
			"has_ranged": false,
			"drops_better_loot": true,
			"drops_extra_pb": false
		},
		{
			"type_id": "ladron_huido",
			"display_name": "Ladron Huido",
			"hp": 30,
			"damage": 5,
			"speed": 5.0,
			"behavior": 3,  # FLEE
			"faction": "SIN_LEGAJA",
			"xp": 40,
			"color": Color(0.5, 0.5, 0.2),
			"has_ranged": false,
			"drops_better_loot": false,
			"drops_extra_pb": true
		}
	]


static func get_type_by_id(type_id: String) -> Dictionary:
	for t in get_all_types():
		if t["type_id"] == type_id:
			return t
	return {}


static func get_behavior_name(behavior_id: int) -> String:
	match behavior_id:
		0: return "PATROL"
		1: return "GUARD"
		2: return "CHASE"
		3: return "FLEE"
		4: return "BERSERK"
		5: return "CALL_HELP"
	return "UNKNOWN"