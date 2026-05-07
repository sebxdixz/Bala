# API de Nodos de Control - Godot 4.x

> Documentación oficial de Godot Engine 4.6 en español

---

## CanvasLayer

**Hereda:** Node < Object
**Heredado por:** ParallaxBackground

Nodo para renderizado independiente de objetos en una escena 2D. Los nodos derivados de `CanvasItem` que son hijos de un CanvasLayer se dibujarán en esa capa.

### Propiedades

| Propiedad | Tipo | Default | Descripción |
|-----------|------|---------|-------------|
| `custom_viewport` | Node | null | Viewport personalizado asignado al CanvasLayer |
| `follow_viewport_enabled` | bool | false | Si mantiene posición en espacio mundial |
| `follow_viewport_scale` | float | 1.0 | Escala de capa al seguir viewport |
| `layer` | int | 1 | Índice de capa para orden de dibujo |
| `offset` | Vector2 | (0,0) | Desplazamiento de la capa base |
| `rotation` | float | 0.0 | Rotación de la capa en radianes |
| `scale` | Vector2 | (1,1) | Escala de la capa |
| `transform` | Transform2D | identidad | Transformación de la capa |
| `visible` | bool | true | Visibilidad de la capa |

### Señales

- `visibility_changed()` - Emitida al modificar la visibilidad

### Métodos Clave

- `get_canvas()` → RID - Devuelve el RID del canvas
- `get_final_transform()` → Transform2D - Transformación al sistema de coordenadas del Viewport
- `hide()` / `show()` - Oculta/Muestra los CanvasItems hijos

> **Nota:** Las capas con índice -1 se dibujan detrás, capa 0 es la escena 2D por defecto, y capas 1+ se dibujan encima. Ventanas embebidas usan capa 1024.

---

## Control

**Hereda:** CanvasItem < Node < Object
**Heredado por:** BaseButton, ColorRect, Container, GraphEdit, ItemList, Label, LineEdit, MenuBar, NinePatchRect, Panel, Range, ReferenceRect, RichTextLabel, Separator, TabBar, TextEdit, TextureRect, Tree, VideoStreamPlayer

Clase base para todos los controles GUI. Adapta su posición y tamaño según su control padre.

### Propiedades Principales

| Propiedad | Tipo | Default | Descripción |
|-----------|------|---------|-------------|
| `anchor_left/top/right/bottom` | float | 0.0 | Anclas (0.0-1.0) relativas al padre |
| `offset_left/top/right/bottom` | float | 0.0 | Offsets en píxeles desde las anclas |
| `custom_minimum_size` | Vector2 | (0,0) | Tamaño mínimo personalizado |
| `size` | Vector2 | (0,0) | Tamaño del control |
| `position` | Vector2 | (0,0) | Posición relativa al padre |
| `scale` | Vector2 | (1,1) | Escala |
| `rotation` | float | 0.0 | Rotación en radianes |
| `pivot_offset` | Vector2 | (0,0) | Desplazamiento del pivote |
| `mouse_filter` | MouseFilter | 0 | Filtro de eventos de ratón |
| `mouse_default_cursor_shape` | CursorShape | 0 | Forma del cursor por defecto |
| `focus_mode` | FocusMode | 0 | Modo de enfoque |
| `theme` | Theme | null | Tema personalizado para esta rama |
| `theme_type_variation` | StringName | "" | Variación de tipo de tema |
| `clip_contents` | bool | false | Recortar contenido fuera de los límites |
| `auto_translate` | bool | true | Traducción automática de texto |
| `tooltip_text` | String | "" | Texto del tooltip |
| `shortcut_context` | Node | null | Contexto para atajos |

### Enums

**FocusMode:** FOCUS_NONE=0, FOCUS_CLICK=1, FOCUS_ALL=2

**MouseFilter:** MOUSE_FILTER_STOP=0, MOUSE_FILTER_PASS=1, MOUSE_FILTER_IGNORE=2

**GrowDirection:** GROW_DIRECTION_BEGIN=0, GROW_DIRECTION_END=1, GROW_DIRECTION_BOTH=2

**SizeFlags:** SIZE_SHRINK_BEGIN=0, SIZE_FILL=1, SIZE_EXPAND=2, SIZE_SHRINK_CENTER=4, SIZE_SHRINK_END=8

