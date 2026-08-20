# Cronograma — Sistema Integral de Gestión de Eventos

Planificación semanal completa del proyecto, desde la formación del equipo
(31 de julio de 2026) hasta el último día de semestre (28 de noviembre de
2026). Equipo de **4 integrantes**.

> ⚠️ **Supuestos a confirmar con el profesor.** Ninguna diapositiva revisada
> (clases 1 a 14) menciona fechas oficiales de Entrega 1, Entrega 2, primer
> parcial ni segundo parcial. Las fechas marcadas como **(tentativa)** en
> este documento son propuestas del equipo para poder planear, no fechas
> confirmadas por el profesor — ajustarlas en cuanto se anuncien las reales.
> La única fecha dura conocida es el **28 de noviembre de 2026** (último día
> de semestre, dato dado por el equipo), a partir de la cual se calculó
> hacia atrás el resto del cronograma.
>
> También se asume que la clase se dicta **2 veces por semana** (según lo
> confirmado por el equipo), en un patrón tipo martes/viernes que calza con
> las fechas de exportación de diapositivas ya vistas en `Work/Slides/`.
> Si los días reales de clase son otros, correr las fechas de "Clase" de
> cada fila sin cambiar la semana a la que pertenecen.
>
> El syllabus (Clase 1) pide grupos de **5 a 7 personas**; este equipo tiene
> 4. Si eso no ha sido validado explícitamente con el profesor, es un punto
> a confirmar — puede implicar que cada integrante deba asumir más de los
> "mínimo 5 casos de uso" indicados por persona.

## Cómo leer este documento

- **Clase / tema**: lo que dicta el profesor ese día (según `Work/Notes/`).
- **Entregable/ejercicio de la diapositiva**: lo que la diapositiva de esa
  clase pide explícitamente hacer (si lo pide).
- **Trabajo interno del equipo**: lo que el equipo debe producir esa semana
  para no atrasarse con Entrega 1 / Entrega 2, aunque la diapositiva no lo
  pida de forma literal.
- **Responsable(s)**: a qué integrante(s) se le asigna la tarea. Los
  integrantes se numeran **I1–I4**; reemplazar por los nombres reales del
  equipo.

### Reparto fijo de atributos de calidad (I1–I4)

Para no duplicar esfuerzo, cada integrante es "dueño" de investigar tácticas
y patrones de 2–3 atributos de calidad (además de su propio prototipo y sus
≥5 casos de uso). Sus hallazgos alimentan el Utility Tree, la Bitácora y el
SAD compartido:

| Integrante | Atributos de calidad a cargo |
|---|---|
| **I1** | Availability, Deployability |
| **I2** | Performance, Modifiability |
| **I3** | Integrabilidad, Safety, Testability |
| **I4** | Security, Usability |

---

## Resumen de hitos

| Hito | Fecha | Estado |
|---|---|---|
| Formación del equipo + 2 ideas de proyecto | 31 jul 2026 | ✅ hecho |
| Propuesta arquitectónica (QA priorizados, componentes, conexiones) | 18 ago 2026 | ✅ submitted |
| Diagramas C4 completos (6 diagramas + checklist) | 20 ago 2026 | ✅ submitted |
| Bitácora Arquitectónica creada (registro permanente) | 18 ago 2026 | ✅ en curso, continuo |
| Listado de casos de uso (25 CU, spreadsheet) | 20 ago 2026 | ✅ submitted |
| Utility Tree formal + tácticas de disponibilidad (Clase 6) | 28 ago 2026 (tentativa) | ⬜ pendiente |
| Primer Parcial | 25 sep 2026 (tentativa) | ⬜ pendiente |
| **Entrega 1 (SAD v1, 15%)** | **9 oct 2026 (tentativa)** | ⬜ pendiente |
| Segundo Parcial | 6 nov 2026 (tentativa) | ⬜ pendiente |
| **Entrega 2 (prototipo + SAD v2, 25%)** | **20 nov 2026 (tentativa — 1 semana antes del fin de semestre)** | ⬜ pendiente |
| Sustentaciones | 24–27 nov 2026 (tentativa) | ⬜ pendiente |
| Fin de semestre | **28 nov 2026 (dato confirmado)** | — |

---

## Semana a semana

### Semana 1 · 27 jul – 2 ago ✅ completada

