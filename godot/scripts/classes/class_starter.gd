extends Node



var _retries: int = 0



func _ready():

	await get_tree().process_frame

	_try_start()



func _try_start():

	_retries += 1

	var players = get_tree().get_nodes_in_group("players")

	if players.size() > 0:

		var player = players[0]

		if player.has_method("_setup_class"):

			player._setup_class()

			print("[ClassStarter] Clase iniciada en el jugador")

		return

	if _retries < 15:

		await get_tree().process_frame

		_try_start()

	else:

		print("[ClassStarter] No se encontro jugador tras 15 intentos")
