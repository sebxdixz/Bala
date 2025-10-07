# 🚀 Guía de Setup - Gangster MMO RPG

## Setup Inicial en Godot 4

### 1. Importar el Proyecto
1. Abre Godot 4.3 o superior
2. Clica "Import" en el Project Manager
3. Navega a la carpeta `gangster-mmo-rpg`
4. Selecciona el archivo `project.godot`
5. Clica "Import & Edit"

### 2. Configuración de Pixel Art
Las configuraciones ya están en el `project.godot`, pero verifica:

**Project Settings > Rendering > Textures:**
- Canvas Textures > Default Texture Filter: `Nearest`

**Project Settings > Rendering > 2D:**
- Use Pixel Snap: `On`

**Project Settings > Rendering > Scaling 3D:**
- Mode: `FSR 1.0`

### 3. Crear la Primera Escena del Jugador

1. **Crear Player.tscn:**
   - Scene > New Scene
   - Add Node > CharacterBody3D (renombrar a "Player")
   - Attach script: `scripts/player/Player.gd`

2. **Estructura del Player:**
   ```
   Player (CharacterBody3D) - Script: Player.gd
   ├── PlayerMesh (MeshInstance3D)
   │   └── Mesh: BoxMesh (temporal)
   │   └── Material: StandardMaterial3D
   ├── CollisionShape3D
   │   └── Shape: BoxShape3D
   ├── CameraPivot (Node3D)
   │   └── Camera3D
   └── InventoryManager (Node) - Script: InventoryManager.gd
   ```

3. **Configurar el BoxMesh:**
   - Size: (1, 2, 1) para simular un personaje
   - Material: Crear un StandardMaterial3D
   - Albedo: Color vibrante (ej: naranja, verde)
   - Flags > Unshaded: On (para look pixel art)

### 4. Crear Escena de Testing

1. **Crear TestLevel.tscn:**
   - Scene > New Scene  
   - Add Node > Node3D (renombrar a "TestLevel")

2. **Agregar un piso:**
   ```
   TestLevel (Node3D)
   ├── Floor (StaticBody3D)
   │   ├── MeshInstance3D
   │   │   └── Mesh: BoxMesh (10x1x10)
   │   └── CollisionShape3D
   │       └── Shape: BoxShape3D (10x1x10)
   └── Player (instancia de Player.tscn)
   ```

### 5. Crear Game Manager Scene

1. **Crear Main.tscn:**
   ```
   Main (Node)
   ├── GameManager (Node) - Script: GameManager.gd
   │   ├── UIManager (Node) 
   │   └── AudioManager (Node)
   └── TestLevel (instancia de TestLevel.tscn)
   ```

## ⌨️ Controles por Defecto

- **WASD**: Movimiento
- **Shift**: Sprint  
- **Space**: Salto
- **Mouse**: Rotar cámara
- **I**: Toggle inventario
- **E**: Interactuar
- **ESC**: Pausa

## 🎯 Testing Inicial

1. Set `Main.tscn` como escena principal (Project Settings > Application > Run > Main Scene)
2. Presiona F5 para correr
3. Deberías poder moverte por el mundo con WASD y mouse
4. Presiona F12 en el juego para abrir la consola y ver los debug prints

## 🔧 Items de Prueba

El sistema viene con 3 items de ejemplo:
- **Buzo Adidas Vintage** (+15 flow, +20% robo)
- **Air Jordan Falsas** (+12 flow, +15% velocidad) 
- **Cadena Dorada Chunky** (+20 flow, +25% intimidación)

Estos se cargan automáticamente en el inventario para testing.

## 🎨 Siguientes Pasos de Arte

1. **Reemplazar BoxMesh del jugador** con un modelo 3D chunky
2. **Crear texturas pixel art** de baja resolución (16x16, 32x32)
3. **Configurar materiales** sin filtrado para mantener píxeles duros
4. **Agregar modelos de items** (buzos, zapatillas, cadenas)

## 🌐 Para MMO (Futuro)

Los scripts están preparados para networking con:
- Sistema de Player ID
- Señales para sincronización
- Separación entre lógica local y del servidor

## 🐛 Debug y Testing

- Usa `player.print_stats()` en la consola para ver stats
- `inventory_manager.print_inventory()` para ver items
- Los prints con emojis aparecen en Output para trackear acciones

---

¡Ahora tienes todo lo necesario para empezar a desarrollar tu MMO RPG gangster chunky! 🔥
