#!/usr/bin/env python3
"""
BSLO Asset Generator - OpenRouter GPT Image 2
Generates game assets via OpenRouter API with cost tracking.
Budget: $20 USD | Model: openai/gpt-5.4-image-2
"""

import json
import base64
import time
import sys
import os
from pathlib import Path
from datetime import datetime
import requests

# ═══════════════════════════════════════════════════════
# CONFIGURATION
# ═══════════════════════════════════════════════════════
API_KEY = os.getenv("OPENROUTER_API_KEY", "").strip()
if not API_KEY:
    raise SystemExit("Missing OPENROUTER_API_KEY environment variable.")
MODEL = "openai/gpt-5.4-image-2"
API_URL = "https://openrouter.ai/api/v1/chat/completions"
OUTPUT_DIR = Path(r"C:\Users\sdiaz\OneDrive - Axo\Escritorio\Proyectos\BALA\design\prompts\output")
MAX_BUDGET = 20.0
DELAY_BETWEEN = 5  # seconds between requests

HEADERS = {
    "Authorization": f"Bearer {API_KEY}",
    "Content-Type": "application/json",
    "HTTP-Referer": "https://github.com/bslo"
}

# ═══════════════════════════════════════════════════════
# COST TRACKING
# ═══════════════════════════════════════════════════════
total_spent = 0.0

def track_cost(amount):
    global total_spent
    total_spent += amount
    remaining = MAX_BUDGET - total_spent
    print(f"  COST: ${amount:.4f} | TOTAL: ${total_spent:.4f} | LEFT: ${remaining:.4f}")
    return remaining

# ═══════════════════════════════════════════════════════
# IMAGE GENERATION
# ═══════════════════════════════════════════════════════
def generate_image(prompt, category, filename, extra_body=None):
    """Generate a single image via OpenRouter GPT Image 2."""
    global total_spent
    
    output_path = OUTPUT_DIR / category / f"{filename}.png"
    output_path.parent.mkdir(parents=True, exist_ok=True)
    
    if output_path.exists():
        print(f"  [SKIP] Already exists: {output_path.name}")
        return True
    
    remaining = MAX_BUDGET - total_spent
    if remaining < 0.30:
        print(f"  [STOP] Budget exhausted. ${total_spent:.2f} spent of ${MAX_BUDGET:.2f}")
        return False
    
    messages = [{"role": "user", "content": prompt}]
    
    data = {
        "model": MODEL,
        "messages": messages,
        "max_tokens": 8000
    }
    
    if extra_body:
        data["extra_body"] = extra_body
    
    print(f"  Generating: {filename}...")
    print(f"  Prompt: {prompt[:120]}...")
    
    try:
        start = time.time()
        resp = requests.post(API_URL, headers=HEADERS, json=data, timeout=180)
        elapsed = time.time() - start
        
        if resp.status_code != 200:
            print(f"  [ERROR] HTTP {resp.status_code}: {resp.text[:300]}")
            if resp.status_code == 429:
                print("  Rate limited. Waiting 60s...")
                time.sleep(60)
                return generate_image(prompt, category, filename, extra_body)
            return False
        
        resp_json = resp.json()
        
        # Extract images
        choices = resp_json.get("choices", [])
        if not choices:
            print(f"  [ERROR] No choices in response")
            return False
        
        message = choices[0].get("message", {})
        images = message.get("images", [])
        
        if not images:
            print(f"  [ERROR] No images in response. Message: {json.dumps(message, default=str)[:500]}")
            return False
        
        # Save image
        img_url = images[0]["image_url"]["url"]
        b64_data = img_url.split(",", 1)[1] if "," in img_url else img_url
        img_bytes = base64.b64decode(b64_data)
        output_path.write_bytes(img_bytes)
        
        # Track cost
        usage = resp_json.get("usage", {})
        cost = usage.get("cost", 0.0)
        remaining = track_cost(cost)
        
        img_tokens = usage.get("completion_tokens_details", {}).get("image_tokens", 0)
        print(f"  [OK] {output_path.name} | {len(img_bytes)} bytes | {elapsed:.0f}s | {img_tokens} img tokens")
        
        return True
        
    except requests.exceptions.Timeout:
        print(f"  [TIMEOUT] Request exceeded 180s")
        return False
    except Exception as e:
        print(f"  [ERROR] {e}")
        return False

