# 🎮 Gangster MMO RPG

Un MMO RPG 3D con estética chunky pixel art y temática de gangsters, donde el estilo y el "flow" son tan importantes como el combate.

## 🎯 Descripción del Proyecto

Gangster MMO RPG es un juego multijugador masivo en línea donde los jugadores encarnan gangsters en un mundo urbano lleno de estilo. Con una estética inspirada en juegos como **Megabonk** y **Friends vs Friends**, el juego combina elementos RPG clásicos con humor irreverente y items únicos que definen tu personalidad criminal.

### 🌟 Características Principales

- **Estética Chunky 3D**: Modelos 3D con texturas pixeladas y estilo cartoon exagerado
- **Sistema de "Flow"**: Tu ropa, armas y accesorios no solo te dan stats, sino que definen tu estilo
- **Items Divertidos**: Desde buzos Adidas que mejoran tus habilidades de robo hasta cadenas doradas que aumentan tu carisma
- **Leveling Progresivo**: Sube de nivel completando misiones, robos y actividades urbanas
- **Multijugador Masivo**: Interactúa con otros gangsters en tiempo real
- **Mundo Urbano Inmersivo**: Explora calles, edificios y territorios disputados

### 🎨 Estilo Visual

El juego adopta un estilo visual único que combina:
- **Modelos 3D chunky** con proporciones exageradas
- **Texturas pixel art** de alta calidad
- **Paleta de colores vibrante** y contrastante
- **Animaciones expresivas** que enfatizan la personalidad
- **Efectos visuales cartoon** para combate y habilidades

## 🛠️ Tecnologías

- **Motor**: Godot 4.3+
- **Lenguaje**: GDScript
- **Networking**: Godot Multiplayer API
- **Arte**: Aseprite / Blender + texturas pixeladas
- **Control de Versiones**: Git

## 📁 Estructura del Proyecto

```
gangster-mmo-rpg/
├── assets/                    # Recursos del juego
│   ├── art/                  # Arte y gráficos
│   │   ├── characters/       # Personajes (player, NPCs, enemigos)
│   │   ├── items/           # Armas, ropa, accesorios
│   │   ├── environment/     # Escenarios urbanos
│   │   └── ui/              # Interfaz de usuario
│   └── audio/               # Música y efectos de sonido
├── scenes/                   # Escenas de Godot
│   ├── player/              # Escenas del jugador
│   ├── items/               # Prefabs de items
│   ├── environment/         # Niveles y mapas
│   └── ui/                  # Menús e interfaces
├── scripts/                  # Código del juego
│   ├── player/              # Lógica del jugador
│   ├── items/               # Sistema de inventario
│   ├── combat/              # Sistema de combate
│   ├── networking/          # Multijugador
│   └── managers/            # Gestores globales
├── resources/                # ScriptableObjects y datos
├── materials/                # Materiales y shaders
├── shaders/                  # Shaders personalizados
└── docs/                    # Documentación
```

## 🚀 Setup Inicial

### Prerrequisitos
- Godot 4.3 o superior
- Git (para control de versiones)

### Instalación
1. Clona este repositorio:
   ```bash
   git clone [url-del-repo]
   cd gangster-mmo-rpg
   ```

2. Abre el proyecto en Godot 4

3. Configura las settings para pixel art:
   - Rendering > Textures > Canvas Textures > Filter = Off
   - Rendering > 2D > Use Pixel Snap = On

## 🎲 Sistema de Items

El corazón del juego está en su sistema de items único y divertido:

### Tipos de Items
- **Ropa**: Buzos, pantalones, zapatos que afectan stats específicos
- **Armas**: Desde pistolas hasta bates de baseball con efectos únicos
- **Accesorios**: Cadenas, relojes, lentes que dan bonificaciones de estilo
- **Flow Items**: Items especiales que desbloquean animaciones y habilidades únicas

### Ejemplos de Items
- 👟 **Zapatillas Jordan Falsas**: +15% Velocidad de escape, -5% Detección
- 🧥 **Buzo Adidas Vintage**: +20% Éxito en robos, +10% Respeto callejero
- ⛓️ **Cadena Dorada Chunky**: +25% Intimidación, +15% Carisma con NPCs
- 🔫 **Desert Eagle Cromada**: +30% Daño, +50% Estilo, -20% Sigilo

## 🗺️ Roadmap

### Fase 1: Prototipo (MVP)
- [x] Setup del proyecto y estructura
- [ ] Movimiento básico del jugador
- [ ] Sistema de inventario simple
- [ ] 3-5 items básicos funcionales
- [ ] Mapa de prueba urbano

### Fase 2: Core Gameplay
- [ ] Sistema de combate
- [ ] NPCs y misiones básicas
- [ ] Sistema de leveling
- [ ] 20+ items únicos
- [ ] Multiplayer local (2-4 jugadores)

### Fase 3: MMO Features
- [ ] Servidor dedicado
- [ ] Sistema de guilds/pandillas
- [ ] Territorios disputados
- [ ] Economía de jugador
- [ ] 50+ items y combinaciones

### Fase 4: Polish & Launch
- [ ] Balanceo final
- [ ] Arte finalizado
- [ ] Sistema de progresión completo
- [ ] Beta testing
- [ ] Lanzamiento

## 🎮 Gameplay Core Loop

1. **Explora** el mundo urbano buscando oportunidades
2. **Equipa** items que definan tu estilo y habilidades
3. **Completa** misiones y actividades para ganar XP y dinero
4. **Roba** o **compra** nuevos items para mejorar tu build
5. **Interactúa** con otros jugadores: compite, colabora o intimida
6. **Domina** territorios y construye tu reputación criminal

## 🤝 Contribución

Este es un proyecto indie experimental. Si quieres contribuir:

1. Fork del proyecto
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -m 'Agrega nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

## 📄 Licencia

[Definir licencia - MIT/Apache/Propietaria]

## 🎨 Arte & Referencias

- **Inspiración visual**: Megabonk, Friends vs Friends, Pizza Tower
- **Estética**: Chunky 3D, pixel art moderno, colores saturados
- **Tono**: Irreverente, divertido, estiloso

---

*"En las calles, el estilo es supervivencia. Tu flow define tu poder."* 🔥
