"""Fix details: main menu entry point, game name, NPC dialogue, etc."""
import os

godot = r"C:\Users\sdiaz\OneDrive - Axo\Escritorio\Proyectos\BALA\godot"

# 1. Change game name to BALA
f = os.path.join(godot, "project.godot")
with open(f, "r", encoding="utf-8") as fh:
    content = fh.read()
content = content.replace('config/name="Barrio Sin Ley Online"', 'config/name="BALA"')
content = content.replace('config/description="MMO Action-RPG', 'config/description="BALA - MMO Action-RPG')
# Set main menu as entry
content = content.replace('run/main_scene="scenes/world/test_world.tscn"', 'run/main_scene="scenes/menu/main_menu.tscn"')
with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.write(content)
print("project.godot: name=BALA, main=main_menu")

# 2. Add script to main_menu.tscn
f = os.path.join(godot, "scenes/menu/main_menu.tscn")
with open(f, "r", encoding="utf-8") as fh:
    lines = fh.readlines()

# Check if script is already attached
has_script = any("main_menu.gd" in l for l in lines)
if not has_script:
    # Add ext_resource for script
    for i, l in enumerate(lines):
        if "format=3" in l and "gd_scene" in l:
            # Insert ext_resource after gd_scene line
            lines.insert(i + 1, '\n[ext_resource type="Script" path="res://scripts/ui/main_menu.gd" id="10_menu_script"]\n')
            break
    
    # Add script to MainMenu node
    for i, l in enumerate(lines):
        if 'node name="MainMenu" type="Control"' in l:
            lines[i] = l.replace('type="Control"', 'type="Control"')
            lines.insert(i + 1, 'script = ExtResource("10_menu_script")\n')
            break
    
    # Connect buttons to script methods
    for i, l in enumerate(lines):
        if "NewGameBtn" in l and "node name" in l:
            lines.insert(i + 3, 'pressed.connect(_on_new_game_pressed)\n')
        if "QuitBtn" in l and "node name" in l:
            lines.insert(i + 3, 'pressed.connect(_on_quit_pressed)\n')
    
    # Update load_steps
    for i, l in enumerate(lines):
        if l.startswith("[gd_scene load_steps="):
            current = int(l.split("=")[1].split()[0])
            lines[i] = l.replace(f"load_steps={current}", f"load_steps={current + 1}")
            break
    
    with open(f, "w", encoding="utf-8", newline="\n") as fh:
        fh.writelines(lines)
    print("main_menu.tscn: script attached, buttons connected")

# 3. Update global.gd to support new game button
f = os.path.join(godot, "scripts/global/global.gd")
with open(f, "r", encoding="utf-8") as fh:
    lines = fh.readlines()

# Add toggle_inventory input action if missing
# Actually, check if the scene change works - it already exists

# 4. Add NPC dialogue trigger to player interaction
f = os.path.join(godot, "scripts/player/player.gd")
with open(f, "r", encoding="utf-8") as fh:
    lines = fh.readlines()

# Find interact handling - check if F key triggers NPC dialogue
has_dialogue = any("dialogue" in l.lower() for l in lines if "func _" in l)
if not has_dialogue:
    # Add dialogue interaction in _input
    for i, l in enumerate(lines):
        if "toggle_camera" in l and "event.is_action_pressed" in l:
            for j in range(i, min(i+10, len(lines))):
                if "toggle_camera_view()" in lines[j]:
                    indent = lines[j][:len(lines[j])-len(lines[j].lstrip())]
                    dialogue_code = [
                        indent + "# NPC interaction\n",
                        indent + "if event.is_action_pressed(\"interact\"):\n",
                        indent + "\t_interact_with_npc()\n",
                    ]
                    for k, nl in enumerate(dialogue_code):
                        lines.insert(j + 1 + k, nl)
                    break
            break
    
    # Add _interact_with_npc method
    for i, l in enumerate(lines):
        if "func _find_hud" in l:
            interact_method = [
                "\n",
                "func _interact_with_npc():\n",
                "\tvar npcs = get_tree().get_nodes_in_group(\"npcs\")\n",
                "\tfor npc in npcs:\n",
                "\t\tif not is_instance_valid(npc):\n",
                "\t\t\tcontinue\n",
                "\t\tvar dist = global_position.distance_to(npc.global_position)\n",
                "\t\tif dist < 4.0:\n",
                "\t\t\tif npc.has_method(\"_speak\"):\n",
                "\t\t\t\tnpc._speak()\n",
                "\t\t\telif npc.has_method(\"interact\"):\n",
                "\t\t\t\tnpc.interact()\n",
                "\t\t\treturn\n",
            ]
            for j, nl in enumerate(interact_method):
                lines.insert(i + j, nl)
            break

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.writelines(lines)
print("player.gd: NPC interaction added")

# 5. Fix all tabs
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

print("All tabs fixed")
print("\nDone - Details fixed")
