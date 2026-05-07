# ============================================================

# class_manager.gd — ClassManager (Autoload Singleton)

# Barrio Sin Ley Online (BSLO)

# Base de datos central de todas las clases del juego.

# Registrado como autoload "ClassManager".

# ============================================================

extends Node



# Force Godot to compile and register class_name types

const _ClassData = preload("res://scripts/classes/class_data.gd")

const _SkillData = preload("res://scripts/classes/skill_data.gd")



enum Role {

	TANK,

	HEALER,

	MELEE,

	RANGED,

	SUPPORT,

	CONTROL,

	HYBRID

}



var _classes: Dictionary = {}





func _ready():

	process_mode = PROCESS_MODE_ALWAYS

	_build_database()





func _create_skill(data: Dictionary) -> Resource:

	var skill = _SkillData.new()

	skill.skill_name = data.get("skill_name", "")

	skill.skill_id = data.get("skill_id", "")

	skill.description = data.get("description", "")

	skill.icon_path = data.get("icon_path", "")

	skill.hotbar_slot = data.get("hotbar_slot", -1)

	skill.cooldown = data.get("cooldown", 0.0)

	skill.stamina_cost = data.get("stamina_cost", 0)

	skill.damage_multiplier = data.get("damage_multiplier", 1.0)

	skill.unlock_level = data.get("unlock_level", 1)

	skill.max_rank = data.get("max_rank", 5)

	skill.tree_branch = data.get("tree_branch", "")

	skill.prerequisites = data.get("prerequisites", [])

	skill.is_ultimate = data.get("is_ultimate", false)

	skill.is_targeted = data.get("is_targeted", true)

	skill.area_radius = data.get("area_radius", 0.0)

	skill.duration = data.get("duration", 0.0)

	return skill





func _create_class(data: Dictionary) -> Resource:

	var cd = _ClassData.new()

	cd.class_name_str = data.get("class_name_str", "")

	cd.class_id = data.get("class_id", "")

	cd.class_tag = data.get("class_tag", "")

	cd.role = data.get("role", "")

	cd.description = data.get("description", "")

	cd.lore = data.get("lore", "")

	cd.faction_required = data.get("faction", "")

	cd.is_elite = data.get("elite", false)

	cd.required_level = data.get("req_level", 1)

	cd.required_reputation = data.get("reputation", "")

	cd.primary_weapon = data.get("primary_weapon", "")

	cd.secondary_weapon = data.get("secondary_weapon", "")

	cd.primary_stat = data.get("primary_stat", "STR")

	cd.base_hp = data.get("base_hp", 100)

	cd.base_stamina = data.get("base_stamina", 50)

	cd.hp_per_level = data.get("hp_per_level", 10)

	cd.stamina_per_level = data.get("stamina_per_level", 3)

	cd.str_mod = data.get("str_mod", 1.0)

	cd.dex_mod = data.get("dex_mod", 1.0)

	cd.con_mod = data.get("con_mod", 1.0)

	cd.int_mod = data.get("int_mod", 1.0)

	cd.wis_mod = data.get("wis_mod", 1.0)

	cd.cha_mod = data.get("cha_mod", 1.0)

	cd.icon_path = data.get("icon_path", "")

	var skarr: Array = []

	for s in data.get("skills", []):

		skarr.append(_create_skill(s))

	cd.skills = skarr

	return cd





