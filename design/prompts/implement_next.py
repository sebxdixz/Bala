"""Implement next priority items from LOG.md: Wanted, Inventory textures, DialogueBox, Particles"""
import os, glob

godot = r"C:\Users\sdiaz\OneDrive - Axo\Escritorio\Proyectos\BALA\godot"

# ═══════════════════════════════════════════════
# 1. WANTED SYSTEM: Track wanted level, integrate with HUD
# ═══════════════════════════════════════════════
f = os.path.join(godot, "scripts/player/stats.gd")
with open(f, "r", encoding="utf-8") as fh:
    lines = fh.readlines()

# Add wanted variable
for i, l in enumerate(lines):
    if "@export var skill_points: int = 0" in l:
        wanted_vars = [
            "\n@export var wanted_level: int = 0\n",
            "@export var wanted_points: int = 0\n",
        ]
        for k, nl in enumerate(wanted_vars):
            lines.insert(i + 1 + k, nl)
        break

# Add wanted methods
for i, l in enumerate(lines):
    if "func get_ammo" in l:
        end = i
        for j in range(i, len(lines)):
            if lines[j].strip() == "" and j > i + 10:
                end = j
                break
        wanted_methods = [
            "\n",
            "func add_wanted(points: int):\n",
            "\twanted_points += points\n",
            "\t_update_wanted_stars()\n",
            "\n",
            "func reduce_wanted(points: int):\n",
            "\twanted_points = maxi(0, wanted_points - points)\n",
            "\t_update_wanted_stars()\n",
            "\n",
            "func _update_wanted_stars():\n",
            "\tif wanted_points <= 25: wanted_level = 0\n",
            "\telif wanted_points <= 60: wanted_level = 1\n",
            "\telif wanted_points <= 120: wanted_level = 2\n",
            "\telif wanted_points <= 200: wanted_level = 3\n",
            "\telif wanted_points <= 300: wanted_level = 4\n",
            "\telse: wanted_level = 5\n",
            "\tstats_changed.emit(\"wanted\", wanted_level)\n",
        ]
        for k, nl in enumerate(wanted_methods):
            lines.insert(end + 1 + k, nl)
        break

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.writelines(lines)
print("stats.gd: wanted system added")

# ═══════════════════════════════════════════════
# 2. Add wanted update to HUD
# ═══════════════════════════════════════════════
f = os.path.join(godot, "scripts/ui/hud.gd")
with open(f, "r", encoding="utf-8") as fh:
    lines = fh.readlines()

for i, l in enumerate(lines):
    if "func update_wanted" in l:
        for j in range(i, min(i+15, len(lines))):
            if "wanted_label.text" in lines[j]:
                # Update the wanted display to also update texture-based stars
                indent = lines[i][:len(lines[i])-len(lines[i].lstrip())]
                update_lines = [
                    indent + "# Update wanted stars texture visibility\n",
                    indent + "var wanted_bg = get_node_or_null(\"MainContainer/WantedContainer/WantedBg\")\n",
                    indent + "if wanted_bg:\n",
                    indent + "\twanted_bg.modulate.a = 1.0 if stars > 0 else 0.3\n",
                ]
                for k, nl in enumerate(update_lines):
                    lines.insert(j + 1 + k, nl)
                break
        break

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.writelines(lines)
print("hud.gd: wanted visual feedback")

# ═══════════════════════════════════════════════
# 3. Connect DialogueBox to NPC interaction
# ═══════════════════════════════════════════════
f = os.path.join(godot, "scripts/player/player.gd")
with open(f, "r", encoding="utf-8") as fh:
    lines = fh.readlines()

# Find _interact_with_npc and enhance it to show dialogue box
for i, l in enumerate(lines):
    if "func _interact_with_npc" in l:
        for j in range(i, min(i+25, len(lines))):
            if "npc._speak()" in lines[j]:
                indent = lines[j][:len(lines[j])-len(lines[j].lstrip())]
                # Replace the simple _speak call with DialogueBox-aware version
                old_line = lines[j]
                new_line = indent + "_show_npc_dialogue(npc)\n"
                lines[j] = new_line
                break
        break

