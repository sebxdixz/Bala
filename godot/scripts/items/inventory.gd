# ============================================================
# inventory.gd — InventoryManager (Autoload)
# Barrio Sin Ley Online (BSLO)
# Sistema de inventario en malla grid 8x10
# ============================================================
extends Node

const ItemDataRef = preload("res://scripts/items/item_data.gd")

# Senales
signal inventory_opened()
signal inventory_closed()
signal item_added(item: Resource, slot: Vector2i)
signal item_removed(item: Resource, slot: Vector2i)
signal item_used(item: Resource, slot: Vector2i)
signal inventory_changed()
signal weight_changed(current_weight: float, max_weight: float)

# Dimensiones del inventario
const GRID_COLS: int = 8
const GRID_ROWS: int = 10
const TOTAL_SLOTS: int = GRID_COLS * GRID_ROWS

# Estructura del inventario
# inventory[col][row] = { "item": Resource, "quantity": int } o null
var inventory: Array = []
var is_open: bool = false

# Peso
var current_weight: float = 0.0
var max_weight: float = 40.0
# Nota: max_weight se recalcula basado en STR del StatsManager

func _ready():
	"""Inicializa la malla de inventario como array 2D vacia."""
	_init_grid()

# ============================================================
# METODOS PRIVADOS
# ============================================================

func _init_grid():
	"""Crea la malla 2D de inventario: 8 columnas x 10 filas.
	
	Cada celda es null (vacia) o un diccionario con:
		- "item": ItemData
		- "quantity": int
	"""
	inventory.clear()
	for col in range(GRID_COLS):
		var column: Array = []
		for row in range(GRID_ROWS):
			column.append(null)
		inventory.append(column)

func _recalculate_weight():
	"""Recalcula el peso total del inventario."""
	current_weight = 0.0
	for col in range(GRID_COLS):
		for row in range(GRID_ROWS):
			var cell = inventory[col][row]
			if cell != null:
				current_weight += cell["item"].weight * cell["quantity"]
	weight_changed.emit(current_weight, max_weight)

func _update_max_weight():
	"""Actualiza el peso maximo basado en STR.
	
	Formula: 20 + STR * 4 kg
	"""
	if StatsManager:
		max_weight = 20.0 + StatsManager.get_stat("STR") * 4.0
	else:
		max_weight = 40.0

func _is_slot_empty(col: int, row: int) -> bool:
	"""Verifica si una celda especifica esta vacia.
	
	Parametros:
		col: Columna (0-7)
		row: Fila (0-9)
	Returns:
		bool: true si la celda esta vacia o es null
	"""
	if col < 0 or col >= GRID_COLS or row < 0 or row >= GRID_ROWS:
		return false
	return inventory[col][row] == null

func _can_fit(item: Resource, start_col: int, start_row: int) -> bool:
	"""Verifica si un item cabe en la posicion dada respetando su tamano.
	
	Parametros:
		item: ItemData a verificar
		start_col: Columna inicial
		start_row: Fila inicial
	Returns:
		bool: true si el item cabe en esa area
	"""
	if start_col + item.grid_width > GRID_COLS:
		return false
	if start_row + item.grid_height > GRID_ROWS:
		return false
	
	for col in range(start_col, start_col + item.grid_width):
		for row in range(start_row, start_row + item.grid_height):
			if not _is_slot_empty(col, row):
				return false
	return true

func _find_free_space(item: Resource) -> Vector2i:
	"""Busca espacio libre para un item en toda la malla.
	
	Parametros:
		item: ItemData a ubicar
	Returns:
		Vector2i: Posicion (col, row) o Vector2i(-1, -1) si no hay espacio
	"""
	for row in range(GRID_ROWS):
		for col in range(GRID_COLS):
			if _can_fit(item, col, row):
				return Vector2i(col, row)
	return Vector2i(-1, -1)

# ============================================================
# METODOS PUBLICOS
# ============================================================

func open_inventory():
	"""Abre la interfaz de inventario.
	
	El jugador queda vulnerable mientras esta abierto.
	"""
	is_open = true
	_update_max_weight()
	inventory_opened.emit()
	_emit_contents_changed()

func close_inventory():
	"""Cierra la interfaz de inventario."""
	is_open = false
	inventory_closed.emit()

func toggle_inventory():
	"""Alterna entre abrir y cerrar inventario."""
	if is_open:
		close_inventory()
	else:
		open_inventory()

