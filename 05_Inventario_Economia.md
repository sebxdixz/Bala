# 🎮 BARRIO SIN LEY ONLINE (BSLO)
## 05 - Inventario, Economía & Crafting
**Versión:** 1.0 | **Género:** MMO Action-RPG de Mundo Abierto

---

## 1. FILOSOFÍA DEL INVENTARIO: "ATTACHÉ CASE" ESTILO RESIDENT EVIL

El inventario de BSLO es un homenaje directo al sistema de *Resident Evil 4* y *Resident Evil: Village*: una malla grid donde los objetos ocupan espacio físico real y debes optimizar como un puzzle de Tetris. Pero aquí, en vez de hierbas y granadas, metes pistolas, bolsas de polvo blanco, cajas de munición, tacos, y maletines de dinero sucio.

> **Regla de Diseño:** *"El inventario no es solo un menú. Es tensión. Es decisión. Es el momento donde decides si dejas la escopeta o los tacos de la abuela."*

---

## 2. ESTRUCTURA DEL INVENTARIO

### Malla Principal ("La Maleta")
- **Tamaño base:** 8x10 celdas (80 slots totales, pero los ítems ocupan múltiples celdas).
- **Expansión:** +2 filas por mochila equipada. Las mochilas son visibles en el sprite del personaje (bolsas, maletines, maletas de ruedas).
- **Visual:** Fondo verde oscuro (#1a2e1a) con textura de nylon balístico. Grid visible en gris tenue. Los ítems tienen bordes dorados si son épicos, rojos si son malditos, magenta si son del mercado negro.

### Tipos de Celdas
| Tamaño | Ejemplos |
|--------|----------|
| **1x1** | Bala suelta, moneda, píldora, llave, condón (sí, ítem de quest), tarjeta SIM. |
| **1x2** | Navaja, pistola compacta, frasco, taco, billete doblado, walkie-talkie. |
| **2x2** | Pistola estándar, bote de spray, paquete de vendas, cajetilla de cigarros, teléfono celular. |
| **2x3** | Subfusil (UZI), escopeta recortada, bata de químico, laptop vieja. |
| **2x5** | Rifle de asalto, escopeta completa, maletín de dinero, guitarra eléctrica. |
| **3x4** | Lanzacohetes, caja fuerte portátil, cuerpo de NPC (sí, quest items oscuros), TV CRT. |

### Rotación de Ítems
- Presionar [R] rota el ítem 90 grados dentro de la malla. Esencial para optimizar espacio.
- Algunos ítems NO rotan: líquidos (se derramarían), cuerpos (anatomía), y la TV CRT (porque "el tubo de rayos catódicos no se voltea").

### Sistema de Peso Secundario
- Aunque la mecánica principal es espacial, cada personaje tiene un peso máximo basado en Fuerza (STR).
- Si excedes el peso: movimiento -50%, no puedes sprintar, y tu sprite se ve encorvado (animación de cargar mucho).
- Si excedes el peso y el espacio: los ítems nuevos caen al suelo (lootable por cualquiera).

---

## 3. CATEGORÍAS DE ÍTEMS

### 3.1 Armas
- **Slot de Arma Principal:** 1 (espalda del personaje, visible en sprite).
- **Slot de Arma Secundaria:** 1 (cinturón/pierna, visible).
- **Slot de Cuerpo a Cuerpo:** 1 (espalda/cinturón).
- **Slot de Explosivo/Arrojadizo:** 2 (cinturón).

**Nota Importante:** El arma equipada NO ocupa espacio en el inventario mientras esté equipada. Pero si la desequipas, debe caber en la malla o la tiras.

### 3.2 Munición
- La munición ocupa espacio en el inventario como cajas.
- **Caja de 9mm (50 balas):** 1x2 celdas.
- **Caja de .45 ACP (30 balas):** 1x2 celdas.
- **Caja de Escopeta (20 cartuchos):** 2x2 celdas.
- **Caja de Rifle (30 balas):** 2x2 celdas.
- **Cohete RPG:** 1x3 celdas (individual, no rotan).

**Mecánica de Recarga:** Al recargar, consumes una caja completa. Las balas sobrantes se pierden (sí, es frustrante, es intencional). Esto fuerza a llevar exactamente lo que necesitas.

### 3.3 Consumibles (Drogas, Comida, Medicina)
- **Tacos de la Esquina:** 1x1. Cura 20% HP. 5 segundos de animación de comer (vulnerable).
- **Jarabe de la Abuela:** 1x2. Cura 50% HP + remueve veneno. Sabor a menta y peligro.
- **Cocaína (Polvo Blanco):** 1x1. +30% velocidad, +20% daño, dura 3 minutos. Debuff post-uso: -50% stamina, visión borrosa por 2 minutos. Ilegal. Si te revisa un policía y la encuentra, wanted 3⭐ instantáneo.
- **Marihuana (Bolsa Verde):** 1x1. +50% regeneración de HP pasiva, visión más brillante (colores saturados), -10% precisión. Ilegal pero policías a veces la ignoran si les das una calada.
- **Adrenalina (Jeringa Roja):** 1x1. Revive a 10% HP si mueres en los próximos 30 segundos (auto-revive). Cooldown 10 minutos.
- **Cerveza del Barrio:** 1x1. +20% daño cuerpo a cuerpo, -30% precisión a distancia, duración 5 min. Stackable hasta 3 (si tomas 3, te desmayas por 10 segundos).

### 3.4 Materiales de Crafting
- **Químicos:** 1x1 cada uno. Rojo, azul, verde, amarillo. Combinables.
- **Piezas de Arma:** Cañones (2x4), Cargadores (1x2), Empuñaduras (1x1).
- **Componentes Electrónicos:** Placas (2x2), Cables (1x3), Baterías (1x1).
- **Ropa y Tela:** 2x2 cada pieza. Pueden apilarse hasta 5 en la misma celda si son del mismo tipo.

### 3.5 Ítems de Quest y Misceláneos
- **Documentos Falsos:** 2x3. Necesarios para cruzar ciertos puestos de control.
- **Maletín de Dinero Sucio:** 2x3. Contiene oro no-lavado. No puede usarse en tiendas hasta que lo "laves" (quest de contador).
- **Teléfono Celular:** 2x2. Ítem obligatorio. Recibes llamadas de NPCs (misiones), mensajes de tu crew, y spam publicitario.
- **Radio Walkie-Talkie:** 1x2. Permite chat de voz con tu party sin depender de proximidad.

---

## 4. INVENTARIOS ESPECIALES

### 4.1 Baúl del Vehículo
- Cada vehículo tiene su propia malla de inventario.
- Sedán: 6x6 celdas.
- Camioneta: 8x8 celdas.
- Moto: 2x3 celdas (solo mochila pequeña).
- **Mecánica:** Si el vehículo es destruido, el inventario queda esparcido en un radio de 10 metros como loot libre.

### 4.2 Banco / Almacén de Crew
- El banco central permite guardar oro e ítems. 100 slots iniciales, expansión con moneda premium o quest.
- El almacén de crew es una malla compartida de 20x20 celdas donde todos los miembros depositan/recogen.
- **Evento de Robo:** En "La Purga" mensual, los bancos pueden ser asaltados. Los ítems guardados tienen 5% chance de ser robados por NPCs (se convierten en misiones de recuperación).

### 4.3 Maletín Táctico (Equipo Rápido)
- Cuatro slots visibles en el HUD que no requieren abrir el inventario completo.
- Slots 1-4: Consumibles rápidos (por defecto: cura, droga, adrenalina, explosivo).
- Se llenan arrastrando desde la malla principal.

### 4.4 Inventario de "Compañero" (Pets/Followers)
- Si tienes un follower (Firulais el perro, un NPC aliado temporal), tiene 4 slots de inventario 1x1.
- Firulais puede llevar 4 tacos. Es lo más adorable y útil del juego.

---

## 5. ECONOMÍA DEL JUEGO

### 5.1 Monedas
| Moneda | Origen | Uso |
|--------|--------|-----|
| **Pesos de Barrio (PB)** | Todo (loot, quests, ventas) | Común. Tiendas, reparaciones, comida. |
| **Dólares Sucios (DS)** | Crimen, mercado negro, raids | Premium ilegal. Armas, drogas, info, sobornos. |
| **Fichas de Casino (FC)** | Juegos de azar, eventos | Cosméticos, emotes, muebles de safe house. |
| **Reputación de Facción (RF)** | Quests de facción | Gear exclusivo, clases elite, mounts. |

### 5.2 Sistema de Lavado de Dinero
- El dinero ganado por crimen llega como **Dólares Sucios**.
- No puedes gastarlos en tiendas legales. Debes "lavarlos".
- **Métodos de Lavado:**
  - **La Taquería:** Compra tacos a 1000 DS, revéndelos a NPCs por 800 PB (pérdida del 20%, pero legal).
  - **El Casino:** Apuesta DS. Si ganas, salen como Fichas, que cambias a PB.
  - **La Inmobiliaria:** Compra propiedades con DS (soborno al vendedor), alquila por PB legal.
  - **El Contador (Mafia):** Habilidad de clase. Convierte DS a PB con solo 10% pérdida.

### 5.3 Mercados

#### Mercado Legal (Tiendas Físicas)
- **Armería del Barrio:** Vende armas básicas, munición, chalecos. Requiere licencia (quest) para armas grandes.
- **Farmacia:** Vende curas básicas, antídotos, condones (sí, ítem de protección contra debuff de enfermedad).
- **Supermercado:** Comida, bebidas, ropa básica, materiales comunes.
- **Taller Mecánico:** Repara vehículos, vende gasolina, tunea coches.
- **Peluquería / Tattoo:** Customización visual. Los tatuajes cuestan PB + dolor (daño temporal de 5% HP).

#### Mercado Negro (La Casa Abandonada y Túneles)
- No aparece en el mapa oficial. Debes saber dónde está.
- **Precios:** -30% en armas, +200% en curas (lógica del mercado negro: abundancia de armas, escasez de médicos).
- **Ítems Exclusivos:** Drogas, armas sin registro, documentos falsos, órganos, información de jugadores (ubicación, inventario).
- **Vendedores:** Cambian cada día server. Uno puede ser un yakuza vendiendo katanas, otro un narco con "producto agrícola especial".

#### Subasta Server (Domingos, Torre del Reloj)
- Subasta de ítems únicos donados por jugadores o generados por eventos.
- Sistema de puja en tiempo real. El ganador obtiene el ítem, el vendedor recibe PB menos 15% de comisión del "sindicato de subastas".
- Pueden subastarse: vehículos, armas legendarias, propiedades de distrito, incluso **bounties** (subastar el derecho de cazar a un jugador famoso).

### 5.4 Generación de Ingresos Pasivos

#### Propiedades
- Los jugadores pueden comprar inmuebles en distritos que su crew controle.
- **Tipos:**
  - **Safe House:** Almacén + respawn personal. $500,000 PB.
  - **Negocio de Fachada:** Genera PB por hora real (tienda de ropa, taller, restaurante). $1,000,000 PB. Puede ser "protegido" por tu crew o "extorsionado" por otra.
  - **Bodega:** Almacén masivo (40x40 celdas). $2,000,000 PB. Ideal para crews.
  - **Penthouse:** Decoración social, fiestas, +10% charisma a invitados. $5,000,000 PB.

#### Extorsión y Protección (Crew Feature)
- Si tu crew controla un distrito, puede cobrar "impuestos" a los negocios de jugadores en ese distrito.
- 5% de sus ingresos pasivos van al banco de crew.
- El dueño del negocio puede pagar "protección extra" (10% más, pero +seguridad) o negarse (riesgo de que NPCs destruyan su propiedad).

---

## 6. SISTEMA DE CRAFTING ("EL TALLER CLANDESTINO")

### 6.1 Estaciones de Crafting

| Estación | Ubicación | Qué Hace |
|----------|-----------|----------|
| **Banco de Armas** | Armería / Safe House | Desarmar armas por piezas. Combinar piezas para armas custom. |
| **Laboratorio Químico** | Túneles Narco / Safe House | Cocinar drogas, explosivos caseros, venenos, curas potentes. |
| **Mesa de Tatuajes** | Barbería / Safe House | Crear diseños de tatuaje que dan buffs permanentes (+5 STR, etc.). |
| **Taller Mecánico** | Garajes / Safe House | Craftear vehículos, mejorar armadura de coches, pintura custom. |
| **Ordenador de Hackeo** | Cyber-Café / Safe House | Craftear virus, desbloquear cajas fuertes, falsificar documentos. |
| **Cocina de Barrio** | Casa / Puestos Callejeros | Comida buffeada. Tacos de la abuela que curan 100% HP pero requieren 10 ingredientes raros. |

### 6.2 Recetas Ejemplares

#### Armas
- **"La Vecina" (Pistola custom):** Empuñadura estándar (1x1) + Cañón recortado (1x2) + Cargador extendido (1x1). Resultado: Pistola 2x2 que dispara 15 balas sin recargar.
- **"El Corrido" (AK modificada):** AK base (2x5) + Mira holográfica (1x1) + Silenciador de lata (1x1) + Empuñadura vertical (1x1). Resultado: AK silenciada 2x5 con +10% precisión.
- **"Pólvora y Orgullo" (Mina casera):** Químico rojo (1x1) + Químico azul (1x1) + Cable (1x3) + Placa (2x2). Resultado: Mina 2x2. Se planta en el suelo. Daño de área.

#### Drogas (Química)
- **"Polvo de Ángel":** Químico rojo + Químico blanco + Bicarbonato (1x1). +50% daño, -30% defensa, duración 5 minutos. Ilegal. Wanted si te encuentran con él.
- **"Jarabe para el Aliento":** Químico verde + Menta (1x1) + Agua (1x1). Cura veneno + da buff de charisma +20% (aliento fresco = confianza).

#### Comida
- **"Taco de Suadero Divino":** Tortilla (1x1) + Carne (1x1) + Cebolla (1x1) + Salsa verde (1x1). Cura 100% HP. Da buff "Satisfacción" (+10% XP) por 1 hora.
- **"Elote del Barrio":** Elote (1x2) + Mayonesa (1x1) + Queso (1x1) + Chile (1x1). Cura 50% HP. Da buff "Lengua de Fuego" (resistencia al fuego +50%) por 30 min.

#### Ropa / Armadura
- **Chaleco Antibalas Reforzado:** Chaleco estándar (2x3) + Placas de metal (2x2) + Cinta adhesiva (1x3). +40% defensa contra balas. Movimiento -10%.
- **Traje de la Yakuza (Buff):** Tela negra (2x2) + Tela blanca (2x2) + Aguja de tatuaje (1x1). +20% charisma con NPCs yakuza. Animación de ajustarse la corbata automática.

### 6.3 Sistema de Calidad
Los ítems crafteados tienen calidad basada en tu skill de crafting:
- **Defectuoso (gris):** -20% stats. Pero puede venderse como "auténtico barrio" a coleccionistas.
- **Normal (blanco):** Stats base.
- **Bueno (verde):** +10% stats.
- **Excelente (azul):** +20% stats, apariencia brillante.
- **Maestro (magenta):** +30% stats, nombre personalizable, puede llevar tu tag de crew.
- **Legendario (dorado):** +50% stats, efecto único, solo 1 por servidor puede existir con ese nombre.

---

## 7. LOOT Y DROP SYSTEM

### 7.1 Fuentes de Loot
- **Enemigos NPCs:** Dropean armas usadas (daño reducido), munición sobrante, dinero, y "recuerdos" (llaveros, fotos, relojes) que venden bien a coleccionistas.
- **Jugadores (PVP):** Si matas a un jugador en zona PVP libre, puedes saquear su cadáver. Solo ítems no-equipados (los equipados se quedan con el muerto).
- **Contenedores:** Basureros, cajas, maleteros de coches, neveras. Loot aleatorio de bajo nivel pero con chance de rareza.
- **Cajas Fuertes:** Requieren lockpick (skill) o explosivos. Alto riesgo (alarma), alto reward.

### 7.2 Rarezas
| Tier | Color | Descripción |
|------|-------|-------------|
| Basura | Gris | Ropa rota, latas vacías, zapatos sin par. Vendible como chatarra. |
| Común | Blanco | Armas básicas, comida normal, ropa standard. |
| Incomún | Verde | Armas con modificaciones, drogas de calidad, materiales raros. |
| Raro | Azul | Armas únicas con nombre, vehículos tuneados, documentos valiosos. |
| Épico | Magenta | Gear de facción, armas con historias (lore), drogas de diseñador. |
| Legendario | Dorado | Uno por servidor. Pistola del Patrón, Katana del Patriarca, etc. |
| Maldito | Rojo Oscuro | Stats absurdamente altos pero debuff permanente. Ej: "El Anillo del Padrino" (+100% daño, pero -50% velocidad y llueve sangre alrededor tuyo). |

---

## 8. ESTÉTICA DE INVENTARIO Y UI

### Animaciones
- **Abrir inventario:** Sonido de cremallera + el maletín "cae" en pantalla desde arriba con animación de física.
- **Mover ítems:** Sonido de fricción de tela/cuero. Los ítems grandes hacen un "thud" al colocarse.
- **Combinar ítems:** Chispa pixelada + sonido de soldadura/cocina según el crafting.
- **Tirar ítem:** El ítem cae del inventario a la pantalla de juego como un objeto 3D físico.

### Easter Eggs del Inventario
- Si tienes un taco y una pistola en celdas adyacentes, aparece un tooltip especial: "Desayuno del Campeón".
- Si llenas exactamente toda la malla sin espacios vacíos, obtienes el buff "Tetris Master" (+5% velocidad de movimiento por 10 minutos).
- Si llevas 10 condones en el inventario, un NPC te grita "¡Eso compa, precavido!" al pasar.
- Si llevas un cuerpo (quest item) y una pala en el inventario, aparece la opción "Resolver el problema" que consume ambos y te da un buff de karma negativo.

---

*"Aquí no hay mochila mágica de 500 slots. Si quieres traer la escopeta, la caja de balas, los tacos, la droga y el dinero del soborno, necesitas una maleta de ruedas. Y sí, te robamos la maleta si te matamos."*
