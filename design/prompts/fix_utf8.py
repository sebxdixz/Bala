import os, glob, shutil

godot_dir = r"C:\Users\sdiaz\OneDrive - Axo\Escritorio\Proyectos\BALA\godot"

for gd_file in glob.glob(godot_dir + "/**/*.gd", recursive=True):
    with open(gd_file, "rb") as f:
        raw = f.read()
    
    try:
        text = raw.decode("utf-8", errors="strict")
        already_clean = True
    except UnicodeDecodeError:
        # Try decoding as Windows-1252 first
        try:
            text = raw.decode("cp1252")
            already_clean = False
        except:
            # Fallback: decode as latin-1 (always succeeds)
            text = raw.decode("latin-1", errors="replace")
            already_clean = False
    
    if not already_clean:
        # Remove BOM if present
        if text.startswith("\ufeff"):
            text = text[1:]
        # Replace smart quotes and other cp1252 specific chars that are invalid UTF-8
        replacements = {
            "\x97": "\u2014",  # em dash
            "\x96": "\u2013",  # en dash
            "\x91": "\u2018",  # left single quote
            "\x92": "\u2019",  # right single quote
            "\x93": "\u201c",  # left double quote
            "\x94": "\u201d",  # right double quote
            "\x95": "\u2022",  # bullet
        }
        for old, new in replacements.items():
            if old in text:
                text = text.replace(old, new)
        
        # Backup original
        bak = gd_file + ".bak"
        shutil.copy2(gd_file, bak)
        
        # Write clean UTF-8
        with open(gd_file, "w", encoding="utf-8", newline="\n") as f:
            f.write(text)
        
        print(f"FIXED: {os.path.basename(gd_file)} (cp1252 -> UTF-8)")
    else:
        print(f"  OK: {os.path.basename(gd_file)}")

print("\nAll .gd files processed.")
