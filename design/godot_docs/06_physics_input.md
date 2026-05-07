# Física e Input - Godot 4.x

> Documentación oficial de Godot Engine 4.6 en español

---

# PARTE 1: Introducción a la Física

Fuente: https://docs.godotengine.org/es/stable/tutorials/physics/physics_introduction.html

## Conceptos Básicos

- **Detección de colisiones**: Saber cuándo dos objetos se superponen o entran en contacto
- **Respuesta a la colisión**: Lo que sucede cuando se detecta una colisión

Godot ofrece varios objetos de colisión en 2D y 3D. Los ejemplos usan objetos 2D, pero cada uno tiene su equivalente 3D.

## Tipos de Objetos de Colisión

### Area2D / Area3D
Proveen **detección** e **influencia**:
- Detectan cuando objetos se superponen
- Emiten señales cuando cuerpos entran/salen
- Pueden sobrescribir propiedades físicas (gravedad, resistencia) en una zona

### StaticBody2D / StaticBody3D
Cuerpo que **no es movido** por el motor de física:
- Participa en detección de colisiones
- No se mueve en respuesta a colisiones
- Ideal para paredes, pisos, objetos del entorno
- Puede tener `constant_linear_velocity` y `constant_angular_velocity` (plataformas móviles, cintas transportadoras)

### RigidBody2D / RigidBody3D
Implementa **simulación de física completa**:
- No se controla directamente, se aplican fuerzas
- El motor calcula movimiento, colisiones, rebotes, rotación
- Afectado por gravedad, fricción, elasticidad
- Entra en reposo cuando está inmóvil (optimización)

```gdscript
extends RigidBody2D

var thrust = Vector2(0, -250)
var torque = 20000

func _integrate_forces(state):
    if Input.is_action_pressed("ui_up"):
        state.apply_force(thrust.rotated(rotation))
    else:
        state.apply_force(Vector2())
    var rotation_direction = 0
    if Input.is_action_pressed("ui_right"):
        rotation_direction += 1
    if Input.is_action_pressed("ui_left"):
        rotation_direction -= 1
    state.apply_torque(rotation_direction * torque)
```

### CharacterBody2D / CharacterBody3D
Cuerpo con **detección de colisiones pero sin física**:
- Todo movimiento y respuesta debe implementarse en código
- Usa `move_and_collide()` o `move_and_slide()`
- Ideal para personajes controlados por el jugador

#### move_and_collide()
Retorna un objeto `KinematicCollision2D` con información de la colisión:

```gdscript
var collision_info = move_and_collide(velocity * delta)
if collision_info:
    velocity = velocity.bounce(collision_info.get_normal())
```

#### move_and_slide()
Desliza a lo largo de superficies. NO multiplicar velocity por delta (lo hace automáticamente):

```gdscript
extends CharacterBody2D

var run_speed = 350
var jump_speed = -1000
var gravity = 2500

func get_input():
    velocity.x = 0
    if Input.is_action_pressed('ui_right'): velocity.x += run_speed
    if Input.is_action_pressed('ui_left'): velocity.x -= run_speed
    if is_on_floor() and Input.is_action_just_pressed('ui_select'):
        velocity.y = jump_speed

func _physics_process(delta):
    velocity.y += gravity * delta
    get_input()
    move_and_slide()
```

## Material de Físicas (PhysicsMaterial)

StaticBody y RigidBody pueden usar `PhysicsMaterial` para ajustar:
- **Friction** (fricción)
- **Bounce** (rebote/elasticidad)
- Absorbent/Rough

## Figuras de Colisión (CollisionShape)

Cada cuerpo físico puede contener objetos `Shape2D` como hijos:
- `CollisionShape2D` / `CollisionShape3D`
- `CollisionPolygon2D` / `CollisionPolygon3D`

> **Importante:** NUNCA escalar las formas de colisión en el editor. La propiedad "scale" debe mantenerse en (1,1). Usar los controles de tamaño, no los de Node2D para escala.

## Physics Process Callback

El motor de física corre a una tasa fija (60 iteraciones/segundo por defecto). Godot diferencia entre:

