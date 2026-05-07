# ============================================================
# shop_screen.gd — Interfaz de Tienda (Shop UI)
# Barrio Sin Ley Online (BSLO)
# CanvasLayer con tienda FUNCIONAL: comprar items con PB.
# ============================================================
extends CanvasLayer

# Senales
signal shop_opened()
signal shop_closed()
signal item_purchased(item_id: String, price: int)

# ---- Nodos hijos ----
@onready var shop_panel: Panel = $ShopPanel
@onready var title_label: Label = $ShopPanel/Title
@onready var grid_container = $ShopPanel/ScrollContainer/GridContainer
@onready var close_button: Button = $ShopPanel/CloseButton
@onready var money_label: Label = $ShopPanel/MoneyLabel
@onready var background: ColorRect = $Background

# ---- Export ----
@export var shop_name: String = "EL FERRETERO"

# Items disponibles en la tienda con precios fijos
const SHOP_INVENTORY: Dictionary = {
	"taco_callejero": {"price": 200, "name": "Taco Callejero"},
	"cerveza_barrio": {"price": 150, "name": "Cerveza del Barrio"},
	"jarabe_abuela": {"price": 500, "name": "Jarabe de la Abuela"},
	"adrenalina":    {"price": 2000, "name": "Adrenalina"},
	"pistol_9mm":    {"price": 5000, "name": "Pistola 9mm"},
	"navaja":        {"price": 3000, "name": "Navaja"},
	"ammo_9mm":      {"price": 500, "name": "Municion 9mm"},
	"vendaje":       {"price": 100, "name": "Vendaje"},
}

# Referencia a botones para habilitar/deshabilitar segun PB
var _item_buttons: Dictionary = {}

func _ready():
	"""Inicializa la tienda y conecta senales."""
	hide()
	process_mode = PROCESS_MODE_ALWAYS

	# Configurar titulo
	if title_label:
		title_label.text = shop_name
		title_label.add_theme_color_override("font_color", Color(1, 0.9, 0.3, 1))
		title_label.add_theme_font_size_override("font_size", 24)

	# Conectar boton de cerrar
	if close_button:
		close_button.pressed.connect(_on_close_pressed)
		close_button.text = "CERRAR"

	# Conectar click en background para cerrar
	if background:
		background.gui_input.connect(_on_background_input)

	# Poblar la grilla con los items del shop
	_populate_grid()

func _input(event: InputEvent):
	"""Cierra la tienda con Escape o F."""
	if visible:
		if event.is_action_pressed("toggle_inventory") or event.is_action_pressed("ui_cancel"):
			close_shop()
			get_viewport().set_input_as_handled()

# ============================================================
# METODOS PUBLICOS
# ============================================================

func open_shop():
	"""Abre la interfaz de la tienda."""
	_update_money_display()
	_refresh_button_states()
	show()
	shop_opened.emit()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	print("Shop: Tienda '%s' abierta" % shop_name)

func close_shop():
	"""Cierra la interfaz de la tienda."""
	hide()
	shop_closed.emit()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	print("Shop: Tienda cerrada")

func _update_money_display():
	"""Actualiza el label de dinero con el PB actual."""
	var pb = 0
	if StatsManager:
		pb = StatsManager.carried_pb
	if money_label:
		money_label.text = "PB: %d" % pb
		money_label.add_theme_color_override("font_color", Color(0.3, 1.0, 0.3, 1))
		money_label.add_theme_font_size_override("font_size", 18)

func _refresh_button_states():
	"""Actualiza el estado de todos los botones COMPRAR segun PB disponible."""
	var pb = 0
	if StatsManager:
		pb = StatsManager.carried_pb
	
	for item_id in _item_buttons:
		var btn_info = _item_buttons[item_id]
		var button: Button = btn_info["button"]
		var price: int = btn_info["price"]
		
		if pb >= price:
			button.disabled = false
			button.text = "COMPRAR"
			button.add_theme_color_override("font_color", Color(1, 1, 1, 1))
		else:
			button.disabled = true
			button.text = "SIN PB"
			button.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5, 1))

# ============================================================
# UI - POBLAR GRILLA
# ============================================================

func _populate_grid():
	"""Llena la grilla con los items de la tienda."""
	if not grid_container:
		print("Shop: No se encontro GridContainer")
		return
	
	# Limpiar hijos existentes
	for child in grid_container.get_children():
		child.queue_free()
	
	_item_buttons.clear()
	
	# Crear fila de encabezado
	var header = _create_header_row()
	grid_container.add_child(header)
	
	# Crear fila para cada item
	for item_id in SHOP_INVENTORY:
		var item_info = SHOP_INVENTORY[item_id]
		var item_row = _create_item_row(item_id, item_info["name"], item_info["price"])
		grid_container.add_child(item_row)