| Clase / tema | Entregable/ejercicio de la diapositiva | Trabajo interno del equipo | Responsable(s) |
|---|---|---|---|
| **Clase 1** (vie 31 jul) — Introducción al curso y reglas | Formar equipo + diligenciar formulario de inscripción. Definir 2 ideas de proyecto con listado de CU y justificación de complejidad. | Equipo formado. Idea elegida: "Sistema Integral de Gestión de Eventos". | Todos |

---

### Semana 2 · 3 – 9 ago ✅ completada

| Clase / tema | Entregable/ejercicio de la diapositiva | Trabajo interno del equipo | Responsable(s) |
|---|---|---|---|
| **Clase 2** (mar 4 ago) — Introducción a la Arquitectura de Software | Priorizar atributos de calidad (alta/media/baja), definir componentes/conexiones principales, explicar cómo la arquitectura los satisface. | Arranque de `ArchitecturalProposal.tex`. | Todos |
| **Clase 3** (vie 7 ago) — Proceso de software y arquitectura | Mismo ejercicio que Clase 2, reforzado. | Continuar propuesta arquitectónica. | Todos |

---

### Semana 3 · 10 – 16 ago ✅ completada

| Clase / tema | Entregable/ejercicio de la diapositiva | Trabajo interno del equipo | Responsable(s) |
|---|---|---|---|
| **Clase 4** (mar 11 ago) — Notación y vistas arquitectónicas | Elaborar **todos** los diagramas C4 (Context, Container, Component, System Landscape, Dynamic, Deployment) y validarlos contra el checklist oficial. | Iniciar `C4Diagrams.tex`. | Todos |
| **Clase 5** (vie 14 ago) — Proceso de diseño arquitectónico 1 | Crear y mantener permanentemente una **Bitácora Arquitectónica**. | Crear `Work/BitacoraArquitectonica.md`; migrar decisiones ya tomadas. | Todos |

---

### Semana 4 · 17 – 23 ago 🔶 en curso (hoy: 20 ago)

| Clase / tema | Entregable/ejercicio de la diapositiva | Trabajo interno del equipo | Responsable(s) |
|---|---|---|---|
| **Clase 6** (mar 18 ago) — Availability | Identificar tácticas y patrones relevantes para los escenarios de disponibilidad del proyecto. | Documentar tácticas (redundancia, ping/echo, heartbeat, failover, load balancing) aplicadas a los componentes ya definidos en `ArchitecturalProposal.tex`. Registrar en la Bitácora. | **I1** |
| **Clase 7** (vie 21 ago) — Deployability | Sin ejercicio explícito en la diapositiva. | Revisar cómo se desplegará el sistema (CI/CD, ambientes dev/test/prod) — insumo directo para el script de despliegue automatizado de Entrega 2. | **I1** |
| — | — | ✅ *Ya completado esta semana*: `C4Diagrams.tex` ampliado a los 6 diagramas y resubmitido (20 ago); spreadsheet de 25 casos de uso (CU-001..CU-025) submitted (20 ago); `Summary.tex` submitted (20 ago). | Todos |

---

### Semana 5 · 24 – 30 ago

| Clase / tema | Entregable/ejercicio de la diapositiva | Trabajo interno del equipo | Responsable(s) |
|---|---|---|---|
| **Clase 8** (mar 25 ago) — Performance | Sin ejercicio explícito. | Identificar tácticas de performance (caching, priorización de recursos, balanceo de carga) para los CU de alta concurrencia (ej. venta de entradas). | **I2** |
| **Clase 9** (vie 28 ago) — Modifiability | Sin ejercicio explícito. | Revisar modularidad del diseño actual: acoplamiento entre componentes, puntos de extensión. | **I2** |
| Trabajo de equipo transversal | — | Formalizar el **Utility Tree** (Clase 5) con escenarios priorizados (H,H)/(H,M)/etc. para los atributos ya cubiertos (Availability, Performance, Modifiability). Actualizar Bitácora. | Todos (cada uno aporta sus atributos) |

---

### Semana 6 · 31 ago – 6 sep

| Clase / tema | Entregable/ejercicio de la diapositiva | Trabajo interno del equipo | Responsable(s) |
|---|---|---|---|
| **Clase 10** (mar 1 sep) — Integrabilidad | Sin ejercicio explícito. | Revisar integraciones externas del sistema (pasarelas de pago, notificaciones, sistemas de terceros) y cómo se exponen/consumen. | **I3** |
| **Clase 11** (vie 4 sep) — Safety | Sin ejercicio explícito (baja relevancia si el sistema no es crítico/embebido — confirmar). | Evaluar si aplica algún escenario de safety real (ej. aforo máximo en eventos presenciales) o justificar por qué no aplica. | **I3** |
| Trabajo de equipo transversal | — | Empezar la selección de casos de uso complejos por integrante para el prototipo de Entrega 1 (uno por persona, con QA no triviales). | Todos |

