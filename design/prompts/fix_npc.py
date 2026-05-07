f = r"C:\Users\sdiaz\OneDrive - Axo\Escritorio\Proyectos\BALA\godot\scripts\npc\npc_base.gd"
with open(f, "r", encoding="utf-8") as fh:
    content = fh.read()

# Fix _flash_red - was referencing nonexistent character_body
old = "func _flash_red():\n\n\n\n\tif character_body and character_body.has_method(\"set_damage_flash\"):\n\n\t\tcharacter_body.set_damage_flash()\n\n\t_flash_timer = FLASH_DURATION"
new = "func _flash_red():\n\tvar white_mat = StandardMaterial3D.new()\n\twhite_mat.albedo_color = Color.WHITE\n\twhite_mat.emission_enabled = true\n\twhite_mat.emission = Color.WHITE\n\twhite_mat.emission_energy_multiplier = 1.5\n\tif mesh_body:\n\t\tmesh_body.material_override = white_mat\n\tif mesh_head:\n\t\tmesh_head.material_override = white_mat\n\t_flash_timer = FLASH_DURATION"
content = content.replace(old, new)

# Fix _restore_materials
old2 = "func _restore_materials():\n\n\n\n\tif character_body and character_body.has_method(\"reset_colors\"):\n\n\t\tcharacter_body.reset_colors()"
new2 = "func _restore_materials():\n\tif mesh_body:\n\t\tmesh_body.material_override = null\n\tif mesh_head:\n\t\tmesh_head.material_override = null"
content = content.replace(old2, new2)

# Bigger damage numbers
content = content.replace("label.font_size = 28", "label.font_size = 48")

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.write(content)
print("Fixed: flash + restore + float size")
