extends Resource

@export var quest_id: String = ""
@export var quest_name: String = ""
@export var description: String = ""
@export var quest_type: String = ""  # "kill", "collect", "deliver", "talk"
@export var target_id: String = ""  # item_id to collect, or enemy type to kill
@export var target_count: int = 1
@export var reward_xp: int = 50
@export var reward_pb: int = 100
@export var reward_item_id: String = ""
@export var giver_npc: String = ""  # NPC name that gives this quest
@export var completion_dialogue: String = ""
@export var is_repeatable: bool = false
@export var required_level: int = 1
@export var target_npcs: PackedStringArray = []  # for "talk" quests with multiple NPCs in sequence
