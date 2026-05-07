extends Resource
# EnemyData - Config data for enemy NPCs
# Used by EnemySpawner to instantiate enemies with specific stats

@export var enemy_name: String = "Enemy"
@export var enemy_id: String = ""
@export var faction: String = "SIN_LEGAJA"
@export var max_hp: int = 100
@export var damage: int = 10
@export var level: int = 1
@export var detection_range: float = 8.0
@export var attack_range: float = 2.5
@export var attack_cooldown: float = 1.2
@export var patrol_speed: float = 1.0
@export var chase_speed: float = 3.5
@export var xp_reward: int = 25
@export var pb_reward: int = 10
@export var loot_table: Array = []
@export var is_boss: bool = false
@export var mesh_color: Color = Color(0.8, 0.1, 0.1, 1)
@export var scale_multiplier: float = 1.0
@export var dialogue_lines: PackedStringArray = []
@export var is_hostile: bool = true

func get_leveled_stats(override_level: int = 1) -> Dictionary:
	var lvl = maxi(override_level, 1)
	return {
		"max_hp": int(max_hp * (1.0 + (lvl - 1) * 0.15)),
		"damage": int(damage * (1.0 + (lvl - 1) * 0.1)),
		"xp_reward": int(xp_reward * (1.0 + (lvl - 1) * 0.2)),
		"pb_reward": int(pb_reward * (1.0 + (lvl - 1) * 0.15))
	}