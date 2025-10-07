# 🚀 Guía de Inicio Rápido - Gangster MMO RPG

## ⚡ Cómo Empezar

### 1️⃣ Abrir el Motor Godot
```
📂 Navega a: SdS/godot-engine/
🖱️ Ejecuta: Godot_v4.5-stable_win64.exe
```

### 2️⃣ Abrir el Proyecto
En el motor Godot:
- Click en "Importar"
- Navega a: `SdS/gangster-mmo-rpg/project.godot`
- Click en "Importar y Editar"

### 3️⃣ Verificar Configuración
El proyecto ya está configurado con:
- ✅ Modo de renderizado 3D optimizado
- ✅ Configuración para pixel art (filtro desactivado)
- ✅ Controles de jugador (WASD, Espacio, Shift)
- ✅ Sistema de física configurado

## 📁 Estructura del Proyecto

```
gangster-mmo-rpg/
├── 📂 assets/          # Aquí van tus modelos 3D, texturas, audio
│   ├── art/
│   │   ├── characters/  # Personajes
│   │   ├── items/       # Armas y ropa
│   │   ├── environment/ # Mapas y escenarios
│   │   └── ui/          # Interfaz
│   └── audio/          # Música y efectos de sonido
│
├── 📂 scenes/          # Escenas de Godot (.tscn)
│   ├── player/
│   ├── items/
│   ├── environment/
│   ├── ui/
│   └── main_menu/
│
├── 📂 scripts/         # Código GDScript
│   ├── player/         # Lógica del jugador
│   ├── items/          # Sistema de inventario
│   ├── combat/         # Sistema de combate
│   ├── managers/       # Managers globales
│   ├── networking/     # Multiplayer
│   └── ui/            # Interfaz de usuario
│
├── 📂 resources/       # Datos y configuraciones
├── 📂 materials/       # Materiales 3D
├── 📂 shaders/         # Shaders personalizados
└── 📂 docs/           # Documentación adicional
```

## 🎮 Scripts Incluidos

### Ya Implementados:
- **Player.gd** - Movimiento, cámara, físicas del jugador
- **CameraController.gd** - Control de cámara tercera persona
- **Item.gd** - Clase base para items
- **ClothingItem.gd** - Sistema de ropa con stats
- **InventoryManager.gd** - Gestión de inventario
- **GameManager.gd** - Manager global del juego

## 📚 Próximos Pasos

1. **Crear la Primera Escena**
   - Lee: `docs/scene-setup-guide.md`
   - Crea una escena de prueba con el jugador

2. **Agregar Assets**
   - Descomprime `assets/exported-assets.zip` si tienes assets
   - O importa tus propios modelos 3D

3. **Probar el Movimiento**
   - Crea una escena simple
   - Instancia el nodo Player
   - Presiona F5 para probar

## 🎯 Controles del Juego

| Tecla | Acción |
|-------|--------|
| W/A/S/D | Movimiento |
| Espacio | Saltar |
| Shift | Correr |
| E | Interactuar |
| I | Inventario |
| V | Cambiar cámara |
| Mouse | Rotar cámara |

## 📖 Documentación Adicional

- **README.md** - Descripción completa del proyecto
- **docs/SETUP.md** - Guía de configuración detallada
- **docs/scene-setup-guide.md** - Cómo configurar escenas
- **docs/example-items.md** - Ejemplos de items divertidos

## ⚠️ Notas Importantes

- La carpeta `sd-s/` es un proyecto de prueba vacío y puede eliminarse
- Los ejecutables de Godot están en `godot-engine/` (fuera del proyecto)
- El archivo `.gitignore` ya está configurado para Godot 4
- La carpeta `docs/` tiene un `.gdignore` para que Godot no la importe

## 🔧 Solución de Problemas

**Error al abrir el proyecto:**
- Asegúrate de usar Godot 4.3 o superior
- Verifica que estás abriendo `project.godot` en `gangster-mmo-rpg/`

**No se ve nada al presionar F5:**
- Configura una escena principal en Proyecto > Configuración del Proyecto
- O presiona F6 para ejecutar la escena actual

---
**¡Ahora estás listo para empezar a desarrollar! 🎮**
