"""Generate a single asset. Usage: python gen_one.py <category> <filename>"""
import os, sys, json, base64, time, requests
from pathlib import Path

API_KEY = os.getenv("OPENROUTER_API_KEY", "").strip()
if not API_KEY:
    raise SystemExit("Missing OPENROUTER_API_KEY environment variable.")
MODEL = "openai/gpt-5.4-image-2"
OUT_DIR = Path(r"C:\Users\sdiaz\OneDrive - Axo\Escritorio\Proyectos\BALA\design\prompts\output")

HEADERS = {
    "Authorization": f"Bearer {API_KEY}",
    "Content-Type": "application/json",
    "HTTP-Referer": "https://github.com/bslo"
}

STYLE = "3D low poly video game asset, cell shaded, flat colors, chunky geometry, clean silhouette, MU Online aesthetic, PS2 retro 3D, no realistic textures, bold color blocking, game-ready for Godot Engine 4"

PROMPTS = {
    "characters": {
        "yakuza_maton_tank": f"{STYLE}, full body front view T-pose character, Japanese Yakuza gangster, black suit, dragon tattoos on arms, holding baseball bat, formal posture, male, isolated on white bg",
        "cartel_gatillero_dps": f"{STYLE}, full body front view T-pose character, Mexican cartel gunslinger, plaid red shirt, cowboy hat, gold pistol in holster, gold chain, tierra roja dust on boots, male, isolated on white bg",
        "mafia_capo_support": f"{STYLE}, full body front view T-pose character, Italian mafia Capo, three-piece pinstripe suit, fedora hat, cigar, polished shoes, elegant, male, isolated on white bg",
        "policia_swat_tank": f"{STYLE}, full body front view T-pose character, police SWAT officer, dark blue tactical armor, helmet visor, riot shield, shotgun, heavy gear, male, isolated on white bg",
        "cholo_vandal_melee": f"{STYLE}, full body front view T-pose character, cholo street gang Vandal, oversized hoodie, bandana mask, baseball bat with barbed wire, baggy pants, graffiti stains, male, isolated on white bg",
        "sinlegaja_doctor_healer": f"{STYLE}, full body front view T-pose character, mercenary Doctor de Barrio, mix of clothes, medical coat patched, jeringas in pocket, stethoscope, backpack, male, isolated on white bg",
    },
    "environments": {
        "yakuza_torre_cisne": f"{STYLE}, wide establishing shot environment, cyberpunk corporate district at night, dark glass skyscrapers, red neon kanji signs, perpetual rain, neon puddle reflections, clean empty streets",
        "cartel_plaza_mercado": f"{STYLE}, wide establishing shot environment, mexican outdoor market plaza, colorful tarp canopies, taco stands with smoke, tierra roja ground, lucha libre ring, papel picado, warm sunset",
        "mafia_callejon_padrino": f"{STYLE}, wide establishing shot environment, old Italian neighborhood, narrow cobblestone streets, red brick buildings, gas lamp posts, fog rolling at ground level, cats on windowsills",
        "policia_comisaria": f"{STYLE}, wide establishing shot environment, brutalist police headquarters, gray concrete fortress, barbed wire, police cars, flickering fluorescent lights, oppressive atmosphere",
        "cholo_skatepark": f"{STYLE}, wide establishing shot environment, abandoned pool turned skatepark, graffiti covering every surface, ramps and rails, barrel fires, broken concrete, rebellious energy",
        "centro_mercado_global": f"{STYLE}, wide establishing shot environment, grand central market hall, glass ceiling, multiple floors, vendor stalls from different cultures, auction stage, crowded bustling neutral zone",
    },
    "npcs": {
        "don_vincenzo_mafia": f"{STYLE}, full body T-pose, very large Italian mafia Don, three-piece pinstripe suit, napkin in collar, plate of pasta, big mustache, warm dangerous smile, ring on pinky, isolated on white bg",
        "el_compa_chuy_cartel": f"{STYLE}, full body T-pose, Mexican narco cook, apron over plaid shirt, cowboy hat, big friendly mustache, holding taco, gold chain with Saint Death pendant, warm smile, isolated on white bg",
        "sargento_rodriguez_policia": f"{STYLE}, full body T-pose, honest police sergeant 50s, immaculate blue uniform, tired eyes, gray mustache, badge shining, rain on shoulders, isolated on white bg",
        "abuela_barrio_cholos": f"{STYLE}, full body T-pose, Mexican grandmother 80s, floral dress, white apron, rolling pin in hand, sweet dangerous smile, chanclas, isolated on white bg",
        "dogman_sinlegaja": f"{STYLE}, full body T-pose, mysterious hot dog vendor, dirty apron, knowing smile, hot dog cart behind him, middle aged man, isolated on white bg",
        "kazuto_yakuza_boss": f"{STYLE}, full body T-pose, Japanese Yakuza boss, pristine white suit, icy cold expression, katana at waist, dragon tattoo on neck, gray temples, never smiles, isolated on white bg",
    },
    "weapons": {
        "baseball_bat": f"{STYLE}, wooden baseball bat, worn handle, chunky low poly, diagonal angle, game prop, isolated on white bg",
        "pistol_standard": f"{STYLE}, semi-automatic pistol, low poly compact, dark gray silver slide, diagonal angle, game prop, isolated on white bg",
        "katana_yakuza": f"{STYLE}, Japanese katana sword in sheath, red cord, silver blade, elegant low poly, diagonal angle, game prop, isolated on white bg",
        "ak47_cartel": f"{STYLE}, AK-47 assault rifle, wooden furniture, curved magazine, low poly, diagonal angle, game prop, isolated on white bg",
        "shotgun_swat": f"{STYLE}, pump-action shotgun, dark finish, tactical flashlight, low poly, diagonal angle, game prop, isolated on white bg",
    },
    "consumables": {
        "taco_healing": f"{STYLE}, Mexican street taco, corn tortilla meat cilantro onion, lime wedge, delicious food item, low poly, diagonal angle, game item, isolated on white bg",
        "cerveza_buff": f"{STYLE}, brown beer bottle, condensation drops, street art label, low poly, diagonal angle, game item prop, isolated on white bg",
        "adrenaline_syringe": f"{STYLE}, medical auto-injector syringe, orange cap, clear liquid, emergency item, low poly, diagonal angle, game prop, isolated on white bg",
        "jarabe_abuela": f"{STYLE}, glass medicine bottle dark amber liquid, cork stopper, handwritten label, low poly, diagonal angle, game item, isolated on white bg",
    },
    "vehicles": {
        "sedan_yakuza_black": f"{STYLE}, black luxury sedan, tinted windows, chrome trim, low poly, side and 3/4 view, game vehicle, isolated on white bg",
        "patrulla_policia": f"{STYLE}, police patrol car, black and white livery, light bar on roof, push bar, low poly, side and 3/4 view, game vehicle, isolated on white bg",
        "pickup_cartel": f"{STYLE}, lifted pickup truck, tierra roja dust, bull bars, off-road, low poly, side and 3/4 view, game vehicle, isolated on white bg",
    },
}

