# main_menu.gd - BALA Main Menu
extends Control

func _ready():
	_apply_textures()
	_connect_buttons()

func _apply_textures():
	var bg = get_node_or_null("Background")
	if bg and bg is TextureRect and bg.texture == null:
		bg.texture = load("res://assets/ui/main_menu_bg.png")
		bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED

	var title = get_node_or_null("TitleLogo")
	if title and title is TextureRect and title.texture == null:
		title.texture = load("res://assets/ui/main_menu_title.png")
		title.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

func _connect_buttons():
	var new_game = get_node_or_null("MenuButtons/NewGameBtn")
	if new_game:
		new_game.pressed.connect(_on_new_game_pressed)
	
	var quit_btn = get_node_or_null("MenuButtons/QuitBtn")
	if quit_btn:
		quit_btn.pressed.connect(_on_quit_pressed)

func _on_new_game_pressed():
	get_tree().change_scene_to_file("res://scenes/world/test_world.tscn")

func _on_quit_pressed():
	get_tree().quit()
