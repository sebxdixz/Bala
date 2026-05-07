# ============================================================
# minimap.gd -- Functional Minimap Radar
# Barrio Sin Ley Online (BSLO)
# Node2D child of the Minimap Control. Renders colored dots
# representing players (green), enemies (red), friendlies (blue),
# quest givers (gold), and loot items (white).
# Player dot stays centered; map optionally rotates with player.
# Press M to toggle between small (150px) and large (300px).
# Updates every 0.5s to minimize performance impact.
# ============================================================
extends Node2D

# ---------- exported settings ----------
@export var world_radius: float = 50.0          # world units shown on map
@export var minimap_pixels: float = 150.0       # pixel size (normal)
@export var update_interval: float = 0.5        # seconds between scans
@export var rotate_with_player: bool = false    # rotate map with camera yaw
@export var dot_size: float = 4.0               # pixel size of each dot

# dot colours
const COLOR_PLAYER      := Color.GREEN
const COLOR_ENEMY       := Color(1.0, 0.15, 0.1, 0.95)
const COLOR_FRIENDLY    := Color(0.25, 0.6, 1.0, 0.9)
const COLOR_QUEST_GIVER := Color(1.0, 0.85, 0.1, 1.0)
const COLOR_LOOT        := Color(1.0, 1.0, 1.0, 0.85)
const COLOR_NORTH_TICK  := Color(0.8, 0.8, 0.8, 0.6)

# size constants
const SIZE_NORMAL: float = 150.0
const SIZE_LARGE:  float = 300.0

# ---------- internal state ----------
var _player: Node3D = null
var _dot_container: Node2D = null
var _player_dot: ColorRect = null
var _north_tick: ColorRect = null
var _dots: Dictionary = {}          # Node -> ColorRect
var _update_timer: float = 0.0
var _is_large: bool = false
var _parent_control: Control = null
var _m_was_pressed: bool = false


func _ready() -> void:
    _parent_control = get_parent() as Control
    _dot_container = Node2D.new()
    _dot_container.name = "DotContainer"
    add_child(_dot_container)

    _create_player_dot()
    _create_north_tick()
    _find_player()
    _update_minimap()


func _process(delta: float) -> void:
    _update_timer += delta
    if _update_timer >= update_interval:
        _update_timer -= update_interval
        _update_minimap()

    # M key toggle with debounce
    var m_pressed: bool = Input.is_key_pressed(KEY_M)
    if m_pressed and not _m_was_pressed:
        _toggle_size()
    _m_was_pressed = m_pressed


# ============================================================
# SIZE TOGGLE
# ============================================================

func _toggle_size() -> void:
    _is_large = not _is_large
    var sz: float = SIZE_LARGE if _is_large else SIZE_NORMAL
    minimap_pixels = sz
    if _parent_control:
        _parent_control.custom_minimum_size = Vector2(sz, sz)
    _reposition_player_dot()
    _update_minimap()
    print("Minimap: size toggled to ", int(sz), "px")


# ============================================================
# PLAYER / DOT SETUP
# ============================================================

func _find_player() -> void:
    var players = get_tree().get_nodes_in_group("players")
    if players.size() > 0:
        _player = players[0]


func _create_player_dot() -> void:
    _player_dot = ColorRect.new()
    _player_dot.name = "PlayerDot"
    _player_dot.color = COLOR_PLAYER
    _player_dot.custom_minimum_size = Vector2(dot_size + 2, dot_size + 2)
    _player_dot.size = Vector2(dot_size + 2, dot_size + 2)
    _dot_container.add_child(_player_dot)
    _reposition_player_dot()


func _create_north_tick() -> void:
    _north_tick = ColorRect.new()
    _north_tick.name = "NorthTick"
    _north_tick.color = COLOR_NORTH_TICK
    _north_tick.custom_minimum_size = Vector2(2, 8)
    _north_tick.size = Vector2(2, 8)
    _dot_container.add_child(_north_tick)


