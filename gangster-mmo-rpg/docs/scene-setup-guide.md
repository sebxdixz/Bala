# 🎮 Setup de Escenas - Sistema de Movimiento y Cámaras

## Estructura Requerida para Player.tscn

Para que el sistema de movimiento WASD y cambio de cámara funcione correctamente, debes crear la siguiente estructura de nodos en Godot:

### Jerarquía de Nodos:

```
Player (CharacterBody3D) - Script: Player.gd
├── PlayerMesh (MeshInstance3D)
│   ├── Mesh: BoxMesh (1, 2, 1) temporal
│   └── Material: StandardMaterial3D (color vibrante)
├── CollisionShape3D
│   └── Shape: BoxShape3D (1, 2, 1)
├── CameraController (Node3D) - Script: CameraController.gd
│   ├── CameraArm (SpringArm3D)
│   │   ├── Spring Length: 5.0
│   │   ├── Collision Mask: Layer 2 (Environment)
│   │   └── Camera3D (Camera3D)
│   │       ├── FOV: 75
│   │       └── Current: true
│   └── FirstPersonCamera (Camera3D)
│       ├── Position Y: 1.7
│       └── Current: false
└── InventoryManager (Node) - Script: InventoryManager.gd
```

## Pasos de Configuración:

### 1. Crear Player.tscn

1. **Scene > New Scene**
2. **Add Node > CharacterBody3D** (renombrar a "Player")
3. **Attach Script**: Selecciona `scripts/player/Player.gd`

### 2. Agregar Mesh del Jugador

1. **Add Child al Player > MeshInstance3D** (renombrar a "PlayerMesh")
2. **En Inspector > Mesh**: New BoxMesh
3. **Configure BoxMesh**: Size (1, 2, 1)
4. **Material**: New StandardMaterial3D
   - Albedo Color: Naranja chunky (#FF6B35)
   - Flags > Unshaded: ON
   - Texture > Filter: OFF (pixel art)

### 3. Agregar Colisión

1. **Add Child al Player > CollisionShape3D**
2. **En Inspector > Shape**: New BoxShape3D
3. **Configure BoxShape3D**: Size (1, 2, 1)

### 4. Sistema de Cámaras

#### A. CameraController:
1. **Add Child al Player > Node3D** (renombrar a "CameraController")
2. **Attach Script**: Selecciona `scripts/player/CameraController.gd`
3. **Position**: (0, 2, 0) para elevar el punto de rotación

#### B. SpringArm para Tercera Persona:
1. **Add Child al CameraController > SpringArm3D** (renombrar a "CameraArm")
2. **Configure SpringArm3D**:
   - Spring Length: 5.0
   - Collision Mask: 2 (Layer Environment)
   - Margin: 0.2

#### C. Cámara de Tercera Persona:
1. **Add Child al CameraArm > Camera3D**
2. **Configure Camera3D**:
   - FOV: 75
   - Near: 0.1
   - Far: 100
   - Current: true

#### D. Cámara de Primera Persona:
1. **Add Child al CameraController > Camera3D** (renombrar a "FirstPersonCamera")
2. **Configure Camera3D**:
   - Position Y: 1.7
   - FOV: 90 (más amplio para primera persona)
   - Current: false

### 5. Agregar InventoryManager

1. **Add Child al Player > Node** (renombrar a "InventoryManager")
2. **Attach Script**: Selecciona `scripts/managers/InventoryManager.gd`

## Configuración del Nivel de Prueba

### Crear TestLevel.tscn:

```
TestLevel (Node3D)
├── Floor (StaticBody3D)
│   ├── MeshInstance3D
│   │   └── Mesh: BoxMesh (20, 1, 20)
│   └── CollisionShape3D
│       └── Shape: BoxShape3D (20, 1, 20)
├── Walls (StaticBody3D) - Opcional para probar colisiones de cámara
│   ├── MeshInstance3D
│   │   └── Mesh: BoxMesh (1, 3, 20)
│   └── CollisionShape3D
│       └── Shape: BoxShape3D (1, 3, 20)
└── Player (Instancia de Player.tscn)
    └── Position: (0, 1, 0)
```

## Configuración de Capas de Física

En **Project Settings > Layer Names > 3D Physics**:

- Layer 1: "Player"
- Layer 2: "Environment" ⭐ (Importante para colisión de cámara)
- Layer 3: "Items"
- Layer 4: "NPCs"
- Layer 5: "Enemies"

**Asignar capas**:
- Floor/Walls: Layer 2 (Environment)
- Player: Layer 1 (Player)

## Controles:

- **W/A/S/D**: Movimiento relativo a la cámara
- **Mouse**: Rotar cámara (capturado automáticamente)
- **V**: Cambiar entre primera y tercera persona
- **Shift**: Correr
- **Space**: Saltar
- **I**: Inventario (placeholder)
- **ESC**: Liberar/capturar mouse

## Testing:

1. **Set TestLevel.tscn** como escena principal
2. **F5** para correr
3. **Verifica**:
   - Movimiento WASD relativo a cámara
   - Rotación suave del personaje hacia dirección de movimiento
   - Cambio de cámara con V
   - Mouse look funcional
   - Salto y gravedad
   - Colisión de cámara con paredes (SpringArm)

## Troubleshooting:

**🐛 La cámara no se mueve con el mouse:**
- Verifica que el mouse esté capturado (debería estar automático)
- Presiona ESC y vuelve a hacer click en la ventana

**🐛 El personaje no rota hacia donde camina:**
- Verifica que el CameraController esté como hijo directo del Player
- Asegúrate que la estructura de nodos sea exacta

**🐛 La cámara de tercera persona atraviesa paredes:**
- Configura la Collision Mask del SpringArm en Layer 2
- Asegúrate que las paredes estén en Layer 2 (Environment)

**🐛 El cambio de cámara no funciona:**
- Verifica que ambas cámaras estén configuradas correctamente
- Una debe tener Current: true, la otra Current: false inicialmente

¡Con esta configuración tendrás un sistema de movimiento 3D completo y profesional! 🎮
