# BSLO — PROMPTS DE UI, HUD Y MENUS
## design/prompts/06_ui_hud_menus.md
**Version:** 2.0 | **Fuentes:** Ver FONT_GUIDE.md

---

> **STYLE_TOKEN_UI:** "pixel art game UI element, 64x64 to 256x256, flat colors, bold silhouette, high contrast, 8-bit retro aesthetic, video game UI, graffiti spray paint edges, neon accent colors, dark background compatible, clean readable at small sizes, Godot Engine 4, game HUD, isolated"

---

## 1. HUD PRINCIPAL (In-Game)

### Barra de Vida — Corazon Estilizado
```
{STYLE_TOKEN_UI} pixel art heart health bar organic shape, cracked and bleeding
at low HP, pulsing animation frames, dark crimson and bright red,
street art graffiti heart style, video game HP indicator,
full - half - critical (3 states), 256x256 sprite sheet
```
**Estados necesarios:** 100%, 75%, 50%, 25%, 10% (critico, late y gotea), 0%

### Barra de Stamina
```
{STYLE_TOKEN_UI} pixel art stamina bar, horizontal yellow energy bar,
below health heart, draining animation smooth, street style,
bold yellow #FFCC00 on dark background, video game HUD element,
full to empty states, 256x64
```

### Sistema de Wanted (1-5 Estrellas)
```
{STYLE_TOKEN_UI} pixel art wanted level stars, police report paper background,
1 to 5 gold star icons, retro GTA style, amarillo policia #FFCC00,
each star appearing with flash animation, top right corner HUD,
video game crime indicator, 256x256 sprite sheet with all states
```

### Hotbar 10 Slots
```
{STYLE_TOKEN_UI} pixel art skill hotbar, 10 rectangular slots horizontal bottom,
graffiti spray edge borders, each slot with faction color outline ability icon,
dark semi-transparent background, video game MMO hotbar,
keybind numbers 1-0 visible, empty and filled states, 1024x128
```

### Inventario Rapido 4 Slots
```
{STYLE_TOKEN_UI} pixel art quick inventory bar, 4 small slots bottom right,
consumable items visible, taco health potion grenade icons,
compact HUD element, video game quick slots, 256x96
```

### Minimapa Circular
```
{STYLE_TOKEN_UI} pixel art circular minimap HUD element, rotating compass,
street layout simplified, ally dots cyan, enemy dots red,
quest markers yellow, top left corner, dark background,
graffiti border ring, video game radar minimap, 256x256
```

---

## 2. MENU DE INVENTARIO

### Fondo de Inventario — Nylon Verde
```
{STYLE_TOKEN_UI} pixel art inventory background, dark green nylon fabric texture,
RE4 style attache case color, grid lines subtle gray,
8x10 grid cells visible, military tactical bag vibe,
video game inventory screen background, 1024x1024 tileable
```

### Grid de Inventario (8x10 celdas)
```
{STYLE_TOKEN_UI} pixel art inventory grid overlay, 8 columns 10 rows,
light gray grid lines on dark green background,
Tetris inventory system, Resident Evil 4 inspired,
video game grid inventory, 1024x1024
```

### Borde de Rareza (6 variantes)
```
{STYLE_TOKEN_UI} pixel art item rarity borders, 6 variants:
gray trash common, white common, green uncommon, blue rare,
magenta epic, gold legendary, dark red cursed,
glowing edges for higher tiers, video game item frames, 256x256 each
```

### Slots de Equipamiento (Personaje)
```
{STYLE_TOKEN_UI} pixel art equipment doll slots, humanoid silhouette outline,
slots for: head, chest, hands, legs, weapon L, weapon R, accessory x2,
paper doll equipment system, video game character equipment, 512x512
```

---

## 3. MENU DE MAPA

### Fondo de Mapa — Papel Arrugado
```
{STYLE_TOKEN_UI} pixel art wrinkled paper map texture, coffee stains,
burned edges, vintage paper sepia tone, old map aesthetic,
territory overlay compatible, video game world map background, 2048x2048
```

### Icono de Territorio de Crew
```
{STYLE_TOKEN_UI} pixel art territory control icons, spray paint tag style,
your crew: vibrant graffiti tag, enemy crew: crossed out tag,
neutral: empty circle, contesting: flashing tag,
video game territory markers, 128x128 each
```

---

## 4. MENU DE SKILL TREE

### Fondo de Skill Tree — Muro de Graffiti
```
{STYLE_TOKEN_UI} pixel art brick wall background covered in graffiti,
skill tree mural aesthetic, neon spray paint effects,
each branch a different color graffiti style,
dark brick visible between tags, video game skill tree, 1920x1080
```

### Nodo de Habilidad (Desbloqueado)
```
{STYLE_TOKEN_UI} pixel art skill node icon, glowing graffiti tag circle,
neon spray paint edge, ability icon inside, unlocked state,
bright vibrant colors, video game skill tree node, 128x128
```

### Nodo de Habilidad (Bloqueado)
```
{STYLE_TOKEN_UI} pixel art locked skill node, grayed out graffiti circle,
chain or lock overlay, dark muted colors, can not unlock yet state,
video game skill tree locked node, 128x128
```

