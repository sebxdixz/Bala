extends StaticBody3D

class_name BuildingTall


@export var body_color: Color = Color(0.227, 0.235, 0.231, 1.0)
@export var window_color: Color = Color(1.0, 0.8, 0.2, 1.0)
@export var has_neon: bool = false
@export var neon_color: Color = Color(1.0, 0.0, 0.667, 1.0)


func _ready() -> void:
	_apply_materials()


func _apply_materials() -> void:
	var body_mat := StandardMaterial3D.new()
	body_mat.albedo_color = body_color
	body_mat.roughness = 0.85

	var body_node := get_node_or_null("Body") as MeshInstance3D
	if body_node:
		body_node.material_override = body_mat

	var roof_node := get_node_or_null("Roof") as MeshInstance3D
	if roof_node:
		var roof_mat := StandardMaterial3D.new()
		roof_mat.albedo_color = body_color.darkened(0.2)
		roof_mat.roughness = 0.9
		roof_node.material_override = roof_mat

	var win_mat := StandardMaterial3D.new()
	win_mat.albedo_color = window_color
	win_mat.emission_enabled = true
	win_mat.emission = window_color
	win_mat.emission_energy_multiplier = 2.0

	for child in get_children():
		if child is MeshInstance3D and child.name.begins_with("Window"):
			child.material_override = win_mat

	var neon_node := get_node_or_null("NeonSign") as MeshInstance3D
	if neon_node:
		if has_neon:
			var neon_mat := StandardMaterial3D.new()
			neon_mat.albedo_color = neon_color
			neon_mat.emission_enabled = true
			neon_mat.emission = neon_color
			neon_mat.emission_energy_multiplier = 3.0
			neon_node.material_override = neon_mat
			neon_node.visible = true
		else:
			neon_node.visible = false
