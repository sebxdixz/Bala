# BARRIO SIN LEY ONLINE (BSLO)
## 00 — Índice Central del Proyecto
**Versión:** 2.0 | **Motor:** Godot Engine 4 | **Plataforma:** PC | **Género:** MMO Action-RPG de Mundo Abierto

---

## Visión Ejecutiva

**Barrio Sin Ley Online** es un MMO Action-RPG de mundo abierto ambientado en una metrópolis decadente donde bandas callejeras, mafias, cárteles, yakuza y policías corruptos luchan por el control territorial. Construido en Godot 4 con estética 3D Low Poly estilo MU Online, el juego mezcla mecánicas clásicas de MMORPG (mazmorras, raids, clases, loot, progresión por niveles) con la crudeza del crimen organizado, el humor callejero y la cultura urbana de Latinoamérica, Asia y Europa.

El mapa tiene escala GTA San Andreas (~36 km²). Los jugadores eligen una **Facción** (raza estética con 1 stat bonus) y una **Clase** (habilidades de combate) de forma independiente. No hay jugadores pacíficos: solo zonas pacíficas. El griefing es parte del ecosistema, pero el racismo y el discurso de odio son la única línea roja.

---

## Glosario

| Término | Significado |
|---------|-------------|
| **BSLO** | Barrio Sin Ley Online |
| **Crew** | Guild / clan. Banda de jugadores que controla territorio. |
| **Facción** | Raza del personaje. Define estética, zona inicial, questline y 1 stat bonus. No define habilidades. |
| **Clase** | Profesión de combate. Define habilidades, rol y skill tree. Independiente de la facción. |
| **Wanted** | Nivel de búsqueda policial (1-5 estrellas). Afecta a todos en la zona. |
| **Karma** | Moral del personaje (-1000 Criminal a +1000 Vigilante). |
| **Reputación** | Relación independiente con cada facción (Odiado a Legendario). |
| **Dinero Sucio** | Recurso exclusivo de crews. No existe para individuos. |
| **Res Sickness** | Debuff temporal de stats tras resucitar. |
| **Gold Sink** | Sumidero de oro: mecánica que destruye moneda del juego para controlar inflación. |
| **La Hora del Diablo** | 2:00-4:00 AM server-time. Eventos raros, bosses ocultos, PVP no anunciado. |
| **PB** | Pesos de Barrio. Moneda del juego. |

---

## Mapa de Documentos

| # | Archivo | Contenido | ¿Cuándo leerlo? |
|---|---------|-----------|-----------------|
| **00** | `00_INDICE.md` | Hub central, glosario, reglas de oro | Siempre, punto de entrada |
| **01** | `01_Vision.md` | Concepto, audiencia, pilares de diseño | Para entender el "por qué" |
| **02** | `02_Arte.md` | Godot 4, 3D Low Poly, paleta, UI, sonido | Para dirección visual y auditiva |
| **03** | `03_Mecanicas.md` | Combate, stats, muerte, clima, wanted | Para sistemas core del gameplay |
| **04** | `04_Facciones.md` | Las 6 facciones como razas, stats bonus | Para diseñar identidad y lore |
| **05** | `05_Clases.md` | 20+ clases, roles, skill trees | Para diseñar combate y progresión |
| **06** | `06_Mundo.md` | Mapa GTA SA, sectores, distritos, eventos | Para worldbuilding y level design |
| **07** | `07_Progresion.md` | Niveles 1-60, creación, tutorial, mentoría | Para curva de juego y onboarding |
| **08** | `08_Crews.md` | Bandas, territorio, dinero sucio, jerarquía | Para sistemas sociales y endgame |
| **09** | `09_PVP.md` | Duelos, bounties, griefing, servidores | Para conflicto entre jugadores |
| **10** | `10_Inventario.md` | Grid Tetris, ítems, rarezas, equipamiento | Para economía de recursos |
| **11** | `11_Economia.md` | Monedas, mercados, crafting, monetización | Para sistemas económicos |
| **12** | `12_Narrativa.md` | Lore, quests, humor, easter eggs | Para escritura y tono |

---

## Reglas de Oro del Diseño

> **#1 — «Si funciona en World of Warcraft, funciona aquí.»**
> BSLO es un MMORPG tradicional con piel criminal. No es un simulador realista.

> **#2 — «Facción es quién eres. Clase es qué sabes hacer.»**
> La facción define tu estética, tu barrio y un stat bonus. La clase define tus habilidades. Son decisiones independientes.

> **#3 — «No hay jugadores pacíficos. Solo zonas pacíficas.»**
> El mundo es hostil por naturaleza. La seguridad se conquista, no se asume.

> **#4 — «El odio es mecánica. El racismo es baneo.»**
> Griefing, asesinato, robo y traición son gameplay válido. Racismo, xenofobia y discurso de odio son la única línea roja.

> **#5 — «Que se vea como algo que encontraste en un cyber de 2004, pero en 3D.»**
> La estética es Low Poly con alma callejera. No es realista, no es cartoon. Es MU Online meets GTA SA meets graffiti.

> **#6 — «Si no te hace sonreír, reescríbelo.»**
> El humor es un feature central, no un adorno. Tooltips, pantallas de carga, diálogos, mensajes de muerte: todo debe tener tono.

---

## Changelog

| Versión | Fecha | Cambios |
|---------|-------|---------|
| 1.0 | Original | 6 documentos base. Pixel art, 4 monedas, facción=clase, PVE/PVP/RP/Hardcore |
| 2.0 | Actual | 13 documentos. Godot 4, 3D Low Poly, 2 monedas, facción≠clase, solo PVP y Hardcore, mapa GTA SA, muerte -15% XP + degradación + res sickness |

---

*«Bienvenido al Barrio. Lee el índice, elige tu veneno, y no dejes que te roben los tacos.»*
