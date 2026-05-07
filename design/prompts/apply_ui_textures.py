"""Apply UI textures programmatically to avoid Godot .tscn regeneration issues."""
import os

godot = r"C:\Users\sdiaz\OneDrive - Axo\Escritorio\Proyectos\BALA\godot"

# ═══════════════════════════════════════════════
# 1. hud.gd - Add texture loading for minimap, hotbar, wanted, emblems
# ═══════════════════════════════════════════════
f = os.path.join(godot, "scripts/ui/hud.gd")
with open(f, "r", encoding="utf-8") as fh:
    lines = fh.readlines()

# Add texture setup call in _ready, after _create_crosshair
for i, l in enumerate(lines):
    if "_create_xp_bar()" in l:
        lines.insert(i + 1, "\t_apply_textures()\n")
        break

# Add _apply_textures method before _create_crosshair
for i, l in enumerate(lines):
    if "func _create_crosshair" in l:
        method = [
            "\n",
            "func _apply_textures():\n",
            "\t# Load UI textures at runtime (avoids .tscn regeneration issues)\n",
            "\tvar minimap_tex = load(\"res://assets/ui/minimap_circular.png\")\n",
            "\tvar hotbar_tex = load(\"res://assets/ui/hotbar_10_slots.png\")\n",
            "\tvar wanted_tex = load(\"res://assets/ui/wanted_stars.png\")\n",
            "\tvar emblems_tex = load(\"res://assets/ui/faction_emblems_sheet.png\")\n",
            "\t\n",
            "\t# Apply to existing nodes if they dont have textures\n",
            "\tvar minimap = get_node_or_null(\"MainContainer/Minimap/MinimapTex\")\n",
            "\tif minimap and minimap is TextureRect and minimap.texture == null:\n",
            "\t\tminimap.texture = minimap_tex\n",
            "\t\tminimap.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED\n",
            "\t\n",
            "\tvar hotbar_bg = get_node_or_null(\"MainContainer/HotbarContainer/HotbarBg\")\n",
            "\tif hotbar_bg and hotbar_bg is TextureRect and hotbar_bg.texture == null:\n",
            "\t\thotbar_bg.texture = hotbar_tex\n",
            "\t\thotbar_bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED\n",
            "\t\n",
            "\tvar wanted_bg = get_node_or_null(\"MainContainer/WantedContainer/WantedBg\")\n",
            "\tif wanted_bg and wanted_bg is TextureRect and wanted_bg.texture == null:\n",
            "\t\twanted_bg.texture = wanted_tex\n",
            "\t\twanted_bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED\n",
            "\t\n",
            "\tvar emblem = get_node_or_null(\"MainContainer/PlayerInfo/VBoxInfo/FactionRow/FactionEmblem\")\n",
            "\tif emblem and emblem is TextureRect and emblem.texture == null:\n",
            "\t\temblem.texture = emblems_tex\n",
            "\t\temblem.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED\n",
        ]
        for j, nl in enumerate(method):
            lines.insert(i + j, nl)
        break

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.writelines(lines)
print("hud.gd: texture loading added")

# ═══════════════════════════════════════════════
# 2. inventory_screen.gd - Apply inventory textures
# ═══════════════════════════════════════════════
f = os.path.join(godot, "scripts/ui/inventory_screen.gd")
with open(f, "r", encoding="utf-8") as fh:
    lines = fh.readlines()

# Add texture loading in _ready
for i, l in enumerate(lines):
    if "visible = false" in l and "func _ready" in [x.strip() for x in lines[max(0,i-3):i+1]]:
        lines.insert(i + 1, "\t_apply_inventory_textures()\n")
        break

# Add method at end of _ready area
for i, l in enumerate(lines):
    if "func _on_inventory_opened" in l:
        method = [
            "\n",
            "func _apply_inventory_textures():\n",
            "\tvar inv_bg_tex = load(\"res://assets/ui/inventory_background.png\")\n",
            "\tvar inv_grid_tex = load(\"res://assets/ui/inventory_grid.png\")\n",
            "\t\n",
            "\tvar bg = get_node_or_null(\"InventoryPanel/InvBackground\")\n",
            "\tif bg and bg is TextureRect and bg.texture == null:\n",
            "\t\tbg.texture = inv_bg_tex\n",
            "\t\tbg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED\n",
        ]
        for j, nl in enumerate(method):
            lines.insert(i + j, nl)
        break

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.writelines(lines)
print("inventory_screen.gd: texture loading added")

# ═══════════════════════════════════════════════
# 3. loading_screen.gd - Apply loading texture
# ═══════════════════════════════════════════════
f = os.path.join(godot, "scripts/ui/loading_screen.gd")
with open(f, "r", encoding="utf-8") as fh:
    lines = fh.readlines()

for i, l in enumerate(lines):
    if "visible = false" in l and i < 15:
        lines.insert(i + 1, "\t_apply_texture()\n")
        break

for i, l in enumerate(lines):
    if "func show_loading" in l:
        lines.insert(i, "func _apply_texture():\n\tvar bg = get_node_or_null(\"Background\")\n\tif bg and bg is TextureRect and bg.texture == null:\n\t\tbg.texture = load(\"res://assets/ui/loading_screen.png\")\n\t\tbg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED\n\n")
        break

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.writelines(lines)
print("loading_screen.gd: texture loading added")

# ═══════════════════════════════════════════════
# 4. death_screen.gd - Apply overlay texture
# ═══════════════════════════════════════════════
f = os.path.join(godot, "scripts/ui/death_screen.gd")
with open(f, "r", encoding="utf-8") as fh:
    lines = fh.readlines()

for i, l in enumerate(lines):
    if "visible = false" in l and i < 20:
        lines.insert(i + 1, "\t_apply_texture()\n")
        break

for i, l in enumerate(lines):
    if "func trigger_death" in l:
        lines.insert(i, "func _apply_texture():\n\tvar overlay = get_node_or_null(\"Overlay\")\n\tif overlay and overlay is TextureRect and overlay.texture == null:\n\t\toverlay.texture = load(\"res://assets/ui/death_screen_overlay.png\")\n\t\toverlay.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED\n\n")
        break

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.writelines(lines)
print("death_screen.gd: texture loading added")

print("\nAll UI texture loading applied programmatically.")
print("These survive Godot .tscn regeneration because they load in code.")
