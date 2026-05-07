# ============================================================

# level_up_burst.gd -- Level up celebration effect

# Barrio Sin Ley Online (BSLO)

# Fountain of colored particles that burst upward, then float down.

# Duration: 3 seconds total. Auto-destroys.

# ============================================================

extends Node3D



@export var burst_duration: float = 2.0

@export var particle_count: int = 20



var palette_colors: Array = [

	Color(1.0, 0.0, 1.0, 1.0),   # magenta

	Color(0.0, 1.0, 1.0, 1.0),   # cyan

	Color(1.0, 0.85, 0.0, 1.0),  # gold

	Color(1.0, 0.5, 0.0, 1.0),   # orange

]



func _ready():

	spawn_burst()

	await get_tree().create_timer(burst_duration + 0.5).timeout

	queue_free()



func spawn_burst():

	for i in range(particle_count):

		var particle = MeshInstance3D.new()

		var box = BoxMesh.new()

		box.size = Vector3(0.08, 0.08, 0.08)

		particle.mesh = box



		var color = palette_colors[i % palette_colors.size()]

		var mat = StandardMaterial3D.new()

		mat.albedo_color = color

		mat.emission_enabled = true

		mat.emission = color

		mat.emission_energy_multiplier = 3.0

		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA

		particle.material_override = mat



		particle.name = "BurstParticle_" + str(i)

		add_child(particle)



		var angle = randf_range(0.0, TAU)

		var radius = randf_range(0.2, 1.2)

		var rise_height = randf_range(1.5, 3.5)

		var rise_target = Vector3(

			cos(angle) * radius,

			rise_height,

			sin(angle) * radius

		)



		var tween = create_tween()

		tween.set_parallel(true)

		# Rise: 0 to 1s

		tween.tween_property(particle, "position", rise_target, 1.0)

		tween.tween_property(particle, "scale", Vector3(1.5, 1.5, 1.5), 0.5)

		# Float down: 1s to 2s

		tween.tween_property(particle, "position:y", rise_height - 1.5, 1.0).set_delay(1.0)

		tween.tween_property(particle, "scale", Vector3(0.5, 0.5, 0.5), 1.5).set_delay(0.5)

		# Fade out over full duration

		tween.tween_property(mat, "albedo_color:a", 0.0, burst_duration)

		tween.tween_property(mat, "emission_energy_multiplier", 0.0, burst_duration)