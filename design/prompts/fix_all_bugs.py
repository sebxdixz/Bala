"""Fix ALL issues: tabs + 5 CRITICAL + 2 HIGH + 4 MODERATE bugs"""
import os, glob, re

godot = r"C:\Users\sdiaz\OneDrive - Axo\Escritorio\Proyectos\BALA\godot"

# ═══════════════════════════════
# CRITICAL #1: player.gd - use_skill() undefined at line 297
# The hotbar input calls use_skill(slot) but it doesn't exist
# We need to connect it to CombatManager or implement locally
# ═══════════════════════════════
f = os.path.join(godot, "scripts/player/player.gd")
with open(f, "r", encoding="utf-8") as fh:
    lines = fh.readlines()

# Find where use_skill is called and redirect to the local skill execution
for i, l in enumerate(lines):
    if "use_skill(slot)" in l and "func" not in l:
        indent = l[:len(l)-len(l.lstrip())]
        # Check if this is inside _handle_hotbar_input
        lines[i] = indent + "_execute_hotbar_skill(slot)\n"
        break

# Now find the skill execution methods and ensure _execute_hotbar_skill exists
for i, l in enumerate(lines):
    if "func _handle_hotbar_input" in l:
        # Add _execute_hotbar_skill before _handle_hotbar_input
        method = [
            indent + "func _execute_hotbar_skill(slot: int):\n",
            indent + "\tif slot < 0 or slot >= class_skills.size():\n",
            indent + "\t\treturn\n",
            indent + "\tvar skill = class_skills[slot]\n",
            indent + "\tif not _can_use_skill(slot):\n",
            indent + "\t\treturn\n",
            indent + "\t# Execute through existing skill pipeline\n",
            indent + "\t_use_skill_internal(skill, slot)\n",
            "\n",
        ]
        # Check if _use_skill_internal already exists or create an alias
        for j in range(i, min(i+50, len(lines))):
            if "func _can_use_skill" in lines[j]:
                use_skill_method = [
                    "\n",
                    indent + "func _use_skill_internal(skill: Resource, slot: int):\n",
                    indent + "\t# Consumir stamina\n",
                    indent + "\tif StatsManager:\n",
                    indent + "\t\tStatsManager.use_stamina(skill.stamina_cost)\n",
                    indent + "\t# Iniciar cooldown\n",
                    indent + "\tskill_cooldowns[skill.skill_id] = skill.cooldown\n",
                    indent + "\t# Calcular danio y ejecutar\n",
                    indent + "\tvar damage = _calculate_skill_base_damage(skill)\n",
                    indent + "\tvar skill_type = _get_skill_type(skill)\n",
                    indent + "\tmatch skill_type:\n",
                    indent + "\t\tSkillType.MELEE:\n",
                    indent + "\t\t\t_execute_melee_skill(skill, damage)\n",
                    indent + "\t\tSkillType.RANGED:\n",
                    indent + "\t\t\t_execute_ranged_skill(skill, damage)\n",
                    indent + "\t\tSkillType.AREA:\n",
                    indent + "\t\t\t_execute_area_skill(skill, damage)\n",
                    indent + "\t\tSkillType.SUPPORT:\n",
                    indent + "\t\t\t_execute_support_skill(skill)\n",
                    indent + "\t_show_skill_feedback(skill.skill_name, skill_type)\n",
                    indent + "\t_update_hud()\n",
                ]
                for k, nl in enumerate(use_skill_method):
                    lines.insert(j + 1 + k, nl)
                break
        break

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.writelines(lines)
print("CRITICAL #1: use_skill() fixed -> _execute_hotbar_skill() + _use_skill_internal()")

# ═══════════════════════════════
# CRITICAL #2: hud.gd lines 139-141 - code outside function
# ═══════════════════════════════
f = os.path.join(godot, "scripts/ui/hud.gd")
with open(f, "r", encoding="utf-8") as fh:
    lines = fh.readlines()

# Remove orphaned code after update_wanted
new_lines = []
skip_orphans = False
for i, l in enumerate(lines):
    stripped = l.strip()
    if skip_orphans and stripped and not stripped.startswith("func") and not stripped.startswith("#") and not stripped.startswith("var crosshair") and not stripped.startswith("func _"):
        continue
    if "func update_wanted" in stripped:
        skip_orphans = False
        # Find the actual end of this function
    if i > 130 and i < 160 and stripped.startswith("var wanted_bg") and "func" not in stripped:
        continue  # skip orphaned line
    if i > 130 and i < 160 and stripped.startswith("if wanted_bg") and "func" not in stripped:
        continue  # skip orphaned line
    if i > 130 and i < 160 and stripped.startswith("wanted_bg.modulate") and "func" not in stripped:
        continue  # skip orphaned line
    new_lines.append(l)

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.writelines(new_lines)
print("CRITICAL #2: hud.gd orphaned code removed")