**CursorShape:** CURSOR_ARROW=0, CURSOR_IBEAM=1, CURSOR_POINTING_HAND=2, CURSOR_CROSS=3, CURSOR_WAIT=4, CURSOR_BUSY=5, CURSOR_DRAG=6, CURSOR_CAN_DROP=7, CURSOR_FORBIDDEN=8, CURSOR_VSIZE=9, CURSOR_HSIZE=10, CURSOR_BDIAGSIZE=11, CURSOR_FDIAGSIZE=12, CURSOR_MOVE=13, CURSOR_VSPLIT=14, CURSOR_HSPLIT=15, CURSOR_HELP=16

**LayoutDirection:** LAYOUT_DIRECTION_INHERITED=0, LAYOUT_DIRECTION_LOCALE=1, LAYOUT_DIRECTION_LTR=2, LAYOUT_DIRECTION_RTL=3

### Métodos Clave

**Tema:**
- `add_theme_color_override(name, color)` / `add_theme_constant_override(name, constant)` / `add_theme_font_override(name, font)` / `add_theme_font_size_override(name, font_size)` / `add_theme_icon_override(name, texture)` / `add_theme_stylebox_override(name, stylebox)`
- `get_theme_color(name, theme_type)` / `get_theme_constant(name, theme_type)` / `get_theme_font(name, theme_type)` / `get_theme_font_size(name, theme_type)` / `get_theme_icon(name, theme_type)` / `get_theme_stylebox(name, theme_type)`
- `begin_bulk_theme_override()` / `end_bulk_theme_override()` - Operaciones en lote

**Input:**
- `accept_event()` - Marca evento como manejado
- `_gui_input(event)` - Virtual, para manejar input de GUI
- `_has_point(point)` - Virtual, verifica si un punto está dentro

**Focus:**
- `grab_focus()` - Toma el foco
- `release_focus()` - Libera el foco
- `has_focus()` - ¿Tiene el foco?

**Layout:**
- `get_rect()` → Rect2
- `get_global_rect()` → Rect2
- `get_minimum_size()` → Vector2
- `get_combined_minimum_size()` → Vector2

**Drag & Drop:**
- `_get_drag_data(position)` - Virtual
- `_can_drop_data(position, data)` - Virtual
- `_drop_data(position, data)` - Virtual
- `force_drag(data, preview)`

### Callbacks Virtuales
- `_gui_input(event)` - Input de GUI
- `_get_minimum_size()` - Tamaño mínimo
- `_has_point(point)` - Hit testing
- `_get_tooltip(at_position)` - Tooltip personalizado
- `_make_custom_tooltip(for_text)` - Nodo tooltip personalizado
- `_get_drag_data(position)` - Iniciar drag
- `_can_drop_data(position, data)` - ¿Puede recibir drop?
- `_drop_data(position, data)` - Recibir drop

---

## TextureRect

**Hereda:** Control < CanvasItem < Node < Object

Control que muestra una textura (icono) dentro de una GUI.

### Propiedades

| Propiedad | Tipo | Default | Descripción |
|-----------|------|---------|-------------|
| `texture` | Texture2D | null | Textura a mostrar |
| `stretch_mode` | StretchMode | 0 | Modo de estiramiento |
| `expand_mode` | ExpandMode | 0 | Modo de expansión del tamaño mínimo |
| `flip_h` | bool | false | Voltear horizontalmente |
| `flip_v` | bool | false | Voltear verticalmente |
| `mouse_filter` | MouseFilter | 1 (PASS) | Override de Control |

### Enum StretchMode

| Valor | Constante | Descripción |
|-------|-----------|-------------|
| 0 | STRETCH_SCALE | Escalar para ajustar al rectángulo |
| 1 | STRETCH_TILE | Tile dentro del rectángulo |
| 2 | STRETCH_KEEP | Tamaño original, esquina superior izquierda |
| 3 | STRETCH_KEEP_CENTERED | Tamaño original, centrado |
| 4 | STRETCH_KEEP_ASPECT | Escalar manteniendo aspecto |
| 5 | STRETCH_KEEP_ASPECT_CENTERED | Escalar manteniendo aspecto, centrado |
| 6 | STRETCH_KEEP_ASPECT_COVERED | Cubrir el rectángulo manteniendo aspecto |

### Enum ExpandMode

