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
> calidad** concreto (no una preferencia sin justificar) — **para todas las
> decisiones tomadas hasta el momento**, no solo las nuevas. Estas tres
> reglas son transversales a los 6 puntos de abajo — no son un ítem aparte.
>
> **Ejemplo de referencia dado por el usuario**, que fija el nivel de
> rigor esperado: *"en la app móvil se decidió trabajar en Flutter porque
> se hizo un demo en Flutter y otro en Android Studio, y se debe decir el
> porqué de la decisión y a qué atributo de calidad corresponde."* — es
> decir, no basta con elegir y justificar en prosa: hay que **construir
> algo en cada alternativa candidata** (aunque sea un demo pequeño) y
> comparar con datos reales. Este documento desarrolla ese ejemplo a fondo
> más abajo, y aplica el mismo criterio a **todas** las decisiones técnicas
> ya tomadas en el proyecto (auditoría completa en la siguiente sección).

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

**Demo/PoC construido para comparar:** <qué se construyó en cada
alternativa, aunque sea mínimo — una pantalla, un endpoint, un script — y
dónde vive el código>

**Decisión:** <cuál se eligió y en una frase, por qué gana sobre las otras>

**Evidencia / pruebas:** <qué demuestra que la decisión funciona: resultado
medido del demo (tiempo, líneas de código, throughput, latencia, capturas
de pantalla comparadas), o si no alcanzó el tiempo para un demo propio, al
menos documentación/benchmark técnico citado — nunca solo "porque es lo más
usado" sin respaldo>

