# 🎮 BARRIO SIN LEY ONLINE (BSLO)
## 02 - Mecánicas de Juego & Sistemas Core
**Versión:** 1.0 | **Género:** MMO Action-RPG de Mundo Abierto

---

## 1. FILOSOFÍA DE DISEÑO MECÁNICO

BSLO no es un simulador de crimen realista. Es un **MMORPG tradicional** (hotbar, levels, raids, loot, crafting, guilds) que usa la piel de un mundo criminal urbano. La paradoja intencional es que el sistema más MMO posible — con sus abstracciones y gamificaciones — se sienta fresco porque está vestido de callejón sucio.

> **Regla de Oro:** *"Si funciona en World of Warcraft, funciona aquí. Solo que en vez de un Paladín con espada brillante, es un Narco con una AK dorada y chanclas."*

---

## 2. PROGRESIÓN DE PERSONAJE

### Niveles y Rangos (Level Cap: 60)
- **Niveles 1-15:** Chivato / Tirapiedras / Camello — Aprendiz de criminal.
- **Niveles 16-30:** Soldado / Matón de Confianza / Patrullero Sucio — Pieza funcional de la organización.
- **Niveles 31-45:** Capitán / Sicario / Teniente Corrupto — Mando medio con tropas bajo tu mando.
- **Niveles 46-60:** Jefe de Plaza / Consigliere / Comandante / Oyabun / Comisario Sombrío — Elite del servidor.

### Stats Principales (Sistema RPG Clásico)
| Stat | Nombre Callejero | Qué Afecta |
|------|-------------------|------------|
| **STR** | *Fuerza Bruta* | Daño cuerpo a cuerpo (bate, navaja, puño americano). Capacidad de cargar más peso en inventario. |
| **DEX** | *Dedos Ligeros* | Velocidad de recarga, precisión, pickpocket, chance de crítico (tiro en la cabeza). |
| **CON** | *Hígado de Acero* | HP total, resistencia a venenos/drogas, tiempo antes de desmayarse por daño. |
| **INT** | *Astucia* | Daño con explosivos, químicos, hacks. Eficiencia en crafting. |
| **WIS** | *Calle* | Detección de mentiras en diálogos, resistencia a sobornos, encontrar rutas secretas en la ciudad. |
| **CHA** | *Labia* | Precios en el mercado negro, chance de sobornar policías, liderazgo de banda (buffs de área). |

### Sistema de Clases (Ver detalle en 03_Facciones_Clases.md)
Cada facción tiene 3 clases jugables + 1 clase híbrida desbloqueable. Total: **20+ clases**.

---

## 3. COMBATE: SISTEMA HíBRIDO TAB-TARGET + ACTION

### Combate a Distancia (Armas de Fuego)
- **Modo PVE:** Tab-target clásico. Seleccionas al enemigo, usas habilidades de la hotbar (1-0). El daño se calcula con stats + gear.
- **Modo PVP:** Action combat con hitboxes. Debes apuntar. Sistema de *cover* automático: al acercarte a una pared/coche, tu sprite se pone en cobertura (animación de agacharse).
- **Sistema de Munición:** Las balas son un recurso, no un número abstracto. Debes recargar manualmente (animación de 2 segundos vulnerable). La munición ocupa espacio en tu inventario tipo Tetris (una caja de 9mm = 1x2 celdas).

### Combate Cuerpo a Cuerpo
- **Estilo beat-'em-up:** Combos de 3 golpes básicos + habilidad especial. Referencia mecánica: *Yakuza 0* simplificado.
- **Armas cuerpo a cuerpo:** Navajas (rápido, poco daño), Bate de Béisbol (lento, stun), Cadena de Motosierra (DPS, overheat), Puño Americano (críticos silenciosos).
- **Ejecuciones:** Si un enemigo está bajo 10% de vida, aparece el prompt de ejecución (tecla F). Es una animación breve, violencia pixelada estilizada, y da buff de moral a aliados cercanos.

### Cover System
- Presionar [Espacio] cerca de objetos sólidos te pone en cobertura.
- En cobertura, recibes -75% daño frontal pero no puedes usar armas largas (rifles/escopetas).
- Puedes hacer *blind fire* (disparar sin apuntar) con -90% precisión pero manteniendo cobertura.

