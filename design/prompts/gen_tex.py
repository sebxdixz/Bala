"""Generate seamless textures. Usage: python gen_tex.py <name>"""
import os, sys, json, base64, time, requests
from pathlib import Path

API_KEY = os.getenv("OPENROUTER_API_KEY", "").strip()
if not API_KEY:
    raise SystemExit("Missing OPENROUTER_API_KEY environment variable.")
MODEL = "openai/gpt-5.4-image-2"
OUT_DIR = Path(r"C:\Users\sdiaz\OneDrive - Axo\Escritorio\Proyectos\BALA\design\prompts\output\textures")
OUT_DIR.mkdir(parents=True, exist_ok=True)

HEADERS = {
    "Authorization": f"Bearer {API_KEY}",
    "Content-Type": "application/json",
    "HTTP-Referer": "https://github.com/bslo"
}

STYLE = "seamless tileable texture, low poly video game, flat colors, stylized hand-painted look, no photorealism, cartoon game surface, 1024x1024, Godot Engine 4, PBR simplified"

PROMPTS = {
    "tex_brick_wall": f"{STYLE}, dirty brick wall texture, urban alley bricks, dark red and brown tones, weathered mortar, seamless repeating pattern",
    "tex_concrete_floor": f"{STYLE}, gray concrete floor texture, urban sidewalk stone, slight cracks and stains, seamless tileable ground surface",
    "tex_graffiti_wall": f"{STYLE}, graffiti covered wall texture, multiple colorful spray paint tags on dark concrete, vibrant pink cyan and green, seamless tileable",
    "tex_asphalt_road": f"{STYLE}, dark asphalt road texture, street pavement with subtle wear marks, oil stains, yellow painted line fragment, seamless tileable",
    "tex_metal_rusted": f"{STYLE}, rusty corrugated metal texture, orange brown rust on gray metal, industrial sheet metal wall, seamless tileable",
    "tex_neon_glow_grid": f"{STYLE}, dark cyberpunk grid texture, blue and magenta neon lines on black, Tron-like aesthetic, seamless futuristic floor pattern",
}

if len(sys.argv) < 2:
    print("Available:")
    for k in PROMPTS: print(f"  {k}")
    sys.exit(1)

fname = sys.argv[1]
if fname not in PROMPTS:
    print(f"Not found: {fname}"); sys.exit(1)

prompt = PROMPTS[fname]
out_path = OUT_DIR / f"{fname}.png"
if out_path.exists():
    print(f"SKIP: {out_path}"); sys.exit(0)

print(f"Generating: {fname}")
data = {"model": MODEL, "messages": [{"role": "user", "content": prompt}], "max_tokens": 8000}
start = time.time()
resp = requests.post("https://openrouter.ai/api/v1/chat/completions", headers=HEADERS, json=data, timeout=300)
rj = resp.json()
if resp.status_code != 200:
    print(f"ERROR {resp.status_code}: {resp.text[:200]}"); sys.exit(1)
images = rj.get("choices", [{}])[0].get("message", {}).get("images", [])
if not images:
    print(f"ERROR: No images. {json.dumps(rj, default=str)[:300]}"); sys.exit(1)
b64 = images[0]["image_url"]["url"].split(",", 1)[1]
out_path.write_bytes(base64.b64decode(b64))
cost = rj.get("usage", {}).get("cost", 0)
print(f"OK: {out_path.name} | {out_path.stat().st_size} bytes | {time.time()-start:.0f}s | ${cost:.4f}")