**Riesgos / desventajas de lo elegido:** <qué se sacrifica>
```

**Por qué el campo "Evidencia" importa tanto:** en la sustentación, "elegimos
Redis porque es rápido" no resiste una pregunta de seguimiento. "Elegimos
Redis porque en el PoC-02 (`Work/PoCs/locking-redis/`) simulamos 50 compras
concurrentes de la misma entrada en reventa y Redis con `SETNX` evitó el
100% de las ventas duplicadas, mientras que sin bloqueo se duplicaron 6 de
50" sí resiste. Ese es el nivel que se busca — y es exactamente el nivel del
ejemplo de Flutter vs. Android Studio que dio el usuario.

---

## Auditoría completa de decisiones tecnológicas (tomadas o pendientes)

Se revisó todo lo que hoy existe en `Proyecto/App/**/README.md`, los ADR-01
a ADR-04 del SAD y las decisiones fundacionales de la Bitácora
(2026-08-18). Ninguna tiene hoy el campo **Evidencia** de la plantilla de
arriba — todas fueron justificadas por razonamiento, no por una prueba
construida. Además, **dos decisiones están literalmente sin cerrar**
(marcadas ❌ abajo) y bloquean poder avanzar con PoCs reales.

| # | Decisión | Estado hoy | Atributo de calidad que debería justificarla | Alternativas a comparar (mínimo 2) | Evidencia que falta conseguir |
|---|---|---|---|---|---|
| 1 | Arquitectura de microservicios (vs. monolito) | 🟡 decidida, alternativas ya listadas en Bitácora (2026-08-18) | Escalabilidad / Disponibilidad | Microservicios vs. Monolito modular (ya nombrada) | PoC: escalar solo el servicio de Entradas bajo carga simulada vs. escalar un monolito completo — medir recursos usados |
| 2 | **Lenguaje/framework del backend de `services/*`** | ❌ **"Por definir"** (`App/README.md`) — bloquea todo lo demás | Rendimiento (ASR-04: apertura de venta) | Ej. Node.js/Express vs. Java/Spring Boot vs. Go — elegir 2-3 candidatos reales del equipo | Benchmark: mismo endpoint (ej. "consultar disponibilidad de entradas") implementado en cada candidato, medir throughput/latencia con carga simulada (k6, JMeter o similar) |
| 3 | **Cola de mensajes: RabbitMQ *o* Kafka** | ❌ **sin decidir** — ADR-04 hoy dice "RabbitMQ/Kafka" como si fueran intercambiables | Desacoplamiento / Disponibilidad | RabbitMQ vs. Kafka | PoC: publicar/consumir el evento "entrada transferida" en ambos, comparar latencia y facilidad de configurar reintentos/DLQ |
| 4 | Redis para bloqueo de concurrencia + caché | 🟡 decidida (ADR-03), sin alternativa explícita comparada | Consistencia (evitar doble venta) | Redis (`SETNX`/lock distribuido) vs. bloqueo optimista en PostgreSQL (version/timestamp) vs. `SELECT FOR UPDATE` | Ya es uno de los PoCs sugeridos en el punto 4 de esta guía — reutilizar ese resultado aquí |
| 5 | PostgreSQL para datos transaccionales | 🟡 decidida, sin alternativa comparada | Consistencia (ACID) | PostgreSQL vs. MySQL | Evidencia liviana: comparación documentada (no necesita PoC propio si el equipo ya tiene experiencia clara con uno) |
| 6 | MongoDB para Reportes/analítica (polyglot persistence) | 🟡 decidida, sin alternativa comparada | Flexibilidad de esquema / Rendimiento en consultas analíticas | MongoDB vs. PostgreSQL con columnas JSONB | Evidencia liviana: ejemplo de una consulta de reporte típica en ambos, comparar flexibilidad de esquema |
| 7 | Angular + TypeScript para los portales web | 🟡 decidida, con un "motivo" en la tabla de `App/README.md` (RxJS para tiempo real) pero **sin demo comparado** | Modifiability / Rendimiento en actualizaciones en tiempo real | Angular vs. React (o Vue) | Demo pequeño: un componente con actualización en tiempo real (WebSocket o polling, ej. "aforo restante del evento") implementado en ambos frameworks |
| 8 | **Stack de las apps móviles: Kotlin nativo (Android) + Swift nativo (iOS), dos apps separadas** | ❌ decidida **de facto** (las dos apps ya están construidas: `app-movil` y `app-ios`) pero **sin documentar la comparación ni el porqué** | Modifiability (una base de código) vs. Usability/Performance (look-and-feel 100% nativo) | Nativo (Kotlin + Swift, ya construido) vs. **Flutter** (una sola base de código) — ver desarrollo completo abajo | Este es el ejemplo exacto que dio el usuario — desarrollado a fondo en la siguiente sección |

**Prioridad si el tiempo no alcanza para las 8**: cerrar primero la **#2**
(lenguaje del backend — sin esto no se puede ni empezar a codificar
`services/`) y la **#3** (cola de mensajes), porque son las únicas que
están genuinamente **sin decidir**, no solo sin evidencia. Las demás ya
tienen una decisión funcionando; hay que respaldarla, pero no bloquean
avanzar mientras tanto.

---

## Ejemplo completo desarrollado: stack de la app móvil (Nativo vs. Flutter)

Este es el desarrollo íntegro del ejemplo que dio el usuario, aplicado al
caso real del proyecto (fila #8 de la tabla de arriba).

### Contexto

Ya existen dos apps móviles completas (19 pantallas cada una, sobre datos
mock, sin backend real todavía):
- `Proyecto/App/frontend/app-movil` — Android nativo, Kotlin + Jetpack Compose.
- `Proyecto/App/frontend/app-ios` — iOS nativo, Swift + SwiftUI.

Esto se construyó así porque el usuario lo pidió explícitamente en dos
pasos separados de la conversación, **no porque el equipo comparó
alternativas y decidió** — es exactamente el tipo de decisión "de facto sin
evidencia" que esta guía busca corregir antes de la entrega.

### Atributo de calidad que motiva la decisión

Hay tensión entre dos atributos, y el ADR final debe decir cuál pesa más
para HEXACORE:
- **Modifiability** (mantenibilidad/costo de desarrollo): una sola base de
  código (Flutter) se modifica una vez para ambas plataformas; dos bases
  nativas duplican todo cambio.
- **Usability** (consistencia con la plataforma) y **Performance**: código
  nativo usa los widgets/render real de cada SO (look-and-feel 100%
  fiel, mejor acceso a APIs nuevas del sistema operativo); Flutter dibuja
  su propio motor de renderizado (Skia/Impeller) por encima, no usa
  widgets nativos.

### Alternativas a comparar (mínimo 2 — aquí van 3)

1. **Dos apps nativas** (Kotlin/Compose + Swift/SwiftUI) — **ya construido**.
2. **Flutter** (Dart) — una sola base de código para ambas plataformas —
   **falta construir el demo**.
3. *(opcional, si el tiempo alcanza)* **Kotlin Multiplatform (KMM)**: UI
   nativa por plataforma pero lógica de negocio/red compartida — término
   medio entre las dos anteriores. Puede quedar solo como análisis en
   prosa si no alcanza el tiempo para un tercer demo.

### El demo que hay que construir (esto es lo que falta — es la evidencia)

Tomar **una sola pantalla ya existente en ambas apps nativas**, la más
representativa (recomendado: **Inicio** — lista de eventos con tabs
Próximos/Pasados, `InicioScreen.kt` / `InicioScreen.swift` — o si se
prefiere algo más simple, **Login**), y reimplementarla en Flutter desde
cero, con los mismos datos mock. No hace falta portar las 19 pantallas —
con una bien elegida basta para medir de forma justa.

**Qué medir en el demo (esto se convierte en la tabla de evidencia):**

| Métrica | Cómo medirla | Por qué importa |
|---|---|---|
| Tiempo de desarrollo | Horas reales para llegar al mismo resultado visual/funcional en Flutter, comparado con lo que ya tomó en Kotlin+Swift (estimar retrospectivamente si no se cronometró en su momento) | Evidencia directa de Modifiability/costo |
| Líneas de código | Flutter: 1 archivo/pantalla para ambas plataformas. Nativo: 2 archivos (uno Kotlin, uno Swift) para la misma pantalla | Evidencia directa de duplicación de esfuerzo |
| Fidelidad al look-and-feel nativo | Captura de pantalla lado a lado: la versión Flutter vs. la nativa de Android vs. la nativa de iOS, en el mismo dispositivo/simulador | Evidencia de Usability — ¿se nota que Flutter no es 100% nativo? |
| Rendimiento | Tiempo de arranque en frío y fluidez de scroll de la lista de eventos, medidos con Flutter DevTools vs. Android Studio Profiler / Xcode Instruments | Evidencia de Performance |
| Familiaridad del equipo | Cualitativo: el equipo ya conoce Kotlin (así lo dice `App/README.md` como "motivo" actual) — nadie en el equipo tiene experiencia previa en Dart/Flutter, lo cual es un riesgo real de tiempo, no solo una preferencia | Evidencia de Testability/riesgo de cronograma |

**Nota práctica:** esta máquina no tiene el SDK de Flutter instalado (se
verificó: `flutter`/`dart` no están disponibles). Si el equipo quiere que
se construya este demo en una sesión futura, hay que instalar el SDK
primero (`brew install --cask flutter` en macOS) — avisar antes de hacerlo
porque es una descarga grande. Mientras tanto, esta sección deja la
metodología exacta lista para ejecutar.

### Decisión (a redactar después de correr el demo — no se puede inventar)

Aquí va, una vez exista el resultado real del demo, una frase del tipo:
*"Se mantiene el stack nativo (Kotlin + Swift) porque, aunque duplica el
código, el demo de Flutter mostró [X ms más de arranque en frío / look
diferente perceptible en Y] y el equipo no tiene experiencia previa en
Dart, lo que habría puesto en riesgo el cronograma de Entrega 1."* — o la
conclusión contraria, si el demo de Flutter sale mejor de lo esperado. **No
redactar la decisión antes de tener el demo** — sería exactamente el tipo
de justificación sin evidencia que se está corrigiendo.

### Dónde documentarlo

Nuevo **ADR-05 — Stack de las apps móviles** en
`Work/DescripcionArquitecturaSoftware.tex` (junto a ADR-01..04) + entrada
nueva en `BitacoraArquitectonica.md` con la plantilla completa de la
sección "Regla de oro". Actualizar también la tabla de "Stack técnico" en
`Proyecto/App/README.md`, que hoy solo dice "Kotlin nativo... Lenguaje ya
conocido por el equipo" sin mencionar que también existe una app iOS ni
que se comparó con Flutter — está desactualizada respecto a lo que
realmente hay en el repo.

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
alternativas/tecnología en este punto, eso viene en los puntos 3 y 4 (y en
la auditoría de arriba).

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
   explícitamente marcado con la plantilla de la sección "Regla de oro".
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
**evidencia** que piden los puntos 1, 3, 5 y 6, y también la mayoría de
filas de la auditoría de decisiones — es el más importante de priorizar
cronológicamente, antes que redactar los análisis de QA, porque sin PoC no
hay pruebas que citar.

**Candidatos** (de `Cronograma.md`, ajustar con el equipo — nótese que el
#1 y el #4 de la tabla de auditoría de decisiones se resuelven con estos
mismos PoCs, no hace falta duplicar esfuerzo):
1. **Bloqueo de concurrencia en reventa de entradas** (Redis `SETNX`/
   distributed lock) — demuestra Disponibilidad/Consistencia bajo
   concurrencia, y resuelve la fila #4 de la auditoría. Comparar contra
   **al menos una alternativa**: bloqueo optimista en base de datos
   (version/timestamp) o `SELECT FOR UPDATE`. Medir: % de ventas
   duplicadas con N compradores simulados comprando la misma entrada al
   mismo tiempo, con y sin la táctica.
2. **Generación/validación de QR a escala** — demuestra Rendimiento. Medir
   tiempo de generación/validación bajo carga (ej. 1000 validaciones/seg
   simuladas) comparando **al menos 2 librerías o estrategias** (ej. QR
   firmado con JWT vs. UUID + consulta a BD).
3. **Failover de una instancia caída** (API Gateway o servicio de Entradas)
   — demuestra Disponibilidad. Comparar **al menos 2 estrategias**: réplica
   activa detrás de balanceador vs. réplica pasiva con reinicio automático.
   Medir tiempo de recuperación real (segundos) en cada una.
4. **(Recomendado añadir, dado el hueco #2 de la auditoría)**: benchmark
   del lenguaje/framework del backend — es el desafío técnico más urgente
   de resolver porque bloquea empezar a codificar `services/*`.

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
como "el CU complejo de cada integrante con sus QA implementados" — y,
como quedó dicho en la auditoría, la elección misma de ese stack todavía no
tiene su ADR con evidencia (fila #8).

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
- [ ] **Decidir el lenguaje/framework del backend de `services/*`**
      (auditoría #2) — hoy está literalmente "por definir" y bloquea
      empezar a codificar.
- [ ] **Decidir RabbitMQ vs. Kafka** (auditoría #3) — hoy el ADR-04 los
      lista a ambos sin elegir.
- [ ] **Construir el demo de Flutter y redactar el ADR-05 del stack móvil**
      (auditoría #8, desarrollado a fondo arriba) — es el ejemplo que
      motivó esta versión de la guía.
- [ ] Auditar el resto de la tabla de decisiones (filas #1, #4, #5, #6, #7)
      y conseguir al menos evidencia liviana (documentación citada) donde
      no alcance el tiempo para un PoC propio.
- [ ] Prototipo del CU complejo de cada integrante, demostrable en vivo
      (punto 5).
- [ ] Tabla de alcance para Entrega 2 (punto 6).
- [ ] `Work/DescripcionArquitecturaSoftware.tex` compilado sin errores y
      copiado a `Submission/` (hoy sigue siendo borrador).
- [ ] Actualizar `Proyecto/App/README.md` (tabla "Stack técnico") una vez
      se resuelvan las decisiones pendientes de la auditoría.
- [ ] Actualizar `TASKS.md` y esta guía conforme se cierre cada punto.
