extends Item
class_name ClothingItem

## Item de ropa - afecta apariencia y stats del jugador

enum ClothingSlot {
	HEAD,      # Gorras, lentes, máscaras
	CHEST,     # Camisas, buzos, chaquetas  
	LEGS,      # Pantalones, shorts
	FEET,      # Zapatos, zapatillas
	ACCESSORY  # Relojes, cadenas, anillos
}

@export var clothing_slot: ClothingSlot = ClothingSlot.CHEST
@export var material_override: Material

func _init():
	item_type = ItemType.CLOTHING

# Crear items de ejemplo divertidos
static func create_example_items() -> Array[ClothingItem]:
	var items: Array[ClothingItem] = []
	
	# Buzo Adidas Vintage
	var adidas_hoodie = ClothingItem.new()
	adidas_hoodie.item_name = "Buzo Adidas Vintage"
	adidas_hoodie.description = "Un clásico de los 90s. Las tres rayas dan +20% de éxito en robos. Es ciencia, bro."
	adidas_hoodie.clothing_slot = ClothingSlot.CHEST
	adidas_hoodie.flow_bonus = 15
	adidas_hoodie.rarity = Rarity.UNCOMMON
	adidas_hoodie.price = 800
	adidas_hoodie.add_stat("theft_success", 20.0)
	adidas_hoodie.add_stat("street_respect", 10.0)
	items.append(adidas_hoodie)
	
	# Zapatillas Jordan Falsas
	var fake_jordans = ClothingItem.new()
	fake_jordans.item_name = "Air Jordan Retro (Falsas)"
	fake_jordans.description = "Se ven reales hasta que llueve. +15% velocidad porque corres como si te persiguieran."
	fake_jordans.clothing_slot = ClothingSlot.FEET
	fake_jordans.flow_bonus = 12
	fake_jordans.rarity = Rarity.COMMON
	fake_jordans.price = 350
	fake_jordans.add_stat("movement_speed", 15.0)
	fake_jordans.add_stat("escape_chance", 20.0)
	items.append(fake_jordans)
	
	# Cadena de Oro Chunky
	var gold_chain = ClothingItem.new()
	gold_chain.item_name = "Cadena Dorada Chunky"
	gold_chain.description = "Tan chunky que duele el cuello, pero vale la pena por el +25% de intimidación."
	gold_chain.clothing_slot = ClothingSlot.ACCESSORY
	gold_chain.flow_bonus = 20
	gold_chain.rarity = Rarity.RARE
	gold_chain.price = 1500
	gold_chain.add_stat("intimidation", 25.0)
	gold_chain.add_stat("charisma", 15.0)
	items.append(gold_chain)
	
	return items
