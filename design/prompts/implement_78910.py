"""Implement LOG.md items 7-10: Inventory textures, enemy variety, day/night, minimap"""
import os, glob, random

godot = r"C:\Users\sdiaz\OneDrive - Axo\Escritorio\Proyectos\BALA\godot"

# ═══════════════════════════════════════════════
# 1. INVENTORY: Show generated item textures instead of ColorRect
# ═══════════════════════════════════════════════
f = os.path.join(godot, "scripts/ui/inventory_screen.gd")
with open(f, "r", encoding="utf-8") as fh:
    lines = fh.readlines()

# Update _create_placeholder_items to reference textures
for i, l in enumerate(lines):
    if "placeholder_items.append" in l and "Machete" in l:
        for j in range(i, i+5):
            if '"color"' in lines[j]:
                lines[j] = lines[j].replace('"color"', '"texture_path"')
                lines[j] = lines[j].replace('Color(0.5, 0.5, 0.5)', '"res://assets/weapons/katana_yakuza.png"')
                break
    if "placeholder_items.append" in l and "Pistola 9mm" in l:
        for j in range(i, i+5):
            if '"color"' in lines[j]:
                lines[j] = lines[j].replace('"color"', '"texture_path"')
                lines[j] = lines[j].replace('Color(0.25, 0.25, 0.3)', '"res://assets/weapons/pistol_standard.png"')
                break
    if "placeholder_items.append" in l and "Municion" in l:
        for j in range(i, i+5):
            if '"color"' in lines[j]:
                lines[j] = lines[j].replace('"color"', '"texture_path"')
                lines[j] = lines[j].replace('Color(0.8, 0.7, 0.2)', '"res://assets/weapons/ak47_cartel.png"')
                break
    if "placeholder_items.append" in l and "Taco" in l and "callejero" in l:
        for j in range(i, i+5):
            if '"color"' in lines[j]:
                lines[j] = lines[j].replace('"color"', '"texture_path"')
                lines[j] = lines[j].replace('Color(0.9, 0.6, 0.2)', '"res://assets/consumables/taco_healing.png"')
                break
    if "placeholder_items.append" in l and "Cerveza" in l:
        for j in range(i, i+5):
            if '"color"' in lines[j]:
                lines[j] = lines[j].replace('"color"', '"texture_path"')
                lines[j] = lines[j].replace('Color(0.85, 0.7, 0.1)', '"res://assets/consumables/cerveza_buff.png"')
                break
    if "placeholder_items.append" in l and "Vendaje" in l:
        for j in range(i, i+5):
            if '"color"' in lines[j]:
                lines[j] = lines[j].replace('"color"', '"texture_path"')
                lines[j] = lines[j].replace('Color(0.95, 0.95, 0.9)', '"res://assets/consumables/adrenaline_syringe.png"')
                break

# Update _refresh_grid to use TextureRect instead of ColorRect
for i, l in enumerate(lines):
    if "var color_rect = ColorRect.new()" in l:
        indent = l[:len(l)-len(l.lstrip())]
        lines[i] = indent + 'var item_tex = TextureRect.new()\n'
        lines[i+1] = indent + 'item_tex.custom_minimum_size = Vector2(40, 40)\n'
        lines[i+2] = indent + 'item_tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED\n'
        lines[i+3] = indent + 'item_tex.mouse_filter = Control.MOUSE_FILTER_IGNORE\n'
        # Check if item has texture_path
        lines.insert(i+4, indent + 'if item.has("texture_path") and item["texture_path"] != "":\n')
        lines.insert(i+5, indent + '\tvar tex = load(item["texture_path"])\n')
        lines.insert(i+6, indent + '\tif tex:\n')
        lines.insert(i+7, indent + '\t\titem_tex.texture = tex\n')
        lines.insert(i+8, indent + 'else:\n')
        lines.insert(i+9, indent + '\titem_tex.modulate = item.get("color", Color.WHITE)\n')
        # Replace vbox.add_child(color_rect) with new node
        for j in range(i+10, min(i+30, len(lines))):
            if "vbox.add_child(color_rect)" in lines[j]:
                lines[j] = lines[j].replace("color_rect", "item_tex")
                break
        break

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.writelines(lines)
print("inventory_screen.gd: texture items")

# ═══════════════════════════════════════════════
# 2. MORE ENEMIES: 8 spawn points + 6 enemy types
# ═══════════════════════════════════════════════
f = os.path.join(godot, "scripts/world/enemy_spawner.gd")
with open(f, "r", encoding="utf-8") as fh:
    lines = fh.readlines()

