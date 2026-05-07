# BARRIO SIN LEY ONLINE (BSLO)
## design/balance/class_stats.md — Estadísticas Detalladas de Clases
**Versión:** 2.0 | **Última Revisión:** Mayo 2026

---

## 1. INTRODUCCIÓN

Este documento detalla las estadísticas numéricas de cada clase: HP base, Stamina base, stat principal, multiplicadores de daño, cooldowns exactos, duraciones y costos de stamina. Todos los valores asumen nivel 30 con CON = 15 y stat principal = 15 (a menos que se indique lo contrario).

**Clases cubiertas:** 14 clases base + 6 clases élite = 20 clases totales.

---

## 2. CLASES TANK

---

### Matón (Tank Puro)

| Estadística | Valor |
|------------|-------|
| **HP Base (Nv 30, CON 15)** | 590 |
| **Stamina Base (CON 15)** | 100 |
| **Stat Principal** | STR (modificador daño ×0.1 por punto sobre 5) |
| **Armas** | Bate, Puños, Escudo improvisado |
| **Daño Base (Bate, STR 15)** | 60 × (1 + (15-5)×0.1) = 60 × 2.0 = 120 |

| Habilidad | CD (s) | Duración | Costo Stamina | Daño/Efecto |
|-----------|--------|----------|--------------|-------------|
| 1 — Empujón | 8s | Stun 2s (contra pared) | 10 | Empuja 5m, daño 30 |
| 2 — Provocación | 12s | Taunt 5s | 15 | Atracción en área 10m |
| 3 — Aguante | 20s | 8s | 20 | +50% defensa, -30% velocidad |
| 4 — Contragolpe | 15s | Hasta recibir golpe | 15 | Bloquea y devuelve ×1.5 daño |
| 5 — Terremoto | 30s | Stun 3s | 30 | Área 8m, daño 80 |

**Skill Tree:**
- **Rama A — Muro:** +20% HP, +10% resistencia a CC
- **Rama B — Carnicero:** +15% daño melee, +20% generación de amenaza
- **Rama C — Protector:** Aliados en 10m reciben 10% de tu defensa como bonus

---

### SWAT (Tank Táctico) — Solo Policía

| Estadística | Valor |
|------------|-------|
| **HP Base (Nv 30, CON 15)** | 540 |
| **Stamina Base (CON 15)** | 100 |
| **Stat Principal** | STR |
| **Armas** | Escopeta, Escudo balístico, Porra |
| **Daño Base (Escopeta, DEX 15)** | 90 × 2.0 = 180 (corto alcance) |

| Habilidad | CD (s) | Duración | Costo Stamina | Daño/Efecto |
|-----------|--------|----------|--------------|-------------|
| 1 — Formación | 2s | Pasivo mientras aliados estén detrás | 0 | Aliados en 5m reciben -30% daño |
| 2 — Granada Flash | 20s | Ceguera 4s | 15 | Cono frontal, sin daño |
| 3 — Escudo Balístico | 5s (toggle) | Ilimitado mientras activo | 5/s | Bloquea 90% daño frontal, solo caminar |
| 4 — Brecha | 15s | Stun 1s por enemigo | 20 | Carga 8m, daño 60 |
| 5 — Zona Segura | 45s | 12s | 30 | Área 15m, aliados no reciben críticos |

**Skill Tree:**
- **Rama A — Fortaleza:** Escudo dura 50% más, resistencia +20%
- **Rama B — Comandante:** Formación afecta a +2 aliados
- **Rama C — Breacher:** +30% daño con explosivos tácticos

---

## 3. CLASES HEALER

---

### Doctor de Barrio (Healer Puro)

| Estadística | Valor |
|------------|-------|
| **HP Base (Nv 30, CON 15)** | 490 |
| **Stamina Base (CON 15)** | 100 |
| **Stat Principal** | INT (modifica curación: +5% cura por punto sobre 5) |
| **Armas** | Jeringas, Bisturí, Kit médico |
| **Daño Base (Bisturí)** | 20 (solo defensivo) |

