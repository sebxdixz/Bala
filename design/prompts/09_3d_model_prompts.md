# BSLO — PROMPTS PARA MODELADO 3D LOW POLY
## design/prompts/09_3d_model_prompts.md
**Version:** 2.0 | **Herramientas:** Meshy.ai / Tripo3D / Spline AI / Blender

---

## 1. ESPECIFICACIONES TECNICAS

### Parametros para TODOS los modelos 3D
```
- Polygon count: <2000 triangles (personajes), <1000 (props), <3000 (vehiculos)
- Texture resolution: 512x512 (standard), 256x256 (small props)
- Texture style: flat colors, hand-painted look, no realism
- UV mapping: atlas-friendly, non-overlapping
- Rigging: Mixamo-compatible skeleton (T-pose, 65 bones max)
- Format: .glb or .fbx for Godot 4 import
- Scale: meters, character ~1.8m tall
- Normals: flat shading (no smooth groups for low poly look)
```

---

## 2. PROMPTS PARA MESHY.AI (Image-to-3D)

### Template de Prompt para Meshy
```
"A low poly 3D model of [SUBJECT], game-ready for Godot Engine,
cell shaded style, flat colors, clean topology, under 2000 polygons,
T-pose, front view, stylized chunky proportions, MU Online inspired,
no realistic textures, bold color blocking, outline-ready geometry"
```

### Template de Prompt para Tripo3D
```
"Low poly game asset: [SUBJECT]. PS2 retro 3D style, flat shaded,
chunky geometry, clean silhouette, under 1500 tris, game-ready,
cartoon proportions, isometric camera friendly, Godot compatible"
```

### Template para Spline AI (Generacion por texto)
```
"Create a 3D low poly [SUBJECT] in [STYLE]. Use flat colors,
cell shading, retro game aesthetic. Keep polygon count low.
Style: MU Online meets GTA San Andreas. Godot Engine export."
```

---

## 3. CATEGORIAS DE MODELOS (Prioridad)

### FASE 1 — Personajes (Meshy Image-to-3D)

Usar los concept art generados en `01_characters_factions.md` como imagen de entrada.

| Prioridad | Modelo | Tris Max | Notas |
|-----------|--------|----------|-------|
| **P1** | Male Yakuza Maton (Tank MVP) | 2000 | Primer personaje jugable |
| **P1** | Female Cholo Gatillero (DPS MVP) | 2000 | Contraste visual maximo |
| **P1** | Male Cartel Doctor de Barrio (Healer MVP) | 2000 | Ropa unica |
| **P2** | Male Mafia Capo (Support MVP) | 2000 | Traje elegante |
| **P2** | Female Policia SWAT (Tank MVP) | 2000 | Armadura pesada |
| **P2** | Male Sin-Legaja Vandal (DPS MVP) | 2000 | Mezcla de ropa |
| **P3** | 14 clases base × 1 genero c/u | 2000 | El resto del roster |

### FASE 2 — NPCs Clave (Meshy Image-to-3D)

| Prioridad | NPC | Tris Max | Funcion |
|-----------|-----|----------|---------|
| **P1** | Don Vincenzo | 2500 | Quest giver Mafia |
| **P1** | El Compa Chuy | 2000 | Vendor Cartel |
| **P1** | Sargento Rodriguez | 2000 | Quest giver Policia |
| **P1** | La Abuela del Barrio | 1800 | Vendor Cholo |
| **P1** | Dogman (Vendedor Hot Dogs) | 2000 | Vendor movil |
| **P2** | Kazuto Nakamura | 2500 | Boss Yakuza |
| **P2** | Firulais (perro) | 800 | Mascota/NPC |

### FASE 3 — Armas (Meshy Image-to-3D)

| Prioridad | Arma | Tris Max |
|-----------|------|----------|
| **P1** | Bate de beisbol | 400 |
| **P1** | Pistola estandar | 500 |
| **P1** | Katana | 600 |
| **P1** | AK-47 | 800 |
| **P2** | Escopeta | 700 |
| **P2** | Tommy Gun | 800 |
| **P2** | RPG | 600 |
| **P3** | Resto de armas (20+) | 500 avg |

