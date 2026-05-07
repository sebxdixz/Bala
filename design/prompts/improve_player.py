"""Improve player visuals - faction colors, better body"""
import os

f = r"C:\Users\sdiaz\OneDrive - Axo\Escritorio\Proyectos\BALA\godot\scripts\player\player.gd"
with open(f, "r", encoding="utf-8") as fh:
    lines = fh.readlines()

# Find _ready and add player material setup
for i, l in enumerate(lines):
    if "Input.mouse_mode = Input.MOUSE_MODE_CAPTURED" in l:
        setup_code = [
            "\t# Apply faction colors to player body\n",
            "\t_apply_faction_colors()\n",
        ]
        for j, nl in enumerate(setup_code):
            lines.insert(i + j + 1, nl)
        break

# Add _apply_faction_colors method - find a good insertion point
for i, l in enumerate(lines):
    if "func _find_hud" in l:
        faction_method = [
            "\n",
            "func _apply_faction_colors():\n",
            "\tvar colors = {\n",
            "\t\t\"YAKUZA\": Color(0.05, 0.05, 0.15),\n",
            "\t\t\"CARTEL\": Color(0.3, 0.15, 0.05),\n",
            "\t\t\"MAFIA\": Color(0.08, 0.02, 0.02),\n",
            "\t\t\"POLICIA\": Color(0.05, 0.08, 0.2),\n",
            "\t\t\"CHOLOS\": Color(0.15, 0.02, 0.2),\n",
            "\t\t\"SIN_LEGAJA\": Color(0.15, 0.15, 0.1),\n",
            "\t}\n",
            "\tvar color = colors.get(player_faction, Color(0.15, 0.15, 0.2))\n",
            "\tvar mat = StandardMaterial3D.new()\n",
            "\tmat.albedo_color = color\n",
            "\tmat.roughness = 0.7\n",
            "\tif mesh_instance:\n",
            "\t\tmesh_instance.material_override = mat\n",
        ]
        for j, nl in enumerate(faction_method):
            lines.insert(i + j, nl)
        break

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.writelines(lines)
print("Player: faction colors added")
