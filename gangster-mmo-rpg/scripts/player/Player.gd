extends CharacterBody3D
class_name Player

## Jugador principal del Gangster MMO RPG
## Movimiento WASD con cambio de cámara primera/tercera persona

@export_group("Movement")
@export var move_speed: float = 5.0
@export var sprint_speed: float = 8.0
@export var jump_velocity: float = 4.5
@export var mouse_sensitivity: float = 0.003
@export var rotation_speed: float = 10.0

@export_group("Camera")
@export var third_person_distance: float = 5.0
@export var third_person_height: float = 2.0
@export var first_person_height: float = 1.7
@export var camera_lerp_speed: float = 8.0

@export_group("Stats")
@export var max_health: float = 100.0
@export var health: float = 100.0
@export var flow_level: int = 1
@export var street_cred: int = 0

# Referencias a nodos
@onready var camera_controller: Node3D = $CameraController
@onready var camera_arm: SpringArm3D = $CameraController/CameraArm
@onready var camera: Camera3D = $CameraController/CameraArm/Camera3D
@onready var first_person_camera: Camera3D = $CameraController/FirstPersonCamera
@onready var mesh_instance: MeshInstance3D = $PlayerMesh
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

# Variables de movimiento
var is_sprinting: bool = false
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var input_vector: Vector2 = Vector2.ZERO
var last_direction: Vector3 = Vector3.ZERO

# Variables de cámara
enum CameraMode { THIRD_PERSON, FIRST_PERSON }
var current_camera_mode: CameraMode = CameraMode.THIRD_PERSON
var camera_rotation: Vector2 = Vector2.ZERO

# Variables de items equipados
var equipped_weapon = null
var equipped_clothing: Array = []
var current_flow_bonus: float = 0.0

signal health_changed(new_health: float)
signal flow_changed(new_flow: int)
signal item_equipped(item)
signal camera_changed(new_mode: CameraMode)

func _ready():
	setup_camera_system()
	setup_input()
	print("🎮 Gangster spawneado - Level: %d, Street Cred: %d" % [flow_level, street_cred])
	print("📹 Controles: WASD = Movimiento, Mouse = Cámara, V = Cambiar vista, Shift = Correr")

func setup_camera_system():
	# Configurar SpringArm para tercera persona
	if camera_arm:
		camera_arm.collision_mask = 1  # Solo colisionar con environment
		camera_arm.spring_length = third_person_distance
		camera_arm.position.y = third_person_height
	
	# Posicionar cámara de primera persona
	if first_person_camera:
		first_person_camera.position.y = first_person_height
		first_person_camera.current = false
	
	# Activar cámara inicial
	set_camera_mode(CameraMode.THIRD_PERSON)

func setup_input():
	# Capturar mouse para controlar cámara
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# Rotación de cámara con mouse
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		handle_mouse_look(event)
	
	# Cambio de cámara
	if event.is_action_pressed("camera_toggle"):
		toggle_camera()
	
	# Toggle inventario
	if event.is_action_pressed("inventory"):
		toggle_inventory()
	
	# Sprint
	handle_sprint_input(event)
	
	# Escape para liberar mouse
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func handle_mouse_look(event: InputEventMouseMotion):
	# Rotar el controlador de cámara horizontalmente
	camera_controller.rotate_y(-event.relative.x * mouse_sensitivity)
	
	# Rotar verticalmente (pitch)
	camera_rotation.y += -event.relative.y * mouse_sensitivity
	camera_rotation.y = clamp(camera_rotation.y, -1.5, 1.5)
	
	# Aplicar rotación vertical al brazo de cámara
	if camera_arm:
		camera_arm.rotation.x = camera_rotation.y

func handle_sprint_input(event: InputEvent):
	if event.is_action_pressed("sprint"):
		is_sprinting = true
		print("🏃‍♂️ Sprint activado!")
	elif event.is_action_released("sprint"):
		is_sprinting = false

func _physics_process(delta):
	handle_gravity(delta)
	handle_jump()
	handle_movement(delta)
	move_and_slide()

func handle_gravity(delta):
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y -= gravity * delta

func handle_jump():
	# Salto
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		print("🦘 ¡Salto chunky!")