func add_item(item: Resource, quantity: int = 1) -> bool:
	"""Anade un item al inventario. Retorna true si se pudo anadir.
	
	Busca stacks existentes primero, luego espacio libre.
	Retorna false si el inventario esta lleno.
	
	Parametros:
		item: ItemData a agregar
		quantity: Cantidad a agregar (default 1)
	Returns:
		bool: true si se agrego exitosamente
	"""
	_update_max_weight()
	
	# Verificar peso
	if current_weight + (item.weight * quantity) > max_weight:
		print("Inventory: Peso maximo excedido!")
		return false
	
	# Si es stackeable, buscar stack existente
	if item.stackable:
		for col in range(GRID_COLS):
			for row in range(GRID_ROWS):
				var cell = inventory[col][row]
				if cell != null and cell["item"].item_name == item.item_name:
					var space = cell["item"].max_stack - cell["quantity"]
					if space > 0:
						var to_add = mini(quantity, space)
						cell["quantity"] += to_add
						quantity -= to_add
						item_added.emit(item, Vector2i(col, row))
						inventory_changed.emit()
						_recalculate_weight()
						if quantity <= 0:
							return true
	
	# Si quedan items por agregar, buscar espacio libre
	while quantity > 0:
		var pos = _find_free_space(item)
		if pos == Vector2i(-1, -1):
			print("Inventory: No hay espacio para el item!")
			return false
		
		var to_add = 1
		if item.stackable:
			to_add = mini(quantity, item.max_stack)
		
		# Ocupar las celdas del tamano del item
		for col in range(pos.x, pos.x + item.grid_width):
			for row in range(pos.y, pos.y + item.grid_height):
				inventory[col][row] = {"item": item, "quantity": to_add}
		
		item_added.emit(item, pos)
		quantity -= to_add
	
	inventory_changed.emit()
	_recalculate_weight()
	return true

func remove_item_at(col: int, row: int, quantity: int = 1) -> Resource:
	"""Elimina un item del inventario en la posicion dada.
	Retorna el ItemData eliminado o null si no hay nada.
	
	Para items con tamano > 1x1, la posicion es la celda superior izquierda.
	
	Parametros:
		col: Columna
		row: Fila
		quantity: Cantidad a remover
	Returns:
		ItemData: El item removido, o null si no habia nada
	"""
	if not _is_slot_empty(col, row):
		var cell = inventory[col][row]
		var item = cell["item"]
		
		# Limpiar todas las celdas que ocupa el item
		if quantity >= cell["quantity"]:
			# Remover completamente
			for c in range(col, col + item.grid_width):
				for r in range(row, row + item.grid_height):
					inventory[c][r] = null
			item_removed.emit(item, Vector2i(col, row))
		else:
			# Reducir cantidad
			cell["quantity"] -= quantity
		
		inventory_changed.emit()
		_recalculate_weight()
		return item
	
	return null

func use_item(col: int, row: int) -> bool:
	"""Usa un item del inventario. Para consumibles, aplica efectos.
	Retorna true si se pudo usar.
	
	Parametros:
		col: Columna del item
		row: Fila del item
	Returns:
		bool: true si el item se uso correctamente
	"""
	if _is_slot_empty(col, row):
		return false
	
	var cell = inventory[col][row]
	var item = cell["item"]
	
	if item.is_consumable():
		# Aplicar efectos del consumible
		if item.heal_amount > 0:
			StatsManager.heal(item.heal_amount)
		if item.stamina_restore > 0:
			StatsManager.restore_stamina(item.stamina_restore)
		if item.buff_duration > 0 and item.buff_stat != "":
			StatsManager.modify_stat(item.buff_stat, item.buff_amount)
			# TODO: Timer para remover buff al expirar
		
		item_used.emit(item, Vector2i(col, row))
		
		# Reducir stack
		cell["quantity"] -= 1
		if cell["quantity"] <= 0:
			remove_item_at(col, row, 999)
		
		inventory_changed.emit()
		_recalculate_weight()
		return true
	
	return false

func get_item_at(col: int, row: int) -> Resource:
	"""Obtiene el ItemData en la posicion dada sin modificarlo.
	
	Parametros:
		col: Columna
		row: Fila
	Returns:
		ItemData o null si esta vacio
	"""
	if _is_slot_empty(col, row):
		return null
	return inventory[col][row]["item"]

func get_item_quantity_at(col: int, row: int) -> int:
	"""Obtiene la cantidad de items en la posicion dada.
	
	Parametros:
		col: Columna
		row: Fila
	Returns:
		int: Cantidad de items, 0 si esta vacio
	"""
	if _is_slot_empty(col, row):
		return 0
	return inventory[col][row]["quantity"]

func has_item(item_name: String, quantity: int = 1) -> bool:
	"""Verifica si existe un item por nombre con cierta cantidad.
	
	Parametros:
		item_name: Nombre del item a buscar
		quantity: Cantidad minima requerida
	Returns:
		bool: true si existe al menos la cantidad especificada
	"""
	var total = 0
	for col in range(GRID_COLS):
		for row in range(GRID_ROWS):
			var cell = inventory[col][row]
			if cell != null and cell["item"].item_name == item_name:
				total += cell["quantity"]
				if total >= quantity:
					return true
	return false

