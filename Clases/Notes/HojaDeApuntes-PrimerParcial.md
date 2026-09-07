# Hoja de apuntes — Primer Parcial (Clases 1–7)

Contenido para copiar **a mano** en la hoja tamaño carta/A4 (única ayuda
permitida en el examen, según `Clases/Slides/Reglas e instrucciones para
evaluaciones escritas.pdf`). Pensado para caber en **las dos caras de una
sola hoja**: prioriza fórmulas, tablas y listas que no se pueden derivar en
el momento — lo que sí se puede razonar en el momento (por qué falla
cascada, qué es DevOps, por qué documentar) no está aquí a propósito.

Distribución sugerida: **Cara 1** = Clases 2, 4, 5 (conceptos y proceso).
**Cara 2** = Clases 6, 7 (atributos de calidad con tácticas/patrones, lo más
denso).

---

## CARA 1

### Clase 2 — Atributos de calidad (definición en una línea c/u)
- **Availability**: responde cuando se requiere (Reliability+Recovery+Fault-tolerance)
- **Deployability**: facilidad de poner en producción una nueva versión
- **Integrability**: facilidad/costo de integrarse con otros sistemas
- **Modifiability**: facilidad de cambio (Mantenibilidad+Escalabilidad+Portabilidad)
- **Performance**: tiempo/velocidad, uso de CPU/memoria
- **Safety**: "no mates a nadie" — criticidad = pérdida × stakeholders afectados
- **Security**: **CIA** = Confidentiality, Integrity, Availability
- **Testability**: encontrar errores, controlar entradas/salidas, reproducir fallos
- **Usability**: aprendizaje, eficiencia, tolerancia a errores, satisfacción

**Arq. vs diseño detallado**: largo plazo/impacto general/estratégica ↔
corto plazo/impacto acotado/táctica.

**Vistas 4+1**: Logical, Development, Process, Physical, + Scenarios.

**CAP**: solo 2 de 3 — Consistency, Availability, Partition tolerance.

**Estilos arquitectónicos** (reconocer por nombre): Layered/N-Tier, Modular
Monolith, Pipe-and-Filter, Microkernel, Service-based, Event-driven, ESB
(orchestration SOA), Microservices, CQRS, Broker-domain.

### Clase 3 — Proceso
- Cascada falla porque: **requisitos no se conocen completos de entrada**.
- **Cono de incertidumbre** (McConnell 1998): el rango de estimación se
  reduce con el tiempo.
- **DevOps** = Config. management + Pruebas automáticas + Integración
  frecuente.
- **BDUF** (fijo al inicio) < **Iteración 0** (pico inicial + refinamiento,
  **recomendado**) < **Emergente** (ágil puro, sin diseño inicial).
- Arquitecto vs Ing. de requisitos: éste entrega RF/RNF; el arquitecto los
  prioriza y saca los **ASR**.
- Ágil + Arq. compatibles, **excepto**: en sistemas complejos sí hace falta
  documentación formal y roles capacitados (no solo cara a cara/auto-org.).

### Clase 4 — Notación
**Formalidad**: informal < semi-formal (**C4**, UML, SysML, ArchiMate) <
formal (ADL: Rapide, Wright).

**4+1 → diagrama**: Logical→clases · Process→secuencia/actividad/estados ·
Development→paquetes/componentes · Physical→despliegue.

**C4 jerarquía**: Context → Container → Component → Code.
**C4 auxiliares**: System Landscape, Dynamic, Deployment.

**C4 ↔ 4+1**:
| C4 | 4+1 |
|---|---|
| Context / Sys. Landscape | Scenarios |
| Container / Component | Development |
| Code | Logical |
| Deployment | Physical |
| Dynamic | Process |

### Clase 5 — Diseño arquitectónico
`Stakeholder` tiene `Preocupación` (según `Punto de vista`) → resuelta por
`Vista`.

