# BARRIO SIN LEY ONLINE (BSLO)
## design/balance/combat_formulas.md — Fórmulas de Combate
**Versión:** 2.0 | **Última Revisión:** Mayo 2026

---

## 1. FILOSOFÍA DEL COMBATE

BSLO usa un sistema híbrido **Tab-Target + Action**. Ambas modalidades coexisten: el jugador puede seleccionar enemigos con Tab y usar habilidades, pero si además apunta manualmente a puntos débiles, obtiene bonificaciones. Las fórmulas están diseñadas para que **Skill > Gear > Level**: un jugador hábil nivel 30 con buen gear puede vencer a uno nivel 40 con gear malo.

---

## 2. FÓRMULA DE DAÑO

```
Daño_Total = Daño_Base_Arma × (1 + (Stat_Modificador - 5) × 0.1) × Mod_Habilidad × Mod_Rareza × Mod_Crítico × Mod_Puntería
```

### Componentes

| Componente | Descripción | Ejemplo |
|------------|-------------|---------|
| **Daño_Base_Arma** | Daño inherente del arma (según tipo y rareza) | Pistola común: 50 DMG |
| **Stat_Modificador** | Stat principal del arma (STR para melee, DEX para rango) | STR 25 |
| **Mod_Habilidad** | Multiplicador de la habilidad usada | Jab (Boxeador): ×1.0, Gancho: ×2.0 |
| **Mod_Rareza** | Multiplicador por rareza del arma | Común: ×1.0, Épico: ×1.3, Legendario: ×1.5 |
| **Mod_Crítico** | ×2.0 si es golpe crítico, ×1.0 si no | Ver sección 3 |
| **Mod_Puntería** | ×1.25 si apunta a punto débil (cabeza/pecho), ×1.0 si no | Bonus por action combat |

### Ejemplo Numérico

Un **Gatillero** (nivel 30, DEX 25) dispara su **Pistola Épica** (Daño Base: 80) usando **Disparo Preciso** (×1.3) contra la cabeza de un enemigo:

```
Daño = 80 × (1 + (25 - 5) × 0.1) × 1.3 × 1.3 × 1.0 × 1.25
     = 80 × (1 + 2.0) × 1.3 × 1.3 × 1.0 × 1.25
     = 80 × 3.0 × 1.3 × 1.3 × 1.0 × 1.25
     = 80 × 6.3375
     = 507 DMG
```

### Daño por Tipo de Arma (Base, Sin Modificadores)

| Tipo de Arma | Daño Base | Velocidad | Alcance | Stat Principal |
|-------------|-----------|-----------|---------|---------------|
| Pistola Común | 50 | 1.0 | 20m | DEX |
| Rifle de Asalto | 75 | 0.8 | 40m | DEX |
| Escopeta | 90 | 0.6 | 15m | DEX |
| SMG | 40 | 1.3 | 25m | DEX |
| Rifle Francotirador | 200 | 0.3 | 80m | DEX |
| Bate de Béisbol | 60 | 0.7 | 2m | STR |
| Navaja | 35 | 1.5 | 1m | STR |
| Cadena | 45 | 1.1 | 2.5m | STR |
| Puño Americano | 70 | 0.6 | 1m | STR |
| Puños (Boxeador) | 40 | 1.4 | 1m | STR |

---

## 3. FÓRMULA DE CRÍTICO

```
Chance_Crítico(%) = DEX × 0.5
Daño_Crítico = Daño_Total × 2.0
```

### Tabla de Chance Crítico por DEX

| DEX | Chance Crítico | Frecuencia |
|-----|---------------|------------|
| 5 | 2.5% | 1 cada 40 golpes |
| 10 | 5% | 1 cada 20 golpes |
| 15 | 7.5% | 1 cada 13 golpes |
| 20 | 10% | 1 cada 10 golpes |
| 25 | 12.5% | 1 cada 8 golpes |
| 30 | 15% | 1 cada ~7 golpes |
| 40 | 20% | 1 cada 5 golpes |
| 50 | 25% | 1 cada 4 golpes |

### Bonificadores a Chance Crítico
| Fuente | Bonus | Duración |
|--------|-------|----------|
| Tiro en la Cabeza (Gatillero) | Crítico garantizado | Instantáneo, 30s CD |
| Ataque por la espalda (Sicario) | +150% daño (no es crítico, es daño posicional) | Pasivo |
| Puñalada (Sicario) | +150% daño por detrás | Pasivo |
| Rareza Épica del arma | +5% chance crítico | Pasivo |
| Rareza Legendaria del arma | +10% chance crítico | Pasivo |

---

## 4. FÓRMULA DE DEFENSA

```
Reducción_Física(%) = Defensa / (Defensa + 100 + Nivel_Atacante × 5)
```

### Tabla de Reducción de Daño

