# Introducción al Skinning de la GUI - Godot 4.x

> Documentación oficial de Godot Engine 4.6 en español
> Fuente: https://docs.godotengine.org/es/stable/tutorials/ui/gui_skinning.html

## Visión General

Es esencial que un juego brinde una interfaz de usuario clara, informativa y visualmente agradable. Godot incluye un sistema de "skinning" (tematización) de la GUI que permite personalizar el aspecto de cada control en la UI, incluidos controles personalizados.

---

## Conceptos Básicos de Temas (Skins)

El sistema de temas es gestionado por el recurso **[Theme](https://docs.godotengine.org/es/4.x/classes/class_theme.html)**. Cada proyecto de Godot tiene un tema predeterminado que contiene las configuraciones utilizadas por los nodos de control incorporados.

> **Nota:** Incluso el editor de Godot depende del tema predeterminado, pero aplica su propio tema altamente personalizado sobre él.

### Artículos de Tema (Theme Items)

Cada elemento de tema tiene un nombre único y debe ser uno de estos tipos:

| Tipo | Descripción |
|------|-------------|
| **Color** | Valor `Color`, usado para fuentes, fondos, modulación de controles e iconos |
| **Constante** | Valor entero, para propiedades numéricas (separación, flags booleanos) |
| **Font** | Recurso `Font`, usado por controles que muestran texto |
| **Font Size** | Valor entero, tamaño de la fuente en píxeles |
| **Icon** | Recurso `Texture2D`, normalmente para iconos en botones |
| **StyleBox** | Recurso `StyleBox`, colección de opciones para paneles, fondos y overlays |

Los StyleBoxes se usan de forma diferente según el control. Notablemente, los styleboxes `focus` se dibujan como **overlay** sobre otros styleboxes (como `normal` o `pressed`), por lo que deben diseñarse como contornos o cajas translúcidas.

### Tipos de Tema (Theme Types)

Cada tema se divide en **tipos**, y cada elemento pertenece a un solo tipo. La combinación (nombre + tipo de dato + tipo de tema) debe ser única.

El tema predeterminado de Godot tiene tipos definidos para cada nodo de control incorporado. Las clases secundarias pueden usar los elementos definidos para su clase padre.

**Jerarquía de búsqueda de items de tema:**
1. Verifica anulaciones locales del mismo tipo y nombre
2. Usando la variación de tipo del control, nombre de clase y nombres de clases padre:
   - Verifica cada control padre por un tema personalizado
   - Si existe, busca el item correspondiente
   - Si no, avanza al siguiente control padre
3. Verifica el tema global del proyecto
4. Verifica el tema predeterminado

---

## Personalizar un Control

Cada nodo de control se puede personalizar directamente mediante **anulaciones locales** (local overrides). Cada propiedad del tema se puede anular en el propio control usando el Inspector o scripts.

Esto permite cambios específicos sin afectar al resto del proyecto, incluyendo los hijos del control.

### Métodos para Anulaciones Locales

```gdscript
# Añadir override de color
add_theme_color_override("font_color", Color.RED)

# Añadir override de constante
add_theme_constant_override("separation", 10)

# Añadir override de fuente
add_theme_font_override("font", my_font)

# Añadir override de tamaño de fuente
add_theme_font_size_override("font_size", 24)

# Añadir override de icono
add_theme_icon_override("icon", my_texture)

# Añadir override de stylebox
add_theme_stylebox_override("normal", my_stylebox)
```

Cuando un control tiene una anulación local, ese valor es el que se utiliza; los valores del tema son ignorados.

---

## Personalización de un Proyecto

### Configuración Global del Proyecto

Dos configuraciones de proyecto afectan a todo el proyecto:
- **GUI > Theme > Custom**: Tema personalizado para todo el proyecto
- **GUI > Theme > Custom Font**: Fuente de respaldo predeterminada

### Tema por Rama de Nodos

Cada nodo de control tiene una propiedad `theme` que permite establecer un tema personalizado para esa rama de nodos.

```gdscript
# Aplicar tema a una rama específica
$PopupDialog.theme = preload("res://popup_theme.tres")
```

**Orden de prioridad para un control arbitrario:**
1. Tema del control más cercano en la jerarquía
2. Tema del proyecto (si existe)
3. Tema predeterminado de Godot

---

## Más Allá de los Controles

Los temas pueden usarse para cualquier propósito visual, no solo controles UI. Ejemplo: modulación de sprites para unidades de diferentes equipos en un juego de estrategia.

```gdscript
# Acceder a items de tema con tipo personalizado
var accent_color = get_theme_color("accent_color", "MyType")
label.add_theme_color_override("font_color", accent_color)
```

### Variaciones de Tipo de Tema

Permiten almacenar múltiples configuraciones preestablecidas para la misma clase de control:

```gdscript
# Marcar un tipo como variación de otro
theme.set_type_variation("Header", "Label")

# Un control Label puede usar la variación "Header"
$Label.theme_type_variation = "Header"
```

> **Advertencia:** Solo las variaciones definidas en el tema predeterminado o en el tema personalizado del proyecto se muestran en el Inspector.

---

## Flujo de Búsqueda de Items de Tema

```
Para cada item solicitado (ej: "font_color" en tipo "Button"):

1. ¿Existe anulación local en este control?
   └─ Sí → Usar valor de anulación

2. ¿Existe variación de tipo en este control?
   └─ Buscar en el tema del control → tema del padre → ... → tema del proyecto → tema default

3. Buscar por nombre de clase (Button)
   └─ Misma cascada de temas

4. Buscar por clases padre (BaseButton → Control)
   └─ Misma cascada de temas

5. Si nada existe → Devolver valor predeterminado del tipo de dato
```

---

## Ejemplos Prácticos

### Crear un Tema Personalizado

```gdscript
var theme = Theme.new()

# Colores para botones
theme.set_color("font_color", "Button", Color.WHITE)
theme.set_color("font_hover_color", "Button", Color.YELLOW)

# StyleBox para estado normal
var normal_style = StyleBoxFlat.new()
normal_style.bg_color = Color(0.2, 0.2, 0.8)
normal_style.border_width_left = 2
normal_style.border_width_right = 2
normal_style.border_width_top = 2
normal_style.border_width_bottom = 2
normal_style.corner_radius_top_left = 8
normal_style.corner_radius_top_right = 8
normal_style.corner_radius_bottom_left = 8
normal_style.corner_radius_bottom_right = 8
theme.set_stylebox("normal", "Button", normal_style)

# StyleBox para hover
var hover_style = StyleBoxFlat.new()
hover_style.bg_color = Color(0.3, 0.3, 0.9)
hover_style.set_corner_radius_all(8)
theme.set_stylebox("hover", "Button", hover_style)

# Aplicar tema
$Button.theme = theme
```

### Usar el Editor de Temas

El editor de temas integrado de Godot permite:
- Crear y editar temas visualmente
- Gestionar tipos de tema y sus items
- Previsualizar cambios en tiempo real
- Importar/exportar temas como archivos `.tres` o `.res`
