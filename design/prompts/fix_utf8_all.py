import os, glob, shutil

godot_dir = r"C:\Users\sdiaz\OneDrive - Axo\Escritorio\Proyectos\BALA\godot"
fixed_count = 0

for ext in ["*.tscn", "*.tres", "*.gdshader"]:
    for f in glob.glob(godot_dir + "/**/" + ext, recursive=True):
        with open(f, "rb") as fh:
            raw = fh.read()
        try:
            raw.decode("utf-8", errors="strict")
        except UnicodeDecodeError:
            try:
                text = raw.decode("cp1252")
            except:
                text = raw.decode("latin-1", errors="replace")
            
            # Fix smart quotes and special chars
            replacements = {
                "\x97": "\u2014", "\x96": "\u2013",
                "\x91": "\u2018", "\x92": "\u2019",
                "\x93": "\u201c", "\x94": "\u201d",
                "\x95": "\u2022",
            }
            for old, new in replacements.items():
                if old in text:
                    text = text.replace(old, new)
            
            shutil.copy2(f, f + ".bak")
            with open(f, "w", encoding="utf-8", newline="\n") as fh:
                fh.write(text)
            print(f"FIXED: {os.path.basename(f)}")
            fixed_count += 1

print(f"\nTotal fixed: {fixed_count} files")
