f = r"C:\Users\sdiaz\OneDrive - Axo\Escritorio\Proyectos\BALA\godot\scripts\player\player.gd"
with open(f, "r", encoding="utf-8") as fh:
    lines = fh.readlines()

# Find _on_leveled_up and add skill points update after level update
added = False
for i, l in enumerate(lines):
    if "hud_node.update_level" in l and not added:
        indent = l[: len(l) - len(l.lstrip())]
        sp_line1 = indent + "if hud_node.has_method(\"update_skill_points\") and StatsManager:\n"
        sp_line2 = indent + "\thud_node.update_skill_points(StatsManager.skill_points)\n"
        lines.insert(i + 1, sp_line2)
        lines.insert(i + 1, sp_line1)
        print(f"Added SP update after line {i + 1}")
        added = True

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.writelines(lines)
print("Done")
