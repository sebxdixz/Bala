extends CanvasLayer

signal settings_applied(values: Dictionary)

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

@onready var close_button: Button = $CenterPanel/MarginContainer/VBoxMain/ButtonsRow/CloseButton
@onready var reset_button: Button = $CenterPanel/MarginContainer/VBoxMain/ButtonsRow/ResetButton

@onready var mouse_slider: HSlider = $CenterPanel/MarginContainer/VBoxMain/SlidersGrid/MouseSensitivitySlider
@onready var walk_slider: HSlider = $CenterPanel/MarginContainer/VBoxMain/SlidersGrid/WalkSpeedSlider
@onready var sprint_slider: HSlider = $CenterPanel/MarginContainer/VBoxMain/SlidersGrid/SprintSpeedSlider
@onready var roll_slider: HSlider = $CenterPanel/MarginContainer/VBoxMain/SlidersGrid/RollSpeedSlider
@onready var accel_slider: HSlider = $CenterPanel/MarginContainer/VBoxMain/SlidersGrid/AccelerationSlider
@onready var jump_slider: HSlider = $CenterPanel/MarginContainer/VBoxMain/SlidersGrid/JumpVelocitySlider
@onready var smooth_slider: HSlider = $CenterPanel/MarginContainer/VBoxMain/SlidersGrid/CameraSmoothSlider
@onready var day_speed_slider: HSlider = $CenterPanel/MarginContainer/VBoxMain/SlidersGrid/DaySpeedSlider

@onready var mouse_value: Label = $CenterPanel/MarginContainer/VBoxMain/SlidersGrid/MouseValue
@onready var walk_value: Label = $CenterPanel/MarginContainer/VBoxMain/SlidersGrid/WalkValue
@onready var sprint_value: Label = $CenterPanel/MarginContainer/VBoxMain/SlidersGrid/SprintValue
@onready var roll_value: Label = $CenterPanel/MarginContainer/VBoxMain/SlidersGrid/RollValue
@onready var accel_value: Label = $CenterPanel/MarginContainer/VBoxMain/SlidersGrid/AccelValue
@onready var jump_value: Label = $CenterPanel/MarginContainer/VBoxMain/SlidersGrid/JumpValue
@onready var smooth_value: Label = $CenterPanel/MarginContainer/VBoxMain/SlidersGrid/SmoothValue
@onready var day_speed_value: Label = $CenterPanel/MarginContainer/VBoxMain/SlidersGrid/DaySpeedValue

var _is_refreshing: bool = false

func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	if GameSettings:
		GameSettings.load_settings()
	close_button.pressed.connect(close_menu)
	reset_button.pressed.connect(_on_reset_pressed)

	mouse_slider.value_changed.connect(_on_mouse_sensitivity_changed)
	walk_slider.value_changed.connect(_on_walk_speed_changed)
	sprint_slider.value_changed.connect(_on_sprint_speed_changed)
	roll_slider.value_changed.connect(_on_roll_speed_changed)
	accel_slider.value_changed.connect(_on_acceleration_changed)
	jump_slider.value_changed.connect(_on_jump_velocity_changed)
	smooth_slider.value_changed.connect(_on_camera_smooth_changed)
	day_speed_slider.value_changed.connect(_on_day_speed_changed)

	_sync_from_targets()

func _unhandled_input(event: InputEvent):
	if not visible:
		return
	if event.is_action_pressed("toggle_settings") or event.is_action_pressed("ui_cancel"):
		close_menu()
		get_viewport().set_input_as_handled()

func toggle_menu():
	if visible:
		close_menu()
	else:
		open_menu()

func open_menu():
	_sync_from_targets()
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func close_menu():
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_reset_pressed():
	if GameSettings:
		GameSettings.reset_defaults()
	_sync_from_targets()
	_apply_all_from_sliders()

func _sync_from_targets():
	var values = DEFAULTS.duplicate(true)
	if GameSettings:
		var saved_values = GameSettings.get_all()
		for key in values.keys():
			values[key] = saved_values.get(key, values[key])

	var player = _find_player()
	if player:
		values.mouse_sensitivity = _get_or_default(player, "mouse_sensitivity", values.mouse_sensitivity)
		values.walk_speed = _get_or_default(player, "walk_speed", values.walk_speed)
		values.sprint_speed = _get_or_default(player, "sprint_speed", values.sprint_speed)
		values.roll_speed = _get_or_default(player, "roll_speed", values.roll_speed)
		values.acceleration = _get_or_default(player, "acceleration", values.acceleration)
		values.jump_velocity = _get_or_default(player, "jump_velocity", values.jump_velocity)
		values.camera_smooth_speed = _get_or_default(player, "camera_smooth_speed", values.camera_smooth_speed)

	var world_initializer = _find_world_initializer()
	if world_initializer:
		values.day_speed = _get_or_default(world_initializer, "day_speed", values.day_speed)

	_is_refreshing = true
	mouse_slider.value = values.mouse_sensitivity
	walk_slider.value = values.walk_speed
	sprint_slider.value = values.sprint_speed
	roll_slider.value = values.roll_speed
	accel_slider.value = values.acceleration
	jump_slider.value = values.jump_velocity
	smooth_slider.value = values.camera_smooth_speed
	day_speed_slider.value = values.day_speed
	_is_refreshing = false

	_update_value_labels(values)

