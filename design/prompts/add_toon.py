f = r"C:\Users\sdiaz\OneDrive - Axo\Escritorio\Proyectos\BALA\godot\scripts\world\world_initializer.gd"
with open(f, "r", encoding="utf-8") as fh:
    lines = fh.readlines()

# Add _apply_toon_shader call in _ready after particles
for i, l in enumerate(lines):
    if "Smoke particles spawneados" in l:
        lines.insert(i + 1, "\t_apply_toon_shader()\n")
        break

# Add _apply_toon_shader method at end
toon_method = [
    "\n",
    "func _apply_toon_shader():\n",
    "\tvar shader = load(\"res://shaders/low_poly_outline.gdshader\")\n",
    "\tif not shader:\n",
    "\t\tprint(\"WorldInit: Toon shader not found\")\n",
    "\t\treturn\n",
    "\tvar count = 0\n",
    "\tvar root = get_tree().current_scene\n",
    "\tif not root:\n",
    "\t\treturn\n",
    "\tfor mesh in root.find_children(\"*\", \"MeshInstance3D\", true, false):\n",
    "\t\tvar parent_name = mesh.get_parent().name if mesh.get_parent() else \"\"\n",
    "\t\tif parent_name in [\"SmokeParticles\", \"Projectile\"]:\n",
    "\t\t\tcontinue\n",
    "\t\tvar mat = ShaderMaterial.new()\n",
    "\t\tmat.shader = shader\n",
    "\t\tmat.set_shader_parameter(\"grosor_outline\", 3.0)\n",
    "\t\tmat.set_shader_parameter(\"toon_steps\", 2)\n",
    "\t\tmat.set_shader_parameter(\"color_outline\", Color.BLACK)\n",
    "\t\tmesh.material_override = mat\n",
    "\t\tcount += 1\n",
    "\tprint(\"WorldInit: Toon shader applied to \" + str(count) + \" meshes\")\n",
]
for k, nl in enumerate(toon_method):
    lines.append(nl)

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.writelines(lines)
print("Toon shader auto-apply added to WorldInitializer")
