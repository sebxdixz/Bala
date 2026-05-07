# BARRIO SIN LEY ONLINE (BSLO)
## design/balance/leveling_curve.md — Curva de Progresión y Experiencia
**Versión:** 2.0 | **Última Revisión:** Mayo 2026

---

## 1. FÓRMULA DE XP REQUERIDA POR NIVEL

La experiencia requerida para subir del nivel `n` al nivel `n+1` sigue la fórmula:

```
XP_requerida(n) = floor(100 × n^2.2 + 50 × n)
```

Donde:
- `n` = nivel actual (1 a 59)
- `floor()` = redondeo hacia abajo
- `n^2.2` = potencia de exponente 2.2 (curva parabólica suave)

### Justificación de la Curva
- **Niveles 1-20:** Crecimiento suave (n^2.2 ~ n^2). Subir es rápido, ~20-40 minutos por nivel.
- **Niveles 21-40:** Crecimiento medio. n^2.2 escala a ~n^2.5. ~1-2 horas por nivel.
- **Niveles 41-55:** Crecimiento pronunciado. ~3-5 horas por nivel.
- **Niveles 55-60:** Crecimiento muy pronunciado. ~8-15 horas por nivel.

---

## 2. TABLA COMPLETA DE XP REQUERIDA (NIVEL 1 AL 60)

| Nivel | XP Requerida | XP Acumulada | Rango | Tiempo Estimado |
|-------|-------------|--------------|-------|-----------------|
| 1 | 0* | 0 | Chivato | — |
| 2 | 150 | 150 | Chivato | 5 min |
| 3 | 559 | 709 | Chivato | 10 min |
| 4 | 1,271 | 1,980 | Chivato | 15 min |
| 5 | 2,311 | 4,291 | Chivato | 20 min |
| 6 | 3,703 | 7,994 | Chivato | 25 min |
| 7 | 5,479 | 13,473 | Chivato | 30 min |
| 8 | 7,667 | 21,140 | Chivato | 35 min |
| 9 | 10,292 | 31,432 | Chivato | 40 min |
| 10 | 13,378 | 44,810 | Chivato | 45 min |
| 11 | 16,349 | 61,159 | Chivato | 50 min |
| 12 | 20,231 | 81,390 | Chivato | 55 min |
| 13 | 25,044 | 106,434 | Chivato | 1 h 00 min |
| 14 | 30,804 | 137,238 | Chivato | 1 h 10 min |
| 15 | 37,527 | 174,765 | Chivato | 1 h 20 min |
| 16 | 45,226 | 219,991 | Matón | 1 h 30 min |
| 17 | 53,912 | 273,903 | Matón | 1 h 45 min |
| 18 | 63,594 | 337,497 | Matón | 2 h 00 min |
| 19 | 74,279 | 411,776 | Matón | 2 h 15 min |
| 20 | 85,972 | 497,748 | Soldado | 2 h 30 min |
| 21 | 98,678 | 596,426 | Soldado | 3 h 00 min |
| 22 | 112,399 | 708,825 | Soldado | 3 h 30 min |
| 23 | 127,136 | 835,961 | Soldado | 4 h 00 min |
| 24 | 142,888 | 978,849 | Soldado | 4 h 30 min |
| 25 | 159,652 | 1,138,501 | Soldado | 5 h 00 min |
| 26 | 177,426 | 1,315,927 | Soldado | 5 h 30 min |
| 27 | 196,205 | 1,512,132 | Soldado | 6 h 00 min |
| 28 | 215,982 | 1,728,114 | Soldado | 6 h 30 min |
| 29 | 236,750 | 1,962,864 | Soldado | 7 h 00 min |
| 30 | 258,500 | 2,221,364 | Capitán | 7 h 30 min |
| 31 | 281,221 | 2,502,585 | Capitán | 8 h 00 min |
| 32 | 304,901 | 2,807,486 | Capitán | 9 h 00 min |
| 33 | 329,528 | 3,137,014 | Capitán | 10 h 00 min |
| 34 | 355,087 | 3,492,101 | Capitán | 11 h 00 min |
| 35 | 381,563 | 3,873,664 | Capitán | 12 h 00 min |
| 36 | 408,941 | 4,282,605 | Capitán | 13 h 00 min |
| 37 | 437,206 | 4,719,811 | Capitán | 14 h 00 min |
| 38 | 466,337 | 5,186,148 | Capitán | 15 h 00 min |
| 39 | 496,316 | 5,682,464 | Capitán | 16 h 00 min |
| 40 | 527,124 | 6,209,588 | Sicario | 18 h 00 min |
| 41 | 558,741 | 6,768,329 | Sicario | 20 h 00 min |
| 42 | 591,146 | 7,359,475 | Sicario | 22 h 00 min |
| 43 | 624,316 | 7,983,791 | Sicario | 24 h 00 min |
| 44 | 658,229 | 8,642,020 | Sicario | 26 h 00 min |
| 45 | 692,861 | 9,334,881 | Sicario | 28 h 00 min |
| 46 | 728,190 | 10,063,071 | Jefe de Plaza | 31 h 00 min |
| 47 | 764,191 | 10,827,262 | Jefe de Plaza | 34 h 00 min |
| 48 | 800,841 | 11,628,103 | Jefe de Plaza | 37 h 00 min |
| 49 | 838,115 | 12,466,218 | Jefe de Plaza | 40 h 00 min |
| 50 | 876,000 | 13,342,218 | Jefe de Plaza | 44 h 00 min |
| 51 | 914,470 | 14,256,688 | Oyabun / Comisario | 50 h 00 min |
| 52 | 953,505 | 15,210,193 | Oyabun / Comisario | 56 h 00 min |
| 53 | 993,083 | 16,203,276 | Oyabun / Comisario | 62 h 00 min |
| 54 | 1,033,180 | 17,236,456 | Oyabun / Comisario | 68 h 00 min |
| 55 | 1,073,776 | 18,310,232 | Oyabun / Comisario | 76 h 00 min |
| 56 | 1,114,846 | 19,425,078 | Oyabun / Comisario | 84 h 00 min |
| 57 | 1,156,372 | 20,581,450 | Oyabun / Comisario | 92 h 00 min |
| 58 | 1,198,332 | 21,779,782 | Oyabun / Comisario | 100 h 00 min |
| 59 | 1,240,708 | 23,020,490 | Oyabun / Comisario | 110 h 00 min |
| 60 | 1,283,480 | 24,303,970 | Leyenda | 120 h 00 min |

