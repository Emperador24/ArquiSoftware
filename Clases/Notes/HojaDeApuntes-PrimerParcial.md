# Hoja de apuntes — Primer Parcial (Clases 1–7)

Contenido para copiar **a mano** en la hoja tamaño carta/A4 (única ayuda permitida en el examen).
Pensado para caber en **dos caras de una sola hoja**.

Distribución: **Cara 1** = Clases 2–5. **Cara 2** = Clases 6–7.

---

## CARA 1

### Clase 2 — Atributos de Calidad (9 totales)

| Atributo | Definición | Ejemplo |
|---|---|---|
| **Availability** | Responde cuando se necesita (confiabilidad+recuperación) | 99.99% uptime = 52.6 min downtime/año |
| **Deployability** | Nuevas versiones en producción rápido/sin parada | Blue/Green, Rolling Upgrade |
| **Integrability** | Costo/facilidad de integrarse con otros sistemas | APIs, contratos, formato datos |
| **Modifiability** | Costo de cambio (agregar features, refactor) | arquitectura modular |
| **Performance** | Tiempo/CPU/memoria bajo carga | latency p95 < 500ms, throughput > 1000 req/s |
| **Safety** | No causa daño físico | criticidad = pérdida × stakeholders |
| **Security** | **CIA**: Confidentiality, Integrity, Availability | encriptación, autenticación, autorización |
| **Testability** | Encontrar errores rápido; reproducibles | coverage > 80%, aislamiento de módulos |
| **Usability** | Aprendizaje, eficiencia, tolerancia a errores | UX metrics, facilidad de aprender |

**Architectura vs. Diseño**: Arq. = largo plazo, impacto general, estratégica.
Diseño = corto plazo, acotado, táctico.

**Vistas 4+1** (cada una resuelve preocupación diferente):
- **Logical**: clases del dominio (OO), relaciones, herencia. Ej: User, Order, Product
- **Development**: paquetes/módulos, estructura del código fuente. Ej: com.app.services, com.app.dao
- **Process**: hilos/procesos, comunicación concurrente. Ej: thread pool, async tasks
- **Physical**: máquinas, base datos, despliegue, red. Ej: load balancer, app server, BD
- **Scenarios**: narrativas, flujos de casos de uso. Ej: "Usuario compra entrada"

**CAP Theorem**: 3 propiedades, solo **2 de 3** posibles en sistemas distribuidos:
- **Consistency**: todos los nodos ven el mismo estado simultáneamente
- **Availability**: el sistema siempre responde (no timeout)
- **Partition tolerance**: tolera desconexión entre nodos
Ejemplos: CA (BD centrales), CP (banking), AP (redes sociales).

**Estilos Arquitectónicos** (10 principales):
- **Layered (N-Tier)**: capas horizontales (UI → Biz → Data). Simple, común, monolítico.
- **Modular Monolith**: monolito pero internamente modular (fácil de partir luego).
- **Pipe-and-Filter**: cadena de procesadores, cada uno transforma datos (ETL, streams).
- **Microkernel**: core pequeño + plugins modulares (ej: navegador, IDE).
- **Service-based**: servicios coexistentes, DB compartida (entre monolith y microservices).
- **Event-driven**: componentes desacoplados por eventos (pub-sub, async).
- **ESB** (Enterprise Service Bus): orquestación centralizada (anticuado).
- **Microservices**: servicios independientes, DB por servicio, deploy independiente.
- **CQRS**: Command Query Responsibility Segregation (read y write por separado).
- **Broker-domain**: brokers centrales conectan dominios distribuidos (peer-to-peer).

---

### Clase 3 — Proceso de Desarrollo

**Por qué falla Cascada**: requisitos no se conocen **completos al inicio** →
necesita iteración para refinamiento.

**Cono de Incertidumbre** (McConnell 1998): rango de estimación se reduce con tiempo.

**Espectro de diseño**:
1. **BDUF** (Big Design Up Front): todo el diseño fijo al inicio. Alto riesgo.
2. **Iteración 0** (recomendado ⭐): pico inicial de diseño + refinamiento iterativo.
   Equilibra riesgo y adaptación.
