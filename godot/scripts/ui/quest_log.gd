# ============================================================
# quest_log.gd — Quest Log UI
# Barrio Sin Ley Online (BSLO)
# CanvasLayer that shows active quests with progress bars
# and a completed quests history tab.
# Toggle with L key.
# ============================================================
extends CanvasLayer

@onready var quest_list: VBoxContainer = $Panel/MarginContainer/VBoxContainer/TabContainer/ActiveQuests/ScrollContainer/QuestList
@onready var completed_list: VBoxContainer = $Panel/MarginContainer/VBoxContainer/TabContainer/CompletedQuests/ScrollContainer/CompletedList
@onready var tab_container: TabContainer = $Panel/MarginContainer/VBoxContainer/TabContainer

var _quest_card_scene: PackedScene = null

func _ready():
	visible = false
	process_mode = PROCESS_MODE_ALWAYS
	
	# Connect to QuestManager signals
	if QuestManager:
		QuestManager.quest_accepted.connect(_on_quest_accepted)
		QuestManager.quest_progress.connect(_on_quest_progress)
		QuestManager.quest_completed.connect(_on_quest_completed)
		QuestManager.quest_reward_given.connect(_on_quest_reward_given)
		QuestManager.quest_abandoned.connect(_on_quest_abandoned)

func _process(_delta):
	if Input.is_action_just_pressed("toggle_quest_log"):
		visible = not visible
		if visible:
			_refresh_all()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _refresh_all():
	_refresh_active_quests()
	_refresh_completed_quests()

func _refresh_active_quests():
	# Clear existing
	for child in quest_list.get_children():
		child.queue_free()
	
	if not QuestManager:
		return
	
	var active = QuestManager.get_active_quest_data()
	if active.size() == 0:
		var no_quests = Label.new()
		no_quests.text = "No tienes misiones activas. Habla con los NPCs del barrio."
		no_quests.autowrap_mode = TextServer.AUTOWRAP_WORD
		no_quests.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
		no_quests.add_theme_font_size_override("font_size", 14)
		quest_list.add_child(no_quests)
		return
	
	for entry in active:
		var progress = entry as QuestManager.QuestProgress
		var qdata = progress.quest_data
		_add_quest_card(quest_list, qdata, progress)

func _refresh_completed_quests():
	for child in completed_list.get_children():
		child.queue_free()
	
	if not QuestManager:
		return
	
	var names = QuestManager.get_completed_quest_names()
	if names.size() == 0:
		var no_quests = Label.new()
		no_quests.text = "No has completado ninguna mision aun."
		no_quests.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
		no_quests.add_theme_font_size_override("font_size", 14)
		completed_list.add_child(no_quests)
		return
	
	for name in names:
		var label = Label.new()
		label.text = "- " + name
		label.add_theme_color_override("font_color", Color(0.3, 1.0, 0.3))
		label.add_theme_font_size_override("font_size", 14)
		completed_list.add_child(label)

