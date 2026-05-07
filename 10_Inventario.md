# BARRIO SIN LEY ONLINE (BSLO)
## 10 — Inventario y Equipamiento
**Versión:** 2.0

---

## 1. FILOSOFÍA DEL INVENTARIO

El inventario de BSLO es un homenaje al sistema de **Resident Evil 4**: una malla grid donde los objetos ocupan espacio físico real y debés optimizar como un puzzle de Tetris. Abrir el inventario **no pausa el juego** — sos vulnerable mientras revisás tu maletín. Cada decisión de inventario importa.

> **Regla:** *"El inventario no es solo un menú. Es tensión. Es el momento donde decidís si dejás la escopeta o los tacos de la abuela."*

---

## 2. ESTRUCTURA DE LA MALLA PRINCIPAL

### Especificaciones
- **Tamaño base:** 8 columnas x 10 filas (80 celdas totales).
- **Expansión:** +2 filas por mochila equipada. Máximo 3 mochilas = 8x16 (128 celdas).
- **Visual:** Fondo verde oscuro con textura de nylon balístico. Grid gris tenue. Bordes de ítems según rareza.
- **Las mochilas son visibles en el modelo 3D del personaje** (mochila pequeña, mediana, maleta de ruedas).

### Tamaños de Ítems
| Tamaño | Ejemplos |
|--------|----------|
| **1x1** | Balas sueltas, monedas, píldoras, llaves, tarjeta SIM |
| **1x2** | Navaja, pistola compacta, frasco, taco, walkie-talkie |
| **2x2** | Pistola estándar, bote de spray, teléfono celular, cajetilla |
| **2x3** | Subfusil (UZI), escopeta recortada, laptop vieja |
| **2x5** | Rifle de asalto, escopeta completa, guitarra eléctrica |
| **3x4** | Lanzacohetes, caja fuerte portátil, TV CRT |

### Rotación de Ítems
- Tecla [R] rota el ítem 90° para optimizar espacio.
- **No rotan:** Líquidos (se derramarían) y la TV CRT ("el tubo de rayos catódicos no se voltea").

---

## 3. VULNERABILIDAD AL ABRIR INVENTARIO

- Abrir el inventario **no pausa el juego**.
- Tu personaje queda vulnerable: podés ser atacado mientras ordenás.
- En 1ª persona, la pantalla se oscurece y ves el maletín. En 3ª persona, aparece una ventana semi-transparente.
- **Animación:** Sonido de cremallera. El maletín "cae" desde arriba con física.
- **Consejo del juego:** "No revises tu mochila en medio de un tiroteo. Eso lo aprendés a las malas."

---

## 4. SLOTS DE EQUIPAMIENTO

| Slot | Cantidad | Visible en personaje |
|------|----------|---------------------|
| Arma Principal | 1 | Sí (espalda) |
| Arma Secundaria | 1 | Sí (cadera/pierna) |
| Cuerpo a Cuerpo | 1 | Sí (espalda/cinturón) |
| Explosivo / Arrojadizo | 2 | Sí (cinturón) |
| Casco / Gorra | 1 | Sí |
| Chaleco / Armadura | 1 | Sí |
| Guantes | 1 | Sí |
| Botas / Zapatos | 1 | Sí |
| Accesorio 1 | 1 | Sí (collar, anillo) |
| Accesorio 2 | 1 | Sí |

Un ítem equipado **no ocupa espacio en la malla**. Al desequiparlo, debe caber en el inventario o se tira al suelo.

---

## 5. TIPOS DE ÍTEMS

### 5.1 Armas
- Cada arma tiene: daño base, velocidad de ataque/recarga, alcance, rareza, durabilidad.
- Las armas se degradan con el uso y al morir.
- Un arma con durabilidad 0 no puede equiparse hasta repararse.

### 5.2 Munición
- **Caja de 9mm (50 balas):** 1x2 celdas.
- **Caja de .45 ACP (30 balas):** 1x2 celdas.
- **Caja de Escopeta (20 cartuchos):** 2x2 celdas.
- **Caja de Rifle (30 balas):** 2x2 celdas.
- **Cohete RPG:** 1x3 celdas (individual, no rotan).

**Mecánica de Recarga:** Consumís la caja completa. Las balas sobrantes se pierden. Esto fuerza a planificar cuánta munición llevar.

### 5.3 Consumibles
| Ítem | Tamaño | Efecto |
|------|--------|--------|
| Taco de la Esquina | 1x1 | Cura 20% HP. Animación de comer 5s (vulnerable). |
| Jarabe de la Abuela | 1x2 | Cura 50% HP + remueve veneno. |
| Cocaína | 1x1 | +30% velocidad, +20% daño 3 min. Post-uso: -50% stamina, visión borrosa 2 min. Ilegal. |
| Marihuana | 1x1 | +50% HP regen pasiva, colores saturados, -10% precisión. Ilegal. |
| Adrenalina | 1x1 | Auto-revive: si morís en 30s, resucitás con 10% HP. 10 min CD. |
| Cerveza del Barrio | 1x1 | +20% daño melee, -30% precisión. Stackable x3. 3 cervezas = desmayo 10s. |

