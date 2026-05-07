# BALA — Development Log
## LOG.md | Ultima actualizacion: Mayo 2026

---

## RESUMEN DE PROGRESO

| Categoria | Total Features | Implementado | Parcial | Pendiente |
|-----------|---------------|-------------|---------|-----------|
| Core Engine | 12 | 9 | 3 | 0 |
| Personaje | 15 | 8 | 4 | 3 |
| Combate | 18 | 10 | 5 | 3 |
| Mundo | 12 | 6 | 4 | 2 |
| UI/HUD | 14 | 10 | 2 | 2 |
| Enemigos/NPC | 10 | 5 | 3 | 2 |
| Skills/Habilidades | 10 | 7 | 2 | 1 |
| Progresion | 12 | 5 | 4 | 3 |
| Crews/Guilds | 8 | 0 | 0 | 8 |
| PVP | 10 | 0 | 0 | 10 |
| Economia | 12 | 2 | 2 | 8 |
| Social | 8 | 0 | 1 | 7 |
| Narrativa | 10 | 1 | 1 | 8 |
| Wanted/Ley | 8 | 0 | 1 | 7 |
| Visuales/Assets | 15 | 12 | 2 | 1 |
| **TOTAL** | **165** | **75** | **34** | **66** |

---

## ✅ IMPLEMENTADO (75 features)

### Core Engine
- [x] Godot Engine 4.6, 3D Low Poly
- [x] CharacterBody3D con move_and_slide()
- [x] Camara 3ra persona orbital + 1ra persona (toggle V)
- [x] Zoom con scroll suave
- [x] Mouse captura automatica (GTA5-style)
- [x] InputMap: WASD, sprint, jump, hotbar 1-5, interact F, inventory I
- [x] GameManager autoload (global.gd)
- [x] StatsManager autoload (stats.gd)
- [x] InventoryManager autoload (inventory.gd)

### Personaje
- [x] 6 stats: STR, DEX, CON, INT, WIS, CHA
- [x] HP + Stamina con formulas base
- [x] Movimiento WASD + sprint (Shift) + roll (doble tap)
- [x] Color de cuerpo por faccion
- [x] Spawn via WorldInitializer
- [x] Clase seleccionable (ClassManager + ClassStarter)
- [x] 14 clases base + 6 elite con datos
- [x] Skill points: +1 por nivel, se muestran en HUD

### Combate
- [x] Melee attack (click izquierdo, raycast frontal)
- [x] Ranged skills (proyectiles Area3D)
- [x] Area skills (radio de efecto)
- [x] Support skills (curacion)
- [x] Cooldowns por habilidad
- [x] Calculo de dano base + stat + skill multiplier
- [x] Proyectil system (projectile.tscn + projectile.gd)
- [x] Flash blanco en enemigos al recibir dano
- [x] Damage numbers flotantes (Label3D, 48px)
- [x] Skill feedback: nombre flotante con color por tipo

### Mundo
- [x] Test world: 200x200m con calles, edificios, postes
- [x] Luces omni (naranja, magenta, cyan) + directional
- [x] Collision en suelo (StaticBody3D + BoxShape3D 200x1x200)
- [x] Collision en edificios
- [x] Spawn points para enemigos (4) + NPCs (2)
- [x] Fog volumetrico + ambiente + clear color

### UI/HUD
- [x] HUD: vida (TextureProgressBar rojo)
- [x] HUD: stamina (TextureProgressBar amarillo)
- [x] HUD: XP bar (TextureProgressBar dorado, creado en codigo)
- [x] HUD: hotbar 10 slots con cooldowns
- [x] HUD: minimapa circular con textura
- [x] HUD: wanted stars con textura
- [x] HUD: emblema de faccion
- [x] HUD: crosshair GTA5-style (generado en codigo)
- [x] HUD: skill points display
- [x] Main menu: fondo + titulo graffiti + botones

### Enemigos/NPC
- [x] 4 tipos de enemigos con stats/colores distintos
- [x] Floating health bar (QuadMesh 3D + Label3D)
- [x] Barra cambia color: verde > amarillo > rojo
- [x] NPCs amistosos con dialogo (F key)
- [x] EnemySpawner: spawnea enemigos + NPCs

