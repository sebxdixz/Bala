# Partículas y AnimationTree - Godot 4.x

> Documentación oficial de Godot Engine 4.6 en español

---

# PARTE 1: Sistemas de Partículas (3D)

Fuente: https://docs.godotengine.org/es/stable/tutorials/3d/particles/index.html

## Introducción

Los sistemas de partículas simulan efectos físicos complejos como fuego, chispas, humo, efectos mágicos y más. Son ideales para crear comportamiento dinámico y orgánico.

Cada sistema de partículas en Godot consiste en dos partes principales:

### Partículas
La parte visible: pequeñas motas, llamas, orbes brillantes. Se puede tener desde cientos hasta decenas de miles de partículas en un solo sistema. Se puede aleatorizar tamaño, velocidad, dirección y color a lo largo de su vida.

### Emisores
Lo que crea las partículas. Normalmente no visibles, pero pueden tener una forma que controla dónde y cómo se generan las partículas.

## Tipos de Sistemas de Partículas 3D

| Tipo | Descripción |
|------|-------------|
| **GPUParticles3D** | Procesados en GPU. Cientos de miles de partículas. Shaders personalizados. Colisiones y atractores. |
| **CPUParticles3D** | Procesados en CPU. Menos flexibles pero mejor soporte en hardware antiguo/móvil. |

## Nodos Relacionados

### Atractores de Partículas
- `GPUParticlesAttractorBox3D` - Atractor en forma de caja
- `GPUParticlesAttractorSphere3D` - Atractor esférico
- `GPUParticlesAttractorVectorField3D` - Campo vectorial

Aplican fuerza a las partículas en su alcance, atrayéndolas o repeliéndolas.

### Colisiones de Partículas
- `GPUParticlesCollisionBox3D` - Colisión con caja
- `GPUParticlesCollisionSphere3D` - Colisión con esfera
- `GPUParticlesCollisionSDF3D` - Colisión con SDF (interiores)
- `GPUParticlesCollisionHeightField3D` - Mapa de alturas (exteriores grandes)

## Propiedades del Process Material

### Spawn (Emisión)
- Tasa de emisión, forma del emisor (punto, esfera, caja, etc.)
- Dirección, velocidad inicial, ángulo de dispersión
- Aleatoriedad en todos los parámetros

### Accelerations
- Gravedad
- Fuerzas direccionales
- Atractores

### Display (Visualización)
- Color inicial y final (con gradiente)
- Tamaño inicial y final (con curva)
- Rotación y velocidad angular
- Animación de spritesheet

### Particle Flags
- Alineación a la velocidad
- Alineación a la cámara (billboard)
- Rotación Y a velocidad

### Collision
- Modo de colisión (rígida, ocultar al contacto)
- Rebote, fricción

### Sub-Emitters
- Emitir al nacer, al colisionar, al morir

## Temas Avanzados

