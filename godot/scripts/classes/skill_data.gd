extends Resource

@export var skill_name: String = ""
@export var skill_id: String = ""
@export var description: String = ""
@export var icon_path: String = ""
@export var hotbar_slot: int = -1
@export var cooldown: float = 0.0
@export var stamina_cost: int = 0
@export var damage_multiplier: float = 1.0
@export var unlock_level: int = 1
@export var max_rank: int = 5
@export var tree_branch: String = ""
@export var prerequisites: Array = []
@export var is_ultimate: bool = false
@export var is_targeted: bool = true
@export var area_radius: float = 0.0
@export var duration: float = 0.0

func is_passive() -> bool:
	return hotbar_slot == -1

func is_active() -> bool:
	return hotbar_slot >= 1 and hotbar_slot <= 5