### 5.4 Materiales de Crafting
- Químicos (rojo, azul, verde, amarillo): 1x1 c/u.
- Piezas de arma (cañón 2x4, cargador 1x2, empuñadura 1x1).
- Electrónicos (placa 2x2, cables 1x3, batería 1x1).
- Tela y ropa (2x2, stackeable hasta 5 del mismo tipo).

### 5.5 Ítems de Quest
- Documentos Falsos (2x3): Necesarios para cruzar puestos de control policial.
- Teléfono Celular (2x2): Obligatorio. Recibís llamadas de NPCs, mensajes de crew, spam.
- Walkie-Talkie (1x2): Chat de voz con party sin límite de proximidad.

---

## 6. INVENTARIOS ESPECIALES

### Baúl de Vehículo
| Vehículo | Capacidad | Notas |
|----------|-----------|-------|
| Moto | 2x3 | Prácticamente un bolsillo |
| Sedán | 6x6 | Transporte de loot estándar |
| Camioneta | 8x8 | Para raids y loot masivo |
| Helicóptero | 4x4 | Escape rápido con loot limitado |

Si el vehículo se destruye, el loot del baúl se esparce en 10m a la redonda (loot libre para cualquiera).

### Banco Personal
- 100 slots iniciales en el Banco Central.
- Almacenamiento de oro (PB).
- Expansión con moneda premium: +50 slots por compra.
- Durante "La Purga" mensual, 5% de chance de que NPCs roben ítems del banco (se convierten en misiones de recuperación).

### Almacén de Crew
- Malla compartida de 20x20 celdas para todos los miembros.
- Uso: depositar/retirar loot de raids, compartir recursos, almacenar ítems de guerra.
- Ver 08_Crews.md para gestión completa.

### Inventario de Mascota
- Firulais (perro callejero) y otras mascotas tienen 4 slots 1x1.
- Ideal para llevar tacos extra. Firulais llevando 4 tacos es "lo más adorable y útil del juego".

### Equipo Rápido (HUD)
- 4 slots visibles en el HUD sin abrir inventario completo.
- Por defecto: cura, droga, adrenalina, explosivo.
- Se configuran arrastrando desde la malla principal.

---

## 7. PESO MÁXIMO Y CAPACIDAD DE CARGA

El peso es un sistema secundario al espacio grid:
- **Capacidad de carga** = 50 + (STR × 5) kg.
- Cada ítem tiene un valor de peso. Exceder el límite:
  - Movimiento -50%.
  - Sin sprint.
  - Personaje se ve encorvado (animación de cargar mucho).
  - Si excedés peso Y espacio, los ítems nuevos caen al suelo.

---

## 8. RAREZAS DE ÍTEMS

| Tier | Color | Descripción |
|------|-------|-------------|
| **Basura** | Gris | Ropa rota, latas vacías. Vendible como chatarra. |
| **Común** | Blanco | Armas básicas, comida normal. |
| **Incomún** | Verde | Armas modificadas, drogas de calidad, materiales raros. |
| **Raro** | Azul | Armas con nombre, vehículos tuneados. |
| **Épico** | Magenta | Gear de facción, armas con historia (lore). |
| **Legendario** | Dorado | Uno por servidor. Pistola del Patrón, Katana del Patriarca. |
| **Maldito** | Rojo Oscuro | Stats absurdamente altos + debuff permanente. Ej: "Anillo del Padrino" (+100% daño, -50% velocidad, lluvia de sangre a tu alrededor). |

---

## 9. DEGRADACIÓN Y REPARACIÓN

- Todas las armas y armaduras tienen **durabilidad** (100 puntos base).
- Cada muerte: -15 a 25 puntos de durabilidad en todo el equipo.
- Uso normal: -1 punto cada ~100 disparos/golpes.
- **Durabilidad 0:** Ítem roto. No equipable. Ocupa espacio en inventario.
- **Reparación:** Taller Mecánico (vehículos), Armería (armas), Sastrería (ropa). Cuesta PB.
- Costo de reparación escala con el tier del ítem. Legendario = muy caro de mantener.
- **Gold sink primario.**

---

## 10. ANIMACIONES Y SONIDO DEL INVENTARIO

- **Abrir:** Sonido de cremallera + maletín cae con física.
- **Mover ítem:** Fricción de tela/cuero. Ítems grandes hacen "thud".
- **Combinar (crafting):** Chispa + sonido de soldadura/cocina.
- **Tirar ítem:** Cae al mundo como objeto 3D físico con su sprite de inventario.

### Easter Eggs del Inventario
- Taco + Pistola en celdas adyacentes = tooltip "Desayuno del Campeón".
- Malla completamente llena (sin huecos) = buff "Tetris Master" (+5% velocidad, 10 min).
- 10 condones en inventario = NPC te grita "¡Eso compa, precavido!".
- Cuerpo (quest) + Pala = opción "Resolver el problema" (consume ambos, buff karma negativo).

---

*«Aquí no hay mochila mágica de 500 slots. Si querés traer la escopeta, las balas, los tacos, la droga y el soborno, necesitás una maleta de ruedas. Y sí, te la robamos si te matamos.»*
