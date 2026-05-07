# BARRIO SIN LEY ONLINE (BSLO)
## design/systems/wanted_level.md — Sistema de Nivel de Búsqueda (Wanted)
**Versión:** 2.0 | **Última Revisión:** Mayo 2026

---

## 1. FILOSOFÍA DEL SISTEMA WANTED

El sistema Wanted de BSLO está inspirado en GTA pero adaptado a un MMO. Cuando un jugador acumula estrellas de búsqueda, **todos los jugadores en la zona se ven afectados**. El wanted no es solo una penalización — es una **mecánica de generación de contenido** que convierte al criminal en un objetivo para todo el servidor.

---

## 2. TABLA DE NIVELES WANTED (1-5⭐)

| Nivel | Nombre | Efectos Inmediatos | Efectos de Área | NPCs que Spawnean |
|-------|--------|-------------------|-----------------|-------------------|
| **⭐** | Mirada Sospechosa | NPCs policiales te siguen con la vista. No pueden atacarte aún. | Ninguno | — |
| **⭐⭐** | Patrullaje Agresivo | Policías NPCs te piden documentos. Opciones: mostrar papeles (si tienes), sobornar ($1,000-5,000 PB), huir, atacar. | Ninguno | 2-3 policías NPC nivel 20 patrullando |
| **⭐⭐⭐** | Operativo de Barrio | SWAT spawn. Todos los jugadores en 200m reciben debuff "Zona Caliente". | **Debuff Zona Caliente:** -20% ventas en tiendas, -10% calidad de crafting | 4-6 SWAT NPC nivel 35 |
| **⭐⭐⭐⭐** | Estado de Sitio | Helicópteros patrullan. Barricadas en calles. Jugadores policía pueden unirse a la cacería. | **Toque de Queda:** Tiendas cierran, NPCs se esconden. +50% XP para criminales. | 2 helicópteros, 8-10 SWAT, jugadores policía invitados |
| **⭐⭐⭐⭐⭐** | Mano Dura Total | Tanque policial aparece. Rompe paredes. Pérdida total de inventario no-equipado al morir. | **Ley Marcial:** Todos los NPCs comerciales cierran. Criminales ganan +50% XP por sobrevivir. | 1 tanque (HP: 10,000), 15+ SWAT, 3 helicópteros |

---

## 3. CÓMO SUBE EL WANTED

### Puntos de Wanted por Acción

| Acción | Puntos Wanted | ⭐ Resultante (acumulativo) |
|--------|--------------|---------------------------|
| Matar civil (NPC) | +25 pts | 1⭐ a 25 pts |
| Matar jugador en zona NO-PVP | +20 pts | 2⭐ a 60 pts |
| Matar jugador en zona PVP | +5 pts | — |
| Robar vehículo frente a testigos | +15 pts | 3⭐ a 120 pts |
| Ser detectado con drogas ilegales | +30 pts | 4⭐ a 200 pts |
| Atacar a policía NPC | +40 pts | 5⭐ a 300 pts |
| Atacar a policía jugador | +50 pts | — |
| Ser detectado con armas sin licencia (en zona policial) | +10 pts | — |
| Robar en tienda (pickpocket fallido) | +15 pts | — |
| Tachar graffiti de crew (si la crew tiene alianza con policía) | +10 pts | — |

### Umbrales de Wanted por Estrella

| Estrella | Puntos Acumulados Necesarios | Tiempo para Subir |
|----------|------------------------------|-------------------|
| ⭐ | 0-25 pts | Instantáneo al cometer delito |
| ⭐⭐ | 26-60 pts | +15s |
| ⭐⭐⭐ | 61-120 pts | +30s |
| ⭐⭐⭐⭐ | 121-200 pts | +45s |
| ⭐⭐⭐⭐⭐ | 201-300+ pts | +60s |

### Factores que Aceleran la Subida de Wanted

