# ============================================================

# hit_spark.gd -- Hit spark particle effect

# Barrio Sin Ley Online (BSLO)

# Spawns multiple small emissive squares that fly outward,

# scale down, fade, and self-destruct.

# ============================================================

extends Node3D



@export var spark_color: Color = Color(1.0, 0.85, 0.2, 1.0)

@export var spark_count: int = 6

@export var lifetime: float = 0.4

@export var spread_speed: float = 3.0



func _ready():

	spawn_sparks()

	await get_tree().create_timer(lifetime + 0.15).timeout

	queue_free()



func spawn_sparks():

	for i in range(spark_count):

		var spark = MeshInstance3D.new()

		var box = BoxMesh.new()

		box.size = Vector3(0.05, 0.05, 0.05)

		spark.mesh = box



		var mat = StandardMaterial3D.new()

		mat.albedo_color = spark_color

		mat.emission_enabled = true

		mat.emission = spark_color

		mat.emission_energy_multiplier = 4.0

		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA

		spark.material_override = mat



		spark.name = "Spark_" + str(i)

		add_child(spark)



		var random_dir = Vector3(

			randf_range(-1.0, 1.0),

			randf_range(0.3, 1.5),

			randf_range(-1.0, 1.0)

		).normalized()



		var speed = randf_range(spread_speed * 0.5, spread_speed * 1.5)

		var target_pos = random_dir * speed * lifetime



		var tween = create_tween()

		tween.set_parallel(true)

		tween.tween_property(spark, "position", target_pos, lifetime)

		tween.tween_property(spark, "scale", Vector3.ZERO, lifetime)

		tween.tween_property(mat, "albedo_color:a", 0.0, lifetime)

		tween.tween_property(mat, "emission_energy_multiplier", 0.0, lifetime)