- **Idle processing** (`_process(delta)`): Cada frame, tasa variable
- **Physics processing** (`_physics_process(delta)`): Cada tick de física, tasa fija

> **Recomendación:** Usar siempre el parámetro `delta` en cálculos de física para comportamiento correcto si cambia la tasa de actualización.

## Capas y Máscaras de Colisión

Cada `CollisionObject2D` tiene 32 capas de física:

- **collision_layer**: Capas en las que el objeto **aparece** (default: capa 1)
- **collision_mask**: Capas en las que el objeto **busca** colisiones (default: capa 1)

### Ejemplo de Configuración

4 tipos de nodos: Walls, Player, Enemy, Coin

| Nodo | Layer | Mask (busca) |
|------|-------|--------------|
| Walls | 1 (walls) | - |
| Player | 2 (player) | 1, 3, 4 |
| Enemy | 3 (enemies) | 1, 2 |
| Coin | 4 (coins) | 2 |

Player colisiona con Walls, Enemy y Coin. Enemy colisiona con Walls y Player. Coin solo es detectado por Player.

### Capas por Código

```gdscript
# Binario: capas 1, 3 y 4
0b00000000_00000000_00000000_00001101  # = 0b1101
# Hexadecimal
0x000d  # = 0xd
# Decimal: 2^(1-1) + 2^(3-1) + 2^(4-1) = 1 + 4 + 8 = 13
# Usando <<
(1 << 1 - 1) | (1 << 3 - 1) | (1 << 4 - 1)

# Por valor individual
collider.set_collision_mask_value(1, true)
collider.set_collision_mask_value(3, true)
collider.set_collision_mask_value(4, true)
```

### Nombres de Capas
Se pueden asignar nombres en **Project Settings > Layer Names > 2D Physics / 3D Physics**.

### Export Annotation
```gdscript
@export_flags_2d_physics var layers_2d_physics
```

## Resumen: Cuándo Usar Cada Tipo

| Tipo | Cuándo usarlo |
|------|---------------|
| **Area** | Detección de entrada/salida, modificación de propiedades físicas en zona |
| **StaticBody** | Paredes, pisos, plataformas, objetos del entorno que no se mueven |
| **RigidBody** | Objetos con física realista: cajas, pelotas, física tipo Angry Birds |
| **CharacterBody** | Personajes controlados por el jugador, movimiento personalizado |

---

# PARTE 2: Manejo de Input

Fuentes:
- https://docs.godotengine.org/es/stable/tutorials/inputs/inputevent.html
- https://docs.godotengine.org/es/stable/tutorials/inputs/input_examples.html

## Usar InputEvent

### ¿Qué es InputEvent?

Tipo built-in para manejar entradas de forma consistente entre plataformas. Los eventos viajan a través del motor y pueden recibirse en múltiples lugares.

### Ejemplo Básico

```gdscript
func _unhandled_input(event):
    if event is InputEventKey:
        if event.pressed and event.keycode == KEY_ESCAPE:
            get_tree().quit()
```

### Mejor: Usar InputMap

Define acciones de entrada en **Proyecto > Ajustes del Proyecto > Mapa de Entradas**:

```gdscript
func _process(delta):
    if Input.is_action_pressed("ui_right"):
        # Mover derecha
```

## Cómo Funciona el Flujo de Eventos

1. Si el Viewport tiene ventanas embebidas, interpreta el evento como window-manager
2. Si una ventana embebida está enfocada, el evento va a esa ventana
3. `_input()` - Se llama en cada nodo que lo sobrescribe (orden depth-first inverso)
4. GUI processing - `_gui_input()` en controles
5. `_shortcut_input()` - Para atajos de teclado/joypad
6. `_unhandled_key_input()` - Solo eventos de tecla no manejados
7. `_unhandled_input()` - Gameplay input no manejado por GUI
8. Object Picking - Raycasting en objetos de física (si está habilitado)