- [Subemisores](https://docs.godotengine.org/es/stable/tutorials/3d/particles/subemitters.html) - Fuegos artificiales, chispas
- [Rastros de partículas](https://docs.godotengine.org/es/stable/tutorials/3d/particles/trails.html) - RibbonTrailMesh, TubeTrailMesh
- [Turbulencia](https://docs.godotengine.org/es/stable/tutorials/3d/particles/turbulence.html)
- [Atractores 3D](https://docs.godotengine.org/es/stable/tutorials/3d/particles/attractors.html)
- [Colisiones 3D](https://docs.godotengine.org/es/stable/tutorials/3d/particles/collision.html)
- [Formas de emisión complejas](https://docs.godotengine.org/es/stable/tutorials/3d/particles/complex_shapes.html)

---

# PARTE 2: Usar AnimationTree

Fuente: https://docs.godotengine.org/es/stable/tutorials/animation/animation_tree.html

## Introducción

`AnimationPlayer` tiene uno de los sistemas de animación más flexibles. Sin embargo, el soporte para mezclar animaciones es limitado (solo cross-fade fijo). `AnimationTree` maneja transiciones avanzadas.

**Importante:** `AnimationTree` no contiene sus propias animaciones. Usa las animaciones de un `AnimationPlayer`. Creas/editas/importas animaciones en `AnimationPlayer` y usas `AnimationTree` para controlar la reproducción.

## Crear un Árbol

Para usar `AnimationTree`, debes establecer un nodo raíz. Hay 3 tipos de sub-nodos:

1. **Animation nodes** - Referencian una animación del `AnimationPlayer`
2. **Animation Root nodes** - Mezclan sub-nodos, pueden anidarse
3. **Animation Blend nodes** - Usados en `AnimationNodeBlendTree`, toman múltiples entradas

### Tipos de Nodos Raíz

| Nodo | Descripción |
|------|-------------|
| `AnimationNodeAnimation` | Selecciona y reproduce una animación. El más simple. |
| `AnimationNodeBlendTree` | Grafo 2D con múltiples nodos hijos. Mix, Blend2/3, OneShot, etc. |
| `AnimationNodeBlendSpace1D` | Mezcla lineal entre animaciones en 1 dimensión |
| `AnimationNodeBlendSpace2D` | Mezcla lineal entre animaciones en 2 dimensiones |
| `AnimationNodeStateMachine` | Máquina de estados con transiciones |

## Nodos del BlendTree

### Blend2 / Blend3
Mezclan entre 2 o 3 entradas mediante un valor de mezcla. Pueden usar **filtros** para controlar qué tracks se mezclan individualmente.

### OneShot
Ejecuta una animación una vez y retorna al terminar. Tiempos de fade-in/out personalizables.

```gdscript
# Disparar animación OneShot
animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
# Abortar
animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
# Estado actual (solo lectura)
animation_tree.get("parameters/OneShot/active")
```

### TimeSeek
Busca a un tiempo específico en la animación conectada. El valor está en segundos.

```gdscript
# Reproducir desde el inicio
animation_tree.set("parameters/TimeSeek/seek_request", 0.0)
# Reproducir desde 12 segundos
animation_tree.set("parameters/TimeSeek/seek_request", 12.0)
```

### TimeScale
Escala la velocidad de la animación. 0 = pausa, negativo = reproducir hacia atrás.

### Transition
Versión simplificada de StateMachine. Conectas animaciones a las entradas y el índice de estado determina cuál reproducir.

```gdscript
# Cambiar a estado
animation_tree.set("parameters/Transition/transition_request", "state_2")
# Obtener estado actual
animation_tree.get("parameters/Transition/current_state")
animation_tree.get("parameters/Transition/current_index")
```

## StateMachine

Cuando creas un `AnimationNodeStateMachine`, obtienes un grafo 2D con estados `Start` y `End`. Puedes añadir animaciones, blendspaces, blendtrees, u otro StateMachine.

### Tipos de Transiciones

| Tipo | Descripción |
|------|-------------|
| **Immediate** | Cambia al siguiente estado inmediatamente |
| **Sync** | Cambia inmediatamente pero busca la posición de reproducción del estado anterior |
| **At End** | Espera a que termine el estado actual, luego va al inicio del siguiente |

### Propiedades de Transición

- **Xfade Time**: Tiempo de cross-fade entre estados
- **Xfade Curve**: Curva de cross-fade (no lineal)
- **Reset**: ¿Empezar desde el principio al cambiar?
- **Priority**: Usado con `travel()`
- **Switch Mode**: Tipo de transición (Immediate/Sync/At End)
- **Advance Mode**: Disabled/Enabled/Auto
- **Advance Condition**: Variable booleana para transición automática
- **Advance Expression**: Expresión evaluable (más flexible)

### Advance Expression (Ejemplos)

```
is_walking
is_walking == true
is_walking && !is_idle
velocity > 0
player.is_on_floor()
```

> **Advertencia:** Las expresiones son case-sensitive. En GDScript usar snake_case, en C# usar PascalCase.

### Travel (Viaje entre estados)

Usa el algoritmo A* para navegar entre estados a través de transiciones intermedias.

```gdscript
var state_machine = animation_tree["parameters/playback"]
state_machine.travel("SomeState")
```

## BlendSpace2D y BlendSpace1D

### BlendSpace2D
Mezcla avanzada en 2 dimensiones. Puntos representando animaciones en un espacio 2D. La triangulación Delaunay se genera automáticamente.

**Modos de mezcla:**
- **Interpolated**: Interpola dentro del triángulo más cercano
- **Discrete**: Cambio directo entre animaciones (para animaciones frame-by-frame)
- **Carry**: Mantiene posición de reproducción al cambiar

### BlendSpace1D
Como BlendSpace2D pero en 1 dimensión (una línea). No se usan triángulos.

## Root Motion (Movimiento Raíz)

Técnica popular en animaciones 3D donde el hueso raíz del esqueleto da movimiento al resto. Al marcar una pista como "root motion track", se cancela la transformación visualmente (la animación se mantiene en su lugar).

```gdscript
# Obtener el delta de movimiento
animation_tree.get_root_motion_position()
animation_tree.get_root_motion_rotation()
animation_tree.get_root_motion_scale()

# Obtener valor acumulado
animation_tree.get_root_motion_position_accumulator()
animation_tree.get_root_motion_rotation_accumulator()
animation_tree.get_root_motion_scale_accumulator()
```

Esto se puede usar con `CharacterBody3D.move_and_slide()` para controlar el movimiento.

## Control desde Código

Los nodos de animación son recursos compartidos entre instancias. Los datos de animación se acceden a través de las propiedades del `AnimationTree`.

```gdscript
# Encontrar el path de propiedad (hover en el inspector)
animation_tree.set("parameters/eye_blend/blend_amount", 1.0)
# Sintaxis alternativa
animation_tree["parameters/eye_blend/blend_amount"] = 1.0
```

### Mejores Prácticas para Blending

1. Las propiedades mezcladas deben tener valores iniciales definidos
2. Usar la animación `RESET` para definir la pose por defecto
3. Para esqueletos humanoides, importar en **T-pose**
4. Los valores Bone Rest deben estar cerca del punto medio del rango de movimiento

> **Nota:** Las pistas Rotation 3D con Interpolation Type Linear/Cubic Angle previenen rotaciones >180° desde el valor inicial.
