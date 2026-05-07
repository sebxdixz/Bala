import glob, os

godot = r"C:\Users\sdiaz\OneDrive - Axo\Escritorio\Proyectos\BALA\godot"

# 1. hud.gd: add update_skill_points
f = os.path.join(godot, "scripts/ui/hud.gd")
with open(f, "r", encoding="utf-8") as fh:
    lines = fh.readlines()

inserted = False
for i, l in enumerate(lines):
    if "func toggle_debug" in l and not inserted:
        new_code = [
            "\n",
            "func update_skill_points(points: int):\n",
            "\tif level_label:\n",
            "\t\tvar lvl = 1\n",
            "\t\tif StatsManager:\n",
            "\t\t\tlvl = StatsManager.level\n",
            "\t\tlevel_label.text = \"Nivel %d | SP: %d\" % [lvl, points]\n",
            "\n",
        ]
        for j, nl in enumerate(new_code):
            lines.insert(i + j, nl)
        inserted = True
        break

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.writelines(lines)
print("hud.gd: added update_skill_points()")

# 2. Fix all tabs in all .gd files
for f in glob.glob(godot + "/**/*.gd", recursive=True):
    if f.endswith(".bak"):
        continue
    with open(f, "r", encoding="utf-8") as fh:
        lines = fh.readlines()
    nl = []
    for l in lines:
        if l.strip() and not l.strip().startswith("#"):
            s = l.lstrip()
            lead = l[: len(l) - len(s)]
            sc = len(lead) - len(lead.lstrip(" "))
            nl.append(("\t" * (sc // 4) + " " * (sc % 4) + s) if sc > 0 else l)
        else:
            nl.append(l)
    with open(f, "w", encoding="utf-8", newline="\n") as fh:
        fh.writelines(nl)

print("All tabs fixed")

# 3. Verify
bad = 0
for f in glob.glob(godot + "/**/*.gd", recursive=True):
    if f.endswith(".bak"):
        continue
    with open(f, "r", encoding="utf-8") as fh:
        for i, l in enumerate(fh.readlines()):
            s = l.lstrip()
            if s and not s.startswith("#"):
                lead = l[: len(l) - len(s)]
                if lead and lead[0] == " ":
                    bad += 1
                    if bad <= 3:
                        print(f"WARN: {os.path.basename(f)}:{i+1} has spaces")
                    break
print(f"Files with spaces: {bad}")
print("Done")