| Factor | Multiplicador de Puntos |
|--------|------------------------|
| Reincidencia (mismo delito en <5 min) | ×1.5 |
| Testigos múltiples (>3 NPCs viendo) | ×1.25 |
| En zona policial (Distrito Sur) | ×1.5 |
| En "La Hora del Diablo" (2:00-4:00 AM) | ×0.5 (mitad de puntos) |
| Durante evento "Marcha de los Insultados" | ×2.0 |
| Ser miembro de facción Cholo (en territorio Cholo) | ×0.7 |

---

## 4. CÓMO BAJA EL WANTED

### Métodos de Reducción

| Método | Estrellas Reducidas | Tiempo / Costo | Cooldown |
|--------|--------------------|----------------|----------|
| **Safe House** | -1⭐ cada 5 minutos reales | 5 min por ⭐ | Ilimitado (mientras estés en safe house) |
| **Soborno (NPC policía)** | -1⭐ por soborno | $2,000 × ⭐ actual | Ilimitado (mientras encuentres policías) |
| **Soborno (Jugador policía)** | -1⭐ por soborno | $3,000 × ⭐ actual (mínimo) | El policía decide |
| **Cambio de look (Peluquería)** | -1⭐ instantáneo | $5,000 PB | 1 hora real |
| **Cambio de ropa (Tienda)** | -1⭐ instantáneo | $2,000 PB | 30 minutos reales |
| **Habilidad "Lavado de Datos" (Consigliere)** | -1⭐ a -3⭐ | Según nivel de habilidad | 10 minutos CD |
| **Habilidad "Mordida" (Comisario)** | -2⭐ a aliados | 0 (habilidad de clase) | 2 minutos CD |
| **Muerte** | Resetea a 0⭐ | Muerte normal | — |
| **Escondite (fuera de safe house)** | -1⭐ cada 10 minutos | 10 min por ⭐ | Solo funciona si no te ven |

### Tabla de Tiempos para Bajar de 5⭐ a 0⭐

| Método | Tiempo Total | Costo Total |
|--------|-------------|-------------|
| Safe House | 25 minutos | $0 |
| Soborno a NPCs | 5-10 minutos | $10,000 - $30,000 |
| Soborno a jugador | 5-10 minutos | $15,000 - $50,000 |
| Cambio de look | Instantáneo + 1h CD | $10,000 (múltiples cambios) |
| Escondite | 50 minutos | $0 |
| Muerte (respawn) | Instantáneo | -15% XP + reparación |

---

## 5. EFECTOS DETALLADOS POR ESTRELLA

### ⭐ — Mirada Sospechosa

| Aspecto | Detalle |
|---------|--------|
| **Duración típica** | 2-5 minutos |
| **NPCs** | Te miran fijamente, hacen comentarios |
| **Comercio** | Normal |
| **PVP** | Normal |
| **Notificación** | Sutil: "Te sientes observado..." |

### ⭐⭐ — Patrullaje Agresivo

| Aspecto | Detalle |
|---------|--------|
| **Duración típica** | 5-15 minutos |
| **NPCs** | Policías se acercan a pedir documentos |
| **Chance de soborno** | 70% (si tienes CHA 15+) |
| **Costo de soborno** | $1,000 - $5,000 PB |
| **Si no pagas** | Te arrestan (wanted baja a 0 pero te llevan a comisaría) |
| **Si peleas** | Sube a 3⭐ automáticamente |

### ⭐⭐⭐ — Operativo de Barrio (SWAT)

| Aspecto | Detalle |
|---------|--------|
| **Duración típica** | 15-30 minutos |
| **Debuff Zona Caliente** | -20% ventas en tiendas, -10% calidad crafting |
| **Radio del debuff** | 200m alrededor del jugador wanted |
| **Afecta a** | TODOS los jugadores en el radio (incluso los que no tienen wanted) |
| **SWAT** | 4-6 unidades, nivel 35, HP 500 c/u |
| **Recompensa por matar SWAT** | 200 XP + $500 PB cada uno |

### ⭐⭐⭐⭐ — Estado de Sitio