### Skills/Habilidades
- [x] Skill tree UI (K key): 3 ramas, 5 skills cada una
- [x] Desbloqueo con SP (verifica nivel, rango max, puntos)
- [x] Sincronizacion bidireccional StatsManager <-> SkillTree
- [x] 26 skill icons generados
- [x] Hotbar skills (1-5) con ejecucion por tipo
- [x] ClassManager.unlock_skill()
- [x] SkillData resource con todos los campos

### Progresion
- [x] XP system: add_xp, curvas, overflow entre niveles
- [x] Level up: +10 HP, +3 stamina, cura completa, +1 SP
- [x] XP por matar enemigos
- [x] Nivel mostrado en HUD
- [x] Flash verde al subir de nivel + texto "LEVEL UP!"

### Visuales/Assets
- [x] 5 tileable textures aplicadas (asphalt, concrete, brick, graffiti, metal)
- [x] 26 skill icons
- [x] 18 UI textures (cargadas programaticamente)
- [x] 9 fuentes TTF (PressStart2P, Playfair, Barlow, JetBrainsMono)
- [x] Shader low_poly_outline (toon + outline, Godot 4.6)
- [x] 30 concept art characters/NPCs/environments/weapons
- [x] Tema global (bslo_theme.tres)
- [x] 6 personajes faccion (concept art)
- [x] 6 entornos (concept art)
- [x] 6 NPCs (concept art)
- [x] 5 armas + 4 consumibles + 3 vehiculos (concept art)
- [x] Texturas aplicadas via codigo (no .tscn)

---

## 🟡 PARCIAL (34 features)

### Core Engine
- [~] Day/Night cycle - solo directional light estatico
- [~] Weather system - solo fog volumetrico
- [~] ClassManager - datos de 20 clases cargados, falta aplicar todos los modificadores

### Personaje
- [~] Facción - seleccionable pero no afecta quests/dialogos
- [~] Clase - asignable pero no todos los modificadores de stats activos
- [~] 6 stats - existen pero DEX/INT/WIS/CHA no tienen efectos mecanicos reales
- [~] Roll con i-frames - implementado pero sin invulnerabilidad real verificada

### Combate
- [~] Cover system - no implementado
- [~] Execution system (<10% HP) - no implementado
- [~] Tab-target - no implementado (solo raycast frontal)
- [~] Ranged manual aim bonus (+25%) - no implementado
- [~] Ammo system - no implementado

### Mundo
- [~] 120 distritos - solo test world de 200x200m
- [~] Metro fast-travel - no implementado
- [~] Vehiculos - no implementados
- [~] La Hora del Diablo - no implementada

### UI/HUD
- [~] Inventory grid 8x10 funcional pero usa ColorRect (no texturas de items)
- [~] Death screen existe pero no se activa automaticamente al morir

### Enemigos/NPC
- [~] Enemy AI - chase basico, sin patrol real ni flanking
- [~] NPC dialogue - habla pero sin DialogueBox UI conectada
- [~] Loot al morir - existe codigo pero no verificado

### Skills/Habilidades
- [~] 20 clases con 5 skills cada una = 100 skills - solo ~40 definidas en class_manager
- [~] Skill tree branches - UI funciona pero no muestra iconos de skills

### Progresion
- [~] XP curve completa - formula implementada pero no calibrada
- [~] Death penalty - no implementado (-15% XP + degradation)
- [~] Respawn system - no implementado
- [~] Level-unlock milestones - parcial (solo SP por nivel)

### Economia
- [~] PB currency - existe variable pero sin usos reales
- [~] Inventario con peso - parcialmente funcional

### Social
- [~] 3D positional chat - no implementado

### Narrativa
- [~] NPC dialogue lines - definidas pero no usadas en juego

### Wanted/Ley
- [~] Wanted stars UI - existe textura pero sin mecanica de acumulacion

### Visuales/Assets
- [~] Particle effects - scene creada (smoke_particles.tscn) pero no instanciada
- [~] Neon signs - existen meshes pero sin shader de glow animado

---

## ❌ PENDIENTE (66 features)

### Personaje (3)
- [ ] Character creation funnel (4 pasos)
- [ ] Body type affects hitbox
- [ ] Guided tutorial (7 stages, 10-12 min)

### Combate (3)
- [ ] Armas cuerpo a cuerpo (navaja, bate, cadena, puno americano)
- [ ] Armas de fuego (pistola, rifle, escopeta, sniper, SMG)
- [ ] Elemental/special resistances

