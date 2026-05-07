# ============================================================
# day_night_cycle.gd -- DayNightCycle (Autoload)
# Barrio Sin Ley Online (BSLO)
# Gestiona ciclo dia/noche con iluminacion real.
# Controla DirectionalLight3D para sol, y luces artificiales.
# ============================================================
extends Node

# Fases del ciclo
enum Phase { DAWN, DAY, DUSK, NIGHT }

# Seniales
signal phase_changed(new_phase: int)

# Configuracion exportada
@export var cycle_duration: float = 240.0
@export var sun_light: DirectionalLight3D
@export var time_display: Label

# Estado interno
var _time_of_day: float = 0.25
var _current_phase: int = Phase.DAWN
var _environment: Environment
var _world_environment: WorldEnvironment
var _all_omni_lights: Array = []
var _street_lights: Array = []
var _neon_lights: Array = []
var _original_sun_energy: float = 1.0
var _original_sun_color: Color = Color(1, 0.85, 0.65, 1)
var _lights_initialized: bool = false

func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	call_deferred("_initialize_lights")

func _initialize_lights():
	_find_sun_light()
	_categorize_lights()
	_find_environment()
	_lights_initialized = true

func _find_sun_light():
	if sun_light:
		_original_sun_energy = sun_light.light_energy
		_original_sun_color = sun_light.light_color
		return
	var root = get_tree().current_scene
	if root:
		var children = root.find_children("*", "DirectionalLight3D", true, false)
		if children.size() > 0:
			for child in children:
				if child is DirectionalLight3D:
					sun_light = child
					_original_sun_energy = sun_light.light_energy
					_original_sun_color = sun_light.light_color
					break

func _categorize_lights():
	var root = get_tree().current_scene
	if not root:
		return
	_all_omni_lights.clear()
	_street_lights.clear()
	_neon_lights.clear()

	var omnis = root.find_children("*", "OmniLight3D", true, false)
	for light in omnis:
		if light is OmniLight3D:
			_all_omni_lights.append(light)
			var c = light.light_color
			if c.g > 0.5 or c.b > 0.6 or (c.r > 0.8 and c.b > 0.3):
				_neon_lights.append(light)
			else:
				_street_lights.append(light)

func _find_environment():
	var root = get_tree().current_scene
	if not root:
		return
	var envs = root.find_children("*", "WorldEnvironment", true, false)
	if envs.size() > 0:
		_world_environment = envs[0] as WorldEnvironment
		if _world_environment:
			_environment = _world_environment.environment

func _process(delta: float):
	if not _lights_initialized:
		return

	_time_of_day += delta / cycle_duration
	if _time_of_day >= 1.0:
		_time_of_day -= 1.0

	var new_phase = _calculate_phase()
	if new_phase != _current_phase:
		_current_phase = new_phase
		phase_changed.emit(new_phase)
		_on_phase_changed(new_phase)

	_update_sun()
	_update_sky()
	_update_artificial_lights()
	_update_time_display()

func _calculate_phase() -> int:
	if _time_of_day < 0.25:
		return Phase.NIGHT
	elif _time_of_day < 0.5:
		return Phase.DAWN
	elif _time_of_day < 0.75:
		return Phase.DAY
	else:
		return Phase.DUSK

func _on_phase_changed(phase: int):
	match phase:
		Phase.NIGHT:
			_set_street_lights(true)
			_set_neon_lights(true)
		Phase.DAWN:
			_set_street_lights(true)
			_set_neon_lights(true)
		Phase.DAY:
			_set_street_lights(false)
			_set_neon_lights(false)
		Phase.DUSK:
			_set_street_lights(true)
			_set_neon_lights(true)

func _update_sun():
	if not sun_light:
		return

	var sun_angle: float
	var intensity: float
	var color: Color

	if _time_of_day < 0.25:
		var t = _time_of_day / 0.25
		sun_angle = lerpf(-90.0, 0.0, t)
		intensity = lerpf(0.02, 0.25, t)
		color = Color(0.08, 0.05, 0.2, 1).lerp(Color(1, 0.3, 0.15, 1), t)
	elif _time_of_day < 0.5:
		var t = (_time_of_day - 0.25) / 0.25
		sun_angle = lerpf(0.0, 90.0, t)
		intensity = lerpf(0.25, 1.2, t)
		color = Color(1, 0.3, 0.15, 1).lerp(Color(1, 0.9, 0.7, 1), t)
	elif _time_of_day < 0.75:
		var t = (_time_of_day - 0.5) / 0.25
		sun_angle = lerpf(90.0, 180.0, t)
		intensity = lerpf(1.2, 0.7, t)
		color = Color(1, 0.9, 0.7, 1).lerp(Color(1, 0.55, 0.25, 1), t)
	else:
		var t = (_time_of_day - 0.75) / 0.25
		sun_angle = lerpf(180.0, 270.0, t)
		intensity = lerpf(0.7, 0.02, t)
		color = Color(1, 0.55, 0.25, 1).lerp(Color(0.08, 0.05, 0.2, 1), t)

	sun_light.rotation_degrees.x = sun_angle
	sun_light.light_energy = intensity * _original_sun_energy
	sun_light.light_color = color

