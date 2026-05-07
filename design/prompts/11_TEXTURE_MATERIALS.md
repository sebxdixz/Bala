# BSLO — PROMPTS DE TEXTURAS Y MATERIALES
## design/prompts/11_TEXTURE_MATERIALS.md
**Version:** 2.0 | **Uso:** Texturas tileables para superficies 3D en Godot 4

---

> **STYLE_TOKEN_TEX:** "seamless tileable texture, low poly video game, flat colors, stylized, hand-painted look, no photorealism, cartoon game surface, 512x512, Godot Engine 4, PBR simplified, albedo only"

---

## 1. SUPERFICIES DE SUELO

### Asfalto Mojado (Yakuza / Lluvia)
```
{STYLE_TOKEN_TEX} wet asphalt ground texture, dark gray with puddle reflections,
neon light reflections in puddles, rain wet look, seamless tile,
city street ground, stylized not realistic, flat color blocks
```

### Tierra Roja (Cartel)
```
{STYLE_TOKEN_TEX} red dirt ground texture, tierra roja, dry cracked earth,
warm terracotta color, stylized flat, light variations,
rural Mexico dirt road, seamless tile, hand-painted look
```

### Adoquin Mojado (Mafia)
```
{STYLE_TOKEN_TEX} wet cobblestone ground texture, old European street,
dark gray stones with moss between, damp fog look,
old world street, seamless tile, flat stylized colors
```

### Hormigon Gris (Policia)
```
{STYLE_TOKEN_TEX} gray concrete floor texture, industrial linoleum,
slight cracks and wear, institutional flooring,
police station floor, seamless tile, flat gray tones
```

### Tierra con Graffiti (Cholos)
```
{STYLE_TOKEN_TEX} cracked concrete ground with graffiti paint splatters,
colorful spray paint on gray, street art floor,
abandoned urban ground, seamless tile, vibrant accents
```

### Concreto de Acera (Generico / Centro)
```
{STYLE_TOKEN_TEX} sidewalk concrete texture, grid lines for tiles,
urban pavement, slight dirt weathering, seamless tile,
neutral city ground, flat grays
```

---

## 2. SUPERFICIES DE PARED

### Vidrio Oscuro Corporativo (Yakuza)
```
{STYLE_TOKEN_TEX} dark glass building facade texture, reflective window grid,
skyscraper exterior, blue-black tinted glass,
corporate building wall, seamless vertical tile, stylized
```

### Adobe Colorido (Cartel)
```
{STYLE_TOKEN_TEX} colorful adobe wall texture, Mexican pueblo style,
warm terracotta pink yellow green variations,
rough plaster surface, seamless tile, hand-painted
```

### Ladrillo Rojo Viejo (Mafia)
```
{STYLE_TOKEN_TEX} old red brick wall texture, Italian building exterior,
varied brick colors, mortar visible, aged historic,
European architecture wall, seamless tile, warm tones
```

### Hormigon Institucional (Policia)
```
{STYLE_TOKEN_TEX} brutalist concrete wall texture, gray institutional,
panel seams, slight stains, government building,
cold unwelcoming surface, seamless tile, flat gray
```

### Muro con Graffiti Total (Cholos)
```
{STYLE_TOKEN_TEX} graffiti covered wall texture, multiple tag layers,
vibrant neon paint on dark wall, street art explosion,
urban decay beauty, seamless tile, colorful chaos
```

### Ladrillo de Callejon (Generico)
```
{STYLE_TOKEN_TEX} dirty alley brick wall texture, urban decay,
weathered bricks, grime and stains, back alley feel,
generic city wall, seamless tile, dark tones
```

---

## 3. TECHOS Y SUPERFICIES SUPERIORES

### Tejas de Barro (Cartel / Mafia)
```
{STYLE_TOKEN_TEX} clay roof tiles texture, terracotta overlapping,
Mediterranean roofing, warm orange-brown,
top-down view roof, seamless tile, stylized flat
```

### Lamina Metalica Oxidada (Industrial / Cholos)
```
{STYLE_TOKEN_TEX} corrugated metal roof texture, rusted and weathered,
industrial roofing, orange rust on gray metal,
abandoned factory roof, seamless tile, decay aesthetic
```