*Nivel 1: XP inicial = 0. El personaje empieza en nivel 1 y debe acumular 150 XP para llegar a nivel 2.

**Total acumulado para nivel 60:** ~24,303,970 XP (~24.3 millones)
**Rango confirmado en documento 07_Progresion.md:** ~25-30 millones (consistente)

---

## 3. XP POR FUENTE

| Fuente | XP Base | Escala por Nivel | Bonus Adicional | Cooldown / Frecuencia |
|--------|---------|-----------------|-----------------|----------------------|
| **Quest de Facción** | 500 - 5,000 XP | ×(1 + nivel/100) | ×1.5 si es primera vez del día | Una vez por quest (~150 totales) |
| **Quest Secundaria** | 200 - 2,000 XP | ×(1 + nivel/100) | — | Repetible, algunas procedurales |
| **Kill PVE (enemigo mismo nivel)** | 50 XP | ×(1 + nivel_enemigo/50) | — | Ilimitado |
| **Kill PVE (enemigo +5 niveles)** | 100 XP | ×1.5 adicional | — | Ilimitado |
| **Kill PVP (mismo nivel)** | 200 XP | ×(1 + nivel/200) | ×1.3 si enemigo es nivel superior | Ilimitado |
| **Kill PVP (enemigo +5 niveles)** | 500 XP | ×(1 + nivel/100) | ×1.3 bonus nivel superior | Ilimitado |
| **Mazmorra básica (completada)** | 2,000 - 10,000 XP | ×(1 + nivel/50) | ×2 primera del día | Diaria |
| **Raid (por boss)** | 5,000 - 25,000 XP | ×(1 + nivel/40) | ×1.5 primera de la semana | Semanal |
| **Bounty completado** | 3,000 - 15,000 XP | ×(1 + nivel/30) | ×2 si objetivo tiene wanted 3+ | Ilimitado |
| **Evento Server** | 1,000 - 10,000 XP | ×(1 + nivel/50) | ×1.5 durante eventos especiales | Según evento |
| **Crafting (ítem de calidad nueva)** | 50 - 500 XP | según rareza del ítem | — | Ilimitado |
| **Control de Territorio (Crew)** | 100 - 500 XP/hora | según tipo de distrito | Solo para miembros de crew | Pasiva por hora |
| **Mentoría (aprendiz sube nivel)** | 10% del XP del aprendiz | — | — | Por nivel del aprendiz |

### Tabla de XP por Hora (Estimada)

| Rango de Nivel | XP/h (PVE) | XP/h (PVP) | XP/h (Mazmorras) | XP/h (Quests) |
|----------------|-----------|-----------|-------------------|---------------|
| 1-15 | 500 - 1,500 | 800 - 2,000 | 1,000 - 3,000 | 2,000 - 5,000 |
| 16-30 | 2,000 - 5,000 | 3,000 - 8,000 | 5,000 - 15,000 | 4,000 - 10,000 |
| 31-45 | 5,000 - 15,000 | 8,000 - 20,000 | 15,000 - 40,000 | 10,000 - 25,000 |
| 46-60 | 15,000 - 30,000 | 20,000 - 50,000 | 30,000 - 80,000 | 20,000 - 40,000 |

