# ============================================================
# quest_manager.gd — QuestManager (Autoload)
# Barrio Sin Ley Online (BSLO)
# Tracks active quests, progress, and rewards.
# Registered as autoload "QuestManager".
# ============================================================
extends Node

const QuestDataRef = preload("res://scripts/quests/quest_data.gd")

signal quest_accepted(quest_id: String)
signal quest_progress(quest_id: String, current: int, max_count: int)
signal quest_completed(quest_id: String)
signal quest_reward_given(quest_id: String, xp: int, pb: int, item_id: String)
signal quest_abandoned(quest_id: String)

# QuestProgress inner class for tracking per-quest state
class QuestProgress:
	var quest_data: Resource
	var current_count: int = 0
	var talk_step: int = 0  # for "talk" quests, which NPC in sequence we've talked to
	
	func _init(data: Resource):
		quest_data = data
		current_count = 0
		talk_step = 0
	
	func is_complete() -> bool:
		return current_count >= quest_data.target_count
	
	func get_progress_text() -> String:
		if quest_data.quest_type == "talk":
			return "%d/%d hablados" % [current_count, quest_data.target_count]
		else:
			return "%d/%d %s" % [current_count, quest_data.target_count, quest_data.target_id]

# Active quests: quest_id -> QuestProgress
var active_quests: Dictionary = {}

# Completed quests: quest_id -> bool (or count for repeatable)
var completed_quests: Dictionary = {}

# All quest definitions: quest_id -> Resource
var _quest_database: Dictionary = {}

func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	_build_quest_database()
	print("QuestManager: %d misiones cargadas" % _quest_database.size())

# ============================================================
# QUEST DATABASE CONSTRUCTION (8 quests)
# ============================================================

func _create_quest(id: String, name: String, desc: String, type: String,
					target: String, count: int, xp: int, pb: int,
					item: String, giver: String, dialogue: String,
					repeatable: bool, level: int, npcs: Array = []) -> Resource:
	var q = QuestDataRef.new()
	q.quest_id = id
	q.quest_name = name
	q.description = desc
	q.quest_type = type
	q.target_id = target
	q.target_count = count
	q.reward_xp = xp
	q.reward_pb = pb
	q.reward_item_id = item
	q.giver_npc = giver
	q.completion_dialogue = dialogue
	q.is_repeatable = repeatable
	q.required_level = level
	if npcs.size() > 0:
		q.target_npcs = PackedStringArray(npcs)
	return q

func _build_quest_database():
	_quest_database["limpia_barrio"] = _create_quest(
		"limpia_barrio", "Limpieza del Barrio",
		"Elimina a 3 Matones Callejeros para limpiar las calles del barrio.",
		"kill", "Maton Callejero", 3, 60, 50, "", "El Viejo del Barrio",
		"Bien hecho, chaval. El barrio esta un poco mas limpio gracias a ti.",
		false, 1
	)
	
	_quest_database["problema_narco"] = _create_quest(
		"problema_narco", "Problema Narco",
		"Acaba con 2 Sicarios Narco. Son un peligro para todos.",
		"kill", "Sicario Narco", 2, 100, 80, "", "El Viejo del Barrio",
		"Esos narcos no volveran a molestar. Buen trabajo.",
		false, 2
	)
	
	_quest_database["proteccion_yakuza"] = _create_quest(
		"proteccion_yakuza", "Proteccion Yakuza",
		"Elimina a 1 Guardia Yakuza que ronda el territorio.",
		"kill", "Guardia Yakuza", 1, 150, 120, "", "El Viejo del Barrio",
		"Ese yakuza no volvera a pisar nuestras calles.",
		false, 3
	)
	
	_quest_database["caza_mayor"] = _create_quest(
		"caza_mayor", "Caza Mayor",
		"Derrota a 1 Maton Pesado. Son tipos duros, ve preparado.",
		"kill", "Maton Pesado", 1, 200, 200, "pistol_9mm", "El Viejo del Barrio",
		"Increible. Toma esta pistola 9mm como recompensa extra.",
		false, 4
	)
	
	_quest_database["recoleccion"] = _create_quest(
		"recoleccion", "Recoleccion",
		"Consigue 3 tacos callejeros. La abuelita los necesita para la cena.",
		"collect", "taco_callejero", 3, 30, 30, "", "El Ferretero",
		"Gracias, muchacho. La abuelita te lo agradecera.",
		false, 1
	)
	
	_quest_database["el_recado"] = _create_quest(
		"el_recado", "El Recado",
		"Habla con El Ferretero primero, luego ve con El Viejo del Barrio.",
		"talk", "El Ferretero,El Viejo del Barrio", 2, 40, 50, "", "El Ferretero",
		"Bien, el mensaje ha sido entregado. Eres de fiar.",
		false, 1,
		["El Ferretero", "El Viejo del Barrio"]
	)
	
	_quest_database["patrulla_nocturna"] = _create_quest(
		"patrulla_nocturna", "Patrulla Nocturna",
		"Elimina a 5 enemigos de cualquier tipo durante la noche.",
		"kill", "", 5, 250, 300, "", "El Viejo del Barrio",
		"Patrulla completada. El barrio duerme mas tranquilo.",
		false, 5
	)
	
	_quest_database["gran_golpe"] = _create_quest(
		"gran_golpe", "El Gran Golpe",
		"Elimina a 10 enemigos en total. Demuestra quien manda en el barrio.",
		"kill", "", 10, 500, 500, "ak47_dorada", "El Viejo del Barrio",
		"Eres una leyenda, chaval. Toma la AK-47 Dorada. Te la has ganado.",
		false, 8
	)

