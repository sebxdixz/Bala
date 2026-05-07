# ============================================================
# item_database.gd — ItemDatabase (Autoload Singleton)
# Barrio Sin Ley Online (BSLO)
# Base de datos central de todos los items del juego.
# Registrado como autoload "ItemDatabase".
# ============================================================
extends Node

const ItemDataRef = preload("res://scripts/items/item_data.gd")

# Categorias de items
enum Category {
	WEAPONS,
	AMMO,
	CONSUMABLES,
	MATERIALS,
	QUEST_ITEMS,
	JUNK,
	ARMOR,
	BLUEPRINTS
}

# Diccionario maestro: item_id (String) -> ItemData
var _items: Dictionary = {}


func _ready():
	"""Inicializa la base de datos con todos los items del juego."""
	process_mode = PROCESS_MODE_ALWAYS
	_build_database()


# ============================================================
# CONSTRUCCION DE LA BASE DE DATOS (42 items)
# ============================================================

func _build_database():
	"""Construye todos los items base del juego.

	Cada entry es un ItemData con stats balanceados segun:
	- 05_Clases.md  (niveles de rareza, requisitos)
	- 11_Economia.md (valores base, economia del barrio)
	"""

	# ============================================================
	# ARMAS (WEAPONS)
	# ============================================================

	_items["pistol_9mm"] = _create_item({
		"name": "Pistola 9mm",
		"desc": "Pistola estandar del barrio. Fiable, precisa, barata de mantener.",
		"type": 0,
		"rarity": 0,
		"width": 1,
		"height": 2,
		"weight": 1.2,
		"value": 500,
		"damage": 15,
		"req_level": 1,
		"range": 30.0,
		"tags": ["firearm", "pistol", "light"]
	})

	_items["navaja"] = _create_item({
		"name": "Navaja",
		"desc": "Hoja afilada plegable. Ideal para peleas callejeras discretas.",
		"type": 0,
		"rarity": 0,
		"width": 1,
		"height": 2,
		"weight": 0.3,
		"value": 300,
		"damage": 8,
		"req_level": 1,
		"range": 2.0,
		"tags": ["melee", "blade", "light"]
	})

	_items["bate_beisbol"] = _create_item({
		"name": "Bate de Beisbol",
		"desc": "Madera maciza con alambre de puas improvisado. Aturde al enemigo.",
		"type": 0,
		"rarity": 1,
		"width": 1,
		"height": 3,
		"weight": 2.5,
		"value": 600,
		"damage": 12,
		"req_level": 2,
		"range": 2.5,
		"tags": ["melee", "blunt", "stun", "heavy"]
	})

	_items["machete"] = _create_item({
		"name": "Machete",
		"desc": "Hoja larga para cortar cana... o lo que se ponga por delante.",
		"type": 0,
		"rarity": 1,
		"width": 1,
		"height": 3,
		"weight": 1.8,
		"value": 1200,
		"damage": 18,
		"req_level": 3,
		"range": 2.2,
		"tags": ["melee", "blade", "bleed"]
	})

	_items["pistola_45"] = _create_item({
		"name": "Pistola .45",
		"desc": "Mayor calibre, mayor poder de parada. Mas cara de mantener.",
		"type": 0,
		"rarity": 2,
		"width": 1,
		"height": 2,
		"weight": 1.5,
		"value": 1500,
		"damage": 20,
		"req_level": 4,
		"range": 28.0,
		"tags": ["firearm", "pistol", "heavy"]
	})

	_items["subfusil_uzi"] = _create_item({
		"name": "Subfusil UZI",
		"desc": "Rafagas cortas, perfecto para drive-by y combate urbano.",
		"type": 0,
		"rarity": 1,
		"width": 2,
		"height": 3,
		"weight": 3.5,
		"value": 2000,
		"damage": 15,
		"req_level": 5,
		"range": 25.0,
		"tags": ["firearm", "smg", "auto", "medium"]
	})

	_items["escopeta_recortada"] = _create_item({
		"name": "Escopeta Recortada",
		"desc": "Canones cortados. Devastadora a corta distancia, dispersion bestial.",
		"type": 0,
		"rarity": 2,
		"width": 2,
		"height": 4,
		"weight": 3.0,
		"value": 2500,
		"damage": 25,
		"req_level": 6,
		"range": 12.0,
		"tags": ["firearm", "shotgun", "heavy", "spread"]
	})

	_items["ak47_dorada"] = _create_item({
		"name": "AK-47 Dorada",
		"desc": "Fusil de asalto banado en oro. Simbolo de poder en el barrio. Legendaria.",
		"type": 0,
		"rarity": 4,
		"width": 2,
		"height": 5,
		"weight": 5.0,
		"value": 5000,
		"damage": 35,
		"req_level": 10,
		"range": 35.0,
		"tags": ["firearm", "rifle", "auto", "legendary", "gold"]
	})

	_items["puno_americano"] = _create_item({
		"name": "Puno Americano",
		"desc": "Laton macizo. Golpes rapidos y sangrientos.",
		"type": 0,
		"rarity": 0,
		"width": 1,
		"height": 1,
		"weight": 0.4,
		"value": 200,
		"damage": 6,
		"req_level": 1,
		"range": 1.5,
		"tags": ["melee", "blunt", "fast"]
	})

	# ============================================================
	# MUNICION (AMMO)
	# ============================================================

	_items["ammo_9mm"] = _create_item({
		"name": "Municion 9mm",
		"desc": "Caja de 50 balas parabellum 9mm.",
		"type": 6,
		"rarity": 0,
		"weight": 0.5,
		"value": 50,
		"stackable": true,
		"max_stack": 200,
		"tags": ["ammo", "pistol"]
	})

	_items["ammo_45"] = _create_item({
		"name": "Municion .45",
		"desc": "Caja de 30 balas .45 ACP.",
		"type": 6,
		"rarity": 1,
		"weight": 0.7,
		"value": 80,
		"stackable": true,
		"max_stack": 150,
		"tags": ["ammo", "pistol"]
	})

	_items["ammo_escopeta"] = _create_item({
		"name": "Cartuchos de Escopeta",
		"desc": "8 cartuchos calibre 12.",
		"type": 6,
		"rarity": 0,
		"weight": 1.2,
		"value": 60,
		"stackable": true,
		"max_stack": 50,
		"tags": ["ammo", "shotgun"]
	})

	_items["ammo_rifle"] = _create_item({
		"name": "Municion 7.62mm",
		"desc": "Caja de 30 balas de fusil.",
		"type": 6,
		"rarity": 1,
		"weight": 1.0,
		"value": 100,
		"stackable": true,
		"max_stack": 150,
		"tags": ["ammo", "rifle"]
	})

	_items["ammo_357"] = _create_item({
		"name": "Municion .357",
		"desc": "Caja de 20 balas de revolver.",
		"type": 6,
		"rarity": 1,
		"weight": 0.6,
		"value": 70,
		"stackable": true,
		"max_stack": 100,
		"tags": ["ammo", "revolver"]
	})

	# ============================================================
	# CONSUMIBLES (CONSUMABLES)
	# ============================================================

	_items["taco_callejero"] = _create_item({
		"name": "Taco Callejero",
		"desc": "Taco de carnitas con salsa verde. Cura 20% HP. La abuelita lo aprueba.",
		"type": 2,
		"rarity": 0,
		"width": 1,
		"height": 1,
		"weight": 0.2,
		"value": 200,
		"heal_percent": 0.20,
		"stackable": true,
		"max_stack": 10,
		"tags": ["food", "heal"]
	})

	_items["jarabe_abuela"] = _create_item({
		"name": "Jarabe de la Abuela",
		"desc": "Remedio casero milagroso. Cura 50% HP y elimina veneno. Sabe horrible.",
		"type": 2,
		"rarity": 1,
		"width": 1,
		"height": 2,
		"weight": 0.5,
		"value": 500,
		"heal_percent": 0.50,
		"cures_poison": true,
		"stackable": true,
		"max_stack": 5,
		"tags": ["medicine", "heal", "cure"]
	})

	_items["cerveza_barrio"] = _create_item({
		"name": "Cerveza del Barrio",
		"desc": "Caguama bien fria. +20% dano cuerpo a cuerpo, -30% precision. 2 minutos.",
		"type": 2,
		"rarity": 0,
		"width": 1,
		"height": 1,
		"weight": 0.6,
		"value": 150,
		"buffs": {"stat": "STR", "amount": 2, "duration": 120.0},
		"stackable": true,
		"max_stack": 8,
		"tags": ["drink", "buff", "alcohol", "melee"]
	})

	_items["cocaina"] = _create_item({
		"name": "Cocaina",
		"desc": "Polvo blanco de dudosa procedencia. +30% velocidad, +20% dano. 3 minutos. ILEGAL.",
		"type": 2,
		"rarity": 2,
		"width": 1,
		"height": 1,
		"weight": 0.05,
		"value": 1000,
		"buffs": {"stat": "DEX", "amount": 3, "duration": 180.0},
		"illegal": true,
		"stackable": true,
		"max_stack": 5,
		"tags": ["drug", "illegal", "buff", "speed"]
	})

	_items["adrenalina"] = _create_item({
		"name": "Adrenalina",
		"desc": "Inyeccion de emergencia. Auto-revive al morir durante 30 segundos. Uso unico.",
		"type": 2,
		"rarity": 3,
		"width": 1,
		"height": 1,
		"weight": 0.1,
		"value": 2000,
		"buff_duration": 30.0,
		"auto_revive": true,
		"stackable": false,
		"max_stack": 1,
		"tags": ["medicine", "revive", "epic", "emergency"]
	})

	_items["vendaje"] = _create_item({
		"name": "Vendaje",
		"desc": "Gasa esterilizada. Cura 15 HP. Siempre lleva unos encima.",
		"type": 2,
		"rarity": 0,
		"width": 1,
		"height": 1,
		"weight": 0.1,
		"value": 50,
		"heal": 15,
		"stackable": true,
		"max_stack": 20,
		"tags": ["medicine", "heal", "bandage"]
	})

	_items["botiquin"] = _create_item({
		"name": "Botiquin",
		"desc": "Kit medico completo. Cura 50 HP. Imprescindible en tiroteos.",
		"type": 2,
		"rarity": 1,
		"width": 1,
		"height": 2,
		"weight": 1.0,
		"value": 300,
		"heal": 50,
		"stackable": true,
		"max_stack": 5,
		"tags": ["medicine", "heal", "firstaid"]
	})

	_items["tequila_barato"] = _create_item({
		"name": "Tequila Barato",
		"desc": "Del que venden en la esquina. +10% dano, -10% precision. 2 minutos. Arde al entrar.",
		"type": 2,
		"rarity": 0,
		"width": 1,
		"height": 1,
		"weight": 0.5,
		"value": 100,
		"buffs": {"stat": "STR", "amount": 1, "duration": 120.0},
		"stackable": true,
		"max_stack": 8,
		"tags": ["drink", "buff", "alcohol"]
	})

	_items["esteroides"] = _create_item({
		"name": "Esteroides",
		"desc": "Frasco de anabolicos. +30 STR durante 1 minuto. Efectos secundarios no incluidos.",
		"type": 2,
		"rarity": 2,
		"width": 1,
		"height": 1,
		"weight": 0.2,
		"value": 800,
		"buffs": {"stat": "STR", "amount": 3, "duration": 60.0},
		"illegal": true,
		"stackable": true,
		"max_stack": 3,
		"tags": ["drug", "buff", "strength", "illegal"]
	})

	_items["agua_mineral"] = _create_item({
		"name": "Agua Mineral",
		"desc": "Botella de agua purificada. Cura 10 HP y reduce intoxicacion. Hidratacion esencial.",
		"type": 2,
		"rarity": 0,
		"width": 1,
		"height": 1,
		"weight": 0.4,
		"value": 30,
		"heal": 10,
		"stamina_restore": 5,
		"stackable": true,
		"max_stack": 10,
		"tags": ["drink", "heal", "water"]
	})

	_items["cigarros_sueltos"] = _create_item({
		"name": "Cigarros Sueltos",
		"desc": "Un par de cigarros. Calma los nervios. +10 stamina en 5 segundos.",
		"type": 2,
		"rarity": 0,
		"width": 1,
		"height": 1,
		"weight": 0.05,
		"value": 25,
		"stamina_restore": 10,
		"stackable": true,
		"max_stack": 20,
		"tags": ["misc", "stamina", "smoke"]
	})

	# ============================================================
	# MATERIALES (MATERIALS)
	# ============================================================

	_items["chatarra_metal"] = _create_item({
		"name": "Chatarra de Metal",
		"desc": "Pedazos de metal reciclado. Sirve para crafteo basico.",
		"type": 4,
		"rarity": 0,
		"weight": 1.0,
		"value": 20,
		"stackable": true,
		"max_stack": 99,
		"tags": ["material", "metal", "scrap"]
	})

	_items["polvora"] = _create_item({
		"name": "Polvora",
		"desc": "Polvora negra de contrabando. Para recargar municion o fabricar explosivos.",
		"type": 4,
		"rarity": 1,
		"weight": 0.3,
		"value": 40,
		"stackable": true,
		"max_stack": 50,
		"tags": ["material", "gunpowder", "crafting"]
	})

	_items["cinta_adhesiva"] = _create_item({
		"name": "Cinta Adhesiva",
		"desc": "Cinta gris multiusos. El duct tape arregla todo.",
		"type": 4,
		"rarity": 0,
		"weight": 0.2,
		"value": 15,
		"stackable": true,
		"max_stack": 99,
		"tags": ["material", "tape", "crafting"]
	})

	_items["componentes_electronicos"] = _create_item({
		"name": "Componentes Electronicos",
		"desc": "Chips, cables y placas. Utiles para dispositivos y mejoras.",
		"type": 4,
		"rarity": 1,
		"weight": 0.3,
		"value": 60,
		"stackable": true,
		"max_stack": 50,
		"tags": ["material", "electronics", "tech"]
	})

	_items["tela"] = _create_item({
		"name": "Tela",
		"desc": "Retazos de tela resistente. Para vendajes, ropa y manualidades.",
		"type": 4,
		"rarity": 0,
		"weight": 0.3,
		"value": 10,
		"stackable": true,
		"max_stack": 99,
		"tags": ["material", "cloth", "crafting"]
	})

	_items["alcohol_puro"] = _create_item({
		"name": "Alcohol Puro",
		"desc": "Etanol de alta graduacion. Desinfecta heridas o fabrica cocteles molotov.",
		"type": 4,
		"rarity": 1,
		"weight": 0.5,
		"value": 35,
		"stackable": true,
		"max_stack": 30,
		"tags": ["material", "alcohol", "crafting", "medicine"]
	})

	_items["vidrio_roto"] = _create_item({
		"name": "Vidrio Roto",
		"desc": "Fragmentos de vidrio. Afilados y peligrosos. Arma improvisada o trampa.",
		"type": 4,
		"rarity": 0,
		"weight": 0.4,
		"value": 5,
		"stackable": true,
		"max_stack": 99,
		"tags": ["material", "glass", "sharp"]
	})

	# ============================================================
	# OBJETOS DE MISION (QUEST ITEMS)
	# ============================================================

	_items["documentos_falsos"] = _create_item({
		"name": "Documentos Falsos",
		"desc": "Pasaportes y licencias falsificadas. Alguien los necesita para escapar del pais.",
		"type": 3,
		"rarity": 2,
		"width": 2,
		"height": 3,
		"weight": 0.2,
		"value": 0,
		"tags": ["quest", "document", "story"]
	})

	_items["telefono_celular"] = _create_item({
		"name": "Telefono Celular",
		"desc": "Smartphone con mensajes cifrados. Contiene informacion comprometedora.",
		"type": 3,
		"rarity": 1,
		"width": 2,
		"height": 2,
		"weight": 0.2,
		"value": 0,
		"tags": ["quest", "tech", "story"]
	})

	_items["llave_bodega"] = _create_item({
		"name": "Llave de Bodega",
		"desc": "Llave oxidada con el numero 7 grabado. Abre una bodega en el muelle.",
		"type": 3,
		"rarity": 0,
		"width": 1,
		"height": 1,
		"weight": 0.1,
		"value": 0,
		"tags": ["quest", "key", "story"]
	})

	_items["alijo_dinero"] = _create_item({
		"name": "Alijo de Dinero",
		"desc": "Fajo de billetes de alta denominacion. $5000 en efectivo del Cartel.",
		"type": 3,
		"rarity": 3,
		"width": 1,
		"height": 2,
		"weight": 0.3,
		"value": 5000,
		"tags": ["quest", "money", "story", "valuable"]
	})

	_items["muestra_droga"] = _create_item({
		"name": "Muestra de Droga",
		"desc": "Bolsa con una sustancia desconocida. El laboratorio quiere analizarla.",
		"type": 3,
		"rarity": 1,
		"width": 1,
		"height": 1,
		"weight": 0.1,
		"value": 0,
		"tags": ["quest", "drug", "story"]
	})

	# ============================================================
	# CHATARRA / BASURA (JUNK) — para vender
	# ============================================================

	_items["cartera_vacia"] = _create_item({
		"name": "Cartera Vacia",
		"desc": "Cartera de cuero sintetico. Le sacaron todo menos la foto de la familia.",
		"type": 5,
		"rarity": 0,
		"weight": 0.1,
		"value": 5,
		"tags": ["junk", "trash"]
	})

	_items["reloj_roto"] = _create_item({
		"name": "Reloj Roto",
		"desc": "Reloj de pulsera que ya no funciona. Quizas alguien lo compre por las piezas.",
		"type": 5,
		"rarity": 0,
		"weight": 0.1,
		"value": 30,
		"tags": ["junk", "trash"]
	})

	_items["cadena_oro_falsa"] = _create_item({
		"name": "Cadena de Oro Falsa",
		"desc": "Brilla como oro pero es pura hojalata. Bueno para aparentar.",
		"type": 5,
		"rarity": 1,
		"weight": 0.15,
		"value": 50,
		"tags": ["junk", "jewelry", "fake"]
	})

	_items["zapatos_viejos"] = _create_item({
		"name": "Zapatos Viejos",
		"desc": "Par de tenis desgastados. Aguantaron mil batallas en el barrio.",
		"type": 5,
		"rarity": 0,
		"weight": 1.0,
		"value": 8,
		"tags": ["junk", "trash"]
	})

	_items["periodico_atrasado"] = _create_item({
		"name": "Periodico Atrasado",
		"desc": "Diario de hace una semana. Envuelve pescado o leelo en el bano.",
		"type": 5,
		"rarity": 0,
		"weight": 0.1,
		"value": 2,
		"tags": ["junk", "paper"]
	})

	print("ItemDatabase: %d items cargados en la base de datos." % _items.size())


