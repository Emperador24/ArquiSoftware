# Disponibilidad: explorando tácticas y patrones posibles (doc de trabajo, informal)

> Esto **no** es el entregable formal. El entregable formal — la tabla
> escenario/estímulo-respuesta/tácticas/patrón que efectivamente se presenta
> — vive en `Work/ArchitecturalProposal.tex` § "Disponibilidad -- Alta" y
> quedó registrado en `Work/BitacoraArquitectonica.md` (entrada del
> 2026-08-25, "Ejercicio Clase 6"). Este documento es el "detrás de cámaras":
> para cada escenario de disponibilidad del proyecto, repaso **todo** el
> catálogo de Bass/Kazman (no solo lo que terminó eligiéndose) y anoto qué se
> descartó y por qué, qué quedó dudoso, y qué tácticas del catálogo el equipo
> todavía no ha usado en ningún lado. Sirve para justificar el "por qué esto
> y no lo otro" si el profesor pregunta en la sustentación, y como checklist
> por si se nos quedó algo por revisar antes de Entrega 1.
>
> Fuente del catálogo: `Work/Notes/06. Availability.md` (resumen de la
> diapositiva de clase, Bass/Kazman).

## Recordatorio rápido del catálogo

**Tácticas — 3 grupos:**
- *Detectar defectos*: monitoreo, ping/echo, heartbeat (+watchdog),
  timestamp, monitoreo de condiciones, sanity checking, voting, detección de
  excepciones/timeout, self-test.
- *Recuperarse de defectos*: (preparación/reparación) redundant
  spare/réplicas, rollback, manejo de excepciones, actualización sin
  interrumpir (ISSU), retry, ignorar comportamiento defectuoso, graceful
  degradation, reconfiguración; (reintroducción) shadow, resincronización de
  estado, reinicio escalado, nonstop forwarding.
- *Prevenir defectos*: baja temporal (desconectar/reparar/reconectar),
  transacciones (ACID, 2PC, SAGA), modelo predictivo, prevención de
  excepciones, incrementar estados "competentes".

**Patrones:** redundancia (activa/hot spare, pasiva/warm spare, repuesto/cold
spare, TMR) y Circuit Breaker.

Ninguno de los 6 escenarios necesita el catálogo completo — la idea de este
documento es justamente ver *cuánto* del catálogo aplica y por qué el resto
no, en vez de asumir que "ya elegimos algo y ya".

---

## 1. Falla de una instancia de validación de QR durante el ingreso masivo

**Elegido (formal):** heartbeat/monitoreo (detección) + redundant spare y
reconfiguración (recuperación) + reinicio escalado (reintroducción).
Patrón: redundancia activa detrás del balanceador.

**Otras tácticas de detección que se pensaron:**
- *Ping/echo* — redundante con el heartbeat que ya usa el balanceador para
  saber qué instancias están sanas; no aporta algo que el heartbeat no dé
  ya. Descartado por redundante, no por malo.
- *Self-test* al arrancar cada instancia (verificar que puede conectarse a
  la BD de Entradas antes de recibir tráfico) — sí parece razonable
  añadirlo como buena práctica de despliegue, aunque no estaba en la tabla
  formal. Vale la pena mencionarlo en el SAD como parte del arranque de
  contenedores.
- *Voting* (comparar respuesta de varias instancias) — no tiene sentido
  aquí, no es una decisión donde valga la pena tener consenso entre
  réplicas; validar un QR es una operación idempotente de lectura/escritura
  simple, no una decisión crítica tipo aviónica.

**Sobre el patrón:** se consideró *redundancia pasiva (warm spare)* en vez
de activa, pero se descartó — durante ingreso masivo la ventana de
indisponibilidad tolerable es casi cero (miles de personas haciendo fila),
así que vale la pena pagar el costo de tener todas las instancias activas
todo el tiempo en vez de "despertar" una réplica al detectar la falla.

---

## 2. Picos de tráfico en la apertura de venta

