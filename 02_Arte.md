# BARRIO SIN LEY ONLINE (BSLO)
## 02 — Dirección de Arte
**Versión:** 2.0 | **Motor:** Godot Engine 4 | **Estilo:** 3D Low Poly

---

## 1. FILOSOFÍA VISUAL

BSLO usa **Godot Engine 4** con gráficos **3D Low Poly**. La referencia estética principal es **MU Online**: modelos tridimensionales de bajo poligonaje, texturas limpias con sombreado plano, armaduras que brillan por tier, y una sensación nostálgica de "juego de cyber de los 2000s". Pero en vez de castillos y dragones, esto es callejones, neón y narcos.

> **Mantra Visual:** *"MU Online meets GTA San Andreas meets graffiti digital. Que se vea como algo que encontraste en un cyber de 2004, pero corriendo en hardware de 2026."*

### Principios:
- **Low Poly Intencional:** Pocos polígonos, siluetas limpias. Los personajes son reconocibles por su forma, no por su conteo de triángulos.
- **Sombras planas + Iluminación moderna:** Cell shading suave combinado con iluminación global de Godot 4. Las sombras son duras, los neones rebotan.
- **Paleta dual:** Mundo podrido (grises, marrones, verdes oscuros) + Acción neón (magenta, cian, naranja).
- **Partículas pixeladas:** Humo, chispas, spray, lluvia: todo con partículas de baja resolución que refuercen la estética "retro-moderna".

---

## 2. PALETA DE COLORES OFICIAL

### Colores de Mundo (Podrido / Realista)
| Nombre | Hex | Uso |
|--------|-----|-----|
| **Asfalto Podrido** | `#2B2D2F` | Calles, fondos de UI principales |
| **Humedad de Pared** | `#4A4E4D` | Edificios, concreto, muros |
| **Óxido de Neón** | `#8B5A2B` | Metales, barandales, tuberías |
| **Verde Tóxico** | `#2E8B57` | Inventario, luces de safe house, veneno |
| **Sangre Seca** | `#6B2D2D` | Daño crítico, alertas, territorio enemigo |

### Colores de Acción (Neón / Graffiti)
| Nombre | Hex | Uso |
|--------|-----|-----|
| **Spray Magenta** | `#FF00AA` | Tags de tu banda, habilidades especiales, loot épico |
| **Cian de Barrio** | `#00FFFF` | NPCs aliados, waypoints, chat de grupo |
| **Naranja Quemado** | `#FF6600` | Misiones principales, fuego, explosivos |
| **Amarillo Policía** | `#FFCC00` | Nivel de búsqueda, policía, alertas |
| **Blanco Fantasma** | `#E0E0E0` | Texto principal, diálogos de mafia/yakuza |

---

## 3. CÁMARA

### Tercera Persona (Default)
- Cámara a la espalda, ligeramente elevada, distancia de 4-6 metros.
- Zoom con scroll: desde casi isométrico (estilo MU) hasta cercano (over-the-shoulder).
- En zonas de graffiti, la cámara hace zoom lento hacia la pared.
- En combate cuerpo a cuerpo, se acerca a la cintura.
- Rotación libre con mouse en 360°.

### Primera Persona (Interiores / Combate)
- Toggle manual o automático al entrar en interiores estrechos (safe houses, callejones).
- Armas en primer plano con animaciones de recarga visibles.
- Al abrir inventario en 1ª persona, la pantalla se oscurece y aparece la malla grid.

---

## 4. INTERFAZ DE USUARIO (UI/UX)

### HUD Principal
- **Vida:** Corazón estilizado que se agrieta y pierde color al recibir daño. En modo crítico (<20%), late con animación y gotea.
- **Stamina:** Barra amarilla bajo la vida.
- **Wanted:** 1-5 estrellas en esquina superior derecha, sobre un fondo de papel de búsqueda policial.
- **Hotbar:** 10 slots (1-0) en la parte inferior central. Íconos de habilidades con bordes de graffiti del color de tu facción.
- **Inventario rápido:** 4 slots visibles en esquina inferior (consumibles).
- **Minimapa:** Circular, rotativo, en esquina superior izquierda. Muestra calles, aliados de crew, enemigos con wanted.

### Menús
- **Inventario:** Fondo verde oscuro con textura de nylon táctico. Grid 8x10. Ítems con bordes de color según rareza.
- **Mapa:** Papel arrugado con manchas de café. Territorio de crew = tu tag. Territorio enemigo = su tag tachado.
- **Skill Tree:** Muro de graffiti. Cada habilidad es un tag que aparece con animación de spray al desbloquearse.
- **Árbol de Crew:** Tablero de corcho con fotos de los miembros conectadas por hilos rojos (estilo investigación policial).