func handle_movement(delta):
	# Obtener input de movimiento WASD
	input_vector = Vector2()
	
	if Input.is_action_pressed("move_up"):
		input_vector.y -= 1
	if Input.is_action_pressed("move_down"):
		input_vector.y += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	
	# Normalizar input para movimiento diagonal consistente
	if input_vector.length() > 0:
		input_vector = input_vector.normalized()
		
		# Calcular velocidad con bonificaciones de items
		var current_speed = sprint_speed if is_sprinting else move_speed
		current_speed += get_speed_bonus_from_items()
		
		# Movimiento relativo a la cámara
		var camera_forward = -camera_controller.transform.basis.z
		var camera_right = camera_controller.transform.basis.x
		
		# Proyectar al plano horizontal
		camera_forward.y = 0
		camera_right.y = 0
		camera_forward = camera_forward.normalized()
		camera_right = camera_right.normalized()
		
		# Calcular dirección de movimiento
		var move_direction = (camera_forward * input_vector.y + camera_right * input_vector.x)
		
		# Aplicar movimiento horizontal
		velocity.x = move_direction.x * current_speed
		velocity.z = move_direction.z * current_speed
		
		# Rotar el personaje hacia la dirección de movimiento
		rotate_player_towards_movement(move_direction, delta)
		
		last_direction = move_direction
	else:
		# Decelerar cuando no hay input
		velocity.x = move_toward(velocity.x, 0, move_speed * 3 * delta)
		velocity.z = move_toward(velocity.z, 0, move_speed * 3 * delta)

func rotate_player_towards_movement(direction: Vector3, delta: float):
	if direction.length() > 0.1:
		var target_rotation = atan2(direction.x, direction.z)
		var current_rotation = rotation.y
		
		# Interpolar suavemente la rotación
		var angle_diff = angle_difference(target_rotation, current_rotation)
		rotation.y += angle_diff * rotation_speed * delta

func toggle_camera():
	match current_camera_mode:
		CameraMode.THIRD_PERSON:
			set_camera_mode(CameraMode.FIRST_PERSON)
		CameraMode.FIRST_PERSON:
			set_camera_mode(CameraMode.THIRD_PERSON)

func set_camera_mode(mode: CameraMode):
	current_camera_mode = mode
	
	match mode:
		CameraMode.THIRD_PERSON:
			camera.current = true
			first_person_camera.current = false
			show_player_mesh(true)
			print("📹 Cámara: Tercera persona")
			
		CameraMode.FIRST_PERSON:
			camera.current = false
			first_person_camera.current = true
			show_player_mesh(false)
			print("👁️ Cámara: Primera persona")
	
	camera_changed.emit(current_camera_mode)

func show_player_mesh(visible: bool):
	if mesh_instance:
		mesh_instance.visible = visible

func get_speed_bonus_from_items() -> float:
	var bonus: float = 0.0
	for clothing in equipped_clothing:
		if clothing and clothing.has_method("get_stat") and clothing.has_stat("movement_speed"):
			bonus += clothing.get_stat("movement_speed") / 100.0 * move_speed
	return bonus

func equip_item(item):
	if not item:
		return false
	
	print("🎽 Equipando: %s (+%d flow)" % [item.item_name, item.flow_bonus])
	equipped_clothing.append(item)
	item_equipped.emit(item)
	update_flow_level()
	return true

func update_flow_level():
	var total_flow = 0
	
	for clothing in equipped_clothing:
		if clothing:
			total_flow += clothing.flow_bonus
	
	current_flow_bonus = total_flow
	flow_changed.emit(flow_level + int(current_flow_bonus / 10))

func take_damage(damage: float, source: String = ""):
	health = max(0, health - damage)
	health_changed.emit(health)
	
	print("💥 Took %d damage from %s (Health: %.0f/%.0f)" % [damage, source, health, max_health])
	
	if health <= 0:
		die()

func die():
	print("💀 Player died - respawning...")
	# TODO: Implementar respawn

func heal(amount: float):
	health = min(max_health, health + amount)
	health_changed.emit(health)

func add_street_cred(amount: int):
	street_cred += amount
	print("📈 Street Cred +%d (Total: %d)" % [amount, street_cred])

func toggle_inventory():
	print("🎒 Toggle inventory (TODO: implementar UI)")

func print_stats():
	print("=== PLAYER STATS ===")
	print("Flow Level: %d (+%.1f from items)" % [flow_level, current_flow_bonus])
	print("Street Cred: %d" % street_cred)
	print("Health: %.0f/%.0f" % [health, max_health])
	print("Camera Mode: %s" % CameraMode.keys()[current_camera_mode])
	print("Clothing items: %d equipped" % equipped_clothing.size())
	print("==================")

# Función helper para calcular diferencia de ángulos
func angle_difference(target: float, current: float) -> float:
	var diff = target - current
	while diff > PI:
		diff -= TAU
	while diff < -PI:
		diff += TAU
	return diff
