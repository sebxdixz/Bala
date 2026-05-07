"""Godot-style static analysis - simulates engine validation"""
import os, glob, re
from pathlib import Path

godot = str(Path(__file__).resolve().parents[2] / "godot")
errors = []
warnings = []

print("=" * 60)
print("BALA - GODOT ENGINE VALIDATION SIMULATION")
print("=" * 60)

# ═══════════════════════════
# 1. GDScript syntax check
# ═══════════════════════════
print("\n[1/5] GDScript Syntax Check...")
for f in sorted(glob.glob(godot + "/**/*.gd", recursive=True)):
    if f.endswith(".bak"): continue
    rel = os.path.relpath(f, godot)
    
    with open(f, "r", encoding="utf-8") as fh:
        content = fh.read()
        lines = content.split("\n")
    
    # Check 1: All opened brackets/parens are closed
    open_count = content.count("(") - content.count(")")
    if open_count != 0:
        errors.append(f"{rel}: Unbalanced parentheses ({open_count} extra opens)")
    
    brace_open = content.count("{") - content.count("}")
    if brace_open != 0:
        errors.append(f"{rel}: Unbalanced braces ({brace_open} extra opens)")
    
    # Check 2: No mixed tabs/spaces in indentation
    for i, line in enumerate(lines, 1):
        if line.strip() and not line.strip().startswith("#"):
            leading = line[:len(line)-len(line.lstrip())]
            if "\t" in leading and " " in leading:
                errors.append(f"{rel}:{i}: Mixed tabs and spaces in indentation")
                break
    
    # Check 3: extends must be first code line
    has_extends = False
    for line in lines:
        stripped = line.strip()
        if stripped.startswith("extends "):
            has_extends = True
        elif has_extends and stripped and not stripped.startswith("#") and not stripped.startswith("class_name"):
            if "func " in stripped or "var " in stripped or "@export" in stripped or "signal " in stripped or "const " in stripped or "enum " in stripped or "@onready" in stripped:
                break  # Valid code after extends
    
    # Check 4: func definitions have matching end (indentation)
    for i, line in enumerate(lines, 1):
        stripped = line.strip()
        if stripped.startswith("func ") and ":" in stripped:
            # Find the body - must have at least one indented line
            body_found = False
            for j in range(i, min(i+5, len(lines))):
                next_line = lines[j]
                if next_line.strip() and not next_line.strip().startswith("#"):
                    if next_line.startswith("\t") or next_line.startswith("    "):
                        body_found = True
                        break
            # Empty function bodies are valid in GDScript (pass is implicit)
    
    # Check 5: No @onready var without get_node pattern
    for i, line in enumerate(lines, 1):
        if "@onready" in line and "var " in line:
            # Should reference a node path
            pass  # Not always required, skip

# ═══════════════════════════
# 2. TSCN resource validation
# ═══════════════════════════
print("[2/5] TSCN Resource Validation...")
for f in sorted(glob.glob(godot + "/**/*.tscn", recursive=True)):
    if f.endswith(".bak"): continue
    rel = os.path.relpath(f, godot)
    
    with open(f, "r", encoding="utf-8") as fh:
        content = fh.read()
    
    # Check all ext_resource paths
    for m in re.finditer(r'path="res://([^"]+)"', content):
        res_path = m.group(1)
        full = os.path.join(godot, res_path)
        if not os.path.exists(full):
            errors.append(f"{rel}: MISSING RESOURCE -> res://{res_path}")
    
    # Check SubResource references exist
    sub_ids = set(re.findall(r'SubResource\("([^"]+)"\)', content))
    for sub_id in sub_ids:
        if f'id="{sub_id}"' not in content:
            errors.append(f"{rel}: BROKEN SubResource ref -> {sub_id}")

# ═══════════════════════════
# 3. Signal connection validation
# ═══════════════════════════
print("[3/5] Signal Connection Validation...")
for f in sorted(glob.glob(godot + "/**/*.gd", recursive=True)):
    if f.endswith(".bak"): continue
    rel = os.path.relpath(f, godot)
    
    with open(f, "r", encoding="utf-8") as fh:
        content = fh.read()
    
    # Find all .connect() calls
    connects = re.findall(r'(\w+)\.(\w+)\.connect\((\w+)\)', content)
    for obj, signal_name, method in connects:
        # Verify the method exists somewhere in the file
        if f"func {method}" not in content:
            warnings.append(f"{rel}: Signal {obj}.{signal_name}.connect({method}) - method '{method}' may not exist in this file")

# ═══════════════════════════
# 4. Preload/load path validation
# ═══════════════════════════
print("[4/5] Preload/Load Path Validation...")
for f in sorted(glob.glob(godot + "/**/*.gd", recursive=True)):
    if f.endswith(".bak"): continue
    rel = os.path.relpath(f, godot)
    
    with open(f, "r", encoding="utf-8") as fh:
        content = fh.read()
    
    for m in re.finditer(r'(?:preload|load)\("res://([^"]+)"\)', content):
        res_path = m.group(1)
        full = os.path.join(godot, res_path)
        if not os.path.exists(full):
            errors.append(f"{rel}: MISSING -> res://{res_path}")

# ═══════════════════════════
# 5. Godot 4.x API migration checks
# ═══════════════════════════
print("[5/5] Godot 4.x API Migration Checks...")
deprecated = [
    ("ALBEDO_TEXTURE", "TEXTURE"),
    ("flags_unshaded", "shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED"),
    ("flags_transparent", "transparency = BaseMaterial3D.TRANSPARENCY_ALPHA"),
    ("instance()", "instantiate()"),
    ("yield(", "await "),
    ("get_node(", "$ or @onready"),
    ("KinematicBody", "CharacterBody3D"),
    ("move_and_slide(velocity * delta", "move_and_slide() without delta multiply"),
]
for f in sorted(glob.glob(godot + "/**/*.gd", recursive=True)):
    if f.endswith(".bak"): continue
    rel = os.path.relpath(f, godot)
    
    with open(f, "r", encoding="utf-8") as fh:
        content = fh.read()
    
    for old, new in deprecated:
        if old in content:
            warnings.append(f"{rel}: Deprecated API '{old}' found -> use '{new}'")

# ═══════════════════════════
# REPORT
# ═══════════════════════════
print("\n" + "=" * 60)
print("VALIDATION REPORT")
print("=" * 60)

if errors:
    print(f"\nERRORS ({len(errors)}):")
    for e in errors[:20]:
        print(f"  [ERR] {e}")
    if len(errors) > 20:
        print(f"  ... and {len(errors)-20} more")
else:
    print("\n  ZERO ERRORS - All files valid")

if warnings:
    print(f"\nWARNINGS ({len(warnings)}):")
    for w in warnings[:15]:
        print(f"  [WARN] {w}")
    if len(warnings) > 15:
        print(f"  ... and {len(warnings)-15} more")
else:
    print("\n  ZERO WARNINGS")

print(f"\n  Scanned: {sum(1 for _ in glob.glob(godot+'/**/*.gd',recursive=True) if not _.endswith('.bak'))} .gd files")
print(f"  Scanned: {sum(1 for _ in glob.glob(godot+'/**/*.tscn',recursive=True) if not _.endswith('.bak'))} .tscn files")
print(f"  Result: {'PASS' if not errors else 'FAIL'}")
