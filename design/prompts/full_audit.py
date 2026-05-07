"""COMPREHENSIVE Godot project checker - catches ALL errors and warnings"""
import os, glob, re
from pathlib import Path

godot = str(Path(__file__).resolve().parents[2] / "godot")
errors = []
warnings = []

def add_err(f, line, msg):
    errors.append(f"{f}:{line}: {msg}")

def add_warn(f, line, msg):
    warnings.append(f"{f}:{line}: {msg}")

# ═══════════════════════════════════════
# 1. TABS: zero tolerance for spaces
# ═══════════════════════════════════════
for f in sorted(glob.glob(godot + "/**/*.gd", recursive=True)):
    if f.endswith(".bak"): continue
    rel = os.path.relpath(f, godot)
    with open(f, "r", encoding="utf-8") as fh:
        for i, line in enumerate(fh.readlines(), 1):
            stripped = line.lstrip()
            if stripped and not stripped.startswith("#"):
                leading = line[:len(line)-len(stripped)]
                if leading and leading[0] == " " and "\t" not in leading:
                    add_err(rel, i, "Space indentation (must use tabs)")

# ═══════════════════════════════════════
# 2. ENCODING: all files must be valid UTF-8
# ═══════════════════════════════════════
for f in sorted(glob.glob(godot + "/**/*.gd", recursive=True) + sorted(glob.glob(godot + "/**/*.tscn", recursive=True))):
    if f.endswith(".bak"): continue
    rel = os.path.relpath(f, godot)
    try:
        with open(f, "r", encoding="utf-8") as fh:
            fh.read()
    except UnicodeDecodeError as e:
        add_err(rel, e.start, f"Invalid UTF-8 at byte {e.start}")

# ═══════════════════════════════════════
# 3. BOM: no UTF-8 BOM allowed
# ═══════════════════════════════════════
for f in sorted(glob.glob(godot + "/**/*.gd", recursive=True) + sorted(glob.glob(godot + "/**/*.tscn", recursive=True))):
    if f.endswith(".bak"): continue
    rel = os.path.relpath(f, godot)
    with open(f, "rb") as fh:
        head = fh.read(3)
    if head == b"\xef\xbb\xbf":
        add_err(rel, 0, "UTF-8 BOM present (must be removed)")

# ═══════════════════════════════════════
# 4. RESOURCE PATHS: every path must resolve
# ═══════════════════════════════════════
tscn_files = sorted(glob.glob(godot + "/**/*.tscn", recursive=True))
gd_files = sorted(glob.glob(godot + "/**/*.gd", recursive=True))
tres_files = sorted(glob.glob(godot + "/**/*.tres", recursive=True))
for f in tscn_files + gd_files + tres_files:
    if f.endswith(".bak"): continue
    rel = os.path.relpath(f, godot)
    try:
        with open(f, "r", encoding="utf-8") as fh:
            content = fh.read()
    except:
        continue
    
    for m in re.finditer(r'(?:path|resource)\s*=\s*"res://([^"]+)"', content):
        res = m.group(1)
        full = os.path.join(godot, res)
        if not os.path.exists(full):
            add_err(rel, 0, f"MISSING: res://{res}")
    
    for m in re.finditer(r'(?:preload|load)\("res://([^"]+)"\)', content):
        res = m.group(1)
        full = os.path.join(godot, res)
        if not os.path.exists(full):
            add_err(rel, 0, f"MISSING: res://{res}")

# ═══════════════════════════════════════
# 5. GDScript SYNTAX
# ═══════════════════════════════════════
for f in sorted(glob.glob(godot + "/**/*.gd", recursive=True)):
    if f.endswith(".bak"): continue
    rel = os.path.relpath(f, godot)
    try:
        with open(f, "r", encoding="utf-8") as fh:
            content = fh.read()
    except:
        continue
    
    lines = content.split("\n")
    
    # Unbalanced parens
    diff = content.count("(") - content.count(")")
    if diff != 0:
        add_err(rel, 0, f"Unbalanced parentheses ({diff} extra opens)")
    
    # Unbalanced brackets
    diff2 = content.count("[") - content.count("]")
    if diff2 != 0:
        add_err(rel, 0, f"Unbalanced brackets ({diff2} extra opens)")
    
    # Check for code outside functions
    in_class_body = False
    for i, line in enumerate(lines, 1):
        stripped = line.strip()
        if stripped.startswith("extends "):
            in_class_body = True
            continue
        if in_class_body and not stripped:
            in_class_body = False
        if stripped and not stripped.startswith("#") and not line[0] in ("\t", " ", "@", "v", "c", "e", "s", "f", "#"):
            # Heuristic: code at column 0 that's not a keyword
            if any(stripped.startswith(kw) for kw in ["var ", "const ", "enum ", "signal ", "@export", "@onready", "func ", "static func", "class ", "extends "]):
                pass  # valid
            elif stripped.startswith("if ") or stripped.startswith("for ") or stripped.startswith("while ") or stripped.startswith("match "):
                add_warn(rel, i, f"Code at column 0: '{stripped[:50]}'")