| Defensa | Vs Nv 1 | Vs Nv 20 | Vs Nv 40 | Vs Nv 60 |
|---------|---------|----------|----------|----------|
| 10 | 5.0% | 4.8% | 4.5% | 4.3% |
| 25 | 11.4% | 10.9% | 10.4% | 9.8% |
| 50 | 20.0% | 19.2% | 18.5% | 17.9% |
| 100 | 33.3% | 32.3% | 31.3% | 30.3% |
| 200 | 50.0% | 48.8% | 47.6% | 46.5% |
| 500 | 71.4% | 70.4% | 69.4% | 68.5% |
| 1000 | 83.3% | 82.6% | 82.0% | 81.3% |

### Defensa por Tipo de Armadura

| Tipo | Defensa Base | Peso | Penalización de Movimiento |
|------|-------------|------|---------------------------|
| Ropa Civil | 5 | 0 kg | 0% |
| Chaleco Antibalas Nv 1 | 50 | 5 kg | -5% |
| Chaleco Antibalas Nv 2 | 100 | 8 kg | -10% |
| Chaleco Táctico SWAT | 200 | 12 kg | -20% |
| Armadura de Combate (Élite) | 350 | 15 kg | -25% |
| Traje Blindado (Legendario) | 500 | 20 kg | -30% |

### Reducción de Daño Elemental / Especial
- **Resistencia a Veneno:** CON × 1.5%
- **Resistencia a Fuego:** CON × 1.0%
- **Resistencia a Explosivos:** CON × 0.5% + INT × 0.5%

---

## 5. FÓRMULA DE HP (Puntos de Vida)

```
HP_Base = 100 + (CON - 5) × 20 + Nivel × 10
```

### Tabla de HP por CON y Nivel

| CON | Nv 1 | Nv 10 | Nv 20 | Nv 30 | Nv 40 | Nv 50 | Nv 60 |
|-----|------|-------|-------|-------|-------|-------|-------|
| 5 | 100 | 190 | 290 | 390 | 490 | 590 | 690 |
| 10 | 200 | 290 | 390 | 490 | 590 | 690 | 790 |
| 15 | 300 | 390 | 490 | 590 | 690 | 790 | 890 |
| 20 | 400 | 490 | 590 | 690 | 790 | 890 | 990 |
| 25 | 500 | 590 | 690 | 790 | 890 | 990 | 1,090 |
| 30 | 600 | 690 | 790 | 890 | 990 | 1,090 | 1,190 |
| 40 | 800 | 890 | 990 | 1,090 | 1,190 | 1,290 | 1,390 |
| 50 | 1,000 | 1,090 | 1,190 | 1,290 | 1,390 | 1,490 | 1,590 |

### HP por Clase (Aproximado, CON = 15, Nv 30)

| Clase | HP Estimado | Notas |
|------|-------------|-------|
| Matón (Tank) | 790 + 20% (Rama A) = 948 | +defensa, +resistencia CC |
| SWAT (Tank) | 690 + escudo | 90% bloqueo frontal |
| Doctor de Barrio | 490 | Bajo HP, compensa con curas |
| Boxeador | 590 | HP medio, movilidad alta |
| Gatillero | 490 | HP bajo, daño a distancia |
| Vandal | 640 | HP medio-alto, daño área |

---

## 6. FÓRMULA DE STAMINA

```
Stamina_Máxima = 50 + (CON - 5) × 5
```

### Tabla de Stamina Máxima

| CON | Stamina Máx | Sprint (seg) | Esquivas |
|-----|------------|-------------|----------|
| 5 | 50 | 5.0s | 2 |
| 10 | 75 | 7.5s | 3 |
| 15 | 100 | 10.0s | 4 |
| 20 | 125 | 12.5s | 5 |
| 25 | 150 | 15.0s | 6 |
| 30 | 175 | 17.5s | 7 |

### Regeneración de Stamina
- **Reposo (sin acción):** 10 puntos/segundo
- **Caminando:** 5 puntos/segundo
- **En combate:** 3 puntos/segundo
- **Corriendo/Sprint:** 0 puntos/segundo
- **Después de consumir Cerveza:** -50% regeneración por 2 min
- **Bajo efecto de Cocaína:** +30% velocidad, no afecta regeneración directa

### Costo de Acciones en Stamina

| Acción | Costo Stamina |
|--------|--------------|
| Sprint (por segundo) | 10/s |
| Esquiva (roll) | 15 |
| Salto | 5 |
| Golpe básico (melee) | 3 |
| Habilidad 1 | 5-15 |
| Habilidad 2 | 10-20 |
| Habilidad 3 | 15-25 |
| Habilidad 4 | 20-30 |
| Habilidad 5 (Ultimate) | 30-50 |

---

## 7. COBERTURA Y PENETRACIÓN