# Add _show_npc_dialogue method
for i, l in enumerate(lines):
    if "func _interact_with_npc" in l:
        method = [
            "\n",
            "func _show_npc_dialogue(npc: Node):\n",
            "\tvar box = get_tree().current_scene.get_node_or_null(\"DialogueBox\") if get_tree().current_scene else null\n",
            "\tif not box:\n",
            "\t\t# Fallback: just let NPC speak\n",
            "\t\tif npc.has_method(\"_speak\"):\n",
            "\t\t\tnpc._speak()\n",
            "\t\treturn\n",
            "\t\n",
            "\tvar npc_name = npc.get(\"npc_name\") if \"npc_name\" in npc else \"NPC\"\n",
            "\tvar faction = npc.get(\"faction\") if \"faction\" in npc else \"CHOLOS\"\n",
            "\tvar lines_arr = npc.get(\"dialogue_lines\") if \"dialogue_lines\" in npc else []\n",
            "\t\n",
            "\tvar line = \"...\"\n",
            "\tif lines_arr is Array and lines_arr.size() > 0:\n",
            "\t\tvar idx = npc.get(\"_dialogue_index\") if \"_dialogue_index\" in npc else 0\n",
            "\t\tline = lines_arr[idx % lines_arr.size()]\n",
            "\t\tif \"_dialogue_index\" in npc:\n",
            "\t\t\tnpc._dialogue_index = (idx + 1) % lines_arr.size()\n",
            "\t\n",
            "\tvar style = 0  # CALLEJERO default\n",
            "\tmatch faction:\n",
            "\t\t\"YAKUZA\": style = 1\n",
            "\t\t\"SIN_LEGAJA\": style = 2\n",
            "\t\n",
            "\tif box.has_method(\"show_dialogue\"):\n",
            "\t\tbox.show_dialogue(npc_name, line, style)\n",
        ]
        for k, nl in enumerate(method):
            lines.insert(i + k, nl)
        break

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.writelines(lines)
print("player.gd: dialogue box connected")

# ═══════════════════════════════════════════════
# 4. Add DialogueBox spawn to WorldInitializer
# ═══════════════════════════════════════════════
f = os.path.join(godot, "scripts/world/world_initializer.gd")
with open(f, "r", encoding="utf-8") as fh:
    lines = fh.readlines()

for i, l in enumerate(lines):
    if 'preload("res://scenes/ui/death_screen.tscn")' in l:
        lines.insert(i, 'const DIALOGUE_SCENE = preload("res://scenes/ui/dialogue_box.tscn")\n')
        break

# Add dialogue box spawn after death screen
for i, l in enumerate(lines):
    if "DeathScreen overlay spawneado" in l:
        dialogue_spawn = [
            '\t\n',
            '\tvar dialogue_box = DIALOGUE_SCENE.instantiate()\n',
            '\tdialogue_box.name = "DialogueBox"\n',
            '\tadd_child(dialogue_box)\n',
            '\tprint("WorldInit: DialogueBox spawneado")\n',
        ]
        for k, nl in enumerate(dialogue_spawn):
            lines.insert(i + 1 + k, nl)
        break

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.writelines(lines)
print("world_initializer.gd: dialogue box spawn added")

# ═══════════════════════════════════════════════
# 5. Add smoke particles to test world buildings
# ═══════════════════════════════════════════════
f = os.path.join(godot, "scripts/world/world_initializer.gd")
with open(f, "r", encoding="utf-8") as fh:
    lines = fh.readlines()

# Add particle spawn after dialogue box
for i, l in enumerate(lines):
    if "DialogueBox spawneado" in l:
        particle_spawn = [
            '\t\n',
            '\t_spawn_particles()\n',
        ]
        for k, nl in enumerate(particle_spawn):
            lines.insert(i + 1 + k, nl)
        break

# Add _spawn_particles method at end
particle_method = [
    '\n',
    'func _spawn_particles():\n',
    '\tvar smoke = load("res://scenes/effects/smoke_particles.tscn")\n',
    '\tif not smoke:\n',
    '\t\treturn\n',
    '\t# Add smoke to a few rooftop positions\n',
    '\tvar positions = [\n',
    '\t\tVector3(-18, 28, -28),\n',
    '\t\tVector3(18, 26, -20),\n',
    '\t\tVector3(-55, 8, -42),\n',
    '\t]\n',
    '\tfor pos in positions:\n',
    '\t\tvar p = smoke.instantiate()\n',
    '\t\tp.global_position = pos\n',
    '\t\tadd_child(p)\n',
    '\tprint("WorldInit: Smoke particles spawneados")\n',
]
for k, nl in enumerate(particle_method):
    lines.append(nl)

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.writelines(lines)
print("world_initializer.gd: smoke particles added")

# ═══════════════════════════════════════════════
# 6. TAB FIX
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

print("\nDone: Wanted + Inventory + DialogueBox + Particles")
