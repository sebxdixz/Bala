# ============================================================
# loading_screen.gd — Loading Screen with Progess Bar & Tips
# Barrio Sin Ley Online (BSLO)
# Shows while scenes load, with humorous tips
# ============================================================
extends CanvasLayer

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var tip_label: Label = $TipLabel

var tips: Array[String] = [
	"Consejo: No revises la mochila en medio de un tiroteo.",
	"Consejo: Los tacos curan. Las balas no.",
	"Consejo: Si ves a Don Vincenzo, acepta la pasta.",
	"Consejo: La Abuela del Barrio es intocable. En serio.",
	"Consejo: El metro es gratis. El vagabundo del vagon 3... no tanto.",
	"Consejo: Si escuchas un saxofon en la lluvia, corre.",
	"Consejo: Firulais es inmortal. No intentes matarlo.",
	"Consejo: Los policias aceptan sobornos. Los SWAT no.",
	"Consejo: Guarda siempre un taco en el inventario rapido.",
	"Consejo: El Bar de la Esquina no aparece en el mapa. Buscalo.",
	"Consejo: Si el semaforo esta en verde, igual mira a ambos lados.",
	"Consejo: El graffiti es arte. El graffiti en la comisaria es declaracion de guerra.",
]

func _ready():
	visible = false

func _apply_texture():
	var bg = get_node_or_null("Background")
	if bg and bg is TextureRect and bg.texture == null:
		bg.texture = load("res://assets/ui/loading_screen.png")
		bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

func show_loading():
	visible = true
	tip_label.text = tips[randi() % tips.size()]
	progress_bar.value = 0.0

func set_progress(value: float):
	progress_bar.value = clamp(value * 100.0, 0.0, 100.0)

func hide_loading():
	visible = false
