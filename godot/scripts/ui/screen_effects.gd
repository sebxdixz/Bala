# ============================================================
# screen_effects.gd -- Screen Effects Singleton (Autoload)
# Barrio Sin Ley Online (BSLO)
# Godot 4.6
# ============================================================
extends Node

const SHAKE_DECAY: float = 7.0
const DAMAGE_VIGNETTE_DURATION: float = 0.3
const HEAL_FLASH_DURATION: float = 0.4
const LOW_HP_VIGNETTE_ALPHA: float = 0.15

# Public shake offset -- read by Player camera to apply to camera position
var shake_offset: Vector3 = Vector3.ZERO

var _shake_intensity: float = 0.0
var _shake_duration: float = 0.0
var _shake_timer: float = 0.0

var _damage_overlay: ColorRect = null
var _heal_overlay: ColorRect = null
var _low_hp_overlay: ColorRect = null
var _low_hp_active: bool = false

func _ready():
    process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta: float):
    _update_shake(delta)

func _update_shake(delta: float):
    if _shake_timer > 0.0:
        _shake_timer -= delta
        if _shake_timer <= 0.0:
            shake_offset = Vector3.ZERO
            _shake_timer = 0.0
            return
        var progress = clampf(_shake_timer / maxf(_shake_duration, 0.001), 0.0, 1.0)
        var current_intensity = _shake_intensity * progress
        shake_offset = Vector3(
            randf_range(-1.0, 1.0) * current_intensity,
            randf_range(-1.0, 1.0) * current_intensity * 0.5,
            randf_range(-1.0, 1.0) * current_intensity
        )
    else:
        shake_offset = Vector3.ZERO

# -----------------------------------------------------------
# SCREEN SHAKE
# -----------------------------------------------------------
func screen_shake(intensity: float, duration: float):
    _shake_intensity = intensity
    _shake_duration = maxf(duration, 0.01)
    _shake_timer = _shake_duration

# -----------------------------------------------------------
# DAMAGE VIGNETTE -- brief red flash on damage taken
# -----------------------------------------------------------
func damage_vignette():
    var root = _get_scene_root()
    if not root:
        return

    if _damage_overlay and is_instance_valid(_damage_overlay):
        _damage_overlay.queue_free()

    _damage_overlay = ColorRect.new()
    _damage_overlay.name = "DamageVignette"
    _damage_overlay.color = Color(1.0, 0.0, 0.0, 0.0)
    _damage_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
    _damage_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
    root.add_child(_damage_overlay)

    var tween = _damage_overlay.create_tween()
    # Flash in quickly
    tween.tween_property(_damage_overlay, "color:a", 0.25, 0.05)
    # Fade out
    tween.tween_property(_damage_overlay, "color:a", 0.0, DAMAGE_VIGNETTE_DURATION)
    tween.tween_callback(_damage_overlay.queue_free)

# -----------------------------------------------------------
# LOW HP VIGNETTE -- continuous red overlay when HP < 30%
# -----------------------------------------------------------
func low_hp_vignette(hp_ratio: float):
    var root = _get_scene_root()
    if not root:
        return

    var is_low = hp_ratio < 0.3

    if is_low and not _low_hp_active:
        _low_hp_active = true
        _create_low_hp_overlay(root)
    elif not is_low and _low_hp_active:
        _low_hp_active = false
        _remove_low_hp_overlay()

    if _low_hp_overlay and is_instance_valid(_low_hp_overlay) and _low_hp_active:
        # Pulsate based on how low HP is
        var pulse = sin(Time.get_ticks_msec() * 0.005) * 0.5 + 0.5
        var alpha = LOW_HP_VIGNETTE_ALPHA + pulse * 0.08
        _low_hp_overlay.color = Color(1.0, 0.0, 0.0, alpha)

func _create_low_hp_overlay(root: Node):
    if _low_hp_overlay and is_instance_valid(_low_hp_overlay):
        return
    _low_hp_overlay = ColorRect.new()
    _low_hp_overlay.name = "LowHPVignette"
    _low_hp_overlay.color = Color(1.0, 0.0, 0.0, LOW_HP_VIGNETTE_ALPHA)
    _low_hp_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
    _low_hp_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
    root.add_child(_low_hp_overlay)

func _remove_low_hp_overlay():
    if _low_hp_overlay and is_instance_valid(_low_hp_overlay):
        _low_hp_overlay.queue_free()
        _low_hp_overlay = null

# -----------------------------------------------------------
# HEAL FLASH -- brief green flash when healed
# -----------------------------------------------------------
func heal_flash():
    var root = _get_scene_root()
    if not root:
        return

    if _heal_overlay and is_instance_valid(_heal_overlay):
        _heal_overlay.queue_free()

    _heal_overlay = ColorRect.new()
    _heal_overlay.name = "HealFlash"
    _heal_overlay.color = Color(0.0, 1.0, 0.0, 0.2)
    _heal_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
    _heal_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
    root.add_child(_heal_overlay)

    var tween = _heal_overlay.create_tween()
    tween.tween_property(_heal_overlay, "color:a", 0.0, HEAL_FLASH_DURATION)
    tween.tween_callback(_heal_overlay.queue_free)

# -----------------------------------------------------------
# UTILITY
# -----------------------------------------------------------
func _get_scene_root() -> Node:
    var tree = get_tree()
    if tree:
        return tree.current_scene
    return null