### FASE 4 — Vehiculos (Meshy Image-to-3D)

| Prioridad | Vehiculo | Tris Max |
|-----------|----------|----------|
| **P1** | Sedan negro Yakuza | 2500 |
| **P1** | Patrulla Policia | 2500 |
| **P1** | Pickup Cartel | 3000 |
| **P2** | Moto deportiva | 1500 |
| **P2** | Lowrider Cholo | 3000 |
| **P3** | Resto de vehiculos | 2500 avg |

### FASE 5 — Props y Entorno (Spline AI / Blender)

| Categoria | Cantidad | Tris Max c/u |
|-----------|----------|--------------|
| Edificios modulares (por sector) | 20 | 500 |
| Mobiliario urbano (bancos, farolas, etc.) | 15 | 200 |
| Señales y letreros de neon | 10 | 150 |
| Puestos de mercado | 5 | 400 |
| Elementos de cobertura (cajas, barriles) | 8 | 150 |
| Vegetacion low poly (arboles, arbustos) | 6 | 300 |

---

## 4. WORKFLOW DE PRODUCCION 3D

### Pipeline Completo
```
1. [GPT Image 2]    -> Generar concept art (PNG, 1024x1024)
2. [Remove.bg]      -> Quitar fondo automaticamente
3. [Meshy.ai]       -> Image-to-3D, generar .glb con textura
4. [Blender]        -> Limpiar geometria, optimizar UVs, ajustar escala
5. [Mixamo]         -> Auto-riggear personajes, descargar animaciones base
6. [Godot 4]        -> Importar .glb, asignar shader low_poly_outline
7. [Godot 4]        -> Crear AnimationPlayer, asignar BlendSpace2D
8. [Test]           -> Verificar en escena test_world.tscn
```

### Script de Automatizacion (Concepto - PowerShell)

```powershell
# batch_3d_workflow.ps1
# 1. Generar concept art via API
python generate_concepts.py --category characters --count 36

# 2. Quitar fondos
Get-ChildItem "output\*.png" | ForEach-Object {
    curl -X POST https://api.remove.bg/v1.0/removebg `
      -H "X-Api-Key: $env:REMOVEBG_KEY" `
      -F "image_file=@$($_.FullName)" `
      -o "output_clean\$($_.BaseName)_nobg.png"
}

# 3. Enviar a Meshy (manual o API)
# Meshy acepta batch upload via web UI o API
```

---

## 5. CONFIGURACION DE EXPORTACION PARA GODOT 4

### Ajustes de Importacion en Godot
```gdscript
# Al importar modelos .glb en Godot 4:
# 1. Seleccionar archivo .glb en FileSystem
# 2. Inspector -> Import:
#    - Animation > Import: true (si tiene animaciones)
#    - Meshes > Light Baking: Disabled (low poly no necesita)
#    - Meshes > Generate LODs: false
#    - Materials > Storage: Files (.material)
#    - Materials > Material Override: low_poly_outline.tres
# 3. Reimport
```

### Aplicar Shader Automaticamente
```gdscript
# script: apply_shader_to_imports.gd (EditorScript)
@tool
extends EditorScript

func _run():
    var shader = load("res://shaders/low_poly_outline.gdshader")
    var dir = "res://assets/characters/"
    var files = DirAccess.get_files_at(dir)
    
    for file in files:
        if file.ends_with(".import"):
            var path = dir + file.replace(".import", "")
            var mat = StandardMaterial3D.new()
            mat.shading_style = BaseMaterial3D.SHADING_STYLE_UNSHADED  # para toon
            ResourceSaver.save(mat, path.replace(".glb", ".material"))
```

---

*<<Total: ~50 modelos 3D para MVP. Costo estimado: ~$150 USD en Meshy.ai. Tiempo: ~1-2 semanas para generacion + limpieza.>>*
