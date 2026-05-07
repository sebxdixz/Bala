"""Final polish pass - adds XP bar, improves player, fixes tabs."""
import glob, os

godot = r"C:\Users\sdiaz\OneDrive - Axo\Escritorio\Proyectos\BALA\godot"

# 1. Add XP bar to hud.gd
f = os.path.join(godot, "scripts/ui/hud.gd")
with open(f, "r", encoding="utf-8") as fh:
    lines = fh.readlines()

# Find stamina bar to add XP bar after it
for i, l in enumerate(lines):
    if "StaminaBar" in l and "TextureProgressBar" in l:
        # Add XP bar node reference
        for j in range(i, len(lines)):
            if "func update_skill_points" in lines[j] or "func toggle_debug" in lines[j]:
                insert_point = j
                break
        else:
            insert_point = len(lines) - 5
        break

# Add update_xp method
# Find a good spot to add it
for i, l in enumerate(lines):
    if "func update_skill_points" in l:
        # Add update_xp after this method
        xp_method = [
            "\n",
            "func update_xp(current: int, max_val: int):\n",
            "\tvar xp_bar = get_node_or_null(\"MainContainer/PlayerInfo/VBoxInfo/XpBar\")\n",
            "\tif xp_bar:\n",
            "\t\txp_bar.max_value = float(max_val)\n",
            "\t\txp_bar.value = float(current)\n",
        ]
        # Find end of this method
        end = i
        for j in range(i, len(lines)):
            if lines[j].strip() == "" and j > i + 5:
                end = j
                break
        for j, nl in enumerate(xp_method):
            lines.insert(end + 1 + j, nl)
        break

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.writelines(lines)
print("hud.gd: added update_xp()")

# 2. Add XP bar to player's _update_hud call
f = os.path.join(godot, "scripts/player/player.gd")
with open(f, "r", encoding="utf-8") as fh:
    lines = fh.readlines()

# Find _update_hud and add XP update
for i, l in enumerate(lines):
    if "func _update_hud" in l:
        for j in range(i, min(i+30, len(lines))):
            if "hud_node.update_level" in lines[j]:
                indent = lines[j][:len(lines[j])-len(lines[j].lstrip())]
                xp_line = indent + "if hud_node.has_method(\"update_xp\") and StatsManager:\n"
                xp_line2 = indent + "\thud_node.update_xp(StatsManager.current_xp, StatsManager.xp_to_next_level)\n"
                lines.insert(j + 1, xp_line2)
                lines.insert(j + 1, xp_line)
                print("player.gd: added XP bar update")
                break
        break

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.writelines(lines)

# 3. Fix all tabs
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
print("Done")