| Valor | Constante | Descripción |
|-------|-----------|-------------|
| 0 | EXPAND_KEEP_SIZE | Tamaño mínimo = tamaño de textura |
| 1 | EXPAND_IGNORE_SIZE | Ignorar tamaño de textura |
| 2 | EXPAND_FIT_WIDTH | Ancho mínimo = altura actual |
| 3 | EXPAND_FIT_WIDTH_PROPORTIONAL | Como FIT_WIDTH pero mantiene aspecto |
| 4 | EXPAND_FIT_HEIGHT | Altura mínima = ancho actual |
| 5 | EXPAND_FIT_HEIGHT_PROPORTIONAL | Como FIT_HEIGHT pero mantiene aspecto |

---

## TextureProgressBar

**Hereda:** Range < Control < CanvasItem < Node < Object

Barra de progreso basada en texturas. Útil para pantallas de carga, barras de vida/resistencia.

### Propiedades

| Propiedad | Tipo | Default | Descripción |
|-----------|------|---------|-------------|
| `fill_mode` | int | 0 | Dirección de llenado (FillMode) |
| `texture_under` | Texture2D | null | Textura de fondo |
| `texture_over` | Texture2D | null | Textura superior (overlay) |
| `texture_progress` | Texture2D | null | Textura de progreso |
| `texture_progress_offset` | Vector2 | (0,0) | Offset de la textura de progreso |
| `tint_under` | Color | blanco | Tinte de la textura under |
| `tint_progress` | Color | blanco | Tinte de la textura progress |
| `tint_over` | Color | blanco | Tinte de la textura over |
| `nine_patch_stretch` | bool | false | Estiramiento 9-patch |
| `stretch_margin_*` | int | 0 | Márgenes del 9-patch |
| `radial_initial_angle` | float | 0.0 | Ángulo inicial para relleno radial |
| `radial_fill_degrees` | float | 360.0 | Ángulo máximo de relleno |
| `radial_center_offset` | Vector2 | (0,0) | Centro del relleno radial |

### Enum FillMode

| Valor | Constante | Descripción |
|-------|-----------|-------------|
| 0 | FILL_LEFT_TO_RIGHT | Izquierda a derecha |
| 1 | FILL_RIGHT_TO_LEFT | Derecha a izquierda |
| 2 | FILL_TOP_TO_BOTTOM | Arriba a abajo |
| 3 | FILL_BOTTOM_TO_TOP | Abajo a arriba |
| 4 | FILL_CLOCKWISE | Radial en sentido horario |
| 5 | FILL_COUNTER_CLOCKWISE | Radial en sentido antihorario |
| 6 | FILL_BILINEAR_LEFT_AND_RIGHT | Desde el centro, horizontal |
| 7 | FILL_BILINEAR_TOP_AND_BOTTOM | Desde el centro, vertical |
| 8 | FILL_CLOCKWISE_AND_COUNTER_CLOCKWISE | Radial desde centro, ambas direcciones |

---

## Panel

**Hereda:** Control < CanvasItem < Node < Object

Control GUI que muestra un StyleBox.

### Propiedades del Tema

| Item | Tipo | Descripción |
|------|------|-------------|
| `panel` | StyleBox | StyleBox de este control |

---

## Label

**Hereda:** Control < CanvasItem < Node < Object

Control para mostrar texto sin formato. Para texto enriquecido usar RichTextLabel.

### Propiedades

| Propiedad | Tipo | Default | Descripción |
|-----------|------|---------|-------------|
| `text` | String | "" | Texto a mostrar |
| `horizontal_alignment` | HorizontalAlignment | 0 | Alineación horizontal |
| `vertical_alignment` | VerticalAlignment | 0 | Alineación vertical |
| `autowrap_mode` | AutowrapMode | 0 | Modo de ajuste de línea |
| `clip_text` | bool | false | Recortar texto fuera de límites |
| `text_overrun_behavior` | OverrunBehavior | 0 | Comportamiento de desbordamiento |
| `uppercase` | bool | false | Mostrar en mayúsculas |
| `visible_characters` | int | -1 | Caracteres visibles (-1 = todos) |
| `visible_ratio` | float | 1.0 | Fracción de caracteres visibles |
| `lines_skipped` | int | 0 | Líneas saltadas al inicio |
| `max_lines_visible` | int | -1 | Máximo de líneas visibles |
| `label_settings` | LabelSettings | null | Recurso de configuración compartido |
| `language` | String | "" | Código de idioma para line-breaking |
| `text_direction` | TextDirection | 0 | Dirección de escritura |
| `ellipsis_char` | String | "…" | Carácter de elipsis |

