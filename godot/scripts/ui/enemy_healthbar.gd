# enemy_healthbar.gd - Floating health bar (GTA5 style)



extends Node3D







@onready var bar_bg: MeshInstance3D = $BarBackground



@onready var bar_fg: MeshInstance3D = $BarForeground



@onready var name_label: Label3D = $NameLabel







var max_hp: float = 100.0



var current_hp: float = 100.0



var bar_width: float = 1.5







func _ready():



	_create_bar_materials()







func _create_bar_materials():



	# Background: dark gray



	var bg_mat = StandardMaterial3D.new()



	bg_mat.albedo_color = Color(0.1, 0.1, 0.1, 1)



	bg_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED

	bg_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA



	bar_bg.material_override = bg_mat







	# Foreground: red (changes with HP)



	var fg_mat = StandardMaterial3D.new()



	fg_mat.albedo_color = Color(0.9, 0.15, 0.15, 1)



	fg_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED

	fg_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA



	bar_fg.material_override = fg_mat







func setup(enemy_name: String, hp: float, max_hp_val: float):



	name_label.text = enemy_name



	max_hp = max_hp_val



	current_hp = hp



	_update_bar()







func update_hp(hp: float):



	current_hp = hp



	_update_bar()







func _update_bar():



	var ratio = clampf(current_hp / max(max_hp, 1.0), 0.0, 1.0)



	



	# Scale foreground bar



	bar_fg.scale.x = ratio



	# Offset to left-align



	bar_fg.position.x = -(bar_width * (1.0 - ratio)) / 2.0



	



	# Color: green > yellow > red



	if ratio > 0.6:



		set_fg_color(Color(0.2, 0.85, 0.2, 1))



	elif ratio > 0.3:



		set_fg_color(Color(0.9, 0.8, 0.1, 1))



	else:



		set_fg_color(Color(0.9, 0.15, 0.15, 1))



	



	# Hide bar if dead



	visible = current_hp > 0







func set_fg_color(color: Color):



	if bar_fg.material_override:



		bar_fg.material_override.albedo_color = color