# ═══════════════════════════════════════════════════════
# MVP PROMPTS - Priority 1 (Minimal set for prototype)
# ═══════════════════════════════════════════════════════

STYLE = "3D low poly video game asset, cell shaded, flat colors, chunky geometry, clean silhouette, MU Online aesthetic, PS2 retro 3D, no realistic textures, bold color blocking, game-ready for Godot Engine 4, isolated on white background"

MVP_PROMPTS = {
    # ── FACTION CHARACTERS (T-pose, for 3D modeling reference) ──
    "characters": {
        "yakuza_maton_tank": f"{STYLE}, full body front view T-pose character, Japanese Yakuza gangster, black suit, dragon tattoos on arms, holding baseball bat, formal posture, male",
        "cartel_gatillero_dps": f"{STYLE}, full body front view T-pose character, Mexican cartel gunslinger, plaid red shirt, cowboy hat, gold pistol in holster, gold chain, tierra roja dust on boots, male",
        "mafia_capo_support": f"{STYLE}, full body front view T-pose character, Italian mafia Capo, three-piece pinstripe suit, fedora hat, cigar in hand, polished shoes, elegant dangerous, male",
        "policia_swat_tank": f"{STYLE}, full body front view T-pose character, police SWAT officer, dark blue tactical armor, helmet with visor, riot shield, shotgun, heavy gear, male",
        "cholo_vandal_melee": f"{STYLE}, full body front view T-pose character, cholo street gang Vandal, oversized hoodie, bandana mask, baseball bat with barbed wire, baggy pants, graffiti stains, male",
        "sinlegaja_doctor_healer": f"{STYLE}, full body front view T-pose character, mercenary Doctor de Barrio, mix of clothes from different factions, medical coat patched, jeringas in pocket, stethoscope, backpack, male",
    },
    
    # ── ENVIRONMENTS (1 per sector, wide establishing shots) ──
    "environments": {
        "yakuza_torre_cisne": f"{STYLE}, wide establishing shot 3D low poly environment, cyberpunk corporate district at night, dark glass skyscrapers, red neon kanji signs, perpetual rain, puddles reflecting neon, clean empty streets",
        "cartel_plaza_mercado": f"{STYLE}, wide establishing shot 3D low poly environment, mexican outdoor market plaza, colorful tarp canopies, taco stands with smoke, tierra roja ground, lucha libre ring, papel picado, warm sunset",
        "mafia_callejon_padrino": f"{STYLE}, wide establishing shot 3D low poly environment, old Italian neighborhood, narrow cobblestone streets, red brick buildings, gas lamp posts, fog rolling at ground level, cats on windowsills",
        "policia_comisaria": f"{STYLE}, wide establishing shot 3D low poly environment, brutalist police headquarters, gray concrete fortress, barbed wire, police cars, flickering fluorescent lights, oppressive atmosphere",
        "cholo_skatepark": f"{STYLE}, wide establishing shot 3D low poly environment, abandoned pool turned skatepark, graffiti covering every surface, ramps and rails, barrel fires, broken concrete, rebellious energy",
        "centro_mercado_global": f"{STYLE}, wide establishing shot 3D low poly environment, grand central market hall, glass ceiling, multiple floors, vendor stalls from different cultures, auction stage, crowded bustling neutral zone",
    },
    
    # ── KEY NPCs ──
    "npcs": {
        "don_vincenzo_mafia": f"{STYLE}, full body T-pose, very large Italian mafia Don, three-piece pinstripe suit, napkin tucked in collar, plate of pasta in front, big mustache, warm dangerous smile, ring on pinky",
        "el_compa_chuy_cartel": f"{STYLE}, full body T-pose, Mexican narco cook, apron over plaid shirt, cowboy hat, big friendly mustache, holding taco, gold chain with Saint Death pendant, warm smile",
        "sargento_rodriguez_policia": f"{STYLE}, full body T-pose, honest police sergeant 50s, immaculate blue uniform, tired eyes with integrity, gray mustache, badge shining, rain on shoulders",
        "abuela_barrio_cholos": f"{STYLE}, full body T-pose, Mexican grandmother 80s, floral dress, white apron, rolling pin in hand, flour on cheeks, sweet dangerous smile, chanclas",
        "dogman_sinlegaja": f"{STYLE}, full body T-pose, mysterious hot dog vendor, dirty apron, knowing smile, hot dog cart with umbrella behind him, middle aged man",
        "kazuto_yakuza_boss": f"{STYLE}, full body T-pose, Japanese Yakuza boss, pristine white suit, icy cold expression, katana at waist, dragon tattoo on neck, gray temples, never smiles",
    },
    
    # ── WEAPONS & PROPS ──
    "weapons": {
        "baseball_bat": f"{STYLE}, wooden baseball bat with worn handle, chunky low poly, diagonal angle, game prop, no background",
        "pistol_standard": f"{STYLE}, semi-automatic pistol, low poly compact, dark gray with silver slide, diagonal angle, game prop, no background",
        "katana_yakuza": f"{STYLE}, Japanese katana sword in sheath, red cord, silver blade, elegant low poly, diagonal angle, game prop, no background",
        "ak47_cartel": f"{STYLE}, AK-47 assault rifle, wooden furniture, curved magazine, low poly, diagonal angle, game prop, no background",
        "shotgun_swat": f"{STYLE}, pump-action shotgun, dark finish, tactical flashlight, low poly, diagonal angle, game prop, no background",
    },
    
    # ── CONSUMABLES ──
    "consumables": {
        "taco_healing": f"{STYLE}, Mexican street taco, corn tortilla with meat cilantro onion, lime wedge, mouth-watering stylized food, low poly, diagonal angle, game item, no background",
        "cerveza_buff": f"{STYLE}, brown beer bottle with condensation, street art label, low poly, diagonal angle, game item prop, no background",
        "adrenaline_syringe": f"{STYLE}, medical auto-injector syringe, orange cap, clear liquid, low poly, diagonal angle, emergency item, game prop, no background",
        "jarabe_abuela": f"{STYLE}, glass medicine bottle dark amber liquid, cork stopper, handwritten label, low poly, diagonal angle, game item, no background",
    },
    
    # ── KEY VEHICLES ──
    "vehicles": {
        "sedan_yakuza_black": f"{STYLE}, black luxury sedan, tinted windows, chrome trim, low poly, side view and 3/4 angle, game vehicle, no background",
        "patrulla_policia": f"{STYLE}, police patrol car, black and white livery, light bar on roof, push bar, low poly, side view and 3/4 angle, game vehicle, no background",
        "pickup_cartel": f"{STYLE}, lifted pickup truck, tierra roja dust, bull bars, off-road look, low poly, side view and 3/4 angle, game vehicle, no background",
    },
}

