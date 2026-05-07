# BARRIO SIN LEY ONLINE (BSLO)
## Guia de Tipografia — Godot 4 Importacion
**Version:** 2.0

---

> *"La tipografia no es solo letras. Es la voz del juego impresa en pixeles."*

---

## Indice

1. [Press Start 2P — Titulos/Graffiti](#1-press-start-2p--titulosgraffiti)
2. [Serif Clasica — Dialogos Mafia/Yakuza](#2-serif-clasica--dialogos-mafiayakuza)
3. [Sans-Serif Gruesa — Dialogos Callejeros](#3-sans-serif-gruesa--dialogos-callejeros)
4. [Consola Verde — Notificaciones del Sistema](#4-consola-verde--notificaciones-del-sistema)
5. [Resumen de Importacion](#5-resumen-de-importacion-en-godot-4)
6. [Configuracion de UI por Contexto](#6-configuracion-de-ui-por-contexto)

---

## 1. Press Start 2P — Titulos/Graffiti

**Uso en BSLO:**
- Titulos de pantallas (menu principal, carga, opciones)
- Texto de graffiti en el mundo
- Nombres de habilidades en el Skill Tree
- Letras de canciones de karaoke
- Tags de crews en el mapa

**Fuente:** Press Start 2P
**Peso:** Regular (solo existe un peso)
**Licencia:** Open Font License (SIL OFL)
**Descarga:** https://fonts.google.com/specimen/Press+Start+2P

### Importacion a Godot 4

1. Descargar el archivo TTF desde Google Fonts.
2. Colocar `PressStart2P-Regular.ttf` en: `godot/assets/fonts/PressStart2P/`
3. En Godot, crear un recurso `FontFile`:
   - En el Dock de Archivos, navegar a `res://assets/fonts/PressStart2P/`
   - Click derecho en `PressStart2P-Regular.ttf` → `New Resource...` → `FontFile`
   - O alternativamente, cargar directamente en un control Label usando la opcion "Load" en el inspector.

4. Configuracion recomendada en el Inspector del FontFile:
   - `Antialiasing`: Gray (suavizado suave, evita bordes pixelados excesivos)
   - `Generate Mipmaps`: On (para escalados en graffiti del mundo)
   - `Fallbacks`: Agregar una fuente sans-serif generica (Arial, Verdana) como fallback para caracteres no soportados
   - `Hinting`: Light (mantiene la estetica pixel pero legible)

5. Para efectos de graffiti (spray):
   - Crear un `ShaderMaterial` para el Label
   - Aplicar variacion de color RGB splitting sutil
   - Usar modulate con opacidad variable
   - No usar outline en esta fuente; la fuente ya es gruesa por diseno

### Tamanos Recomendados
| Contexto | Tamano |
|----------|--------|
| Menu principal titulo | 48-64 px |
| Subtitulos | 24-32 px |
| Graffiti en mundo | 128-256 px (escalado en 3D) |
| Nombres de habilidad | 18-24 px |
| Tags de crew | 16-20 px |

---

## 2. Serif Clasica — Dialogos Mafia/Yakuza

**Uso en BSLO:**
- Dialogos de NPCs Mafia (Don Vincenzo, Francesca, Padre Matteo)
- Dialogos de NPCs Yakuza (Kazuto, Yuki, Kenji)
- Cartas, documentos formales, contratos en el juego
- Interfaz del inventario (descripciones de items "elegantes")
- Menu de pausa (opciones, creditos)

**Fuente Recomendada:** Playfair Display (Google Fonts)
**Pesos:** Regular (400), Italic (400), Bold (700)
**Licencia:** Open Font License
**Descarga:** https://fonts.google.com/specimen/Playfair+Display

**Alternativa:** Crimson Text (mas clasico, mejor para dialogos largos)
**Descarga:** https://fonts.google.com/specimen/Crimson+Text

### Importacion a Godot 4

1. Descargar Playfair Display (seleccionar Regular, Italic, Bold).
2. Colocar en: `godot/assets/fonts/PlayfairDisplay/`
3. Crear FontFile para cada peso:
   - `PlayfairDisplay-Regular.ttf`
   - `PlayfairDisplay-Italic.ttf`
   - `PlayfairDisplay-Bold.ttf`
4. Usar variaciones para dialogos:
   - Italic: Pensamientos internos, flashbacks, susurros
   - Bold: Enfasis en palabras clave, gritos, nombres

5. Configuracion:
   - `Antialiasing`: Gray
   - `Hinting`: Normal (buena legibilidad en dialogos)
   - `MSDF`: Preferiblemente ON (para escalado en 3D en dialogos sobre NPCs)
   - `Fallbacks`: Times New Roman o Liberation Serif

6. Para el efecto "formal mafioso":
   - Anadir `outline_size: 1` con color negro
   - Modulate: `#E0E0E0` (Blanco Fantasma de la paleta)

### Tamanos Recomendados
| Contexto | Tamano |
|----------|--------|
| Dialogo de NPC | 22-28 px |
| Nombre de NPC | 18-22 px (Bold) |
| Cartas/Documentos | 16-20 px |
| Subtitulos de cinematica | 20-24 px |

---

## 3. Sans-Serif Gruesa — Dialogos Callejeros

**Uso en BSLO:**
- Dialogos de NPCs Cartel (Compa Chuy, Narco Filosofico)
- Dialogos de NPCs Cholos (Abuela, Cholo Meta, La Negra)
- Dialogos de NPCs Policia corrupta (Morales, El Rata)
- Chat general, chat de crew, mensajes de jugador
- Tooltips de items, descripciones de misiones
- Dialogos de NPCs Sin-Legaja (Vendedor, Zero, La Loba)

**Fuente Recomendada:** Barlow (Google Fonts)
**Pesos:** SemiBold (600), Bold (700), ExtraBold (800)
**Licencia:** Open Font License
**Descarga:** https://fonts.google.com/specimen/Barlow

**Alternativa:** Rubik (similar, buena legibilidad en pantalla)
**Descarga:** https://fonts.google.com/specimen/Rubik

### Importacion a Godot 4

1. Descargar Barlow (pesos 600, 700, 800).
2. Colocar en: `godot/assets/fonts/Barlow/`
3. Crear FontFile para cada peso.
4. Configuracion:
   - `Antialiasing`: Gray
   - `Hinting`: Light (mantiene el feeling callejero)
   - `MSDF`: ON (para dialogos en el mundo 3D)
   - `Fallbacks`: Arial

5. Para el efecto "callejero":
   - Modulate: varia segun faccion:
     - Cartel: `#FF6600` (Naranja Quemado)
     - Cholos: `#FF00AA` (Spray Magenta) o `#00FF00` (Verde Toxic)
     - Policia corrupta: `#FFCC00` (Amarillo Policia)
     - Sin-Legaja: variable por personaje
   - Sin outline (mantener limpio)

### Tamanos Recomendados
| Contexto | Tamano |
|----------|--------|
| Dialogo callejero | 20-26 px |
| Chat general | 14-16 px |
| Tooltips | 14-18 px |
| Mensajes de sistema | 14 px |

---

## 4. Consola Verde — Notificaciones del Sistema

**Uso en BSLO:**
- Mensajes de muerte ("Has muerto. Respiras... o intentas hacerlo.")
- Notificaciones de loot ("Encontraste: 1 foto de su ex, 1 navaja, y arrepentimientos.")
- Anuncios server-wide ("Atencion barrio: La Purga comienza en 10 minutos.")
- Mensajes de wanted ("1 estrella: Tienes cara de culpable. Es decir, tienes cara.")
- Logs de hackeo y sistema

**Fuente Recomendada:** JetBrains Mono (Google Fonts)
**Pesos:** Regular (400), Bold (700)
**Licencia:** Open Font License
**Descarga:** https://fonts.google.com/specimen/JetBrains+Mono

**Alternativa:** Fira Code (programming ligatures, para efectos de hackeo)
**Descarga:** https://fonts.google.com/specimen/Fira+Code

### Importacion a Godot 4

1. Descargar JetBrains Mono.
2. Colocar en: `godot/assets/fonts/JetBrainsMono/`
3. Crear FontFile.
4. Configuracion:
   - `Antialiasing`: Gray
   - `Hinting`: Normal
   - `MSDF`: OFF (no se escala en 3D, solo UI)
   - `Fallbacks`: Courier New

5. Para el efecto "consola":
   - Modulate: `#00FF00` (Verde fosforescente clasico de terminal)
   - Anadir `ShaderMaterial` con efecto de parpadeo sutil:
     - Usar `TIME` del shader para modificar `modulate.a` entre 0.8 y 1.0
     - Opcional: scanlines sutiles via shader
   - Fondo del Label: `#0A0A0A` con 80% opacidad (efecto terminal retro)

6. Efecto de escritura:
   - Usar el nodo `RichTextLabel` con `percent_visible` para animacion de "escribiendo..."
   - Velocidad: 30-50 caracteres por segundo

### Tamanos Recomendados
| Contexto | Tamano |
|----------|--------|
| Mensaje de muerte | 18-22 px |
| Notificaciones | 14-16 px |
| Anuncios server | 24-28 px |
| Logs de hackeo | 12-14 px |

---

## 5. Resumen de Importacion en Godot 4

### Paso a paso para cada fuente:

1. **Descargar el TTF** de Google Fonts (https://fonts.google.com/)
2. **Crear la estructura de carpetas:**
   ```
   godot/assets/fonts/
   ├── PressStart2P/
   │   └── PressStart2P-Regular.ttf
   ├── PlayfairDisplay/
   │   ├── PlayfairDisplay-Regular.ttf
   │   ├── PlayfairDisplay-Italic.ttf
   │   └── PlayfairDisplay-Bold.ttf
   ├── Barlow/
   │   ├── Barlow-SemiBold.ttf
   │   ├── Barlow-Bold.ttf
   │   └── Barlow-ExtraBold.ttf
   └── JetBrainsMono/
       ├── JetBrainsMono-Regular.ttf
       └── JetBrainsMono-Bold.ttf
   ```
3. **Importar a Godot:**
   - Los archivos .ttf se importan automaticamente
   - Para usarlos en UI: seleccionar el control Label, ir a la propiedad `Label > Theme Overrides > Fonts > Font` y elegir "Load" y seleccionar el .ttf
   - Para usarlos en 3D (dialogos de NPC): usar nodo `Label3D`, cargar la fuente en `Label3D > Font`
4. **Crear Theme global (opcional pero recomendado):**
   - Crear recurso `Theme` en `res://assets/fonts/bslo_theme.tres`
   - Asignar fuentes por tipo de control:
     - `Label`: Barlow SemiBold
     - `Button`: Press Start 2P (small), Barlow Bold (normal)
     - `RichTextLabel`: JetBrains Mono (sistema) o Playfair Display (narrativa)
     - `LineEdit`: JetBrains Mono
     - `Panel`: no usa fuente (color de fondo)

### Archivos .ttf vs .otf
- **Usar .ttf** para todas las fuentes de BSLO
- .otf tiene mejor soporte tipografico pero Godot 4 maneja .ttf mas establemente
- Todas las fuentes recomendadas estan disponibles en .ttf desde Google Fonts

---

## 6. Configuracion de UI por Contexto

### Menu Principal
- **Titulo "BARRIO SIN LEY ONLINE"**: Press Start 2P, 48px, modulate #FF00AA (Spray Magenta), outline negro 2px
- **Botones**: Press Start 2P, 20px, modulate #00FFFF (Cian de Barrio)
- **Subtitulo "Version 2.0"**: JetBrains Mono, 14px, modulate #00FF00

### HUD Principal
- **Vida/Stamina**: Barlow ExtraBold, 16px, valores en blanco
- **Hotbar skills**: Press Start 2P, 12px, color de faccion
- **Wanted estrellas**: JetBrains Mono, 24px, modulate #FFCC00
- **Minimapa texto**: Barlow Bold, 11px

### Dialogos de NPC
- **Nombre NPC**: Barlow Bold, 22px, color varia por faccion
- **Texto dialogo**: Segun faccion:
  - Yakuza: Playfair Display, 24px, #E0E0E0
  - Mafia: Playfair Display, 24px, #E0E0E0
  - Cartel: Barlow, 24px, #FF6600
  - Cholos: Barlow, 24px, #FF00AA
  - Policia: Barlow, 24px, #FFCC00
  - Sin-Legaja: Barlow, 22px, #00FFFF
- **Opciones de respuesta**: Barlow SemiBold, 18px, #FFFFFF

### Sistema/Notificaciones
- **Mensaje de muerte**: JetBrains Mono, 20px, #00FF00, fondo #0A0A0A 80%
- **Notificacion de loot**: JetBrains Mono, 16px, #FFFFFF
- **Anuncio server**: JetBrains Mono Bold, 24px, #FF00AA, con parpadeo
- **Chat**: JetBrains Mono, 14px

### Graffiti / Murales (3D)
- **Tags de graffiti en paredes**: Press Start 2P, escalado 128-256px, modulate color de crew
- **Nombres de distritos**: Press Start 2P, 64px, modulate #FF00AA
- **Dialogos 3D sobre NPCs**: Playfair Display o Barlow segun faccion, 32px

---

> *"Las letras pueden ser balas si las pones en el lugar correcto."*
> — Graffiti en una pared del Distrito Dragon.

---

### Configuracion Rapida en Godot 4 (Codigo GDScript)

```
# Ejemplo: Configurar fuente para un Label
var font_path = "res://assets/fonts/PressStart2P/PressStart2P-Regular.ttf"
var font_file = FontFile.new()
font_file.font_data = load(font_path)
$Label.add_theme_font_override("font", font_file)
$Label.add_theme_font_size_override("font_size", 24)
$Label.modulate = Color("#FF00AA")

# Ejemplo: Configurar fuente para Label3D (dialogo sobre NPC)
var npc_font_path = "res://assets/fonts/PlayfairDisplay/PlayfairDisplay-Regular.ttf"
var npc_font = FontFile.new()
npc_font.font_data = load(npc_font_path)
$Label3D.font = npc_font
$Label3D.font_size = 32
$Label3D.modulate = Color("#E0E0E0")
```
