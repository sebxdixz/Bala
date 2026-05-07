extends Resource

@export var class_name_str: String = ""
@export var class_id: String = ""
@export var class_tag: String = ""
@export var role: String = ""
@export var description: String = ""
@export var lore: String = ""
@export var faction_required: String = ""
@export var is_elite: bool = false
@export var required_level: int = 1
@export var required_reputation: String = ""
@export var primary_weapon: String = ""
@export var secondary_weapon: String = ""
@export var primary_stat: String = "STR"
@export var base_hp: int = 100
@export var base_stamina: int = 50
@export var hp_per_level: int = 10
@export var stamina_per_level: int = 3
@export var str_mod: float = 1.0
@export var dex_mod: float = 1.0
@export var con_mod: float = 1.0
@export var int_mod: float = 1.0
@export var wis_mod: float = 1.0
@export var cha_mod: float = 1.0
@export var icon_path: String = ""
@export var skills: Array = []
@export var hp_multiplier: float = 1.0
@export var stamina_multiplier: float = 1.0

func is_universal() -> bool:
	return faction_required == ""

func calculate_hp_at_level(level: int) -> int:
	return int((base_hp + hp_per_level * (level - 1)) * hp_multiplier)

func calculate_stamina_at_level(level: int) -> int:
	return int((base_stamina + stamina_per_level * (level - 1)) * stamina_multiplier)