func _create_header_row() -> HBoxContainer:
	"""Crea la fila de encabezado de la tienda."""
	var row = HBoxContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("separation", 8)
	
	var name_header = Label.new()
	name_header.text = "ITEM"
	name_header.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_header.add_theme_color_override("font_color", Color(0.6, 0.5, 0.2, 1))
	name_header.add_theme_font_size_override("font_size", 13)
	row.add_child(name_header)
	
	var price_header = Label.new()
	price_header.text = "PRECIO"
	price_header.size_flags_horizontal = Control.SIZE_SHRINK_END
	price_header.custom_minimum_size = Vector2(80, 0)
	price_header.add_theme_color_override("font_color", Color(0.6, 0.5, 0.2, 1))
	price_header.add_theme_font_size_override("font_size", 13)
	price_header.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	row.add_child(price_header)
	
	var action_header = Label.new()
	action_header.text = ""
	action_header.size_flags_horizontal = Control.SIZE_SHRINK_END
	action_header.custom_minimum_size = Vector2(90, 0)
	row.add_child(action_header)
	
	return row

func _create_item_row(item_id: String, item_name: String, price: int) -> HBoxContainer:
	"""Crea una fila de tienda con nombre, precio y boton comprar.
	
	Parametros:
		item_id: ID del item en la base de datos
		item_name: Nombre visible del item
		price: Precio en PB
	Returns:
		HBoxContainer: Fila con los elementos del item
	"""
	var row = HBoxContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("separation", 8)
	
	# Obtener rareza del item si esta en la BD para colorear
	var item_color = Color(1, 1, 1, 1)
	if ItemDatabase:
		var item_data = ItemDatabase.get_item(item_id)
		if item_data:
			item_color = item_data.get_rarity_color()
	
	# Nombre del item
	var name_label = Label.new()
	name_label.text = item_name
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_label.add_theme_color_override("font_color", item_color)
	name_label.add_theme_font_size_override("font_size", 14)
	row.add_child(name_label)
	
	# Precio
	var price_label = Label.new()
	price_label.text = "%d PB" % price
	price_label.size_flags_horizontal = Control.SIZE_SHRINK_END
	price_label.custom_minimum_size = Vector2(80, 0)
	price_label.add_theme_color_override("font_color", Color(1, 0.85, 0.3, 1))
	price_label.add_theme_font_size_override("font_size", 14)
	price_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	row.add_child(price_label)
	
	# Boton comprar
	var buy_btn = Button.new()
	buy_btn.text = "COMPRAR"
	buy_btn.size_flags_horizontal = Control.SIZE_SHRINK_END
	buy_btn.custom_minimum_size = Vector2(90, 32)
	buy_btn.add_theme_font_size_override("font_size", 12)
	
	# Estilo normal (verde)
	var normal_style = StyleBoxFlat.new()
	normal_style.bg_color = Color(0.2, 0.5, 0.15, 0.9)
	normal_style.border_width_left = 1
	normal_style.border_width_top = 1
	normal_style.border_width_right = 1
	normal_style.border_width_bottom = 1
	normal_style.border_color = Color(0.3, 0.7, 0.2, 1)
	normal_style.corner_radius_top_left = 4
	normal_style.corner_radius_top_right = 4
	normal_style.corner_radius_bottom_right = 4
	normal_style.corner_radius_bottom_left = 4
	buy_btn.add_theme_stylebox_override("normal", normal_style)
	
	# Estilo hover (verde brillante)
	var hover_style = StyleBoxFlat.new()
	hover_style.bg_color = Color(0.3, 0.7, 0.2, 0.95)
	hover_style.border_width_left = 1
	hover_style.border_width_top = 1
	hover_style.border_width_right = 1
	hover_style.border_width_bottom = 1
	hover_style.border_color = Color(0.4, 0.9, 0.3, 1)
	hover_style.corner_radius_top_left = 4
	hover_style.corner_radius_top_right = 4
	hover_style.corner_radius_bottom_right = 4
	hover_style.corner_radius_bottom_left = 4
	buy_btn.add_theme_stylebox_override("hover", hover_style)
	
	# Estilo disabled (gris)
	var disabled_style = StyleBoxFlat.new()
	disabled_style.bg_color = Color(0.15, 0.15, 0.15, 0.7)
	disabled_style.border_width_left = 1
	disabled_style.border_width_top = 1
	disabled_style.border_width_right = 1
	disabled_style.border_width_bottom = 1
	disabled_style.border_color = Color(0.2, 0.2, 0.2, 1)
	disabled_style.corner_radius_top_left = 4
	disabled_style.corner_radius_top_right = 4
	disabled_style.corner_radius_bottom_right = 4
	disabled_style.corner_radius_bottom_left = 4
	buy_btn.add_theme_stylebox_override("disabled", disabled_style)
	
	buy_btn.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	buy_btn.add_theme_color_override("font_disabled_color", Color(0.4, 0.4, 0.4, 1))
	
	# Conectar compra
	buy_btn.pressed.connect(_on_buy_pressed.bind(item_id, price, item_name))
	row.add_child(buy_btn)
	
	# Guardar referencia al boton para actualizar estado
	_item_buttons[item_id] = {"button": buy_btn, "price": price}
	
	return row

