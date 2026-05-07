import json, base64, io
from pathlib import Path
from PIL import Image

resp = json.load(open(r"C:\Users\sdiaz\OneDrive - Axo\Escritorio\Proyectos\BALA\design\prompts\output\test_response.json", "r"))
img_data = resp["choices"][0]["message"]["images"][0]["image_url"]["url"]
b64 = img_data.split(",", 1)[1]
img_bytes = base64.b64decode(b64)

out = Path(r"C:\Users\sdiaz\OneDrive - Axo\Escritorio\Proyectos\BALA\design\prompts\output\test_potion.png")
out.write_bytes(img_bytes)

img = Image.open(io.BytesIO(img_bytes))
cost = resp["usage"]["cost"]
print(f"Image saved: {out}")
print(f"Dimensions: {img.size[0]}x{img.size[1]}")
print(f"Mode: {img.mode}, {len(img_bytes)} bytes")
print(f"Cost: ${cost:.4f} USD")
print(f"Budget left: ${20 - cost:.4f} USD")
print(f"Est. images for $20 budget: ~{int(20 / max(cost, 0.001))}")