3. **Emergente**: diseño evoluciona completamente con código (ágil puro, riesgoso
   en sistemas complejos).

**DevOps**: Config. management + Pruebas automáticas + Integración frecuente.
Cierra brecha entre desarrollo y operaciones.

**Ágil + Arquitectura**: compatibles, EXCEPTO: en sistemas complejos sí necesita
**documentación formal** y **roles capacitados** (no solo auto-organización).

**Roles**:
- **Ing. de Requisitos**: entrega RF (requisitos funcionales) y RNF (no funcionales) crudos
- **Arquitecto**: **prioriza** RF/RNF, extrae **ASR** (reqs arquitectónicamente significativos)

---

### Clase 4 — Notación y Diagramas

**Formalidad**: Informal < Semi-formal (C4, UML, SysML, ArchiMate) < Formal (ADL).

**4+1 → Diagrama**:
- Logical → Clases UML (dominio OO)
- Development → Paquetes/componentes UML (código)
- Process → Secuencia/estado UML (flujos)
- Physical → Despliegue UML (máquinas)
- Scenarios → Narrativas y secuencias (casos uso)

**C4 — 4 niveles jerárquicos**:
1. **Context**: sistema en contexto (usuarios externos, sistemas externos)
2. **Container**: aplicaciones, BDs, servicios, APIs (tecnología explícita)
3. **Component**: módulos dentro de un container
4. **Code**: clases/funciones en un componente
**Auxiliares**: System Landscape, Dynamic, Deployment.

**C4 ↔ 4+1 mapeo**:
| C4 | 4+1 |
|---|---|
| Context, System Landscape | Scenarios |
| Container, Component | Development |
| Code | Logical |
| Deployment | Physical |
| Dynamic | Process |

---

### Clase 5 — Diseño Arquitectónico

**Triada fundamental**: Stakeholder tiene Preocupación (según Punto de Vista) →
resuelta por Vista arquitectónica.

**ASR** (Architectural Significant Requirement): requisito con **impacto fuerte**
en la arquitectura. Sin él, la arquitectura sería **drásticamente distinta**.
Típicamente no-funcional, pero no todo RNF es ASR.

**Árbol de Utilidad (Utility Tree)**:
```
Utilidad
├─ Atributo (Availability, Performance, etc.)
   ├─ Sub-atributo (ej. "Resiliencia ante BD down")
      └─ Escenario concreto, Prioridad (Importancia, Dificultad)
         Ej. (H,H) = crítico y difícil
```

**ADD — 7 Pasos, EN ORDEN**:
1. **Revisar entradas**: requisitos, restricciones, contexto
2. **Definir objetivos**: qué ASR refinamos esta iteración
3. **Seleccionar elementos a refinar**: qué partes del sistema
4. **Seleccionar conceptos de diseño**: patrones, referencias, techs
5. **Instanciar elementos**: responsabilidades, interfaces
6. **Bosquejar vistas**: diagramas, registrar decisiones (ADR)
7. **Analizar resultados**: ¿se cumplen ASR? ¿nuevos riesgos?

---

## CARA 2

### Clase 6 — Disponibilidad (Availability)

**Cadena causal de fallos**:
```
Fault (defecto) → Error (estado inválido) → Failure (servicio cae) → Downtime
```
Se resuelve con: Resiliencia = Detectar + Recuperar + Prevenir.

**Fórmula de disponibilidad** (memorizar):
```
Disponibilidad = MTBF / (MTBF + MTTR)
```
- **MTBF** = Mean Time Between Failures (horas sin caída, ej. 500h)
- **MTTR** = Mean Time To Repair (horas para reparar, ej. 2h)
- Para mejorar: ↑MTBF (software más confiable) OR ↓MTTR (recuperación rápida)

**Tabla SLA (downtime permitido/año)**:
| Disp. | Downtime/año |
|---|---|
| 99.0% | ~3.6 días |
| 99.9% | ~8.8 horas |
| 99.99% | ~52.6 minutos |
| 99.999% (5 nines) | ~5.3 minutos |
| 99.9999% (6 nines) | ~32 segundos |

