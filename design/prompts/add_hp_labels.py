f = r"C:\Users\sdiaz\OneDrive - Axo\Escritorio\Proyectos\BALA\godot\scripts\ui\hud.gd"
with open(f, "r", encoding="utf-8") as fh:
    lines = fh.readlines()

# Add stat labels creation in _ready
for i, l in enumerate(lines):
    if "_create_xp_bar()" in l:
        lines.insert(i + 1, "\t_create_stat_labels()\n")
        break

# Add member vars + method
for i, l in enumerate(lines):
    if "func _create_xp_bar" in l:
        method = [
            "\n",
            "var hp_label: Label = null\n",
            "var stamina_label: Label = null\n",
            "\n",
            "func _create_stat_labels():\n",
            "\tvar vbox = get_node(\"MainContainer/PlayerInfo/VBoxInfo\")\n",
            "\tvar hp_bar = get_node(\"MainContainer/PlayerInfo/VBoxInfo/HealthBar\")\n",
            "\tvar st_bar = get_node(\"MainContainer/PlayerInfo/VBoxInfo/StaminaBar\")\n",
            "\t\n",
            "\thp_label = Label.new()\n",
            "\thp_label.text = \"100 / 100\"\n",
            "\thp_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT\n",
            "\thp_label.add_theme_font_size_override(\"font_size\", 13)\n",
            "\thp_label.add_theme_color_override(\"font_color\", Color(1, 0.3, 0.3, 0.95))\n",
            "\tvbox.add_child(hp_label)\n",
            "\tvbox.move_child(hp_label, hp_bar.get_index())\n",
            "\t\n",
            "\tstamina_label = Label.new()\n",
            "\tstamina_label.text = \"50 / 50\"\n",
            "\tstamina_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT\n",
            "\tstamina_label.add_theme_font_size_override(\"font_size\", 11)\n",
            "\tstamina_label.add_theme_color_override(\"font_color\", Color(1, 0.85, 0.2, 0.9))\n",
            "\tvbox.add_child(stamina_label)\n",
            "\tvbox.move_child(stamina_label, st_bar.get_index())\n",
        ]
        for k, nl in enumerate(method):
            lines.insert(i + k, nl)
        break

# Update update_hp to set label
for i, l in enumerate(lines):
    if "health_bar.value = float(current)" in l:
        indent = l[:len(l)-len(l.lstrip())]
        lines.insert(i + 1, indent + "if hp_label:\n")
        lines.insert(i + 2, indent + "\thp_label.text = \"%d / %d\" % [current, max_val]\n")
        break

# Update update_stamina to set label
for i, l in enumerate(lines):
    if "stamina_bar.value = float(current)" in l:
        indent = l[:len(l)-len(l.lstrip())]
        lines.insert(i + 1, indent + "if stamina_label:\n")
        lines.insert(i + 2, indent + "\tstamina_label.text = \"%d / %d\" % [current, max_val]\n")
        break

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.writelines(lines)
print("HP/Stamina labels added to HUD")