---

## 5. MENU PRINCIPAL

### Titulo "BARRIO SIN LEY ONLINE"
```
{STYLE_TOKEN_UI} pixel art game title logo "BARRIO SIN LEY ONLINE",
graffiti spray paint style typography, magenta neon #FF00AA,
black outline, street art energy, cyberpunk meets cholo,
video game main menu title, 1024x256
```

### Fondo de Menu Principal
```
{STYLE_TOKEN_UI} pixel art main menu background, city skyline silhouette at night,
neon lights reflecting on wet street, graffiti tags visible,
atmospheric fog, dark moody, "BARRIO SIN LEY ONLINE" space,
video game main menu screen, 1920x1080
```

### Boton de Menu (Normal / Hover / Click)
```
{STYLE_TOKEN_UI} pixel art menu button, graffiti tagged rectangle,
cyan #00FFFF border, dark fill, Press Start 2P font text area,
normal hover pressed 3 states, video game UI button, 384x96 sprite sheet
```

### Pantalla de Carga
```
{STYLE_TOKEN_UI} pixel art loading screen, graffiti tag "CARGANDO..." animated,
spray can painting effect progress bar, random humorous tip text,
dark background, neon accents, video game loading screen, 1920x1080
```

---

## 6. VENTANAS DE DIALOGO

### Dialogo Yakuza (Serif Formal)
```
{STYLE_TOKEN_UI} pixel art dialogue box, dark elegant frame with minimal gold trim,
white text area, red accent line, Japanese formal aesthetic,
Playfair Display compatible, video game NPC dialogue window, 800x200
```

### Dialogo Mafia (Serif Clasico)
```
{STYLE_TOKEN_UI} pixel art dialogue box, dark wood frame, gold corners,
parchment-like text area, Italian classical aesthetic,
Playfair Display compatible, video game NPC dialogue window, 800x200
```

### Dialogo Callejero (Sans-Serif)
```
{STYLE_TOKEN_UI} pixel art dialogue box, graffiti tag frame,
color varies by faction (orange cartel, magenta cholo, yellow police),
concrete texture background, Barlow font compatible,
video game NPC dialogue window, 800x200
```

### Dialogo Sistema (Consola Verde)
```
{STYLE_TOKEN_UI} pixel art terminal dialogue box, black background with green text,
CRT scanline effect subtle, computer terminal aesthetic,
JetBrains Mono compatible, flickering cursor, video game system message, 800x200
```

---

## 7. NOTIFICACIONES Y POP-UPS

### Notificacion de Loot
```
{STYLE_TOKEN_UI} pixel art loot notification popup, item icon + text,
dark semi-transparent background, white text,
"Encontraste: [ITEM]" with rarity color, slide-in animation,
video game notification, 512x128
```

### Notificacion de Muerte
```
{STYLE_TOKEN_UI} pixel art death screen overlay, blood spatter edges,
"Has muerto." in green terminal font, respawn timer countdown,
dark red vignette, "Respiras... o intentas hacerlo." flavor text,
video game death screen, 1920x1080
```

### Anuncio Server-Wide
```
{STYLE_TOKEN_UI} pixel art server announcement banner, top of screen,
magenta neon text, dark semi-transparent background,
"ATENCION BARRIO:" prefix, important event notification,
video game server message, 1920x96
```

---

## 8. ICONOS DE FACCIÓN (Emblemas)

### Emblema Yakuza — Dragon
```
{STYLE_TOKEN_UI} pixel art Yakuza faction emblem, stylized dragon in circle,
red and black, Japanese minimalist, neon glow subtle,
faction icon for UI and flags, 256x256
```

### Emblema Cartel — Aguila
```
{STYLE_TOKEN_UI} pixel art cartel faction emblem, eagle with snake,
green red gold, Mexican coat of arms stylized, tierra warmth,
faction icon for UI and flags, 256x256
```

### Emblema Mafia — Rosa de los Vientos
```
{STYLE_TOKEN_UI} pixel art mafia faction emblem, compass rose with olive branch,
dark green and gold, Italian old world style, elegant,
faction icon for UI and flags, 256x256
```

### Emblema Policia — Placa
```
{STYLE_TOKEN_UI} pixel art police faction emblem, badge shield shape,
blue and silver, POLICE lettering, law enforcement,
faction icon for UI and flags, 256x256
```

### Emblema Cholos — Calavera con Graffiti
```
{STYLE_TOKEN_UI} pixel art cholo faction emblem, skull with bandana and spray can,
purple and neon green, street art style, rebellious,
faction icon for UI and flags, 256x256
```

### Emblema Sin-Legaja — Signo de Interrogacion
```
{STYLE_TOKEN_UI} pixel art sin-legaja faction emblem, question mark with broken chain,
rainbow chaotic colors, no allegiance, mercenary,
faction icon for UI and flags, 256x256
```

---

*<<Total: 50+ elementos de UI. Priorizar MVP: HUD completo (vida, stamina, hotbar, minimapa, wanted) + 1 pantalla de inventario + 1 menu principal.>>*