func get_total_weight() -> float:
	"""Retorna el peso total actual del inventario.
	
	Returns:
		float: Peso total en kg
	"""
	return current_weight

func get_max_weight() -> float:
	"""Retorna el peso maximo que soporta el jugador.
	
	Returns:
		float: Peso maximo en kg
	"""
	_update_max_weight()
	return max_weight

func get_weight_ratio() -> float:
	"""Retorna la proporcion de peso usado (0.0 a 1.0).
	
	Returns:
		float: Ratio de peso usado
	"""
	if max_weight <= 0:
		return 1.0
	return clampf(current_weight / max_weight, 0.0, 1.0)

func is_overweight() -> bool:
	"""Retorna true si el jugador excede el peso maximo.
	
	Returns:
		bool: true si el peso actual supera el maximo
	"""
	return current_weight > max_weight

func clear_inventory():
	"""Vacia todo el inventario."""
	_init_grid()
	current_weight = 0.0
	inventory_changed.emit()
	weight_changed.emit(0.0, max_weight)

func get_all_items() -> Array:
	"""Retorna un array con todos los items del inventario.
	
	Returns:
		Array: Lista de diccionarios {item, quantity, col, row}
	"""
	var items: Array = []
	var visited: Array = []  # Para no duplicar items multi-celda
	
	for col in range(GRID_COLS):
		for row in range(GRID_ROWS):
			if visited.has(Vector2i(col, row)):
				continue
			var cell = inventory[col][row]
			if cell != null:
				var item = cell["item"]
				items.append({
					"item": item,
					"quantity": cell["quantity"],
					"col": col,
					"row": row
				})
				# Marcar todas las celdas que ocupa este item
				for c in range(col, col + item.grid_width):
					for r in range(row, row + item.grid_height):
						visited.append(Vector2i(c, r))
	
	return items

# ============================================================
# SEÑAL DE CONTENIDO (para UI)
# ============================================================

# Señal emitida cuando el contenido del inventario cambia
# Pasa un array de diccionarios {item, quantity, col, row}
signal inventory_contents_changed(items: Array)


# ============================================================
# METODOS DE BASE DE DATOS (ItemDatabase integration)
# ============================================================

func add_item_by_id(item_id: String, quantity: int = 1) -> bool:
	"""Anade un item al inventario usando su ID de la base de datos.
	
	Busca el item en ItemDatabase y lo agrega al inventario.
	
	Parametros:
		item_id: ID del item en la base de datos (ej. "pistol_9mm")
		quantity: Cantidad a agregar (default 1)
	Returns:
		bool: true si se agrego exitosamente
	"""
	if not ItemDatabase:
		push_error("Inventory: ItemDatabase no disponible!")
		return false
	
	var item_data = ItemDatabase.get_item(item_id)
	if item_data == null:
		push_error("Inventory: Item no encontrado en BD: ", item_id)
		return false
	
	return add_item(item_data, quantity)


func remove_item_by_id(item_id: String, quantity: int = 1) -> bool:
	"""Elimina un item del inventario por su ID.
	
	Busca el item en el inventario y remueve la cantidad especificada.
	
	Parametros:
		item_id: ID del item a remover
		quantity: Cantidad a remover (default 1)
	Returns:
		bool: true si se removio al menos un item
	"""
	if not ItemDatabase:
		push_error("Inventory: ItemDatabase no disponible!")
		return false
	
	var item_data = ItemDatabase.get_item(item_id)
	if item_data == null:
		push_error("Inventory: Item no encontrado en BD: ", item_id)
		return false
	
	# Buscar el item por nombre en el inventario
	for col in range(GRID_COLS):
		for row in range(GRID_ROWS):
			var cell = inventory[col][row]
			if cell != null and cell["item"].item_name == item_data.item_name:
				remove_item_at(col, row, quantity)
				return true
	
	print("Inventory: Item no encontrado en el inventario: ", item_id)
	return false


func has_item_by_id(item_id: String, quantity: int = 1) -> bool:
	"""Verifica si existe un item en el inventario por su ID de base de datos.
	
	Parametros:
		item_id: ID del item a buscar
		quantity: Cantidad minima requerida
	Returns:
		bool: true si existe al menos la cantidad especificada
	"""
	if not ItemDatabase:
		return false
	
	var item_data = ItemDatabase.get_item(item_id)
	if item_data == null:
		return false
	
	return has_item(item_data.item_name, quantity)


func _emit_contents_changed():
	"""Emite la senal inventory_contents_changed con el contenido actual."""
	var items = get_all_items()
	inventory_contents_changed.emit(items)