# ============================================================
# PUBLIC METHODS
# ============================================================

func get_quest_data(quest_id: String) -> Resource:
	if _quest_database.has(quest_id):
		return _quest_database[quest_id]
	return null

func get_available_quests() -> Array:
	"""Returns quests the player can accept (not active, not completed if non-repeatable)."""
	var available: Array = []
	for quest_id in _quest_database:
		if is_quest_active(quest_id):
			continue
		if is_quest_complete(quest_id) and not _quest_database[quest_id].is_repeatable:
			continue
		var qdata = _quest_database[quest_id]
		if StatsManager and StatsManager.level < qdata.required_level:
			continue
		available.append(qdata)
	return available

func accept_quest(quest_id: String) -> bool:
	"""Starts tracking a quest. Returns false if quest not found or already active."""
	if not _quest_database.has(quest_id):
		push_error("QuestManager: Quest '%s' not found" % quest_id)
		return false
	if is_quest_active(quest_id):
		print("QuestManager: Quest '%s' already active" % quest_id)
		return false
	if is_quest_complete(quest_id) and not _quest_database[quest_id].is_repeatable:
		print("QuestManager: Quest '%s' already completed (non-repeatable)" % quest_id)
		return false
	
	var qdata = _quest_database[quest_id]
	var progress = QuestProgress.new(qdata)
	active_quests[quest_id] = progress
	print("QuestManager: Quest accepted: %s [%s]" % [qdata.quest_name, quest_id])
	quest_accepted.emit(quest_id)
	return true

func update_progress_kill(enemy_name: String):
	"""Called when player kills an enemy. Updates relevant kill quests."""
	for quest_id in active_quests:
		var progress: QuestProgress = active_quests[quest_id]
		if progress.quest_data.quest_type != "kill":
			continue
		var target = progress.quest_data.target_id
		# If target_id is empty, count any kill ("Patrulla Nocturna", "El Gran Golpe")
		if target == "" or enemy_name == target:
			progress.current_count += 1
			quest_progress.emit(quest_id, progress.current_count, progress.quest_data.target_count)
			print("QuestManager: [%s] progreso: %d/%d" % [quest_id, progress.current_count, progress.quest_data.target_count])
			if progress.is_complete():
				quest_completed.emit(quest_id)

func update_progress_collect(item_id: String, quantity: int = 1):
	"""Called when player picks up an item. Updates relevant collect quests."""
	for quest_id in active_quests:
		var progress: QuestProgress = active_quests[quest_id]
		if progress.quest_data.quest_type != "collect":
			continue
		if progress.quest_data.target_id == item_id:
			progress.current_count += quantity
			quest_progress.emit(quest_id, progress.current_count, progress.quest_data.target_count)
			print("QuestManager: [%s] recoleccion: %d/%d" % [quest_id, progress.current_count, progress.quest_data.target_count])
			if progress.is_complete():
				quest_completed.emit(quest_id)

