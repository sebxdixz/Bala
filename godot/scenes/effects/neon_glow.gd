# ============================================================

# neon_glow.gd -- Neon glow effect script

# Barrio Sin Ley Online (BSLO)

# Simple OmniLight3D with configurable color and radius.

# Can be placed on neon signs or street lights for atmosphere.

# ============================================================

extends OmniLight3D



@export var glow_color: Color = Color(1.0, 0.0, 1.0, 1.0)

@export var glow_radius: float = 6.0

@export var flicker_enabled: bool = false

@export var flicker_speed: float = 2.0



func _ready():

	light_color = glow_color

	omni_range = glow_radius

	light_energy = 2.0

	shadow_enabled = false

	light_indirect_energy = 0.5



func set_glow_properties(color: Color, radius: float):

	glow_color = color

	glow_radius = radius

	light_color = color

	omni_range = radius



func _process(delta: float):

	if flicker_enabled:

		var flicker = 1.0 + sin(Time.get_ticks_msec() * 0.001 * flicker_speed) * 0.15

		light_energy = 2.0 * flicker