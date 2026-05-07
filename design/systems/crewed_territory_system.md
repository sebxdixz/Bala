# BARRIO SIN LEY ONLINE (BSLO)
## design/systems/crewed_territory_system.md — Sistema de Crews y Territorio
**Versión:** 2.0 | **Última Revisión:** Mayo 2026

---

## 1. VISIÓN GENERAL

El sistema de Crews y Territorio es el **endgame social, económico y militar** de BSLO. La ciudad de 120 distritos es el tablero de juego donde las crews compiten por control, recursos y prestigio. Una crew sin territorio es una crew sin honor.

---

## 2. CREACIÓN DE CREW

### Requisitos Fundacionales

| Requisito | Valor |
|-----------|-------|
| **Nivel mínimo del líder** | 20 |
| **Jugadores fundadores** | 5 (incluyendo al líder) |
| **Costo en PB** | $500,000 PB |
| **Facción principal** | Elegir una (determina estética, no mecánicas) |

### Proceso de Fundación
1. Los 5 fundadores se reúnen en el mismo lugar del mapa.
2. El líder selecciona "Fundar Crew" desde el menú de interacción.
3. Se define: **Nombre** (único por servidor), **Tag** (3-5 caracteres), **Facción**, **Diseño de graffiti inicial**.
4. Se descuenta $500,000 PB del bolsillo del líder.
5. Animación: todos pintan el primer tag juntos.

### Límites de Crews por Servidor
| Concepto | Límite |
|----------|--------|
| Máximo de crews activas por servidor | 200 |
| Máximo de miembros por crew | 100 |
| Tiempo mínimo entre disolución y refundación | 7 días |

---

## 3. JERARQUÍA DE CREW

| Rango | Cantidad Máxima | Salario Semanal (PB) | Permisos |
|-------|----------------|---------------------|----------|
| **Líder (Jefe)** | 1 | $40,000 | Todo: declarar guerra, banco, disolver, transferir liderazgo |
| **Subjefe (Consigliere)** | 2 | $25,000 | Invitar/expulsar, iniciar raids, editar tags |
| **Capitán** | 5 | $15,000 | Liderar escuadras, colocar defensas, cobrar salario |
| **Soldado** | Ilimitado | $5,000 | Participar raids, zonas de crew, salario |
| **Recluta** | Ilimitado | $0 | Solo chat de crew, no puede entrar a zonas seguras sin escolta |

### Salario Mínimo Semanal
Los salarios se pagan automáticamente cada **domingo a las 00:00 server-time** desde el banco de crew:
- **Soldado:** $5,000 PB (mínimo)
- **Capitán:** $15,000 PB (mínimo)
- **Subjefe:** $25,000 PB
- **Líder:** $40,000 PB

Si el banco de crew no tiene fondos suficientes para pagar todos los salarios:
1. Se paga primero a los rangos inferiores (Soldados primero).
2. Si no alcanza para todos, se prorratea.
3. Si un miembro no recibe salario por 2 semanas seguidas, puede abandonar la crew sin penalización.

---

## 4. DISTRITOS Y TIPOS DE TERRITORIO

La ciudad tiene **120 distritos** (~300×300m cada uno). Cada distrito tiene un **tipo** que determina su generación de ingresos y beneficios estratégicos.

### Tipos de Distrito

| Tipo | Multiplicador de Ingreso | Descripción | Ejemplos |
|------|-------------------------|-------------|----------|
| **Comercial** | ×2.0 | Zonas de alto tráfico comercial, tiendas, mercados | Plaza del Mercado, Torre del Cisne |
| **Cultural** | ×1.2 | Teatros, templos, zonas turísticas | Teatro de la Ópera, Templo del Viento |
| **Residencial** | ×1.0 | Zonas habitacionales, población estable | Callejón del Padrino, Barrio Protegido |
| **Industrial** | ×0.8 | Bodegas, puertos, fábricas | Muelle Olvidado, Bodegas del Puerto |

### Beneficios por Controlar un Distrito

| Beneficio | Valor |
|-----------|-------|
| **Ingreso pasivo por hora** | 100 + (tipo_distrito × 50) + (nivel_crew × 10) PB/h |
| **Zona de spawn para miembros** | Res sickness reducido a 2 min |
| **NPCs defensores** | 5 + (nivel_crew / 2) NPCs patrullando |
| **Graffiti de crew visible** | Tag gigante en paredes principales |
| **Impuesto a negocios** | 5% de ingresos pasivos de negocios en el distrito |

### Cálculo de Ingreso Pasivo por Hora

