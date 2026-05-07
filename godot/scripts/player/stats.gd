# ============================================================
# stats.gd — StatsManager (Autoload)
# Barrio Sin Ley Online (BSLO)
# Sistema de 6 stats base: STR, DEX, CON, INT, WIS, CHA
# Incluye XP, leveling, loot system, y dinero PB
# ============================================================
extends Node

# Force Godot to compile and register class_name types
const _ClassData = preload("res://scripts/classes/class_data.gd")

# Senales
signal stats_changed(stat_name: String, new_value: int)
signal health_changed(current_hp: int, max_hp: int)
signal stamina_changed(current_stamina: int, max_stamina: int)
signal player_died()
signal damage_taken(amount: int, damage_type: String)
signal healed(amount: int)
signal xp_changed(current_xp: int, xp_to_next: int)
signal leveled_up(new_level: int)
signal pb_changed(new_amount: int)

# Stats base del jugador — todas inician en 5
@export var base_str: int = 5
@export var base_dex: int = 5
@export var base_con: int = 5
@export var base_int: int = 5
@export var base_wis: int = 5
@export var base_cha: int = 5

# Stats modificadas (por gear, buffs, etc.)
@export var mod_str: int = 0
@export var mod_dex: int = 0
@export var mod_con: int = 0
@export var mod_int: int = 0
@export var mod_wis: int = 0
@export var mod_cha: int = 0

# HP y Stamina
@export var current_hp: int = 100
@export var max_hp: int = 100
@export var current_stamina: int = 50
@export var max_stamina: int = 50

# Nivel y experiencia (XP system)
@export var level: int = 1
@export var current_xp: int = 0
@export var xp_to_next_level: int = 100
@export var skill_points: int = 0

@export var wanted_level: int = 0
@export var wanted_points: int = 0

# Ammo system
@export var ammo_pistol: int = 50
@export var ammo_rifle: int = 30
@export var ammo_shotgun: int = 20
@export var max_ammo_pistol: int = 100
@export var max_ammo_rifle: int = 60
@export var max_ammo_shotgun: int = 40

# Dinero del jugador (PB = Pesos del Barrio)
@export var carried_pb: int = 0

func _ready():
	"""Inicializa el sistema de stats al entrar al juego."""
	recalc_stats()

# ============================================================
# METODOS PUBLICOS
# ============================================================

func recalc_stats():
	"""Recalcula HP y stamina basado en CON y otros modificadores."""
	var total_con = base_con + mod_con
	max_hp = total_con * 20
	max_stamina = total_con * 10
	current_hp = mini(current_hp, max_hp)
	current_stamina = mini(current_stamina, max_stamina)
	health_changed.emit(current_hp, max_hp)
	stamina_changed.emit(current_stamina, max_stamina)

func get_stat(stat_name: String) -> int:
	"""Retorna el valor total (base + modificador) de un stat.
	
	Parametros:
		stat_name: Nombre del stat (STR, DEX, CON, INT, WIS, CHA)
	Returns:
		int: Valor total del stat
	"""
	match stat_name.to_upper():
		"STR":
			return base_str + mod_str
		"DEX":
			return base_dex + mod_dex
		"CON":
			return base_con + mod_con
		"INT":
			return base_int + mod_int
		"WIS":
			return base_wis + mod_wis
		"CHA":
			return base_cha + mod_cha
		_:
			push_error("StatManager: Stat desconocido: ", stat_name)
			return 0

