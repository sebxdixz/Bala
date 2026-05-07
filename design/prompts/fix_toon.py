f = r"C:\Users\sdiaz\OneDrive - Axo\Escritorio\Proyectos\BALA\godot\scripts\world\world_initializer.gd"
with open(f, "r", encoding="utf-8") as fh:
    content = fh.read()

old = 'for mesh in root.find_children("*", "MeshInstance3D", true, false):'
new = 'for mesh in root.find_children("*", "MeshInstance3D", true, false):\n\t\tif not mesh is MeshInstance3D:\n\t\t\tcontinue\n\t\tvar pname = mesh.get_parent().name if mesh.get_parent() else ""\n\t\tif pname in ["SmokeParticles", "Projectile", "BarBackground", "BarForeground"]:\n\t\t\tcontinue'
content = content.replace(old, new)

# Also remove the old parent_name check if duplicated
old2 = '\t\tvar parent_name = mesh.get_parent().name if mesh.get_parent() else ""\n\t\tif parent_name in ["SmokeParticles", "Projectile"]:\n\t\t\tcontinue'
content = content.replace(old2, '')

with open(f, "w", encoding="utf-8", newline="\n") as fh:
    fh.write(content)
print("Fixed toon shader with type guards")