| Habilidad | CD (s) | Duración | Costo Stamina | Curación/Efecto |
|-----------|--------|----------|--------------|-----------------|
| 1 — Jeringazo | 6s | Instantáneo | 10 | Cura 25% HP del aliado |
| 2 — Vendas | 15s | HOT 10s (5 tics) | 15 | 5% HP cada 2s |
| 3 — Adrenalina | 120s | Instantáneo | 30 | Resucita aliado con 30% HP |
| 4 — Antídoto | 20s | Instantáneo | 10 | Remueve veneno, enfermedad, debuffs |
| 5 — Quirófano Móvil | 300s | 6s | 50 | Área: 15% HP/s a todos los aliados |

**Skill Tree:**
- **Rama A — Cirujano:** +20% efectividad curas directas
- **Rama B — Farmacéutico:** HOTs duran +5s y stackean
- **Rama C — Triaje:** Curas +50% efectivas si aliado <20% HP

---

### Curandero (Healer/Support)

| Estadística | Valor |
|------------|-------|
| **HP Base (Nv 30, CON 15)** | 490 |
| **Stamina Base (CON 15)** | 100 |
| **Stat Principal** | WIS (modifica curación por hierbas) |
| **Armas** | Hierbas, Incienso, Amuleto |
| **Daño Base** | 10 (simbólico) |

| Habilidad | CD (s) | Duración | Costo Stamina | Curación/Efecto |
|-----------|--------|----------|--------------|-----------------|
| 1 — Taco Curativo | 8s | Instantáneo | 10 | Cura 20% HP, lanzable |
| 2 — Incienso | 25s | 20s | 15 | Área 8m: +10% HP regen pasivo |
| 3 — Limpia | 30s | Instantáneo | 20 | Remueve 1 debuff de aliados en 15m |
| 4 — Ofrenda | 60s | Instantáneo | 25 | Sacrifica 15% HP. Aliados en 20m recuperan doble |
| 5 — Milagro | 900s | Instantáneo | 50 | Revive TODOS los aliados caídos en 20m al 10% HP |

**Skill Tree:**
- **Rama A — Fe:** +25% efectividad Milagro y Ofrenda
- **Rama B — Naturaleza:** Incienso da +10% velocidad de movimiento
- **Rama C — Mártir:** -10% daño recibido mientras canaliza curas

---

## 4. CLASES DPS MELEE

---

### Boxeador (DPS Melee Puro)

| Estadística | Valor |
|------------|-------|
| **HP Base (Nv 30, CON 15)** | 590 |
| **Stamina Base (CON 15)** | 100 |
| **Stat Principal** | STR (×2.0 a daño de puños) |
| **Armas** | Puños (daño base 40) |
| **Daño Base (Puños, STR 15)** | 40 × 2.0 = 80 |

| Habilidad | CD (s) | Duración | Costo Stamina | Daño/Efecto |
|-----------|--------|----------|--------------|-------------|
| 1 — Jab (3 cargas) | 3s por carga | Instantáneo | 5 | Daño 50, rápido |
| 2 — Gancho | 8s | Instantáneo | 15 | Daño +100% = 160 |
| 3 — Esquiva | 6s | 0.5s i-frames | 10 | Dash lateral, invulnerable |
| 4 — Combo (5 golpes) | 15s | 2s (secuencia) | 25 | Daño total 400 (último +200%) |
| 5 — Knockout | 20s | Stun 5s | 20 | 50% chance si enemigo <30% HP |

**Skill Tree:**
- **Rama A — Peso Pesado:** +20% daño base, -10% velocidad de ataque
- **Rama B — Peso Ligero:** +20% velocidad de ataque, +1 carga de Jab
- **Rama C — Contragolpeador:** Bloquear reduce CD de Esquiva 2s

---

### Sicario (DPS Melee Sigiloso)

| Estadística | Valor |
|------------|-------|
| **HP Base (Nv 30, CON 15)** | 490 |
| **Stamina Base (CON 15)** | 100 |
| **Stat Principal** | DEX |
| **Armas** | Navaja (daño base 35), Puño Americano |
| **Daño Base (Navaja, DEX 15)** | 35 × 2.0 = 70 |

