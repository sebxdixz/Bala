# ============================================================
# dialogue_box.gd — NPC Dialogue Box System
# Barrio Sin Ley Online (BSLO)
# Shows faction-styled dialogue boxes for NPC interactions
# ============================================================
extends CanvasLayer

enum DialogueStyle { CALLEJERO, YAKUZA, SYSTEM }

@onready var box_container: Control = $BoxContainer
@onready var box_bg: TextureRect = $BoxContainer/BoxBg
@onready var npc_name: Label = $BoxContainer/NpcName
@onready var dialogue_text: Label = $BoxContainer/DialogueText
@onready var continue_hint: Label = $BoxContainer/ContinueHint

var yakuza_tex: Texture2D = preload("res://assets/ui/dialogue_box_yakuza.png")
var callejero_tex: Texture2D = preload("res://assets/ui/dialogue_box_callejero.png")
var system_tex: Texture2D = preload("res://assets/ui/dialogue_box_system.png")

var current_style: DialogueStyle = DialogueStyle.CALLEJERO
var npc_color: Color = Color(1.0, 0.0, 0.667, 1)
var text_color: Color = Color(0.95, 0.95, 0.95, 1)

func _ready():
	visible = false

func show_dialogue(name_text: String, text: String, style: DialogueStyle = DialogueStyle.CALLEJERO):
	current_style = style
	match style:
		DialogueStyle.YAKUZA:
			box_bg.texture = yakuza_tex
			npc_color = Color(0.878, 0.878, 0.878, 1)
		DialogueStyle.CALLEJERO:
			box_bg.texture = callejero_tex
			npc_color = Color(1.0, 0.0, 0.667, 1)
		DialogueStyle.SYSTEM:
			box_bg.texture = system_tex
			npc_color = Color(0.0, 1.0, 0.2, 1)

	npc_name.text = name_text
	npc_name.add_theme_color_override("font_color", npc_color)
	dialogue_text.text = text
	visible = true

func hide_dialogue():
	visible = false
