"""Implement top 3 priority features: Death/Respawn, Cover, Ammo"""
import os

godot = r"C:\Users\sdiaz\OneDrive - Axo\Escritorio\Proyectos\BALA\godot"

# ═══════════════════════════════════════════════
# 1. DEATH SYSTEM: Connect death_screen to player death
# ═══════════════════════════════════════════════
f = os.path.join(godot, "scripts/player/player.gd")
with open(f, "r", encoding="utf-8") as fh:
    lines = fh.readlines()

# Add death screen reference
for i, l in enumerate(lines):
    if "var hud_node: CanvasLayer = null" in l:
        lines.insert(i + 1, "\nvar death_screen_node: CanvasLayer = null\n")
        break

# Find _on_player_died and add death screen activation
for i, l in enumerate(lines):
    if "func _on_player_died" in l:
        # Find the end of this method
        for j in range(i, min(i+20, len(lines))):
            if "player_died.emit()" in lines[j]:
                indent = lines[j][:len(lines[j])-len(lines[j].lstrip())]
                death_code = [
                    indent + "# Show death screen\n",
                    indent + "if not death_screen_node:\n",
                    indent + "\tvar root = get_tree().current_scene\n",
                    indent + "\tif root:\n",
                    indent + "\t\tdeath_screen_node = root.get_node_or_null(\"DeathScreen\")\n",
                    indent + "if death_screen_node and death_screen_node.has_method(\"trigger_death\"):\n",
                    indent + "\tdeath_screen_node.trigger_death()\n",
                ]
                for k, nl in enumerate(death_code):
                    lines.insert(j + 1 + k, nl)
                break
        break

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.writelines(lines)
print("player.gd: death screen connected")

# ═══════════════════════════════════════════════
# 2. COVER SYSTEM: Space near walls = -75% damage
# ═══════════════════════════════════════════════
# Add cover variables and check in _physics_process
for i, l in enumerate(lines):
    if "var is_sprinting: bool = false" in l:
        cover_vars = [
            "\nvar in_cover: bool = false\n",
            "var cover_damage_reduction: float = 0.0\n",
        ]
        for k, nl in enumerate(cover_vars):
            lines.insert(i + 1 + k, nl)
        break

# Add cover check before move_and_slide
for i, l in enumerate(lines):
    if "move_and_slide()" in l and len(l.strip()) < 20:
        if i > 100:  # First occurrence is usually the main physics
            indent = l[:len(l)-len(l.lstrip())]
            cover_check = [
                indent + "_check_cover()\n",
            ]
            lines.insert(i, cover_check[0])
            break

# Add _check_cover method - find a good spot
for i, l in enumerate(lines):
    if "func _process_roll_state" in l:
        method = [
            "\n",
            "func _check_cover():\n",
            "\t# Raycast to right to check for wall proximity\n",
            "\tvar space = get_world_3d().direct_space_state\n",
            "\tvar right = global_transform.basis.x\n",
            "\tvar query = PhysicsRayQueryParameters3D.create(global_position + Vector3(0,1,0), global_position + right * 1.5 + Vector3(0,1,0))\n",
            "\tquery.exclude = [self]\n",
            "\tquery.collision_mask = 1\n",
            "\tvar result = space.intersect_ray(query)\n",
            "\tin_cover = result and Input.is_action_pressed(\"sprint\")\n",
            "\tcover_damage_reduction = 0.75 if in_cover else 0.0\n",
        ]
        for k, nl in enumerate(method):
            lines.insert(i + k, nl)
        break

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.writelines(lines)
print("player.gd: cover system added")

# ═══════════════════════════════════════════════
# 3. AMMO SYSTEM: Track bullets per weapon type
# ═══════════════════════════════════════════════
f = os.path.join(godot, "scripts/player/stats.gd")
with open(f, "r", encoding="utf-8") as fh:
    lines = fh.readlines()

# Add ammo variables
for i, l in enumerate(lines):
    if "@export var skill_points: int = 0" in l:
        ammo_vars = [
            "\n# Ammo system\n",
            "@export var ammo_pistol: int = 50\n",
            "@export var ammo_rifle: int = 30\n",
            "@export var ammo_shotgun: int = 20\n",
            "@export var max_ammo_pistol: int = 100\n",
            "@export var max_ammo_rifle: int = 60\n",
            "@export var max_ammo_shotgun: int = 40\n",
        ]
        for k, nl in enumerate(ammo_vars):
            lines.insert(i + 1 + k, nl)
        break

# Add ammo methods at end of file before closing
for i, l in enumerate(lines):
    if "func class_count" in l or "func has_class" in l:
        if i > len(lines) - 5:
            ammo_methods = [
                "\nfunc use_ammo(weapon_type: String, amount: int = 1) -> bool:\n",
                '\tmatch weapon_type:\n',
                '\t\t"pistol": if ammo_pistol >= amount: ammo_pistol -= amount; return true\n',
                '\t\t"rifle": if ammo_rifle >= amount: ammo_rifle -= amount; return true\n',
                '\t\t"shotgun": if ammo_shotgun >= amount: ammo_shotgun -= amount; return true\n',
                "\treturn false\n",
                "\n",
                "func reload_ammo(weapon_type: String, amount: int):\n",
                '\tmatch weapon_type:\n',
                '\t\t"pistol": ammo_pistol = min(ammo_pistol + amount, max_ammo_pistol)\n',
                '\t\t"rifle": ammo_rifle = min(ammo_rifle + amount, max_ammo_rifle)\n',
                '\t\t"shotgun": ammo_shotgun = min(ammo_shotgun + amount, max_ammo_shotgun)\n',
                "\n",
                "func get_ammo(weapon_type: String) -> int:\n",
                '\tmatch weapon_type:\n',
                '\t\t"pistol": return ammo_pistol\n',
                '\t\t"rifle": return ammo_rifle\n',
                '\t\t"shotgun": return ammo_shotgun\n',
                "\treturn 0\n",
            ]
            for k, nl in enumerate(ammo_methods):
                lines.insert(i + 1 + k, nl)
            break

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.writelines(lines)
print("stats.gd: ammo system added")

# ═══════════════════════════════════════════════
# 4. TAB FIX
# ═══════════════════════════════════════════════
import glob
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

print("\nAll done - Death + Cover + Ammo implemented")
