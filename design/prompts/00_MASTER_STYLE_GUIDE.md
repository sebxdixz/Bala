# BSLO — MASTER STYLE GUIDE PARA GENERACION DE ASSETS
## design/prompts/00_MASTER_STYLE_GUIDE.md
**Version:** 2.0 | **Herramienta Primaria:** GPT Image 2 (DALL-E 4 / GPT-4o Image Gen)

---

## 1. TOKEN FIJO DE ESTILO (STYLE TOKEN)

Este bloque DEBE incluirse al inicio de TODO prompt de imagen. Es el ancla visual del proyecto.

```
STYLE_TOKEN = "3D low poly video game asset, cell shaded, flat colors, chunky geometry,
clean silhouette, MU Online aesthetic, PS2-era retro 3D charm, no realistic textures,
simple materials, bold color blocking, outline on edges, isometric-friendly proportions,
top-down friendly, Godot Engine 4 compatible, game-ready asset, isolated on transparent background"
```

**Variante para UI/Iconos:**
```
STYLE_TOKEN_UI = "pixel art icon, 64x64 to 256x256, flat colors, bold silhouette,
high contrast, 8-bit retro aesthetic, video game UI element, graffiti spray paint edges,
neon accent colors, dark background compatible, clean readable at small sizes"
```

**Variante para Entornos:**
```
STYLE_TOKEN_ENV = "3D low poly environment, cell shaded, flat color palette,
stylized architecture, chunky buildings, retro 3D aesthetic, MU Online meets GTA SA,
neon lights, atmospheric fog, isometric camera friendly, Godot 4 game world"
```

---

## 2. PALETA GLOBAL (SIEMPRE A MANO)

### Podrido / Base
| Token | Hex | Uso |
|-------|-----|-----|
| `#2B2D2F` | Asfalto Podrido | Fondos, calles |
| `#4A4E4D` | Humedad de Pared | Edificios, concreto |
| `#8B5A2B` | Oxido de Neon | Metales, tuberias |
| `#2E8B57` | Verde Toxico | Inventario, safe houses |
| `#6B2D2D` | Sangre Seca | Dano critico, alertas |

### Neon / Accion
| Token | Hex | Uso |
|-------|-----|-----|
| `#FF00AA` | Spray Magenta | Tags, epico, habilidades |
| `#00FFFF` | Cian de Barrio | Aliados, waypoints |
| `#FF6600` | Naranja Quemado | Misiones, fuego |
| `#FFCC00` | Amarillo Policia | Wanted, alertas |
| `#E0E0E0` | Blanco Fantasma | Texto principal |

### Paletas de RAREZA de items
| Tier | Borde Color |
|------|------------|
| Basura | `#888888` gris |
| Comun | `#FFFFFF` blanco |
| Incomun | `#2ECC40` verde |
| Raro | `#0074D9` azul |
| Epico | `#FF00AA` magenta |
| Legendario | `#FFD700` dorado |
| Maldito | `#8B0000` rojo oscuro |

---

## 3. REGLAS DE PROMPT POR TIPO DE ASSET

### 3.1 Personajes (Character Concept Sheet)
```
Prompt Structure:
[STYLE_TOKEN] [FACTION_STYLE] [CLASS_ARCHETYPE] [SPECIFIC_DETAILS]
full body front view, A-pose or T-pose, 3/4 profile sheet, concept art,
character design sheet, multiple views, reference sheet for 3D modeling,
[PALETTE], [KEY_PROPS], [PERSONALITY_TRAIT]
```

### 3.2 Armas/Props
```
Prompt Structure:
[STYLE_TOKEN] [WEAPON_TYPE], [MATERIAL], [SCALE_REFERENCE],
diagonal angle, 3D render style, game prop, [PALETTE],
isolated, no background, [SPECIAL_FX]
```

### 3.3 Vehiculos
```
Prompt Structure:
[STYLE_TOKEN] [VEHICLE_TYPE], [ERA_STYLE], [FACTION_DECALS],
side profile + 3/4 angle, game vehicle asset, [PALETTE],
[SCALE], [WEAR_AND_TEAR]
```

### 3.4 Entornos/Distritos
```
Prompt Structure:
[STYLE_TOKEN_ENV] [DISTRICT_NAME], [ARCHITECTURE_STYLE], [ATMOSPHERE],
wide shot establishing view, [LIGHTING], [WEATHER],
game environment, [LANDMARKS], [PALETTE], [ACTIVITIES]
```

### 3.5 UI / HUD
```
Prompt Structure:
[STYLE_TOKEN_UI] [UI_ELEMENT], [CONTEXT], [COLORS],
game UI design, [TYPOGRAPHY], [LAYOUT], [STATE]
```

