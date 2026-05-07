# BSLO — GENERACION POR LOTES VIA API GPT IMAGE 2
## design/prompts/10_API_BATCH_GENERATION.md
**Version:** 2.0 | **Lenguaje:** Python 3.10+ | **API:** OpenAI GPT Image 2 / DALL-E 3

---

## 1. CONFIGURACION INICIAL

### Instalacion
```bash
pip install openai pillow requests
```

### Variables de Entorno (NO COMMITEAR)
```bash
# .env o variables de sistema
$env:OPENAI_API_KEY = "sk-..."
```

### Estructura de Carpetas
```
design/prompts/output/
├── characters/
│   ├── yakuza/
│   ├── cartel/
│   ├── mafia/
│   ├── policia/
│   ├── cholos/
│   └── sinlegaja/
├── npcs/
├── environments/
├── weapons/
├── vehicles/
├── ui/
└── icons/
```

---

## 2. SCRIPT PRINCIPAL DE GENERACION

```python
#!/usr/bin/env python3
"""
BSLO Batch Image Generator
Usa OpenAI GPT Image 2 API para generar todos los assets visuales.
"""

import os
import json
import time
import base64
from pathlib import Path
from openai import OpenAI

# ─── CONFIG ───────────────────────────────────────────
client = OpenAI(api_key=os.environ.get("OPENAI_API_KEY"))
OUTPUT_DIR = Path("C:/Users/sdiaz/OneDrive - Axo/Escritorio/Proyectos/BALA/design/prompts/output")

# ─── STYLE TOKENS ─────────────────────────────────────
STYLE_CHARACTER = (
    "3D low poly video game asset, cell shaded, flat colors, chunky geometry, "
    "clean silhouette, MU Online aesthetic, PS2-era retro 3D charm, "
    "no realistic textures, simple materials, bold color blocking, "
    "outline on edges, isometric-friendly proportions, "
    "Godot Engine 4 compatible, T-pose, isolated on transparent background"
)

STYLE_ICON = (
    "pixel art icon, 64x64, flat colors, bold silhouette, high contrast, "
    "8-bit retro aesthetic, video game UI element, graffiti spray paint edges, "
    "neon accent colors, dark background compatible, clean readable at small sizes"
)

STYLE_ENV = (
    "3D low poly environment, cell shaded, flat color palette, "
    "stylized architecture, chunky buildings, retro 3D aesthetic, "
    "MU Online meets GTA SA, neon lights, atmospheric fog, "
    "isometric camera friendly, Godot 4 game world, wide establishing shot"
)

# ─── PROMPTS DATABASE ─────────────────────────────────
# (Carga desde los archivos .md de la carpeta prompts/)

PROMPTS = {
    "characters": {
        "yakuza_maton": f"{STYLE_CHARACTER} Yakuza gangster tank character, black suit, dragon tattoos, baseball bat, full body front view, T-pose",
        "cartel_gatillero": f"{STYLE_CHARACTER} Mexican cartel gunslinger, plaid shirt, cowboy hat, gold pistol, full body T-pose",
        # ... (todos los prompts de 01_characters_factions.md)
    },
    "npcs": {
        "don_vincenzo": f"{STYLE_CHARACTER} Italian mafia Don, very large man, three piece suit, pasta plate, warm dangerous smile",
        # ... (todos los prompts de 02_npcs_named.md)
    },
    "environments": {
        "yakuza_torre_cisne": f"{STYLE_ENV} cyberpunk corporate district, dark glass skyscrapers, red neon kanji signs, perpetual rain",
        # ... (todos los prompts de 03_environments_districts.md)
    },
    "weapons": {
        "baseball_bat": f"{STYLE_CHARACTER} wooden baseball bat, chunky low poly, worn handle, game prop, diagonal angle",
        # ... (todos los prompts de 04_weapons_props_items.md)
    },
    "vehicles": {
        "sedan_yakuza": f"{STYLE_CHARACTER} black luxury sedan, tinted windows, yakuza transport, game vehicle, side and 3/4 view",
        # ... (todos los prompts de 05_vehicles.md)
    },
    "ui": {
        "heart_health": f"{STYLE_ICON} pixel art heart health bar, cracked bleeding at low HP, graffiti street art style, sprite sheet",
        # ... (todos los prompts de 06_ui_hud_menus.md)
    },
    "icons": {
        "empujon": f"{STYLE_ICON} pushing hands forward icon, shockwave, street brawler ability, brown red",
        # ... (todos los prompts de 07_icons_skills.md)
    },
}


def generate_image(prompt: str, category: str, filename: str, size: str = "1024x1024", quality: str = "standard") -> bool:
    """Genera una imagen via GPT Image 2 y la guarda en disco."""
    
    output_path = OUTPUT_DIR / category / f"{filename}.png"
    output_path.parent.mkdir(parents=True, exist_ok=True)
    
    if output_path.exists():
        print(f"  [SKIP] Ya existe: {output_path}")
        return True
    
    try:
        response = client.images.generate(
            model="dall-e-3",
            prompt=prompt,
            size=size,
            quality=quality,
            style="vivid",
            response_format="b64_json",
            n=1,
        )
        
        # Decodificar y guardar
        b64_data = response.data[0].b64_json
        with open(output_path, "wb") as f:
            f.write(base64.b64decode(b64_data))
        
        print(f"  [OK] Generado: {output_path}")
        return True
        
    except Exception as e:
        print(f"  [ERROR] {filename}: {e}")
        
        # Reintento para rate limits
        if "rate_limit" in str(e).lower():
            print("  [WAIT] Rate limit, esperando 60s...")
            time.sleep(60)
            return generate_image(prompt, category, filename, size, quality)
        
        return False


def batch_generate(category: str = None, quality: str = "standard", delay: float = 1.0):
    """Genera todas las imagenes de una categoria (o todas si no se especifica)."""
    
    categories = [category] if category else PROMPTS.keys()
    
    total = 0
    success = 0
    
    for cat in categories:
        if cat not in PROMPTS:
            print(f"[WARN] Categoria '{cat}' no encontrada")
            continue
            
        prompts = PROMPTS[cat]
        print(f"\n{'='*60}")
        print(f" CATEGORIA: {cat} ({len(prompts)} imagenes)")
        print(f"{'='*60}")
        
        for i, (filename, prompt) in enumerate(prompts.items(), 1):
            print(f"\n[{i}/{len(prompts)}] {filename}")
            total += 1
            
            if generate_image(prompt, cat, filename, quality=quality):
                success += 1
            
            time.sleep(delay)  # Respetar rate limits
    
    print(f"\n{'='*60}")
    print(f" COMPLETADO: {success}/{total} exitos")
    print(f" COSTO ESTIMADO: ${total * (0.08 if quality == 'hd' else 0.04):.2f} USD")
    print(f"{'='*60}")


def generate_hd(category: str):
    """Genera en calidad HD para assets finales."""
    batch_generate(category, quality="hd", delay=2.0)


def generate_wide_concept(category: str, filename: str, prompt: str):
    """Genera una imagen widescreen (1792x1024) para concept sheets."""
    # Nota: DALL-E 3 solo soporta 1024x1024, 1792x1024, 1024x1792
    generate_image(prompt, category, filename, size="1792x1024", quality="hd")


def estimate_cost():
    """Calcula costo estimado de generacion completa."""
    total_images = sum(len(p) for p in PROMPTS.values())
    cost_std = total_images * 0.04
    cost_hd = total_images * 0.08
    
    print(f"\nESTIMACION DE COSTOS GPT IMAGE 2:")
    print(f"  Total imagenes: {total_images}")
    print(f"  Costo standard: ${cost_std:.2f} USD")
    print(f"  Costo HD:       ${cost_hd:.2f} USD")
    print(f"  (HD solo para assets finales, no concept art)")
    
    return total_images


# ─── MAIN ─────────────────────────────────────────────
if __name__ == "__main__":
    import argparse
    
    parser = argparse.ArgumentParser(description="BSLO Batch Image Generator")
    parser.add_argument("category", nargs="?", help="Categoria a generar (characters, npcs, environments, weapons, vehicles, ui, icons)")
    parser.add_argument("--hd", action="store_true", help="Calidad HD")
    parser.add_argument("--estimate", action="store_true", help="Solo estimar costo")
    parser.add_argument("--delay", type=float, default=1.0, help="Delay entre requests (segundos)")
    
    args = parser.parse_args()
    
    if args.estimate:
        estimate_cost()
    else:
        quality = "hd" if args.hd else "standard"
        batch_generate(args.category, quality=quality, delay=args.delay)
```