![Flujo de eventos](https://docs.godotengine.org/es/4.x/_images/input_event_flow.webp)

## Tipos de InputEvent

| Evento | Descripción |
|--------|-------------|
| `InputEvent` | Evento vacío base |
| `InputEventKey` | Tecla presionada (keycode, unicode, modifiers) |
| `InputEventMouseButton` | Click de ratón (botón, posición, doble click) |
| `InputEventMouseMotion` | Movimiento del ratón (posición relativa/absoluta, velocidad) |
| `InputEventJoypadMotion` | Ejes analógicos de joystick |
| `InputEventJoypadButton` | Botones de joystick |
| `InputEventScreenTouch` | Toque en pantalla (móvil) |
| `InputEventScreenDrag` | Arrastre en pantalla (móvil) |
| `InputEventMagnifyGesture` | Gesto de magnificación (posición, factor) |
| `InputEventPanGesture` | Gesto de paneo (posición, delta) |
| `InputEventMIDI` | Información MIDI |
| `InputEventShortcut` | Atajo de teclado |
| `InputEventAction` | Acción genérica (generada por código) |

## Acciones de Entrada (Input Actions)

Agrupan cero o más InputEvents bajo un nombre común. Ventajas:
- Mismo código para diferentes dispositivos (teclado PC, gamepad consola)
- Reconfiguración en tiempo de ejecución
- Acciones programáticas

### Enviar Acciones desde Código

```gdscript
var ev = InputEventAction.new()
ev.action = "ui_left"
ev.pressed = true
Input.parse_input_event(ev)
```

## Eventos vs Polling

```gdscript
# Eventos: responde a un input específico
func _input(event):
    if event.is_action_pressed("jump"):
        jump()

# Polling: mientras se mantiene presionado
func _physics_process(delta):
    if Input.is_action_pressed("move_right"):
        position.x += speed * delta
```

## Eventos de Teclado

```gdscript
func _input(event):
    if event is InputEventKey and event.pressed:
        if event.keycode == KEY_T:
            if event.shift_pressed:
                print("Shift+T presionado")
            else:
                print("T presionado")
```

> **Advertencia:** El efecto ghosting del teclado puede causar que no se registren todas las teclas simultáneamente.

## Eventos del Ratón

### Botones

```gdscript
func _input(event):
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
            print("Click izquierdo en ", event.position)
        if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
            print("Rueda arriba")
```

### Movimiento (Drag & Drop)

```gdscript
var dragging = false
var click_radius = 32

func _input(event):
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
        if (event.position - $Sprite2D.position).length() < click_radius:
            if not dragging and event.pressed:
                dragging = true
        if dragging and not event.pressed:
            dragging = false
    
    if event is InputEventMouseMotion and dragging:
        $Sprite2D.position = event.position
```

## Eventos de Toque (Móvil)

- `InputEventScreenTouch` = equivalente a click de ratón
- `InputEventScreenDrag` = equivalente a movimiento de ratón

> **Tip:** Para probar en PC, habilita "Emular el toque del ratón" en Configuración del Proyecto > Dispositivos de entrada/punto.

## InputMap desde Código

```gdscript
# Añadir acción
InputMap.add_action("custom_action")

# Asignar tecla
var event = InputEventKey.new()
event.keycode = KEY_SPACE
InputMap.action_add_event("custom_action", event)

# Verificar asignaciones
InputMap.action_get_events("custom_action")

# Verificar si existe
InputMap.has_action("custom_action")
```

## Singleton Input (Métodos Útiles)

| Método | Descripción |
|--------|-------------|
| `is_action_pressed(action)` | ¿Está presionada? |
| `is_action_just_pressed(action)` | ¿Se acaba de presionar? |
| `is_action_just_released(action)` | ¿Se acaba de soltar? |
| `get_action_strength(action)` | Fuerza (0.0-1.0, para analógicos) |
| `get_vector(negative_x, positive_x, negative_y, positive_y)` | Vector 2D combinado |
| `get_axis(negative_action, positive_action)` | Eje unidimensional |
| `is_key_pressed(keycode)` | ¿Tecla específica presionada? |
| `is_mouse_button_pressed(button)` | ¿Botón de ratón presionado? |
| `get_last_mouse_velocity()` | Velocidad del ratón |
| `use_accumulated_input` | Acumular input entre frames |