| Habilidad | CD (s) | Duración | Costo Stamina | Daño/Efecto |
|-----------|--------|----------|--------------|-------------|
| 1 — Puñalada | 3s | Instantáneo | 5 | Daño 70 (×2.5 por detrás = 175) |
| 2 — Sigilo | 25s | 8s | 20 | Invisible. Primer ataque +200% daño |
| 3 — Garrote | 20s | Stun 4s | 15 | Solo desde sigilo |
| 4 — Marca | 15s | 10s en objetivo | 10 | Objetivo recibe +25% daño de todas fuentes |
| 5 — Ejecución | 120s | Instantáneo | 30 | Muerte instantánea si enemigo <15% HP |

**Skill Tree:**
- **Rama A — Asesino:** +30% daño en sigilo
- **Rama B — Saboteador:** Puede colocar minas sin romper sigilo
- **Rama C — Fantasma:** +5s duración de sigilo

---

### Vandal (DPS Melee Área)

| Estadística | Valor |
|------------|-------|
| **HP Base (Nv 30, CON 15)** | 640 |
| **Stamina Base (CON 15)** | 100 |
| **Stat Principal** | STR |
| **Armas** | Bate (daño base 60), Cadena (45) |
| **Daño Base (Bate, STR 15)** | 60 × 2.0 = 120 |

| Habilidad | CD (s) | Duración | Costo Stamina | Daño/Efecto |
|-----------|--------|----------|--------------|-------------|
| 1 — Batazo | 5s | Instantáneo | 10 | Arco 120°, daño 100 |
| 2 — Cadena | 7s | Instantáneo | 12 | 360°, empuja 3m, daño 80 |
| 3 — Furia | 25s | 8s | 20 | +40% velocidad ataque, -20% defensa |
| 4 — Carga | 12s | Instantáneo | 15 | Corre 10m, atraviesa enemigos, daño 90 |
| 5 — Destrucción | 35s | Instantáneo | 30 | Área 6m, daño 200, rompe cobertura |

**Skill Tree:**
- **Rama A — Demoledor:** +20% daño a estructuras y vehículos
- **Rama B — Incansable:** -2s CD en todas habilidades tras kill
- **Rama C — Tanque de Acero:** -15% daño recibido durante Furia

---

## 5. CLASES DPS RANGO

---

### Gatillero (DPS Rango Puro)

| Estadística | Valor |
|------------|-------|
| **HP Base (Nv 30, CON 15)** | 490 |
| **Stamina Base (CON 15)** | 100 |
| **Stat Principal** | DEX |
| **Armas** | Pistola (50), Rifle (75), SMG (40) |
| **Daño Base (Pistola, DEX 15)** | 50 × 2.0 = 100 |

| Habilidad | CD (s) | Duración | Costo Stamina | Daño/Efecto |
|-----------|--------|----------|--------------|-------------|
| 1 — Disparo Preciso | 4s (reset en kill) | Instantáneo | 5 | Daño +30% = 130 |
| 2 — Ráfaga | 10s | 1.5s (5 disparos) | 15 | Precisión -40%, daño total 250 |
| 3 — Recarga Rápida | 20s | Instantáneo | 10 | Recarga instantánea |
| 4 — Tiro en la Cabeza | 30s | Instantáneo | 20 | Crítico garantizado, +200% daño = 300 |
| 5 — Fuego Supresivo | 25s | 6s | 15 | Enemigos en 15m: -30% precisión |

**Skill Tree:**
- **Rama A — Francotirador:** +15% daño a >20m
- **Rama B — Pistolero:** +25% daño con pistolas y SMGs
- **Rama C — Munición Especial:** 10% chance de no consumir munición

---

### Experto en Explosivos (DPS Rango Área)

| Estadística | Valor |
|------------|-------|
| **HP Base (Nv 30, CON 15)** | 540 |
| **Stamina Base (CON 15)** | 100 |
| **Stat Principal** | INT |
| **Armas** | Granada, Mina, RPG, Molotov |
| **Daño Base (Granada, INT 15)** | 150 × 2.0 = 300 en área 5m |

