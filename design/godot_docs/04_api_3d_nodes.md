# API de Nodos 3D - Godot 4.x

> Documentación oficial de Godot Engine 4.6 en español

---

## CharacterBody3D

**Hereda:** PhysicsBody3D < CollisionObject3D < Node3D < Node < Object

Cuerpo físico 3D especializado para personajes movidos por script. No es afectado por la física pero afecta a otros cuerpos. Ideal para personajes controlados por el usuario.

### Propiedades

| Propiedad | Tipo | Default | Descripción |
|-----------|------|---------|-------------|
| `velocity` | Vector3 | (0,0,0) | Velocidad actual (m/s). Se modifica durante `move_and_slide()` |
| `up_direction` | Vector3 | (0,1,0) | Vector hacia arriba para distinguir suelo/pared/techo |
| `motion_mode` | MotionMode | 0 | Modo de movimiento (grounded/floating) |
| `floor_max_angle` | float | 0.7853982 (45°) | Ángulo máximo considerado suelo |
| `floor_snap_length` | float | 0.1 | Distancia de ajuste al suelo |
| `floor_stop_on_slope` | bool | true | Detenerse en pendientes al estar quieto |
| `floor_block_on_wall` | bool | true | Solo moverse en el suelo, no escalar paredes |
| `floor_constant_speed` | bool | false | Velocidad constante en pendientes |
| `slide_on_ceiling` | bool | true | Deslizar al saltar contra el techo |
| `wall_min_slide_angle` | float | 0.2617994 (15°) | Ángulo mínimo para deslizar en pared |
| `max_slides` | int | 6 | Máx. cambios de dirección en `move_and_slide()` |
| `safe_margin` | float | 0.001 | Margen para recuperación de colisión |
| `platform_floor_layers` | int | 4294967295 | Capas de suelo para plataformas móviles |
| `platform_wall_layers` | int | 0 | Capas de pared para plataformas móviles |
| `platform_on_leave` | PlatformOnLeave | 0 | Comportamiento al dejar plataforma móvil |

### Enum MotionMode

| Valor | Constante | Descripción |
|-------|-----------|-------------|
| 0 | MOTION_MODE_GROUNDED | Suelo/pared/techo relevantes. Reacciona a pendientes |
| 1 | MOTION_MODE_FLOATING | Sin noción de suelo. Para juegos espaciales |

### Enum PlatformOnLeave

| Valor | Constante | Descripción |
|-------|-----------|-------------|
| 0 | PLATFORM_ON_LEAVE_ADD_VELOCITY | Añadir velocidad de plataforma al salir |
| 1 | PLATFORM_ON_LEAVE_ADD_UPWARD_VELOCITY | Solo añadir velocidad hacia arriba |
| 2 | PLATFORM_ON_LEAVE_DO_NOTHING | No hacer nada |

### Métodos

**Movimiento:**
- `move_and_slide()` → bool - Mueve basado en velocity. Retorna true si colisionó
- `apply_floor_snap()` - Ajuste manual al suelo

**Estado post-colisión:**
- `is_on_floor()` / `is_on_floor_only()` → bool
- `is_on_wall()` / `is_on_wall_only()` → bool
- `is_on_ceiling()` / `is_on_ceiling_only()` → bool
- `get_floor_normal()` → Vector3
- `get_floor_angle(up_direction)` → float
- `get_wall_normal()` → Vector3
- `get_last_motion()` → Vector3
- `get_position_delta()` → Vector3
- `get_real_velocity()` → Vector3

**Colisiones:**
- `get_slide_collision_count()` → int
- `get_slide_collision(slide_idx)` → KinematicCollision3D
- `get_last_slide_collision()` → KinematicCollision3D

**Plataformas:**
- `get_platform_velocity()` → Vector3
- `get_platform_angular_velocity()` → Vector3

### Ejemplo Básico

```gdscript
extends CharacterBody3D

var speed = 5.0
var jump_velocity = 10.0
var gravity = 20.0

func _physics_process(delta):
    velocity.y -= gravity * delta
    
    var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    var direction = transform.basis * Vector3(input_dir.x, 0, input_dir.y).normalized()
    
    if direction:
        velocity.x = direction.x * speed
        velocity.z = direction.z * speed
    else:
        velocity.x = move_toward(velocity.x, 0, speed)
        velocity.z = move_toward(velocity.z, 0, speed)
    
    if is_on_floor() and Input.is_action_just_pressed("ui_accept"):
        velocity.y = jump_velocity
    
    move_and_slide()
```

