# Guía detallada — Entrega 1 (SAD v1, 15%)

Guía de trabajo para cerrar los 6 puntos del checklist de Entrega 1
(`Cronograma.md` § "Checklist consolidado — Entrega 1", fecha tentativa
**9 oct 2026**, aún no confirmada por el profesor). No es un entregable del
curso — es la hoja de ruta interna del equipo; actualizarla conforme se
avanza (marcar los `[ ]` como `[x]`).

> **Por qué existe este documento.** El usuario pidió explícitamente que la
> entrega tenga: (1) **pruebas** que demuestren por qué se tomó cada
> decisión, (2) **al menos dos alternativas** comparadas en toda selección
> de tecnología, y (3) que **cada decisión corresponda a un atributo de
> calidad** concreto (no una preferencia sin justificar). Estas tres reglas
> son transversales a los 6 puntos de abajo — no son un ítem aparte.

---

## Regla de oro: la plantilla de decisión (úsala siempre)

Cada vez que el equipo elija una tecnología, patrón o táctica — no solo en
los ADR "grandes", también en cada análisis de atributo de calidad (clases
6–14) — la decisión se redacta con esta plantilla, la misma que ya usa
`BitacoraArquitectonica.md` pero con un campo nuevo obligatorio
(**Evidencia**):

```
**Atributo de calidad que motiva la decisión:** <uno de los priorizados en
ArchitecturalProposal.tex — Disponibilidad, Seguridad, Rendimiento, etc.>

**Alternativas consideradas (mínimo 2):**
1. <Opción A> — ventajas / desventajas
2. <Opción B> — ventajas / desventajas
3. <Opción C, si aplica>

**Decisión:** <cuál se eligió y en una frase, por qué gana sobre las otras>

**Evidencia / pruebas:** <qué demuestra que la decisión funciona: resultado
de un PoC (con número/gráfica), benchmark, artículo/documentación técnica
citada, o al menos un experimento reproducible — nunca solo "porque es lo
más usado" sin respaldo>

**Riesgos / desventajas de lo elegido:** <qué se sacrifica>
```

**Por qué el campo "Evidencia" importa tanto:** en la sustentación, "elegimos
Redis porque es rápido" no resiste una pregunta de seguimiento. "Elegimos
Redis porque en el PoC-02 (`Work/PoCs/locking-redis/`) simulamos 50 compras
concurrentes de la misma entrada en reventa y Redis con `SETNX` evitó el
100% de las ventas duplicadas, mientras que sin bloqueo se duplicaron 6 de
50" sí resiste. Ese es el nivel que se busca.

**Auditoría pendiente de lo ya decidido:** los ADR-01 a ADR-04 en
`DescripcionArquitecturaSoftware.tex` y las decisiones fundacionales de la
Bitácora (2026-08-18) ya tienen alternativas consideradas, pero **no tienen
el campo de Evidencia** — fueron justificadas por razonamiento, no por una
prueba. Antes de entregar, revisar si al menos las decisiones más
"preguntables" (por qué Redis y no Memcached/bloqueo optimista en BD; por
qué colas de mensajes y no llamadas síncronas con reintentos; por qué
microservicios y no monolito modular) tienen — o pueden conseguir rápido —
un PoC o benchmark que las respalde. Ver punto 4 (PoCs) más abajo: es
exactamente el mecanismo para generar esta evidencia.

---

## 1. Especificación de casos de uso y RNF

**Estado:** CU ✅ hecho (32 CU en `Submission/CU_eventos_completo.xlsx`).
RNF ❌ **no existe todavía** — falta crear.

**Qué hay que producir:** una tabla de Requisitos No Funcionales, uno por
atributo de calidad ya priorizado en `ArchitecturalProposal.tex`, con
formato medible (no "el sistema debe ser rápido", sino algo verificable):

| ID | RNF | Atributo de calidad | Métrica / umbral |
|---|---|---|---|
| RNF-01 | Validación de una entrada en la puerta | Rendimiento | ≤ 500 ms por escaneo, p95 |
| RNF-02 | El sistema soporta la apertura de venta de un evento masivo | Rendimiento / Disponibilidad | ≥ 2000 solicitudes/seg sin degradar |
| RNF-03 | Recuperación ante caída de una instancia de validación de QR | Disponibilidad | Failover ≤ 10 s, sin pérdida de transacciones |
| RNF-04 | Autenticación de usuarios | Seguridad | Tokens JWT con expiración ≤ 1 h, HTTPS obligatorio |

(Son ejemplos de arranque — completar con uno por cada QA de la tabla de
prioridades, alta y media como mínimo.) Dónde va: nueva sección "Requisitos
No Funcionales" en `Work/DescripcionArquitecturaSoftware.tex`, justo antes o
después de "Visión general de los requisitos funcionales".

**Dónde aplican las 3 reglas aquí:** cada RNF debe decir explícitamente el
atributo de calidad que representa (columna de la tabla) — no hace falta
alternativas/tecnología en este punto, eso viene en los puntos 3 y 4.

---

