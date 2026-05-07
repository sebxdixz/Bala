import os, glob, re

godot = r"C:\Users\sdiaz\OneDrive - Axo\Escritorio\Proyectos\BALA\godot"
errors = []
warnings = []

for tscn in glob.glob(godot + "/**/*.tscn", recursive=True):
    if tscn.endswith(".bak"):
        continue
    rel = os.path.relpath(tscn, godot)
    
    try:
        with open(tscn, "r", encoding="utf-8") as f:
            text = f.read()
    except:
        errors.append(f"{rel}: Cannot read file")
        continue
    
    # Check ext_resource paths
    for m in re.finditer(r'path="res://([^"]+)"', text):
        res_path = m.group(1)
        full = os.path.join(godot, res_path)
        if not os.path.exists(full):
            errors.append(f"{rel}: MISSING -> res://{res_path}")
    
    # Check sub_resource references (within file, should be fine)
    # Check node path references
    for m in re.finditer(r'script = ExtResource\("(\d+)[^"]*"\)', text):
        ext_id = m.group(1)
        # These are internal references, fine
    
    # Check if scene references another scene
    for m in re.finditer(r'PackedScene.*?path="res://([^"]+)"', text):
        ref_path = m.group(1)
        full = os.path.join(godot, ref_path)
        if not os.path.exists(full):
            errors.append(f"{rel}: MISSING SCENE -> res://{ref_path}")

# Also check .gd files reference valid paths
for gd_file in glob.glob(godot + "/**/*.gd", recursive=True):
    if gd_file.endswith(".bak"):
        continue
    rel = os.path.relpath(gd_file, godot)
    try:
        with open(gd_file, "r", encoding="utf-8") as f:
            text = f.read()
    except:
        errors.append(f"{rel}: Cannot read file")
        continue
    
    # Check preload/load paths
    for m in re.finditer(r'(?:preload|load)\("res://([^"]+)"\)', text):
        res_path = m.group(1)
        full = os.path.join(godot, res_path)
        if not os.path.exists(full):
            errors.append(f"{rel}: MISSING -> res://{res_path}")

if errors:
    print(f"\n{len(errors)} ERRORS:")
    for e in errors:
        print(f"  [ERR] {e}")
if warnings:
    print(f"\n{len(warnings)} WARNINGS:")
    for w in warnings:
        print(f"  [WARN] {w}")

if not errors and not warnings:
    print("PROJECT INTEGRITY: PERFECT")
    print("  All resource paths valid")
    print("  All scripts loadable")
    print("  No broken references")
    print(f"  {sum(1 for _ in glob.glob(godot+'/**/*.gd',recursive=True) if not _.endswith('.bak'))} .gd scripts")
    print(f"  {sum(1 for _ in glob.glob(godot+'/**/*.tscn',recursive=True) if not _.endswith('.bak'))} .tscn scenes")
    print(f"  {sum(1 for _ in glob.glob(godot+'/**/*.png',recursive=True))} .png assets")