---

## Camera3D

**Hereda:** Node3D < Node < Object
**Heredado por:** XRCamera3D

Nodo de cámara que muestra lo visible desde su ubicación actual.

### Propiedades

| Propiedad | Tipo | Default | Descripción |
|-----------|------|---------|-------------|
| `current` | bool | false | ¿Es la cámara activa del Viewport? |
| `projection` | ProjectionType | 0 | Modo de proyección |
| `fov` | float | 75.0 | Campo de visión en grados (perspectiva) |
| `size` | float | 1.0 | Tamaño en metros (ortogonal/frustum) |
| `near` | float | 0.05 | Plano de recorte cercano |
| `far` | float | 4000.0 | Plano de recorte lejano |
| `keep_aspect` | KeepAspect | 1 | Eje a bloquear (KEEP_WIDTH/KEEP_HEIGHT) |
| `h_offset` | float | 0.0 | Desplazamiento horizontal |
| `v_offset` | float | 0.0 | Desplazamiento vertical |
| `frustum_offset` | Vector2 | (0,0) | Offset del frustum (modo frustum) |
| `cull_mask` | int | 1048575 | Máscara de culling (20 capas visibles) |
| `environment` | Environment | null | Entorno para esta cámara |
| `attributes` | CameraAttributes | null | Atributos de cámara |
| `compositor` | Compositor | null | Compositor para post-procesado |
| `doppler_tracking` | DopplerTracking | 0 | Simulación de efecto Doppler |

### Enum ProjectionType

| Valor | Constante | Descripción |
|-------|-----------|-------------|
| 0 | PROJECTION_PERSPECTIVE | Perspectiva (objetos lejanos más pequeños) |
| 1 | PROJECTION_ORTHOGONAL | Ortográfica (sin perspectiva) |
| 2 | PROJECTION_FRUSTUM | Frustum inclinado personalizable |

### Enum KeepAspect

| Valor | Constante | Descripción |
|-------|-----------|-------------|
| 0 | KEEP_WIDTH | Preservar aspecto horizontal (Vert-) |
| 1 | KEEP_HEIGHT | Preservar aspecto vertical (Hor+) |

### Métodos

- `make_current()` - Hacer esta cámara la activa
- `clear_current(enable_next=true)` - Dejar de ser la cámara actual
- `get_camera_rid()` → RID
- `get_camera_transform()` → Transform3D
- `get_camera_projection()` → Projection
- `get_frustum()` → Array[Plane] - Planos del frustum
- `get_pyramid_shape_rid()` → RID
- `is_position_behind(world_point)` → bool
- `is_position_in_frustum(world_point)` → bool

**Proyección/Raycasting:**
- `project_ray_origin(screen_point)` → Vector3
- `project_ray_normal(screen_point)` → Vector3
- `project_local_ray_normal(screen_point)` → Vector3
- `project_position(screen_point, z_depth)` → Vector3
- `unproject_position(world_point)` → Vector2

**Configuración por código:**
- `set_perspective(fov, z_near, z_far)`
- `set_orthogonal(size, z_near, z_far)`
- `set_frustum(size, offset, z_near, z_far)`
- `set_cull_mask_value(layer_number, value)` / `get_cull_mask_value(layer_number)` → bool

---

## AnimationPlayer

**Hereda:** AnimationMixer < Node < Object

Nodo para reproducción de animaciones de propósito general. Contiene un diccionario de recursos `AnimationLibrary` y tiempos de mezcla personalizados.

### Propiedades