### Props del Tema

| Item | Tipo | Default | Descripción |
|------|------|---------|-------------|
| `font_color` | Color | blanco | Color del texto |
| `font_outline_color` | Color | negro | Color del contorno |
| `font_shadow_color` | Color | transparente | Color de la sombra |
| `line_spacing` | int | 3 | Espaciado vertical entre líneas |
| `outline_size` | int | 0 | Tamaño del contorno |
| `paragraph_spacing` | int | 0 | Espacio entre párrafos |
| `shadow_offset_x/y` | int | 1 | Desplazamiento de sombra |
| `shadow_outline_size` | int | 1 | Tamaño del contorno de sombra |
| `font` | Font | null | Fuente |
| `font_size` | int | null | Tamaño de fuente |
| `normal` | StyleBox | null | Fondo normal |
| `focus` | StyleBox | null | Fondo enfocado |

### Métodos

- `get_line_count()` → int
- `get_line_height(line=-1)` → int
- `get_total_character_count()` → int
- `get_visible_line_count()` → int
- `get_character_bounds(pos)` → Rect2

---

## Button

**Hereda:** BaseButton < Control < CanvasItem < Node < Object
**Heredado por:** CheckBox, CheckButton, ColorPickerButton, MenuButton, OptionButton

Botón temático estándar que puede contener texto e icono.

### Propiedades

| Propiedad | Tipo | Default | Descripción |
|-----------|------|---------|-------------|
| `text` | String | "" | Texto del botón |
| `icon` | Texture2D | null | Icono del botón |
| `alignment` | HorizontalAlignment | 1 (CENTER) | Alineación del texto |
| `icon_alignment` | HorizontalAlignment | 0 (LEFT) | Alineación del icono |
| `vertical_icon_alignment` | VerticalAlignment | 1 (CENTER) | Alineación vertical del icono |
| `flat` | bool | false | Sin decoración |
| `clip_text` | bool | false | Recortar texto |
| `expand_icon` | bool | false | Expandir icono al tamaño del botón |
| `autowrap_mode` | AutowrapMode | 0 | Modo de ajuste de texto |
| `text_direction` | TextDirection | 0 | Dirección del texto |
| `text_overrun_behavior` | OverrunBehavior | 0 | Comportamiento de overflow |
| `language` | String | "" | Código de idioma |

### Props del Tema (StyleBoxes por estado)

| Item | Descripción |
|------|-------------|
| `normal` / `normal_mirrored` | Estado normal |
| `hover` / `hover_mirrored` | Hover del mouse |
| `pressed` / `pressed_mirrored` | Presionado |
| `hover_pressed` / `hover_pressed_mirrored` | Hover + presionado |
| `disabled` / `disabled_mirrored` | Deshabilitado |
| `focus` | Enfocado (se dibuja como overlay) |

### Props del Tema (Colores)

| Item | Default | Descripción |
|------|---------|-------------|
| `font_color` | (0.875, 0.875, 0.875, 1) | Color de texto normal |
| `font_hover_color` | (0.95, 0.95, 0.95, 1) | Color hover |
| `font_pressed_color` | blanco | Color presionado |
| `font_hover_pressed_color` | blanco | Color hover+presionado |
| `font_disabled_color` | (0.875, 0.875, 0.875, 0.5) | Color deshabilitado |
| `font_focus_color` | (0.95, 0.95, 0.95, 1) | Color enfocado |
| `font_outline_color` | negro | Color del contorno |
| `icon_normal_color` | blanco | Modulación del icono |
| `icon_hover_color` / `icon_pressed_color` / etc. | blanco | Varios estados |

### Props del Tema (Constantes)

| Item | Default | Descripción |
|------|---------|-------------|
| `h_separation` | 4 | Espacio horizontal icono-texto |
| `icon_max_width` | 0 | Ancho máximo del icono |
| `outline_size` | 0 | Tamaño del contorno |
| `line_spacing` | 0 | Espaciado de línea |
| `align_to_largest_stylebox` | 0 | Alinear al stylebox más grande |

---

## StyleBoxFlat

**Hereda:** StyleBox < Resource < RefCounted < Object

StyleBox personalizable que no utiliza textura. Permite fondos con bordes redondeados, antialiasing, sombras y skew.