### Skills (1)
- [ ] Elite classes desbloqueables (Oyabun, El Patron, Don, Comisario, OG, Mercenario)

### Mundo (2)
- [ ] Parque vehicular (moto, sedan, pickup, helicoptero)
- [ ] Vehicle mechanics (HP, gasolina, reparacion, robo)

### Progresion (3)
- [ ] Daily dungeon bonus (+100% XP first completion)
- [ ] Mentoria system (mentor +15% XP apprentice)
- [ ] Battle pass (seasonal, free + premium)

### Crews/Guilds (8)
- [ ] Crew creation (level 20, 5 founders, $500K)
- [ ] 5-rank hierarchy system
- [ ] Territory control (120 districts)
- [ ] Territory raid system (24h prep, 30min, 3 points)
- [ ] Dinero Sucio (crew resource)
- [ ] Graffiti territory system
- [ ] Weekly salary auto-distribution
- [ ] Crew diplomacy (Ally/Neutral/Enemy)

### PVP (10)
- [ ] PVP Server (triple death penalty)
- [ ] Hardcore Server (permadeath)
- [ ] Alley duel 1v1 (instanced, betting)
- [ ] Bounty system (player-placed)
- [ ] Free PVP zones (4)
- [ ] Safe zones (8)
- [ ] Novice Killer banner
- [ ] Insult auto-duel
- [ ] Revenge system (blacklist, 24h XP recovery)
- [ ] Moderation system

### Economia (8)
- [ ] Dual currency (PB + MP premium)
- [ ] Legal market shops (6 types)
- [ ] Black market (hidden, rotating)
- [ ] Server auction (Sundays, 15% commission)
- [ ] Crafting stations (6 types)
- [ ] Item quality system (6 tiers)
- [ ] Property system (4 types: safe house, negocio, bodega, penthouse)
- [ ] Premium shop (5 product types)

### Social (7)
- [ ] Pareja/Couple system
- [ ] Mentoria/Mentorship system
- [ ] Crew voice chat
- [ ] Cultural emotes (5 por faccion)
- [ ] 3D positional voice chat
- [ ] Multi-channel chat (/grito, /barrio, /crew, /radio)
- [ ] Chat channels

### Narrativa (8)
- [ ] 5 faction main quest chains (30 quests each = 150)
- [ ] 100+ procedural side quests
- [ ] Narrative bounties with micro-stories
- [ ] 4 lore mysteries (Mayor, Firulais, Line 5, Hack 98)
- [ ] Radio vehicle parody songs
- [ ] Memorable NPCs (7+)
- [ ] Cinematic/game/internet meme references
- [ ] Annual festivals + weekly events

### Wanted/Ley (7)
- [ ] Wanted point accumulation system
- [ ] Wanted acceleration multipliers
- [ ] 5 star levels with escalating response
- [ ] Police NPC/player integration
- [ ] Wanted decrease methods (safe house, bribe, look change)
- [ ] Zona Caliente debuff (3 stars)
- [ ] Server-wide announcement (5 stars)

---

## PROXIMOS PASOS (Orden de prioridad)

1. **Death system** - Activar death screen al morir, respawn en hospital/spawn point
2. **Cover system** - Space cerca de objetos = cobertura (-75% dano)
3. **Ammo system** - Balas como recurso, recarga manual
4. **Wanted system basico** - Acumular estrellas al atacar NPCs/civiles
5. **Inventory con texturas** - Mostrar items generados en el grid
6. **DialogueBox conectada** - Mostrar dialogos de NPCs con UI apropiada
7. **Particle effects** - Instanciar smoke_particles en techos
8. **Mas enemigos** - Aumentar spawn points y variedad
9. **Day/Night cycle** - Rotar directional light + cambiar fog
10. **Minimap funcional** - Mostrar posicion del jugador y enemigos cercanos

---

## NOTAS TECNICAS

- **Encoding:** Todos los .gd son UTF-8 sin BOM. Usar solo tabs para indentacion.
- **Texturas:** Cargar con `load()` en scripts, NO en .tscn (Godot las borra al regenerar)
- **Edit tool:** Introduce espacios. Siempre correr `python fix_tabs.py` despues de editar.
- **API Key OpenRouter:** ~$15.50 gastado de $20. ~$4.50 restante para mas iconos.
- **Godot 4.6:** Shader usa `TEXTURE` (no `ALBEDO_TEXTURE`). `shading_mode` (no `flags_unshaded`).