---

## 4. SISTEMA DE WANTED / NIVEL DE BÚSQUEDA (1-5 ESTRELLAS)

Inspirado en GTA pero adaptado a MMO: tu nivel de búsqueda afecta a TODOS los jugadores de tu zona.

| Estrellas | Nombre | Qué Pasa |
|-----------|--------|----------|
| ⭐ | *Mirada Sospechosa* | Solo NPCs policiales te siguen con la vista. |
| ⭐⭐ | *Patrullaje Agresivo* | Policías NPCs te piden documentos (mecánica de diálogo/escape). |
| ⭐⭐⭐ | *Operativo de Barrio* | SWAT NPCs generados. Todos los jugadores en 200m reciben debuff de "Zona Caliente" (-20% ventas en tiendas). |
| ⭐⭐⭐⭐ | *Estado de Sitio* | Helicópteros pixelados, barricadas en calles. Los jugadores policía pueden unirse a la cacería por recompensa. |
| ⭐⭐⭐⭐⭐ | *Mano Dura Total* | Tanque de policía rompe paredes. Todos los NPCs comerciales cierran. Los jugadores criminales ganan +50% XP por sobrevivir. Si mueres, pierdes TODO el inventario no-equipado. |

### Cómo Bajar Estrellas
- **Esconderse:** Safe houses reducen 1 estrella cada 5 minutos reales.
- **Sobornar:** Interactuar con un jugador policía o NPC corrupto. Paga dinero negro = reduce nivel.
- **Cambio de Look:** Peluquerías y tiendas de ropa te permiten "resetear" tu apariencia, reduciendo 1 estrella instantáneamente (cooldown: 1 hora real).

---

## 5. SISTEMA DE BANDAS / GUILDS ("Crews")

Las guilds son el corazón social del juego. En BSLO se llaman **Crews** (Bandas).

### Creación de Crew
- Requiere nivel 20 + 5 jugadores fundadores + pago de $500,000 en moneda del juego.
- Debes elegir una facción principal (Yakuza, Narco, Mafia, Policía Corrupta, o Pandilla Callejera Libre).

### Territorio y Control
- La ciudad está dividida en **120 Distritos**.
- Cada distrito genera ingresos pasivos por hora (impuestos de NPCs, venta de drogas simulada, protección a comercios).
- Para conquistar un distrito, tu Crew debe completar una **Raid de Territorio** (instancia PVE/PVP de 10-20 jugadores) contra la Crew defensora o NPCs locales.

### Jerarquía de Crew
| Rango | Poder |
|-------|-------|
| **Líder (1)** | Control total, declaración de guerra, acceso a banco de crew. |
| **Subjefe (2)** | Invitar/expulsar, iniciar raids, editar tag de territorio. |
| **Capitán (5)** | Liderar escuadras (parties de 5), colocar defensas en territorio. |
| **Soldado (∞)** | Participar en raids, cobrar salario semanal de crew. |
| **Recluta** | Solo acceso a chat, no puede entrar a zonas de crew sin escolta. |

### Graffiti de Territorio
- Al controlar un distrito, tu crew puede colocar un **Tag Gigante** en las paredes principales. Es visible para todos los jugadores.
- Otros jugadores pueden "desprestigiar" tu tag (mecánica de mini-juego de spray) para debuff temporal de -10% ingresos del distrito.
- El tag se queda ahí hasta que otra crew tome el territorio.

---

## 6. TRANSPORTE Y MOVIMIENTO

### A Pie
- Sprint limitado por stamina (barra amarilla bajo la vida).
- Doble-tap en dirección para *esquivar* (roll) con frames de invulnerabilidad.
- **Parkour simplificado:** Presionar [Espacio] frente a vallas bajas, ventanas, o tejados salteables.

### Vehículos
| Vehículo | Tipo | Uso |
|----------|------|-----|
| **Moto 125cc** | Personal | Rápida, acceso a callejones estrechos, 1 pasajero. |
| **Auto Sedán Chocado** | Crew | 4 pasajeros, baúl para transportar loot/armas. |
| **Camioneta Blindada** | Raid | 6 pasajeros, HP alta, sirve como cobertura móvil. |
| **Metro / Subte** | Público | Fast-travel entre distritos desbloqueados. Anuncios pixelados en los vagones. |
| **Helicóptero** | Elite | Solo nivel 50+. Acceso a tejados, bypass de barricadas. |