### Tipografía
- **Títulos / Graffiti:** "Press Start 2P" o similar, con efecto de spray.
- **Diálogos Mafia/Yakuza:** Serif clásica, formal.
- **Diálogos Callejeros/Narcos/Cholos:** Sans-serif gruesa, con slang.
- **Sistema:** Consola verde fosforescente, parpadeo sutil.

---

## 5. DIRECCIÓN DE ARTE POR FACCIÓN

| Facción | Estilo Visual | Paleta Dominante | Arquitectura |
|---------|--------------|-------------------|--------------|
| **Yakuza** | Limpio, minimalista, vidrio oscuro, neón rojo, lluvia perpetua | Negro, rojo, blanco, gris plata | Torres corporativas, templos, callejones ordenados |
| **Cártel** | Colorido, caótico, tierra roja, camionetas, narcomantas | Tierra, rosa mexicano, verde aguacate, oro | Casas de adobe, ranchos, túneles, puestos de tacos |
| **Mafia** | Ladrillo viejo, niebla, farolas de gas, trajes caros | Marrón ladrillo, verde botella, crema, negro carbón | Restaurantes, iglesias, bodegas, teatros |
| **Policía** | Hormigón gris, fluorescentes, alambradas, orden falso | Blanco frío, azul policial, gris linóleo | Comisarías, barrios protegidos, hospitales |
| **Cholos** | Caos puro, graffiti en TODO, casas abandonadas, skateparks | Morado, verde veneno, azul profundo, rojo ladrillo | Casas tomadas, underpasses, parques rotos |
| **Sin-Legaja** | Sin uniforme, mezcla ecléctica de todas las facciones | Arcoíris caótico, cada jugador define | Zona Neutral: mercado, rooftops, metro |

---

## 6. DIRECCIÓN DE SONIDO Y MÚSICA

### Música Ambiental por Zona
| Zona | Género | Referencia |
|------|--------|------------|
| **Yakuza** | City pop japonés 80s, bit-crushed, saxofón melancólico | Plastic Love pero en 8-bit |
| **Cártel** | Corridos tumbados, banda sinaloense, narcocorridos | Peso Pluma meets chiptune |
| **Mafia** | Italo-disco oscuro, jazz nocturno, órgano de iglesia | Giorgio Moroder meets giallo |
| **Policía** | Radio estática, música de ascensor, metal industrial en combate | Silent Hill sirenas meets DOOM |
| **Cholos** | Hip-hop old school, phonk latino, scratch de discos | Cypress Hill meets phonk brasileño |
| **Sin-Legaja** | Lo que el jugador ponga en su radio personal | Playlist del jugador |

### SFX
- Pasos diferenciados por superficie (charco, concreto, tierra, metal).
- Click metálico del inventario (estilo RE4).
- Spray de lata en paredes.
- Sirenas distorsionadas.
- Recargas con sonido metálico contundente.

### Voces
- Sin doblaje completo. Los personajes emiten sonidos característicos por facción:
  - Yakuza: guturales limpios y secos.
  - Narco: tonadas norteñas distorsionadas.
  - Mafia: gruñidos con acento italiano.
  - Policía: static de radio y ladridos de megáfono.
  - Cholos: beats de boca y "ey, carnal".
- Estilo Banjo-Kazooie / Undertale.

---

## 7. ESTÉTICA "ANTIGUOSA" (Opcional)

Filtros opcionales activables por el jugador:
1. **Scanlines CRT:** Bandas horizontales con curvatura de pantalla.
2. **Dithering visible:** En sombras, visible como en PS1.
3. **CRT Bloom:** Las luces neón sangran ligeramente.
4. **Bajas físicas:** Modo para hardware modesto que reduce todavía más el poligonaje.

---

## 8. REFERENCIAS VISUALES

| Referencia | Qué Tomamos |
|------------|-------------|
| **MU Online** | Modelado 3D low poly, armaduras brillantes por tier, sensación nostálgica |
| **GTA San Andreas** | Paleta cálida, escala de ciudad, vehículos reconocibles |
| **Resident Evil 4** | Diseño de inventario grid, paleta de menús oscura |
| **Graffiti Constructor (Itch.io)** | Tags con bordes de spray, colores saturados sobre fondos oscuros |
| **Filthy and Guilty (Behance)** | Personajes caricaturescos pero peligrosos |
| **Zelda: Wind Waker** | Cell shading aplicado a un mundo oscuro (inspiración de contraste) |

---

*«No es realista. No es cartoon. Es el punto exacto donde MU Online se toma un tequila con GTA SA en un callejón con neón.»*