# ============================================================
# FACTORY METHOD — Crea un ItemData desde un diccionario
# ============================================================

func _create_item(data: Dictionary) -> Resource:
	"""Crea un ItemData a partir de un diccionario de propiedades.

	Parametros:
		data: Diccionario con las propiedades del item.
				Claves soportadas:
				"name", "desc",
				"type" (ItemData.ItemType), "rarity" (ItemData.Rarity),
				"width", "height",
				"weight", "value",
				"damage", "defense", "req_level", "range",
				"durability", "max_durability",
				"stackable", "max_stack",
				"heal", "heal_percent", "stamina_restore",
				"buffs", "buff_duration",
				"cures_poison", "auto_revive", "illegal",
				"ammo", "tags"
	Returns:
		ItemData: Nueva instancia con los datos configurados
	"""
	var item = ItemDataRef.new()

	# Basic identification
	item.item_name = data.get("name", "Unknown")
	item.description = data.get("desc", "")
	item.item_type = data.get("type", 5)
	item.rarity = data.get("rarity", 0)

	# Grid dimensions
	item.grid_width = data.get("width", 1)
	item.grid_height = data.get("height", 1)

	# Weight and value
	item.weight = data.get("weight", 0.0)
	item.base_value = data.get("value", 0)

	# Combat stats
	item.damage = data.get("damage", 0)
	item.defense = data.get("defense", 0)
	item.required_level = data.get("req_level", 1)
	item.range = data.get("range", 0.0)

	# Durability
	item.max_durability = data.get("max_durability", 100)
	item.current_durability = data.get("durability", item.max_durability)

	# Stacking
	item.stackable = data.get("stackable", false)
	item.max_stack = data.get("max_stack", 1)

	# Healing (consumables)
	var heal_percent: float = data.get("heal_percent", 0.0)
	var heal_amount: int = data.get("heal", 0)
	if heal_percent > 0.0:
		if StatsManager:
			item.heal_amount = int(StatsManager.max_hp * heal_percent)
		else:
			item.heal_amount = 0
	else:
		item.heal_amount = heal_amount

	item.stamina_restore = data.get("stamina_restore", 0)

	# Buff effects
	if data.has("buffs"):
		var buffs: Dictionary = data["buffs"]
		item.buff_stat = buffs.get("stat", "")
		item.buff_amount = buffs.get("amount", 0)
		item.buff_duration = buffs.get("duration", 0.0)
		item.set("buff_effects", buffs)
	elif data.has("buff_duration"):
		item.buff_duration = data["buff_duration"]

	# Tags (with extra flag handling)
	var tags: Array[String] = []
	var raw_tags = data.get("tags", [])
	for t in raw_tags:
		tags.append(str(t))
	if data.get("cures_poison", false):
		if not tags.has("cure_poison"):
			tags.append("cure_poison")
	if data.get("auto_revive", false):
		if not tags.has("auto_revive"):
			tags.append("auto_revive")
	item.tags = tags

	# Extended properties (via Object.set() for properties not declared in ItemData)
	if data.has("ammo"):
		item.set("ammo_count", data["ammo"])
	if data.get("illegal", false):
		item.set("is_illegal", true)

	return item


