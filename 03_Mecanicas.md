# BARRIO SIN LEY ONLINE (BSLO)
## 03 — Mecánicas de Juego y Sistemas Core
**Versión:** 2.0 | **Género:** MMO Action-RPG de Mundo Abierto

---

## 1. FILOSOFÍA DE DISEÑO MECÁNICO

BSLO no es un simulador de crimen realista. Es un **MMORPG tradicional** (hotbar, levels, raids, loot, crafting, guilds) que usa la piel de un mundo criminal urbano.

> **Regla de Oro:** *"Si funciona en World of Warcraft, funciona aquí. Solo que en vez de un Paladín con espada brillante, es un Narco con una AK dorada y chanclas."*

---

## 2. PROGRESIÓN DE PERSONAJE

### Niveles y Rangos (Level Cap: 60)
| Niveles | Rango | Descripción |
|---------|-------|-------------|
| 1-15 | Chivato / Tirapiedras | Aprendiz de criminal. Nadie te conoce. |
| 16-30 | Soldado / Matón | Pieza funcional de la organización. |
| 31-45 | Capitán / Sicario | Mando medio. Apareces en el mapa para otros jugadores. |
| 46-60 | Jefe / Oyabun / Comisario | Elite del servidor. Todos te buscan. |

### Stats Principales
| Stat | Nombre Callejero | Qué Afecta |
|------|-------------------|------------|
| **STR** | Fuerza Bruta | Daño cuerpo a cuerpo. Capacidad de carga en inventario. |
| **DEX** | Dedos Ligeros | Velocidad de recarga, precisión, crítico, pickpocket. |
| **CON** | Hígado de Acero | HP total, resistencia a drogas/venenos, duración de res sickness. |
| **INT** | Astucia | Daño con explosivos, hacks, eficiencia en crafting. |
| **WIS** | Calle | Detección de mentiras, rutas secretas, resistencia a sobornos. |
| **CHA** | Labia | Precios en mercado, chance de soborno, buffs de área para crew. |

**Stats bonus por facción:** Cada facción otorga +5% a un stat específico (ver 04_Facciones.md).

---

## 3. COMBATE: SISTEMA HÍBRIDO TAB-TARGET + ACTION

Ambos modos coexisten simultáneamente. El jugador puede usar tab-target para seleccionar enemigos y lanzar habilidades, PERO si apunta manualmente y el proyectil/ataque impacta, hace daño adicional por "puntería".

### Combate a Distancia
- **Tab-target:** Seleccionás enemigo (Tab), usás habilidades (1-0). El daño se calcula con stats + gear.
- **Action bonus:** Si además apuntás al punto débil (cabeza, pecho), +25% daño. No es obligatorio, es recompensa por skill.
- **Munición:** Recurso físico en inventario. Recarga manual con animación de 2 segundos (vulnerable).
- **Cover system:** Presionar [Espacio] cerca de paredes/objetos. -75% daño frontal. No podés usar armas largas en cobertura.

### Combate Cuerpo a Cuerpo
- Combos de 3 golpes básicos (click izquierdo) + habilidad especial.
- Armas: Navaja (rápido), Bate (lento, stun), Cadena (DPS, overheat), Puño Americano (críticos sigilosos).
- **Ejecuciones:** Enemigo <10% vida → prompt [F]. Animación breve. Buff de moral a aliados cercanos (+10% daño por 30s).

### Cover System
- Cobertura automática al pegarse a objetos sólidos.
- En cobertura: -75% daño frontal, no armas largas, posibilidad de blind fire (-90% precisión).

---

## 4. SISTEMA DE WANTED (1-5 ESTRELLAS)

| ⭐ | Nombre | Efecto |
|---|--------|--------|
| ⭐ | Mirada Sospechosa | NPCs policiales te siguen con la vista. |
| ⭐⭐ | Patrullaje Agresivo | Policías te piden documentos. Posibilidad de escape o soborno. |
| ⭐⭐⭐ | Operativo de Barrio | SWAT spawn. Todos en 200m reciben debuff "Zona Caliente" (-20% ventas). |
| ⭐⭐⭐⭐ | Estado de Sitio | Helicópteros, barricadas. Jugadores policía pueden unirse a la cacería. |
| ⭐⭐⭐⭐⭐ | Mano Dura Total | Tanque policial rompe paredes. Si morís, perdés TODO el inventario no-equipado. Criminales ganan +50% XP por sobrevivir. |

### Cómo Subir Wanted
- Matar jugadores en zona no-PVP.
- Matar NPCs civiles.
- Ser detectado con drogas o armas ilegales.
- Robar vehículos frente a testigos.
- Atacar policías.

### Cómo Bajar Wanted
- **Safe House:** -1 estrella cada 5 minutos reales.
- **Soborno:** Pagar a jugador policía o NPC corrupto.
- **Cambio de Look:** Peluquería/ropa. -1 estrella instantánea (cooldown 1h).

---

## 5. SISTEMA DE MUERTE Y PENALIZACIÓN

BSLO usa un sistema de **triple penalización**:

### 5.1 Pérdida de Experiencia (-15%)
- Al morir, perdés el 15% de la XP acumulada en tu nivel actual.
- **Podés bajar de nivel.** Si estás a 5% del nivel y morís, volvés al nivel anterior.
- Estilo "vieja escuela" (Tibia, Ragnarok, EverQuest).