## 2. ASR (Árbol de Utilidad)

**Estado:** 🟡 primer borrador ya existe (ASR-01..10 en
`DescripcionArquitecturaSoftware.tex`, 2026-08-25), sin copiar aún a
`Submission/`.

**Qué falta:** que el equipo completo lo revise (hoy lo hizo el asistente a
partir de la tabla de prioridades, no cada integrante). Para cada ASR,
confirmar que:
- El escenario esté en formato completo Fuente/Estímulo/Artefacto/Entorno/
  Respuesta/Medida de respuesta (formato Bass/Kazman de escenario de
  calidad), no solo una frase.
- Tenga su par (Importancia, Dificultad) en escala H/M/L, y que los
  priorizados como (H,H) sean justamente los que después reciben PoC
  (punto 4) — así el árbol deja de ser un documento aislado y se conecta
  con el resto de la entrega.

**No requiere alternativas de tecnología** (el Árbol de Utilidad es sobre
requisitos, no sobre soluciones) — pero cada ASR sí debe decir de qué
atributo de calidad priorizado se deriva (ya lo hace).

---

## 3. Diseño arquitectónico con tácticas de QA (clases 6–14)

**Estado:** 🟡 el hueco más grande. Solo **Disponibilidad** (Clase 6) está
hecho (2026-08-25). Faltan **7 atributos**: Deployability, Performance,
Modifiability, Integrabilidad, Safety, Security, Testability, Usability —
repartidos así (`Cronograma.md`):

| Atributo | Responsable |
|---|---|
| Deployability | I1 |
| Performance, Modifiability | I2 |
| Integrabilidad, Safety, Testability | I3 |
| Security, Usability | I4 |

**Qué debe producir cada responsable, por atributo** (mismo formato que ya
existe para Disponibilidad en la Bitácora del 2026-08-25 — usarlo de
plantilla) — pero ahora con las 3 reglas obligatorias:

1. Identificar 2–4 escenarios reales del proyecto para ese atributo (no
   genéricos — específicos a HEXACORE: ej. para Performance, "la apertura
   de venta de HEXACORE Fest genera 5000 solicitudes concurrentes al
   servicio de Entradas en el primer minuto").
2. Para cada escenario, **elegir al menos 2 tácticas o patrones candidatos**
   del catálogo de la clase correspondiente (`Clases/Notes/`), compararlos
   (ventaja/desventaja para ese escenario puntual), y elegir uno —
   explícitamente marcado con la plantilla de la sección anterior.
3. Adjuntar **evidencia**: si el atributo tiene un PoC asociado (ver punto
   4), citarlo aquí. Si no alcanza a tener PoC propio, al menos una
   comparación técnica citando fuentes (documentación oficial, benchmark
   publicado) — nunca una elección sin respaldo.
4. Documentar en `BitacoraArquitectonica.md` (entrada nueva, una por
   atributo) y reflejar la tabla resultante en
   `Work/ArchitecturalProposal.tex`, igual que se hizo con Disponibilidad.

**Ejemplo concreto para no partir de cero — Deployability (I1):**
- Escenario: "hay que desplegar un hotfix al servicio de validación de QR
  mientras hay ingreso masivo activo a un evento, sin interrumpir
  validaciones en curso."
- Alternativas de patrón: **Rolling Upgrade** (solo N+1 instancias, pero
  puede haber inconsistencia temporal de versiones) vs. **Blue/Green**
  (sin inconsistencia de versiones, pero requiere 2×N instancias — más
  costoso durante un evento en vivo, que es justo cuando más instancias
  activas hay).
- Decisión razonable: Blue/Green para este escenario puntual (evento en
  vivo, prioridad es cero downtime sobre costo), Rolling Upgrade para
  actualizaciones fuera de horario de evento.
- Evidencia: puede ser un PoC pequeño (levantar 2 versiones de un servicio
  de ejemplo detrás de un balanceador y medir el tiempo sin downtime al
  cambiar tráfico) o, si no alcanza el tiempo, documentación citada sobre
  el patrón + la justificación de por qué aplica al escenario.

**Prioriza los atributos priorizados como "Alta"** en
`ArchitecturalProposal.tex` si el tiempo no alcanza para los 7 — es
preferible tener 4-5 bien evidenciados que 7 superficiales.

---

## 4. Pruebas de concepto (PoCs) de los 2–3 desafíos técnicos más complejos

**Estado:** ❌ no existe ningún PoC todavía. Este es el punto que genera la
**evidencia** que piden los puntos 1, 3, 5 y 6 — es el más importante de
priorizar cronológicamente, antes que redactar los análisis de QA, porque
sin PoC no hay pruebas que citar.

**Candidatos** (de `Cronograma.md`, ajustar con el equipo):
1. **Bloqueo de concurrencia en reventa de entradas** (Redis `SETNX`/
   distributed lock) — demuestra Disponibilidad/Consistencia bajo
   concurrencia. Comparar contra **al menos una alternativa**: bloqueo
   optimista en base de datos (version/timestamp) o `SELECT FOR UPDATE`.
   Medir: % de ventas duplicadas con N compradores simulados comprando la
   misma entrada al mismo tiempo, con y sin la táctica.
2. **Generación/validación de QR a escala** — demuestra Rendimiento. Medir
   tiempo de generación/validación bajo carga (ej. 1000 validaciones/seg
   simuladas) comparando **al menos 2 librerías o estrategias** (ej. QR
   firmado con JWT vs. UUID + consulta a BD).
3. **Failover de una instancia caída** (API Gateway o servicio de Entradas)
   — demuestra Disponibilidad. Comparar **al menos 2 estrategias**: réplica
   activa detrás de balanceador vs. réplica pasiva con reinicio automático.
   Medir tiempo de recuperación real (segundos) en cada una.

**Formato de cada PoC:** código real y ejecutable (no pseudocódigo), en el
repo de código `HEXACORE` (o en el repo personal del integrante si es
exploratorio, antes de llevarlo al PoC oficial — ver `TASKS.md`). Cada PoC
debe dejar:
- El código fuente, versionado.
- Un `README.md` corto: qué desafío ataca, qué alternativas comparó, cómo
  correrlo, y el resultado medido (tabla o gráfica simple).
- Un enlace desde el ADR/análisis de QA correspondiente ("ver PoC-01") y
  desde la entrada de la Bitácora que documenta la decisión.

**Aquí es donde las 3 reglas del usuario se cumplen al 100%**: cada PoC
*es* la comparación de ≥2 alternativas, *es* la evidencia, y nace de un
atributo de calidad concreto (el que motivó elegirlo como "desafío
complejo").

---

## 5. Prototipo funcional del CU más complejo de cada integrante

**Estado:** 🟡 hay trabajo de app móvil (`app-movil` Android,
`app-ios` SwiftUI) pero como apps genéricas de 19 pantallas, no enmarcadas
como "el CU complejo de cada integrante con sus QA implementados".

**Qué hacer:**
1. Cada integrante identifica, de sus ≥5 CU propios, cuál es el más
   complejo (el que ya tiene "Atributos de Calidad Asociados" e
   "Infraestructura No Trivial" más ricos en
   `Submission/CU_eventos_completo.xlsx`).
2. Implementa (o recorta del código ya existente en `app-movil`/`app-ios`/
   los portales web) ese CU puntual, mostrando explícitamente en
   funcionamiento la táctica de calidad que le corresponde a su atributo
   asignado (tabla de `Cronograma.md`) — no basta con que la pantalla
   exista, tiene que **demostrar** la táctica (ej. si es Seguridad, mostrar
   el flujo de autenticación real, no un login mock que acepta cualquier
   contraseña).
3. Deja evidencia demostrable: captura de pantalla, GIF corto, o mejor,
   poder correrlo en vivo el día de la entrega/sustentación.

**Regla de las 3 reglas aquí:** si el prototipo usa una librería/framework
puntual para lograr la táctica (ej. una librería de rate-limiting para
Performance, un validador de esquema para Seguridad), esa elección también
debería tener su mini-ADR con ≥2 alternativas — no hace falta un PoC
aparte si el prototipo mismo ya es la prueba funcionando.

---

## 6. Listado de CU + atributos de calidad comprometidos para Entrega 2

**Estado:** ❌ no redactado.

**Qué producir:** una tabla simple, al final de
`Work/DescripcionArquitecturaSoftware.tex`, del tipo:

| CU | Integrante | QA que se implementará completo en Entrega 2 |
|---|---|---|
| CU-006 (Mercado secundario) | Samuel Emperador | Disponibilidad, Rendimiento |
| ... | ... | ... |

Esto es una declaración de alcance, no requiere alternativas/evidencia —
pero sí debe ser consistente con lo ya construido en los puntos 3 y 5 (no
comprometer un atributo que nunca se analizó).

---

## Checklist de cierre antes de entregar

- [ ] RNF redactados (punto 1) y agregados al SAD.
- [ ] Árbol de Utilidad revisado por todo el equipo, no solo generado por
      el asistente (punto 2).
- [ ] Los 7 atributos pendientes (o al menos los "Alta") tienen su análisis
      de tácticas con ≥2 alternativas + evidencia + QA explícito, en la
      Bitácora y en `ArchitecturalProposal.tex` (punto 3).
- [ ] 2–3 PoCs corridos, con README de resultados, en el repo de código
      (punto 4) — **hacer esto primero**, alimenta todo lo demás.
- [ ] Prototipo del CU complejo de cada integrante, demostrable en vivo
      (punto 5).
- [ ] Tabla de alcance para Entrega 2 (punto 6).
- [ ] Auditar los ADR-01..04 existentes: ¿tienen ya evidencia, o hay que
      conseguirla con alguno de los PoCs del punto 4? (ver "Regla de oro"
      arriba).
- [ ] `Work/DescripcionArquitecturaSoftware.tex` compilado sin errores y
      copiado a `Submission/` (hoy sigue siendo borrador).
- [ ] Actualizar `TASKS.md` y esta guía conforme se cierre cada punto.
