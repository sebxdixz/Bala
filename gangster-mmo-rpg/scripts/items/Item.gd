extends Resource
class_name Item

## Clase base para todos los items del juego
## Define propiedades comunes y comportamiento base

enum ItemType {
	WEAPON,
	CLOTHING, 
	ACCESSORY,
	CONSUMABLE
}

enum Rarity {
	COMMON,    # Blanco - Items básicos
	UNCOMMON,  # Verde - Items decentes  
	RARE,      # Azul - Items buenos
	EPIC,      # Morado - Items geniales
	LEGENDARY  # Dorado - Items únicos y divertidos
}

@export var item_name: String = ""
@export var description: String = ""
@export var item_type: ItemType = ItemType.CLOTHING
@export var rarity: Rarity = Rarity.COMMON
@export var icon: Texture2D
@export var mesh: Mesh
@export var flow_bonus: int = 0
@export var price: int = 100

# Stats que pueden tener los items
@export var stats: Dictionary = {}

func get_stat(stat_name: String) -> float:
	return stats.get(stat_name, 0.0)

func has_stat(stat_name: String) -> bool:
	return stat_name in stats

func add_stat(stat_name: String, value: float):
	stats[stat_name] = value

func get_rarity_color() -> Color:
	match rarity:
		Rarity.COMMON:
			return Color.WHITE
		Rarity.UNCOMMON:
			return Color.GREEN
		Rarity.RARE:
			return Color.CYAN
		Rarity.EPIC:
			return Color.MAGENTA
		Rarity.LEGENDARY:
			return Color.GOLD
		_:
			return Color.WHITE

func get_flow_description() -> String:
	if flow_bonus > 0:
		return "+%d Flow ✨" % flow_bonus
	return ""

func get_full_description() -> String:
	var full_desc = description
	
	# Agregar stats
	if stats.size() > 0:
		full_desc += "\n\nEffects:"
		for stat in stats:
			var value = stats[stat]
			var sign = "+" if value > 0 else ""
			full_desc += "\n• %s: %s%.1f%%" % [stat.replace("_", " ").capitalize(), sign, value]
	
	# Agregar flow bonus
	if flow_bonus > 0:
		full_desc += "\n\n" + get_flow_description()
	
	return full_desc

func on_equipped(player: Player):
	print("📦 %s equipped!" % item_name)

func on_unequipped(player: Player):
	print("📦 %s unequipped!" % item_name)
