# ============================================================
# healthbar.gd -- Floating Health Bar & Nameplate Component
# Barrio Sin Ley Online (BSLO)
# Godot 4.6
# ============================================================
extends Node3D

@onready var bar_bg: MeshInstance3D = $BarBackground
@onready var bar_fg: MeshInstance3D = $BarForeground
@onready var name_label: Label3D = $NameLabel

var max_hp: float = 100.0
var current_hp: float = 100.0
var target_hp: float = 100.0
var bar_width: float = 1.5

var _tween_active: bool = false
var _current_displayed_ratio: float = 1.0

func _ready():
    _create_bar_materials()
    visible = true
    _current_displayed_ratio = 1.0

func _create_bar_materials():
    # Background: dark gray, always visible
    var bg_mat = StandardMaterial3D.new()
    bg_mat.albedo_color = Color(0.1, 0.1, 0.1, 1)
    bg_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
    bg_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
    bg_mat.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
    bar_bg.material_override = bg_mat

    # Foreground: color changes with HP, billboard
    var fg_mat = StandardMaterial3D.new()
    fg_mat.albedo_color = Color(0.2, 0.85, 0.2, 1)
    fg_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
    fg_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
    fg_mat.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
    bar_fg.material_override = fg_mat

    # Billboard for name label is set in scene via property

func update_health(current: float, max_val: float):
    max_hp = maxf(max_val, 1.0)
    target_hp = clampf(current, 0.0, max_hp)
    _animate_bar()

func update_name(name_str: String, lvl: int):
    name_label.text = name_str + " [Lv." + str(lvl) + "]"

func show_bar():
    visible = true

func hide_bar():
    visible = false

# Backward compatibility with old API
func setup(enemy_name: String, hp: float, max_hp_val: float):
    update_name(enemy_name, 1)
    max_hp = max_hp_val
    current_hp = hp
    target_hp = hp
    _update_bar_instant()

func update_hp(hp: float):
    update_health(hp, max_hp)

func _animate_bar():
    var start_ratio = _current_displayed_ratio
    var end_ratio = clampf(target_hp / max_hp, 0.0, 1.0)

    if _tween_active:
        # Cancel current tween if active and snap
        _tween_active = false

    var tween = create_tween()
    tween.set_trans(Tween.TRANS_LINEAR)
    tween.set_ease(Tween.EASE_OUT)
    tween.tween_method(_set_bar_ratio, start_ratio, end_ratio, 0.2)
    tween.tween_callback(_finish_animation)
    _tween_active = true

func _update_bar_instant():
    var ratio = clampf(target_hp / max_hp, 0.0, 1.0)
    _current_displayed_ratio = ratio
    _set_bar_ratio(ratio)
    current_hp = target_hp

func _set_bar_ratio(ratio: float):
    ratio = clampf(ratio, 0.0, 1.0)
    _current_displayed_ratio = ratio

    bar_fg.scale.x = ratio
    bar_fg.position.x = -(bar_width * (1.0 - ratio)) / 2.0

    # Color: green (>60%), yellow (30-60%), red (<30%)
    if ratio > 0.6:
        _set_fg_color(Color(0.2, 0.85, 0.2, 1))
    elif ratio > 0.3:
        _set_fg_color(Color(0.9, 0.8, 0.1, 1))
    else:
        _set_fg_color(Color(0.9, 0.15, 0.15, 1))

func _finish_animation():
    current_hp = target_hp
    _tween_active = false

func _set_fg_color(color: Color):
    if bar_fg and bar_fg.material_override:
        bar_fg.material_override.albedo_color = color