| Habilidad | CD (s) | Duración | Costo Stamina | Daño/Efecto |
|-----------|--------|----------|--------------|-------------|
| 1 — Granada (3 cargas) | 15s por carga | Instantáneo | 15 | Área 5m, daño 300 |
| 2 — Mina | 20s | 30s en suelo | 15 | Proximidad, daño 350 |
| 3 — RPG | 45s | Instantáneo | 30 | Área 3m, daño 600 |
| 4 — Cóctel Molotov | 20s | 8s de fuego | 15 | Área 5m, 50 DPS |
| 5 — Bomba de Humo | 30s | 12s | 10 | Área 10m, visibilidad 0% enemigos |

**Skill Tree:**
- **Rama A — Demoledor:** +25% radio de explosiones
- **Rama B — Trampero:** +1 mina activa simultánea (total 2)
- **Rama C — Piromaníaco:** +30% daño de fuego, Molotov +4s

---

### Hacker (DPS Rango / Control)

| Estadística | Valor |
|------------|-------|
| **HP Base (Nv 30, CON 15)** | 440 |
| **Stamina Base (CON 15)** | 100 |
| **Stat Principal** | INT |
| **Armas** | Drone, Virus, Laptop |
| **Daño Base (Drone, INT 15)** | 30 DPS automático |

| Habilidad | CD (s) | Duración | Costo Stamina | Daño/Efecto |
|-----------|--------|----------|--------------|-------------|
| 1 — Drone de Ataque | 25s | 15s | 15 | Drone dispara 30 DPS automático |
| 2 — Hackeo de Arma | 15s | 3s | 10 | Enemigo no dispara |
| 3 — Virus | 12s | Instantáneo | 15 | Área 10m, daño 150, +50% a mecánicos |
| 4 — Sobrecarga | 20s | 3s carga | 20 | Vehículo/torreta explota, daño 400 |
| 5 — DDoS | 60s | 6s | 30 | Enemigos en 20m: acciones retrasadas 1s |

**Skill Tree:**
- **Rama A — Ingeniero:** +15% duración drones, puede tener 2 drones
- **Rama B — Black Hat:** +20% duración de hacks y CC
- **Rama C — Overclocker:** -15% CD en todas habilidades

---

## 6. CLASES SUPPORT

---

### Capo (Support / Líder)

| Estadística | Valor |
|------------|-------|
| **HP Base (Nv 30, CON 15)** | 590 |
| **Stamina Base (CON 15)** | 100 |
| **Stat Principal** | CHA |
| **Armas** | Pistola (daño base 50), Bastón de mando |
| **Daño Base (Pistola, CHA 15)** | 50 (sin modificador de daño directo) |

| Habilidad | CD (s) | Duración | Costo Stamina | Efecto |
|-----------|--------|----------|--------------|--------|
| 1 — Motivación | 30s | 15s | 15 | Aliados 20m: +15% daño |
| 2 — Plan de Batalla | 25s | 15s | 15 | Punto marcado: aliados cerca +20% defensa |
| 3 — Repliegue | 20s | 5s | 10 | Aliados 30m: +50% velocidad |
| 4 — Inspector | 20s | 10s | 15 | Revela debilidades: enemigo recibe +20% daño |
| 5 — Última Orden | 180s | 4s | 40 | Si mueres: aliados 30m invulnerables 4s |

**Skill Tree:**
- **Rama A — Estratega:** +25% duración buffs
- **Rama B — Carismático:** Buffs afectan +3 aliados
- **Rama C — Mártir:** Última Orden +2s, revive aliados caídos

---

### Informante (Support / Utilidad)

| Estadística | Valor |
|------------|-------|
| **HP Base (Nv 30, CON 15)** | 440 |
| **Stamina Base (CON 15)** | 100 |
| **Stat Principal** | WIS |
| **Armas** | Cámara, Walkie-talkie |
| **Daño Base** | No tiene daño directo |

| Habilidad | CD (s) | Duración | Costo Stamina | Efecto |
|-----------|--------|----------|--------------|--------|
| 1 — Revelar | 15s | Instantáneo | 10 | Muestra enemigos ocultos/sigilosos en 30m |
| 2 — Rastrear | 20s | 30s | 10 | Marca enemigo: visible en mapa para crew |
| 3 — Chisme | 30s | Instantáneo | 20 | Intercambia ubicación de 2 aliados |
| 4 — Exponer | 18s | 10s | 15 | Objetivo: -30% defensa |
| 5 — Filtración | 60s | Instantáneo | 25 | Ves inventario enemigo, crew lo ve |