func modify_stat(stat_name: String, amount: int, is_modifier: bool = true):
	"""Modifica un stat, ya sea base o modificador.
	
	Parametros:
		stat_name: Nombre del stat
		amount: Cantidad a modificar
		is_modifier: true = mod temporal, false = stat base permanente
	"""
	match stat_name.to_upper():
		"STR":
			if is_modifier:
				mod_str += amount
			else:
				base_str += amount
		"DEX":
			if is_modifier:
				mod_dex += amount
			else:
				base_dex += amount
		"CON":
			if is_modifier:
				mod_con += amount
			else:
				base_con += amount
			recalc_stats()
		"INT":
			if is_modifier:
				mod_int += amount
			else:
				base_int += amount
		"WIS":
			if is_modifier:
				mod_wis += amount
			else:
				base_wis += amount
		"CHA":
			if is_modifier:
				mod_cha += amount
			else:
				base_cha += amount
		_:
			push_error("StatsManager: Stat desconocido: ", stat_name)
			return
	stats_changed.emit(stat_name, get_stat(stat_name))

func apply_damage(amount: int, damage_type: String = "physical") -> int:
	"""Aplica danio al jugador. Retorna el danio real aplicado.
	
	Calculo de resistencia segun tipo de danio:
		- physical: reducido por CON
		- poison: reducido por CON
		- explosive: reducido por INT
		- magical: reducido por WIS
	
	Parametros:
		amount: Danio base
		damage_type: Tipo de danio (physical, poison, explosive, magical)
	Returns:
		int: Danio real aplicado despues de resistencia
	"""
	var resistance: int = 0
	match damage_type.to_lower():
		"physical":
			resistance = get_stat("CON") * 2
		"poison":
			resistance = get_stat("CON") * 3
		"explosive":
			resistance = get_stat("INT") * 2
		"magical":
			resistance = get_stat("WIS") * 2
		_:
			resistance = 0
	
	var final_damage = maxi(1, amount - resistance)
	current_hp = maxi(0, current_hp - final_damage)
	damage_taken.emit(final_damage, damage_type)
	health_changed.emit(current_hp, max_hp)
	
	if current_hp <= 0:
		player_died.emit()
	
	return final_damage

func heal(amount: int) -> int:
	"""Cura al jugador. Retorna la cantidad real curada.
	
	Parametros:
		amount: Cantidad de curacion
	Returns:
		int: Curacion real aplicada
	"""
	var before = current_hp
	current_hp = mini(max_hp, current_hp + amount)
	var actual_heal = current_hp - before
	if actual_heal > 0:
		healed.emit(actual_heal)
		health_changed.emit(current_hp, max_hp)
	return actual_heal

func use_stamina(amount: int) -> bool:
	"""Consume stamina. Retorna true si habia suficiente.
	
	Parametros:
		amount: Cantidad de stamina a consumir
	Returns:
		bool: true si se pudo consumir, false si no hay suficiente
	"""
	if current_stamina >= amount:
		current_stamina -= amount
		stamina_changed.emit(current_stamina, max_stamina)
		return true
	return false

func restore_stamina(amount: int):
	"""Recupera stamina.
	
	Parametros:
		amount: Cantidad a recuperar
	"""
	current_stamina = mini(max_stamina, current_stamina + amount)
	stamina_changed.emit(current_stamina, max_stamina)

# ============================================================
# SISTEMA DE DINERO PB
# ============================================================

func add_pb(amount: int):
	"""Anade PB al jugador.
	
	Parametros:
		amount: Cantidad de PB a anadir
	"""
	if amount <= 0:
		return
	carried_pb += amount
	pb_changed.emit(carried_pb)
	print("StatsManager: +%d PB (Total: %d)" % [amount, carried_pb])

func remove_pb(amount: int) -> bool:
	"""Resta PB al jugador. Retorna true si tenia suficiente.
	
	Parametros:
		amount: Cantidad de PB a remover
	Returns:
		bool: true si se pudo remover, false si no hay suficiente
	"""
	if amount <= 0:
		return true
	if carried_pb >= amount:
		carried_pb -= amount
		pb_changed.emit(carried_pb)
		print("StatsManager: -%d PB (Total: %d)" % [amount, carried_pb])
		return true
	return false

# ============================================================
# PERDIDA POR MUERTE
# ============================================================