### Propiedades

| Propiedad | Tipo | Default | Descripción |
|-----------|------|---------|-------------|
| `bg_color` | Color | (0.6, 0.6, 0.6, 1) | Color de fondo |
| `border_color` | Color | (0.8, 0.8, 0.8, 1) | Color del borde |
| `border_width_*` | int | 0 | Ancho del borde (top/left/right/bottom) |
| `border_blend` | bool | false | Mezclar borde con fondo |
| `corner_radius_*` | int | 0 | Radio de esquina (top_left/top_right/bottom_left/bottom_right) |
| `corner_detail` | int | 8 | Vértices por esquina (1 = chaflán) |
| `anti_aliasing` | bool | true | Antialiasing en bordes |
| `anti_aliasing_size` | float | 1.0 | Tamaño del antialiasing |
| `draw_center` | bool | true | Dibujar interior |
| `shadow_color` | Color | (0,0,0,0.6) | Color de sombra |
| `shadow_size` | int | 0 | Tamaño de sombra |
| `shadow_offset` | Vector2 | (0,0) | Desplazamiento de sombra |
| `expand_margin_*` | float | 0.0 | Expansión fuera del rect del control |
| `skew` | Vector2 | (0,0) | Deformación (efecto "futurista") |

### Métodos

| Método | Descripción |
|--------|-------------|
| `set_border_width_all(width)` | Ancho de borde para todos los lados |
| `set_corner_radius_all(radius)` | Radio para todas las esquinas |
| `set_expand_margin_all(size)` | Margen de expansión para todos los lados |
| `get_border_width(margin)` | Ancho de borde para lado específico |
| `get_border_width_min()` | Menor ancho de borde |
| `get_corner_radius(corner)` | Radio de esquina específica |

> **Nota sobre radios:** Si los radios de esquina suman más que la altura, el sistema usa un ratio relativo para calcular los radios reales.

---

## Theme

**Hereda:** Resource < RefCounted < Object

Recurso para estilizar/skinning de nodos Control y Window. Almacena configuraciones visuales aplicables en cascada.

### Propiedades

| Propiedad | Tipo | Default | Descripción |
|-----------|------|---------|-------------|
| `default_font` | Font | null | Fuente predeterminada |
| `default_font_size` | int | -1 | Tamaño de fuente predeterminado |
| `default_base_scale` | float | 0.0 | Escala base predeterminada |

### Enum DataType

| Valor | Constante | Descripción |
|-------|-----------|-------------|
| 0 | DATA_TYPE_COLOR | Item Color |
| 1 | DATA_TYPE_CONSTANT | Item Constante |
| 2 | DATA_TYPE_FONT | Item Font |
| 3 | DATA_TYPE_FONT_SIZE | Item Tamaño de Fuente |
| 4 | DATA_TYPE_ICON | Item Icon (Texture2D) |
| 5 | DATA_TYPE_STYLEBOX | Item StyleBox |
| 6 | DATA_TYPE_MAX | Valor máximo |

### Métodos Clave

**Gestión de Tipos:**
- `add_type(theme_type)` / `remove_type(theme_type)` / `rename_type(old, new)`
- `get_type_list()` → PackedStringArray

**Variaciones:**
- `set_type_variation(theme_type, base_type)` / `clear_type_variation(theme_type)`
- `is_type_variation(theme_type, base_type)` → bool
- `get_type_variation_list(base_type)` → PackedStringArray
- `get_type_variation_base(theme_type)` → StringName

**Setters (por tipo de dato):**
- `set_color(name, theme_type, color)` / `get_color(name, theme_type)` → Color
- `set_constant(name, theme_type, constant)` / `get_constant(name, theme_type)` → int
- `set_font(name, theme_type, font)` / `get_font(name, theme_type)` → Font
- `set_font_size(name, theme_type, font_size)` / `get_font_size(name, theme_type)` → int
- `set_icon(name, theme_type, texture)` / `get_icon(name, theme_type)` → Texture2D
- `set_stylebox(name, theme_type, stylebox)` / `get_stylebox(name, theme_type)` → StyleBox

**Genéricos:**
- `set_theme_item(data_type, name, theme_type, value)`
- `get_theme_item(data_type, name, theme_type)` → Variant
- `has_theme_item(data_type, name, theme_type)` → bool
- `clear_theme_item(data_type, name, theme_type)`
- `rename_theme_item(data_type, old_name, name, theme_type)`