if len(sys.argv) < 3:
    print("Usage: python gen_one.py <category> <filename>")
    cats = list(PROMPTS.keys())
    for c in cats:
        print(f"\n  {c}:")
        for f in PROMPTS[c]:
            print(f"    - {f}")
    sys.exit(1)

cat = sys.argv[1]
fname = sys.argv[2]

if cat not in PROMPTS or fname not in PROMPTS[cat]:
    print(f"Not found: {cat}/{fname}")
    sys.exit(1)

prompt = PROMPTS[cat][fname]
out_path = OUT_DIR / cat / f"{fname}.png"
out_path.parent.mkdir(parents=True, exist_ok=True)

if out_path.exists():
    print(f"SKIP: Already exists: {out_path}")
    sys.exit(0)

print(f"Generating: {cat}/{fname}")
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
    print(f"ERROR: No images. Response: {json.dumps(rj, default=str)[:500]}")
    sys.exit(1)

b64_data = images[0]["image_url"]["url"].split(",", 1)[1]
img_bytes = base64.b64decode(b64_data)
out_path.write_bytes(img_bytes)

cost = rj.get("usage", {}).get("cost", 0)
img_tokens = rj.get("usage", {}).get("completion_tokens_details", {}).get("image_tokens", 0)

print(f"OK: {out_path.name} | {len(img_bytes)} bytes | {elapsed:.0f}s | cost ${cost:.4f} | {img_tokens} img tokens")
print(f"TOTAL SPENT SO FAR: check OpenRouter dashboard")