func _update_sky():
	if not _environment:
		return

	var sky_energy: float
	var ambient_color: Color
	var bg_color: Color

	if _time_of_day < 0.25:
		var t = _time_of_day / 0.25
		sky_energy = lerpf(0.12, 0.28, t)
		ambient_color = Color(0.04, 0.03, 0.12, 1).lerp(Color(0.18, 0.06, 0.12, 1), t)
		bg_color = Color(0.02, 0.02, 0.08, 1).lerp(Color(0.15, 0.06, 0.08, 1), t)
	elif _time_of_day < 0.5:
		var t = (_time_of_day - 0.25) / 0.25
		sky_energy = lerpf(0.28, 0.7, t)
		ambient_color = Color(0.18, 0.06, 0.12, 1).lerp(Color(0.3, 0.22, 0.18, 1), t)
		bg_color = Color(0.15, 0.06, 0.08, 1).lerp(Color(0.4, 0.35, 0.55, 1), t)
	elif _time_of_day < 0.75:
		var t = (_time_of_day - 0.5) / 0.25
		sky_energy = lerpf(0.7, 0.55, t)
		ambient_color = Color(0.3, 0.22, 0.18, 1).lerp(Color(0.22, 0.15, 0.12, 1), t)
		bg_color = Color(0.4, 0.35, 0.55, 1).lerp(Color(0.5, 0.3, 0.2, 1), t)
	else:
		var t = (_time_of_day - 0.75) / 0.25
		sky_energy = lerpf(0.55, 0.12, t)
		ambient_color = Color(0.22, 0.15, 0.12, 1).lerp(Color(0.04, 0.03, 0.12, 1), t)
		bg_color = Color(0.5, 0.3, 0.2, 1).lerp(Color(0.02, 0.02, 0.08, 1), t)

	_environment.ambient_light_energy = sky_energy
	_environment.ambient_light_color = ambient_color
	if _environment.background_mode == 1:
		_environment.background_color = bg_color

func _update_artificial_lights():
	var enable_lights = (_current_phase != Phase.DAY)
	var base_energy_street: float = 2.5
	var base_energy_neon: float = 2.0

	if _current_phase == Phase.DAY:
		base_energy_street = 0.0
		base_energy_neon = 0.0
	elif _current_phase == Phase.DAWN:
		var da = (_time_of_day - 0.25) / 0.25
		base_energy_street = lerpf(2.5, 0.0, da * da)
		base_energy_neon = lerpf(3.0, 0.0, da * da)
	elif _current_phase == Phase.DUSK:
		var du = (_time_of_day - 0.75) / 0.25
		base_energy_street = lerpf(0.0, 2.5, du * du)
		base_energy_neon = lerpf(0.0, 3.0, du * du)
	else:
		base_energy_street = 2.5
		base_energy_neon = 3.0

	for light in _street_lights:
		if is_instance_valid(light):
			light.light_energy = base_energy_street
			light.visible = enable_lights

	for light in _neon_lights:
		if is_instance_valid(light):
			light.light_energy = base_energy_neon
			light.visible = enable_lights

func _set_street_lights(enabled: bool):
	for light in _street_lights:
		if is_instance_valid(light):
			light.visible = enabled

func _set_neon_lights(enabled: bool):
	for light in _neon_lights:
		if is_instance_valid(light):
			light.visible = enabled

func _update_time_display():
	if not time_display:
		var root = get_tree().current_scene
		if root:
			var labels = root.find_children("TimeDisplay", "", true, false)
			if labels.size() > 0 and labels[0] is Label:
				time_display = labels[0] as Label
	if time_display:
		time_display.text = get_time_string() + "\n" + get_phase_name()

func get_time_of_day() -> float:
	return _time_of_day

func get_phase() -> int:
	return _current_phase

func get_phase_name() -> String:
	match _current_phase:
		Phase.DAWN:
			return "AMANECER"
		Phase.DAY:
			return "DIA"
		Phase.DUSK:
			return "ATARDECER"
		Phase.NIGHT:
			return "NOCHE"
	return "???"

func get_hour() -> int:
	return int(_time_of_day * 24.0)

func get_minute() -> int:
	return int(fmod(_time_of_day * 24.0 * 60.0, 60.0))

func get_time_string() -> String:
	var h = get_hour()
	var m = get_minute()
	return "%02d:%02d" % [h, m]