### 5.2 Degradación de Equipo
- Armas y armaduras pierden **durabilidad** al morir.
- Si la durabilidad llega a 0, el ítem se rompe y no puede equiparse hasta repararlo.
- Reparar cuesta moneda del juego en talleres mecánicos o armerías.
- **Gold sink primario del juego.**

### 5.3 Res Sickness (Debilidad Temporal)
- Tras resucitar, todas las stats se reducen -30% durante 5 minutos.
- El debuff es visible en el personaje (animación de dolor, sprite pálido).
- Evita el "zerging" (lanzarse suicidamente contra un boss una y otra vez).
- En safe houses, la duración se reduce a 2 minutos.

### Modos de Muerte Adicionales
- **Muerte por Wanted 5⭐:** Penalización normal + pérdida de TODO el inventario no-equipado.
- **Muerte en servidor Hardcore:** Personaje borrado permanentemente. (Ver 09_PVP.md).

---

## 6. CICLO DÍA/NOCHE Y CLIMA

### Ciclo Diario (4 horas reales = 1 día completo)
| Fase | Hora (in-game) | Efectos |
|------|---------------|---------|
| **Mañana** | 06:00-12:00 | Tiendas abiertas, NPCs activos, misiones legales disponibles. Policía +20% patrullaje. |
| **Tarde** | 12:00-18:00 | Tráfico pesado, eventos sociales en plazas, mercado peak. |
| **Noche** | 18:00-00:00 | Luces neón encienden. Brecha de seguridad policial. Mercado negro abre. |
| **Madrugada** | 00:00-06:00 | **La Hora del Diablo** (2:00-4:00). Eventos raros, bosses ocultos, PVP no anunciado, precios del mercado negro -30%. |

### Clima
| Clima | Efecto en Gameplay |
|-------|-------------------|
| **Soleado** | Visibilidad normal. Policía +20%. |
| **Lluvia** | Movimiento -10%. Coches patinan. Sonido amortiguado. |
| **Niebla** | Visibilidad -50%. Sigilo +30%. |
| **Neón** (nocturno) | Cielo magenta/cian. +10% daño de habilidades especiales. |
| **Tierra Roja** (solo sector Cártel) | Viento con polvo. -20% precisión a distancia. +10% daño cuerpo a cuerpo. |

---

## 7. TRANSPORTE Y MOVIMIENTO

### A Pie
- Sprint limitado por stamina.
- Doble-tap direccional = roll con i-frames.
- Parkour simplificado: saltar vallas, ventanas, tejados.

### Vehículos
| Tipo | Capacidad | Baúl | Notas |
|------|-----------|------|-------|
| Moto 125cc | 1 pasajero | 2x3 | Rápida, acceso a callejones estrechos |
| Auto Sedán | 4 pasajeros | 6x6 | Robable, tuneable |
| Camioneta | 6 pasajeros | 8x8 | Cobertura móvil, lenta |
| Metro | Ilimitado | - | Fast-travel entre estaciones |
| Helicóptero | 2 pasajeros | 4x4 | Solo nivel 50+, acceso a tejados |

- Vehículos tienen HP, gasolina y necesitan reparación.
- Si un vehículo explota, el loot del baúl cae al suelo (free-for-all).
- **Robo de vehículos:** Mini-juego de lockpick. Más fácil para facción Cártel (+% manejo).

---

## 8. KARMA Y REPUTACIÓN

### Karma de Barrio (-1000 a +1000)
| Rango | Efectos |
|-------|---------|
| **Criminal (-1000 a -300)** | +15% daño, acceso a mercado negro, NPCs temerosos. |
| **Neutral (-299 a +299)** | +20% oro de quests, equilibrio. |
| **Vigilante (+300 a +1000)** | -50% precios legales, gear táctico, safe zones extendidas. |

### Reputación por Facción (Independiente)
Cada una de las 6 facciones mide tu reputación por separado:
- **Odiado:** Atacado a vista por NPCs de esa facción.
- **Despreciado:** Precios +100%.
- **Neutral:** Default.
- **Respetado:** Descuentos, quests exclusivas.
- **Reverenciado:** Acceso a clase élite, gear legendario.
- **Temido/Legendario:** Título server-wide.

---

## 9. EMOTES Y COMUNICACIÓN

### Emotes Culturales
- **La Jordan:** Cruzar brazos (Yakuza).
- **El Corrido Tumbado:** Tirarse al suelo con sombrero (Cártel).
- **El Gestual Italiano:** Hablar con las manos 10s (Mafia).
- **Silbato Policial:** Tocar silbato (Policía).
- **El Pasito:** Bailar con acordeón invisible (Cholos).

### Chat
- **Proximidad:** Voz 3D posicional en 30 metros.
- **Canales:** /grito (500m), /barrio (distrito), /crew, /radio (facción).
- **Sistema de Insulto:** 30s de insultos mutuos → duelo automático de callejón.

---

*«Aquí no hay clases de tank-healer-dps... bueno, sí hay, pero el tank usa un chaleco antibalas robado y el healer te inyecta adrenalina con una jeringa oxidada.»*