---

## 4. SUPERFICIES DE AGUA

### Charcos con Reflejo Neon (Yakuza)
```
{STYLE_TOKEN_TEX} wet puddle texture with neon reflection, dark water,
cyan magenta light reflections, rain puddle,
ground decal overlay, seamless, stylized flat
```

### Agua Oscura de Puerto (Mafia / Industrial)
```
{STYLE_TOKEN_TEX} dark harbor water texture, oil slick sheen,
gentle ripple pattern, murky port water,
industrial waterfront, seamless tile, dark greens
```

---

## 5. MATERIALES DE PROPS

### Metal Oxidado
```
{STYLE_TOKEN_TEX} rusty metal surface texture, orange brown corrosion,
industrial decay, scrap metal look,
prop material for weapons vehicles, seamless tile
```

### Madera Gastada
```
{STYLE_TOKEN_TEX} worn wood plank texture, dark brown with grain,
weathered wood surface, barrel crate material,
prop material for furniture, seamless tile
```

### Cuero Oscuro (Mafia / Yakuza)
```
{STYLE_TOKEN_TEX} dark leather texture, luxury material, slight grain,
Italian leather upholstery, elegant prop surface,
seamless tile, rich dark brown black
```

### Tela Vaquera / Mezclilla (Cartel / Cholos)
```
{STYLE_TOKEN_TEX} denim fabric texture, blue jeans material,
woven fabric visible, casual clothing prop,
seamless tile, flat blue tones
```

### Nylon Balistico Verde (Inventario)
```
{STYLE_TOKEN_TEX} dark green nylon fabric texture, tactical gear,
RE4 attache case interior, grid-friendly,
inventory background material, seamless tile, military green
```

### Placa de Blindaje (SWAT / Policia)
```
{STYLE_TOKEN_TEX} dark blue kevlar armor texture, tactical vest,
woven ballistic fibers, police SWAT gear,
armor material, seamless tile, matte finish
```

---

## 6. DECALS (Aplicar sobre otras superficies)

### Mancha de Sangre
```
{STYLE_TOKEN_TEX} blood splatter decal texture, transparent background,
dark crimson #6B2D2D, crime scene floor decal,
overlay for combat aftermath, 512x512 with alpha
```

### Tag de Graffiti (Decal)
```
{STYLE_TOKEN_TEX} graffiti tag decal texture, transparent background,
magenta #FF00AA spray paint, crew territory marker,
wall overlay decal, 512x512 with alpha, stylized
```

### Grieta / Agujero de Bala
```
{STYLE_TOKEN_TEX} bullet hole decal texture, transparent background,
impact damage on wall, combat aftermath,
surface damage overlay, 512x512 with alpha
```

### Charco de Aceite
```
{STYLE_TOKEN_TEX} oil spill decal texture, transparent background,
dark iridescent puddle, garage floor spill,
environmental decal, 512x512 with alpha
```

---

## 7. CONFIGURACION DE IMPORTACION EN GODOT 4

### Para TODAS las texturas:
```
Godot Inspector -> Import:
  - Compress > Mode: Lossless (para mantener flat colors sin artefactos)
  - Filter: Nearest (configurado en project.godot)
  - Mipmaps: Generate (para texturas de entorno)
  - Detec 3D: Unchecked (para texturas 2D/UI)
  - SVG Scale: 1.0 (no aplica a PNG)
```

### Para texturas de personajes/props:
```
  - Compress > Mode: VRAM Compressed (optimizado para GPU)
  - Filter: Nearest Mipmap (ya configurado)
  - Mipmaps: Generate
```

### Para texturas de UI:
```
  - Compress > Mode: Lossless (IMPORTANTE - no comprimir UI)
  - Filter: Nearest (pixel art debe verse nitido)
  - Mipmaps: Off
```

---

*<<Total: 25 texturas tileables + 5 decals. Priorizar: 6 suelos (1 por sector) + 6 paredes (1 por sector) = 12 texturas MVP. Generar via GPT Image 2 con size 1024x1024, luego downscale a 512x512.>>*
