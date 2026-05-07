"""Generate UI assets. Usage: python gen_ui.py <filename>"""
import os, sys, json, base64, time, requests
from pathlib import Path

API_KEY = os.getenv("OPENROUTER_API_KEY", "").strip()
if not API_KEY:
    raise SystemExit("Missing OPENROUTER_API_KEY environment variable.")
MODEL = "openai/gpt-5.4-image-2"
OUT_DIR = Path(r"C:\Users\sdiaz\OneDrive - Axo\Escritorio\Proyectos\BALA\design\prompts\output\ui")

HEADERS = {
    "Authorization": f"Bearer {API_KEY}",
    "Content-Type": "application/json",
    "HTTP-Referer": "https://github.com/bslo"
}

STYLE = "pixel art game UI element, flat colors, bold silhouette, high contrast, 8-bit retro aesthetic, graffiti spray paint edges, neon accent colors on dark background, clean readable, video game HUD, Godot Engine 4, 1024x1024, isolated"

PROMPTS = {
    "health_bar_full": f"{STYLE}, pixel art health bar, heart shaped organic, full red bright, cracked texture, street graffiti style, video game HP indicator, dark background, 5 frames sprite sheet horizontal showing 100 percent to 0 percent",
    "stamina_bar": f"{STYLE}, pixel art stamina bar, horizontal yellow energy bar, bold orange-yellow, dark background, video game stamina indicator, depleting from left to right, street style",
    "wanted_stars": f"{STYLE}, pixel art wanted level stars, gold yellow stars on dark police report paper background, 1 to 5 stars, retro GTA style, crime game indicator, top right HUD element",
    "hotbar_10_slots": f"{STYLE}, pixel art skill hotbar, 10 rectangular slots in a row at bottom, graffiti spray edge borders, dark semi-transparent background, MMO hotbar, numbered 1 to 0, empty fillable slots, cyan magenta accents",
    "minimap_circular": f"{STYLE}, pixel art circular minimap, rotating compass, simple street layout lines, dark background, graffiti border ring, top left corner HUD, video game radar, cyan ally dots red enemy dots",
    "inventory_background": f"{STYLE}, pixel art inventory background, dark green nylon fabric texture, RE4 attache case style, 8 by 10 grid subtle gray lines, military tactical bag, video game inventory screen",
    "inventory_grid": f"{STYLE}, pixel art inventory grid overlay, 8 columns 10 rows, light gray grid lines, Tetris inventory system, Resident Evil 4 inspired, dark green background, item slots",
    "rarity_borders_all": f"{STYLE}, pixel art item rarity borders sprite sheet, 6 variants in a row: gray trash, white common, green uncommon, blue rare, magenta epic, gold legendary, dark red cursed, glowing edges on higher tiers, video game item frames",
    "main_menu_title": f"{STYLE}, pixel art game title logo BARRIO SIN LEY ONLINE, graffiti spray paint typography, magenta neon pink glow, black outline, street art energy, dark background, video game main menu title screen",
    "main_menu_bg": f"{STYLE}, pixel art main menu background, city skyline silhouette at night, neon lights reflecting on wet street, graffiti tags visible, atmospheric fog, dark moody, cyberpunk meets street gang aesthetic",
    "dialogue_box_yakuza": f"{STYLE}, pixel art dialogue box, dark elegant frame with minimal gold trim, white text area, red accent line, Japanese formal aesthetic, video game NPC dialogue window, horizontal wide box",
    "dialogue_box_callejero": f"{STYLE}, pixel art dialogue box, graffiti tag frame, concrete texture background, orange and magenta accents, street style, video game NPC dialogue window, horizontal wide box",
    "dialogue_box_system": f"{STYLE}, pixel art terminal dialogue box, black background with green text area, CRT scanline effect, computer terminal aesthetic, monospace font compatible, video game system message window",
    "death_screen_overlay": f"{STYLE}, pixel art death screen HUD overlay, blood spatter edges, dark red vignette, HAS MUERTO in green terminal font, respawn timer text area, video game death screen, 1920x1080 style",
    "faction_emblems_sheet": f"{STYLE}, pixel art faction emblems sprite sheet, 6 icons in a row: dragon red yakuza, eagle green cartel, compass rose gold mafia, badge blue police, skull purple cholo, question mark rainbow sin-legaja, video game faction icons",
    "button_normal_hover": f"{STYLE}, pixel art menu button sprite sheet 3 states, graffiti tagged rectangle, cyan border, dark fill, normal hover pressed states, video game UI button, horizontal strip of 3 buttons",
    "loading_screen": f"{STYLE}, pixel art loading screen, graffiti tag CARGANDO with animated spray paint effect, progress bar, humorous tip text area, dark background, neon accents, video game loading screen",
}

if len(sys.argv) < 2:
    print("Usage: python gen_ui.py <filename>")
    for f in PROMPTS:
        print(f"  - {f}")
    sys.exit(1)

fname = sys.argv[1]
if fname not in PROMPTS:
    print(f"Not found: {fname}")
    sys.exit(1)

prompt = PROMPTS[fname]
out_path = OUT_DIR / f"{fname}.png"
OUT_DIR.mkdir(parents=True, exist_ok=True)

if out_path.exists():
    print(f"SKIP: {out_path}")
    sys.exit(0)

print(f"Generating UI: {fname}")
data = {"model": MODEL, "messages": [{"role": "user", "content": prompt}], "max_tokens": 8000}

start = time.time()
resp = requests.post("https://openrouter.ai/api/v1/chat/completions", headers=HEADERS, json=data, timeout=300)
elapsed = time.time() - start

if resp.status_code != 200:
    print(f"ERROR HTTP {resp.status_code}: {resp.text[:300]}")
    sys.exit(1)

rj = resp.json()
images = rj.get("choices", [{}])[0].get("message", {}).get("images", [])
if not images:
    print(f"ERROR: No images. {json.dumps(rj, default=str)[:500]}")
    sys.exit(1)

b64_data = images[0]["image_url"]["url"].split(",", 1)[1]
img_bytes = base64.b64decode(b64_data)
out_path.write_bytes(img_bytes)

cost = rj.get("usage", {}).get("cost", 0)
img_tokens = rj.get("usage", {}).get("completion_tokens_details", {}).get("image_tokens", 0)

print(f"OK: {out_path.name} | {len(img_bytes)} bytes | {elapsed:.0f}s | cost ${cost:.4f} | {img_tokens} img tokens")