- Los vehículos tienen **HP y necesitan reparación**. Si un sedan se destruye con tu loot dentro, el loot queda esparcido en la calle (free-for-all loot).
- **Mecánica de Robo:** Puedes robar vehículos a NPCs (mini-juego de lockpick) o a jugadores AFK.

---

## 7. PVE: MISIONES Y CONTENIDO INSTANCIADO

### Misiones de Barrio (Quests)
- **Amarillas:** Historia principal (cadenas de 5-10 misiones por facción).
- **Verdes:** Misiones secundarias de NPCs callejeros (humorísticas, recompensan gear raro).
- **Azules:** Misiones diarias de crew (reputación + dinero).
- **Rojas:** Bounties (cazar jugadores con alto wanted level).

### Mazmorras ("Lugares Oscuros")
- **El Depósito de la Policía:** Robar evidencia. Enemigos: Policías NPCs, perros, jefes: Comisario mecanizado (exoesqueleto policial corrupto).
- **La Cantina de la Mafia:** Infiltración. Enemigos: Sicarios italianos. Jefe: El Padrino pixelado con escopeta dorada.
- **El Narcolaboratorio:** Destruir o robar químicos. Enemigos: Narcos locos, jaulas con tigres pixelados. Jefe: El Químico (usa explosivos químicos de área).
- **El Templo Yakuza:** Duelos 1v1 escalonados. Jefe final: El Patriarca (combate cuerpo a cuerpo extremo).
- **El Cyber-Café Abandonado:** Mecánica de puzzles digitales. Jefe: Un hacker que controla drones y torretas.

### Raids ("Golpes")
- **10 jugadores:** Asalto al Banco Central de la Ciudad. 3 fases: Infiltración, Código (hack), Escape en camioneta.
- **20 jugadores:** Guerra Total por el Centro de la Ciudad. PVP instanciado masivo con objetivos dinámicos.
- **40 jugadores:** El Evento Mensual "Día del Juicio". Todos los server compiten en un mapa especial. La crew ganadora obtiene el título de "Dueña de la Ciudad" por 30 días (+20% oro global, skin exclusiva, tag dorado).

---

## 8. PVP: SISTEMAS DE CONFLICTO

### Duelo de Callejón (1v1)
- En cualquier callejón, puedes desafiar a otro jugador. Se activa una instancia privada del callejón. Los espectadores pueden apostar desde las ventanas de los edificios.
- Si ganas, robas un ítem del inventario del perdedor (él elige cuál, dentro de un timer de 30 segundos; si no elige, pierde uno aleatorio).

### Guerras de Crew (Territorio)
- Declaración de guerra: 24 horas de prep. Notificación server-wide.
- La batalla ocurre en el distrito objetivo. Objetivos capturables: Puesto de Radio, Bodega, Subestación Eléctrica.
- Duración: 30 minutos. Gana quien controle más objetivos al final.
- **Consecuencias:** El perdedor pierde el distrito. Si era su único distrito, la crew se disuelve automáticamente ("quedarse sin barrio = sin honor").

### Cacería de Cabezas (Bounty System)
- Cualquier jugador puede poner precio por la cabeza de otro (mínimo $10,000).
- El objetivo recibe notificación: "Alguien pagó por tu cabeza". Su ubicación general se revela en el mapa cada 5 minutos a los cazadores.
- Matar al objetivo = cobrar el bounty. Morir siendo objetivo = pierdes un nivel de experiencia.

### Zonas PVP Libres
- **La Frontera:** Zona norte de la ciudad. PVP libre 24/7. XP +50%. Drop de inventario completo al morir.
- **El Mercado Negro:** Zona sur. PVP permitido pero con "reglas del barrio": si atacas a alguien que está comprando, todos los NPCs mercantes te atacan.
- **Zonas Seguras:** Comisarías centrales, hospitales, iglesias. PVP desactivado. Pero si tienes 4+ estrellas de wanted, los safe zones te expulsan ("ni Dios te quiere aquí").

---

