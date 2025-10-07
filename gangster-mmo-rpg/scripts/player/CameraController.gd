extends Node3D
class_name CameraController

## Controlador de cámara para el sistema de primera/tercera persona
## Maneja transiciones suaves y configuraciones específicas para cada modo

@export var smooth_transitions: bool = true
@export var transition_speed: float = 5.0

@onready var camera_arm: SpringArm3D = $CameraArm
@onready var third_person_camera: Camera3D = $CameraArm/Camera3D
@onready var first_person_camera: Camera3D = $FirstPersonCamera

var is_transitioning: bool = false
var transition_timer: float = 0.0

func _ready():
	setup_cameras()

func setup_cameras():
	# Configurar SpringArm para tercera persona
	if camera_arm:
		camera_arm.collision_mask = 2  # Layer de environment
		camera_arm.margin = 0.2
	
	print("📹 CameraController inicializado")

func _process(delta):
	if is_transitioning:
		handle_transition(delta)

func handle_transition(delta):
	transition_timer += delta
	
	if transition_timer >= 1.0 / transition_speed:
		is_transitioning = false
		transition_timer = 0.0

func switch_to_third_person():
	if third_person_camera:
		third_person_camera.current = true
	if first_person_camera:
		first_person_camera.current = false
	
	if smooth_transitions:
		start_transition()

func switch_to_first_person():
	if first_person_camera:
		first_person_camera.current = true
	if third_person_camera:
		third_person_camera.current = false
		
	if smooth_transitions:
		start_transition()

func start_transition():
	is_transitioning = true
	transition_timer = 0.0

func get_current_camera() -> Camera3D:
	if first_person_camera and first_person_camera.current:
		return first_person_camera
	elif third_person_camera and third_person_camera.current:
		return third_person_camera
	return null

func set_camera_sensitivity(sensitivity: float):
	# Aplicar sensibilidad a ambas cámaras si es necesario
	pass

func get_forward_direction() -> Vector3:
	return -global_transform.basis.z
	
func get_right_direction() -> Vector3:
	return global_transform.basis.x