func lose_xp_on_death() -> int:
	"""Pierde 15% de la XP acumulada en el nivel actual al morir.
	
	Returns:
		int: Cantidad de XP perdida
	"""
	var xp_lost = maxi(1, int(float(current_xp) * 0.15))
	current_xp = maxi(0, current_xp - xp_lost)
	xp_changed.emit(current_xp, xp_to_next_level)
	print("StatsManager: Perdiste %d XP al morir (XP restante: %d)" % [xp_lost, current_xp])
	return xp_lost

func lose_pb_on_death() -> int:
	"""Pierde 15% del PB cargado al morir.
	
	Returns:
		int: Cantidad de PB perdida
	"""
	var pb_lost = maxi(1, int(float(carried_pb) * 0.15))
	if pb_lost > 0 and carried_pb > 0:
		carried_pb = maxi(0, carried_pb - pb_lost)
		pb_changed.emit(carried_pb)
		print("StatsManager: Perdiste %d PB al morir (PB restante: %d)" % [pb_lost, carried_pb])
	return pb_lost

# ============================================================
# SISTEMA DE XP Y LEVELING
# ============================================================

func add_xp(amount: int):
	"""Anade experiencia y sube de nivel si corresponde.
	
	Lleva el exceso de XP al siguiente nivel.
	Emite xp_changed cada vez que se modifica la XP.
	
	Parametros:
		amount: Cantidad de experiencia ganada
	"""
	current_xp += amount
	while current_xp >= xp_to_next_level:
		_level_up()
	xp_changed.emit(current_xp, xp_to_next_level)

func _level_up():
	"""Ejecuta la subida de nivel con formula de curva personalizada.
	
	Formula XP: floor(100 * (level ^ 2.2) + 50 * level)
	Beneficios:
		- +10 max_hp, cura completa
		- +3 max_stamina
		- 1 punto de habilidad (skill_point)
	"""
	var excess_xp = current_xp - xp_to_next_level
	level += 1
	
	# Curva de XP: 100 * nivel^2.2 + 50 * nivel
	xp_to_next_level = int(floor(100.0 * pow(float(level), 2.2) + 50.0 * float(level)))
	current_xp = maxi(0, excess_xp)
	
	# Aumentar HP y stamina
	max_hp += 10
	current_hp += 10
	max_stamina += 3
	current_stamina = max_stamina
	
	# Curar al maximo al subir de nivel
	current_hp = max_hp
	current_stamina = max_stamina
	
	# Punto de habilidad
	skill_points += 1
	
	print("LEVEL UP! Nivel ", level)
	
	# Emitir seniales
	stats_changed.emit("level", level)
	leveled_up.emit(level)
	health_changed.emit(current_hp, max_hp)
	stamina_changed.emit(current_stamina, max_stamina)

# ============================================================
# FORMULAS DE JUEGO
# ============================================================

func get_melee_damage_bonus() -> int:
	"""Retorna el bonus de danio cuerpo a cuerpo basado en STR.
	
	Formula: STR * 2 + nivel
	"""
	return get_stat("STR") * 2 + level

func get_ranged_accuracy_bonus() -> int:
	"""Retorna el bonus de precision a distancia basado en DEX.
	
	Formula: DEX * 1.5
	"""
	return int(get_stat("DEX") * 1.5)

func get_poison_resistance() -> int:
	"""Retorna la resistencia a venenos basada en CON.
	
	Formula: CON * 3
	"""
	return get_stat("CON") * 3

func get_explosive_damage_bonus() -> int:
	"""Retorna el bonus de danio con explosivos basado en INT.
	
	Formula: INT * 2.5
	"""
	return int(get_stat("INT") * 2.5)

func get_detection_rating() -> int:
	"""Retorna la capacidad de deteccion/Percepcion basada en WIS.
	
	Formula: WIS * 2
	"""
	return get_stat("WIS") * 2

func get_price_modifier() -> float:
	"""Retorna el modificador de precios basado en CHA.
	
	Formula: 1.0 + (CHA * 0.05)
	Mayor CHA = mejores precios (mas barato comprar, mas caro vender)
	"""
	return 1.0 + (get_stat("CHA") * 0.05)