### Uso
```bash
# Estimar costo total
python batch_generate.py --estimate

# Generar TODOS los personajes (standard quality)
python batch_generate.py characters

# Generar solo iconos en HD
python batch_generate.py icons --hd

# Generar todo (puede tomar horas y costar ~$10-20 USD)
python batch_generate.py --delay 1.5

# Generar concept sheet wide
python batch_generate.py characters --hd
```

---

## 3. ESTRATEGIA DE GENERACION RAPIDA

### Plan de Ataque (Minimo Tiempo, Maximo Output)

```
FASE 0: Estimacion (5 min)
  python batch_generate.py --estimate

FASE 1: Personajes MVP (15 min, ~$1.50 USD)
  - 6 facciones x 1 clase representativa = 6 imagenes
  - Calidad: standard, 1024x1024
  - python batch_generate.py characters --delay 0.5

FASE 2: NPCs Clave (10 min, ~$1.00 USD)
  - 12 NPCs principales
  - Calidad: standard
  - python batch_generate.py npcs --delay 0.5

FASE 3: Entornos (15 min, ~$1.20 USD)
  - 7 entornos base (1 por sector + centro)
  - Calidad: standard, wide shot 1792x1024
  - Ajustar script para size wide

FASE 4: Armas + Items (10 min, ~$1.00 USD)
  - 10 armas + 8 consumibles + 5 quest items
  - Calidad: standard

FASE 5: UI + Iconos (20 min, ~$2.00 USD)
  - 50 iconos de habilidades y UI
  - Calidad: standard, 1024x1024

FASE 6: HD Finals (30 min, ~$4.00 USD)
  - Re-generar los mejores assets en HD
  - Solo assets aprobados de fases anteriores

TOTAL ESTIMADO: ~100 minutos, ~$10-12 USD
```