## 9. SISTEMA DE MORAL Y REPUTACIÓN

### Karma de Barrio (Escala -1000 a +1000)
- **Negativo (Criminal):** Matar jugadores inocentes, robar NPCs, vender drogas. Beneficios: +15% daño, acceso a mercado negro, intimidación NPCs.
- **Positivo (Vigilante):** Matar criminales, ayudar NPCs, patrullar con policías. Beneficios: -50% precios en tiendas legales, acceso a equipamiento táctico, safe zones extendidas.
- **Neutral (Calle):** Vivir y dejar vivir. Beneficios: +20% gold de quests, habilidades de negociación.

### Reputación por Facción
Cada facción tiene su barra de reputación independiente. Puedes ser amigo de la Yakuza y enemigo de los Narcos al mismo tiempo.
- **Odiado:** Atacado a vista por NPCs de esa facción.
- **Despreciado:** Precios +100%.
- **Neutral:** Default.
- **Respetado:** Descuentos, quests exclusivas.
- **Reverenciado:** Acceso a la clase élite de esa facción, gear legendario.
- **Temido/Legendario:** Título server-wide, NPCs se arrodillan al pasar.

---

## 10. SISTEMAS DE VIDA / MUERTE / NOCHE

### Ciclo Día/Noche (4 horas reales = 1 ciclo completo)
- **Día:** +20% actividad policial. Shops abiertos. Misiones legales disponibles.
- **Tarde:** Peak de tráfico. Más NPCs en calle. Eventos sociales en plazas.
- **Noche:** -50% visibilidad sin linterna. PVP no anunciado (sin notificación de quién te atacó). Mercado negro se activa.
- **Madrugada:** "La Hora del Diablo" (2:00-4:00 AM server time). Eventos raros spawnan: el camión de la basura misterioso, la señora de los tamales que vende potiones épicas, el perro que guía a tesoros.

### Muerte y Penalización
- **Modo Normal:** Pierdes 5% del oro que lleves encima. Un ítem no-equipado queda en tu cadáver (lootable por cualquiera por 2 minutos). Respawn en hospital más cercano o safe house.
- **Modo Hardcore (opcional al crear personaje):** Muerte = personaje borrado. Pero XP +100%, loot exclusivo, tablón de leyenda server-wide con tu nombre si llegas a nivel 60.
- **Muerte por Wanted 5⭐:** Como en modo normal, pero pierdes TODO el inventario no-equipado y 10% del oro bancario.

---

## 11. EMOTES Y COMUNICACIÓN SOCIAL

### Emotes Culturales
- **El Baile del Tiburón** (emote raro, evento de verano).
- **La Jordan** (cruzar los brazos, emote de Yakuza).
- **El Corrido Tumbado** (tumbarte en el suelo con sombrero, emote de Narco).
- **El Piquete Vallenato** (bailar con acordeón invisible, emote de festejo).
- **Cheat Code Emote:** Arriba-Arriba-Abajo-Abajo (te hace brillar en verde por 5 segundos, referencia a Konami).

### Chat de Proximidad
- Voz por proximidad (3D positional audio) para jugadores en 30 metros.
- Chat de texto global dividido por canales: `/grito` (500m), `/barrio` (distrito), `/crew` (banda), `/radio` (frecuencia de facción).
- **Sistema de Insulto:** Si dos jugadores se insultan por chat de proximidad durante 30 segundos sin parar, se activa automáticamente un duelo de callejón (consensual o forzado según zona).

---

## 12. DIFICULTAD Y ACCESIBILIDAD

- **Servidores PVE:** PVP opt-in, wanted solo con NPCs, contenido accesible para jugadores casuales.
- **Servidores PVP:** Full loot, wanted con jugadores, guerra de crews constante.
- **Servidores RP:** Reglas estrictas de roleplay, moderación activa, PVP solo con razón narrativa.
- **Servidor "La Leyenda":** Un solo server por región. Hardcore. Muerte = borrado. El que llegue a nivel 60 primero gana un skin exclusivo server-único.

---

*"Aquí no hay classes de tank-healer-dps... bueno, sí hay, pero el tank usa un chaleco antibalas robado y el healer te inyecta adrenalina con una jeringa oxidada."*