| Propiedad | Tipo | Default | Descripción |
|-----------|------|---------|-------------|
| `autoplay` | StringName | "" | Animación a reproducir al cargar la escena |
| `current_animation` | StringName | "" | Animación actual (solo lectura efectiva) |
| `assigned_animation` | StringName | "" | Animación asignada (settable) |
| `current_animation_position` | float | - | Posición actual (segundos) |
| `current_animation_length` | float | - | Duración actual (segundos) |
| `speed_scale` | float | 1.0 | Escala de velocidad |
| `playback_default_blend_time` | float | 0.0 | Tiempo de mezcla por defecto |
| `movie_quit_on_finish` | bool | false | Salir al terminar (modo Movie Maker) |
| `playback_auto_capture` | bool | true | Auto-captura antes de reproducir |
| `playback_auto_capture_duration` | float | -1.0 | Duración de captura |
| `playback_auto_capture_ease_type` | EaseType | 0 | Tipo de ease para captura |
| `playback_auto_capture_transition_type` | TransitionType | 0 | Tipo de transición para captura |

### Señales

- `animation_changed(old_name, new_name)` - Animación en cola cambió
- `current_animation_changed(name)` - Animación actual cambió

### Métodos

**Reproducción:**
- `play(name, custom_blend=-1, custom_speed=1.0, from_end=false)`
- `play_backwards(name, custom_blend=-1)`
- `play_section(name, start_time=-1, end_time=-1, ...)`
- `play_section_backwards(name, start_time=-1, end_time=-1, ...)`
- `play_section_with_markers(name, start_marker, end_marker, ...)`
- `play_with_capture(name, duration=-1.0, ...)`

**Control:**
- `stop(keep_state=false)` - Detener reproducción
- `pause()` - Pausar
- `seek(seconds, update=false)` - Buscar posición
- `queue(name)` - Encolar animación
- `clear_queue()` - Limpiar cola

**Estado:**
- `is_playing()` → bool
- `is_animation_active()` → bool
- `get_playing_speed()` → float

**Secciones:**
- `set_section(start_time, end_time)` / `reset_section()`
- `set_section_with_markers(start_marker, end_marker)`
- `has_section()` → bool
- `get_section_start_time()` / `get_section_end_time()` → float

**Mezcla:**
- `set_blend_time(animation_from, animation_to, sec)`
- `get_blend_time(animation_from, animation_to)` → float

**Raíz:**
- `set_root(path)` / `get_root()` → NodePath
- `set_method_call_mode(mode)` / `set_process_callback(mode)`

---

## GPUParticles3D

**Hereda:** GeometryInstance3D < VisualInstance3D < Node3D < Node < Object

Emisor de partículas 3D procesado en GPU. Soporta cientos de miles de partículas, shaders personalizados, colisiones y atractores.

### Propiedades

| Propiedad | Tipo | Default | Descripción |
|-----------|------|---------|-------------|
| `emitting` | bool | true | ¿Está emitiendo partículas? |
| `amount` | int | 8 | Número de partículas por ciclo |
| `amount_ratio` | float | 1.0 | Ratio de partículas emitidas (0-1) |
| `lifetime` | float | 1.0 | Vida de cada partícula (segundos) |
| `one_shot` | bool | false | Emitir solo `amount` partículas una vez |
| `preprocess` | float | 0.0 | Tiempo de pre-procesado |
| `explosiveness` | float | 0.0 | Ratio de tiempo entre emisiones (0=continuo, 1=todas juntas) |
| `randomness` | float | 0.0 | Aleatoriedad de emisión |
| `speed_scale` | float | 1.0 | Escala de velocidad (0=pausa) |
| `fixed_fps` | int | 30 | FPS fijos para renderizado |
| `interpolate` | bool | true | Interpolación de partículas |
| `fract_delta` | bool | true | Delta fraccional (más suave) |
| `local_coords` | bool | false | Usar coordenadas locales |
| `process_material` | Material | null | Material de proceso (ParticleProcessMaterial o ShaderMaterial) |
| `draw_order` | DrawOrder | 0 | Orden de dibujo |
| `draw_passes` | int | 1 | Número de pases de dibujo |
| `draw_pass_1/2/3/4` | Mesh | null | Mallas para cada pase |
| `draw_skin` | Skin | null | Skin para las mallas |
| `seed` | int | 0 | Semilla aleatoria |
| `use_fixed_seed` | bool | false | Usar semilla fija |
| `sub_emitter` | NodePath | "" | Sub-emisor (fuegos artificiales, etc.) |
| `visibility_aabb` | AABB | (-4,-4,-4, 8,8,8) | AABB de visibilidad |
| `collision_base_size` | float | 0.01 | Diámetro base para colisión |
| `trail_enabled` | bool | false | Rastros de partículas |
| `trail_lifetime` | float | 0.3 | Duración del rastro |
| `transform_align` | TransformAlign | 0 | Alineación de transformación |
| `interp_to_end` | float | 0.0 | Interpolar al final de vida |