# ============================================================
# SENALES DE COMPRA
# ============================================================

func _on_buy_pressed(item_id: String, price: int, item_name: String):
	"""Intenta comprar un item de la tienda."""
	var current_pb = 0
	if StatsManager:
		current_pb = StatsManager.carried_pb
	
	# Verificar dinero suficiente
	if price > current_pb:
		_show_error_message("No tienes suficiente PB para comprar %s" % item_name)
		print("Shop: Dinero insuficiente para %s (necesitas %d, tienes %d)" % [item_name, price, current_pb])
		return
	
	# Verificar InventoryManager
	if not InventoryManager:
		_show_error_message("Sistema de inventario no disponible")
		print("Shop: InventoryManager no disponible")
		return
	
	# Verificar que el item existe en la BD
	if not ItemDatabase:
		_show_error_message("Base de datos de items no disponible")
		print("Shop: ItemDatabase no disponible")
		return
	
	var item_data = ItemDatabase.get_item(item_id)
	if item_data == null:
		_show_error_message("Item no encontrado: %s" % item_id)
		print("Shop: Item no encontrado en BD: ", item_id)
		return
	
	# Intentar agregar al inventario
	var success = InventoryManager.add_item_by_id(item_id, 1)
	if success:
		# Deducir dinero
		if StatsManager:
			StatsManager.remove_pb(price)
		
		# Actualizar display
		_update_money_display()
		_refresh_button_states()
		
		item_purchased.emit(item_id, price)
		_show_success_message("Compraste %s por %d PB" % [item_name, price])
		print("Shop: Compraste %s por %d PB" % [item_name, price])
	else:
		_show_error_message("No hay espacio en el inventario para %s" % item_name)
		print("Shop: No hay espacio en el inventario para ", item_name)

func _show_error_message(msg: String):
	"""Muestra un mensaje de error temporal en la tienda."""
	var error_label = Label.new()
	error_label.text = msg
	error_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	error_label.add_theme_color_override("font_color", Color(1, 0.3, 0.3, 1))
	error_label.add_theme_font_size_override("font_size", 14)
	error_label.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	error_label.position = Vector2(-250, -40)
	error_label.size = Vector2(500, 30)
	error_label.name = "ErrorMessage"
	add_child(error_label)
	
	# Auto-eliminar tras 2 segundos
	var tween = create_tween()
	tween.tween_interval(2.0)
	tween.tween_callback(error_label.queue_free)

func _show_success_message(msg: String):
	"""Muestra un mensaje de exito temporal en la tienda."""
	var success_label = Label.new()
	success_label.text = msg
	success_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	success_label.add_theme_color_override("font_color", Color(0.3, 1, 0.3, 1))
	success_label.add_theme_font_size_override("font_size", 14)
	success_label.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	success_label.position = Vector2(-250, -40)
	success_label.size = Vector2(500, 30)
	success_label.name = "SuccessMessage"
	add_child(success_label)
	
	# Auto-eliminar tras 2 segundos
	var tween = create_tween()
	tween.tween_interval(2.0)
	tween.tween_callback(success_label.queue_free)

func _on_close_pressed():
	"""Boton CERRAR presionado."""
	close_shop()

func _on_background_input(event: InputEvent):
	"""Cierra la tienda si se hace click fuera del panel."""
	if event is InputEventMouseButton and event.pressed:
		close_shop()