| Tipo de Distrito | Fórmula | Crew Nv 1 | Crew Nv 5 | Crew Nv 10 | Crew Nv 20 |
|-----------------|---------|-----------|-----------|------------|------------|
| **Comercial (×2.0)** | 100 + (2 × 50) + (crew_nv × 10) = 200 + crew_nv×10 | 210 PB/h | 250 PB/h | 300 PB/h | 400 PB/h |
| **Cultural (×1.2)** | 100 + (1.2 × 50) + (crew_nv × 10) = 160 + crew_nv×10 | 170 PB/h | 210 PB/h | 260 PB/h | 360 PB/h |
| **Residencial (×1.0)** | 100 + (1 × 50) + (crew_nv × 10) = 150 + crew_nv×10 | 160 PB/h | 200 PB/h | 250 PB/h | 350 PB/h |
| **Industrial (×0.8)** | 100 + (0.8 × 50) + (crew_nv × 10) = 140 + crew_nv×10 | 150 PB/h | 190 PB/h | 240 PB/h | 340 PB/h |

### Ejemplo: Crew nivel 5 con 3 distritos (1 Comercial, 2 Residencial)
- Comercial: 250 PB/h
- Residencial: 200 PB/h × 2 = 400 PB/h
- **Total: 650 PB/hora (15,600 PB/día, ~109,200 PB/semana)**

---

## 5. EXPANSIÓN TERRITORIAL

### Límites de Control
| Concepto | Límite |
|----------|--------|
| Distritos iniciales (al fundar crew) | 0 |
| Máximo de distritos por crew | Sin límite teórico |
| Máximo práctico (recomendado) | 10-15 distritos (defender más es inviable) |
| Distritos por facción inicial | 4 cada una (24 totales pre-asignados) |
| Distritos neutrales disponibles | ~96 |

---

## 6. GUERRA DE TERRITORIO (RAIDS)

### Declaración de Guerra

| Concepto | Valor |
|----------|-------|
| **Costo de declaración** | $50,000 PB + (nivel_crew × $10,000) |
| **Costo ejemplo (crew nv 5)** | $50,000 + $50,000 = $100,000 PB |
| **Costo ejemplo (crew nv 15)** | $50,000 + $150,000 = $200,000 PB |
| **Tiempo de preparación** | 24 horas reales |
| **Notificación** | Server-wide: "La crew [X] ha declarado sus intenciones sobre [Distrito Y]" |
| **Notificación al defensor** | Inmediata, con opción de contra-declaración |

### La Batalla

| Concepto | Valor |
|----------|-------|
| **Duración** | 30 minutos |
| **Formato** | Instancia PVP/PVE en el distrito |
| **Objetivos capturables** | 3 puntos: Puesto de Radio, Bodega, Subestación Eléctrica |
| **Condición de victoria** | Capturar 2 de 3 objetivos al terminar el tiempo |
| **Tamaño máximo por bando** | 20 jugadores |
| **Si el distrito es neutral** | Defensores son NPCs de la facción local (10-15) |

### Tiempos de Captura de Objetivos

| Objetivo | Tiempo de Captura | Bonificación |
|----------|-------------------|-------------|
| Puesto de Radio | 60s | Revela posición de enemigos en el distrito |
| Bodega | 90s | -50% tiempo de respawn para el bando |
| Subestación Eléctrica | 75s | Apaga luces (+30% sigilo para el bando) |

### Consecuencias

| Resultado | Efecto |
|-----------|--------|
| **Victoria atacante** | Crew gana el distrito. El tag enemigo se tacha, se pinta el propio. |
| **Victoria defensora** | Crew mantiene el distrito. Atacante pierde el costo de declaración. |
| **Empate (1-1-1 capturas)** | Defensor mantiene. Atacante recupera 50% del costo. |
| **Derrota total (último distrito)** | Crew defensora entra en período de gracia de 48h. |

---

## 7. PERÍODO DE GRACIA POST-DISOLUCIÓN

### Causas de Disolución
| Causa | Descripción |
|-------|-------------|
| **Pérdida del último distrito** | Si una crew pierde su único distrito y no reconquista en 48h |
| **Disolución voluntaria** | El líder puede disolver la crew en cualquier momento |
| **Inactividad total** | Todos los miembros offline por 30 días consecutivos |

### Período de Gracia (48 horas)

Cuando una crew pierde su último distrito:
1. **Período de gracia:** 48 horas reales para reconquistar CUALQUIER distrito.
2. Durante la gracia, la crew NO genera ingresos pasivos.
3. Los miembros pueden seguir usando chat de crew y zonas de spawn (pero no hay distritos).
4. Los tags de graffiti se vuelven **grises y agrietados** (estado "abandonado").
5. Si reconquistan un distrito dentro de las 48h, vuelven a la normalidad.

### Qué Pasa al Disolverse Definitivamente