**Tácticas de Disponibilidad — 3 Grupos**:

**A) Detectar fallo**:
- Monitoreo, ping/echo, heartbeat/watchdog
- Sanity check, votación (3+ nodos), excepciones, self-test

**B) Recuperar**:
- Redundant spare (stand-by)
- Rollback, retry
- **Graceful degradation** (funcionalidad reducida, no crash total)
- Reconfiguración, resincronización, nonstop forwarding

**C) Prevenir**:
- Dar de baja temporal (quarantine/circuit breaker)
- Transacciones (ACID, 2PC)
- **SAGA** (transacción distribuida compensatoria)
- Modelo predictivo, excepciones, incrementar estados competentes

**Redundancia — 3 Niveles**:
| Tipo | Nodos activos | Sincronización | Costo | Disponibilidad |
|---|---|---|---|---|
| **Activa (hot)** | Todos, constantemente | Sync frecuente | Alto | Alta (sin lag) |
| **Pasiva (warm)** | Subconjunto + standby | Parcial | Medio | Media (lag corto) |
| **Repuesto (cold)** | Apagados, se encienden al fallo | Ninguna | Bajo | Baja (lag largo) |

**Patrones de Disponibilidad principales**:
- **Redundancia activa** (hot spare): todas las instancias activas, datos sincronizados
- **Redundancia pasiva** (warm spare): una activa, una en standby sincronizándose
- **TMR** (Triple Modular Redundancy): 3+ sistemas idénticos, gana la mayoría (votación)
- **Circuit Breaker**: monitor limita reintentos fallidos, evita cascada (herr. Resilience4j)

**⚠️ NOTA CRÍTICA**: Rolling Upgrade, Blue/Green, Canary, A/B Testing son patrones de
**DESPLEGABILIDAD (Clase 7)**, NO de Disponibilidad.

---

### Clase 7 — Desplegabilidad (Deployability)

**Ambiente de despliegue** (5 ambientes, en orden):
```
Development → Repo código → Integration → Staging → Production
```
Patrón: Shadow (replica) → Monitoreo → Reintroducción.

**Calidad del pipeline**:
- **Cycle Time**: spec → producción (meta: corto, ej. < 1 día)
- **Trazabilidad**: quién desplegó qué cuándo (auditoría)
- **Repetibilidad**: mismo script, mismo resultado (automatización)

**Tácticas de Desplegabilidad — 2 Grupos**:

**A) Administrar el pipeline**:
- Scaled Rollouts (despliegues graduales)
- Scripts de despliegue (automatización)
- Rollback (revertir a versión anterior)

**B) Administrar sistema desplegado**:
- Manage Service Interactions: service registry, traffic splitting, circuit breaker
- Package Dependencies: contenedores (Docker), VMs
- Feature Toggle (Kill Switch): encender/apagar features sin redeploy

**Patrones de reemplazo** (4 patrones principales):
| Patrón | Instancias | Downtime | Cuándo usar |
|---|---|---|---|
| **Blue/Green** | 2 sets completos (A↔B) | Ninguno (corte tráfico instantáneo) | Cambio atómico, reversión rápida |
| **Rolling Upgrade** | N+1 (gradual, una por una) | Ninguno (gradual) | Economía, menos recursos |
| **Canary** | Subconjunto usuarios reales | — | Validar en producción antes de liberar |
| **A/B Testing** | A vs B, ambos en paralelo | — | Elegir ganador comparando métricas |

**Distinciones críticas** (errores comunes en examen):
- **Canary**: probar CON usuarios reales antes de liberar a todos (validación, seguridad)
- **A/B Testing**: comparar dos versiones para ELEGIR cuál se queda (experimento negocio)
- **Rolling Upgrade**: reemplazo **gradual** (N+1 instancias, una cae, otra sube)
- **Blue/Green**: reemplazo **atómico** (dos sets completos, switch instantáneo)

**Estructuración de servicios para Desplegabilidad independiente**:
- Empaquetar dependencias (contenedores + librerías)
- Administrar interacciones (service registry, API versioning)
- Sin acoplamiento de despliegue (cada servicio despliega solo)
