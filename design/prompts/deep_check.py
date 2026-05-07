import os, glob, re

godot_dir = r"C:\Users\sdiaz\OneDrive - Axo\Escritorio\Proyectos\BALA\godot"

issues = []

for ext in ["*.gd", "*.tscn", "*.tres", "*.gdshader"]:
    for f in glob.glob(godot_dir + "/**/" + ext, recursive=True):
        name = os.path.basename(f)
        if name.endswith(".bak"):
            continue
        
        with open(f, "rb") as fh:
            raw = fh.read()
        
        # Check 1: UTF-8 validity
        try:
            text = raw.decode("utf-8")
        except:
            issues.append((f, "NOT UTF-8", str(raw[:50])))
            continue
        
        # Check 2: ext_resource paths exist
        if ext == "*.tscn":
            paths = re.findall(r'path="([^"]+)"', text)
            for path in paths:
                if path.startswith("res://"):
                    full = os.path.join(godot_dir, path.replace("res://", ""))
                    if not os.path.exists(full):
                        issues.append((f, f"MISSING: {path}", ""))
        
        # Check 3: BOM present (should not be for godot)
        if raw[:3] == b"\xef\xbb\xbf":
            issues.append((f, "HAS BOM", "remove UTF-8 BOM"))
        
        # Check 4: uid conflicts (simple check)
        uids = re.findall(r'uid://(\w+)', text)
        # just count unique ones per file

# Check for duplicate UIDs across files
uid_map = {}
for ext in ["*.tscn", "*.tres"]:
    for f in glob.glob(godot_dir + "/**/" + ext, recursive=True):
        if f.endswith(".bak"):
            continue
        try:
            with open(f, "r", encoding="utf-8") as fh:
                text = fh.read()
            uids = re.findall(r'uid://([a-z_]+)', text)
            for uid in uids:
                if uid in uid_map and uid_map[uid] != f:
                    issues.append((f, f"DUPLICATE UID: {uid} (also in {uid_map[uid]})", ""))
                uid_map[uid] = f
        except:
            pass

if issues:
    print(f"FOUND {len(issues)} ISSUES:\n")
    for f, issue, detail in issues:
        print(f"  {os.path.relpath(f, godot_dir)}")
        print(f"    -> {issue}")
        if detail:
            print(f"    -> {detail}")
else:
    print("ALL CLEAN - No issues found.")

print(f"\nScanned {sum(1 for _ in glob.glob(godot_dir+'/**/*.gd',recursive=True) if not _.endswith('.bak'))} .gd files")
print(f"Scanned {sum(1 for _ in glob.glob(godot_dir+'/**/*.tscn',recursive=True) if not _.endswith('.bak'))} .tscn files")
print(f"Scanned {sum(1 for _ in glob.glob(godot_dir+'/**/*.tres',recursive=True) if not _.endswith('.bak'))} .tres files")