func _reposition_player_dot() -> void:
    var half: float = minimap_pixels / 2.0
    var d2: float = dot_size / 2.0
    _player_dot.position = Vector2(half - d2 - 1, half - d2 - 1)
    _north_tick.position = Vector2(half - 1, 2)


# ============================================================
# MAIN UPDATE -- scan world and place dots
# ============================================================

func _update_minimap() -> void:
    if not is_inside_tree():
        return

    if not _player or not is_instance_valid(_player):
        _find_player()
        if not _player:
            return

    var player_pos: Vector3 = _player.global_position
    var player_yaw: float = _player.rotation.y if rotate_with_player else 0.0

    # keep track of which world nodes still exist
    var active_nodes: Dictionary = {}

    # --- npcs -------------------------------------------------
    var npcs = get_tree().get_nodes_in_group("npcs")
    for npc in npcs:
        if not is_instance_valid(npc):
            continue
        # skip dead npcs
        if npc.has_method("is_alive_check") and not npc.is_alive_check():
            continue
        var color: Color = _get_npc_color(npc)
        _update_dot(npc, npc.global_position, color, player_pos, player_yaw)
        active_nodes[npc] = true

    # --- loot items -------------------------------------------
    var loots = get_tree().get_nodes_in_group("loot_items")
    for loot in loots:
        if not is_instance_valid(loot):
            continue
        _update_dot(loot, loot.global_position, COLOR_LOOT, player_pos, player_yaw)
        active_nodes[loot] = true

    # --- other players (future multiplayer support) -----------
    var all_players = get_tree().get_nodes_in_group("players")
    for p in all_players:
        if not is_instance_valid(p) or p == _player:
            continue
        _update_dot(p, p.global_position, COLOR_PLAYER, player_pos, player_yaw)
        active_nodes[p] = true

    # --- remove dots for entities that disappeared -------------
    var to_remove: Array = []
    for node in _dots:
        if not active_nodes.has(node):
            to_remove.append(node)

    for node in to_remove:
        var dot: ColorRect = _dots[node]
        if is_instance_valid(dot):
            dot.queue_free()
        _dots.erase(node)


# ============================================================
# DOT PLACEMENT HELPERS
# ============================================================

func _get_npc_color(npc: Node) -> Color:
    # quest givers shine gold
    if npc.get("is_quest_giver"):
        return COLOR_QUEST_GIVER
    # hostile -> red
    if npc.get("is_hostile"):
        return COLOR_ENEMY
    # everything else -> blue (friendly / neutral)
    return COLOR_FRIENDLY


func _update_dot(node: Node, world_pos: Vector3, color: Color,
                 player_pos: Vector3, player_yaw: float) -> void:
    # offset in world XZ plane
    var dx: float = world_pos.x - player_pos.x
    var dz: float = world_pos.z - player_pos.z

    # rotate if the minimap follows the player's facing direction
    if rotate_with_player:
        var cos_a: float = cos(-player_yaw)
        var sin_a: float = sin(-player_yaw)
        var rx: float = dx * cos_a - dz * sin_a
        var rz: float = dx * sin_a + dz * cos_a
        dx = rx
        dz = rz

    # distance check
    var dist: float = sqrt(dx * dx + dz * dz)
    if dist > world_radius:
        if _dots.has(node):
            var old_dot: ColorRect = _dots[node]
            if is_instance_valid(old_dot):
                old_dot.queue_free()
            _dots.erase(node)
        return

    # world -> minimap coordinates
    var half: float = minimap_pixels / 2.0
    var scale: float = half / world_radius
    var px: float =  dx * scale + half
    var py: float = -dz * scale + half   # -Z = forward = up on map

    var dot: ColorRect
    if _dots.has(node):
        dot = _dots[node]
    else:
        dot = ColorRect.new()
        dot.name = "Dot_" + node.name
        dot.color = color
        dot.custom_minimum_size = Vector2(dot_size, dot_size)
        dot.size = Vector2(dot_size, dot_size)
        _dot_container.add_child(dot)
        _dots[node] = dot

    var d2: float = dot_size / 2.0
    dot.position = Vector2(px - d2, py - d2)
    dot.color = color