# ============================================================
# MODIFICADORES DE CLASE
# ============================================================

# Modificadores de clase (se asignan desde ClassData al aplicar clase)
var class_str_mod: float = 1.0
var class_dex_mod: float = 1.0
var class_con_mod: float = 1.0
var class_int_mod: float = 1.0
var class_wis_mod: float = 1.0
var class_cha_mod: float = 1.0
var class_base_hp: int = 100
var class_base_stamina: int = 50
var class_hp_per_level: int = 10
var class_stamina_per_level: int = 3

func apply_class_modifiers(class_data: Resource):
	"""Aplica los modificadores de clase a los stats base.
	
	Ajusta HP, stamina y multiplicadores de stats segun la clase.
	
	Parametros:
		class_data: Datos de la clase (ClassData)
	"""
	if class_data == null:
		push_error("StatsManager: ClassData es null")
		return
	
	class_str_mod = class_data.str_mod
	class_dex_mod = class_data.dex_mod
	class_con_mod = class_data.con_mod
	class_int_mod = class_data.int_mod
	class_wis_mod = class_data.wis_mod
	class_cha_mod = class_data.cha_mod
	class_base_hp = class_data.base_hp
	class_base_stamina = class_data.base_stamina
	class_hp_per_level = class_data.hp_per_level
	class_stamina_per_level = class_data.stamina_per_level
	
	# Recalcular HP y stamina con los nuevos valores de clase
	recalc_stats_with_class(class_data)

func recalc_stats_with_class(_class_data: Resource):
	"""Recalcula HP y stamina considerando valores base de clase y nivel."""
	var lvl = maxi(level, 1)
	max_hp = class_base_hp + (class_hp_per_level * (lvl - 1))
	max_stamina = class_base_stamina + (class_stamina_per_level * (lvl - 1))
	current_hp = mini(current_hp, max_hp)
	current_stamina = mini(current_stamina, max_stamina)
	health_changed.emit(current_hp, max_hp)
	stamina_changed.emit(current_stamina, max_stamina)

func get_effective_stat(stat_name: String, level_value: int) -> int:
	"""Retorna el stat efectivo considerando modificador de clase y nivel.
	
	Formula: (base + mod) * class_modifier + floor(level / 2)
	
	Parametros:
		stat_name: Nombre del stat (STR, DEX, CON, INT, WIS, CHA)
		level_value: Nivel del personaje
	Returns:
		int: Valor efectivo del stat
	"""
	var base = get_stat(stat_name)
	var multiplier = 1.0
	match stat_name.to_upper():
		"STR": multiplier = class_str_mod
		"DEX": multiplier = class_dex_mod
		"CON": multiplier = class_con_mod
		"INT": multiplier = class_int_mod
		"WIS": multiplier = class_wis_mod
		"CHA": multiplier = class_cha_mod
	var effective = int(float(base) * multiplier) + int(level_value / 2)
	return maxi(1, effective)

func get_hp_for_class(class_data: Resource, level_value: int) -> int:
	"""Calcula el HP maximo basado en los valores de clase y nivel.
	
	Formula: base_hp + hp_per_level * (nivel - 1)
	
	Parametros:
		class_data: Datos de la clase
		level_value: Nivel del personaje
	Returns:
		int: HP maximo calculado
	"""
	var hp = class_data.base_hp + (class_data.hp_per_level * (level_value - 1))
	return maxi(20, hp)

func get_stamina_for_class(class_data: Resource, level_value: int) -> int:
	"""Calcula la stamina maxima basada en los valores de clase y nivel.
	
	Formula: base_stamina + stamina_per_level * (nivel - 1)
	
	Parametros:
		class_data: Datos de la clase
		level_value: Nivel del personaje
	Returns:
		int: Stamina maxima calculada
	"""
	var stamina = class_data.base_stamina + (class_data.stamina_per_level * (level_value - 1))
	return maxi(10, stamina)
