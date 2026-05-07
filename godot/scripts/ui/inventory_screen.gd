# ============================================================
# inventory_screen.gd — Pantalla de inventario
# Barrio Sin Ley Online (BSLO)
# Muestra el grid 8x10 con items placeholder y tooltips
# ============================================================
extends CanvasLayer

@onready var inventory_panel: Panel = $InventoryPanel
@onready var grid_container: GridContainer = $InventoryPanel/ItemGrid
@onready var close_button: Button = $InventoryPanel/CloseButton
@onready var weight_label: Label = $InventoryPanel/WeightLabel
@onready var tooltip_panel: Panel = $InventoryPanel/TooltipPanel
@onready var tooltip_name: Label = $InventoryPanel/TooltipPanel/TooltipName
@onready var tooltip_desc: Label = $InventoryPanel/TooltipPanel/TooltipDesc
@onready var tooltip_stats: Label = $InventoryPanel/TooltipPanel/TooltipStats

var placeholder_items: Array = []

func _ready():
	visible = false
	_apply_inventory_textures()

	if InventoryManager:
		InventoryManager.inventory_opened.connect(_on_inventory_opened)
		InventoryManager.inventory_closed.connect(_on_inventory_closed)
		InventoryManager.inventory_changed.connect(_refresh_grid)

	if close_button:
		close_button.pressed.connect(_on_close_pressed)

func _input(event: InputEvent):
	if event.is_action_pressed("toggle_inventory"):
		if InventoryManager:
			InventoryManager.toggle_inventory()


func _apply_inventory_textures():
	var inv_bg_tex = load("res://assets/ui/inventory_background.png")
	var inv_grid_tex = load("res://assets/ui/inventory_grid.png")
	
	var bg = get_node_or_null("InventoryPanel/InvBackground")
	if bg and bg is TextureRect and bg.texture == null:
		bg.texture = inv_bg_tex
		bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
func _on_inventory_opened():
	visible = true
	_refresh_grid()
	if InventoryManager:
		weight_label.text = "Peso: %.1f / %.1f kg" % [InventoryManager.get_total_weight(), InventoryManager.get_max_weight()]

func _on_inventory_closed():
	visible = false
	if tooltip_panel:
		tooltip_panel.visible = false

func _on_close_pressed():
	if InventoryManager:
		InventoryManager.close_inventory()

func _create_placeholder_items():
	placeholder_items.clear()

	placeholder_items.append({
		"name": "Machete",
		"desc": "Un machete oxidado pero afilado.\nUtil en las calles del barrio.",
		"type": "Arma",
		"color": Color(0.5, 0.5, 0.5),
		"stats": "Dano: 15\nVelocidad: 1.2\nTipo: Melee",
		"quantity": 1
	})

	placeholder_items.append({
		"name": "Pistola 9mm",
		"desc": "Pistola semiautomatica.\nMunicion escasa pero efectiva.",
		"type": "Arma",
		"color": Color(0.25, 0.25, 0.3),
		"stats": "Dano: 25\nAlcance: 20m\nTipo: Ranged",
		"quantity": 1
	})

	placeholder_items.append({
		"name": "Municion 9mm",
		"desc": "Caja de 50 balas calibre 9mm.\nEstandar del barrio.",
		"type": "Municion",
		"color": Color(0.8, 0.7, 0.2),
		"stats": "Cantidad: 50\nCalibre: 9mm\nPeso: 0.05 kg/u",
		"quantity": 50
	})

	placeholder_items.append({
		"name": "Taco",
		"desc": "Un taco callejero bien cargado.\nRecupera 20 HP al instante.",
		"type": "Consumible",
		"color": Color(0.9, 0.6, 0.2),
		"stats": "Curacion: +20 HP\nTiempo: Instantaneo",
		"quantity": 3
	})

	placeholder_items.append({
		"name": "Cerveza",
		"desc": "Cerveza fria del barrio.\n+10 Stamina, -2 INT temporal.",
		"type": "Consumible",
		"color": Color(0.85, 0.7, 0.1),
		"stats": "Stamina: +10\nEfecto: -2 INT (30s)",
		"quantity": 5
	})

	placeholder_items.append({
		"name": "Chatarra",
		"desc": "Piezas de metal y electronica.\nSe puede vender por PB.",
		"type": "Material",
		"color": Color(0.5, 0.45, 0.4),
		"stats": "Valor: 5 PB\nPeso: 2 kg\nUso: Venta/Crafteo",
		"quantity": 12
	})

	placeholder_items.append({
		"name": "Llave Oxidada",
		"desc": "Una llave vieja y oxidada.\nAbre algo... probablemente.",
		"type": "Llave",
		"color": Color(0.7, 0.55, 0.3),
		"stats": "Uso: Desconocido\nOrigen: Callejon Sur",
		"quantity": 1
	})

	placeholder_items.append({
		"name": "Vendaje",
		"desc": "Vendaje esteril improvisado.\nDetiene hemorragias leves.",
		"type": "Consumible",
		"color": Color(0.95, 0.95, 0.9),
		"stats": "Curacion: +10 HP\nEfecto: Anti-sangrado",
		"quantity": 4
	})