# ═══════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════
def main():
    global total_spent
    
    print("=" * 65)
    print("  BSLO ASSET GENERATOR - GPT Image 2 via OpenRouter")
    print(f"  Budget: ${MAX_BUDGET:.2f} | Model: {MODEL}")
    print("=" * 65)
    
    total_assets = sum(len(items) for items in MVP_PROMPTS.values())
    print(f"\n  Total MVP assets to generate: {total_assets}")
    print(f"  Estimated cost: ${total_assets * 0.23:.2f} (based on $0.225/test image)")
    print(f"  Estimated time: ~{total_assets * 3} minutes")
    print()
    print("  Categories:")
    for cat, items in MVP_PROMPTS.items():
        print(f"    {cat}: {len(items)} assets")
    print()
    
    import os as _os
    if "--yes" not in sys.argv and _os.environ.get("AUTO_RUN") != "1":
        response = input("  Start generation? (y/n): ").strip().lower()
        if response != "y":
            print("  Cancelled.")
            return
    
    success = 0
    failed = 0
    skipped = 0
    
    for category, assets in MVP_PROMPTS.items():
        print(f"\n{'='*60}")
        print(f"  CATEGORY: {category.upper()} ({len(assets)} assets)")
        print(f"{'='*60}")
        
        for filename, prompt in assets.items():
            if MAX_BUDGET - total_spent < 0.25:
                print("\n  [BUDGET LIMIT] Stopping to preserve remaining funds.")
                break
            
            result = generate_image(prompt, category, filename)
            if result:
                success += 1
            else:
                if MAX_BUDGET - total_spent < 0.25:
                    break
                failed += 1
            
            time.sleep(DELAY_BETWEEN)
    
    # Summary
    print("\n" + "=" * 65)
    print("  GENERATION COMPLETE")
    print(f"  Success: {success} | Failed: {failed} | Skipped: {skipped}")
    print(f"  Total spent: ${total_spent:.4f} USD")
    print(f"  Remaining: ${MAX_BUDGET - total_spent:.4f} USD")
    print("=" * 65)

if __name__ == "__main__":
    main()