func _add_quest_card(parent: Control, qdata: Resource, progress: QuestManager.QuestProgress):
	var card = MarginContainer.new()
	card.add_theme_constant_override("margin_left", 8)
	card.add_theme_constant_override("margin_top", 4)
	card.add_theme_constant_override("margin_right", 8)
	card.add_theme_constant_override("margin_bottom", 4)
	
	var vbox = VBoxContainer.new()
	card.add_child(vbox)
	
	# Quest name (bold)
	var name_label = Label.new()
	name_label.text = qdata.quest_name
	name_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.0))
	name_label.add_theme_font_size_override("font_size", 16)
	vbox.add_child(name_label)
	
	# Description
	var desc_label = Label.new()
	desc_label.text = qdata.description
	desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	desc_label.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
	desc_label.add_theme_font_size_override("font_size", 12)
	vbox.add_child(desc_label)
	
	# Progress bar container
	var bar_hbox = HBoxContainer.new()
	vbox.add_child(bar_hbox)
	
	var progress_bar = ProgressBar.new()
	progress_bar.custom_minimum_size = Vector2(200, 18)
	progress_bar.max_value = float(qdata.target_count)
	progress_bar.value = float(progress.current_count)
	progress_bar.show_percentage = false
	bar_hbox.add_child(progress_bar)
	
	# Progress text
	var progress_label = Label.new()
	progress_label.text = progress.get_progress_text()
	progress_label.add_theme_color_override("font_color", Color(0.9, 0.9, 0.9))
	progress_label.add_theme_font_size_override("font_size", 13)
	bar_hbox.add_child(progress_label)
	
	# Store references for updates
	card.set_meta("quest_id", qdata.quest_id)
	card.set_meta("progress_bar", progress_bar)
	card.set_meta("progress_label", progress_label)
	
	# Rewards info
	var reward_text = "Recompensas: %d XP" % qdata.reward_xp
	if qdata.reward_pb > 0:
		reward_text += " | %d PB" % qdata.reward_pb
	if qdata.reward_item_id != "":
		reward_text += " | %s" % qdata.reward_item_id
	var reward_label = Label.new()
	reward_label.text = reward_text
	reward_label.add_theme_color_override("font_color", Color(0.5, 0.9, 0.5))
	reward_label.add_theme_font_size_override("font_size", 11)
	vbox.add_child(reward_label)
	
	# Abandon button (only for non-complete)
	if not progress.is_complete():
		var abandon_btn = Button.new()
		abandon_btn.text = "ABANDONAR"
		abandon_btn.add_theme_color_override("font_color", Color(1.0, 0.3, 0.3))
		abandon_btn.custom_minimum_size = Vector2(120, 24)
		abandon_btn.pressed.connect(_on_abandon_pressed.bind(qdata.quest_id))
		vbox.add_child(abandon_btn)
	
	# Separator
	var separator = HSeparator.new()
	vbox.add_child(separator)
	
	parent.add_child(card)

func _update_card(quest_id: String):
	for child in quest_list.get_children():
		if child.has_meta("quest_id") and child.get_meta("quest_id") == quest_id:
			if QuestManager and QuestManager.active_quests.has(quest_id):
				var progress: QuestManager.QuestProgress = QuestManager.active_quests[quest_id]
				var bar: ProgressBar = child.get_meta("progress_bar")
				var label: Label = child.get_meta("progress_label")
				if bar:
					bar.value = float(progress.current_count)
				if label:
					label.text = progress.get_progress_text()
			break

func _on_abandon_pressed(quest_id: String):
	if QuestManager:
		QuestManager.abandon_quest(quest_id)
	_refresh_all()

# Signal callbacks
func _on_quest_accepted(quest_id: String):
	_refresh_all()
	_show_notification("Mision aceptada: %s" % QuestManager.get_quest_data(quest_id).quest_name, Color(0.3, 1.0, 0.3))

func _on_quest_progress(quest_id: String, _current: int, _max_count: int):
	_update_card(quest_id)

func _on_quest_completed(quest_id: String):
	var qdata = QuestManager.get_quest_data(quest_id) if QuestManager else null
	if qdata:
		_show_notification("Mision completada: %s" % qdata.quest_name, Color(1.0, 0.85, 0.0))

func _on_quest_reward_given(quest_id: String, xp: int, pb: int, item_id: String):
	var qdata = QuestManager.get_quest_data(quest_id) if QuestManager else null
	if qdata:
		_show_notification("Recompensa: +%d XP +%d PB %s" % [xp, pb, item_id], Color(0.3, 1.0, 0.3))
	_refresh_all()

func _on_quest_abandoned(quest_id: String):
	var qdata = QuestManager.get_quest_data(quest_id) if QuestManager else null
	if qdata:
		_show_notification("Mision abandonada: %s" % qdata.quest_name, Color(1.0, 0.3, 0.3))
	_refresh_all()

func _show_notification(text: String, color: Color):
	var label = Label.new()
	label.text = text
	label.add_theme_color_override("font_color", color)
	label.add_theme_font_size_override("font_size", 18)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.set_anchors_preset(Control.PRESET_CENTER_TOP)
	label.position = Vector2(0, 100)
	add_child(label)
	
	var tween = create_tween()
	tween.tween_property(label, "position:y", 60, 1.5)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 1.5)
	tween.tween_callback(label.queue_free)
