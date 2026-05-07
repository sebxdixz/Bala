extends StaticBody3D

class_name BuildingShop


@export var body_color: Color = Color(0.29, 0.102, 0.239, 1.0)
@export var window_color: Color = Color(1.0, 0.85, 0.3, 1.0)
@export var sign_color: Color = Color(1.0, 0.0, 0.667, 1.0)
@export var awning_stripe1: Color = Color(0.8, 0.1, 0.1, 1.0)
@export var awning_stripe2: Color = Color(0.95, 0.95, 0.95, 1.0)
@export var has_balcony: bool = false


func _ready() -> void:
	_apply_materials()


func _apply_materials() -> void:
	var body_mat := StandardMaterial3D.new()
	body_mat.albedo_color = body_color
	body_mat.roughness = 0.8

	var body_node := get_node_or_null("Body") as MeshInstance3D
	if body_node:
		body_node.material_override = body_mat

	var win_mat := StandardMaterial3D.new()
	win_mat.albedo_color = window_color
	win_mat.emission_enabled = true
	win_mat.emission = window_color
	win_mat.emission_energy_multiplier = 2.5

	var front_win := get_node_or_null("ShopWindow") as MeshInstance3D
	if front_win:
		front_win.material_override = win_mat

	var sign_mat := StandardMaterial3D.new()
	sign_mat.albedo_color = sign_color
	sign_mat.emission_enabled = true
	sign_mat.emission = sign_color
	sign_mat.emission_energy_multiplier = 3.0

	var sign_node := get_node_or_null("Sign") as MeshInstance3D
	if sign_node:
		sign_node.material_override = sign_mat

	var balcony := get_node_or_null("Balcony") as Node3D
	if balcony:
		balcony.visible = has_balcony