---

## 4. PARAMETROS GPT IMAGE 2 / DALL-E 4

### Configuracion Optima para BSLO
```json
{
  "model": "dall-e-3",  // o "gpt-image-2"
  "size": "1024x1024",
  "quality": "standard",  // "hd" para assets finales
  "style": "vivid",      // colores mas saturados para low poly
  "response_format": "b64_json",  // para guardar directo
  "n": 1
}
```

### Para Concept Art / Reference Sheets
```json
{
  "size": "1792x1024",  // wide para sheets de personajes
  "quality": "hd",
  "style": "vivid"
}
```

### Para Iconos (UI)
```json
{
  "size": "1024x1024",
  "quality": "hd",
  "style": "natural"  // menos saturado para iconos funcionales
}
```

---

## 5. CONVENCION DE NOMBRES DE ARCHIVOS

```
[Categoria]_[Facción]_[Tipo]_[Detalle]_[Numero].png

Ejemplos:
chr_yakuza_boxeador_male_01.png
env_cartel_plaza_mercado_01.png
wpn_mafia_tommygun_01.png
ui_hud_vida_heart_01.png
veh_sedan_policia_01.png
ico_skill_boxeador_jab_01.png
npc_don_vincenzo_mafia_01.png
```

---

## 6. WORKFLOW DE GENERACION POR LOTES

### Fase 1: Concept Art (GPT Image 2)
1. Generar 1 sheet de concepto por faccion (6 total)
2. Generar 1 sheet de concepto por clase (14 base + 6 elite = 20 total)
3. Generar 1 ambiente por tipo de distrito (24 total)
4. Revisar, seleccionar, iterar

### Fase 2: Props e Iconos (GPT Image 2)
1. Generar armas (30+)
2. Generar consumibles (15+)
3. Generar iconos de habilidades (70+)
4. Generar iconos de UI (40+)

### Fase 3: Modelado 3D (Meshy / Tripo / Spline)
1. Subir concept art como referencia
2. Generar modelos low poly (<2000 tris)
3. Auto-riggear con Mixamo o similares
4. Aplicar shader low_poly_outline.gdshader (ya existe en godot/shaders/)

### Fase 4: Texturas (GPT Image 2 + upscale)
1. Generar texturas de superficies desde prompts
2. Procesar a 512x512 o 1024x1024
3. Aplicar nearest-neighbor filtering (ya configurado en project.godot)

### Fase 5: UI Implementation (Godot)
1. Implementar temas con las fuentes (ver FONT_GUIDE.md)
2. Armar escenas .tscn con las texturas generadas
3. Aplicar paletas de color por contexto

---

## 7. NOTAS CRITICAS PARA EL GENERADOR

1. **TODOS los personajes deben estar en T-pose o A-pose** - son para modelado 3D posterior.
2. **Siempre pedir "isolated on transparent background"** - facilita el recorte.
3. **NUNCA pedir armas realistas** - siempre "stylized", "video game prop", "low poly".
4. **Los entornos deben ser "establishing shots"** - vista amplia, no primeros planos.
5. **Las paletas DEBEN coincidir con las definidas en 02_Arte.md** - consistencia ante todo.
6. **Para NPCs, incluir personality traits en el prompt** - la IA necesita character, no solo ropa.
7. **Siempre mencionar "Godot Engine" o "game-ready"** - ayuda a la IA a entender el contexto 3D.

---

## 8. HERRAMIENTAS DEL STACK

| Herramienta | Uso | Costo Aprox |
|-------------|-----|-------------|
| **GPT Image 2 (OpenAI)** | Concept art, texturas, iconos, UI mockups | ~$0.04/image (std), ~$0.08/image (HD) |
| **Meshy.ai** | Image-to-3D low poly, texturizado automatico | ~$3-5/model (pro) |
| **Spline AI** | 3D modeling asistido, escenas | ~$10/mes |
| **Tripo3D** | Image-to-3D (alternativa Meshy) | ~$2-4/model |
| **Mixamo** | Auto-rigging, animaciones base | Gratis |
| **Godot 4** | Engine, shaders, scenes, integration | Gratis |
| **Blender** | Limpieza de modelos, UVs, optimizacion | Gratis |

### Costo Estimado Total (Assets Completos)
- **Concept Art (GPT Image 2):** ~250 imagenes x $0.04 = **~$10 USD**
- **Modelos 3D (Meshy):** ~50 modelos x $3 = **~$150 USD**
- **Total estimado:** **~$160-200 USD** para todos los assets visuales base.

---

*<<Este documento es el ancla. Todo prompt en los archivos siguientes asume que ya leiste esto.>>*
