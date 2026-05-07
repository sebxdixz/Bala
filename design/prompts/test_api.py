import json
import sys
import requests
import base64
import time
import os
from pathlib import Path

API_KEY = os.getenv("OPENROUTER_API_KEY", "").strip()
if not API_KEY:
    raise SystemExit("Missing OPENROUTER_API_KEY environment variable.")
MODEL = "openai/gpt-5.4-image-2"
OUTPUT_DIR = Path("C:/Users/sdiaz/OneDrive - Axo/Escritorio/Proyectos/BALA/design/prompts/output")

headers = {
    "Authorization": f"Bearer {API_KEY}",
    "Content-Type": "application/json",
    "HTTP-Referer": "https://github.com/bslo"
}

prompt = "3D low poly video game asset, cell shaded, flat colors, a simple red health potion bottle, game prop, isolated on white background, diagonal angle, chunky geometry, clean silhouette"

data = {
    "model": MODEL,
    "messages": [{"role": "user", "content": prompt}],
    "max_tokens": 8000
}

print("Sending test request to OpenRouter GPT Image 2...")
start = time.time()
resp = requests.post(
    "https://openrouter.ai/api/v1/chat/completions",
    headers=headers,
    json=data,
    timeout=120
)
elapsed = time.time() - start

print(f"Status: {resp.status_code} | Time: {elapsed:.1f}s")
print(f"Cost: ${resp.headers.get('x-openrouter-cost', 'unknown')}")

resp_json = resp.json()

# Save full response for inspection
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
with open(OUTPUT_DIR / "test_response.json", "w", encoding="utf-8") as f:
    json.dump(resp_json, f, indent=2, ensure_ascii=False)

# Show structure
print(f"\nResponse keys: {list(resp_json.keys())}")

if "choices" in resp_json and resp_json["choices"]:
    msg = resp_json["choices"][0]["message"]
    print(f"Message keys: {list(msg.keys())}")
    content = msg.get("content", "")
    
    if isinstance(content, str):
        print(f"\nContent type: string, length: {len(content)}")
        print(f"Content preview: {content[:300]}")
        
        # Check if it contains base64 or image URL
        if "data:image" in content or content.startswith("/9j/") or "iVBOR" in content:
            print("CONTENT IS IMAGE DATA (base64 or data URL)")
            # Extract and save
            if content.startswith("data:image"):
                b64_data = content.split(",", 1)[1]
            else:
                b64_data = content
            
            img_bytes = base64.b64decode(b64_data)
            img_path = OUTPUT_DIR / "test_image.png"
            with open(img_path, "wb") as f:
                f.write(img_bytes)
            print(f"Image saved to: {img_path} ({len(img_bytes)} bytes)")
            
    elif isinstance(content, list):
        print(f"\nContent is list of {len(content)} items:")
        for i, item in enumerate(content):
            print(f"  [{i}] type={item.get('type')}, keys={list(item.keys())}")
            
            if item.get("type") == "image_url":
                url = item.get("image_url", {}).get("url", "")
                print(f"       image_url: {url[:100]}...")
                if url.startswith("data:image"):
                    b64_data = url.split(",", 1)[1]
                    img_bytes = base64.b64decode(b64_data)
                    img_path = OUTPUT_DIR / f"test_image_{i}.png"
                    with open(img_path, "wb") as f:
                        f.write(img_bytes)
                    print(f"       Saved: {img_path} ({len(img_bytes)} bytes)")
            elif item.get("type") == "image":
                print(f"       image data present")
                img_data = item.get("image", {})
                if isinstance(img_data, dict):
                    b64_data = img_data.get("data", img_data.get("b64_json", ""))
                else:
                    b64_data = str(img_data)
                if b64_data:
                    img_bytes = base64.b64decode(b64_data)
                    img_path = OUTPUT_DIR / f"test_image_{i}.png"
                    with open(img_path, "wb") as f:
                        f.write(img_bytes)
                    print(f"       Saved: {img_path} ({len(img_bytes)} bytes)")
    else:
        print(f"Content type: {type(content)}")
else:
    print(f"\nNo choices. Error: {resp_json.get('error', 'none')}")

# Also show usage/cost info
usage = resp_json.get("usage", {})
if usage:
    print(f"\nUsage: {json.dumps(usage, indent=2)}")

print("\n--- DONE. Check test_response.json for full response. ---")
