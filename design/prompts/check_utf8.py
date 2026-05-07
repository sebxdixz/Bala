import os, glob

godot_dir = r"C:\Users\sdiaz\OneDrive - Axo\Escritorio\Proyectos\BALA\godot"

for gd_file in glob.glob(godot_dir + "/**/*.gd", recursive=True):
    with open(gd_file, "rb") as f:
        data = f.read()
    try:
        data.decode("utf-8", errors="strict")
    except UnicodeDecodeError as e:
        print(f"INVALID: {os.path.basename(gd_file)}")
        print(f"  Byte {e.start}: {e.reason}")
        start = max(0, e.start - 10)
        end = min(len(data), e.start + 10)
        ctx = data[start:end]
        print(f"  Hex around error: {ctx.hex(' ')}")
        print(f"  Latin1 decode: {ctx.decode('latin-1', errors='replace')}")

print("--- DONE ---")