---

## 4. POST-PROCESAMIENTO AUTOMATICO

```python
#!/usr/bin/env python3
"""post_process.py — Recorte, redimension, conversion para Godot."""

from PIL import Image
from pathlib import Path

OUTPUT_DIR = Path("C:/Users/sdiaz/OneDrive - Axo/Escritorio/Proyectos/BALA/design/prompts/output")


def remove_white_background(img_path: Path):
    """Convierte fondo blanco/casi-blanco a transparente."""
    img = Image.open(img_path).convert("RGBA")
    datas = img.getdata()
    
    new_data = []
    for item in datas:
        # Si el pixel es blanco o casi blanco, hacerlo transparente
        if item[0] > 240 and item[1] > 240 and item[2] > 240:
            new_data.append((255, 255, 255, 0))
        else:
            new_data.append(item)
    
    img.putdata(new_data)
    img.save(img_path)
    print(f"  [BG Remove] {img_path.name}")


def resize_for_godot(img_path: Path, max_size: int = 512):
    """Redimensiona a size compatible con Godot texturas."""
    img = Image.open(img_path)
    img.thumbnail((max_size, max_size), Image.LANCZOS)
    img.save(img_path)
    print(f"  [Resize {max_size}] {img_path.name}")


def create_sprite_sheet(img_dir: Path, output_name: str, cols: int = 4):
    """Combina multiples frames en un sprite sheet horizontal."""
    images = sorted(img_dir.glob("*.png"))
    if not images:
        return
    
    # Asumir todos del mismo tamano
    w, h = Image.open(images[0]).size
    rows = (len(images) + cols - 1) // cols
    
    sheet = Image.new("RGBA", (w * cols, h * rows))
    
    for i, img_path in enumerate(images):
        img = Image.open(img_path)
        row = i // cols
        col = i % cols
        sheet.paste(img, (col * w, row * h))
    
    sheet.save(img_dir.parent / f"{output_name}_spritesheet.png")
    print(f"  [SpriteSheet] {output_name}: {len(images)} frames, {cols}x{rows}")


def batch_process():
    """Procesa todas las imagenes generadas."""
    for img_path in OUTPUT_DIR.rglob("*.png"):
        if "icon" in str(img_path).lower():
            resize_for_godot(img_path, 128)
        elif "character" in str(img_path).lower() or "npc" in str(img_path).lower():
            remove_white_background(img_path)


if __name__ == "__main__":
    batch_process()
```

---

## 5. CONSEJOS PARA GPT IMAGE 2

1. **Rate Limits:** ~5 images/minuto en tier standard. Usar `--delay 0.5` como maximo seguro.
2. **Calidad HD solo para finales:** HD cuesta el doble ($0.08). Usar standard para iterar.
3. **Reintentos:** Si falla por rate limit, el script ya incluye retry con 60s de espera.
4. **Prompts cortos pero densos:** GPT Image 2 responde mejor a prompts de 2-3 oraciones con tokens especificos.
5. **"Isolated on transparent background" no siempre funciona:** Usar post-procesamiento con PIL para quitar fondos blancos.
6. **Consistencia de estilo:** Siempre incluir el STYLE_TOKEN al inicio del prompt. Es el ancla.
7. **Wide format:** Para concept sheets de personajes, usar 1792x1024.

---

*<<Este script es el acelerador. Con ~$12 USD y 2 horas, tienes todos los concept art del MVP. Despues, Meshy para 3D.>>*