**Skill Tree:**
- **Rama A — Espía:** +20% rango de detección
- **Rama B — Soplón:** Chisme con -50% CD
- **Rama C — Analista:** Exponer también reduce daño del objetivo -15%

---

## 7. CLASES CONTROL

---

### Químico (Control / Área)

| Estadística | Valor |
|------------|-------|
| **HP Base (Nv 30, CON 15)** | 540 |
| **Stamina Base (CON 15)** | 100 |
| **Stat Principal** | INT |
| **Armas** | Lanzallamas, Jeringas, Bomba química |
| **Daño Base (Gas Tóxico, INT 15)** | 40 DPS |

| Habilidad | CD (s) | Duración | Costo Stamina | Daño/Efecto |
|-----------|--------|----------|--------------|-------------|
| 1 — Gas Tóxico | 20s | 10s | 15 | Nube 8m: 40 DPS, -20% velocidad |
| 2 — Ácido | 12s | Instantáneo | 12 | Línea: daño 100, -10% defensa (acumulable ×3) |
| 3 — Bomba de Humo | 25s | 4s ceguera | 10 | Nube 10m, ciega enemigos |
| 4 — Veneno | 15s | DoT 8s | 15 | 5% HP/s a 1 enemigo |
| 5 — Plaga | 120s | DoT 8s | 30 | Todos los enemigos en 15m reciben Veneno |

**Skill Tree:**
- **Rama A — Toxicólogo:** +30% duración venenos y gases
- **Rama B — Corrosivo:** Ácido reduce 50% más armadura
- **Rama C — Epidemia:** Plaga salta al morir el objetivo

---

### Policía de Barrio (Control / Tanque) — Solo Policía

| Estadística | Valor |
|------------|-------|
| **HP Base (Nv 30, CON 15)** | 640 |
| **Stamina Base (CON 15)** | 100 |
| **Stat Principal** | STR / WIS |
| **Armas** | Taser, Esposas, Porra |
| **Daño Base (Taser, STR 15)** | 50 + DoT eléctrico |

| Habilidad | CD (s) | Duración | Costo Stamina | Daño/Efecto |
|-----------|--------|----------|--------------|-------------|
| 1 — Alto Ahí | 15s | Stun 4s (8s con wanted) | 10 | Stun 1 enemigo |
| 2 — Esposas | 20s | 6s | 15 | Inmoviliza: no ataca ni se mueve |
| 3 — Taser | 12s | Stun 3s + DoT 5s | 12 | Daño 50 + 10 DPS eléctrico |
| 4 — Zona Acordonada | 30s | 8s | 20 | Barrera 12m: nadie entra/sale |
| 5 — Refuerzos | 90s | 20s | 25 | Invoca 2 NPCs policía nivel 30 |

**Skill Tree:**
- **Rama A — Autoridad:** +2s duración CC
- **Rama B — Patrullero:** Refuerzos son nivel 40
- **Rama C — Intimidación:** Enemigos con wanted reciben +25% daño tuyo

---

## 8. CLASES ÉLITE (Nivel 50+, Reputación Reverenciado)

---

### Oyabun (Elite Yakuza)

| Estadística | Valor |
|------------|-------|
| **HP Base (Nv 50, CON 15)** | 890 |
| **Stamina Base (CON 15)** | 100 |
| **Stat Principal** | CHA / STR |
| **Rol** | Tank / Líder |

| Habilidad Signature | CD (s) | Duración | Costo Stamina | Efecto |
|-------------------|--------|----------|--------------|--------|
| **Mirada del Patriarca** | 90s | Congela 3s | 40 | Enemigos en 20m congelados (no pueden moverse ni atacar) |

**HP Bonus:** +25% (total ~1,113 HP a Nv 50)

---

### El Patrón (Elite Cártel)