---

### Semana 7 · 7 – 13 sep

| Clase / tema | Entregable/ejercicio de la diapositiva | Trabajo interno del equipo | Responsable(s) |
|---|---|---|---|
| **Clase 12** (mar 8 sep) — Security | Sin ejercicio explícito. | Verificar que RBAC/autenticación/autorización ya descritos en `ArchitecturalProposal.tex` cubran confidentiality/integrity/availability de forma explícita. | **I4** |
| **Clase 13** (vie 11 sep) — Testability | Sin ejercicio explícito. | Definir estrategia de pruebas (unitarias, integración, aceptación) que se usará en el prototipo — insumo para "estándares de programación" de Entrega 2. | **I3** |
| Trabajo de equipo transversal | — | Empezar setup técnico: repositorio de código, estándares de programación, estructura del proyecto. | Todos |

---

### Semana 8 · 14 – 20 sep

| Clase / tema | Entregable/ejercicio de la diapositiva | Trabajo interno del equipo | Responsable(s) |
|---|---|---|---|
| **Clase 14** (mar 15 sep) — Usability | Sin ejercicio explícito (enfoque distinto: Five Planes Framework de Garrett). | Revisar la experiencia de usuario de los flujos más visibles (compra de entrada, check-in con QR) contra el framework visto. | **I4** |
| (vie 18 sep) — contenido aún no publicado en Teams | — | **Buffer**: consolidar hallazgos de tácticas de QA (semanas 4–8) en el Utility Tree y en `ArchitecturalProposal.tex`. | Todos |
| Trabajo de equipo transversal | — | Empezar PoCs (pruebas de concepto en código) para los 2–3 desafíos técnicos más complejos identificados (ej. escalabilidad de ventas concurrentes, generación/validación de QR). | I1 + I2 (o según el desafío) |

---

### Semana 9 · 21 – 27 sep

| Clase / tema | Entregable/ejercicio de la diapositiva | Trabajo interno del equipo | Responsable(s) |
|---|---|---|---|
| Contenido aún no publicado (probable continuación del proceso de diseño arquitectónico) | — | Continuar PoCs. Empezar prototipo funcional de los CU complejos individuales. | Todos (cada uno su CU) |
| **Primer Parcial** (tentativa, vie 25 sep) | — | Repasar clases 1–14. | Todos |

---

### Semana 10 · 28 sep – 4 oct

| Clase / tema | Entregable/ejercicio de la diapositiva | Trabajo interno del equipo | Responsable(s) |
|---|---|---|---|
| Contenido aún no publicado | — | Cerrar PoCs. Terminar prototipo funcional individual (CU complejo + QA implementados hasta ahora). Redactar sección de Entrega 1: "listado de CU + QA a implementar en la entrega final". | Todos |
| Trabajo de equipo transversal | — | Ensamblar el documento de Entrega 1 (SAD v1: CU + RNF, ASR, diseño arquitectónico, PoCs, prototipo, compromiso de alcance para Entrega 2). | Todos |

---

### Semana 11 · 5 – 11 oct

| Clase / tema | Entregable/ejercicio de la diapositiva | Trabajo interno del equipo | Responsable(s) |
|---|---|---|---|
| Contenido aún no publicado | — | Revisión final y compilación del SAD v1. | Todos |
| **🎯 Entrega 1 — SAD v1 (15%)** (tentativa, **vie 9 oct**) | — | **Entregar**: especificación de CU y RNF · ASR · diseño arquitectónico · PoCs de los desafíos técnicos más complejos · prototipo funcional de los CU más complejos por integrante · listado de CU/QA comprometidos para Entrega 2 (sujeto a aprobación del profesor). | Todos |

---

### Semana 12 · 12 – 18 oct

| Clase / tema | Entregable/ejercicio de la diapositiva | Trabajo interno del equipo | Responsable(s) |
|---|---|---|---|
| Contenido aún no publicado | — | Recibir retroalimentación de Entrega 1. Ajustar alcance comprometido si el profesor lo pide. Iniciar implementación completa del prototipo (todos los CU comprometidos, no solo los complejos). | Todos |

---

### Semana 13 · 19 – 25 oct

| Clase / tema | Entregable/ejercicio de la diapositiva | Trabajo interno del equipo | Responsable(s) |
|---|---|---|---|
| Contenido aún no publicado | — | Desarrollo del prototipo funcional completo (cada integrante sus CU asignados). | Todos |

