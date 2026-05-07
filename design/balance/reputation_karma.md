# BARRIO SIN LEY ONLINE (BSLO)
## design/balance/reputation_karma.md — Sistema de Karma y Reputación por Facción
**Versión:** 2.0 | **Última Revisión:** Mayo 2026

---

## 1. FILOSOFÍA DEL SISTEMA

BSLO usa dos sistemas de moral/reputación independientes:
1. **Karma de Barrio** — Mide tu brújula moral general (Criminal ↔ Vigilante).
2. **Reputación por Facción** — Mide tu relación con cada una de las 6 facciones (Odiado ↔ Legendario).

Ambos sistemas afectan tu gameplay de forma significativa pero diferente. Puedes ser un Criminal querido por la Yakuza, o un Vigilante odiado por la Policía.

---

## 2. KARMA DE BARRIO

### Escala General

```
CRIMINAL                  NEUTRAL                VIGILANTE
-1000  ←  -300  ←  -299  ←  0  →  +299  →  +300  →  +1000
```

### Puntos de Karma por Acción

| Acción | Puntos de Karma | Límite Diario |
|--------|----------------|---------------|
| Matar civil (NPC) | -50 | Sin límite |
| Matar jugador sin wanted (en zona segura) | -30 | Sin límite |
| Matar jugador sin wanted (en zona PVP) | -10 | Sin límite |
| Matar criminal (NPC) | +20 | Sin límite |
| Matar jugador con wanted 3+⭐ | +15 | 10 veces/día |
| Completar quest de facción (legal) | +10 | Por quest |
| Completar quest secundaria (legal) | +5 | Por quest |
| Completar bounty criminal | +25 | 5 veces/día |
| Robar a NPC civil | -15 | Sin límite |
| Robar a jugador (pickpocket) | -10 | Sin límite |
| Vender drogas a NPC | -5 | Sin límite |
| Sobornar a policía | -10 | Sin límite |
| Arrestar a criminal (Policía) | +20 | Sin límite |
| Curar a jugador aliado | +2 | 20 veces/día |
| Participar en raid defensiva | +5 | 3 veces/día |
| Tachar graffiti de crew criminal | +5 | 10 veces/día |

### Rangos de Karma y sus Efectos

| Rango | Puntos | Título | Efectos |
|-------|--------|--------|---------|
| **Criminal Extremo** | -1000 a -700 | "Enemigo Público" | +20% daño, acceso a mercado negro, -50% precios ilegales, NPCs civiles huyen al verte, policía te ataca a la vista |
| **Criminal** | -699 a -300 | "Mal Vivir" | +15% daño, acceso a mercado negro, -25% precios ilegales, NPCs temerosos, policía sospecha de ti |
| **Neutral Bajo** | -299 a -1 | "Callejero" | +10% oro de quests, sin bonus/penalizaciones fuertes |
| **Neutral Alto** | 0 a +299 | "Del Montón" | +20% oro de quests, precios estándar en tiendas |
| **Vigilante Bajo** | +300 a +699 | "Vecino Ejemplar" | -25% precios legales, acceso a gear táctico básico, safe zones extendidas (+50% radio) |
| **Vigilante Alto** | +700 a +1000 | "Ángel del Barrio" | -50% precios legales, acceso a gear táctico avanzado, safe zones extendidas (+100% radio), NPCs aliados te saludan |

### Cómo Cambia el Karma

| Método | Efectividad |
|--------|-------------|
| **Matar criminales** | +15 a +25 por kill (repetible) |
| **Completar quests legales** | +5 a +10 por quest |
| **Hacer arrestos (Policía)** | +20 por arresto |
| **Matar civiles** | -50 por kill |
| **Robar** | -10 a -15 por acción |
| **Vender drogas** | -5 por venta |
| **Tiempo sin acciones criminales** | +1 punto cada hora real (hasta +24/día) |
| **Donar al banco de la ciudad** | +10 por cada $10,000 donados |

---

## 3. REPUTACIÓN POR FACCIÓN

### Niveles de Reputación

Cada facción (Yakuza, Cártel, Mafia, Policía, Cholos, Sin-Legaja) tiene su propia barra de reputación independiente.

| Nivel | Puntos Requeridos | Título |
|-------|------------------|--------|
| 0 — Odiado | 0 | "Odiado" |
| 1 — Despreciado | 100 | "Despreciado" |
| 2 — Neutral | 500 | "Neutral" |
| 3 — Respetado | 2,000 | "Respetado" |
| 4 — Reverenciado | 8,000 | "Reverenciado" |
| 5 — Legendario | 20,000 | "Legendario" |

### Puntos Máximos por Nivel

Cada nivel tiene un techo de puntos. No se puede pasar al siguiente nivel hasta alcanzar el umbral:
- Odiado: 0 a 99 pts
- Despreciado: 100 a 499 pts
- Neutral: 500 a 1,999 pts
- Respetado: 2,000 a 7,999 pts
- Reverenciado: 8,000 a 19,999 pts
- Legendario: 20,000+ pts

### Bonus por Nivel de Reputación

| Nivel | Efectos Positivos | Efectos Negativos |
|-------|------------------|-------------------|
| **Odiado** | — | NPCs de esa facción te atacan a la vista. Precios +200%. No puedes entrar a sus zonas seguras. |
| **Despreciado** | — | Precios +100%. NPCs te insultan. No puedes comerciar con vendedores de facción. |
| **Neutral** | Precios estándar. NPCs neutrales. | — |
| **Respetado** | Descuento -15% en tiendas de facción. Quests exclusivas de facción desbloqueadas. NPCs amigables. | — |
| **Reverenciado** | Descuento -30%. Clase Élite desbloqueada (si Nv 50+). Gear legendario de facción. NPCs se inclinan. | — |
| **Legendario (Temido)** | Descuento -50%. Título server-wide visible. NPCs de facción se arrodillan. Puedes dar órdenes a NPCs de bajo rango. | Otras facciones te temen (efecto social) |