func _build_database():

	# ============================================================

	# CLASES UNIVERSALES (11)

	# ============================================================



	# --- TANK ROLE ---



	_classes["tanque"] = _create_class({

		"class_name_str": "Tanque",

		"class_id": "tanque",

		"class_tag": "TNK",

		"role": "TANK",

		"description": "El grandote del barrio. Absorbe danio, empuja enemigos, provoca. Nadie lo tumba.",

		"lore": "Crecio en las calles mas duras. Su cuerpo es un muro y su presencia impone respeto.",

		"faction": "",

		"elite": false,

		"req_level": 1,

		"reputation": "",

		"primary_weapon": "Bate de Beisbol",

		"secondary_weapon": "Chaleco Antibalas",

		"primary_stat": "CON",

		"base_hp": 150,

		"base_stamina": 50,

		"hp_per_level": 15,

		"stamina_per_level": 3,

		"str_mod": 1.1,

		"dex_mod": 0.7,

		"con_mod": 1.4,

		"int_mod": 0.8,

		"wis_mod": 0.9,

		"cha_mod": 1.1,

		"icon_path": "",

		"skills": [

			{"skill_name": "Empujon", "skill_id": "tanque_empujon", "description": "Empuja enemigo 5m. Si choca contra pared, stun 2s.", "hotbar_slot": 1, "cooldown": 6.0, "stamina_cost": 12, "damage_multiplier": 0.4, "unlock_level": 1, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 0.0},

			{"skill_name": "Provocacion", "skill_id": "tanque_provocacion", "description": "Taunt en area 10m. Obliga a enemigos a atacarte 5s.", "hotbar_slot": 2, "cooldown": 12.0, "stamina_cost": 20, "damage_multiplier": 0.0, "unlock_level": 3, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 10.0, "duration": 5.0},

			{"skill_name": "Aguante", "skill_id": "tanque_aguante", "description": "+50% defensa, -30% velocidad. Duracion 8s.", "hotbar_slot": 3, "cooldown": 20.0, "stamina_cost": 25, "damage_multiplier": 0.0, "unlock_level": 5, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 0.0, "duration": 8.0},

			{"skill_name": "Contragolpe", "skill_id": "tanque_contragolpe", "description": "Bloquea proximo ataque y devuelve 150% danio.", "hotbar_slot": 4, "cooldown": 14.0, "stamina_cost": 15, "damage_multiplier": 1.5, "unlock_level": 7, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 0.0, "duration": 0.0},

			{"skill_name": "Terremoto", "skill_id": "tanque_terremoto", "description": "Golpea el suelo. Stun en area 8m por 3s.", "hotbar_slot": 5, "cooldown": 35.0, "stamina_cost": 35, "damage_multiplier": 0.8, "unlock_level": 10, "max_rank": 5, "tree_branch": "", "is_ultimate": true, "is_targeted": false, "area_radius": 8.0, "duration": 3.0},

			{"skill_name": "Muro (Pasiva A)", "skill_id": "tanque_muro", "description": "+20% HP maximo, +10% resistencia CC.", "hotbar_slot": -1, "tree_branch": "A", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Carnicero (Pasiva B)", "skill_id": "tanque_carnicero", "description": "+15% danio melee. Golpes generan mas amenaza.", "hotbar_slot": -1, "tree_branch": "B", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Protector (Pasiva C)", "skill_id": "tanque_protector", "description": "Aliados en 8m reciben 10% de tu defensa.", "hotbar_slot": -1, "tree_branch": "C", "unlock_level": 2, "max_rank": 5}

		]

	})



	_classes["matasanos"] = _create_class({

		"class_name_str": "Matasanos",

		"class_id": "matasanos",

		"class_tag": "MTS",

		"role": "HEALER",

		"description": "Medico callejero. Cura directa, revive aliados, aplica antidotos. Imprescindible.",

		"lore": "Estudio medicina en YouTube. Sus jeringas estan oxidadas pero curan.",

		"faction": "",

		"elite": false,

		"req_level": 1,

		"reputation": "",

		"primary_weapon": "Jeringas",

		"secondary_weapon": "Botiquin",

		"primary_stat": "WIS",

		"base_hp": 110,

		"base_stamina": 55,

		"hp_per_level": 10,

		"stamina_per_level": 3,

		"str_mod": 0.8,

		"dex_mod": 0.9,

		"con_mod": 1.1,

		"int_mod": 1.1,

		"wis_mod": 1.3,

		"cha_mod": 0.9,

		"icon_path": "",

		"skills": [

			{"skill_name": "Jeringazo", "skill_id": "matasanos_jeringazo", "description": "Cura 25% HP a un aliado. Instantaneo.", "hotbar_slot": 1, "cooldown": 4.0, "stamina_cost": 10, "damage_multiplier": 0.0, "unlock_level": 1, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 0.0},

			{"skill_name": "Vendas", "skill_id": "matasanos_vendas", "description": "HOT: 5% HP cada 2s por 10s.", "hotbar_slot": 2, "cooldown": 10.0, "stamina_cost": 15, "damage_multiplier": 0.0, "unlock_level": 2, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 10.0},

			{"skill_name": "Adrenalina", "skill_id": "matasanos_adrenalina", "description": "Resucita aliado con 30% HP. 2 min CD.", "hotbar_slot": 3, "cooldown": 120.0, "stamina_cost": 30, "damage_multiplier": 0.0, "unlock_level": 5, "max_rank": 3, "tree_branch": "", "is_ultimate": true, "is_targeted": true, "area_radius": 0.0, "duration": 0.0},

			{"skill_name": "Antidoto", "skill_id": "matasanos_antidoto", "description": "Remueve veneno y todos los debuffs.", "hotbar_slot": 4, "cooldown": 8.0, "stamina_cost": 10, "damage_multiplier": 0.0, "unlock_level": 3, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 0.0},

			{"skill_name": "Quirofano Movil", "skill_id": "matasanos_quirofano", "description": "Area curacion 8m. 15% HP/s por 6s. 5 min CD.", "hotbar_slot": 5, "cooldown": 300.0, "stamina_cost": 50, "damage_multiplier": 0.0, "unlock_level": 12, "max_rank": 3, "tree_branch": "", "is_ultimate": true, "is_targeted": false, "area_radius": 8.0, "duration": 6.0},

			{"skill_name": "Cirujano (Pasiva A)", "skill_id": "matasanos_cirujano", "description": "+20% efectividad curas directas.", "hotbar_slot": -1, "tree_branch": "A", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Farmaceutico (Pasiva B)", "skill_id": "matasanos_farmaceutico", "description": "HOTs +5s duracion y stackean.", "hotbar_slot": -1, "tree_branch": "B", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Triaje (Pasiva C)", "skill_id": "matasanos_triaje", "description": "Aliado <20% HP: curas +50% efectivas.", "hotbar_slot": -1, "tree_branch": "C", "unlock_level": 2, "max_rank": 5}

		]

	})



	_classes["yerbatero"] = _create_class({

		"class_name_str": "Yerbatero",

		"class_id": "yerbatero",

		"class_tag": "YRB",

		"role": "HEALER",

		"description": "Cura con menjunjes. HoTs, areas de curacion, sacrificio y milagros.",

		"lore": "Aprendio de su abuela curandera. Sus tacos curan cuerpo y alma.",

		"faction": "",

		"elite": false,

		"req_level": 1,

		"reputation": "",

		"primary_weapon": "Hierbas Curativas",

		"secondary_weapon": "Amuletos",

		"primary_stat": "WIS",

		"base_hp": 105,

		"base_stamina": 60,

		"hp_per_level": 9,

		"stamina_per_level": 4,

		"str_mod": 0.7,

		"dex_mod": 0.9,

		"con_mod": 1.0,

		"int_mod": 1.1,

		"wis_mod": 1.4,

		"cha_mod": 1.0,

		"icon_path": "",

		"skills": [

			{"skill_name": "Taco Curativo", "skill_id": "yerbatero_taco", "description": "Lanza taco. Cura 20% HP.", "hotbar_slot": 1, "cooldown": 5.0, "stamina_cost": 10, "damage_multiplier": 0.0, "unlock_level": 1, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 0.0},

			{"skill_name": "Incienso", "skill_id": "yerbatero_incienso", "description": "Area 8m: +10% HP regen pasivo 20s.", "hotbar_slot": 2, "cooldown": 25.0, "stamina_cost": 20, "damage_multiplier": 0.0, "unlock_level": 3, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 8.0, "duration": 20.0},

			{"skill_name": "Limpia", "skill_id": "yerbatero_limpia", "description": "Remueve 1 debuff de aliados en 15m.", "hotbar_slot": 3, "cooldown": 12.0, "stamina_cost": 15, "damage_multiplier": 0.0, "unlock_level": 4, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 15.0, "duration": 0.0},

			{"skill_name": "Ofrenda", "skill_id": "yerbatero_ofrenda", "description": "Sacrifica 15% HP. Aliados en 20m reciben el doble.", "hotbar_slot": 4, "cooldown": 20.0, "stamina_cost": 25, "damage_multiplier": 0.0, "unlock_level": 7, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 20.0, "duration": 0.0},

			{"skill_name": "Milagro", "skill_id": "yerbatero_milagro", "description": "Revive TODOS los aliados en 20m con 10% HP. 15 min CD.", "hotbar_slot": 5, "cooldown": 900.0, "stamina_cost": 60, "damage_multiplier": 0.0, "unlock_level": 15, "max_rank": 3, "tree_branch": "", "is_ultimate": true, "is_targeted": false, "area_radius": 20.0, "duration": 0.0},

			{"skill_name": "Fe (Pasiva A)", "skill_id": "yerbatero_fe", "description": "+25% efectividad Milagro y Ofrenda.", "hotbar_slot": -1, "tree_branch": "A", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Naturaleza (Pasiva B)", "skill_id": "yerbatero_naturaleza", "description": "Incienso tambien da +10% vel. movimiento.", "hotbar_slot": -1, "tree_branch": "B", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Martir (Pasiva C)", "skill_id": "yerbatero_martir", "description": "-10% danio recibido al canalizar curas.", "hotbar_slot": -1, "tree_branch": "C", "unlock_level": 2, "max_rank": 5}

		]

	})



	# --- DPS MELEE ROLE ---



	_classes["boxeador"] = _create_class({

		"class_name_str": "Boxeador",

		"class_id": "boxeador",

		"class_tag": "BOX",

		"role": "MELEE",

		"description": "Punios limpios. Velocidad, combos demoledores, knockouts. Sin armas, solo tecnica.",

		"lore": "Campeon del gimnasio del barrio. Sus punios son mas rapidos que cualquier navaja.",

		"faction": "",

		"elite": false,

		"req_level": 1,

		"reputation": "",

		"primary_weapon": "Punios",

		"secondary_weapon": "Vendas de Boxeo",

		"primary_stat": "STR",

		"base_hp": 115,

		"base_stamina": 60,

		"hp_per_level": 10,

		"stamina_per_level": 4,

		"str_mod": 1.3,

		"dex_mod": 1.2,

		"con_mod": 1.0,

		"int_mod": 0.7,

		"wis_mod": 0.8,

		"cha_mod": 1.0,

		"icon_path": "",

		"skills": [

			{"skill_name": "Jab", "skill_id": "boxeador_jab", "description": "Golpe rapido. 3 cargas.", "hotbar_slot": 1, "cooldown": 1.5, "stamina_cost": 5, "damage_multiplier": 0.6, "unlock_level": 1, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 0.0},

			{"skill_name": "Gancho", "skill_id": "boxeador_gancho", "description": "+100% danio. 8s CD.", "hotbar_slot": 2, "cooldown": 8.0, "stamina_cost": 18, "damage_multiplier": 2.0, "unlock_level": 2, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 0.0},

			{"skill_name": "Esquiva", "skill_id": "boxeador_esquiva", "description": "Dash lateral con 0.5s invulnerabilidad.", "hotbar_slot": 3, "cooldown": 6.0, "stamina_cost": 12, "damage_multiplier": 0.0, "unlock_level": 3, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 0.0, "duration": 0.5},

			{"skill_name": "Combo", "skill_id": "boxeador_combo", "description": "5 golpes. Ultimo +200% danio.", "hotbar_slot": 4, "cooldown": 14.0, "stamina_cost": 25, "damage_multiplier": 3.0, "unlock_level": 6, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 0.0},

			{"skill_name": "Knockout", "skill_id": "boxeador_knockout", "description": "Enemigo <30% HP: 50% prob stun 5s.", "hotbar_slot": 5, "cooldown": 25.0, "stamina_cost": 30, "damage_multiplier": 1.5, "unlock_level": 10, "max_rank": 5, "tree_branch": "", "is_ultimate": true, "is_targeted": true, "area_radius": 0.0, "duration": 5.0},

			{"skill_name": "Peso Pesado (Pasiva A)", "skill_id": "boxeador_peso_pesado", "description": "+20% danio base, -10% vel. ataque.", "hotbar_slot": -1, "tree_branch": "A", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Peso Ligero (Pasiva B)", "skill_id": "boxeador_peso_ligero", "description": "+20% vel. ataque, +1 carga Jab.", "hotbar_slot": -1, "tree_branch": "B", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Contragolpeador (Pasiva C)", "skill_id": "boxeador_contragolpeador", "description": "Bloquear reduce 2s CD de Esquiva.", "hotbar_slot": -1, "tree_branch": "C", "unlock_level": 2, "max_rank": 5}

		]

	})



	_classes["sicario"] = _create_class({

		"class_name_str": "Sicario",

		"class_id": "sicario",

		"class_tag": "SIC",

		"role": "MELEE",

		"description": "Sigilo, punialadas por la espalda, ejecuciones. Nadie lo ve venir.",

		"lore": "Nadie conoce su nombre. Cuando aparece con navaja y garrote, hay que correr.",

		"faction": "",

		"elite": false,

		"req_level": 1,

		"reputation": "",

		"primary_weapon": "Navaja",

		"secondary_weapon": "Garrote",

		"primary_stat": "DEX",

		"base_hp": 100,

		"base_stamina": 65,

		"hp_per_level": 8,

		"stamina_per_level": 5,

		"str_mod": 0.9,

		"dex_mod": 1.4,

		"con_mod": 0.8,

		"int_mod": 1.0,

		"wis_mod": 1.1,

		"cha_mod": 0.9,

		"icon_path": "",

		"skills": [

			{"skill_name": "Punialada", "skill_id": "sicario_punialada", "description": "Por la espalda: +150% danio.", "hotbar_slot": 1, "cooldown": 3.0, "stamina_cost": 10, "damage_multiplier": 1.0, "unlock_level": 1, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 0.0},

			{"skill_name": "Sigilo", "skill_id": "sicario_sigilo", "description": "Invisible 8s. Primer ataque +200% danio.", "hotbar_slot": 2, "cooldown": 20.0, "stamina_cost": 20, "damage_multiplier": 0.0, "unlock_level": 3, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 0.0, "duration": 8.0},

			{"skill_name": "Garrote", "skill_id": "sicario_garrote", "description": "Stun 4s. Solo desde sigilo.", "hotbar_slot": 3, "cooldown": 15.0, "stamina_cost": 15, "damage_multiplier": 0.3, "unlock_level": 5, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 4.0},

			{"skill_name": "Marca", "skill_id": "sicario_marca", "description": "Enemigo recibe +25% danio 10s.", "hotbar_slot": 4, "cooldown": 12.0, "stamina_cost": 10, "damage_multiplier": 0.0, "unlock_level": 4, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 10.0},

			{"skill_name": "Ejecucion", "skill_id": "sicario_ejecucion", "description": "Enemigo <15% HP: muerte instantanea. 2 min CD.", "hotbar_slot": 5, "cooldown": 120.0, "stamina_cost": 35, "damage_multiplier": 99.0, "unlock_level": 12, "max_rank": 3, "tree_branch": "", "is_ultimate": true, "is_targeted": true, "area_radius": 0.0, "duration": 0.0},

			{"skill_name": "Asesino (Pasiva A)", "skill_id": "sicario_asesino", "description": "+30% danio en sigilo.", "hotbar_slot": -1, "tree_branch": "A", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Saboteador (Pasiva B)", "skill_id": "sicario_saboteador", "description": "Colocar trampas no rompe sigilo.", "hotbar_slot": -1, "tree_branch": "B", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Fantasma (Pasiva C)", "skill_id": "sicario_fantasma_pasiva", "description": "+5s duracion Sigilo.", "hotbar_slot": -1, "tree_branch": "C", "unlock_level": 2, "max_rank": 5}

		]

	})



	_classes["destructor"] = _create_class({

		"class_name_str": "Destructor",

		"class_id": "destructor",

		"class_tag": "DES",

		"role": "MELEE",

		"description": "El que entra rompiendo todo. Bate, cadena, furia y danio en area.",

		"lore": "Cuando entra a un edificio, sale por la pared. Su bate tiene mas muertes que muchos pistoleros.",

		"faction": "",

		"elite": false,

		"req_level": 1,

		"reputation": "",

		"primary_weapon": "Bate de Beisbol",

		"secondary_weapon": "Cadena",

		"primary_stat": "STR",

		"base_hp": 120,

		"base_stamina": 55,

		"hp_per_level": 11,

		"stamina_per_level": 3,

		"str_mod": 1.3,

		"dex_mod": 0.9,

		"con_mod": 1.1,

		"int_mod": 0.7,

		"wis_mod": 0.8,

		"cha_mod": 1.1,

		"icon_path": "",

		"skills": [

			{"skill_name": "Batazo", "skill_id": "destructor_batazo", "description": "Danio en arco 120 grados.", "hotbar_slot": 1, "cooldown": 4.0, "stamina_cost": 12, "damage_multiplier": 1.0, "unlock_level": 1, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 2.5, "duration": 0.0},

			{"skill_name": "Cadena", "skill_id": "destructor_cadena", "description": "Giro 360. Empuja enemigos 3m.", "hotbar_slot": 2, "cooldown": 8.0, "stamina_cost": 15, "damage_multiplier": 0.8, "unlock_level": 2, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 3.0, "duration": 0.0},

			{"skill_name": "Furia", "skill_id": "destructor_furia", "description": "+40% vel. ataque, -20% defensa 8s.", "hotbar_slot": 3, "cooldown": 18.0, "stamina_cost": 20, "damage_multiplier": 0.0, "unlock_level": 4, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 0.0, "duration": 8.0},

			{"skill_name": "Carga", "skill_id": "destructor_carga", "description": "Corre 10m. Atraviesa enemigos.", "hotbar_slot": 4, "cooldown": 12.0, "stamina_cost": 18, "damage_multiplier": 0.7, "unlock_level": 6, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 0.0, "duration": 0.0},

			{"skill_name": "Destruccion", "skill_id": "destructor_destruccion", "description": "Danio masivo area 6m. Rompe cobertura.", "hotbar_slot": 5, "cooldown": 30.0, "stamina_cost": 35, "damage_multiplier": 2.5, "unlock_level": 10, "max_rank": 5, "tree_branch": "", "is_ultimate": true, "is_targeted": false, "area_radius": 6.0, "duration": 0.0},

			{"skill_name": "Demoledor (Pasiva A)", "skill_id": "destructor_demoledor", "description": "+20% danio a estructuras y vehiculos.", "hotbar_slot": -1, "tree_branch": "A", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Incansable (Pasiva B)", "skill_id": "destructor_incansable", "description": "-2s CD tras cada kill.", "hotbar_slot": -1, "tree_branch": "B", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Tanque de Acero (Pasiva C)", "skill_id": "destructor_tanque_acero", "description": "-15% danio durante Furia.", "hotbar_slot": -1, "tree_branch": "C", "unlock_level": 2, "max_rank": 5}

		]

	})



	# --- DPS RANGO ROLE ---



	_classes["francotirador"] = _create_class({

		"class_name_str": "Francotirador",

		"class_id": "francotirador",

		"class_tag": "FRA",

		"role": "RANGED",

		"description": "Larga distancia, criticos, disparo preciso. Si lo ves, ya es tarde.",

		"lore": "Se crio con un rifle en la mano. Acierta a una moneda a 100m.",

		"faction": "",

		"elite": false,

		"req_level": 1,

		"reputation": "",

		"primary_weapon": "Rifle de Precision",

		"secondary_weapon": "Pistola 9mm",

		"primary_stat": "DEX",

		"base_hp": 95,

		"base_stamina": 50,

		"hp_per_level": 8,

		"stamina_per_level": 3,

		"str_mod": 0.7,

		"dex_mod": 1.4,

		"con_mod": 0.8,

		"int_mod": 1.0,

		"wis_mod": 1.2,

		"cha_mod": 0.9,

		"icon_path": "",

		"skills": [

			{"skill_name": "Disparo Preciso", "skill_id": "francotirador_disparo_preciso", "description": "+30% danio. CD reinicia en kill.", "hotbar_slot": 1, "cooldown": 5.0, "stamina_cost": 10, "damage_multiplier": 1.3, "unlock_level": 1, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 0.0},

			{"skill_name": "Rafaga", "skill_id": "francotirador_rafaga", "description": "5 disparos en 1.5s. Precision -40%.", "hotbar_slot": 2, "cooldown": 10.0, "stamina_cost": 20, "damage_multiplier": 0.6, "unlock_level": 3, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 1.5},

			{"skill_name": "Recarga Rapida", "skill_id": "francotirador_recarga", "description": "Recarga instantanea. 20s CD.", "hotbar_slot": 3, "cooldown": 20.0, "stamina_cost": 5, "damage_multiplier": 0.0, "unlock_level": 4, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 0.0, "duration": 0.0},

			{"skill_name": "Tiro en la Cabeza", "skill_id": "francotirador_tiro_cabeza", "description": "Critico garantizado. +200% danio. 30s CD.", "hotbar_slot": 4, "cooldown": 30.0, "stamina_cost": 25, "damage_multiplier": 3.0, "unlock_level": 8, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 0.0},

			{"skill_name": "Fuego Supresivo", "skill_id": "francotirador_fuego_supresivo", "description": "Enemigos en 15m: -30% precision 6s.", "hotbar_slot": 5, "cooldown": 25.0, "stamina_cost": 30, "damage_multiplier": 0.0, "unlock_level": 10, "max_rank": 5, "tree_branch": "", "is_ultimate": true, "is_targeted": false, "area_radius": 15.0, "duration": 6.0},

			{"skill_name": "Francotirador (Pasiva A)", "skill_id": "francotirador_pasiva_a", "description": "+15% danio a >20m.", "hotbar_slot": -1, "tree_branch": "A", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Pistolero (Pasiva B)", "skill_id": "francotirador_pistolero", "description": "+25% danio con pistolas y SMGs.", "hotbar_slot": -1, "tree_branch": "B", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Municion Especial (Pasiva C)", "skill_id": "francotirador_municion", "description": "10% prob no consumir municion.", "hotbar_slot": -1, "tree_branch": "C", "unlock_level": 2, "max_rank": 5}

		]

	})



	_classes["demoledor"] = _create_class({

		"class_name_str": "Demoledor",

		"class_id": "demoledor",

		"class_tag": "DEM",

		"role": "RANGED",

		"description": "Si no explota, no sirve. Granadas, minas, RPGs y Molotovs.",

		"lore": "Su taller es un arsenal. Cada explosion es una obra de arte.",

		"faction": "",

		"elite": false,

		"req_level": 1,

		"reputation": "",

		"primary_weapon": "Granadas",

		"secondary_weapon": "RPG",

		"primary_stat": "INT",

		"base_hp": 100,

		"base_stamina": 50,

		"hp_per_level": 8,

		"stamina_per_level": 3,

		"str_mod": 0.8,

		"dex_mod": 1.0,

		"con_mod": 0.9,

		"int_mod": 1.4,

		"wis_mod": 0.9,

		"cha_mod": 0.9,

		"icon_path": "",

		"skills": [

			{"skill_name": "Granada", "skill_id": "demoledor_granada", "description": "Danio area 5m. 3 cargas.", "hotbar_slot": 1, "cooldown": 15.0, "stamina_cost": 10, "damage_multiplier": 1.5, "unlock_level": 1, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 5.0, "duration": 0.0},

			{"skill_name": "Mina", "skill_id": "demoledor_mina", "description": "Detonacion por proximidad. 30s duracion.", "hotbar_slot": 2, "cooldown": 10.0, "stamina_cost": 15, "damage_multiplier": 2.0, "unlock_level": 3, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 3.0, "duration": 30.0},

			{"skill_name": "RPG", "skill_id": "demoledor_rpg", "description": "Danio masivo area 3m. 45s CD.", "hotbar_slot": 3, "cooldown": 45.0, "stamina_cost": 25, "damage_multiplier": 3.0, "unlock_level": 7, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 3.0, "duration": 0.0},

			{"skill_name": "Coctel Molotov", "skill_id": "demoledor_molotov", "description": "Area fuego 5m. 8s. Danio/s.", "hotbar_slot": 4, "cooldown": 12.0, "stamina_cost": 12, "damage_multiplier": 0.8, "unlock_level": 4, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 5.0, "duration": 8.0},

			{"skill_name": "Bomba de Humo", "skill_id": "demoledor_bomba_humo", "description": "Area 10m. 0% visibilidad. 12s.", "hotbar_slot": 5, "cooldown": 25.0, "stamina_cost": 15, "damage_multiplier": 0.0, "unlock_level": 6, "max_rank": 5, "tree_branch": "", "is_ultimate": true, "is_targeted": false, "area_radius": 10.0, "duration": 12.0},

			{"skill_name": "Demoledor (Pasiva A)", "skill_id": "demoledor_pasiva_a", "description": "+25% radio explosiones.", "hotbar_slot": -1, "tree_branch": "A", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Trampero (Pasiva B)", "skill_id": "demoledor_trampero", "description": "2 minas activas simultaneamente.", "hotbar_slot": -1, "tree_branch": "B", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Piromaniaco (Pasiva C)", "skill_id": "demoledor_piromaniaco", "description": "+30% danio fuego. Molotovs +4s.", "hotbar_slot": -1, "tree_branch": "C", "unlock_level": 2, "max_rank": 5}

		]

	})



	_classes["hacker"] = _create_class({

		"class_name_str": "Hacker",

		"class_id": "hacker",

		"class_tag": "HCK",

		"role": "RANGED",

		"description": "Drones de ataque, hackeo de armas, virus y DDoS. La tecnologia es su arma.",

		"lore": "Tiene mas servidores que muchos bancos. Hackea todo.",

		"faction": "",

		"elite": false,

		"req_level": 1,

		"reputation": "",

		"primary_weapon": "Drones de Combate",

		"secondary_weapon": "Virus Informaticos",

		"primary_stat": "INT",

		"base_hp": 95,

		"base_stamina": 55,

		"hp_per_level": 7,

		"stamina_per_level": 4,

		"str_mod": 0.6,

		"dex_mod": 0.9,

		"con_mod": 0.8,

		"int_mod": 1.5,

		"wis_mod": 1.1,

		"cha_mod": 0.9,

		"icon_path": "",

		"skills": [

			{"skill_name": "Drone de Ataque", "skill_id": "hacker_drone", "description": "Despliega drone que dispara auto. 15s.", "hotbar_slot": 1, "cooldown": 18.0, "stamina_cost": 15, "damage_multiplier": 0.5, "unlock_level": 1, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 0.0, "duration": 15.0},

			{"skill_name": "Hackeo de Arma", "skill_id": "hacker_hackeo_arma", "description": "Enemigo no puede disparar 3s.", "hotbar_slot": 2, "cooldown": 10.0, "stamina_cost": 12, "damage_multiplier": 0.0, "unlock_level": 2, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 3.0},

			{"skill_name": "Virus", "skill_id": "hacker_virus", "description": "Danio area 10m. +50% a mecanicos.", "hotbar_slot": 3, "cooldown": 12.0, "stamina_cost": 20, "damage_multiplier": 0.8, "unlock_level": 4, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 10.0, "duration": 0.0},

			{"skill_name": "Sobrecarga", "skill_id": "hacker_sobrecarga", "description": "Vehiculo/torreta explota tras 3s.", "hotbar_slot": 4, "cooldown": 22.0, "stamina_cost": 18, "damage_multiplier": 3.0, "unlock_level": 7, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 4.0, "duration": 3.0},

			{"skill_name": "DDoS", "skill_id": "hacker_ddos", "description": "Enemigos en 20m: lag (acciones retrasadas 1s). 6s.", "hotbar_slot": 5, "cooldown": 35.0, "stamina_cost": 30, "damage_multiplier": 0.0, "unlock_level": 10, "max_rank": 5, "tree_branch": "", "is_ultimate": true, "is_targeted": false, "area_radius": 20.0, "duration": 6.0},

			{"skill_name": "Ingeniero (Pasiva A)", "skill_id": "hacker_ingeniero", "description": "+15% duracion drones. 2 drones.", "hotbar_slot": -1, "tree_branch": "A", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Black Hat (Pasiva B)", "skill_id": "hacker_black_hat", "description": "+20% duracion hacks/CC.", "hotbar_slot": -1, "tree_branch": "B", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Overclocker (Pasiva C)", "skill_id": "hacker_overclocker", "description": "-15% CD en todas las habilidades.", "hotbar_slot": -1, "tree_branch": "C", "unlock_level": 2, "max_rank": 5}

		]

	})



	# --- SUPPORT ROLE ---



	_classes["capo"] = _create_class({

		"class_name_str": "Capo",

		"class_id": "capo",

		"class_tag": "CAP",

		"role": "SUPPORT",

		"description": "Buffea aliados, marca enemigos, dirige el repliegue tactico. Un verdadero lider.",

		"lore": "Su voz por la radio vale mas que cien balas.",

		"faction": "",

		"elite": false,

		"req_level": 1,

		"reputation": "",

		"primary_weapon": "Radio Tactica",

		"secondary_weapon": "Planos de Batalla",

		"primary_stat": "CHA",

		"base_hp": 105,

		"base_stamina": 55,

		"hp_per_level": 9,

		"stamina_per_level": 3,

		"str_mod": 0.7,

		"dex_mod": 0.8,

		"con_mod": 1.0,

		"int_mod": 1.1,

		"wis_mod": 1.1,

		"cha_mod": 1.4,

		"icon_path": "",

		"skills": [

			{"skill_name": "Motivacion", "skill_id": "capo_motivacion", "description": "+15% danio aliados 20m. 15s.", "hotbar_slot": 1, "cooldown": 18.0, "stamina_cost": 15, "damage_multiplier": 0.0, "unlock_level": 1, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 20.0, "duration": 15.0},

			{"skill_name": "Plan de Batalla", "skill_id": "capo_plan_batalla", "description": "Marca punto. Aliados cerca +20% defensa.", "hotbar_slot": 2, "cooldown": 15.0, "stamina_cost": 12, "damage_multiplier": 0.0, "unlock_level": 3, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 10.0, "duration": 20.0},

			{"skill_name": "Repliegue", "skill_id": "capo_repliegue", "description": "Aliados en 30m +50% velocidad 5s.", "hotbar_slot": 3, "cooldown": 25.0, "stamina_cost": 20, "damage_multiplier": 0.0, "unlock_level": 5, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 30.0, "duration": 5.0},

			{"skill_name": "Inspector", "skill_id": "capo_inspector", "description": "Enemigo recibe +20% danio 10s.", "hotbar_slot": 4, "cooldown": 12.0, "stamina_cost": 10, "damage_multiplier": 0.0, "unlock_level": 4, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 10.0},

			{"skill_name": "Ultima Orden", "skill_id": "capo_ultima_orden", "description": "Al morir: aliados 30m invulnerables 4s.", "hotbar_slot": 5, "cooldown": 120.0, "stamina_cost": 30, "damage_multiplier": 0.0, "unlock_level": 12, "max_rank": 3, "tree_branch": "", "is_ultimate": true, "is_targeted": false, "area_radius": 30.0, "duration": 12.0},

			{"skill_name": "Estratega (Pasiva A)", "skill_id": "capo_estratega", "description": "+25% duracion buffs.", "hotbar_slot": -1, "tree_branch": "A", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Carismatico (Pasiva B)", "skill_id": "capo_carismatico", "description": "Buffs afectan +3 aliados.", "hotbar_slot": -1, "tree_branch": "B", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Martir (Pasiva C)", "skill_id": "capo_martir_pasiva", "description": "Ultima Orden +2s. Revive aliados cercanos.", "hotbar_slot": -1, "tree_branch": "C", "unlock_level": 2, "max_rank": 5}

		]

	})



	# --- CONTROL ROLE ---



	_classes["quimico"] = _create_class({

		"class_name_str": "Quimico",

		"class_id": "quimico",

		"class_tag": "QMC",

		"role": "CONTROL",

		"description": "Gases toxicos, acidos, venenos. Control total del campo de batalla.",

		"lore": "Su sotano es un laboratorio. Cada formula es un nuevo infierno.",

		"faction": "",

		"elite": false,

		"req_level": 1,

		"reputation": "",

		"primary_weapon": "Gases Toxicos",

		"secondary_weapon": "Acidos",

		"primary_stat": "INT",

		"base_hp": 100,

		"base_stamina": 55,

		"hp_per_level": 8,

		"stamina_per_level": 4,

		"str_mod": 0.6,

		"dex_mod": 0.9,

		"con_mod": 1.0,

		"int_mod": 1.4,

		"wis_mod": 1.1,

		"cha_mod": 0.8,

		"icon_path": "",

		"skills": [

			{"skill_name": "Gas Toxico", "skill_id": "quimico_gas_toxico", "description": "Nube 8m. Danio/s + -20% vel. 10s.", "hotbar_slot": 1, "cooldown": 14.0, "stamina_cost": 15, "damage_multiplier": 0.4, "unlock_level": 1, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 8.0, "duration": 10.0},

			{"skill_name": "Acido", "skill_id": "quimico_acido", "description": "Chorro en linea. Degrada armadura -10% (x3).", "hotbar_slot": 2, "cooldown": 8.0, "stamina_cost": 12, "damage_multiplier": 0.7, "unlock_level": 2, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 0.0},

			{"skill_name": "Bomba de Humo", "skill_id": "quimico_bomba_humo", "description": "Area 10m. Ciega enemigos 4s.", "hotbar_slot": 3, "cooldown": 18.0, "stamina_cost": 12, "damage_multiplier": 0.0, "unlock_level": 3, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 10.0, "duration": 4.0},

			{"skill_name": "Veneno", "skill_id": "quimico_veneno", "description": "DoT: 5% HP/s por 8s.", "hotbar_slot": 4, "cooldown": 12.0, "stamina_cost": 18, "damage_multiplier": 0.0, "unlock_level": 5, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 8.0},

			{"skill_name": "Plaga", "skill_id": "quimico_plaga", "description": "Veneno a todos en 15m. 2 min CD.", "hotbar_slot": 5, "cooldown": 120.0, "stamina_cost": 35, "damage_multiplier": 0.0, "unlock_level": 12, "max_rank": 3, "tree_branch": "", "is_ultimate": true, "is_targeted": false, "area_radius": 15.0, "duration": 8.0},

			{"skill_name": "Toxicologo (Pasiva A)", "skill_id": "quimico_toxicologo", "description": "+30% duracion venenos/gases.", "hotbar_slot": -1, "tree_branch": "A", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Corrosivo (Pasiva B)", "skill_id": "quimico_corrosivo", "description": "Acido reduce 50% mas armadura.", "hotbar_slot": -1, "tree_branch": "B", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Epidemia (Pasiva C)", "skill_id": "quimico_epidemia", "description": "Plaga salta al morir objetivo.", "hotbar_slot": -1, "tree_branch": "C", "unlock_level": 2, "max_rank": 5}

		]

	})



	# ============================================================

	# CLASES DE FACCION (6)

	# ============================================================



	_classes["shatei"] = _create_class({

		"class_name_str": "Shatei",

		"class_id": "shatei",

		"class_tag": "SHA",

		"role": "MELEE",

		"description": "Guerrero de honor Yakuza. Paraguas blindado, nudillos de titanio, katas y mirada paralizante.",

		"lore": "Hermano menor del clan. Entrena cada dia en el dojo.",

		"faction": "YAKUZA",

		"elite": false,

		"req_level": 1,

		"reputation": "",

		"primary_weapon": "Paraguas Blindado",

		"secondary_weapon": "Nudillos de Titanio",

		"primary_stat": "STR",

		"base_hp": 120,

		"base_stamina": 55,

		"hp_per_level": 11,

		"stamina_per_level": 3,

		"str_mod": 1.2,

		"dex_mod": 1.1,

		"con_mod": 1.1,

		"int_mod": 0.8,

		"wis_mod": 1.1,

		"cha_mod": 0.8,

		"icon_path": "",

		"skills": [

			{"skill_name": "Kata de Ataque", "skill_id": "shatei_kata", "description": "3 golpes. Cada uno +10% danio.", "hotbar_slot": 1, "cooldown": 4.0, "stamina_cost": 12, "damage_multiplier": 0.8, "unlock_level": 1, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 0.0},

			{"skill_name": "Agarre de Hierro", "skill_id": "shatei_agarre", "description": "Inmoviliza 3s con danio.", "hotbar_slot": 2, "cooldown": 10.0, "stamina_cost": 15, "damage_multiplier": 0.5, "unlock_level": 3, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 3.0},

			{"skill_name": "Mirada Paralizante", "skill_id": "shatei_mirada", "description": "Congela enemigo 2s.", "hotbar_slot": 3, "cooldown": 16.0, "stamina_cost": 10, "damage_multiplier": 0.0, "unlock_level": 5, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 2.0},

			{"skill_name": "Paraguas Defensivo", "skill_id": "shatei_paraguas", "description": "Bloquea 80% danio frontal 6s.", "hotbar_slot": 4, "cooldown": 20.0, "stamina_cost": 20, "damage_multiplier": 0.0, "unlock_level": 4, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 0.0, "duration": 6.0},

			{"skill_name": "Castigo del Clan", "skill_id": "shatei_castigo", "description": "+300% danio a inmovilizados. Aturde 3s.", "hotbar_slot": 5, "cooldown": 30.0, "stamina_cost": 25, "damage_multiplier": 4.0, "unlock_level": 10, "max_rank": 5, "tree_branch": "", "is_ultimate": true, "is_targeted": true, "area_radius": 0.0, "duration": 3.0},

			{"skill_name": "Disciplina (Pasiva A)", "skill_id": "shatei_disciplina", "description": "+15% danio 4s tras esquivar.", "hotbar_slot": -1, "tree_branch": "A", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Yakuzero (Pasiva B)", "skill_id": "shatei_yakuzero", "description": "+20% duracion efectos de control.", "hotbar_slot": -1, "tree_branch": "B", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Lealtad (Pasiva C)", "skill_id": "shatei_lealtad", "description": "-15% danio de enemigos que atacaron a aliado Yakuza.", "hotbar_slot": -1, "tree_branch": "C", "unlock_level": 2, "max_rank": 5}

		]

	})



	_classes["fletero"] = _create_class({

		"class_name_str": "Fletero",

		"class_id": "fletero",

		"class_tag": "FLE",

		"role": "RANGED",

		"description": "Soldado pesado del Cartel. AK-47 dorada, rafagas, intimidacion. Plata o plomo.",

		"lore": "Su AK-47 banada en oro es una extension de su cuerpo.",

		"faction": "CARTEL",

		"elite": false,

		"req_level": 1,

		"reputation": "",

		"primary_weapon": "AK-47 Dorada",

		"secondary_weapon": "Machete",

		"primary_stat": "STR",

		"base_hp": 115,

		"base_stamina": 50,

		"hp_per_level": 10,

		"stamina_per_level": 3,

		"str_mod": 1.3,

		"dex_mod": 1.1,

		"con_mod": 1.0,

		"int_mod": 0.7,

		"wis_mod": 0.8,

		"cha_mod": 1.2,

		"icon_path": "",

		"skills": [

			{"skill_name": "Rafaga de Plomo", "skill_id": "fletero_rafaga", "description": "8 balas en 2s. Dispersion moderada.", "hotbar_slot": 1, "cooldown": 8.0, "stamina_cost": 18, "damage_multiplier": 0.7, "unlock_level": 1, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 2.0},

			{"skill_name": "Machetazo", "skill_id": "fletero_machetazo", "description": "Sangrado: 3% HP/s 5s.", "hotbar_slot": 2, "cooldown": 5.0, "stamina_cost": 10, "damage_multiplier": 1.5, "unlock_level": 2, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 5.0},

			{"skill_name": "Intimidacion", "skill_id": "fletero_intimidacion", "description": "Enemigos 10m: -20% vel. ataque 6s.", "hotbar_slot": 3, "cooldown": 14.0, "stamina_cost": 10, "damage_multiplier": 0.0, "unlock_level": 4, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 10.0, "duration": 6.0},

			{"skill_name": "Fuego de Supresion", "skill_id": "fletero_fuego_supresion", "description": "Vacia cargador. Enemigos no pueden avanzar 4s.", "hotbar_slot": 4, "cooldown": 18.0, "stamina_cost": 25, "damage_multiplier": 0.3, "unlock_level": 6, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 5.0, "duration": 4.0},

			{"skill_name": "Plata o Plomo", "skill_id": "fletero_plata_plomo", "description": "Marca enemigo. Si muere en 10s: doble dinero. Si no: +50% danio.", "hotbar_slot": 5, "cooldown": 45.0, "stamina_cost": 20, "damage_multiplier": 1.5, "unlock_level": 10, "max_rank": 5, "tree_branch": "", "is_ultimate": true, "is_targeted": true, "area_radius": 0.0, "duration": 10.0},

			{"skill_name": "Punteria Cartel (Pasiva A)", "skill_id": "fletero_punteria", "description": "+15% danio fusiles de asalto.", "hotbar_slot": -1, "tree_branch": "A", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Cobrador (Pasiva B)", "skill_id": "fletero_cobrador", "description": "+30% dinero de enemigos eliminados.", "hotbar_slot": -1, "tree_branch": "B", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Soldado Leal (Pasiva C)", "skill_id": "fletero_soldado_leal", "description": "+10% danio por aliado Cartel cercano (max +30%).", "hotbar_slot": -1, "tree_branch": "C", "unlock_level": 2, "max_rank": 5}

		]

	})



	_classes["consigliere"] = _create_class({

		"class_name_str": "Consigliere",

		"class_id": "consigliere",

		"class_tag": "CON",

		"role": "SUPPORT",

		"description": "Consejero de la Mafia. Libro contable, laptop. Lavado de datos, sobornos, reduccion de wanted.",

		"lore": "Nunca carga un arma. Su poder esta en los numeros y contactos.",

		"faction": "MAFIA",

		"elite": false,

		"req_level": 1,

		"reputation": "",

		"primary_weapon": "Libro Contable",

		"secondary_weapon": "Laptop Encriptada",

		"primary_stat": "INT",

		"base_hp": 100,

		"base_stamina": 50,

		"hp_per_level": 8,

		"stamina_per_level": 3,

		"str_mod": 0.6,

		"dex_mod": 0.7,

		"con_mod": 0.9,

		"int_mod": 1.4,

		"wis_mod": 1.2,

		"cha_mod": 1.2,

		"icon_path": "",

		"skills": [

			{"skill_name": "Lavado de Datos", "skill_id": "consigliere_lavado", "description": "Reduce 1 estrella wanted. 2 min CD.", "hotbar_slot": 1, "cooldown": 120.0, "stamina_cost": 15, "damage_multiplier": 0.0, "unlock_level": 1, "max_rank": 3, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 0.0},

			{"skill_name": "Soborno", "skill_id": "consigliere_soborno", "description": "NPC enemigo lucha a tu favor 15s. Cuesta dinero.", "hotbar_slot": 2, "cooldown": 30.0, "stamina_cost": 20, "damage_multiplier": 0.0, "unlock_level": 4, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 15.0},

			{"skill_name": "Auditoria", "skill_id": "consigliere_auditoria", "description": "Enemigo analizado: +15% danio recibido 12s.", "hotbar_slot": 3, "cooldown": 10.0, "stamina_cost": 8, "damage_multiplier": 0.0, "unlock_level": 2, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 12.0},

			{"skill_name": "Proteccion de Datos", "skill_id": "consigliere_proteccion", "description": "Aliado invisible en mapa y sistemas 20s.", "hotbar_slot": 4, "cooldown": 25.0, "stamina_cost": 15, "damage_multiplier": 0.0, "unlock_level": 6, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 20.0},

			{"skill_name": "Omerta", "skill_id": "consigliere_omerta", "description": "Aliados 25m no pueden ser delatados 15s. NPCs ignoran crimenes.", "hotbar_slot": 5, "cooldown": 90.0, "stamina_cost": 30, "damage_multiplier": 0.0, "unlock_level": 12, "max_rank": 3, "tree_branch": "", "is_ultimate": true, "is_targeted": false, "area_radius": 25.0, "duration": 15.0},

			{"skill_name": "Contable (Pasiva A)", "skill_id": "consigliere_contable", "description": "+20% dinero transacciones.", "hotbar_slot": -1, "tree_branch": "A", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Abogado (Pasiva B)", "skill_id": "consigliere_abogado", "description": "-30% tiempo carcel aliados.", "hotbar_slot": -1, "tree_branch": "B", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Consejero (Pasiva C)", "skill_id": "consigliere_consejero", "description": "+15% EXP para la crew.", "hotbar_slot": -1, "tree_branch": "C", "unlock_level": 2, "max_rank": 5}

		]

	})



	_classes["swat"] = _create_class({

		"class_name_str": "SWAT",

		"class_id": "swat",

		"class_tag": "SWT",

		"role": "TANK",

		"description": "Policia de elite tactico. Escopeta, escudo balistico, formaciones y brechas.",

		"lore": "Entrenado en operaciones especiales. Su escudo detiene cualquier cosa.",

		"faction": "POLICIA",

		"elite": false,

		"req_level": 1,

		"reputation": "",

		"primary_weapon": "Escopeta",

		"secondary_weapon": "Escudo Balistico",

		"primary_stat": "CON",

		"base_hp": 140,

		"base_stamina": 50,

		"hp_per_level": 14,

		"stamina_per_level": 3,

		"str_mod": 1.1,

		"dex_mod": 0.8,

		"con_mod": 1.3,

		"int_mod": 0.9,

		"wis_mod": 1.0,

		"cha_mod": 0.9,

		"icon_path": "",

		"skills": [

			{"skill_name": "Formacion", "skill_id": "swat_formacion", "description": "Aliados detras -30% danio.", "hotbar_slot": 1, "cooldown": 5.0, "stamina_cost": 15, "damage_multiplier": 0.0, "unlock_level": 1, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 5.0, "duration": 0.0},

			{"skill_name": "Granada Flash", "skill_id": "swat_granada_flash", "description": "Ciega en cono frontal 4s.", "hotbar_slot": 2, "cooldown": 15.0, "stamina_cost": 10, "damage_multiplier": 0.0, "unlock_level": 3, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 6.0, "duration": 4.0},

			{"skill_name": "Escudo Balistico", "skill_id": "swat_escudo", "description": "Bloquea 90% danio frontal.", "hotbar_slot": 3, "cooldown": 10.0, "stamina_cost": 20, "damage_multiplier": 0.0, "unlock_level": 2, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 0.0, "duration": 0.0},

			{"skill_name": "Brecha", "skill_id": "swat_brecha", "description": "Carga 8m. Stun 1s.", "hotbar_slot": 4, "cooldown": 12.0, "stamina_cost": 18, "damage_multiplier": 0.5, "unlock_level": 5, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 0.0, "duration": 1.0},

			{"skill_name": "Zona Segura", "skill_id": "swat_zona_segura", "description": "Area 15m: aliados inmunes a criticos 12s.", "hotbar_slot": 5, "cooldown": 40.0, "stamina_cost": 30, "damage_multiplier": 0.0, "unlock_level": 10, "max_rank": 5, "tree_branch": "", "is_ultimate": true, "is_targeted": false, "area_radius": 15.0, "duration": 12.0},

			{"skill_name": "Fortaleza (Pasiva A)", "skill_id": "swat_fortaleza", "description": "Mayor duracion/resistencia escudo.", "hotbar_slot": -1, "tree_branch": "A", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Comandante (Pasiva B)", "skill_id": "swat_comandante", "description": "Buffs area +2 aliados.", "hotbar_slot": -1, "tree_branch": "B", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Breacher (Pasiva C)", "skill_id": "swat_breacher", "description": "+30% danio explosivos tacticos.", "hotbar_slot": -1, "tree_branch": "C", "unlock_level": 2, "max_rank": 5}

		]

	})



	_classes["graffitero"] = _create_class({

		"class_name_str": "Graffitero",

		"class_id": "graffitero",

		"class_tag": "GRF",

		"role": "CONTROL",

		"description": "Artista callejero Cholo. Sprays, bombas de color, cegamiento y suelo resbaladizo.",

		"lore": "El barrio es su lienzo. Cada graffiti es un mensaje.",

		"faction": "CHOLOS",

		"elite": false,

		"req_level": 1,

		"reputation": "",

		"primary_weapon": "Spray Cans",

		"secondary_weapon": "Navaja",

		"primary_stat": "DEX",

		"base_hp": 105,

		"base_stamina": 60,

		"hp_per_level": 9,

		"stamina_per_level": 4,

		"str_mod": 0.8,

		"dex_mod": 1.3,

		"con_mod": 0.9,

		"int_mod": 1.0,

		"wis_mod": 1.0,

		"cha_mod": 1.1,

		"icon_path": "",

		"skills": [

			{"skill_name": "Bomba de Pintura", "skill_id": "graffitero_bomba_pintura", "description": "Explota en area 5m. Ciega 3s y pinta (visible en mapa).", "hotbar_slot": 1, "cooldown": 10.0, "stamina_cost": 12, "damage_multiplier": 0.2, "unlock_level": 1, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 5.0, "duration": 3.0},

			{"skill_name": "Suelo Resbaladizo", "skill_id": "graffitero_suelo_resbaladizo", "description": "Area 6m. Enemigos resbalan. 10s.", "hotbar_slot": 2, "cooldown": 14.0, "stamina_cost": 15, "damage_multiplier": 0.0, "unlock_level": 3, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 6.0, "duration": 10.0},

			{"skill_name": "Cegadora", "skill_id": "graffitero_cegadora", "description": "Spray a la cara. Cegado 4s.", "hotbar_slot": 3, "cooldown": 8.0, "stamina_cost": 8, "damage_multiplier": 0.0, "unlock_level": 2, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 4.0},

			{"skill_name": "Navajazo", "skill_id": "graffitero_navajazo", "description": "Contra cegados: +100% danio y sangrado.", "hotbar_slot": 4, "cooldown": 5.0, "stamina_cost": 10, "damage_multiplier": 1.0, "unlock_level": 4, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 0.0},

			{"skill_name": "Obra Maestra", "skill_id": "graffitero_obra_maestra", "description": "Mural 8m. Enemigos: -30% vel. No pueden usar habilidades 8s.", "hotbar_slot": 5, "cooldown": 40.0, "stamina_cost": 30, "damage_multiplier": 0.0, "unlock_level": 10, "max_rank": 5, "tree_branch": "", "is_ultimate": true, "is_targeted": false, "area_radius": 8.0, "duration": 8.0},

			{"skill_name": "Artista (Pasiva A)", "skill_id": "graffitero_artista", "description": "+20% duracion efectos pintura.", "hotbar_slot": -1, "tree_branch": "A", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Vandalismo (Pasiva B)", "skill_id": "graffitero_vandalismo", "description": "+25% radio bombas y suelo resbaladizo.", "hotbar_slot": -1, "tree_branch": "B", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Represento (Pasiva C)", "skill_id": "graffitero_represento", "description": "Enemigos pintados +15% danio de Cholos.", "hotbar_slot": -1, "tree_branch": "C", "unlock_level": 2, "max_rank": 5}

		]

	})



	_classes["mercenario"] = _create_class({

		"class_name_str": "Mercenario",

		"class_id": "mercenario",

		"class_tag": "MER",

		"role": "HYBRID",

		"description": "Sin lealtades. Usa cualquier arma. Roba 1 habilidad de otra clase (-30% eficiencia).",

		"lore": "No tiene bandera, solo tarifa. Su unica regla es sobrevivir.",

		"faction": "SINLEGAJA",

		"elite": false,

		"req_level": 1,

		"reputation": "",

		"primary_weapon": "Cualquier Arma",

		"secondary_weapon": "Cualquier Arma",

		"primary_stat": "STR",

		"base_hp": 110,

		"base_stamina": 55,

		"hp_per_level": 9,

		"stamina_per_level": 3,

		"str_mod": 1.1,

		"dex_mod": 1.1,

		"con_mod": 1.1,

		"int_mod": 1.0,

		"wis_mod": 1.0,

		"cha_mod": 1.0,

		"icon_path": "",

		"skills": [

			{"skill_name": "Disparo Versatil", "skill_id": "mercenario_disparo", "description": "+10% danio con cualquier arma.", "hotbar_slot": 1, "cooldown": 4.0, "stamina_cost": 10, "damage_multiplier": 1.1, "unlock_level": 1, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 0.0},

			{"skill_name": "Golpe Improvisado", "skill_id": "mercenario_golpe_improvisado", "description": "Aturde 1s si golpeas por la espalda.", "hotbar_slot": 2, "cooldown": 6.0, "stamina_cost": 8, "damage_multiplier": 0.8, "unlock_level": 2, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 1.0},

			{"skill_name": "Robo de Habilidad", "skill_id": "mercenario_robo_habilidad", "description": "Copia ultima habilidad enemiga/aliada (-30%).", "hotbar_slot": 3, "cooldown": 25.0, "stamina_cost": 20, "damage_multiplier": 0.7, "unlock_level": 5, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 0.0},

			{"skill_name": "Instinto de Supervivencia", "skill_id": "mercenario_instinto", "description": "Sobrevives con 1 HP +50% vel 3s. 3 min CD.", "hotbar_slot": 4, "cooldown": 180.0, "stamina_cost": 0, "damage_multiplier": 0.0, "unlock_level": 8, "max_rank": 3, "tree_branch": "", "is_ultimate": true, "is_targeted": false, "area_radius": 0.0, "duration": 3.0},

			{"skill_name": "Adaptabilidad", "skill_id": "mercenario_adaptabilidad", "description": "Resetea CD Robo. Siguiente Robo sin penalizacion.", "hotbar_slot": 5, "cooldown": 60.0, "stamina_cost": 25, "damage_multiplier": 0.0, "unlock_level": 10, "max_rank": 3, "tree_branch": "", "is_ultimate": true, "is_targeted": false, "area_radius": 0.0, "duration": 0.0},

			{"skill_name": "Superviviente (Pasiva A)", "skill_id": "mercenario_superviviente", "description": "+15% HP. +10% resistencia a todo danio.", "hotbar_slot": -1, "tree_branch": "A", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Aprendiz (Pasiva B)", "skill_id": "mercenario_aprendiz", "description": "Reduce penalizacion Robo en 10%.", "hotbar_slot": -1, "tree_branch": "B", "unlock_level": 2, "max_rank": 5},

			{"skill_name": "Sin Bandera (Pasiva C)", "skill_id": "mercenario_sin_bandera", "description": "+10% danio contra todas las facciones.", "hotbar_slot": -1, "tree_branch": "C", "unlock_level": 2, "max_rank": 5}

		]

	})





	# ============================================================

	# CLASES ELITE (6) - Nivel 50 + Faccion Reverenciado

	# ============================================================



	_classes["oyabun"] = _create_class({

		"class_name_str": "Oyabun",

		"class_id": "oyabun",

		"class_tag": "OYB",

		"role": "TANK",

		"description": "El Patriarca Yakuza. Su mirada congela enemigos en 20m. Honor y poder absoluto.",

		"lore": "Ha dirigido el clan por decadas. Cuando el Oyabun habla, todos escuchan.",

		"faction": "YAKUZA",

		"elite": true,

		"req_level": 50,

		"reputation": "REVERED",

		"primary_weapon": "Katana Ceremonial",

		"secondary_weapon": "Abanico de Guerra",

		"primary_stat": "CON",

		"base_hp": 200,

		"base_stamina": 80,

		"hp_per_level": 20,

		"stamina_per_level": 5,

		"str_mod": 1.2,

		"dex_mod": 1.0,

		"con_mod": 1.5,

		"int_mod": 1.1,

		"wis_mod": 1.2,

		"cha_mod": 1.3,

		"icon_path": "",

		"skills": [

			{"skill_name": "Mirada del Patriarca", "skill_id": "oyabun_mirada_patriarca", "description": "Congela enemigos 20m por 3s. Habilidad signature.", "hotbar_slot": 5, "cooldown": 60.0, "stamina_cost": 40, "damage_multiplier": 0.0, "unlock_level": 50, "max_rank": 3, "tree_branch": "", "is_ultimate": true, "is_targeted": false, "area_radius": 20.0, "duration": 3.0},

			{"skill_name": "Voz del Patriarca", "skill_id": "oyabun_voz", "description": "Aliados 30m: +30% danio, +20% defensa 12s.", "hotbar_slot": 4, "cooldown": 35.0, "stamina_cost": 30, "damage_multiplier": 0.0, "unlock_level": 50, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 30.0, "duration": 12.0},

			{"skill_name": "Honor del Clan (Elite A)", "skill_id": "oyabun_honor_clan", "description": "+20% stats base con aliados Yakuza en 15m.", "hotbar_slot": -1, "tree_branch": "A", "unlock_level": 50, "max_rank": 5},

			{"skill_name": "Legado (Elite B)", "skill_id": "oyabun_legado", "description": "Al morir: aliados Yakuza 50m +50% HP e invulnerables 5s.", "hotbar_slot": -1, "tree_branch": "B", "unlock_level": 50, "max_rank": 3},

			{"skill_name": "Sabiduria Ancestral (Elite C)", "skill_id": "oyabun_sabiduria", "description": "-20% CD en todas las habilidades.", "hotbar_slot": -1, "tree_branch": "C", "unlock_level": 50, "max_rank": 5}

		]

	})



	_classes["el_patron"] = _create_class({

		"class_name_str": "El Patron",

		"class_id": "el_patron",

		"class_tag": "PAT",

		"role": "TANK",

		"description": "Jefe maximo del Cartel. Plata o Plomo: soborna NPC o ejecuta jugador <20% HP.",

		"lore": "Nadie sabe su nombre real. Construyo un imperio desde la nada.",

		"faction": "CARTEL",

		"elite": true,

		"req_level": 50,

		"reputation": "REVERED",

		"primary_weapon": "Escopeta de Oro",

		"secondary_weapon": "Fajo de Billetes",

		"primary_stat": "STR",

		"base_hp": 190,

		"base_stamina": 70,

		"hp_per_level": 18,

		"stamina_per_level": 4,

		"str_mod": 1.5,

		"dex_mod": 1.0,

		"con_mod": 1.3,

		"int_mod": 1.0,

		"wis_mod": 0.9,

		"cha_mod": 1.4,

		"icon_path": "",

		"skills": [

			{"skill_name": "Plata o Plomo", "skill_id": "el_patron_plata_plomo", "description": "Soborna NPC o ejecuta jugador <20% HP. Signature.", "hotbar_slot": 5, "cooldown": 90.0, "stamina_cost": 50, "damage_multiplier": 99.0, "unlock_level": 50, "max_rank": 3, "tree_branch": "", "is_ultimate": true, "is_targeted": true, "area_radius": 0.0, "duration": 20.0},

			{"skill_name": "Escolta Personal", "skill_id": "el_patron_escolta", "description": "Invoca 2 guardaespaldas Cartel armados 30s.", "hotbar_slot": 4, "cooldown": 60.0, "stamina_cost": 35, "damage_multiplier": 0.0, "unlock_level": 50, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 0.0, "duration": 30.0},

			{"skill_name": "Imperio (Elite A)", "skill_id": "el_patron_imperio", "description": "+25% dinero. NPCs caidos +50% botin.", "hotbar_slot": -1, "tree_branch": "A", "unlock_level": 50, "max_rank": 5},

			{"skill_name": "Temor (Elite B)", "skill_id": "el_patron_temor", "description": "Enemigos <30% HP cerca: -15% vel, -10% def.", "hotbar_slot": -1, "tree_branch": "B", "unlock_level": 50, "max_rank": 5},

			{"skill_name": "Respeto (Elite C)", "skill_id": "el_patron_respeto", "description": "+30% HP. Inmune a miedo/intimidacion.", "hotbar_slot": -1, "tree_branch": "C", "unlock_level": 50, "max_rank": 5}

		]

	})



	_classes["don"] = _create_class({

		"class_name_str": "Don",

		"class_id": "don",

		"class_tag": "DON",

		"role": "SUPPORT",

		"description": "El Padrino de la Mafia. Aliados bajo su proteccion son casi inmortales.",

		"lore": "Controla la ciudad desde las sombras.",

		"faction": "MAFIA",

		"elite": true,

		"req_level": 50,

		"reputation": "REVERED",

		"primary_weapon": "Baston de Mando",

		"secondary_weapon": "Anillo de Poder",

		"primary_stat": "CHA",

		"base_hp": 160,

		"base_stamina": 70,

		"hp_per_level": 15,

		"stamina_per_level": 4,

		"str_mod": 0.9,

		"dex_mod": 0.8,

		"con_mod": 1.2,

		"int_mod": 1.3,

		"wis_mod": 1.2,

		"cha_mod": 1.6,

		"icon_path": "",

		"skills": [

			{"skill_name": "Padrino", "skill_id": "don_padrino", "description": "Aliados 30m: +25% defensa, inmunes ejecucion 15s. Signature.", "hotbar_slot": 5, "cooldown": 75.0, "stamina_cost": 40, "damage_multiplier": 0.0, "unlock_level": 50, "max_rank": 3, "tree_branch": "", "is_ultimate": true, "is_targeted": false, "area_radius": 30.0, "duration": 15.0},

			{"skill_name": "Bendicion", "skill_id": "don_bendicion", "description": "Aliado +50% HP temporal, regen 5%/s 12s.", "hotbar_slot": 4, "cooldown": 30.0, "stamina_cost": 25, "damage_multiplier": 0.0, "unlock_level": 50, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 12.0},

			{"skill_name": "Familia (Elite A)", "skill_id": "don_familia", "description": "+20% efectividad apoyo. Aliados comparten 10% tu defensa.", "hotbar_slot": -1, "tree_branch": "A", "unlock_level": 50, "max_rank": 5},

			{"skill_name": "Intocable (Elite B)", "skill_id": "don_intocable", "description": "20% prob ignorar ataque entrante.", "hotbar_slot": -1, "tree_branch": "B", "unlock_level": 50, "max_rank": 3},

			{"skill_name": "Red de Contactos (Elite C)", "skill_id": "don_red_contactos", "description": "Invoca NPC Mafia cada 5 min sin costo.", "hotbar_slot": -1, "tree_branch": "C", "unlock_level": 50, "max_rank": 5}

		]

	})



	_classes["comisario"] = _create_class({

		"class_name_str": "Comisario",

		"class_id": "comisario",

		"class_tag": "COM",

		"role": "SUPPORT",

		"description": "Jefe de la Policia. Convierte enemigos en aliados con mordida. Limpia el historial de su gente.",

		"lore": "Sabe que todos tienen un precio. Su placa es escudo y arma.",

		"faction": "POLICIA",

		"elite": true,

		"req_level": 50,

		"reputation": "REVERED",

		"primary_weapon": "Placa de Oro",

		"secondary_weapon": "Pistola Reglamentaria",

		"primary_stat": "CHA",

		"base_hp": 170,

		"base_stamina": 65,

		"hp_per_level": 16,

		"stamina_per_level": 4,

		"str_mod": 1.0,

		"dex_mod": 0.9,

		"con_mod": 1.3,

		"int_mod": 1.1,

		"wis_mod": 1.1,

		"cha_mod": 1.5,

		"icon_path": "",

		"skills": [

			{"skill_name": "Mordida", "skill_id": "comisario_mordida", "description": "Convierte NPC en aliado. Reduce wanted aliados 2 estrellas. Signature.", "hotbar_slot": 5, "cooldown": 120.0, "stamina_cost": 50, "damage_multiplier": 0.0, "unlock_level": 50, "max_rank": 3, "tree_branch": "", "is_ultimate": true, "is_targeted": true, "area_radius": 0.0, "duration": 0.0},

			{"skill_name": "Codigo Azul", "skill_id": "comisario_codigo_azul", "description": "NPCs Policia en 40m se vuelven aliados 20s.", "hotbar_slot": 4, "cooldown": 90.0, "stamina_cost": 35, "damage_multiplier": 0.0, "unlock_level": 50, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 40.0, "duration": 20.0},

			{"skill_name": "Jurisdiccion (Elite A)", "skill_id": "comisario_jurisdiccion", "description": "NPCs Policia no te atacan. +30% danio vs NPCS criminales.", "hotbar_slot": -1, "tree_branch": "A", "unlock_level": 50, "max_rank": 5},

			{"skill_name": "Escolta Policial (Elite B)", "skill_id": "comisario_escolta", "description": "Siempre 1 oficial NPC protegiendote.", "hotbar_slot": -1, "tree_branch": "B", "unlock_level": 50, "max_rank": 3},

			{"skill_name": "Ley y Orden (Elite C)", "skill_id": "comisario_ley_orden", "description": "-50% tiempo reaparicion policia aliada. +20% HP aliados Policia.", "hotbar_slot": -1, "tree_branch": "C", "unlock_level": 50, "max_rank": 5}

		]

	})



	_classes["og"] = _create_class({

		"class_name_str": "OG",

		"class_id": "og",

		"class_tag": "OG",

		"role": "MELEE",

		"description": "Original Gangster. Leyenda viva del barrio. Invoca a sus OG Locos nivel 30.",

		"lore": "Sobrevivio a todo. Los chavos lo respetan, los enemigos lo temen.",

		"faction": "CHOLOS",

		"elite": true,

		"req_level": 50,

		"reputation": "REVERED",

		"primary_weapon": "Bate de Aluminio",

		"secondary_weapon": "Cadena de Plata",

		"primary_stat": "STR",

		"base_hp": 180,

		"base_stamina": 75,

		"hp_per_level": 17,

		"stamina_per_level": 4,

		"str_mod": 1.4,

		"dex_mod": 1.2,

		"con_mod": 1.2,

		"int_mod": 0.8,

		"wis_mod": 1.0,

		"cha_mod": 1.3,

		"icon_path": "",

		"skills": [

			{"skill_name": "Leyenda del Barrio", "skill_id": "og_leyenda_barrio", "description": "Invoca 2 NPCs Cholos nivel 30 por 30s. Signature.", "hotbar_slot": 5, "cooldown": 120.0, "stamina_cost": 45, "damage_multiplier": 0.0, "unlock_level": 50, "max_rank": 3, "tree_branch": "", "is_ultimate": true, "is_targeted": false, "area_radius": 0.0, "duration": 30.0},

			{"skill_name": "Respeto en la Calle", "skill_id": "og_respeto_calle", "description": "Grita. Enemigos 15m: -25% danio, -20% vel 8s.", "hotbar_slot": 4, "cooldown": 25.0, "stamina_cost": 20, "damage_multiplier": 0.0, "unlock_level": 50, "max_rank": 5, "tree_branch": "", "is_targeted": false, "area_radius": 15.0, "duration": 8.0},

			{"skill_name": "Veterano (Elite A)", "skill_id": "og_veterano", "description": "+25% HP. Invocaciones +50% HP.", "hotbar_slot": -1, "tree_branch": "A", "unlock_level": 50, "max_rank": 5},

			{"skill_name": "Hermandad (Elite B)", "skill_id": "og_hermandad", "description": "+20% danio por Cholo en 10m (max +60%).", "hotbar_slot": -1, "tree_branch": "B", "unlock_level": 50, "max_rank": 5},

			{"skill_name": "Calles Eternas (Elite C)", "skill_id": "og_calles_eternas", "description": "Al morir: buff permanente area. Cholos +15% danio 30m 2 min.", "hotbar_slot": -1, "tree_branch": "C", "unlock_level": 50, "max_rank": 1}

		]

	})



	_classes["fantasma"] = _create_class({

		"class_name_str": "Fantasma",

		"class_id": "fantasma",

		"class_tag": "FAN",

		"role": "HYBRID",

		"description": "Sin identidad. 30s invisibilidad total. Primer ataque x5 danio. Nadie lo ve venir.",

		"lore": "Dicen que nunca existio. Pero los cadaveres que deja son reales.",

		"faction": "SINLEGAJA",

		"elite": true,

		"req_level": 50,

		"reputation": "REVERED",

		"primary_weapon": "Cuchillo de Combate",

		"secondary_weapon": "Silenciador Artesanal",

		"primary_stat": "DEX",

		"base_hp": 130,

		"base_stamina": 80,

		"hp_per_level": 12,

		"stamina_per_level": 5,

		"str_mod": 1.0,

		"dex_mod": 1.6,

		"con_mod": 0.9,

		"int_mod": 1.1,

		"wis_mod": 1.2,

		"cha_mod": 0.7,

		"icon_path": "",

		"skills": [

			{"skill_name": "Nadie", "skill_id": "fantasma_nadie", "description": "30s invisibilidad total. 1er ataque x5 danio. Signature.", "hotbar_slot": 5, "cooldown": 180.0, "stamina_cost": 50, "damage_multiplier": 5.0, "unlock_level": 50, "max_rank": 3, "tree_branch": "", "is_ultimate": true, "is_targeted": false, "area_radius": 0.0, "duration": 30.0},

			{"skill_name": "Golpe Fantasma", "skill_id": "fantasma_golpe_fantasma", "description": "Ignora 50% armadura. En sigilo: x2 danio.", "hotbar_slot": 4, "cooldown": 12.0, "stamina_cost": 18, "damage_multiplier": 1.5, "unlock_level": 50, "max_rank": 5, "tree_branch": "", "is_targeted": true, "area_radius": 0.0, "duration": 0.0},

			{"skill_name": "Sin Rastro (Elite A)", "skill_id": "fantasma_sin_rastro", "description": "+10s invisibilidad. Sin huellas ni sonido.", "hotbar_slot": -1, "tree_branch": "A", "unlock_level": 50, "max_rank": 5},

			{"skill_name": "Letal (Elite B)", "skill_id": "fantasma_letal", "description": "+30% prob critico. +50% danio critico.", "hotbar_slot": -1, "tree_branch": "B", "unlock_level": 50, "max_rank": 5},

			{"skill_name": "Desvanecerse (Elite C)", "skill_id": "fantasma_desvanecerse", "description": "Al eliminar enemigo: +3s invisibilidad.", "hotbar_slot": -1, "tree_branch": "C", "unlock_level": 50, "max_rank": 5}

		]

	})



	print("ClassManager: %d clases cargadas." % _classes.size())





# ============================================================

# METODOS PUBLICOS

# ============================================================



func get_class_data(class_id: String) -> Resource:

	if _classes.has(class_id):

		return _classes[class_id]

	push_error("ClassManager: Clase no encontrada: ", class_id)

	return null





func get_all_classes() -> Array:

	var all: Array = []

	for key in _classes:

		all.append(_classes[key])

	return all





func get_all_class_ids() -> Array[String]:

	var ids: Array[String] = []

	for key in _classes:

		ids.append(key)

	return ids





func get_classes_by_role(role: String) -> Array:

	var filtered: Array = []

	for cd in _classes.values():

		if cd.role == role:

			filtered.append(cd)

	return filtered





func get_universal_classes() -> Array:

	var filtered: Array = []

	for cd in _classes.values():

		if cd.is_universal() and not cd.is_elite:

			filtered.append(cd)

	return filtered





func get_faction_classes(faction: String) -> Array:

	var filtered: Array = []

	var fup = faction.to_upper()

	for cd in _classes.values():

		if cd.faction_required.to_upper() == fup:

			filtered.append(cd)

	return filtered





func get_elite_classes() -> Array:

	var filtered: Array = []

	for cd in _classes.values():

		if cd.is_elite:

			filtered.append(cd)

	return filtered





func can_use_class(player_faction: String, class_id: String) -> bool:

	var cd = get_class_data(class_id)

	if cd == null:

		return false

	if cd.is_universal():

		return true

	if cd.faction_required != "":

		return player_faction.to_upper() == cd.faction_required.to_upper()

	return true





func get_class_stats(class_id: String, level: int) -> Dictionary:

	var cd = get_class_data(class_id)

	if cd == null:

		return {}

	return {

		"hp": cd.calculate_hp_at_level(level),

		"stamina": cd.calculate_stamina_at_level(level),

		"str_mod": cd.str_mod,

		"dex_mod": cd.dex_mod,

		"con_mod": cd.con_mod,

		"int_mod": cd.int_mod,

		"wis_mod": cd.wis_mod,

		"cha_mod": cd.cha_mod,

		"primary_stat": cd.primary_stat,

		"role": cd.role

	}





func unlock_skill(class_id: String, skill_id: String, rank: int) -> bool:

	if not _classes.has(class_id):

		return false

	var cd = _classes[class_id]

	for skill in cd.skills:

		if skill.skill_id == skill_id:

			skill.current_rank = min(rank + 1, skill.max_rank)

			return true

	return false





func has_class(class_id: String) -> bool:

	return _classes.has(class_id)





func class_count() -> int:

	return _classes.size()