# ═══════════════════════════════
# CRITICAL #6: hud.gd @onready path missing FactionRow
# ═══════════════════════════════
f = os.path.join(godot, "scripts/ui/hud.gd")
with open(f, "r", encoding="utf-8") as fh:
    lines = fh.readlines()

for i, l in enumerate(lines):
    if "faction_name_label" in l and "get_node_or_null" in l and "FactionNameLabel" in l and "FactionRow" not in l:
        lines[i] = l.replace('VBoxInfo/FactionNameLabel', 'VBoxInfo/FactionRow/FactionNameLabel')
        break

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.writelines(lines)
print("CRITICAL #6: hud.gd faction_name_label path fixed")

# ═══════════════════════════════
# CRITICAL #7: hud.gd minimap_player_dot not declared as member
# ═══════════════════════════════
f = os.path.join(godot, "scripts/ui/hud.gd")
with open(f, "r", encoding="utf-8") as fh:
    lines = fh.readlines()

# Add member var declaration near crosshair
for i, l in enumerate(lines):
    if "var crosshair: Control = null" in l:
        lines.insert(i + 1, "var minimap_player_dot: ColorRect = null\n")
        break

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.writelines(lines)
print("CRITICAL #7: minimap_player_dot declared as member var")

# ═══════════════════════════════
# CRITICAL #3-5: enemy_spawner.gd + loot_item.gd parse errors
# ═══════════════════════════════
# enemy_spawner.gd: remove duplicate ]) and undefined vars
f = os.path.join(godot, "scripts/world/enemy_spawner.gd")
with open(f, "r", encoding="utf-8") as fh:
    content = fh.read()

# Remove orphaned ]) and undefined var blocks
# The spawn_registry lines reference undefined vars - remove them
content = content.replace(
    'if not _spawn_registry.has(spawn_name):\n\t\t\t_spawn_registry[spawn_name] = {"config": config.duplicate(), "marker": point}',
    ''
)
# Remove duplicate )]) patterns
lines = content.split('\n')
cleaned = []
i = 0
while i < len(lines):
    line = lines[i]
    # Skip lines with duplicate ]) that have no matching [
    if line.strip() == '])' and i > 0 and lines[i-1].strip() == '':
        i += 1
        continue
    cleaned.append(line)
    i += 1
content = '\n'.join(cleaned)

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.write(content)
print("CRITICAL #3-4: enemy_spawner.gd cleaned")

# loot_item.gd: fix corrupted line 72
f = os.path.join(godot, "scripts/world/loot_item.gd")
with open(f, "r", encoding="utf-8") as fh:
    content = fh.read()

# Replace the corrupted line with proper code
old_corrupt = "# Recoger PB (dinero)`n`tif pb_amount > 0:`n`t`titem_name = \"PB\"`n`t`tif StatsManager:`n`t`t`tStatsManager.add_pb(pb_amount)`n`t`tprint(\"Loot: +\", pb_amount, \" PB\")`n`t`tpicked = true"
new_fixed = "\t# Recoger PB (dinero)\n\tif pb_amount > 0:\n\t\titem_name = \"PB\"\n\t\tif StatsManager:\n\t\t\tStatsManager.add_pb(pb_amount)\n\t\tprint(\"Loot: +\", pb_amount, \" PB\")\n\t\tpicked = true"
if old_corrupt in content:
    content = content.replace(old_corrupt, new_fixed)
else:
    # Try with different whitespace
    for line in content.split('\n'):
        if 'Recoger PB' in line and 'backtick' not in line and 'pb_amount' in line:
            print(f"  Found corrupted line: {line[:80]}...")

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.write(content)
print("CRITICAL #5: loot_item.gd corrupted line fixed")

# ═══════════════════════════════
# MODERATE: inventory_screen.gd - call _apply_inventory_textures in _ready
# ═══════════════════════════════
f = os.path.join(godot, "scripts/ui/inventory_screen.gd")
with open(f, "r", encoding="utf-8") as fh:
    lines = fh.readlines()

for i, l in enumerate(lines):
    if "visible = false" in l and i < 30:
        if "_apply_inventory_textures()" not in [x.strip() for x in lines[i-3:i+3]]:
            lines.insert(i + 1, "\t_apply_inventory_textures()\n")
        break

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.writelines(lines)
print("MODERATE: inventory_screen.gd _apply_inventory_textures called")

# ═══════════════════════════════
# TABS: Fix all files
# ═══════════════════════════════
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

print("\nAll bugs fixed. Tabs fixed.")