func _apply_all_from_sliders():
	_apply_setting("mouse_sensitivity", mouse_slider.value)
	_apply_setting("walk_speed", walk_slider.value)
	_apply_setting("sprint_speed", sprint_slider.value)
	_apply_setting("roll_speed", roll_slider.value)
	_apply_setting("acceleration", accel_slider.value)
	_apply_setting("jump_velocity", jump_slider.value)
	_apply_setting("camera_smooth_speed", smooth_slider.value)
	_apply_setting("day_speed", day_speed_slider.value)
	_update_value_labels({
		"mouse_sensitivity": mouse_slider.value,
		"walk_speed": walk_slider.value,
		"sprint_speed": sprint_slider.value,
		"roll_speed": roll_slider.value,
		"acceleration": accel_slider.value,
		"jump_velocity": jump_slider.value,
		"camera_smooth_speed": smooth_slider.value,
		"day_speed": day_speed_slider.value,
	})

func _apply_setting(setting: String, value: float):
	if GameSettings:
		GameSettings.set_value(setting, value)
	var player = _find_player()
	if player and _has_property(player, setting):
		player.set(setting, value)

	if setting == "day_speed":
		var world_initializer = _find_world_initializer()
		if world_initializer and _has_property(world_initializer, "day_speed"):
			world_initializer.day_speed = value

	settings_applied.emit({setting: value})

func _find_player() -> Node:
	var players = get_tree().get_nodes_in_group("players")
	if players.size() > 0:
		return players[0]
	return null

func _find_world_initializer() -> Node:
	var root = get_tree().current_scene
	if not root:
		return null
	return root.get_node_or_null("WorldInitializer")

func _get_or_default(obj: Object, property_name: String, fallback):
	if _has_property(obj, property_name):
		return obj.get(property_name)
	return fallback

func _has_property(obj: Object, property_name: String) -> bool:
	for prop in obj.get_property_list():
		if String(prop.name) == property_name:
			return true
	return false

func _update_value_labels(values: Dictionary):
	mouse_value.text = "%.4f" % float(values.mouse_sensitivity)
	walk_value.text = "%.1f" % float(values.walk_speed)
	sprint_value.text = "%.1f" % float(values.sprint_speed)
	roll_value.text = "%.1f" % float(values.roll_speed)
	accel_value.text = "%.1f" % float(values.acceleration)
	jump_value.text = "%.1f" % float(values.jump_velocity)
	smooth_value.text = "%.1f" % float(values.camera_smooth_speed)
	day_speed_value.text = "%.4f" % float(values.day_speed)

func _on_mouse_sensitivity_changed(value: float):
	if _is_refreshing:
		return
	_apply_setting("mouse_sensitivity", value)
	mouse_value.text = "%.4f" % value

func _on_walk_speed_changed(value: float):
	if _is_refreshing:
		return
	_apply_setting("walk_speed", value)
	walk_value.text = "%.1f" % value

func _on_sprint_speed_changed(value: float):
	if _is_refreshing:
		return
	_apply_setting("sprint_speed", value)
	sprint_value.text = "%.1f" % value

func _on_roll_speed_changed(value: float):
	if _is_refreshing:
		return
	_apply_setting("roll_speed", value)
	roll_value.text = "%.1f" % value

func _on_acceleration_changed(value: float):
	if _is_refreshing:
		return
	_apply_setting("acceleration", value)
	accel_value.text = "%.1f" % value

func _on_jump_velocity_changed(value: float):
	if _is_refreshing:
		return
	_apply_setting("jump_velocity", value)
	jump_value.text = "%.1f" % value

func _on_camera_smooth_changed(value: float):
	if _is_refreshing:
		return
	_apply_setting("camera_smooth_speed", value)
	smooth_value.text = "%.1f" % value

func _on_day_speed_changed(value: float):
	if _is_refreshing:
		return
	_apply_setting("day_speed", value)
	day_speed_value.text = "%.4f" % value
