# 🎮 BARRIO SIN LEY ONLINE (BSLO)
## 01 - Visión General & Estética Visual
**Versión:** 1.0 | **Género:** MMO Action-RPG de Mundo Abierto | **Perspectiva:** 1ª y 3ª Persona

---

## 1. VISIÓN EJECUTIVA

**Barrio Sin Ley Online** es un MMO RPG de mundo abierto ambientado en una metrópolis decadente donde bandas callejeras, mafias internacionales, cárteles narco, yakuza y policías corruptos luchan por el control territorial. El juego mezcla mecánicas clásicas de MMORPG (mazmorras, raids, clases, loot, progresión por niveles) con la estética cruda del crimen organizado, el humor callejero y la cultura popular urbana de Latinoamérica, Asia y Europa.

La propuesta visual es **retro-nostálgica pero pulida**: pixel art de alta resolución (32-bit style) con iluminación dinámica moderna, atmósferas de ciudad sucia y neón, y una interfaz de usuario que mezcla graffiti digital con sistemas de inventario clásicos de survival horror. La estética aspira a ser "media antiguosa" — como si encontraras un disco duro en un cyber café de 2004 que tiene instalado el mejor juego del mundo que nunca existió.

---

## 2. PALABRAS CLAVE DE ESTÉTICA

> **"Gritty Pixel. Callejón Sucio. Neón Oxidado. Graffiti Digital. CRT Vibes. Humor Tóxico."**

- **Pixel Art Polished:** No es 8-bit simple. Es pixel art detallado con dithering, sombreado y efectos de luz volumétrica. Referencia: *Octopath Traveler* meets *GTA 2* meets *Filthy and Guilty*.
- **Atmósfera de Callejón:** Calles estrechas, cables eléctricos colgando, paredes con humedad, grafitis por todos lados, basura, neón parpadeante, puestos callejeros.
- **UI Graffiti-Digital:** Cada elemento de interfaz tiene borrones de spray, etiquetas de barrio, tags de pandilla. Las fuentes son pixeladas pero con actitud: serif en los diálogos de la mafia, sans-serif agresiva para las notificaciones de PVP, tags de colores para los chats de banda.
- **Paleta Dual:** El mundo es gris-marrón-verde podrido (como el inventario de Resident Evil), pero los elementos interactivos brillan en magenta, cian y naranja neón.

---

## 3. REFERENCIAS VISUALES DIRECTAS

| Referencia | Qué Tomamos | Por Qué |
|------------|-------------|---------|
| **GTA 2 (Pixel Art)** | Cámara top-down/ángulo bajo, paleta cálida, coches pixelados, caos urbano. | Define la energía caótica de la ciudad. |
| **Resident Evil 4 (Inventario)** | Sistema de malla grid "Tetris", fondo verde oscuro, texturas de cuero/metal, ítems que ocupan espacio físico real. | Da tensión al manejo de recursos y nostalgia mecánica. |
| **Pixel Mafia / Manila Alley** | Callejones hiperdetallados, luz cenital filtrada, basura como storytelling ambiental, vehículos abandonados. | El nivel de detalle aspiracional para las zonas del juego. |
| **Graffiti Constructor (Itch.io)** | Tags pixelados con bordes de spray, colores saturados sobre fondos oscuros, estética de "barrio digital". | La biblia visual para toda la UI del juego. |
| **Filthy and Guilty (Behance)** | Personajes con actitud, policía gordo y corrupto, yakuza con traje blanco, prostituta con pistola. | El tono de personajes: caricaturesco pero peligroso. |
| **Save Room (Polygon)** | Oscuridad, sonido de corazón, menús que *pesan*, diseño industrial-militar. | Para los menús de inventario y safe houses. |
| **Kasuma Kiryu Pixel Art** | Traje blanco, pose de pelea, fondo negro puro, actitud imponente en 64x64 píxeles. | Referencia para el rigging de personajes yakuza. |