func update_progress_talk(npc_name: String):
	"""Called when player talks to an NPC. Updates relevant talk quests."""
	for quest_id in active_quests:
		var progress: QuestProgress = active_quests[quest_id]
		if progress.quest_data.quest_type != "talk":
			continue
		# For talk quests, check if this NPC is the next in the sequence
		var npcs = progress.quest_data.target_npcs
		if npcs.size() == 0:
			# Fallback: parse target_id as comma-separated
			var npc_list = progress.quest_data.target_id.split(",")
			for n in npc_list:
				npcs.append(n.strip_edges())
		
		var current_step = progress.talk_step
		if current_step < npcs.size() and npcs[current_step] == npc_name:
			progress.talk_step += 1
			progress.current_count += 1
			quest_progress.emit(quest_id, progress.current_count, progress.quest_data.target_count)
			print("QuestManager: [%s] hablado con %s (%d/%d)" % [quest_id, npc_name, progress.current_count, progress.quest_data.target_count])
			if progress.is_complete():
				quest_completed.emit(quest_id)

func update_progress(quest_id: String, amount: int = 1):
	"""Manual progress update for a specific quest (generic)."""
	if not active_quests.has(quest_id):
		return
	var progress: QuestProgress = active_quests[quest_id]
	progress.current_count += amount
	quest_progress.emit(quest_id, progress.current_count, progress.quest_data.target_count)
	if progress.is_complete():
		quest_completed.emit(quest_id)

func complete_quest(quest_id: String) -> bool:
	"""Gives rewards and marks quest complete. Returns false if quest not active/completed."""
	if not active_quests.has(quest_id):
		return false
	var progress: QuestProgress = active_quests[quest_id]
	if not progress.is_complete():
		return false
	
	var qdata = progress.quest_data
	
	# Give XP reward
	if StatsManager:
		StatsManager.add_xp(qdata.reward_xp)
	
	# Give PB reward (money)
	# TODO: Connect to player money system when available
	if InventoryManager and qdata.reward_pb > 0:
		print("QuestManager: +%d PB (money system pending)" % qdata.reward_pb)
	
	# Give item reward
	if qdata.reward_item_id != "" and InventoryManager:
		InventoryManager.add_item_by_id(qdata.reward_item_id, 1)
		print("QuestManager: recompensa item: %s" % qdata.reward_item_id)
	
	# Mark as completed
	if qdata.is_repeatable:
		if not completed_quests.has(quest_id):
			completed_quests[quest_id] = 0
		completed_quests[quest_id] += 1
	else:
		completed_quests[quest_id] = true
	
	# Remove from active
	active_quests.erase(quest_id)
	
	quest_reward_given.emit(quest_id, qdata.reward_xp, qdata.reward_pb, qdata.reward_item_id)
	print("QuestManager: Quest completed: %s | +%d XP +%d PB %s" % [qdata.quest_name, qdata.reward_xp, qdata.reward_pb, qdata.reward_item_id])
	return true

func abandon_quest(quest_id: String) -> bool:
	"""Removes quest from active without rewards."""
	if not active_quests.has(quest_id):
		return false
	var qdata = active_quests[quest_id].quest_data
	active_quests.erase(quest_id)
	quest_abandoned.emit(quest_id)
	print("QuestManager: Quest abandoned: %s" % qdata.quest_name)
	return true

func is_quest_active(quest_id: String) -> bool:
	return active_quests.has(quest_id)

func is_quest_complete(quest_id: String) -> bool:
	return completed_quests.has(quest_id)

func get_active_quest_data() -> Array:
	"""Returns array of QuestData for all active quests."""
	var result: Array = []
	for quest_id in active_quests:
		result.append(active_quests[quest_id])
	return result

func get_completed_quest_names() -> Array:
	"""Returns array of completed quest names for history."""
	var result: Array = []
	for quest_id in completed_quests:
		if _quest_database.has(quest_id):
			result.append(_quest_database[quest_id].quest_name)
	return result

func get_quest_by_giver(npc_name: String) -> Resource:
	"""Returns the quest offered by a specific NPC, or null."""
	for quest_id in _quest_database:
		if _quest_database[quest_id].giver_npc == npc_name:
			return _quest_database[quest_id]
	return null