| Estadística | Valor |
|------------|-------|
| **HP Base (Nv 50, CON 15)** | 890 |
| **Stamina Base (CON 15)** | 100 |
| **Stat Principal** | CHA |
| **Rol** | Tank / Líder |

| Habilidad Signature | CD (s) | Duración | Costo Stamina | Efecto |
|-------------------|--------|----------|--------------|--------|
| **Plata o Plomo** | 120s | Instantáneo | 30 | Soborna NPC enemigo (aliado 30s) o ejecuta jugador <20% HP |

---

### Don (Elite Mafia)

| Estadística | Valor |
|------------|-------|
| **HP Base (Nv 50, CON 15)** | 890 |
| **Stamina Base (CON 15)** | 100 |
| **Stat Principal** | CHA |
| **Rol** | Líder / Support |

| Habilidad Signature | CD (s) | Duración | Costo Stamina | Efecto |
|-------------------|--------|----------|--------------|--------|
| **Padrino** | 180s | 15s | 40 | Aliados en 30m: +25% defensa, inmunes a ejecución |

---

### Comisario (Elite Policía)

| Estadística | Valor |
|------------|-------|
| **HP Base (Nv 50, CON 15)** | 890 |
| **Stamina Base (CON 15)** | 100 |
| **Stat Principal** | CHA |
| **Rol** | Support / Líder |

| Habilidad Signature | CD (s) | Duración | Costo Stamina | Efecto |
|-------------------|--------|----------|--------------|--------|
| **Mordida** | 120s | NPC aliado 60s | 25 | Convierte NPC en aliado. En PVP: reduce wanted 2⭐ a aliados |

---

### OG — Original Gangster (Elite Cholos)

| Estadística | Valor |
|------------|-------|
| **HP Base (Nv 50, CON 15)** | 890 |
| **Stamina Base (CON 15)** | 100 |
| **Stat Principal** | CHA / DEX |
| **Rol** | Líder / DPS |

| Habilidad Signature | CD (s) | Duración | Costo Stamina | Efecto |
|-------------------|--------|----------|--------------|--------|
| **Leyenda del Barrio** | 180s | 30s | 40 | Invoca 2 NPCs nivel 30 (los "viejos de la cuadra") |

---

### Mercenario (Elite Sin-Legaja)

| Estadística | Valor |
|------------|-------|
| **HP Base (Nv 50, CON 15)** | 890 |
| **Stamina Base (CON 15)** | 100 |
| **Stat Principal** | Depende de la habilidad copiada |
| **Rol** | DPS Mixto |

| Habilidad Signature | CD (s) | Duración | Costo Stamina | Efecto |
|-------------------|--------|----------|--------------|--------|
| **Jack of All Trades** | Variable (según habilidad copiada) | Variable | Variable | Usa 1 habilidad de cualquier clase con -30% eficiencia |

---

## 9. RESUMEN DE HP Y STAMINA POR CLASE (Nv 30, CON 15)

| Clase | HP | Stamina | Stat Principal | Rol |
|------|----|---------|---------------|-----|
| Matón | 590 | 100 | STR | Tank |
| SWAT | 540 | 100 | STR | Tank |
| Doctor de Barrio | 490 | 100 | INT | Healer |
| Curandero | 490 | 100 | WIS | Healer |
| Boxeador | 590 | 100 | STR | DPS Melee |
| Sicario | 490 | 100 | DEX | DPS Melee |
| Vandal | 640 | 100 | STR | DPS Melee |
| Gatillero | 490 | 100 | DEX | DPS Rango |
| Experto en Explosivos | 540 | 100 | INT | DPS Rango |
| Hacker | 440 | 100 | INT | DPS/Control |
| Capo | 590 | 100 | CHA | Support |
| Informante | 440 | 100 | WIS | Support |
| Químico | 540 | 100 | INT | Control |
| Policía de Barrio | 640 | 100 | STR/WIS | Control |

*Nota: La Stamina base es igual para todas las clases (depende solo de CON). Las diferencias están en el COSTO de stamina de cada habilidad y en la eficiencia de uso. La clase Hacker e Informante tienen menos HP por ser roles de retaguardia/soporte puro.*