### Imágenes de Referencia Descargadas
```
./pinterest_images/
├── 3_GTA_2_Style_Pixel_Art_Game_Screenshot.png    [Estilo visual base]
├── 7_PIXEL_MAFIA_Pixel_Mafia_Manila_Alle.png       [Detalle ambiental]
├── 8_Save_Room_is_a_Resident_Evil_4_style.png      [UI Inventario]
├── 1_Free_Graffiti_Constructor_by_Free.png         [UI Graffiti Tags]
├── 2_Free_Gangster_Pixel_Characters_Pack.png       [Diseño de personajes]
├── 9_Free_Gangster_Pixel_Character_Sprite.png      [Animación sprite]
├── 6_Kasuma_Kiryu_Medium_Pixel_Art_by.png          [Referencia Yakuza]
└── 3_Filthy_and_Guilty_Pixel_Art_Behanc.gif        [Tonos de NPCs]
```

---

## 4. PALETA DE COLORES OFICIAL

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
| **Amarillo Policía** | `#FFCC00` | Nivel de búsqueda, polícia, alertas |
| **Blanco Fantasma** | `#E0E0E0` | Texto principal, diálogos de mafia/yakuza |

---

## 5. ESTILO DE CÁMARA: 1ª Y 3ª PERSONA

### Tercera Persona (Default)
- **Vista:** Cámara a la espalda del personaje, ligeramente elevada (como *GTA SA* pero con ángulo más cinematográfico).
- **Distancia:** 4-6 metros del personaje.
- **Toques:** Cuando entras en zonas de graffiti, la cámara hace un *zoom lento* hacia el arte de la pared. En combate cuerpo a cuerpo, se acerca a la cintura para mostrar los detalles del sprite.
- **Estética Sprite 3D:** Los personajes son sprites 2D en planos 3D (billboards que rotan según la cámara) para mantener la estética pixel art en perspectiva moderna. Referencia técnica: *Octopath Traveler*.

### Primera Persona (Modo Combate / Exploración Interior)
- **Activación:** Toggle manual o automático al entrar en interiores estrechos (safe houses, discotecas, callejones).
- **Vista:** Ojos del personaje. Los brazos y armas son sprites pixelados en primer plano (como *Doom* o *Wolfenstein* pero con estilo moderno).
- **Inventario:** Al abrir el inventario en 1ª persona, la pantalla se oscurece y aparece la malla "Tetris" de Resident Evil, como si el personaje literalmente estuviera revisando su maletín en tiempo real.
- **Graffiti POV:** Al hacer graffiti, la vista baja al bote de spray en tu mano y ves cómo la pintura sale en pixel-perfect sobre la pared.

---

## 6. DIRECCIÓN DE ARTE POR ZONAS

| Zona | Estilo Visual | Paleta Dominante |
|------|--------------|-------------------|
| **El Distrito Yakuza** | Limpio, minimalista, edificios de vidrio oscuro, neón rojo puro, calles mojadas por la lluvia perpetua. | Negro, rojo, blanco, gris plata. |
| **Barrio Narco** | Casas coloridas pero descuidadas, paredes con *narcomantas* pixeladas, calles de tierra, pick-ups y motos. | Tierra, rosa mexicano, verde aguacate, oro. |
| **Zona Mafia Italiana** | Ladrillo viejo, restaurantes con toldos a rayas, farolas de gas, niebla, trajes caros. | Marrón ladrillo, verde botella, crema, negro carbón. |
| **Comisaría/Policía** | Fluorescente blanco-azulado, escarcha en las ventanas, papeles tirados, sillas rotas. | Blanco frío, azul policial, gris linóleo. |
| **Underground / Safe Houses** | Oscuro, velas, tuberías, monitores CRT parpadeando, pósters de reguetón pixelados. | Verde terminal, ámbar, negro total. |
| **Zona Neutral (El Mercado)** | Caos de colores, puestos de comida, gente de todas las facciones, graffiti superpuesto. | Todos los colores neón mezclados. |

---

## 7. INTERFAZ DE USUARIO (UI/UX)