### Ejemplo: Reputaciones Contrastantes

Un jugador puede tener:
| Facción | Nivel | Efecto |
|---------|-------|--------|
| Yakuza | Reverenciado | Descuentos, quests exclusivas, clase Oyabun disponible |
| Cártel | Neutral | Precios estándar |
| Mafia | Despreciado | Precios +100% |
| Policía | Odiado | Atacado a la vista por policías |
| Cholos | Respetado | Descuentos, quests exclusivas |
| Sin-Legaja | Legendario | Título, -50% precios, NPCs se arrodillan |

---

## 4. PUNTOS DE REPUTACIÓN POR ACCIÓN (POR FACCIÓN)

### Acciones que Afectan a TODAS las facciones

| Acción | Efecto en TODAS las facciones |
|--------|------------------------------|
| Matar civil | -5 a todas (te ven como amenaza) |
| Completar evento server-wide | +10 a todas |
| Morir en PVP contra facción enemiga | -2 a la facción del asesino |
| Ganar una guerra de crew | +20 a tu facción, -10 a la enemiga |

### Yakuza

| Acción | Puntos |
|--------|--------|
| Completar quest de Yakuza | +50 |
| Matar miembro de Yakuza (PVP) | -100 |
| Matar enemigo de Yakuza (Cártel) | +15 |
| Participar en duelo formal (Templo del Viento) | +10 |
| Pagar deudas a NPC Yakuza | +25 |
| Robar un templo Yakuza | -200 |
| Vestir ropa formal en Distrito Dragón | +5/hora |

### Cártel

| Acción | Puntos |
|--------|--------|
| Completar quest de Cártel | +50 |
| Matar miembro del Cártel (PVP) | -100 |
| Matar enemigo del Cártel (Yakuza) | +15 |
| Vender drogas en territorio del Cártel | +10 |
| Participar en carreras de trocas | +15 |
| Faltar el respeto a la Santa Muerte | -150 |
| Comprar en el mercado negro del Cártel | +3/comprá |

### Mafia

| Acción | Puntos |
|--------|--------|
| Completar quest de Mafia | +50 |
| Matar miembro de la Mafia (PVP) | -100 |
| Matar enemigo de la Mafia (Policía) | +15 |
| Comer en restaurante mafioso (minijuego) | +5 |
| Llevar a cabo un "encargo" (asesinato por contrato) | +30 |
| Romper un acuerdo (traicionar a la Mafia) | -250 |
| Usar modales (emote de respeto) frente a Don | +10 |

### Policía

| Acción | Puntos |
|--------|--------|
| Completar quest de Policía | +50 |
| Matar miembro de la Policía (PVP) | -200 |
| Matar criminal con wanted 3+⭐ | +25 |
| Arrestar a un jugador (no matar) | +40 |
| Sobornar a un policía (como criminal) | -30 |
| Reportar un crimen (usar emote) | +5 |
| Patrullar con un policía NPC 10 min | +20 |

### Cholos

| Acción | Puntos |
|--------|--------|
| Completar quest de Cholos | +50 |
| Matar miembro Cholo (PVP) | -100 |
| Matar enemigo de Cholos (Policía) | +15 |
| Hacer graffiti en territorio Cholo | +5/graffiti |
| Participar en batalla de baile/rap | +10 |
| Dañar un mural de graffiti Cholo | -100 |
| Defender a la Abuela del Barrio (NPC) | +100 |

### Sin-Legaja

| Acción | Puntos |
|--------|--------|
| Completar quest de Sin-Legaja | +50 |
| Matar Sin-Legaja (PVP) | -50 |
| Completar contrato de mercenario | +30 |
| Visitar el Mercado Global | +2/hora |
| Usar la radio personal en público | +5 |
| No unirse a ninguna crew por 30 días | +50/mes |
| Ayudar a un Sin-Legaja en apuros | +20 |

---

## 5. INTERACCIÓN KARMA ↔ REPUTACIÓN

| Karma | Efecto en Reputación Inicial con Facción |
|-------|----------------------------------------|
| Criminal (-1000 a -300) | +50 reputación inicial con Cártel, -50 con Policía |
| Neutral (-299 a +299) | Sin modificación |
| Vigilante (+300 a +1000) | +50 reputación inicial con Policía, -50 con Cártel |

---

## 6. EJEMPLOS DE PERSONAJE

### "El Narco Filantrópico"
- **Karma:** -450 (Criminal)
- **Yakuza:** Neutral | **Cártel:** Reverenciado | **Mafia:** Neutral
- **Policía:** Odiado | **Cholos:** Respetado | **Sin-Legaja:** Neutral
- **Resultado:** Acceso a clase El Patrón, +15% daño, mercado negro, pero no puede entrar a zonas policiales.

### "El Policía Honesto"
- **Karma:** +800 (Vigilante Alto)
- **Yakuza:** Neutral | **Cártel:** Despreciado | **Mafia:** Neutral
- **Policía:** Legendario | **Cholos:** Odiado | **Sin-Legaja:** Respetado
- **Resultado:** -50% precios legales, gear táctico, safe zones grandes, pero los Cholos lo atacan.

### "El Mercenario Sin Brújula"
- **Karma:** +50 (Neutral)
- **Yakuza:** Respetado | **Cártel:** Neutral | **Mafia:** Reverenciado
- **Policía:** Neutral | **Cholos:** Neutral | **Sin-Legaja:** Legendario
- **Resultado:** +20% oro de quests, acceso a clase Mercenario, máxima flexibilidad.