---

### Semana 14 · 26 oct – 1 nov

| Clase / tema | Entregable/ejercicio de la diapositiva | Trabajo interno del equipo | Responsable(s) |
|---|---|---|---|
| Contenido aún no publicado | — | Continuar desarrollo. Empezar script de despliegue automatizado (descarga de código, configuración de componentes, corrida de pruebas, despliegue). | **I1** (deployability) + apoyo de todos |

---

### Semana 15 · 2 – 8 nov

| Clase / tema | Entregable/ejercicio de la diapositiva | Trabajo interno del equipo | Responsable(s) |
|---|---|---|---|
| **Segundo Parcial** (tentativa, vie 6 nov) | — | Repasar contenido posterior al primer parcial. | Todos |
| Trabajo de equipo transversal | — | Continuar desarrollo del prototipo + pruebas de cada QA comprometido. | Todos |

---

### Semana 16 · 9 – 15 nov

| Clase / tema | Entregable/ejercicio de la diapositiva | Trabajo interno del equipo | Responsable(s) |
|---|---|---|---|
| Contenido aún no publicado | — | Terminar implementación funcional. Redactar SAD v2 (mejoras de diseño arquitectónico + resultados de validación de atributos de calidad). Terminar y probar el script de despliegue automatizado. | Todos |

---

### Semana 17 · 16 – 22 nov

| Clase / tema | Entregable/ejercicio de la diapositiva | Trabajo interno del equipo | Responsable(s) |
|---|---|---|---|
| Buffer de cierre | — | Pruebas finales end-to-end del prototipo desplegado por script. Compilar código documentado, estándares de programación, historial de cambios actualizado. | Todos |
| **🎯 Entrega 2 — Prototipo + SAD v2 (25%)** (tentativa, **vie 20 nov** — 1 semana antes del fin de semestre) | — | **Entregar**: prototipo funcional completo de los CU/QA comprometidos · código documentado en repositorio (Git) · script de despliegue automatizado · SAD v2 con resultados de validación. | Todos |

---

### Semana 18 · 23 – 29 nov

| Clase / tema | Entregable/ejercicio de la diapositiva | Trabajo interno del equipo | Responsable(s) |
|---|---|---|---|
| **Sustentaciones** (tentativa, 24–27 nov) | — | ~1h por grupo, contenido libre: requisitos/diseño/implementación/pruebas + demo (cada integrante demuestra su parte). Empezar puntual. | Todos |
| **Fin de semestre** — **sáb 28 nov 2026** | — | — | — |

---

## Checklist consolidado — Entrega 1 (SAD v1, 15%)

- [ ] Especificación de casos de uso y requisitos no funcionales.
- [ ] Requisitos Arquitectónicamente Significativos (ASR) — apoyados en el
      Utility Tree.
- [ ] Diseño arquitectónico (actualizado con tácticas de QA vistas en clases
      6–14).
- [ ] Pruebas de concepto (código) de los 2–3 desafíos técnicos más
      complejos.
- [ ] Prototipo funcional del CU más complejo de cada integrante,
      implementando los atributos de calidad vistos hasta ese momento.
- [ ] Listado de CU + atributos de calidad a implementar en Entrega 2
      (sujeto a aprobación del profesor).

## Checklist consolidado — Entrega 2 (prototipo + SAD v2, 25%)

- [ ] Prototipo funcional completo de los CU + QA comprometidos en
      Entrega 1.
- [ ] SAD v2: mejoras de diseño arquitectónico + resultados de validación.
- [ ] Código documentado, siguiendo estándares de programación.
- [ ] Código fuente en repositorio (Git).
- [ ] Script de despliegue automatizado (descarga código, configura
      componentes, corre pruebas, despliega).

## Pendientes de este cronograma

- [ ] Confirmar con el profesor las fechas reales de Entrega 1, Entrega 2,
      primer y segundo parcial, y sustentaciones — reemplazar todas las
      fechas "(tentativa)" de este documento.
- [ ] Confirmar si el equipo de 4 personas requiere aprobación explícita del
      profesor frente al mínimo de 5–7 del syllabus.
- [ ] Reemplazar **I1–I4** por los nombres reales del equipo en la tabla de
      reparto de atributos de calidad.
- [ ] Actualizar este cronograma cada vez que se publique una diapositiva
      nueva en `Work/Slides/` (correr `slides-analyst`) o se confirme una
      fecha oficial — ver `TASKS.md`.
