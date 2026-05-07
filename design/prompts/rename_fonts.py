import requests, re, os, shutil

basePath = r"C:\Users\sdiaz\OneDrive - Axo\Escritorio\Proyectos\BALA\godot\assets\fonts"

fonts = [
    ("PlayfairDisplay", "https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400"),
    ("JetBrainsMono", "https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;700"),
]

headers = {"User-Agent": "Mozilla/5.0"}

for name, css_url in fonts:
    d = os.path.join(basePath, name)
    resp = requests.get(css_url, headers=headers, timeout=15)
    css = resp.text

    blocks = css.split("@font-face {")
    for block in blocks[1:]:
        block = block.split("}")[0]
        wm = re.search(r"font-weight:\s*(\d+)", block)
        weight = wm.group(1) if wm else "400"
        sm = re.search(r"font-style:\s*(\w+)", block)
        style = sm.group(1) if sm else "normal"
        um = re.search(r"url\((https://fonts\.gstatic\.com/s/[^)]+\.ttf)\)", block)
        if um:
            url = um.group(1)
            old_name = os.path.basename(url)
            old_path = os.path.join(d, old_name)

            if style == "italic":
                new_name = f"{name}-Italic.ttf"
            elif weight == "700":
                new_name = f"{name}-Bold.ttf"
            else:
                new_name = f"{name}-Regular.ttf"

            new_path = os.path.join(d, new_name)

            if os.path.exists(old_path) and not os.path.exists(new_path):
                shutil.move(old_path, new_path)
                print(f"  {old_name[:40]} -> {new_name}")
            elif os.path.exists(old_path) and os.path.exists(new_path):
                os.remove(old_path)
                print(f"  {old_name[:40]} -> dup, removed")

print("\nFinal fonts:")
for root, dirs, files in os.walk(basePath):
    for f in sorted(files):
        if f.endswith(".ttf"):
            kb = os.path.getsize(os.path.join(root, f)) / 1024
            print(f"  {os.path.basename(root)}/{f} ({kb:.1f} KB)")

total = sum(1 for _, _, fs in os.walk(basePath) for f in fs if f.endswith(".ttf"))
print(f"\nTotal: {total} .ttf files")