---

## 4. PENALIZACIÓN POR MUERTE (-15% XP)

Al morir, el jugador pierde el **15% de la XP acumulada en su nivel actual**.

### Ejemplos Concretos
| Situación | XP en Nivel | XP Perdida (-15%) | ¿Baja de Nivel? |
|-----------|------------|-------------------|-----------------|
| Nivel 10, 50% progreso (8,174 XP) | 8,174 | 1,226 | No (7.5% restante) |
| Nivel 20, 15% progreso (12,896 XP) | 12,896 | 1,934 | Sí (cae a nivel 19) |
| Nivel 30, 80% progreso (206,800 XP) | 206,800 | 31,020 | No (68% restante) |
| Nivel 50, 5% progreso (43,800 XP) | 43,800 | 6,570 | Sí (cae a nivel 49) |
| Nivel 60, 100% progreso | — | 0 | No (nivel máximo) |

### Casos Especiales
- **Muerte por Wanted 5⭐:** -15% XP normal + pérdida de TODO inventario no-equipado.
- **Muerte en servidor Hardcore:** Personaje borrado (no aplica penalización de XP).
- **Muerte por caída/accidente:** -15% XP normal (sin reducción).
- **Muerto por otro jugador en zona PVP libre:** -15% XP normal.

### Cómo Recuperar XP Perdida
- **Venganza:** Si matás al jugador que te mató dentro de 24h, recuperás el 50% de la XP perdida.
- **Bono diario de mazmorra:** La primera mazmorra del día da +100% XP (ayuda a recuperar pérdidas).

---

## 5. RANGOS POR NIVEL CON DESBLOQUEOS EXACTOS

| Nivel | Rango | Desbloqueos |
|-------|-------|-------------|
| **1** | Chivato | Zona inicial de facción, 3 habilidades base, arma inicial común |
| **10** | Chivato | Desbloquea skill tree (1er punto), quests secundarias |
| **15** | Chivato | Segunda arma equipable (puede llevar 2 armas) |
| **16** | Matón | Acceso a mazmorras básicas, receta de crafting nivel 1 |
| **20** | Soldado | Fundar o unirse a Crew, acceso a mercado negro, bonus de facción activado |
| **25** | Soldado | Segunda rama del skill tree desbloqueada (10 puntos total) |
| **30** | Capitán | Tercera rama del skill tree, comprar Safe House |
| **35** | Capitán | Vehículo personal (moto), recetas de crafting nivel 2 |
| **40** | Sicario | Acceso a raids, vehículos avanzados (auto), bounties de alto nivel |
| **45** | Sicario | Montura (vehículo con blindaje ligero), recetas de crafting nivel 3 |
| **46** | Jefe de Plaza | Puede adquirir Negocio de Fachada |
| **50** | Jefe de Plaza | Clases Élite (si tiene reputación Reverenciado con facción) |
| **55** | Oyabun / Comisario | Acceso a todas las raids, eventos server-wide con bonus, helicóptero |
| **60** | Leyenda | Título server-wide, gear legendario, acceso a Mansión del Alcalde |

---

## 6. TIEMPO ESTIMADO PARA ALCANZAR CADA NIVEL

| Rango de Niveles | Tiempo Total Acumulado | Tiempo por Nivel | Sesiones Recomendadas |
|------------------|----------------------|-------------------|-----------------------|
| 1-15 | ~11 horas | 20-80 min | 2-3 sesiones |
| 16-20 | ~7 horas | 1.5-2.5 h | 1-2 sesiones |
| 21-30 | ~27 horas | 2-4 h | 3-4 sesiones |
| 31-40 | ~58 horas | 4-7 h | 6-8 sesiones |
| 41-50 | ~108 horas | 8-15 h | 10-14 sesiones |
| 51-60 | ~288 horas | 12-48 h | 25-35 sesiones |

**Tiempo total estimado para nivel 60:** ~500 horas (jugador promedio)
**Tiempo total optimizado (jugador hardcore):** ~250-300 horas

---

## 7. NOTAS DE DISEÑO

- La curva está diseñada para que el **85% de los jugadores** llegue al nivel 30 (Capitán) en ~2 meses de juego casual.
- Solo el **10-15%** de los jugadores alcanza nivel 50+ (Clases Élite).
- Menos del **1%** alcanza nivel 60 (Leyenda).
- El sistema de mentoría (jugador 50+ apadrina a uno 1-10) acelera la progresión de nuevos jugadores en un +15% XP.
- La penalización del 15% XP al morir significa que en niveles altos (~50+), una muerte puede representar **4-6 horas de progreso perdidas**.
