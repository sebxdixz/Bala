extends Node

const SETTINGS_PATH := "user://settings.cfg"
const SECTION_GAMEPLAY := "gameplay"

const DEFAULTS := {
	"mouse_sensitivity": 0.0012,
	"walk_speed": 3.5,
	"sprint_speed": 6.5,
	"roll_speed": 8.0,
	"acceleration": 5.0,
	"jump_velocity": 4.5,
	"camera_smooth_speed": 7.0,
	"day_speed": 0.001,
}

var values: Dictionary = {}

func _ready():
	load_settings()

func load_settings() -> void:
	values = DEFAULTS.duplicate(true)
	var cfg := ConfigFile.new()
	var err = cfg.load(SETTINGS_PATH)
	if err != OK:
		save_settings()
		return
	for key in DEFAULTS.keys():
		values[key] = cfg.get_value(SECTION_GAMEPLAY, key, DEFAULTS[key])

func save_settings() -> void:
	var cfg := ConfigFile.new()
	for key in DEFAULTS.keys():
		cfg.set_value(SECTION_GAMEPLAY, key, values.get(key, DEFAULTS[key]))
	cfg.save(SETTINGS_PATH)

func get_value(key: String, fallback = null):
	if values.has(key):
		return values[key]
	if fallback != null:
		return fallback
	return DEFAULTS.get(key)

func set_value(key: String, value) -> void:
	if not DEFAULTS.has(key):
		return
	values[key] = value
	save_settings()

func get_all() -> Dictionary:
	return values.duplicate(true)

func reset_defaults() -> void:
	values = DEFAULTS.duplicate(true)
	save_settings()

func apply_to_player(player: Node) -> void:
	if not player:
		return
	for key in [
		"mouse_sensitivity",
		"walk_speed",
		"sprint_speed",
		"roll_speed",
		"acceleration",
		"jump_velocity",
		"camera_smooth_speed",
	]:
		if _has_property(player, key):
			player.set(key, values.get(key, DEFAULTS[key]))

func apply_to_world_initializer(world_initializer: Node) -> void:
	if not world_initializer:
		return
	if _has_property(world_initializer, "day_speed"):
		world_initializer.set("day_speed", values.get("day_speed", DEFAULTS.day_speed))

func _has_property(obj: Object, property_name: String) -> bool:
	for prop in obj.get_property_list():
		if String(prop.name) == property_name:
			return true
	return false