**ASR** = requisito (típ. no funcional) con impacto fuerte en la
arquitectura — sin él, la arquitectura sería drásticamente distinta.

**Árbol de Utilidad**: Utilidad → Atributo de calidad → sub-atributo →
Escenario, con prioridad **(Importancia, Dificultad)** ej. (H,H).

**ADD — 7 pasos, EN ORDEN**:
1. Revisar entradas
2. Definir objetivos (qué ASR de esta iteración)
3. Seleccionar elementos del sistema a refinar
4. Seleccionar conceptos de diseño (patrones/referencias/tecnologías)
5. Instanciar elementos, asignar responsabilidades, definir interfaces
6. Bosquejar vistas y registrar decisiones
7. Analizar resultados

---

## CARA 2

### Clase 6 — Disponibilidad (Availability)

**Cadena causal**: Fault → Error → Failure → interrupción de servicio →
**Downtime**. Se resuelve con Resiliencia = Detección + Recuperación +
Prevención.

**Fórmula**: `Disponibilidad = MTBF / (MTBF + MTTR)`
(MTBF = tiempo medio entre fallas · MTTR = tiempo medio de reparación)

**Tabla SLA (downtime/año)**:
| Disp. | Downtime/año |
|---|---|
| 99.0% | ~3.6 días |
| 99.9% | ~8.8 h |
| 99.99% | ~52.6 min |
| 99.999% | ~5.3 min |
| 99.9999% | ~32 s |

**Tácticas — 3 grupos**:
- *Detectar*: monitoreo, ping/echo, heartbeat/watchdog, timestamp, sanity
  check, voting, detección de excepciones, self-test.
- *Recuperar*: redundant spare, rollback, retry, **graceful degradation**,
  reconfiguración, shadow, resincronización, reinicio escalado, nonstop
  forwarding.
- *Prevenir*: dar de baja temporal, transacciones (ACID/2PC/**SAGA**),
  modelo predictivo, prevención de excepciones, incrementar estados
  competentes.

**Redundancia — 3 niveles**:
| Tipo | Nodos activos | Costo | Disponibilidad |
|---|---|---|---|
| Activa (hot) | Todos, sync constante | Alto | Alta |
| Pasiva (warm) | Subconjunto + shadow | Medio | Media |
| Repuesto (cold) | Apagados hasta la falla | Bajo | Baja |

**TMR** (Triple Modular Redundancy): 3+ sistemas, gana la mayoría.
**Circuit Breaker**: monitor externo, limita reintentos (Resilience4j).

### Clase 7 — Desplegabilidad (Deployability)

**5 ambientes, en orden**: Development → Repositorio de código →
Integration → Staging → Production (patrón Shadow→Monitoreo→Reintroducción).

**Calidad del pipeline**: Cycle Time (spec→producción), Trazabilidad,
Repetibilidad.

**Tácticas — 2 grupos**:
- *Administrar el pipeline*: Scaled Rollouts, Scripts de despliegue,
  Rollback.
- *Administrar el sistema desplegado*: Manage Service Interactions
  (service registry, traffic splitting, circuit breaker), Package
  Dependencies (contenedores/VMs), Feature Toggle (Kill Switch).

**Patrones de reemplazo**:
| Patrón | Instancias | Downtime | Riesgo |
|---|---|---|---|
| Blue/Green | 2×N | Ninguno (corte tráfico) | Más costoso |
| Rolling Upgrade | N+1 | Ninguno, gradual | Inconsistencia temporal |
| Canary Testing | Subconj. usuarios reales | — | Enrutamiento selectivo |
| A/B Testing | A vs B, comparar métricas | — | Esfuerzo de instrumentación |

**Canary** = probar con usuarios reales antes de liberar a todos
(seguridad). **A/B** = comparar dos versiones para *elegir* cuál se queda
(experimento). No confundirlos.

**Estructuración de servicios**: desplegabilidad independiente = empaquetar
dependencias + administrar interacciones entre servicios.
