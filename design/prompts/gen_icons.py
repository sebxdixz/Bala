"""Generate skill icons. Usage: python gen_icons.py <icon_name>"""
import os, sys, json, base64, time, requests
from pathlib import Path

API_KEY = os.getenv("OPENROUTER_API_KEY", "").strip()
if not API_KEY:
    raise SystemExit("Missing OPENROUTER_API_KEY environment variable.")
MODEL = "openai/gpt-5.4-image-2"
OUT_DIR = Path(r"C:\Users\sdiaz\OneDrive - Axo\Escritorio\Proyectos\BALA\design\prompts\output\icons")
OUT_DIR.mkdir(parents=True, exist_ok=True)

HEADERS = {
    "Authorization": f"Bearer {API_KEY}",
    "Content-Type": "application/json",
    "HTTP-Referer": "https://github.com/bslo"
}

STYLE = "pixel art skill icon, 64x64 style, flat colors, bold silhouette, high contrast, 8-bit retro game aesthetic, graffiti spray paint edges, neon accent colors on dark background, video game ability icon, readable at small size, stylized not realistic"

PROMPTS = {
    # TANK - Maton
    "skill_empujon": f"{STYLE}, pushing hands forward with shockwave effect, street brawler ability, brown and red colors",
    "skill_provocacion": f"{STYLE}, taunting face shouting with sound waves, aggro pull ability, red angry energy",
    "skill_aguante": f"{STYLE}, shield with clenched fist, defensive stance icon, blue and gray protection",
    "skill_terremoto": f"{STYLE}, fist smashing ground with cracks spreading, area stun ability, brown earth shockwave",

    # DPS RANGO - Gatillero
    "skill_disparo_preciso": f"{STYLE}, precise bullet shot through crosshair, yellow accuracy ability",
    "skill_rafaga": f"{STYLE}, multiple bullets spraying, SMG burst fire pattern, bullet storm icon",
    "skill_tiro_cabeza": f"{STYLE}, headshot bullseye with skull, critical hit icon, sniper precision",
    "skill_recarga_rapida": f"{STYLE}, speed reload icon, magazine swapping with motion blur",

    # HEALER - Doctor de Barrio
    "skill_jeringazo": f"{STYLE}, medical syringe injecting with green healing liquid, plus cross icon",
    "skill_vendas": f"{STYLE}, bandage wrapping icon, heal over time, white cloth with red cross",
    "skill_adrenalina": f"{STYLE}, adrenaline shot to heart icon, revive ability, yellow emergency zap",
    "skill_quirofano_movil": f"{STYLE}, operating room light icon, massive area heal, green glowing circle",

    # MELEE - Boxeador
    "skill_jab": f"{STYLE}, quick boxing jab icon, fast fist forward with speed lines",
    "skill_gancho": f"{STYLE}, boxing hook punch icon, curved fist with impact stars, heavy damage",
    "skill_esquiva": f"{STYLE}, dashing shadow silhouette icon, invulnerability frames, afterimage dodge",

    # CONTROL - Policia de Barrio
    "skill_alto_ahi": f"{STYLE}, stop hand police icon, freeze stun ability, blue authority STOP gesture",
    "skill_esposas": f"{STYLE}, handcuffs icon, immobilize ability, silver cuffs arrest",
    "skill_taser": f"{STYLE}, taser electric shock icon, stun with DOT, blue electricity zap",

    # SUPPORT - Capo
    "skill_motivacion": f"{STYLE}, inspirational speech icon, fist raised with damage buff aura, red leadership",
    "skill_plan_batalla": f"{STYLE}, tactical map marker icon, defense buff zone, blue strategy circle",

    # Quimico
    "skill_gas_toxico": f"{STYLE}, toxic green gas cloud icon with skull, area damage and slow debuff, green poison",
    "skill_acido": f"{STYLE}, acid spray stream icon, armor melting corrosion, dripping green liquid",
    "skill_veneno": f"{STYLE}, poison drop icon with skull crossbones, single target DOT, purple green bile",
    "skill_plaga": f"{STYLE}, plague spreading icon, multiple green skulls multiplying, epidemic mass DOT",

    # Experto en Explosivos
    "skill_granada": f"{STYLE}, fragmentation grenade icon, explosion radius with shrapnel, orange fire boom",
    "skill_mina": f"{STYLE}, landmine trap icon buried, proximity trigger with danger symbol, red explosive",
    "skill_rpg": f"{STYLE}, rocket propelled grenade icon, missile flying with trail, big fire explosion",
    "skill_molotov": f"{STYLE}, molotov cocktail fire bottle icon, glass breaking with flames, area fire",

    # Sicario
    "skill_sigilo": f"{STYLE}, invisible stealth icon, fading shadow silhouette, purple cloak, assassin hide",
    "skill_punalada": f"{STYLE}, backstab dagger icon, red critical hit from behind, sneak attack strike",
    "skill_garrote": f"{STYLE}, choking wire garrote icon, stealth stun takedown, silent black ops",
    "skill_ejecucion": f"{STYLE}, execution finisher icon, skull with knife, instant death below 15 percent HP",

    # Curandero
    "skill_taco_curativo": f"{STYLE}, healing taco flying icon, mexican food with green aura, thrown heal item",
    "skill_incienso": f"{STYLE}, incense burner smoking icon, purple spiritual smoke, area heal buff",
    "skill_limpiar": f"{STYLE}, spiritual cleansing icon, white light removing dark debuffs, purify sage",
    "skill_milagro": f"{STYLE}, divine miracle light from sky icon, mass revive golden rays, ultimate healer",
}

if len(sys.argv) < 2:
    print("Available icons:")
    for k in PROMPTS:
        print(f"  {k}")
    sys.exit(1)

fname = sys.argv[1]
if fname not in PROMPTS:
    print(f"Not found: {fname}")
    sys.exit(1)

prompt = PROMPTS[fname]
out_path = OUT_DIR / f"{fname}.png"

if out_path.exists():
    print(f"SKIP: {out_path}")
    sys.exit(0)

print(f"Generating: {fname}")
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
    print(f"ERROR: No images. {json.dumps(rj, default=str)[:300]}")
    sys.exit(1)

b64_data = images[0]["image_url"]["url"].split(",", 1)[1]
img_bytes = base64.b64decode(b64_data)
out_path.write_bytes(img_bytes)

cost = rj.get("usage", {}).get("cost", 0)
img_tokens = rj.get("usage", {}).get("completion_tokens_details", {}).get("image_tokens", 0)
print(f"OK: {out_path.name} | {len(img_bytes)} bytes | {elapsed:.0f}s | cost ${cost:.4f} | {img_tokens} img tokens")