# Update enemy configs with 6 types
for i, l in enumerate(lines):
    if "var enemy_configs" in l:
        end_config = i
        for j in range(i, len(lines)):
            if "]" in lines[j] and j > i + 10:
                end_config = j
                break
        # Replace with expanded configs
        new_configs = [
            '\tvar enemy_configs = [\n',
            '\t\t{"name": "Maton Callejero", "faction": "CHOLOS", "hp": 70, "dmg": 10, "speed": 1.0, "color": Color(0.8, 0.2, 0.2)},\n',
            '\t\t{"name": "Sicario Narco", "faction": "CARTEL", "hp": 40, "dmg": 15, "speed": 3.0, "color": Color(0.2, 0.7, 0.2)},\n',
            '\t\t{"name": "Guardia Yakuza", "faction": "YAKUZA", "hp": 90, "dmg": 20, "speed": 1.5, "color": Color(0.1, 0.1, 0.9)},\n',
            '\t\t{"name": "Maton Pesado", "faction": "CHOLOS", "hp": 120, "dmg": 25, "speed": 0.8, "color": Color(0.6, 0.1, 0.6)},\n',
            '\t\t{"name": "Policia Corrupto", "faction": "POLICIA", "hp": 60, "dmg": 12, "speed": 2.0, "color": Color(0.2, 0.3, 0.9)},\n',
            '\t\t{"name": "Mafioso Armado", "faction": "MAFIA", "hp": 80, "dmg": 18, "speed": 1.3, "color": Color(0.5, 0.1, 0.1)},\n',
            '\t]\n',
        ]
        for k in range(i, end_config + 1):
            lines[k] = ""  # Mark for deletion
        for k, nl in enumerate(new_configs):
            lines.insert(i + k, nl)
        # Remove marked lines
        lines = [l for l in lines if l != ""]
        break

# Add spawn points expansion - spawn enemies in a wider area
for i, l in enumerate(lines):
    if "_spawn_initial_enemies" in l and "func" in l:
        # Add extra spawn logic for enemies beyond spawn points
        for j in range(i, min(i+40, len(lines))):
            if "_spawned_enemies.append(npc)" in lines[j] and j > i + 30:
                # Add extra random spawns after existing ones
                indent = lines[j][:len(lines[j])-len(lines[j].lstrip())]
                extra = [
                    '\n',
                    indent + '# Spawn extra patrol enemies in random positions\n',
                    indent + 'for _i in range(4):\n',
                    indent + '\tvar config = enemy_configs[randi() % enemy_configs.size()]\n',
                    indent + '\tvar rand_x = randf_range(-60, 60)\n',
                    indent + '\tvar rand_z = randf_range(-60, 60)\n',
                    indent + '\tvar extra_npc = _npc_scene.instantiate()\n',
                    indent + '\textra_npc.set("npc_name", config["name"] + " Patrulla")\n',
                    indent + '\textra_npc.set("faction", config["faction"])\n',
                    indent + '\textra_npc.set("is_hostile", true)\n',
                    indent + '\textra_npc.set("hp", config["hp"])\n',
                    indent + '\textra_npc.set("max_hp", config["hp"])\n',
                    indent + '\textra_npc.set("level", 2)\n',
                    indent + '\textra_npc.set("damage", config["dmg"])\n',
                    indent + '\textra_npc.set("chase_speed", config["speed"])\n',
                    indent + '\tget_tree().current_scene.add_child(extra_npc)\n',
                    indent + '\textra_npc.global_position = Vector3(rand_x, 0.5, rand_z)\n',
                    indent + '\t_spawned_enemies.append(extra_npc)\n',
                ]
                for k, nl in enumerate(extra):
                    lines.insert(j + 1 + k, nl)
                break
        break

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.writelines(lines)
print("enemy_spawner.gd: 6 enemy types + 4 patrol spawns")

# ═══════════════════════════════════════════════
# 3. DAY/NIGHT CYCLE: Rotate directional light + change fog
# ═══════════════════════════════════════════════
f = os.path.join(godot, "scripts/world/world_initializer.gd")
with open(f, "r", encoding="utf-8") as fh:
    lines = fh.readlines()

# Add day/night variables + cycle logic
for i, l in enumerate(lines):
    if "func _spawn_particles" in l:
        daynight = [
            '\n',
            'var day_time: float = 0.5  # Start at noon (0.0=midnight, 0.5=noon)\n',
            'var day_speed: float = 0.02  # Speed of cycle\n',
            '\n',
            'func _process(delta):\n',
            '\t_update_day_night(delta)\n',
            '\n',
            'func _update_day_night(delta):\n',
            '\tday_time += delta * day_speed\n',
            '\tif day_time > 1.0:\n',
            '\t\tday_time -= 1.0\n',
            '\t\n',
            '\tvar sun = get_node_or_null(\"../DirectionalLight3D\")\n',
            '\tif not sun:\n',
            '\t\treturn\n',
            '\t\n',
            '\t# Rotate sun based on time of day\n',
            '\tvar angle = day_time * PI * 2.0\n',
            '\tsun.rotation_x = angle\n',
            '\t\n',
            '\t# Brightness: dim at night, bright at day\n',
            '\tvar brightness = sin(day_time * PI)\n',
            '\tsun.light_energy = 0.3 + brightness * 1.0\n',
            '\t\n',
            '\t# Fog: thicker at night\n',
            '\tvar env = get_node_or_null(\"../WorldEnvironment\")\n',
            '\tif env and env.environment:\n',
            '\t\tenv.environment.volumetric_fog_density = 0.008 + (1.0 - brightness) * 0.015\n',
            '\t\tenv.environment.ambient_light_energy = 0.2 + brightness * 0.4\n',
        ]
        for k, nl in enumerate(daynight):
            lines.insert(i + k, nl)
        break

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.writelines(lines)
print("world_initializer.gd: day/night cycle")