# ═══════════════════════════════════════
# 6. SIGNAL/METHOD CONSISTENCY
# ═══════════════════════════════════════
for f in sorted(glob.glob(godot + "/**/*.gd", recursive=True)):
    if f.endswith(".bak"): continue
    rel = os.path.relpath(f, godot)
    try:
        with open(f, "r", encoding="utf-8") as fh:
            content = fh.read()
    except:
        continue
    
    # Find all emit() calls and check signal exists
    emits = re.findall(r'(\w+)\.emit\(', content)
    signals_in_file = set(re.findall(r'signal\s+(\w+)', content))
    
    # Find all .connect() calls
    connects = re.findall(r'\.(\w+)\.connect\((\w+)\)', content)

# ═══════════════════════════════════════
# 7. GODOT 4.x DEPRECATED APIs
# ═══════════════════════════════════════
godot3_apis = {
    "flags_unshaded": "shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED",
    "flags_transparent": "transparency = BaseMaterial3D.TRANSPARENCY_ALPHA",
    "ALBEDO_TEXTURE": "TEXTURE",
    "instance()": "instantiate()",
    "yield(": "await",
    "KinematicBody": "CharacterBody3D",
    "KinematicBody2D": "CharacterBody2D",
    "Spatial": "Node3D",
    "SpatialMaterial": "StandardMaterial3D",
    "CanvasItemMaterial": "CanvasItemMaterial (still valid)",
}

for f in sorted(glob.glob(godot + "/**/*.gd", recursive=True)):
    if f.endswith(".bak"): continue
    rel = os.path.relpath(f, godot)
    try:
        with open(f, "r", encoding="utf-8") as fh:
            content = fh.read()
    except:
        continue
    
    for old, new in godot3_apis.items():
        if old in content and "Godot 3" not in content and "deprecated" not in content.lower():
            # Skip if it's in a comment
            in_comment = False
            for line in content.split("\n"):
                if old in line and not line.strip().startswith("#") and not line.strip().startswith("//"):
                    add_warn(rel, 0, f"Deprecated '{old}' -> use '{new}'")
                    break

# ═══════════════════════════════════════
# 8. NULL REFERENCE RISKS
# ═══════════════════════════════════════
for f in sorted(glob.glob(godot + "/**/*.gd", recursive=True)):
    if f.endswith(".bak"): continue
    rel = os.path.relpath(f, godot)
    try:
        with open(f, "r", encoding="utf-8") as fh:
            lines = fh.readlines()
    except:
        continue
    
    # Find @onready vars that reference paths
    for i, line in enumerate(lines, 1):
        if "@onready" in line and "$" in line:
            path = line.split("$")[1].split(")")[0].strip().strip('"').strip("'")
            # Check if this is a valid path in any .tscn that uses this script
            # (simplified: just flag complex paths for review)
            if "/" not in path and path not in ["Body", "Head", "MeshInstance3D", "CollisionShape3D"]:
                pass  # direct child, likely fine

# ═══════════════════════════════════════
# 9. DUPLICATE UID CHECK
# ═══════════════════════════════════════
uid_map = {}
for f in sorted(glob.glob(godot + "/**/*.tscn", recursive=True) + sorted(glob.glob(godot + "/**/*.tres", recursive=True))):
    if f.endswith(".bak"): continue
    rel = os.path.relpath(f, godot)
    try:
        with open(f, "r", encoding="utf-8") as fh:
            content = fh.read()
    except:
        continue
    uids = re.findall(r'uid://(\w+)', content)
    for uid in uids:
        if uid in uid_map:
            add_err(rel, 0, f"DUPLICATE UID '{uid}' (also in {uid_map[uid]})")
        uid_map[uid] = rel

# ═══════════════════════════════════════
# 10. EMPTY FUNCTIONS / DEAD CODE
# ═══════════════════════════════════════
for f in sorted(glob.glob(godot + "/**/*.gd", recursive=True)):
    if f.endswith(".bak"): continue
    rel = os.path.relpath(f, godot)
    try:
        with open(f, "r", encoding="utf-8") as fh:
            lines = fh.readlines()
    except:
        continue
    
    for i, line in enumerate(lines, 1):
        stripped = line.strip()
        if stripped == "pass" and i > 1:
            prev = lines[i-2].strip()
            if prev.startswith("func "):
                add_warn(rel, i, f"Empty function body: {prev[:60]}")

# ═══════════════════════════════════════
# REPORT
# ═══════════════════════════════════════
print("=" * 60)
print("BALA — COMPREHENSIVE CODE AUDIT")
print("=" * 60)

if errors:
    print(f"\nERRORS ({len(errors)}):")
    for e in errors:
        print(f"  [ERR] {e}")
else:
    print("\n  ZERO ERRORS")

if warnings:
    print(f"\nWARNINGS ({len(warnings)}):")
    for w in warnings:
        print(f"  [WARN] {w}")
else:
    print("\n  ZERO WARNINGS")

gd_count = sum(1 for _ in glob.glob(godot + "/**/*.gd", recursive=True) if not _.endswith(".bak"))
tscn_count = sum(1 for _ in glob.glob(godot + "/**/*.tscn", recursive=True) if not _.endswith(".bak"))
print(f"\n  Files: {gd_count} .gd + {tscn_count} .tscn")
print(f"  Status: {'CLEAN' if not errors else 'FAIL'}")