**Elegido (formal):** monitoreo de carga (detección) + autoescalado y
reconfiguración (recuperación) + sala de espera virtual como "estado
competente" (prevención) + graceful degradation. Patrón: redundancia activa
con escalado horizontal.

**Nota:** este es, de los 6, el único donde la táctica de **prevención**
("incrementar estados competentes") es el mecanismo central, no un extra —
vale la pena resaltarlo así en la sustentación: no estamos tratando el pico
de tráfico como una excepción a manejar, sino diseñando explícitamente para
que sea un flujo normal (la sala de espera virtual *es* el flujo esperado
en apertura de venta, no un fallback).

**Otras tácticas consideradas:**
- *Modelo predictivo* (anticipar el pico antes de que ocurra, por ejemplo
  preescalar instancias unos minutos antes de la hora anunciada de venta,
  ya que se conoce de antemano) — no está en la tabla formal pero es una
  idea barata de agregar: como la hora de apertura de venta se anuncia con
  anticipación, no haría falta un modelo predictivo sofisticado (cadenas de
  Markov, ML), basta con un *scheduled scale-up* simple. Vale la pena
  anotarlo como mejora futura.
- *Rollback/checkpoints* — no aplica directamente al escenario de tráfico,
  pero sí es relevante para la fila virtual en sí (si el servicio que
  gestiona la posición en la fila falla, ¿se pierde la posición del
  usuario? Habría que persistirla, no solo tenerla en memoria). Esto quedó
  como pregunta abierta, ver sección final.

**Patrón:** se pensó también en *Circuit Breaker* del lado del cliente hacia
el servicio de Entradas (para que el frontend deje de bombardear con
reintentos si el servicio está saturado), pero no quedó explícito en la
tabla formal — es un candidato a añadir si el equipo detalla más el
comportamiento del frontend durante el pico.

---

## 3. Caída del API Gateway (punto único de entrada)

**Elegido (formal):** heartbeat/health-check (detección) + redundant spare y
reconfiguración (recuperación). Patrón: redundancia activa + Circuit
Breaker hacia microservicios lentos.

Este es el escenario más "de manual" — el Gateway es el ejemplo clásico de
punto único de falla (SPOF) en una arquitectura de microservicios, así que
el catálogo aplica casi sin sorpresas.

**Descartado explícitamente:**
- *Cold spare* (repuesto apagado) para el Gateway — no tiene sentido, el
  Gateway es el componente más crítico del sistema (nada entra sin pasar
  por él), así que ahorrar costo con un repuesto frío que tarda en
  levantarse iría en contra de la prioridad "Alta" que ya se le dio a
  disponibilidad.
- *TMR (Triple Modular Redundancy)* — es overkill para este contexto; TMR
  tiene sentido cuando una respuesta incorrecta es tan grave como una caída
  (aviónica, control industrial). Aquí el Gateway solo enruta, no decide
  nada donde el "voto por mayoría" aporte algo — con redundancia activa +
  balanceador ya basta.

**Duda abierta:** la tabla formal no dice explícitamente qué pasa si
*todas* las instancias del Gateway caen a la vez (por ejemplo, un error de
configuración desplegado a todas simultáneamente, no una falla de hardware
aislada). Ese caso no lo cubre la redundancia activa por sí sola — ahí
entraría más bien una táctica de *prevención* (staged rollout / canary
deployment antes de desplegar a todas las instancias) que todavía no está
mencionada en ningún lado del proyecto. Vale la pena anotarlo como
mejora para Entrega 2 si se llega a hablar de estrategia de despliegue.

---

## 4. Indisponibilidad de la pasarela de pagos externa

**Elegido (formal):** detección de excepciones/timeout + retry con máximo
de reintentos (recuperación) + graceful degradation (transacción pendiente
en vez de fallo total). Patrón: Circuit Breaker.

Este es el ejemplo de libro de Circuit Breaker (dependencia externa poco
confiable, fuera de nuestro control).

