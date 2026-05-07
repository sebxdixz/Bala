"""Apply CLI Ink terminal theme to HUD"""
import os, glob

f = r"C:\Users\sdiaz\OneDrive - Axo\Escritorio\Proyectos\BALA\godot\scripts\ui\hud.gd"
with open(f, "r", encoding="utf-8") as fh:
    lines = fh.readlines()

# 1. Add CLI constants after imports/class vars
for i, l in enumerate(lines):
    if "var _cli_font: FontFile = null" in l:
        break
    if "var minimap_player_dot" in l or ("var crosshair" in l and "Control" in l):
        cli_vars = [
            "\n# CLI Ink terminal theme\n",
            "const CLI_GREEN = Color(0.0, 1.0, 0.2, 1.0)\n",
            "const CLI_CYAN = Color(0.0, 0.9, 1.0, 1.0)\n",
            "const CLI_AMBER = Color(1.0, 0.7, 0.1, 1.0)\n",
            "const CLI_RED = Color(1.0, 0.2, 0.2, 1.0)\n",
            "const CLI_MAGENTA = Color(1.0, 0.0, 0.667, 1.0)\n",
            "const CLI_DIM = Color(0.3, 0.35, 0.3, 0.8)\n",
            "const CLI_BG = Color(0.05, 0.08, 0.05, 0.92)\n",
        ]
        for k, nl in enumerate(cli_vars):
            lines.insert(i + k, nl)
        break

# 2. Add _cli_font member + load in _ready
for i, l in enumerate(lines):
    if "var _cli_font" in l:
        break
    if "var crosshair: Control = null" in l:
        lines.insert(i + 1, "var _cli_font: FontFile = null\n")
        break

for i, l in enumerate(lines):
    if "_apply_textures()" in l:
        lines.insert(i + 1, "\t_cli_font = load(\"res://assets/fonts/JetBrainsMono/JetBrainsMono-Regular.ttf\")\n")
        lines.insert(i + 2, "\t_apply_cli_style()\n")
        break

# 3. Add _apply_cli_style method
for i, l in enumerate(lines):
    if "func _create_xp_bar" in l:
        cli_method = [
            "\n",
            "func _apply_cli_style():\n",
            "\tvar labels = find_children(\"*\", \"Label\", true, false)\n",
            "\tfor label in labels:\n",
            "\t\tif _cli_font:\n",
            "\t\t\tlabel.add_theme_font_override(\"font\", _cli_font)\n",
            "\t\tlabel.add_theme_color_override(\"font_color\", CLI_GREEN)\n",
            "\t\n",
            "\tvar buttons = find_children(\"*\", \"Button\", true, false)\n",
            "\tfor btn in buttons:\n",
            "\t\tif _cli_font:\n",
            "\t\t\tbtn.add_theme_font_override(\"font\", _cli_font)\n",
            "\t\tbtn.add_theme_color_override(\"font_color\", CLI_CYAN)\n",
            "\t\n",
            "\t# CLI-style progress bars\n",
            "\tvar hp = get_node_or_null(\"MainContainer/PlayerInfo/VBoxInfo/HealthBar\")\n",
            "\tif hp:\n",
            "\t\thp.tint_progress = CLI_GREEN\n",
            "\t\thp.tint_under = Color(0.05, 0.1, 0.05, 0.9)\n",
            "\t\n",
            "\tvar st = get_node_or_null(\"MainContainer/PlayerInfo/VBoxInfo/StaminaBar\")\n",
            "\tif st:\n",
            "\t\tst.tint_progress = CLI_AMBER\n",
            "\t\tst.tint_under = Color(0.1, 0.08, 0.02, 0.9)\n",
            "\t\n",
            "\tvar pname = get_node_or_null(\"MainContainer/PlayerInfo/VBoxInfo/PlayerName\")\n",
            "\tif pname:\n",
            "\t\tpname.add_theme_color_override(\"font_color\", CLI_CYAN)\n",
        ]
        for k, nl in enumerate(cli_method):
            lines.insert(i + k, nl)
        break

# 4. CLI-format labels
for i, l in enumerate(lines):
    if "hp_label.text = " in l and "%d / %d" in l:
        indent = l[:len(l)-len(l.lstrip())]
        lines[i] = indent + 'hp_label.text = "[ HP ]  %d / %d" % [current, max_val]\n'
for i, l in enumerate(lines):
    if "stamina_label.text = " in l and "%d / %d" in l:
        indent = l[:len(l)-len(l.lstrip())]
        lines[i] = indent + 'stamina_label.text = "[ ST ]  %d / %d" % [current, max_val]\n'

# 5. Hotbar brackets
for i, l in enumerate(lines):
    if 'slot_node.text = str(slot + 1)' in l:
        indent = l[:len(l)-len(l.lstrip())]
        lines[i] = indent + 'slot_node.text = "[" + str(slot + 1) + "]"\n'

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.writelines(lines)

# Tab fix
for f in glob.glob(os.path.dirname(f) + "/../../**/*.gd", recursive=True):
    if f.endswith(".bak"): continue
    with open(f, "r", encoding="utf-8") as fh: lines2 = fh.readlines()
    nl = []
    for l in lines2:
        if l.strip() and not l.strip().startswith("#"):
            s = l.lstrip(); lead = l[:len(l)-len(s)]
            sc = len(lead) - len(lead.lstrip(" "))
            nl.append(("\t" * (sc // 4) + " " * (sc % 4) + s) if sc > 0 else l)
        else: nl.append(l)
    with open(f, "w", encoding="utf-8", newline="\n") as fh: fh.writelines(nl)

print("CLI Ink theme applied + tabs fixed")
