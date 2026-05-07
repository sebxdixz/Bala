# BSLO — PROMPTS DE VFX, PARTICULAS Y ANIMACIONES
## design/prompts/08_vfx_animations.md
**Version:** 2.0 | **Motor:** Godot 4 | **Shaders:** low_poly_outline.gdshader

---

## 1. EFECTOS DE PARTICULAS (Godot GPUParticles3D)

Todos los VFX deben ser **pixelados intencionalmente** (baja resolucion, dithering visible) para mantener coherencia con la estetica retro-moderna.

### Explosion (Generico)
```
Godot GPUParticles3D explosion VFX: low resolution pixelated fireball,
flat color orange #FF6600 and yellow #FFCC00, dithering visible,
smoke puffs dark gray, 20-30 particles, expanding ring shockwave,
retro game explosion, 1 second duration, screen shake trigger
```
**Config Godot:** `amount: 25, lifetime: 1.0, emission_shape: sphere, gravity: (-0.5), scale_curve: expand to 5x`

### Sangre / Impacto (Critico)
```
Godot GPUParticles3D blood splatter VFX: pixelated red droplets,
dark crimson #6B2D2D, chunky square particles, splatter pattern,
impact point directional spray, 15 particles, quick burst 0.3s,
PS1-era blood, no gore excessive, stylized
```
**Config Godot:** `amount: 15, lifetime: 0.5, emission_shape: sphere 0.5m, initial_velocity: 5.0`

### Humo de Spray (Graffiti)
```
Godot GPUParticles3D spray paint mist VFX: pixelated colored mist,
magenta #FF00AA or cyan #00FFFF, cone spray pattern, slow dissipate,
paint can nozzle emission, 40 particles, 2 second duration,
graffiti painting effect, dithering on edges
```

### Chispas (Metal / Soldadura)
```
Godot GPUParticles3D sparks VFX: pixelated orange white sparks,
small square particles, gravity affected, bouncing off surfaces,
metal impact or crafting, 10 particles, random direction burst,
welding sparks aesthetic, quick fade
```

### Lluvia (Distrito Dragon)
```
Godot GPUParticles3D rain VFX: pixelated vertical lines, cyan tint,
thin rectangles falling, screen-wide emission above camera,
constant gentle downpour, reflection puddles compatible,
atmospheric rain, loop seamless
```

### Polvo de Tierra (Sector Cartel / Movimiento)
```
Godot GPUParticles3D dust VFX: pixelated tierra roja particles,
brown red #8B5A2B, ground level emission, character movement trigger,
walking/running dust clouds, 10 particles per step,
dry earth aesthetic, quick dissipate
```

### Niebla (Sector Mafia)
```
Godot GPUParticles3D fog VFX: pixelated white gray fog sheets,
large flat particles, ground level, drifting slow,
atmospheric volumetric fog alternative, semi-transparent,
giallo horror vibe, constant ambient
```

### Neón / Brillo (Efectos de Luz)
```
Godot GPUParticles3D neon glow VFX: pixelated colored light motes,
magenta cyan orange, floating ambient particles, slow drift upward,
cyberpunk atmosphere, bar district energy, gentle pulse,
light motes like fireflies but neon
```

### Electricidad (Taser / Hackeo)
```
Godot GPUParticles3D electricity VFX: pixelated zigzag lines,
cyan or yellow bolts, short-lived sparks, stun effect,
taser hit or hack overload, 8 particles, 0.5s duration,
arc between points, sci-fi but retro
```

### Fuego (Coctel Molotov / Incendio)
```
Godot GPUParticles3D fire VFX: pixelated flame particles,
orange red yellow, rising upward, flickering loop,
area denial fire, ground level emission, 30 particles,
molotov cocktail fire, 8 second burn
```

### Humo (Bomba de Humo / Escape)
```
Godot GPUParticles3D smoke screen VFX: pixelated gray smoke clouds,
large expanding spheres, screen-obscuring, 0 visibility,
smoke grenade thick cover, 50 particles, 12 second duration,
expanding from center, completely opaque
```

### Curacion (Doctor de Barrio / Curandero)
```
Godot GPUParticles3D healing VFX: pixelated green #2E8B57 motes,
floating upward sparkles, gentle particle fountain,
positive energy, plus cross shapes mixed in, 15 particles,
calming effect, 2 second heal cast
```

---

## 2. SPRITES DE ANIMACION (Godot AnimatedSprite2D/3D)

### Corazon de Vida (HUD) — Animacion de Latido
```
pixel art heart sprite sheet: 8 frames, beating animation,
full red (100% HP) -> cracked dark red (critical <20%),
final 2 frames with drip drop blood, loop at critical,
256x256 per frame, sprite sheet horizontal
```

### Estrellas de Wanted (HUD) — Animacion de Aparicion
```
pixel art wanted star sprite sheet: 6 frames per star,
appear flash animation, spinning in from off-screen,
golden yellow #FFCC00, on police report paper background,
64x64 per star, fade in + spin + settle
```