**Por qué no redundancia:** se pensó en tener "pasarela de pagos B" como
respaldo (redundancia pasiva de proveedor), pero se descartó por ahora —
integrar una segunda pasarela duplica el trabajo de integración y
conciliación financiera (CU de Pagos y Conciliación) sin que el curso lo
esté pidiendo; queda como posible evolución, no como parte del diseño
actual.

**Táctica que sí faltaría nombrar explícitamente:** *transacciones* (la
categoría de prevención "Transacciones: ACID, 2PC, SAGA" del catálogo). El
"marcar la transacción como pendiente" que ya está en la tabla formal es,
en el fondo, una aplicación del patrón SAGA (paso compensable: si el pago
falla, no se revierte todo el pedido, se deja en estado intermedio
reconciliable después). Vale la pena nombrar "SAGA" explícitamente en el
SAD si se detalla el flujo de compra como una transacción distribuida —
ahora mismo el texto formal no usa esa palabra aunque el comportamiento
descrito ya es SAGA.

---

## 5. Falla del proveedor de notificaciones durante una emergencia

**Elegido (formal):** detección de excepciones/timeout + retry limitado con
reconfiguración hacia canal secundario (SMS) + graceful degradation
(personal en sitio releva la comunicación). Patrón: Circuit Breaker +
redundancia pasiva (canal secundario en espera).

**Por qué este es el escenario más delicado de los 6:** a diferencia de los
otros, acá la disponibilidad se cruza con *Safety* (evacuación de personas
reales) — si el catálogo de disponibilidad no alcanza, el "graceful
degradation" no puede ser "mostrar un mensaje de error", tiene que ser un
respaldo humano real (personal en sitio). Eso ya está en el texto formal,
pero vale la pena resaltarlo como el motivo de que este sea el único
escenario donde la "degradación" pasa por un proceso *no técnico* — es un
recordatorio de que la disponibilidad de software no siempre es
suficiente, y por qué la Clase 11 (Safety) probablemente vuelva a tocar
este mismo caso de uso.

**Táctica de detección que faltó considerar:** *voting/sanity checking* en
el envío de la alerta — es decir, no dar por confirmada la notificación
solo porque el proveedor devolvió 200 OK, sino confirmar activamente que
llegó (ack del cliente, o un segundo canal de verificación). Esto no está
en la tabla formal y podría ser una mejora real: hoy el diseño detecta que
el *envío* falló (timeout/excepción), pero no detecta si el envío "tuvo
éxito" según el proveedor pero el mensaje nunca llegó al dispositivo.
Queda como pregunta abierta.

---

## 6. Falla del nodo de Redis del bloqueo de concurrencia en reventa

**Elegido (formal):** heartbeat/health-check del clúster (detección) +
redundant spare (recuperación) + resincronización de estado tras failover
(reintroducción). Patrón: redundancia activa/pasiva vía réplica de Redis
(Sentinel/Cluster).

**Por qué "activa/pasiva" y no solo una:** Redis Sentinel funciona con un
nodo maestro activo y réplicas en modo pasivo/warm que se promueven al
fallar el maestro — es una mezcla de los dos patrones de redundancia del
catálogo, no uno solo. Vale la pena aclarar esto en el SAD si se pide
detalle de infraestructura, porque hoy el texto lo menciona junto pero no
explica por qué es una combinación y no un patrón puro.

**Riesgo que el catálogo expone y que la tabla formal no resuelve del
todo:** durante el *failover* (mientras la réplica se promueve a maestro),
hay una ventana de tiempo en la que el bloqueo de concurrencia
temporalmente no está disponible. La táctica listada (resincronización de
estado) cubre "que no queden dos compras simultáneas *después* del
failover", pero no dice qué le pasa a una compra que estaba *en curso*
justo cuando el nodo cayó. Ahí aplicaría la táctica de **rollback**
(deshacer la reserva parcial si no se puede confirmar el bloqueo) — no
está mencionada explícitamente y sería la más natural para cerrar ese
hueco. Anotado como pendiente de revisar con el equipo.

