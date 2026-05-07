extends Resource



@export var item_name: String = "Item"

@export var description: String = "Descripcion del item"

@export var item_type: int = 0

@export var rarity: int = 0

@export var grid_width: int = 1

@export var grid_height: int = 1

@export var weight: float = 1.0

@export var base_value: int = 10

@export var damage: int = 0

@export var defense: int = 0

@export var heal_amount: int = 0

@export var stamina_restore: int = 0

@export var required_level: int = 1

@export var range: float = 0.0

@export var max_durability: int = 100

@export var current_durability: int = 100

@export var stackable: bool = false

@export var max_stack: int = 99

@export var buff_duration: float = 0.0

@export var buff_stat: String = ""

@export var buff_amount: int = 0

@export var tags: Array = []

@export var ammo_count: int = 0

@export var is_illegal: bool = false



enum ItemType { WEAPON = 0, ARMOR = 1, CONSUMABLE = 2, MATERIAL = 3, QUEST = 4, AMMO = 5 }

enum Rarity { TRASH = 0, COMMON = 1, UNCOMMON = 2, RARE = 3, EPIC = 4, LEGENDARY = 5, CURSED = 6 }



func is_consumable() -> bool:

	return item_type == ItemType.CONSUMABLE



func get_rarity_color() -> Color:

	match rarity:

		Rarity.TRASH: return Color(0.5, 0.5, 0.5)

		Rarity.COMMON: return Color(1, 1, 1)

		Rarity.UNCOMMON: return Color(0.18, 0.8, 0.25)

		Rarity.RARE: return Color(0.0, 0.45, 0.85)

		Rarity.EPIC: return Color(1.0, 0.0, 0.667)

		Rarity.LEGENDARY: return Color(1.0, 0.84, 0.0)

		Rarity.CURSED: return Color(0.55, 0.0, 0.0)

	return Color.WHITE