### Spray de Graffiti (Skill Tree) — Animacion
```
pixel art spray can painting sprite sheet: 12 frames,
can spraying paint arc, paint appearing on wall below,
magenta paint #FF00AA, tag being drawn frame by frame,
spray can shaking start, paint trail, finish flourish
```

### Abrir Maletin (Inventario) — Animacion
```
pixel art briefcase opening sprite sheet: 10 frames,
green nylon case opening from top, zipper animation,
case falling with slight bounce physics feel,
interior grid revealed, Resident Evil 4 homage
```

### Comer Taco (Consumible) — Animacion
```
pixel art eating taco sprite sheet: 8 frames character action,
taco raised to mouth, bite taken, chewing, swallow,
healing glow on character, vulnerable during animation,
5 second total, humorous "mmm" expression frames
```

---

## 3. ANIMACIONES DE PERSONAJE (Mixamo / Godot AnimationPlayer)

### Ciclo Base (Todas las clases)

| Animacion | Duracion | Descripcion |
|-----------|----------|-------------|
| **Idle** | Loop | Respira, mira alrededor, ajusta equipo (varia por faccion) |
| **Walk** | Loop | Caminata con peso, actitud de calle |
| **Run / Sprint** | Loop | Correr con determinacion, mochila rebotando |
| **Jump** | 0.8s | Salto con impulso, caida con rodillas flexionadas |
| **Roll / Dodge** | 0.6s | Rodar lateral (doble tap), invulnerabilidad frames |
| **Death** | 2.0s | Caer dramaticamente, estilo exagerado, "no me mori, solo estoy descansando" |
| **Interact** | 1.0s | Agacharse a recoger item, abrir puerta |
| **Cover Enter** | 0.5s | Pegarse a pared/objeto, arma lista |
| **Cover Exit** | 0.5s | Salir de cobertura rapido |
| **Emote: Graffiti** | 3.0s | Agitar lata de spray, pintar en pared |
| **Emote: Baile** | Loop | "El Pasito Perron", breakdance basico |

### Animaciones de Combate (Por Tipo de Arma)

#### Cuerpo a Cuerpo (Bate, Puno, Navaja)
```
Godot AnimationPlayer melee attack sequence:
- Light Attack: quick horizontal swing (0.4s)
- Heavy Attack: wind-up overhead smash (0.8s)
- Combo 3 hits: left-right-spin (1.5s total)
- Block: raise weapon defensive (0.2s, hold loop)
```

#### Armas de Fuego (Pistola, Rifle, Escopeta)
```
Godot AnimationPlayer ranged attack sequence:
- Shoot: aim fire recoil (0.3s)
- Reload: mag out, mag in, cock (1.5s)
- Aim Down Sights: raise weapon to eye level (0.3s, hold loop)
- Weapon Swap: holster current, draw next (0.5s)
```

#### Habilidades Especiales (Skills)
```
Godot AnimationPlayer skill cast animations:
- Each skill has unique 1-2 second cast animation
- Hand gestures, weapon flourishes, device activation
- Combine with VFX particles at impact point
```

---

## 4. SHADERS ADICIONALES (Godot)

### Shader de Neon (Letreros, Luces)
```gdscript
shader_type spatial;
// Neon glow effect for signs and lights
// Pulsing glow, color flicker, bloom-like
// Use on: street signs, bar lights, police sirens
render_mode blend_add, unshaded;
uniform vec4 neon_color : source_color = vec4(1.0, 0.0, 0.67, 1.0); // magenta
uniform float pulse_speed : hint_range(0.0, 5.0) = 2.0;
```

### Shader de Agua / Reflejo (Charcos, Puerto)
```gdscript
shader_type spatial;
// Simple water puddle with reflection
// Pixelated distortion, dark reflective surface
// Use on: street puddles, dock water, rain ground
render_mode blend_mix;
uniform vec4 water_color : source_color = vec4(0.1, 0.1, 0.15, 0.8);
uniform float distortion_strength : hint_range(0.0, 1.0) = 0.3;
```

### Shader de Holograma / Fantasma (NPC Sophia, Nadie)
```gdscript
shader_type spatial;
// Ghost/hologram transparency effect
// Scanlines, flicker, semi-transparent
// Use on: ghost NPCs, holographic signs, drone projections
render_mode blend_mix, unshaded, cull_disabled;
uniform float alpha : hint_range(0.0, 1.0) = 0.5;
uniform float scanline_speed = 2.0;
```

### Shader de Pantalla CRT (Opcional / Filtro)
```gdscript
shader_type canvas_item;
// Full screen CRT post-processing effect
// Scanlines, screen curvature, chromatic aberration
// Optional player toggle (settings -> "Modo Antiguoso")
uniform bool enable_scanlines = true;
uniform float curvature = 0.05;
```

---

*<<Los shaders existentes (low_poly_outline.gdshader) ya estan en godot/shaders/. Los nuevos van en la misma carpeta. Las animaciones se integran via AnimationPlayer de Godot.>>*
