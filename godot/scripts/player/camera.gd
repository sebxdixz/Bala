# ============================================================
# camera.gd — Controlador de camara independiente
# Barrio Sin Ley Online (BSLO)
#   - Modo 3ra persona: orbita a 3-8m, rotacion libre con mouse
#   - Modo 1ra persona: toggle suave
#   - Deteccion de colision con el entorno (no atraviesa paredes)
#   - Zoom con scroll entre 3m y 8m (suave)
#   - Seguimiento fluido del jugador
# ============================================================
extends Node3D

# Senales
signal zoom_changed(new_distance: float)
signal view_toggled(is_first_person: bool)

# Referencia al jugador
@export var player: Node3D = null

# Configuracion de camara
@export var default_distance: float = 5.0
@export var min_distance: float = 3.0
@export var max_distance: float = 8.0
@export var mouse_sensitivity: float = 0.0012
@export var angle_min: float = -40.0  # grados, limite vertical superior
@export var angle_max: float = 80.0   # grados, limite vertical inferior
@export var smooth_speed: float = 7.0
@export var first_person_offset: Vector3 = Vector3(0.0, 1.7, 0.0)
@export var third_person_offset: Vector3 = Vector3(0.0, 1.5, 0.0)

# Estado interno
var camera_rotation_x: float = 0.0  # Vertical (pitch)
var camera_rotation_y: float = 0.0  # Horizontal (yaw)
var current_distance: float = 5.0
var target_distance: float = 5.0
var is_first_person: bool = false
var is_transitioning: bool = false
var transition_progress: float = 0.0

# Referencias a nodos internos
@onready var camera_3d: Camera3D = $Camera3D

func _ready():
	"""Configuracion inicial de la camara."""
	if not player:
		var players = get_tree().get_nodes_in_group("players")
		if players.size() > 0:
			player = players[0]

	current_distance = default_distance
	target_distance = default_distance

	_apply_camera_position()

func _input(event: InputEvent):
	"""Procesa eventos de input para la camara.

	- Mouse motion: rotacion orbital
	- Scroll: zoom (solo en 3ra persona)
	- Tecla V: toggle de vista
	"""
	if not player:
		return

	# Rotacion con mouse
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		camera_rotation_y -= event.relative.x * mouse_sensitivity
		camera_rotation_x -= event.relative.y * mouse_sensitivity
		camera_rotation_x = deg_to_rad(clampf(
			rad_to_deg(camera_rotation_x),
			angle_min,
			angle_max
		))

	# Zoom con scroll (solo en 3ra persona)
	if not is_first_person and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_distance = clampf(target_distance - 0.5, min_distance, max_distance)
			zoom_changed.emit(target_distance)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_distance = clampf(target_distance + 0.5, min_distance, max_distance)
			zoom_changed.emit(target_distance)

	# Toggle vista
	if event.is_action_pressed("toggle_camera"):
		toggle_view()

func _process(delta: float):
	"""Actualiza la posicion de la camara cada frame."""
	if not player:
		return

	# Interpolar distancia de zoom suavemente
	current_distance = lerpf(current_distance, target_distance, smooth_speed * delta)

	# Transicion entre 1ra y 3ra persona
	if is_transitioning:
		transition_progress += delta * 5.0
		if transition_progress >= 1.0:
			transition_progress = 1.0
			is_transitioning = false

	_apply_camera_position()

func _apply_camera_position():
	"""Aplica la posicion y rotacion calculada a la camara."""
	if not player:
		return

	# Seguir al jugador
	global_position = player.global_position

	if is_first_person:
		# 1ra persona: camara en los ojos
		position = first_person_offset
		rotation = Vector3(camera_rotation_x, 0.0, 0.0)
	else:
		# 3ra persona: orbita alrededor del jugador
		position = third_person_offset

		# Calcular offset orbital
		var horizontal = camera_rotation_y
		var vertical = camera_rotation_x

		var offset = Vector3(0.0, 0.0, current_distance)
		var rotated_offset = offset.rotated(Vector3.RIGHT, vertical)
		rotated_offset = rotated_offset.rotated(Vector3.UP, horizontal)

		var desired_pos = position + rotated_offset
		var final_pos = desired_pos

		# Colision con el entorno (no atravesar paredes)
		var space_state = get_world_3d().direct_space_state
		if space_state:
			var from = player.global_position + third_person_offset
			var to = player.global_position + desired_pos

			var query = PhysicsRayQueryParameters3D.create(from, to)
			query.exclude = [player, self]
			query.collision_mask = 1  # Layer 1 = World

			var result = space_state.intersect_ray(query)
			if result:
				var hit_distance = from.distance_to(result.position) - 0.3
				if hit_distance < current_distance:
					var collision_offset = rotated_offset.normalized() * hit_distance
					final_pos = position + collision_offset

		camera_3d.position = final_pos
		# La rotacion del pivot ya orienta la camara
		rotation = Vector3(vertical, horizontal, 0.0)
		# Asegurar que la camara mire hacia el jugador
		camera_3d.look_at(player.global_position + third_person_offset, Vector3.UP)

# ============================================================
# METODOS PUBLICOS
# ============================================================

func toggle_view():
	"""Alterna entre 1ra y 3ra persona con transicion suave."""
	is_first_person = not is_first_person
	is_transitioning = true
	transition_progress = 0.0

	if is_first_person:
		# Al entrar en 1ra persona, resetear rotacion horizontal
		pass

	view_toggled.emit(is_first_person)

func set_first_person(enabled: bool):
	"""Fuerza un modo de vista especifico."""
	if enabled != is_first_person:
		toggle_view()

func set_distance(new_distance: float):
	"""Establece la distancia de la camara (zoom)."""
	target_distance = clampf(new_distance, min_distance, max_distance)
	zoom_changed.emit(target_distance)

func reset_camera():
	"""Resetea la camara a la posicion por defecto."""
	camera_rotation_x = 0.0
	camera_rotation_y = 0.0
	target_distance = default_distance
	current_distance = default_distance
	is_first_person = false
	is_transitioning = false
	transition_progress = 0.0
	view_toggled.emit(false)

func look_at_target(target: Vector3):
	"""Hace que la camara mire hacia un punto especifico."""
	if not player:
		return

	var direction = (target - player.global_position).normalized()
	camera_rotation_y = atan2(-direction.x, -direction.z)
	camera_rotation_x = asin(direction.y)
	camera_rotation_x = clampf(camera_rotation_x,
		deg_to_rad(angle_min),
		deg_to_rad(angle_max))
