# ============================================================
# crafting_ui.gd -- Crafting UI
# Barrio Sin Ley Online (BSLO)
# Interfaz de crafteo: panel oscuro con recetas y botones craft.
# ============================================================
extends CanvasLayer

@onready var _overlay: ColorRect = $Overlay
@onready var _panel: Panel = $CenterPanel
@onready var _recipe_container: VBoxContainer = $CenterPanel/MarginContainer/VBoxMain/ScrollContainer/RecipeContainer
@onready var _close_button: Button = $CenterPanel/MarginContainer/VBoxMain/BottomBar/CloseButton
@onready var _message_label: Label = $CenterPanel/MarginContainer/VBoxMain/MessageLabel

func _ready():
	visible = false
	_close_button.pressed.connect(_on_close_pressed)
	_refresh_recipes()

func _input(event: InputEvent):
	if event.is_action_pressed("toggle_crafting"):
		toggle()

	if visible and event.is_action_pressed("ui_cancel"):
		_close()
		get_viewport().set_input_as_handled()

func toggle():
	visible = not visible
	if visible:
		_refresh_recipes()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _close():
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_close_pressed():
	_close()

func _refresh_recipes():
	if not CraftingSystem:
		return

	for child in _recipe_container.get_children():
		child.queue_free()

	var all_recipes = CraftingSystem.get_all_recipes()
	for recipe in all_recipes:
		var recipe_panel = _create_recipe_entry(recipe)
		_recipe_container.add_child(recipe_panel)

func _create_recipe_entry(recipe: Dictionary) -> Panel:
	var panel = Panel.new()
	panel.custom_minimum_size = Vector2(0, 80)
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.08, 0.14, 0.95)
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.border_color = Color(0.3, 0.3, 0.4, 0.5)
	style.corner_radius_top_left = 6
	style.corner_radius_top_right = 6
	style.corner_radius_bottom_right = 6
	style.corner_radius_bottom_left = 6
	panel.add_theme_stylebox_override("panel", style)

	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 12)
	hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.add_child(hbox)

	var info_vbox = VBoxContainer.new()
	info_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info_vbox.add_theme_constant_override("separation", 4)
	hbox.add_child(info_vbox)

	var name_label = Label.new()
	name_label.text = recipe["name"]
	name_label.add_theme_color_override("font_color", Color(1, 0.8, 0.2, 1))
	name_label.add_theme_font_size_override("font_size", 16)
	info_vbox.add_child(name_label)

	var ing_str = ""
	for ing_id in recipe["ingredients"]:
		var status = recipe["ingredients_status"].get(ing_id, {})
		var required_qty = recipe["ingredients"][ing_id]
		var has_qty = status.get("has", 0)
		var enough = status.get("enough", false)

		var item_name = ing_id.replace("_", " ").capitalize()
		ing_str += "[%d/%d %s] " % [has_qty, required_qty, item_name]

	var ing_label = Label.new()
	ing_label.text = "Ingredientes: " + ing_str.strip_edges()
	ing_label.add_theme_font_size_override("font_size", 12)
	if recipe.get("can_craft", false):
		ing_label.add_theme_color_override("font_color", Color(0.3, 0.9, 0.3, 1))
	else:
		ing_label.add_theme_color_override("font_color", Color(0.9, 0.2, 0.2, 1))
	info_vbox.add_child(ing_label)

	var desc_label = Label.new()
	desc_label.text = recipe.get("description", "")
	desc_label.add_theme_color_override("font_color", Color(0.5, 0.5, 0.6, 1))
	desc_label.add_theme_font_size_override("font_size", 11)
	info_vbox.add_child(desc_label)

	var lvl_label = Label.new()
	lvl_label.text = "Nivel requerido: %d" % recipe.get("required_level", 1)
	lvl_label.add_theme_color_override("font_color", Color(0.6, 0.6, 0.7, 1))
	lvl_label.add_theme_font_size_override("font_size", 11)
	info_vbox.add_child(lvl_label)

	var craft_btn = Button.new()
	craft_btn.text = "CRAFT"
	craft_btn.custom_minimum_size = Vector2(100, 40)
	craft_btn.add_theme_font_size_override("font_size", 14)

	var btn_style = StyleBoxFlat.new()
	btn_style.corner_radius_top_left = 4
	btn_style.corner_radius_top_right = 4
	btn_style.corner_radius_bottom_right = 4
	btn_style.corner_radius_bottom_left = 4

	if recipe.get("can_craft", false):
		btn_style.bg_color = Color(0.1, 0.5, 0.1, 0.9)
		btn_style.border_color = Color(0.2, 0.8, 0.2, 0.8)
		craft_btn.add_theme_color_override("font_color", Color(0.3, 1, 0.3, 1))
		craft_btn.disabled = false
	else:
		btn_style.bg_color = Color(0.3, 0.1, 0.1, 0.7)
		btn_style.border_color = Color(0.5, 0.15, 0.15, 0.5)
		craft_btn.add_theme_color_override("font_color", Color(0.5, 0.3, 0.3, 1))
		craft_btn.disabled = true

	btn_style.border_width_left = 1
	btn_style.border_width_top = 1
	btn_style.border_width_right = 1
	btn_style.border_width_bottom = 1
	craft_btn.add_theme_stylebox_override("normal", btn_style)

	var recipe_id: String = recipe.get("recipe_id", "")
	craft_btn.pressed.connect(_on_craft_pressed.bind(recipe_id))

	var btn_container = VBoxContainer.new()
	btn_container.add_theme_constant_override("separation", 0)
	btn_container.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	btn_container.add_child(craft_btn)

	hbox.add_child(btn_container)

	return panel

func _on_craft_pressed(recipe_id: String):
	if not CraftingSystem:
		return

	var success = CraftingSystem.craft(recipe_id)
	if success:
		_show_message("Crafteado con exito!", Color(0.2, 1, 0.2, 1))
		await get_tree().create_timer(0.3).timeout
		_refresh_recipes()
	else:
		_show_message("No se pudo craftear. Revisa los ingredientes.", Color(1, 0.2, 0.2, 1))
		_refresh_recipes()

func _show_message(text: String, color: Color):
	_message_label.text = text
	_message_label.add_theme_color_override("font_color", color)
	_message_label.visible = true
	var tween = create_tween()
	tween.tween_property(_message_label, "visible", false, 3.0).set_delay(2.0)