### HUD Principal
- **Esquinas inferiores:** Malla de inventario rápido (4 slots visibles) con borde de spray magenta si eres criminal, o azul policial si eres ley.
- **Esquina superior izquierda:** Barra de vida en forma de corazón pixelado que se agrieta (no solo baja, se *rompe* visualmente).
- **Esquina superior derecha:** Nivel de Búsqueda (1-5 estrellas) representado como botes de spray pintados en una pared del HUD.
- **Centro inferior:** Diálogos con fuente pixelada y retratos estilo *Filthy and Guilty* — caricaturescos pero expresivos.

### Menús
- **Inventario (Attache Case System):** Fondo verde oscuro con textura de nylon táctico. Items como pistolas ocupan 2x3 celdas, una bolsita de coca 1x1, una escopeta 2x5. Rotación de ítems permitida (R key).
- **Mapa:** Papel arrugado con manchas de café. Las zonas controladas por tu banda tienen tu tag de graffiti. Las zonas enemigas tienen su tag tachado.
- **Skill Tree:** Representado como un muro de graffiti donde cada habilidad desbloqueada es un nuevo tag que aparece con animación de spray.

### Tipografía
- **Títulos / Graffiti:** "Press Start 2P" customizado con efecto de spray.
- **Diálogos Mafia/Yakuza:** Serif clásica pixelada (como en juegos de SNES RPGs), representa formalidad y poder.
- **Diálogos Callejeros/Narcos:** Sans-serif gruesa, con errores ortográficos intencionales y slang.
- **Notificaciones del Sistema:** Fuente terminal, verde fosforescente, parpadeo sutil.

---

## 8. SONIDO Y MÚSICA (Dirección General)

- **Música de Barrio:** Phonk, reguetón retro, trap latino, city pop japonés para la zona yakuza, Italo-disco oscuro para la mafia. Todo con *bit-crushing* sutil para sonar como si viniera de un cassette encontrado en la calle.
- **SFX:** Sonidos de pasos en charcos, el *click* metálico del inventario de Resident Evil, spray de lata en las paredes, sirenas distorsionadas.
- **Voces:** No hay doblaje completo. Los personajes "hablan" en bocadillos con sonidos tipo *Banjo-Kazooie* o *Undertale* (ruidos característicos por facción: la Yakuza hace sonidos guturales limpios, los narcos tienen tonadas norteñas distorsionadas, los policías tienen static de radio).

---

## 9. ESTÉTICA "ANTIGUOSA" ESPECÍFICA

Para lograr el objetivo de que parezca un juego "de antes pero mejorado":

1. **Opción de Scanlines:** Filtro CRT opcional con curvatura de pantalla leve, bandas de refresco y bloom en las luces neón.
2. **Dithering Visible:** En las sombras, se usa dithering de Bayer a propósito, visible, como en los juegos de PS1.
3. **Low-Poly Backgrounds:** Aunque los personajes sean sprites, los fondos 3D tienen poligonaje bajo intencional con texturas pixeladas.
4. **Load Screens Fake:** Pantallas de carga que simulan un Windows 98 pirata con barra de progreso verde y texto "INSTALANDO BARRIO_SIN_LEY.EXE..."
5. **Cheat Codes como Mecánica Social:** Los códigos clásicos (Konami code, etc.) son *emotes* que tu personaje puede hacer en la calle para reconocerse con otros jugadores de la vieja escuela.

---

## 10. MANTRA DE DISEÑO

> *"Que se vea como lo que encontrarías en un cyber de 2004 en Iztapalapa o La Boca, pero con iluminación global de 2026."*

Todo debe sentirse:
- **Callejero:** No hay limpieza, no hay orden perfecto, hay *vida*.
- **Nostálgico:** El pixel art no es un filtro, es la lengua materna del juego.
- **Peligroso pero divertido:** Como reírse en un funeral. El humor está en el contraste entre la violencia del setting y la ridiculez de los personajes.
- **Propio:** Cada banda debe tener su estética tan definida que un screenshot de 10 píxeles te diga dónde estás.

---

*Documento Base para todo el proyecto. Las decisiones estéticas aquí definidas son inmutables sin aprobación del director creativo.*