### Enum DrawOrder

| Valor | Constante | Descripción |
|-------|-----------|-------------|
| 0 | DRAW_ORDER_INDEX | Orden de emisión |
| 1 | DRAW_ORDER_LIFETIME | Mayor vida al frente |
| 2 | DRAW_ORDER_REVERSE_LIFETIME | Menor vida al frente |
| 3 | DRAW_ORDER_VIEW_DEPTH | Por profundidad |

### Enum EmitFlags (para emit_particle)

| Valor | Constante | Descripción |
|-------|-----------|-------------|
| 1 | EMIT_FLAG_POSITION | Usar posición especificada |
| 2 | EMIT_FLAG_ROTATION_SCALE | Usar rotación y escala |
| 4 | EMIT_FLAG_VELOCITY | Usar velocidad especificada |
| 8 | EMIT_FLAG_COLOR | Usar color especificado |
| 16 | EMIT_FLAG_CUSTOM | Usar datos CUSTOM |

### Señales

- `finished()` - Todas las partículas activas terminaron (solo one_shot)

### Métodos

- `restart(keep_seed=false)` - Reiniciar ciclo de emisión
- `emit_particle(xform, velocity, color, custom, flags)` - Emitir partícula individual
- `capture_aabb()` → AABB - AABB de partículas activas
- `convert_from_particles(particles)` - Copiar de CPUParticles3D
- `request_particles_process(process_time)` - Procesar tiempo adicional
- `get_draw_pass_mesh(pass)` / `set_draw_pass_mesh(pass, mesh)`

---

## ShaderMaterial

**Hereda:** Material < Resource < RefCounted < Object

Material definido por un programa Shader personalizado y los valores de sus parámetros uniform.

### Propiedades

| Propiedad | Tipo | Default | Descripción |
|-----------|------|---------|-------------|
| `shader` | Shader | null | Programa Shader para este material |

### Métodos

- `set_shader_parameter(param, value)` - Establecer valor de uniform
- `get_shader_parameter(param)` → Variant - Obtener valor de uniform

> **Nota:** `param` es case-sensitive. Los cambios afectan a todas las instancias que usen este ShaderMaterial. Para cambios por instancia, usar `set_instance_shader_parameter()` en CanvasItem o GeometryInstance3D.

---

## StandardMaterial3D

**Hereda:** BaseMaterial3D < Material < Resource < RefCounted < Object

Material PBR (Physically Based Rendering) para objetos 3D. Hereda todas sus propiedades de `BaseMaterial3D`.

### Características de BaseMaterial3D

- **Albedo**: Color base y textura
- **Metallic**: Nivel de metalizado
- **Roughness**: Rugosidad de la superficie
- **Emission**: Color de emisión y energía
- **Normal Map**: Mapa de normales
- **Ambient Occlusion**: Oclusión ambiental
- **Height/Depth**: Mapa de altura/desplazamiento
- **Subsurface Scattering**: Dispersión subsuperficial
- **Rim**: Efecto de borde iluminado
- **Clearcoat**: Capa de barniz
- **Anisotropy**: Anisotropía
- **Transparency**: Transparencia (Alpha, Blend Mode)
- **Billboard**: Modo cartel
- **Grow**: Expansión de vértices
- **Particle Trails**: Rastros de partículas
- **Proximity Fade**: Desvanecimiento por proximidad
- **Distance Fade**: Desvanecimiento por distancia

### Modos de Blend

- **Mix**: Mezcla estándar
- **Add**: Aditivo (útil para fuego, energía)
- **Sub**: Sustractivo
- **Mul**: Multiplicativo

### Culling

- **Back**: Solo caras traseras (default)
- **Front**: Solo caras frontales
- **Disabled**: Sin culling (doble cara)

### Depth Draw Mode

- **Opaque Only**
- **Always**
- **Depth Prepass**
- **Never**

> **Nota:** Para usar un solo mapa ORM (Oclusión, Rugosidad, Metálico), usar `ORMMaterial3D` en lugar de `StandardMaterial3D`.