**Has/Listas:**
- `has_color/constant/font/font_size/icon/stylebox(name, theme_type)` → bool
- `has_default_font()` / `has_default_font_size()` / `has_default_base_scale()` → bool
- `get_*_list(theme_type)` / `get_*_type_list()` → PackedStringArray

**Utilidades:**
- `clear()` - Elimina todas las propiedades
- `merge_with(other_theme)` - Fusiona con otro tema
- `clear_color/constant/font/...`(name, theme_type) - Elimina item específico

---

## FontFile

**Hereda:** Font < Resource < RefCounted < Object

Contiene datos de origen de fuente y caché de glifos pre-renderizados. Soporta formatos TrueType (.ttf), OpenType (.otf), WOFF/WOFF2, Type 1 y bitmap fonts (BMFont).

### Propiedades

| Propiedad | Tipo | Default | Descripción |
|-----------|------|---------|-------------|
| `data` | PackedByteArray | [] | Datos binarios de la fuente |
| `antialiasing` | FontAntialiasing | 1 | Modo de antialiasing |
| `hinting` | Hinting | 1 | Modo de hinting |
| `subpixel_positioning` | SubpixelPositioning | 1 | Posicionamiento subpixel |
| `multichannel_signed_distance_field` | bool | false | MSDF (campo de distancia) |
| `msdf_pixel_range` | int | 16 | Rango de píxeles MSDF |
| `msdf_size` | int | 48 | Tamaño de fuente MSDF |
| `generate_mipmaps` | bool | false | Generar mipmaps |
| `oversampling` | float | 0.0 | Sobremuestreo |
| `force_autohinter` | bool | false | Forzar autohinter |
| `allow_system_fallback` | bool | true | Permitir fallback del sistema |
| `disable_embedded_bitmaps` | bool | true | Deshabilitar bitmaps embebidos |
| `fixed_size` | int | 0 | Tamaño fijo (0 = escalable) |
| `font_name` | String | "" | Nombre de la fuente |
| `style_name` | String | "" | Nombre del estilo |
| `font_weight` | int | 400 | Peso (100-900) |
| `font_stretch` | int | 100 | Estiramiento |
| `font_style` | BitField[FontStyle] | 0 | Estilo (bold, italic) |
| `opentype_feature_overrides` | Dictionary | {} | Overrides de características OpenType |
| `keep_rounding_remainders` | bool | true | Mantener restos de redondeo |
| `modulate_color_glyphs` | bool | false | Modular glifos de color |

### Métodos Clave

**Carga:**
- `load_dynamic_font(path)` → Error - Cargar fuente vectorial
- `load_bitmap_font(path)` → Error - Cargar fuente bitmap

**Glifos:**
- `get_glyph_index(size, char, variation_selector)` → int
- `get_glyph_advance(cache_index, size, glyph)` → Vector2
- `get_glyph_size(cache_index, size, glyph)` → Vector2
- `get_glyph_offset(cache_index, size, glyph)` → Vector2

**Renderizado:**
- `render_glyph(cache_index, size, index)`
- `render_range(cache_index, size, start, end)`

**Caché:**
- `get_cache_count()` → int
- `clear_cache()` / `remove_cache(cache_index)`
- `clear_glyphs(cache_index, size)` / `remove_glyph(cache_index, size, glyph)`
- `clear_textures(cache_index, size)`

**Kerning:**
- `get_kerning(cache_index, size, glyph_pair)` → Vector2
- `set_kerning(cache_index, size, glyph_pair, kerning)`
- `get_kerning_list(cache_index, size)` → Array[Vector2i]
- `clear_kerning_map(cache_index, size)`

**Métricas:**
- `get_cache_ascent(cache_index, size)` → float
- `get_cache_descent(cache_index, size)` → float
- `get_cache_scale(cache_index, size)` → float
- `get_cache_underline_position(cache_index, size)` → float
- `get_cache_underline_thickness(cache_index, size)` → float

**Variaciones:**
- `get_variation_coordinates(cache_index)` → Dictionary
- `set_face_index(cache_index, face_index)` / `get_face_index(cache_index)` → int

**Idioma/Script:**
- `set_language_support_override(language, supported)` / `get_language_support_override(language)` → bool
- `set_script_support_override(script, supported)` / `get_script_support_override(script)` → bool
