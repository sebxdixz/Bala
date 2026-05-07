# ============================================================
# loot_item.gd â€” Loot Item in World
# Barrio Sin Ley Online (BSLO)
# Area3D que representa un item dropeado en el mundo.
# El jugador lo recoge al pasar sobre el.
# ============================================================
extends Area3D

# Item a recoger (ID de la base de datos)
@export var item_id: String = ""
@export var item_data: Resource = null
@export var quantity: int = 1
@export var pb_amount: int = 0

# Animacion
@export var spin_speed: float = 2.0
@export var bob_height: float = 0.15
@export var bob_speed: float = 2.0

var _base_y: float = 0.0
var _bob_time: float = 0.0
var _life_timer: float = 0.0
const MAX_LIFETIME: float = 120.0
var _player_in_range: Node3D = null
var _prompt_label: Label3D = null

func _ready():
	"""Configura el area de colision y animacion."""
	add_to_group("loot_items")
	_snap_to_ground()
	_base_y = global_position.y
	_bob_time = randf() * TAU  # Random start offset
	_life_timer = 0.0

	# Conectar senial de colision
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	_create_prompt_label()

func _snap_to_ground():
	"""Ajusta el loot para que caiga visualmente al piso al spawnear."""
	var world := get_world_3d()
	if not world:
		return
	var space_state = world.direct_space_state
	var from = global_position + Vector3(0.0, 2.0, 0.0)
	var to = global_position + Vector3(0.0, -8.0, 0.0)
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.exclude = [self]
	query.collision_mask = 1
	var hit = space_state.intersect_ray(query)
	if hit and hit.has("position"):
		global_position.y = hit.position.y + 0.25

func _process(delta: float):
	"""Animacion de rotacion, bobbing y auto-destruccion."""
	# Rotar lentamente
	rotate_y(spin_speed * delta)

	# Flotar arriba y abajo
	_bob_time += delta * bob_speed
	var bob_offset = sin(_bob_time) * bob_height
	global_position.y = _base_y + bob_offset

	# Auto-destruir despues de MAX_LIFETIME segundos
	_life_timer += delta
	if _life_timer >= MAX_LIFETIME:
		queue_free()
	_handle_pickup_input()

func _on_body_entered(body: Node3D):
	"""Callback cuando un cuerpo entra en el area de colision.
	
	Solo reacciona si el cuerpo es el jugador (grupo 'players').
	"""
	if not body or not body.is_in_group("players"):
		return
	_player_in_range = body
	_set_prompt_visible(true)

func _on_body_exited(body: Node3D):
	if body == _player_in_range:
		_player_in_range = null
		_set_prompt_visible(false)

func _handle_pickup_input():
	if _player_in_range and Input.is_action_just_pressed("interact"):
		_try_pickup(_player_in_range)

func _try_pickup(_player: Node3D):
	var item_name = ""
	var picked = false

	# Recoger item por ID
	if item_id != "":
		if not InventoryManager:
			_show_pickup_text("Inventario no disponible", Color(1.0, 0.3, 0.3, 1.0), false)
			_notify_hud("No se pudo recoger: inventario no disponible")
			return
		var success = InventoryManager.add_item_by_id(item_id, quantity)
		if not success:
			_show_pickup_text("Inventario lleno/sobrepeso", Color(1.0, 0.3, 0.3, 1.0), false)
			_notify_hud("No se pudo recoger %s: inventario lleno o sobrepeso" % _get_item_display_name(item_id))
			return
		item_name = _get_item_display_name(item_id)
		# Track collect quest progress
		if QuestManager:
			QuestManager.update_progress_collect(item_id, quantity)
		picked = true
		print("Loot: +", item_name, " (x", quantity, ")")
		_notify_hud("Recogiste %s x%d" % [item_name, quantity])

		# Recoger PB (dinero)
	if pb_amount > 0:
		item_name = "PB"
		if StatsManager:
			StatsManager.add_pb(pb_amount)
		print("Loot: +", pb_amount, " PB")
		picked = true
		_notify_hud("Recogiste %d PB" % pb_amount)

	if picked:
		# Mostrar texto flotante
		_show_pickup_text(item_name)

		# Sonido de recogida (placeholder)
		_play_pickup_sound()

		# Destruir el item
		queue_free()

func _create_prompt_label():
	_prompt_label = Label3D.new()
	_prompt_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	_prompt_label.font_size = 18
	_prompt_label.position = Vector3(0.0, 1.0, 0.0)
	_prompt_label.visible = false
	add_child(_prompt_label)

func _set_prompt_visible(is_visible: bool):
	if not _prompt_label:
		return
	if is_visible:
		_prompt_label.text = get_interaction_prompt(true)
	_prompt_label.visible = is_visible

func get_interaction_name() -> String:
	if pb_amount > 0:
		return "%d PB" % pb_amount
	return "%s x%d" % [_get_item_display_name(item_id), quantity]

func can_player_interact(player: Node3D) -> bool:
	if not player or not is_instance_valid(player):
		return false
	return _player_in_range == player

func get_interaction_prompt(can_interact: bool) -> String:
	var base_text = "Recoger %s" % get_interaction_name()
	if can_interact:
		return "[F] " + base_text
	return base_text

func _get_item_display_name(id: String) -> String:
	"""Obtiene el nombre visible del item desde la base de datos."""
	if ItemDatabase:
		var data = ItemDatabase.get_item(id)
		if data:
			return data.item_name
	return id

func _show_pickup_text(item_name: String, color: Color = Color(1.0, 1.0, 0.3, 1.0), use_plus: bool = true):
	"""Muestra un texto flotante '+ItemName' sobre el item."""
	var label = Label3D.new()
	label.text = ("+" if use_plus else "") + item_name
	label.font_size = 24
	label.modulate = color
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.position = Vector3(0.0, 1.0, 0.0)
	add_child(label)

	# Animar flotando hacia arriba y desapareciendo
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(label, "position:y", 2.5, 1.0)
	tween.tween_property(label, "modulate:a", 0.0, 0.8)
	tween.chain()
	tween.tween_callback(label.queue_free)

func _notify_hud(message: String):
	var huds = get_tree().get_nodes_in_group("hud")
	if huds.size() > 0:
		var hud = huds[0]
		if hud and hud.has_method("show_combat_log"):
			hud.show_combat_log(message)

func _play_pickup_sound():
	"""Reproduce sonido de recogida (placeholder por ahora)."""
	print("Click")
