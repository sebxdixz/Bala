# ============================================================

# weapon_base.gd -- Weapon model base script

# Barrio Sin Ley Online (BSLO)

# Builds low-poly weapon meshes from primitives.

# Supports: pistol, bat, knife, ak47

# ============================================================

extends Node3D



@export var weapon_type: String = "pistol"

var _mesh_nodes: Array = []



func _ready():

	set_weapon(weapon_type)



func set_weapon(type: String):

	weapon_type = type

	_clear_meshes()

	match type.to_lower():

		"pistol":

			_build_pistol()

		"bat":

			_build_bat()

		"knife":

			_build_knife()

		"ak47":

			_build_ak47()

		_:

			push_warning("WeaponBase: Unknown weapon type: " + type)



func _clear_meshes():

	for node in _mesh_nodes:

		if is_instance_valid(node):

			node.queue_free()

	_mesh_nodes.clear()

	for child in get_children():

		if child is MeshInstance3D:

			child.queue_free()



func _make_material(base_color: Color) -> StandardMaterial3D:

	var mat = StandardMaterial3D.new()

	mat.albedo_color = base_color

	mat.roughness = 0.3

	mat.metallic = 0.1

	return mat



func _add_box(size: Vector3, color: Color, offset: Vector3 = Vector3.ZERO) -> MeshInstance3D:

	var mi = MeshInstance3D.new()

	var box = BoxMesh.new()

	box.size = size

	mi.mesh = box

	mi.material_override = _make_material(color)

	mi.position = offset

	add_child(mi)

	_mesh_nodes.append(mi)

	return mi



func _add_cylinder(top_r: float, bottom_r: float, height: float, color: Color, offset: Vector3 = Vector3.ZERO, rot_deg: Vector3 = Vector3.ZERO) -> MeshInstance3D:

	var mi = MeshInstance3D.new()

	var cyl = CylinderMesh.new()

	cyl.top_radius = top_r

	cyl.bottom_radius = bottom_r

	cyl.height = height

	mi.mesh = cyl

	mi.material_override = _make_material(color)

	mi.position = offset

	mi.rotation_degrees = rot_deg

	add_child(mi)

	_mesh_nodes.append(mi)

	return mi



func _build_pistol():

	_add_box(Vector3(0.15, 0.10, 0.40), Color(0.25, 0.25, 0.30, 1.0), Vector3(0.0, 0.0, -0.10))

	_add_cylinder(0.03, 0.03, 0.30, Color(0.35, 0.35, 0.38, 1.0), Vector3(0.0, 0.04, 0.28), Vector3(90.0, 0.0, 0.0))

	_add_box(Vector3(0.12, 0.15, 0.12), Color(0.20, 0.18, 0.15, 1.0), Vector3(0.0, -0.12, -0.05))

	_add_box(Vector3(0.04, 0.03, 0.08), Color(0.45, 0.45, 0.50, 1.0), Vector3(0.0, -0.04, 0.08))



func _build_bat():

	_add_cylinder(0.04, 0.07, 1.50, Color(0.45, 0.35, 0.22, 1.0), Vector3(0.0, 0.15, 0.0), Vector3(90.0, 0.0, 0.0))

	_add_cylinder(0.045, 0.045, 0.35, Color(0.15, 0.12, 0.08, 1.0), Vector3(0.0, -0.47, -0.01), Vector3(90.0, 0.0, 0.0))



func _build_knife():

	_add_box(Vector3(0.02, 0.05, 0.20), Color(0.75, 0.75, 0.80, 1.0), Vector3(0.0, 0.01, 0.08))

	_add_box(Vector3(0.03, 0.03, 0.12), Color(0.30, 0.22, 0.15, 1.0), Vector3(0.0, 0.0, -0.06))

	_add_box(Vector3(0.06, 0.02, 0.02), Color(0.45, 0.45, 0.50, 1.0), Vector3(0.0, 0.0, 0.02))



func _build_ak47():

	_add_box(Vector3(0.10, 0.12, 0.60), Color(0.22, 0.22, 0.25, 1.0), Vector3(0.0, 0.0, -0.05))

	_add_cylinder(0.03, 0.03, 0.50, Color(0.30, 0.30, 0.33, 1.0), Vector3(0.0, 0.03, 0.40), Vector3(90.0, 0.0, 0.0))

	_add_box(Vector3(0.04, 0.15, 0.08), Color(0.18, 0.18, 0.20, 1.0), Vector3(0.0, -0.12, 0.05))

	_add_box(Vector3(0.05, 0.10, 0.30), Color(0.35, 0.28, 0.20, 1.0), Vector3(0.0, 0.01, -0.30))

	_add_box(Vector3(0.02, 0.04, 0.015), Color(0.15, 0.15, 0.17, 1.0), Vector3(0.0, 0.07, 0.22))