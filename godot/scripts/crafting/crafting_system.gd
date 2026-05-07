# ============================================================
# crafting_system.gd -- CraftingSystem (Autoload)
# Barrio Sin Ley Online (BSLO)
# Sistema de crafteo con recetas y verificacion de inventario.
# ============================================================
extends Node

const ItemDataRef = preload("res://scripts/items/item_data.gd")

signal recipe_crafted(recipe_id: String)

var _recipes: Dictionary = {}
var _custom_items: Dictionary = {}

func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	_init_recipes()
	print("CraftingSystem: %d recetas cargadas." % _recipes.size())

func _init_recipes():
	_recipes["vendaje_mejorado"] = {
		"name": "Vendaje Mejorado",
		"description": "Craftea un botiquin que cura 50 HP",
		"ingredients": {
			"vendaje": 2,
			"cinta_adhesiva": 1
		},
		"result": {"item_id": "botiquin", "quantity": 1},
		"required_level": 1
	}

	_recipes["cerveza_explosiva"] = {
		"name": "Cerveza Explosiva",
		"description": "Craftea un coctel molotov que causa danio de fuego",
		"ingredients": {
			"cerveza_barrio": 2,
			"polvora": 1
		},
		"result": {"item_id": "coctel_molotov", "quantity": 1},
		"required_level": 2
	}

	_recipes["taco_supremo"] = {
		"name": "Taco Supremo",
		"description": "Craftea un taco que cura 100% HP",
		"ingredients": {
			"taco_callejero": 2,
			"alcohol_puro": 1
		},
		"result": {"item_id": "taco_supremo", "quantity": 1},
		"required_level": 3
	}

	_recipes["municion_recargada"] = {
		"name": "Municion Recargada",
		"description": "Recarga municion 9mm con chatarra y polvora",
		"ingredients": {
			"chatarra_metal": 2,
			"polvora": 1
		},
		"result": {"item_id": "ammo_9mm", "quantity": 1},
		"required_level": 1
	}

	_recipes["chaleco_reforzado"] = {
		"name": "Chaleco Reforzado",
		"description": "Craftea un chaleco de defensa improvisado",
		"ingredients": {
			"chatarra_metal": 3,
			"cinta_adhesiva": 2
		},
		"result": {"item_id": "chaleco", "quantity": 1},
		"required_level": 2
	}

	_recipes["estimulante"] = {
		"name": "Estimulante",
		"description": "Craftea un estimulante: +50% velocidad, +30% danio, sin efectos secundarios",
		"ingredients": {
			"adrenalina": 1,
			"cocaina": 1
		},
		"result": {"item_id": "estimulante", "quantity": 1},
		"required_level": 4
	}

	_build_custom_items()

func _build_custom_items():
	var coctel = ItemDataRef.new()
	coctel.item_name = "Coctel Molotov"
	coctel.description = "Botella incendiaria improvisada. Causa danio de fuego en area."
	coctel.item_type = 2
	coctel.rarity = 1
	coctel.grid_width = 1
	coctel.grid_height = 2
	coctel.weight = 0.8
	coctel.base_value = 300
	coctel.damage = 30
	coctel.required_level = 1
	coctel.stackable = true
	coctel.max_stack = 5
	coctel.tags = ["throwable", "fire", "explosive", "weapon"]
	_custom_items["coctel_molotov"] = coctel

	var taco = ItemDataRef.new()
	taco.item_name = "Taco Supremo"
	taco.description = "Taco legendario con ingredientes secretos. Cura 100% HP al instante."
	taco.item_type = 2
	taco.rarity = 3
	taco.grid_width = 1
	taco.grid_height = 1
	taco.weight = 0.3
	taco.base_value = 800
	taco.heal_amount = 0
	taco.stackable = true
	taco.max_stack = 3
	taco.tags = ["food", "heal", "epic", "full_heal"]
	taco.set("heal_percent", 1.0)
	_custom_items["taco_supremo"] = taco

	var chal = ItemDataRef.new()
	chal.item_name = "Chaleco Reforzado"
	chal.description = "Chaleco con placas de chatarra. Aumenta defensa significativamente."
	chal.item_type = 1
	chal.rarity = 1
	chal.grid_width = 2
	chal.grid_height = 2
	chal.weight = 4.0
	chal.base_value = 600
	chal.defense = 15
	chal.required_level = 2
	chal.stackable = false
	chal.max_stack = 1
	chal.tags = ["armor", "defense", "crafted"]
	_custom_items["chaleco"] = chal

	var stim = ItemDataRef.new()
	stim.item_name = "Estimulante"
	stim.description = "Mezcla de adrenalina y cocaina purificada. +50% velocidad, +30% danio. Sin efectos secundarios."
	stim.item_type = 2
	stim.rarity = 3
	stim.grid_width = 1
	stim.grid_height = 1
	stim.weight = 0.1
	stim.base_value = 1500
	stim.stackable = true
	stim.max_stack = 2
	stim.buff_stat = "DEX"
	stim.buff_amount = 5
	stim.buff_duration = 180.0
	stim.tags = ["drug", "buff", "epic", "speed", "damage", "crafted"]
	_custom_items["estimulante"] = stim

