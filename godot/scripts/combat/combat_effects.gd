# ============================================================

# combat_effects.gd -- Combat Effects Manager (Autoload)

# Barrio Sin Ley Online (BSLO)

# Singleton that handles spawning all visual effects

# for combat, death, and level ups.

# ============================================================

extends Node



const HIT_SPARK_SCENE: String = "res://scenes/effects/hit_spark.tscn"

const LEVEL_UP_BURST_SCENE: String = "res://scenes/effects/level_up_burst.tscn"

const NEON_GLOW_SCENE: String = "res://scenes/effects/neon_glow.tscn"



var _hit_spark_resource: PackedScene = null

var _level_up_resource: PackedScene = null

var _neon_glow_resource: PackedScene = null



func _ready():

	_preload_scenes()



func _preload_scenes():

	_hit_spark_resource = load(HIT_SPARK_SCENE)

	_level_up_resource = load(LEVEL_UP_BURST_SCENE)

	_neon_glow_resource = load(NEON_GLOW_SCENE)



func spawn_hit_effect(position: Vector3, damage: int = 0, is_critical: bool = false):

	if not _hit_spark_resource:

		_preload_scenes()

		if not _hit_spark_resource:

			push_error("CombatEffects: Could not load hit_spark.tscn")

			return



	var spark = _hit_spark_resource.instantiate()

	spark.global_position = position



	if is_critical:

		spark.spark_color = Color(1.0, 0.15, 0.15, 1.0)

		spark.spark_count = 10

		spark.spread_speed = 4.0

	else:

		spark.spark_color = Color(1.0, 0.85, 0.2, 1.0)

		spark.spark_count = 6

		spark.spread_speed = 3.0



	var scene_root = get_tree().current_scene

	if scene_root:

		scene_root.add_child(spark)

	else:

		add_child(spark)



func spawn_death_effect(position: Vector3, faction: String = ""):

	if not _hit_spark_resource:

		_preload_scenes()

		if not _hit_spark_resource:

			push_error("CombatEffects: Could not load hit_spark.tscn")

			return



	var spark = _hit_spark_resource.instantiate()

	spark.global_position = position

	spark.spark_count = 12

	spark.lifetime = 0.6

	spark.spread_speed = 4.5



	match faction.to_upper():

		"YAKUZA":

			spark.spark_color = Color(1.0, 0.0, 1.0, 1.0)

		"CARTEL":

			spark.spark_color = Color(1.0, 0.5, 0.0, 1.0)

		"POLICIA":

			spark.spark_color = Color(0.2, 0.4, 1.0, 1.0)

		"CIVILIAN":

			spark.spark_color = Color(1.0, 0.85, 0.0, 1.0)

		_:

			spark.spark_color = Color(1.0, 0.85, 0.0, 1.0)



	var scene_root = get_tree().current_scene

	if scene_root:

		scene_root.add_child(spark)

	else:

		add_child(spark)



func spawn_level_up_effect(position: Vector3):

	if not _level_up_resource:

		_preload_scenes()

		if not _level_up_resource:

			push_error("CombatEffects: Could not load level_up_burst.tscn")

			return



	var burst = _level_up_resource.instantiate()

	burst.global_position = position



	var scene_root = get_tree().current_scene

	if scene_root:

		scene_root.add_child(burst)

	else:

		add_child(burst)



func spawn_neon_glow(position: Vector3, color: Color, radius: float):

	if not _neon_glow_resource:

		_preload_scenes()

		if not _neon_glow_resource:

			push_error("CombatEffects: Could not load neon_glow.tscn")

			return



	var glow = _neon_glow_resource.instantiate()

	glow.global_position = position



	if glow.has_method("set_glow_properties"):

		glow.set_glow_properties(color, radius)

	else:

		if glow is OmniLight3D:

			glow.light_color = color

			glow.omni_range = radius



	var scene_root = get_tree().current_scene

	if scene_root:

		scene_root.add_child(glow)

	else:

		add_child(glow)