| Aspecto | Detalle |
|---------|--------|
| **Duración típica** | 30-60 minutos |
| **Helicópteros** | 2 unidades, iluminan zona, reportan posición cada 30s |
| **HP del helicóptero** | 2,000 HP |
| **Barricadas** | Calles bloqueadas, redirigen tráfico |
| **Jugadores Policía** | Reciben notificación y pueden unirse |
| **Recompensa para policías** | $5,000 PB + 500 XP por arrestar al wanted |
| **Bonus para criminales** | +50% XP por matar policías |

### ⭐⭐⭐⭐⭐ — Mano Dura Total

| Aspecto | Detalle |
|---------|--------|
| **Duración típica** | Hasta que mueras o escapes |
| **Tanque** | 1 unidad, HP 10,000, cañón 200 DMG, rompe paredes |
| **Velocidad del tanque** | Lenta (10 km/h) pero imparable |
| **Pérdida al morir** | TODO el inventario no-equipado + -15% XP normal |
| **Bonus por sobrevivir** | +50% XP mientras dure el 5⭐ |
| **Anuncio server-wide** | "¡ATENCIÓN! [Nombre] ha sido declarado Enemigo Público N°1. Cazar o ser cazado." |
| **Recompensa por matar** | $50,000 PB + 5,000 XP |

---

## 6. WANTED Y FACCIÓN POLICÍA

Los jugadores de la facción **Policía** tienen un rol especial en el sistema wanted:

| Acción | Efecto |
|--------|--------|
| **Unirse a cacería (wanted 3⭐+)** | Reciben notificación automática. Obtienen +20% XP y $5,000 por arrestar. |
| **Soborno** | Pueden aceptar o rechazar sobornos. Aceptar da -30 reputación Policía. Rechazar da +10. |
| **Arrestar (habilidad Esposas)** | Da +40 reputación Policía (más que matar). El arrestado va a la comisaría (respawn forzado). |
| **Reducir wanted de aliados** | Habilidad "Mordida" (Comisario). |
| **Patrullar** | Ganan reputación pasiva +2/hora si patrullan zonas con jugadores wanted. |

---

## 7. WANTED Y EL RESTO DEL JUEGO

### Impacto en Karma y Reputación
| Situación | Efecto |
|-----------|--------|
| Tener 3⭐+ wanted al morir | -100 reputación con Policía adicional |
| Sobrevivir a 5⭐ wanted | +50 reputación con Cártel, +100 con Cholos |
| Arrestar a wanted 5⭐ | +200 reputación con Policía |
| Matar a un jugador con 5⭐ | +50 reputación con la facción opuesta a la del muerto |

### Interacciones Especiales
| Evento / Situación | Efecto en Wanted |
|-------------------|-----------------|
| "La Purga" (evento mensual) | Sin wanted durante 2h. Todo vale. |
| "Marcha de los Insultados" | Facción afectada recibe 2⭐ automático por 1h |
| "La Hora del Diablo" (2-4 AM) | Los puntos de wanted se acumulan al 50% |
| Safe Zones | No puedes recibir wanted nuevo dentro. Si entras con wanted, te expulsan si tienes 4⭐+. |
| Metro (vagones) | Si entras al metro con wanted, los NPCs te ignoran. Pero al salir, el wanted sigue igual. |

---

## 8. TABLA RESUMEN

| ⭐ | Nombre | Puntos | Efecto Principal | Cómo Bajar | Duración Típica |
|---|--------|--------|-----------------|-----------|-----------------|
| ⭐ | Mirada Sospechosa | 0-25 | NPCs te miran | Esperar 2 min | 2-5 min |
| ⭐⭐ | Patrullaje Agresivo | 26-60 | Policías piden documentos | Soborno $1-5K o cambio look | 5-15 min |
| ⭐⭐⭐ | Operativo de Barrio | 61-120 | SWAT + debuff zona -20% ventas | Safe house 10-15 min | 15-30 min |
| ⭐⭐⭐⭐ | Estado de Sitio | 121-200 | Helicópteros + jugadores policía | Safe house 15-20 min + sobornos | 30-60 min |
| ⭐⭐⭐⭐⭐ | Mano Dura Total | 201-300+ | Tanque + pérdida total inventario | Safe house 25 min o muerte | Hasta morir/escapar |
