extends Node

const PLAYER_SCENE = preload("res://scenes/player/player.tscn")
const PLAYER_SPAWN_POSITION := Vector3(0, 1.0, 5)

func _ready():
	await get_tree().process_frame
	if GameSettings:
		GameSettings.apply_to_world_initializer(self)
	
	# Spawn player
	var player = PLAYER_SCENE.instantiate()
	add_child(player)
	player.global_position = PLAYER_SPAWN_POSITION
	print("WorldInit: Jugador spawneado")
	
	_spawn_particles()
	
	# Crear punto de respawn seguro si no existe
	_ensure_respawn_point()

func _ensure_respawn_point():
	"""Crea un Marker3D 'RespawnPoint' en la posicion de spawn segura si no existe."""
	var root = get_tree().current_scene
	if not root:
		return
	
	var existing = root.get_node_or_null("RespawnPoint")
	if existing:
		if existing is Marker3D:
			existing.global_position = PLAYER_SPAWN_POSITION
		return
	
	var respawn_marker = Marker3D.new()
	respawn_marker.name = "RespawnPoint"
	root.add_child(respawn_marker)
	respawn_marker.global_position = PLAYER_SPAWN_POSITION
	print("WorldInit: RespawnPoint creado en ", PLAYER_SPAWN_POSITION)


var day_time: float = 0.5  # Start at noon (0.0=midnight, 0.5=noon)
var day_speed: float = 0.001  # Lower value so time does not pass too fast

func _process(delta):
	_update_day_night(delta)

func _update_day_night(delta):
	day_time += delta * day_speed
	if day_time > 1.0:
		day_time -= 1.0
	
	var sun = get_node_or_null("../DirectionalLight3D")
	if not sun:
		return
	
	# Rotate sun based on time of day
	var angle = day_time * PI * 2.0
	sun.rotation.x = angle
	
	# Brightness: dim at night, bright at day
	var brightness = sin(day_time * PI)
	sun.light_energy = 0.3 + brightness * 1.0
	
	# Fog: thicker at night
	var env = get_node_or_null("../WorldEnvironment")
	if env and env.environment:
		env.environment.volumetric_fog_density = 0.008 + (1.0 - brightness) * 0.015
		env.environment.ambient_light_energy = 0.2 + brightness * 0.4
func _spawn_particles():
	var smoke = load("res://scenes/effects/smoke_particles.tscn")
	if not smoke:
		return
	# Add smoke to a few rooftop positions
	var positions = [
		Vector3(-18, 28, -28),
		Vector3(18, 26, -20),
		Vector3(-55, 8, -42),
	]
	for pos in positions:
		var p = smoke.instantiate()
		add_child(p)
		p.global_position = pos
	print("WorldInit: Smoke particles spawneados")
	_apply_toon_shader()

func _apply_toon_shader():
	var shader = load("res://shaders/low_poly_outline.gdshader")
	if not shader:
		print("WorldInit: Toon shader not found")
		return
	var count = 0
	var root = get_tree().current_scene
	if not root:
		return
	for mesh in root.find_children("*", "MeshInstance3D", true, false):
		if not mesh is MeshInstance3D:
			continue
		if mesh.mesh == null:
			continue
		if mesh.mesh is TextMesh:
			continue
		var pname = mesh.get_parent().name if mesh.get_parent() else ""
		if pname in ["SmokeParticles", "Projectile", "BarBackground", "BarForeground"]:
			continue
		var node_path := str(mesh.get_path())
		if (
			node_path.contains("/HUD") or
			node_path.contains("/SkillTree") or
			node_path.contains("/StatsPanel") or
			node_path.contains("/Inventory") or
			node_path.contains("/QuestLog") or
			node_path.contains("/ShopScreen") or
			node_path.contains("/NPC") or
			node_path.contains("/Player") or
			node_path.contains("/HealthBar")
		):
			continue
		if node_path.contains("LampPole_") or node_path.contains("LampGlobe_"):
			continue
		if node_path.contains("Hydrant_Street") or node_path.contains("GraffitiWall_Alley_"):
			continue
		var is_world_static := (
			node_path.contains("Building") or
			node_path.contains("Road") or
			node_path.contains("Street") or
			node_path.contains("Sidewalk") or
			node_path.contains("Lamp") or
			node_path.contains("Wall")
		)
		if not is_world_static:
			continue
		if mesh.name.contains("@"):
			continue
		var mat = ShaderMaterial.new()
		mat.shader = shader
		mat.set_shader_parameter("grosor_outline", 0.12)
		mat.set_shader_parameter("toon_steps", 3)
		mat.set_shader_parameter("color_outline", Color.BLACK)
		mesh.material_override = mat
		count += 1
	print("WorldInit: Toon shader applied to " + str(count) + " meshes")