func _get_result_item(recipe_id: String) -> Resource:
	if not _recipes.has(recipe_id):
		push_error("CraftingSystem: Receta no encontrada: ", recipe_id)
		return null

	var recipe = _recipes[recipe_id]
	var result_id = recipe["result"]["item_id"]

	if _custom_items.has(result_id):
		return _custom_items[result_id].duplicate(true)

	if ItemDatabase:
		var item = ItemDatabase.get_item(result_id)
		if item:
			return item

	push_error("CraftingSystem: Item resultado no encontrado: ", result_id)
	return null

func _check_ingredients(recipe_id: String) -> bool:
	if not _recipes.has(recipe_id):
		return false

	var recipe = _recipes[recipe_id]
	if not InventoryManager:
		return false

	for ingredient_id in recipe["ingredients"]:
		var qty = recipe["ingredients"][ingredient_id]
		if not InventoryManager.has_item_by_id(ingredient_id, qty):
			return false

	return true

func _check_level(recipe_id: String) -> bool:
	if not _recipes.has(recipe_id):
		return false
	var req_level = _recipes[recipe_id].get("required_level", 1)
	if StatsManager:
		return StatsManager.level >= req_level
	return true

func _remove_ingredients(recipe_id: String) -> bool:
	if not _recipes.has(recipe_id):
		return false

	var recipe = _recipes[recipe_id]
	if not InventoryManager:
		return false

	for ingredient_id in recipe["ingredients"]:
		var qty = recipe["ingredients"][ingredient_id]
		if not InventoryManager.has_item_by_id(ingredient_id, qty):
			push_error("CraftingSystem: Faltan ingredientes para ", recipe_id)
			return false

	for ingredient_id in recipe["ingredients"]:
		var qty = recipe["ingredients"][ingredient_id]
		InventoryManager.remove_item_by_id(ingredient_id, qty)

	return true

func craft(recipe_id: String) -> bool:
	if not _recipes.has(recipe_id):
		push_error("CraftingSystem: Receta no existe: ", recipe_id)
		return false

	if not _check_ingredients(recipe_id):
		print("CraftingSystem: Ingredientes insuficientes para ", recipe_id)
		return false

	if not _check_level(recipe_id):
		print("CraftingSystem: Nivel insuficiente para ", recipe_id)
		return false

	var result_item = _get_result_item(recipe_id)
	if not result_item:
		return false

	if not _remove_ingredients(recipe_id):
		return false

	var qty = _recipes[recipe_id]["result"]["quantity"]
	if not InventoryManager:
		push_error("CraftingSystem: InventoryManager no disponible")
		return false

	var success = InventoryManager.add_item(result_item, qty)
	if success:
		print("CraftingSystem: Crafteado %s!" % _recipes[recipe_id]["name"])
		recipe_crafted.emit(recipe_id)
		return true
	else:
		print("CraftingSystem: Inventario lleno, no se pudo agregar ", result_item.item_name)
		for ingredient_id in _recipes[recipe_id]["ingredients"]:
			var ing_qty = _recipes[recipe_id]["ingredients"][ingredient_id]
			InventoryManager.add_item_by_id(ingredient_id, ing_qty)
		return false

func can_craft(recipe_id: String) -> bool:
	return _check_ingredients(recipe_id) and _check_level(recipe_id)

func get_recipe_ingredients_status(recipe_id: String) -> Dictionary:
	var status: Dictionary = {}
	if not _recipes.has(recipe_id):
		return status

	var recipe = _recipes[recipe_id]
	for ingredient_id in recipe["ingredients"]:
		var required = recipe["ingredients"][ingredient_id]
		var has = 0
		if InventoryManager:
			var item_data = ItemDatabase.get_item(ingredient_id) if ItemDatabase else null
			if item_data:
				has = _count_item_by_name_in_inventory(item_data.item_name)
		status[ingredient_id] = {"required": required, "has": has, "enough": has >= required}
	return status

func _count_item_by_name_in_inventory(item_name: String) -> int:
	if not InventoryManager:
		return 0
	var count = 0
	for col in range(InventoryManager.GRID_COLS):
		for row in range(InventoryManager.GRID_ROWS):
			var cell = InventoryManager.inventory[col][row]
			if cell != null and cell["item"].item_name == item_name:
				count += cell["quantity"]
	return count

func get_available_recipes() -> Array:
	var available: Array = []
	for recipe_id in _recipes:
		if can_craft(recipe_id):
			available.append(_recipes[recipe_id].duplicate(true))
	return available

func get_all_recipes() -> Array:
	var all: Array = []
	for recipe_id in _recipes:
		var r = _recipes[recipe_id].duplicate(true)
		r["recipe_id"] = recipe_id
		r["can_craft"] = can_craft(recipe_id)
		r["ingredients_status"] = get_recipe_ingredients_status(recipe_id)
		all.append(r)
	return all

func get_recipe(recipe_id: String) -> Dictionary:
	if _recipes.has(recipe_id):
		var r = _recipes[recipe_id].duplicate(true)
		r["recipe_id"] = recipe_id
		r["can_craft"] = can_craft(recipe_id)
		r["ingredients_status"] = get_recipe_ingredients_status(recipe_id)
		return r
	return {}