### Cobertura
| Tipo | Reducción de Daño | Precisión | Restricciones |
|------|-------------------|-----------|---------------|
| Cobertura Frontal | -75% daño | Normal | No armas largas (rifles, escopetas) |
| Blind Fire (disparo ciego) | -75% daño | -90% precisión | Cualquier arma |
| Cobertura Lateral | -50% daño | Normal | Sin restricciones |
| Cobertura Destruible | -25% daño | Normal | Se rompe tras 500 DMG recibido |

### Penetración de Cobertura
| Tipo de Ataque | Penetración |
|----------------|-------------|
| Rifle Francotirador | Atraviesa cobertura ligera (madera, drywall) |
| RPG / Explosivos | Destruye cobertura en área 3m |
| Escopeta (distancia cercana) | Atraviesa cobertura ligera |
| Habilidad "Carga" (Vandal) | Rompe cobertura enemiga |
| Habilidad "Brecha" (SWAT) | Atraviesa enemigos en línea |

---

## 8. FÓRMULA DE EJECUCIÓN

```
Si HP_Enemigo < 10% de HP_Máximo
    → Mostrar prompt [F] (2 segundos)
    → Si el jugador presiona F dentro de la ventana
        → Animación de 2 segundos (invulnerable durante animación)
        → Muerte instantánea del enemigo
        → Buff "Moral Alta" a aliados en 30m: +10% daño por 30 segundos
```

### Condiciones de Ejecución
| Condición | Aplica |
|-----------|--------|
| Enemigo < 10% HP | Sí |
| Enemigo es NPC | Sí |
| Enemigo es jugador | Sí |
| Durante cobertura | Sí (si estás fuera de cobertura) |
| Durante sigilo (Sicario) | Sí, desde sigilo umbral es <15% HP |
| Habilidad "Ejecución" (Sicario) | Sí, <15% HP, 2 min CD, muerte instantánea |
| Habilidad "Plata o Plomo" (El Patrón) | Sí, <20% HP, ejecución instantánea |

### Buffs Relacionados con Ejecuciones
| Buff | Efecto | Duración | Fuente |
|------|--------|----------|--------|
| Moral Alta | +10% daño a aliados en 30m | 30s | Ejecución exitosa |
| Intimidación | Enemigos cercanos -10% daño | 15s | Ejecución en PVP |
| Sangre Fría | +5% chance crítico | 60s | 3 ejecuciones seguidas |

---

## 9. MODIFICADORES DE DAÑO ADICIONALES

### Por Distancia
| Distancia al Objetivo | Modificador (Armas de Fuego) |
|----------------------|------------------------------|
| Cuerpo a cuerpo (<2m) | ×1.0 |
| Cercana (2-10m) | ×1.0 |
| Media (10-30m) | ×0.9 |
| Larga (30-50m) | ×0.7 |
| Muy Larga (>50m) | ×0.5 (excepto rifle francotirador: ×1.0) |

### Por Posición
| Posición | Modificador |
|----------|------------|
| Frente | ×1.0 |
| Lateral | ×1.1 |
| Espalda | ×1.5 (×2.5 para Sicario con Puñalada) |
| Cabeza (puntería manual) | ×1.25 |
| En cobertura | ×0.25 (recibido) |

### Clase de Armadura vs Tipo de Daño
| Daño \ Defensa | Ropa Civil | Chaleco Nv1 | Chaleco Nv2 | SWAT | Legendario |
|----------------|-----------|-------------|-------------|------|-----------|
| Balas | ×1.3 | ×0.8 | ×0.6 | ×0.4 | ×0.3 |
| Cuerpo a Cuerpo | ×1.0 | ×1.0 | ×0.9 | ×0.8 | ×0.7 |
| Explosivos | ×1.0 | ×0.9 | ×0.8 | ×0.7 | ×0.6 |
| Fuego | ×1.2 | ×1.1 | ×1.0 | ×0.9 | ×0.8 |
| Veneno | ×1.0 | ×1.0 | ×1.0 | ×1.0 | ×1.0 |

---

## 10. RESUMEN DE FÓRMULAS

| Concepto | Fórmula |
|----------|---------|
| Daño Total | Daño_Base × (1 + (Stat - 5) × 0.1) × Mod_Hab × Mod_Rareza × Mod_Crit × Mod_Puntería |
| Chance Crítico | DEX × 0.5% |
| Daño Crítico | Daño_Total × 2.0 |
| Reducción de Defensa | Defensa / (Defensa + 100 + Nv_Atacante × 5) |
| HP Base | 100 + (CON - 5) × 20 + Nivel × 10 |
| Stamina Máx | 50 + (CON - 5) × 5 |
| Penalización Cobertura Frontal | -75% daño recibido |
| Penalización Blind Fire | -90% precisión |
| Umbral Ejecución | Enemigo < 10% HP |
| Daño Puntería Manual (Cabeza) | ×1.25 |
| Daño por Espalda | ×1.5 (×2.5 Sicario) |