# ============================================================
# METODOS PUBLICOS
# ============================================================

func get_item(item_id: String) -> Resource:
	"""Retorna el ItemData para un ID dado, o null si no existe.

	Parametros:
		item_id: ID del item en la base de datos (ej. "pistol_9mm")
	Returns:
		ItemData: El recurso del item, o null si no se encuentra
	"""
	if _items.has(item_id):
		return _items[item_id].duplicate(true)
	push_error("ItemDatabase: Item no encontrado: ", item_id)
	return null


func get_all_items() -> Array:
	"""Retorna un array con todos los ItemData de la base de datos.

	Returns:
		Array[ItemData]: Lista de todos los items registrados
	"""
	var all: Array = []
	for key in _items:
		all.append(_items[key].duplicate(true))
	return all


func get_items_by_category(category: String) -> Array:
	"""Retorna todos los items filtrados por categoria.

	Parametros:
		category: Categoria (ej. "WEAPONS", "AMMO", "CONSUMABLES", "MATERIALS", "QUEST_ITEMS", "JUNK")
	Returns:
		Array[ItemData]: Items que coinciden con la categoria
	"""
	var filtered: Array = []
	match category.to_upper():
		"WEAPONS":
			for item in _items.values():
				if item.item_type == 0:
					filtered.append(item.duplicate(true))
		"AMMO":
			for item in _items.values():
				if item.item_type == 6:
					filtered.append(item.duplicate(true))
		"CONSUMABLES":
			for item in _items.values():
				if item.item_type == 2:
					filtered.append(item.duplicate(true))
		"MATERIALS":
			for item in _items.values():
				if item.item_type == 4:
					filtered.append(item.duplicate(true))
		"QUEST_ITEMS", "QUEST":
			for item in _items.values():
				if item.item_type == 3:
					filtered.append(item.duplicate(true))
		"JUNK":
			for item in _items.values():
				if item.item_type == 5:
					filtered.append(item.duplicate(true))
		"ARMOR":
			for item in _items.values():
				if item.item_type == 1:
					filtered.append(item.duplicate(true))
		"BLUEPRINTS":
			for item in _items.values():
				if item.item_type == 7:
					filtered.append(item.duplicate(true))
		_:
			push_error("ItemDatabase: Categoria desconocida: ", category)
	return filtered


func get_all_item_ids() -> Array[String]:
	"""Retorna todos los IDs de items disponibles.

	Returns:
		Array[String]: Lista de IDs
	"""
	var ids: Array[String] = []
	for key in _items:
		ids.append(key)
	return ids


func has_item(item_id: String) -> bool:
	"""Verifica si un item existe en la base de datos.

	Parametros:
		item_id: ID del item
	Returns:
		bool: true si existe
	"""
	return _items.has(item_id)