# ═══════════════════════════════════════════════
# 4. FUNCTIONAL MINIMAP: Show player position on minimap
# ═══════════════════════════════════════════════
f = os.path.join(godot, "scripts/ui/hud.gd")
with open(f, "r", encoding="utf-8") as fh:
    lines = fh.readlines()

# Add minimap player dot
for i, l in enumerate(lines):
    if "func _apply_textures" in l:
        minimap_dot = [
            '\n',
            'var minimap_player_dot: ColorRect = null\n',
        ]
        for k, nl in enumerate(minimap_dot):
            lines.insert(i + k, nl)
        break

# Add player dot creation in _ready
for i, l in enumerate(lines):
    if "_apply_textures()" in l:
        lines.insert(i + 1, "\t_create_minimap_dot()\n")
        break

# Add _create_minimap_dot method
for i, l in enumerate(lines):
    if "func _create_xp_bar" in l:
        method = [
            '\n',
            'func _create_minimap_dot():\n',
            '\tvar minimap = get_node_or_null("MainContainer/Minimap")\n',
            '\tif not minimap:\n',
            '\t\treturn\n',
            '\tminimap_player_dot = ColorRect.new()\n',
            '\tminimap_player_dot.name = "PlayerDot"\n',
            '\tminimap_player_dot.color = Color(0, 1, 1, 1)\n',
            '\tminimap_player_dot.custom_minimum_size = Vector2(6, 6)\n',
            '\tminimap_player_dot.set_position(Vector2(72, 72))\n',
            '\tminimap.add_child(minimap_player_dot)\n',
        ]
        for k, nl in enumerate(method):
            lines.insert(i + k, nl)
        break

# Add minimap update in _process if there's one
for i, l in enumerate(lines):
    if "func _process" in l and "delta" in l:
        minimap_update = [
            '\t# Update minimap player dot\n',
            '\t_update_minimap_dot()\n',
        ]
        # Find end of _process method
        for j in range(i, min(i+20, len(lines))):
            if lines[j].strip() == "" and j > i + 3:
                for k, nl in enumerate(minimap_update):
                    lines.insert(j + k, nl)
                break
        break

# Add _update_minimap_dot
for i, l in enumerate(lines):
    if "func _create_minimap_dot" in l:
        end = i
        for j in range(i, len(lines)):
            if lines[j].strip() == "" and j > i + 10:
                end = j
                break
        update_method = [
            '\n',
            'func _update_minimap_dot():\n',
            '\tif not minimap_player_dot:\n',
            '\t\treturn\n',
            '\tvar players = get_tree().get_nodes_in_group("players")\n',
            '\tif players.size() == 0:\n',
            '\t\treturn\n',
            '\tvar player = players[0]\n',
            '\t# Convert world position (-100..100) to minimap (0..150)\n',
            '\tvar world_size = 100.0\n',
            '\tvar map_size = 150.0\n',
            '\tvar px = (player.global_position.x + world_size) / (world_size * 2.0) * map_size\n',
            '\tvar pz = (player.global_position.z + world_size) / (world_size * 2.0) * map_size\n',
            '\tminimap_player_dot.set_position(Vector2(px - 3, pz - 3))\n',
        ]
        for k, nl in enumerate(update_method):
            lines.insert(end + 1 + k, nl)
        break

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.writelines(lines)
print("hud.gd: functional minimap with player dot")

# ═══════════════════════════════════════════════
# 5. TAB FIX
# ═══════════════════════════════════════════════
for f in glob.glob(godot + "/**/*.gd", recursive=True):
    if f.endswith(".bak"): continue
    with open(f, "r", encoding="utf-8") as fh: lines = fh.readlines()
    nl = []
    for l in lines:
        if l.strip() and not l.strip().startswith("#"):
            s = l.lstrip(); lead = l[:len(l)-len(s)]
            sc = len(lead) - len(lead.lstrip(" "))
            nl.append(("\t" * (sc // 4) + " " * (sc % 4) + s) if sc > 0 else l)
        else: nl.append(l)
    with open(f, "w", encoding="utf-8", newline="\n") as fh: fh.writelines(nl)

print("\nAll done: Inventory + Enemies + DayNight + Minimap")