---

## Tácticas del catálogo que el proyecto todavía no usa en ningún escenario

Repasando el catálogo completo contra los 6 escenarios, esto es lo que
**no** aparece en ningún lado todavía — no significa que falte agregarlo
sí o sí, pero vale la pena que el equipo lo revise por si aplica en algún
otro caso de uso (parqueaderos, personal, etc.) que no se analizó en este
ejercicio:

- **Timestamp** (orden de mensajes) — podría ser relevante en el módulo de
  Emergencias si varias fuentes reportan el estado de una zona casi al
  mismo tiempo y hay que saber cuál es el evento más reciente.
- **Monitoreo de condiciones de hardware** (temperatura, humedad,
  vibración) — no aplica, el proyecto no tiene sensores físicos propios más
  allá de lo que reporten terceros (control de acceso, parqueadero).
- **Shadow** (correr un componente oculto antes de reintroducirlo tras una
  falla) — candidato natural para el Gateway o el servicio de Entradas: en
  vez de reintroducir una instancia reparada directo a producción, dejarla
  recibir tráfico espejo primero. No está en el diseño actual.
- **Nonstop forwarding** — es una táctica de nivel de red (OSI 3), probablemente
  fuera del alcance de lo que el equipo controla (más bien de la nube/
  infraestructura), no hace falta diseñarla explícitamente.
- **TMR** — evaluado y descartado arriba (Gateway), no aplica en ningún
  otro escenario tampoco: no hay ninguna decisión del sistema donde un
  "voto por mayoría" entre réplicas tenga sentido.
- **Modelo predictivo** — mencionado como posible mejora en el escenario 2
  (picos de tráfico), no implementado.
- **2PC (two-phase commit)** — se prefirió SAGA (ver escenario 4) por ser
  microservicios con BD independiente; 2PC exigiría acoplar los servicios
  de pago con el de Entradas de forma síncrona, que es justo lo que se
  quiso evitar.

---

## Preguntas abiertas para el equipo (antes de Entrega 1)

1. ¿Se persiste la posición en la fila virtual (escenario 2) o vive solo en
   memoria/Redis sin respaldo? Si Redis también guarda eso, ¿es el mismo
   clúster que el del bloqueo de reventa (escenario 6) o uno separado?
2. ¿Vale la pena nombrar explícitamente **SAGA** en el SAD para el flujo de
   compra/pago (escenario 4), ya que el comportamiento descrito ya es SAGA
   aunque el texto no use la palabra?
3. ¿Qué pasa si **todas** las instancias del Gateway caen a la vez por un
   error de configuración (no una falla aislada de hardware)? Ninguna
   táctica de las elegidas cubre ese caso — requeriría hablar de
   *canary deployment* / *staged rollout*, que no está en el SAD todavía.
4. Rollback de una compra en curso cuando el nodo Redis de bloqueo falla a
   mitad de operación (escenario 6) — ¿el diseño actual ya lo maneja
   implícitamente o es un hueco real?
5. Confirmación de entrega de notificaciones (escenario 5) más allá del
   código HTTP del proveedor — ¿hace falta un ack explícito del
   dispositivo para considerar la alerta "entregada"?

Ninguna de estas 5 preguntas bloquea el ejercicio de la Clase 6 (ya resuelto
formalmente), pero son candidatas a mejorar el análisis antes de Entrega 1
si el equipo tiene tiempo de profundizar.

---

## Referencias

- Catálogo de clase: `Work/Notes/06. Availability.md`
- Documento formal (tabla escenario/estímulo/tácticas/patrón):
  `Work/ArchitecturalProposal.tex` § "Disponibilidad -- Alta"
- Registro del ejercicio: `Work/BitacoraArquitectonica.md`, entrada
  2026-08-25 "Ejercicio Clase 6 (Availability)"
- ASR relacionado: `Work/DescripcionArquitecturaSoftware.tex`, ASR-02
