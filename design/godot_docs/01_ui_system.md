# Interfaz de Usuario (UI) - Godot 4.x

> Documentación oficial de Godot Engine 4.6 en español
> Fuente: https://docs.godotengine.org/es/stable/tutorials/ui/index.html

## UI Building Blocks

En Godot, la interfaz de usuario se construye usando nodos, específicamente nodos **Control**. Hay muchos tipos diferentes de controles para crear tipos específicos de GUIs. Se dividen en dos grupos: contenido y layout.

### Controles de Contenido Típicos

- **Buttons** ([Button](https://docs.godotengine.org/es/4.x/classes/class_button.html))
- **Labels** ([Label](https://docs.godotengine.org/es/4.x/classes/class_label.html))
- **LineEdits** ([LineEdit](https://docs.godotengine.org/es/4.x/classes/class_lineedit.html)) y **TextEdits** ([TextEdit](https://docs.godotengine.org/es/4.x/classes/class_textedit.html))

### Controles de Layout Típicos

- **BoxContainers** ([BoxContainer](https://docs.godotengine.org/es/4.x/classes/class_boxcontainer.html))
- **MarginContainers** ([MarginContainer](https://docs.godotengine.org/es/4.x/classes/class_margincontainer.html))
- **ScrollContainers** ([ScrollContainer](https://docs.godotengine.org/es/4.x/classes/class_scrollcontainer.html))
- **TabContainers** ([TabContainer](https://docs.godotengine.org/es/4.x/classes/class_tabcontainer.html))
- **Popups** ([Popup](https://docs.godotengine.org/es/4.x/classes/class_popup.html))

### Tutoriales de Controles Básicos

- [Tamaño y anclas](https://docs.godotengine.org/es/4.x/tutorials/ui/size_and_anchors.html)
- [Usar Containers](https://docs.godotengine.org/es/4.x/tutorials/ui/gui_containers.html)
- [Controles GUI personalizados](https://docs.godotengine.org/es/4.x/tutorials/ui/custom_gui_controls.html)
- [Navegación por teclado/controlador y enfoque](https://docs.godotengine.org/es/4.x/tutorials/ui/gui_navigation.html)
- [Galería de nodos de control](https://docs.godotengine.org/es/4.x/tutorials/ui/control_node_gallery.html)

## GUI Skinning y Temas

Godot incluye un sistema completo de skinning (personalización visual) y temas para nodos de control.

- [Introducción al skinning de la interfaz gráfica de usuario (GUI)](https://docs.godotengine.org/es/4.x/tutorials/ui/gui_skinning.html)
- [Usar el editor de temas](https://docs.godotengine.org/es/4.x/tutorials/ui/gui_using_theme_editor.html)
- [Variaciones de tipos de tema](https://docs.godotengine.org/es/4.x/tutorials/ui/gui_theme_type_variations.html)
- [Using Fonts](https://docs.godotengine.org/es/4.x/tutorials/ui/gui_using_fonts.html)

## Tutorial de Nodos de Control

- [BBCode en RichTextLabel](https://docs.godotengine.org/es/4.x/tutorials/ui/bbcode_in_richtextlabel.html)

## Creación de Aplicaciones

Godot también puede usarse para crear aplicaciones (no solo juegos).

- [Creating applications](https://docs.godotengine.org/es/4.x/tutorials/ui/creating_applications.html)

---

## Conceptos Clave del Sistema de UI

### Jerarquía de Herencia

```
Object → Node → CanvasItem → Control → (todos los nodos de UI)
```

- **Control**: Clase base para todos los controles GUI. Adapta su posición y tamaño según su control padre.
- **CanvasItem**: Proporciona propiedades como `z_index`, `visible`, `modulate`.
- **Node**: Proporciona callbacks como `_input()`, `_unhandled_input()`, `_gui_input()`.

### Propagación de Eventos de Input

Godot propaga eventos de entrada a través de viewports. Cada `Viewport` es responsable de propagar `InputEvent`s a sus nodos hijos.

1. `_input()` - Se llama en cada nodo que lo sobrescribe (en orden inverso del árbol)
2. GUI processing - `_gui_input()` en los controles
3. `_shortcut_input()` - Para atajos de teclado
4. `_unhandled_key_input()` - Para eventos de tecla no manejados
5. `_unhandled_input()` - Para gameplay input no manejado por la GUI
6. Object Picking - Raycasting en objetos de física

### Anclas y Offsets

Los controles usan:
- **anchors** (0.0 a 1.0): posición relativa al padre
- **offsets** (píxeles): desplazamiento desde las anclas
- **size_flags**: controlan cómo se expanden/encogen en containers
- **grow_direction**: dirección de crecimiento

### Tema y Skinning

- **Theme**: Recurso que almacena configuraciones visuales
- **Tipos de items**: Color, Constante, Font, Font Size, Icon, StyleBox
- **Cascada**: Los temas se heredan de padres a hijos
- **Anulaciones locales**: Se pueden sobrescribir items específicos por control
- **Tipos de tema**: Organizan items por tipo de control (Button, Label, etc.)
- **Variaciones de tipo**: Permiten múltiples presets para el mismo tipo de control