func _refresh_grid():
	for child in grid_container.get_children():
		child.queue_free()

	if not InventoryManager:
		return

	var visited := {}

	for row in range(InventoryManager.GRID_ROWS):
		for col in range(InventoryManager.GRID_COLS):
			var slot = Panel.new()
			slot.custom_minimum_size = Vector2(80, 80)
			slot.mouse_filter = Control.MOUSE_FILTER_STOP

			var style = StyleBoxFlat.new()
			style.bg_color = Color(0.2, 0.15, 0.1, 0.9)
			style.border_width_left = 1
			style.border_width_top = 1
			style.border_width_right = 1
			style.border_width_bottom = 1
			style.border_color = Color(0.6, 0.5, 0.4, 1)
			style.corner_radius_top_left = 3
			style.corner_radius_top_right = 3
			style.corner_radius_bottom_right = 3
			style.corner_radius_bottom_left = 3
			slot.add_theme_stylebox_override("panel", style)

			var cell = InventoryManager.inventory[col][row]
			var key = Vector2i(col, row)
			if cell != null and not visited.has(key):
				var item: Resource = cell["item"]
				var qty: int = cell["quantity"]
				for c in range(col, col + item.grid_width):
					for r in range(row, row + item.grid_height):
						visited[Vector2i(c, r)] = true

				var item_info = {
					"name": item.item_name,
					"desc": item.description,
					"type": str(item.item_type),
					"color": item.get_rarity_color(),
					"stats": _build_item_stats_text(item, qty),
					"quantity": qty
				}

				var vbox = VBoxContainer.new()
				vbox.alignment = BoxContainer.ALIGNMENT_CENTER
				vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE

				var icon_bg = ColorRect.new()
				icon_bg.custom_minimum_size = Vector2(40, 40)
				icon_bg.color = item.get_rarity_color()
				icon_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
				vbox.add_child(icon_bg)

				var short_name = Label.new()
				short_name.text = item.item_name.substr(0, mini(3, item.item_name.length())).to_upper()
				short_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
				short_name.add_theme_font_size_override("font_size", 9)
				short_name.add_theme_color_override("font_color", Color.BLACK)
				short_name.mouse_filter = Control.MOUSE_FILTER_IGNORE
				vbox.add_child(short_name)

				var name_label = Label.new()
				name_label.text = item.item_name
				name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
				name_label.add_theme_font_size_override("font_size", 10)
				name_label.add_theme_color_override("font_color", Color.WHITE)
				name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
				vbox.add_child(name_label)

				if qty > 1:
					var qty_label = Label.new()
					qty_label.text = "x" + str(qty)
					qty_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
					qty_label.add_theme_font_size_override("font_size", 9)
					qty_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
					qty_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
					vbox.add_child(qty_label)

				slot.add_child(vbox)
				slot.mouse_entered.connect(_show_tooltip.bind(item_info))
				slot.mouse_exited.connect(_hide_tooltip)

			grid_container.add_child(slot)

func _build_item_stats_text(item: Resource, qty: int) -> String:
	var lines: Array[String] = []
	lines.append("Cantidad: %d" % qty)
	lines.append("Peso total: %.1f kg" % (item.weight * qty))
	lines.append("Valor: %d PB" % item.base_value)
	if item.damage > 0:
		lines.append("Danio: %d" % item.damage)
	if item.defense > 0:
		lines.append("Defensa: %d" % item.defense)
	if item.heal_amount > 0:
		lines.append("Cura: +%d HP" % item.heal_amount)
	if item.stamina_restore > 0:
		lines.append("Stamina: +%d" % item.stamina_restore)
	return "\n".join(lines)

func _show_tooltip(item: Dictionary):
	if tooltip_panel:
		tooltip_panel.visible = true
		tooltip_name.text = item["name"]
		tooltip_desc.text = item["desc"]
		tooltip_stats.text = item["stats"]

func _hide_tooltip():
	if tooltip_panel:
		tooltip_panel.visible = false