| Elemento | Destino |
|----------|---------|
| **Banco de crew (PB)** | Se divide equitativamente entre miembros activos en las últimas 2 semanas |
| **Almacén de crew (ítems)** | Se divide entre miembros activos (sistema de loot justo) |
| **Tags de graffiti** | Degradan a "abandonados" por 7 días, luego desaparecen |
| **Nombre de crew** | Queda registrado en la Torre del Reloj (archivo muerto) |
| **Miembros** | Pasan a "sin crew". Conservan reputación individual. |
| **Propiedades de crew** | Se subastan automáticamente al mejor postor |

---

## 8. IMPUESTOS Y ECONOMÍA DE CREW

### Impuesto a Negocios (5%)

Los negocios de jugadores en distritos controlados pagan:
- **5% de sus ingresos pasivos** al banco de la crew controladora.
- El pago es automático, no evitable.
- Si un jugador no quiere pagar, puede cerrar su negocio o mudarse a otro distrito.

### Ejemplo de Ingresos Semanales de una Crew

| Fuente | Cálculo | Total Semanal |
|--------|---------|---------------|
| 3 distritos (crew nv 5) | 650 PB/h × 168h | 109,200 PB |
| 5% impuestos (promedio 3 negocios × 100 PB/h) | 15 PB/h × 168h | 2,520 PB |
| **Total ingresos semanales** | | **111,720 PB** |
| **Egresos (salarios mínimos, crew 20 miembros)** | 5×$5K + 2×$25K + $40K = $115K | -$115,000 PB |
| **Balance semanal** | | **-$3,280 PB (déficit)** |

*Nota: El déficit se cubre con ingresos de raids, extorsión y eventos. Una crew saludable necesita al menos 4-5 distritos o más miembros pagando impuestos para ser sostenible.*

---

## 9. DINERO SUCIO (SISTEMA EXCLUSIVO DE CREW)

### Generación
| Fuente | Cantidad | Frecuencia |
|--------|----------|------------|
| Control de distritos (bonus) | +10% sobre ingreso pasivo como Dinero Sucio | Por hora |
| Extorsión a negocios vecinos | 500 - 5,000 PB | Por negociación |
| Raids exitosas (botín) | 10,000 - 50,000 PB | Por raid |
| Eventos de crew | 1,000 - 10,000 PB | Por evento |

### Uso
| Gasto | Costo | Efecto |
|-------|-------|--------|
| Torre de vigilancia | $50,000 DS | +2 NPCs defensores en distrito |
| Cámaras de seguridad | $25,000 DS | Revela enemigos sigilosos en el distrito |
| Soborno masivo | $100,000 DS | Reduce wanted de TODA la crew en 2⭐ |
| Fiesta de crew | $10,000 DS | Buff +10% XP para miembros por 2h |

### Regla de Oro
**El Dinero Sucio NO se puede convertir a PB para individuos.** Es un recurso estratégico de la crew, no una forma de enriquecimiento personal. Esto evita que las crews sean "fábricas de oro".

---

## 10. DIPLOMACIA ENTRE CREWS

| Relación | Cómo se establece | Efectos |
|----------|------------------|---------|
| **Aliado** | Acuerdo entre líderes | No PVP entre crews. Chat de alianza. Defensa mutua en raids. |
| **Neutral** | Default | PVP según reglas de zona. |
| **Enemigo (Guerra declarada)** | Declaración de guerra (costo $25,000 PB) | PVP en cualquier zona. Bonus +20% XP por matar miembros enemigos. |

### Límites Diplomáticos
- Máximo 3 alianzas simultáneas por crew.
- Las guerras solo terminan por: tratado de paz (ambos líderes aceptan) o disolución de una crew.
- Una crew no puede declarar guerra a más de 2 crews simultáneamente.

---

## 11. SISTEMA DE GRAFFITI

### Tags Visibles
- Cada distrito controlado muestra el **tag de la crew** en sus paredes principales.
- Visible para TODOS los jugadores en el distrito.
- El tag cambia de color según la facción de la crew.

### Mini-juego de Desprestigio
| Acción | Tiempo | Efecto en el tag | Costo |
|--------|--------|------------------|-------|
| **Tachar tag enemigo** | 10s (mini-juego de spray) | -10% ingresos del distrito por 1h | 1 Bote de spray (ítem) |
| **Restaurar tag propio** | 5s | Cancela el desprestigio | 0 |

---

## 12. TABLÓN DE CREWS (RANKINGS SERVER-WIDE)

Visible en la **Torre del Reloj** y menú principal:

| Ranking | Criterio |
|---------|----------|
| Top 10 — Más Territorio | Por número de distritos controlados |
| Top 10 — Más Ricos | Por PB en banco de crew |
| Top 10 — Más Letales | Por kills PVP de la crew |
| Más Buscada | Mayor wanted colectivo |
| Más Temida | Mayor ratio de kills/muertes en guerras |
