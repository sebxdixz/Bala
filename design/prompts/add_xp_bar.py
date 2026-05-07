f = r"C:\Users\sdiaz\OneDrive - Axo\Escritorio\Proyectos\BALA\godot\scripts\ui\hud.gd"
with open(f, "r", encoding="utf-8") as fh:
    lines = fh.readlines()

# Add _create_xp_bar call in _ready after _create_crosshair
for i, l in enumerate(lines):
    if "_create_crosshair()" in l:
        lines.insert(i + 1, "\t_create_xp_bar()\n")
        break

# Add _create_xp_bar method before _create_crosshair
for i, l in enumerate(lines):
    if "func _create_crosshair" in l:
        xp_method = [
            "\n",
            "func _create_xp_bar():\n",
            "\tif not has_node(\"MainContainer/PlayerInfo/VBoxInfo/XpBar\"):\n",
            "\t\tvar xp_bar = TextureProgressBar.new()\n",
            "\t\txp_bar.name = \"XpBar\"\n",
            "\t\txp_bar.custom_minimum_size = Vector2(240, 8)\n",
            "\t\txp_bar.value = 0.0\n",
            "\t\txp_bar.max_value = 100.0\n",
            "\t\txp_bar.fill_mode = 0\n",
            "\t\txp_bar.tint_progress = Color(1.0, 0.85, 0.0, 1)\n",
            "\t\txp_bar.tint_under = Color(0.12, 0.08, 0.02, 0.8)\n",
            "\t\tvar vbox = get_node(\"MainContainer/PlayerInfo/VBoxInfo\")\n",
            "\t\tvbox.add_child(xp_bar)\n",
            "\t\tvbox.move_child(xp_bar, vbox.get_child_count() - 1)\n",
        ]
        for j, nl in enumerate(xp_method):
            lines.insert(i + j, nl)
        break

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.writelines(lines)
print("HUD: XP bar added")
