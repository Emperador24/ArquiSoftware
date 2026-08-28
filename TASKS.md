# Tasks — Sistema Integral de Gestión de Eventos

Tracks the deliverables for the Software Architecture project. Update this file
whenever a new assignment is given, a task's status changes, or a deliverable
is submitted.

Status values: `todo`, `in-progress`, `done`, `submitted`.

## Course grading (from Clase 1 — Introducción al curso y reglas)

| Componente | % |
|---|---|
| Primer Parcial | 20% |
| Segundo Parcial | 20% |
| Tareas, Quices, Laboratorios | 20% |
| Proyecto — Entrega 1 (SAD v1) | 15% |
| Proyecto — Entrega 2 (prototipo + SAD v2) | 25% |

Full rules (late-submission penalty, exam device policy, team rules, LLM-use
policy, etc.) are in `Work/Notes/01. AS - Introducción al curso y reglas.md`.

## Cronograma

Full week-by-week schedule (team of 4, work started 2026-07-31) is in
[`Cronograma.md`](./Cronograma.md) — covers what each slide deck (Clase
1–14) asks for, the quality-attribute ownership split across the 4 team
members, and internal milestones leading up to Entrega 1 and Entrega 2.

**⚠️ No official dates for Entrega 1, Entrega 2, parciales, or
sustentaciones appear in any slide deck reviewed so far (Clases 1–14).**
The dates below are the team's own tentative planning, anchored only on the
one confirmed fact — semester end is **2026-11-28** — with Entrega 2 placed
one week before that. Replace them as soon as the professor confirms real
dates (update both here and in `Cronograma.md`).

| Hito | Fecha (tentativa salvo donde se indica) |
|---|---|
| Utility Tree formal + tácticas de disponibilidad (Clase 6) | 2026-08-28 |
| Primer Parcial | 2026-09-25 |
| **Entrega 1 (SAD v1, 15%)** | **2026-10-09** |
| Segundo Parcial | 2026-11-06 |
| **Entrega 2 (prototipo + SAD v2, 25%)** | **2026-11-20** |
| Sustentaciones | 2026-11-24 a 2026-11-27 |
| Fin de semestre | **2026-11-28 (confirmado)** |

## Repositorio de código (HEXACORE)

Repos de código del proyecto — separados de este repo (`ArquiSoftware`),
que solo contiene el diseño/SAD en LaTeX:
- **Código**: https://github.com/Emperador24/HEXACORE
- **Bitácora** (repo aparte; su relación exacta con
  `Work/BitacoraArquitectonica.md` de este repo quedó sin aclarar del todo
  con el usuario — confirmar si reemplaza al archivo local o es otra cosa):
  https://github.com/Emperador24/Bitacora-Hexacore

**Flujo de ramas en HEXACORE** (decidido 2026-08-27):
- `main` — solo recibe merges desde `develop` cuando está estable; nunca
  push directo.
- `develop` — rama de integración, donde llega el trabajo de todos antes de
  pasar a `main`.
- Cada integrante trabaja en su propia rama `feature/<nombre>-<algo>`
  creada desde `develop`, y la sube a `develop` vía Pull Request (no push
  directo a `develop` tampoco).

**Repos personales de PoC** (fuera de HEXACORE): cada integrante mantiene
además su propio repo personal, aparte del proyecto, para probar una
táctica o patrón de forma aislada (p. ej. cómo funciona Circuit Breaker, o
redundancia con Redis Sentinel) antes de llevarla al PoC real dentro de
HEXACORE. No se entregan ni se referencian en el SAD — son solo para
aprender la técnica antes de implementarla en el proyecto.

## Deliverables

| Task | File(s) | Status | Due | Notes |
|---|---|---|---|---|
| Project summary | Work/Summary.tex → Submission/Summary.pdf | submitted (2026-08-20) | — | Compiled, no LaTeX errors. Fixed stale CU-016..CU-020 references (2026-08-20) to match the use-case renumbering — they're actually CU-006..CU-010. |
| Defense study guide | Defense/DefenseGuide.tex → Defense/DefenseGuide.pdf | done (2026-08-20) | — | **Not a course deliverable** — personal prep material explaining every file in `Submission/` for the oral sustentación, with anticipated professor questions and known weak points. Regenerate when `Submission/` changes meaningfully. |
| Architectural proposal | Work/ArchitecturalProposal.tex → Submission/ArchitecturalProposal.pdf | submitted (2026-08-18) | — | Compiled, no LaTeX errors. Re-checked 2026-08-20 against the Clase 2/3 exercise (prioritize QA alta/media/baja, define components/connections, explain how the architecture satisfies each QA) — already covers all three explicitly, no changes needed. **2026-08-25**: expanded § "Disponibilidad — Alta" with the Clase 6 (Availability) exercise — a table mapping 6 concrete availability scenarios to Bass/Kazman tactics (detection/recovery/prevention) and patterns (active/passive redundancy, Circuit Breaker); recompiled clean (17 pages) and re-copied to `Submission/`. |
| C4 diagrams | Work/C4Diagrams.tex → Submission/C4Diagrams.pdf | submitted (2026-08-22) | — | Covers all 6 C4 diagrams (Context, Container, Component, System Landscape, Sequence, Deployment) per the Clase 4 exercise; Level 4/Code deliberately excluded with justification. **2026-08-22: rebuilt per professor feedback** — all 6 diagrams remade in draw.io (app.diagrams.net, not tikz) with name + type/technology + short description on every box, and the Dynamic diagram replaced with a UML sequence diagram (lifelines, numbered messages, activation bar) for CU-006. **Same day, follow-up fix**: initial export was low-resolution (viewport screenshot) and text was unreadable once scaled into the PDF — switched to draw.io's native PNG export (250% zoom) + system clipboard + `osascript` extraction, giving real 3500–5000px-wide images; verified sharp at 300 DPI. Source `.drawio` files + exported PNGs in `Work/Diagrams/`. Checklist section updated to match. Compiled clean, 16 pages. |
| Bitácora Arquitectónica | Work/BitacoraArquitectonica.md | in-progress (ongoing) | continuous | **New required deliverable** (from Clase 5): a permanently-updated log of meetings, design decisions, architectural changes, analyses, and PoCs. Created 2026-08-18; foundational decisions from ArchitecturalProposal.tex migrated in as a dated entry on 2026-08-20 (with alternatives/risks). Keep adding to it all semester — it's graded as part of the process, not a one-time submission. |
| Use-case spreadsheet | Submission/CU_eventos_completo.xlsx | submitted (2026-08-20) | — | **32 use cases** (CU-001..CU-032, up from 25): added CU-026..CU-032 to cover missing CRUD/admin gaps (Eventos, Cuentas de Usuario, Roles y Permisos, Recintos y Zonas, Proveedores, Pagos y Conciliación Financiera, Reportes y Analítica). The `Autor` field on all 32 sheets is set to the real owner (Daniel Cristancho, Samuel Emperador, Sebastián Sánchez, Diego Coronado — see `Work/DistribucionCasosUso.pdf`). The CU-021..CU-032 ownership split (proposed by the assistant) was confirmed with the team by the user on 2026-08-20. Known pre-existing issue still open: CU-013/CU-015 internal-Id mismatch, documented in the Bitácora. |
| **Entrega 1 (SAD v1)** | Work/ArchitecturalProposal.tex + Bitácora + PoCs + prototipo individual → Submission/ | todo | 2026-10-09 (tentative) | Full checklist in `Cronograma.md` § "Checklist consolidado — Entrega 1". Needs: CU + RNF spec, ASR (Utility Tree), diseño arquitectónico, PoCs de desafíos técnicos, prototipo del CU más complejo por integrante, listado de CU/QA comprometidos para Entrega 2. |
| SAD (arc42 template) — v1 draft | Work/DescripcionArquitecturaSoftware.tex | in-progress (2026-08-25) | 2026-10-09 (tentative, folds into Entrega 1) | **First draft assembled 2026-08-25**, consolidating existing material into the course's arc42-based SAD template: intro, 32-CU functional overview, domain concept table, stakeholders, a first-cut Utility Tree (ASR-01..ASR-10), constraints, all 6 C4 views (context/container/component/process/physical, embedding `Diagrams/*.png`), 4 ADRs derived from the founding decisions already in the Bitácora, a technical-risk table, glossary, and references. Compiles clean (19 pages). Left explicitly pending (marked `[Pendiente: ...]` inline, not yet real content): full domain UML class diagram, component breakdown for the other 3 containers (only CU-006's is done), dev/test deployment diagrams (only prod exists), and per-service ER data models. Not yet copied to `Submission/` — still a draft, not the finished Entrega 1 deliverable. |
| **Entrega 2 (prototipo + SAD v2)** | Full repo + deploy script → Submission/ | todo | 2026-11-20 (tentative — 1 week before semester end) | Full checklist in `Cronograma.md` § "Checklist consolidado — Entrega 2". Needs: prototipo funcional completo, SAD v2 con resultados de validación, código documentado en Git, script de despliegue automatizado. |

| Distribución de casos de uso | Work/DistribucionCasosUso.tex → Submission/DistribucionCasosUso.pdf | done (2026-08-20) | — | **Not a course deliverable** — internal team reference PDF listing the 32 CU grouped by owner (Daniel Cristancho, Samuel Emperador, Sebastián Sánchez, Diego Coronado), 8 each, with name + description per CU. Owner names + CU-001..CU-020 assignment given directly by the user; CU-021..CU-032 split proposed by the assistant into contiguous thematic blocks, **confirmed with the team by the user on 2026-08-20**. Regenerate if CU are added/reassigned. |

## Backlog / new tasks

_(Add new tasks here as they're assigned, e.g. from the course syllabus or professor's instructions.)_

- [x] **Confirm project/team status vs. syllabus.** Clase 1's slides list
      "tareas urgentes para la próxima clase": form the 5–7 person team via a
      Google Form (link in `Work/Notes/01...md`) and define **two** possible
      project ideas with full use-case listings + complexity justification.
      This repo already has substantial work on one idea ("Sistema Integral
      de Gestión de Eventos"), so this is likely already done in real life —
      but flagging it since the slides describe it as an early-semester
      step. Confirm the team is formed and the idea is approved by the
      professor, and note it here once confirmed.
- [x] **Complete the C4 diagram set.** Clase 4's exercise asks to elaborate
      *all* C4 diagrams and validate each against the official checklist
      (https://c4model.com/diagrams/checklist). Done 2026-08-20: added System
      Landscape, Dynamic, and Deployment diagrams to `Work/C4Diagrams.tex`
      (Context/Container/Component already existed); fixed a stale CU-016→
      CU-006 reference left over from before the use-case renumbering;
      rewrote the checklist section against every official item; recompiled
      clean (16 pages) and re-submitted the PDF.
- [x] **Strengthen ASR justification with a Utility Tree.** Clase 5 teaches
      the Utility Tree technique (Quality Attribute → refinement →
      prioritized scenario, e.g. (H,H)) for justifying which requirements are
      architecturally significant. `Work/ArchitecturalProposal.tex` lists
      prioritized quality attributes but doesn't use this explicit
      scenario-tree format — consider adding one for the highest-priority
      attributes. (This was a suggestion inferred from Clase 5's material,
      not the literal graded "Ejercicio" slide of that class — the literal
      exercise, the Bitácora, is done. Still worth doing to strengthen the
      SAD. Briefly marked done on `main` directly on 2026-08-20, then
      reverted to pending after confirming with the user that the Utility
      Tree work hasn't actually been done yet. **Re-checked 2026-08-22**
      while reviewing everything asked in Clases 1–5 end-to-end — still the
      only open item from that range; every other Clase 1–5 exercise
      (team/idea confirmation, QA prioritization in
      `ArchitecturalProposal.tex`, the full C4 set, the Bitácora) is done.
      **Done 2026-08-25**: a first-cut Utility Tree (ASR-01..ASR-10) is now
      in `Work/DescripcionArquitecturaSoftware.tex` § "Requisitos
      Arquitectónicamente Significativos (ASR)", derived from the 10
      prioritized QA in `ArchitecturalProposal.tex` mapped to concrete CU
      scenarios. Team should review/adjust before Entrega 1.)
- [x] Migrate the architectural decisions already in
      `Work/ArchitecturalProposal.tex` ("Resumen de decisiones
      arquitectónicas") into a dated entry in `Work/BitacoraArquitectonica.md`,
      including alternatives considered and risks. Done 2026-08-20.
- [x] **Ejercicio de clase 06 (Availability) — aplicar tácticas y patrones
      de Disponibilidad al proyecto.** Última diapositiva de
      `Work/Slides/06. Availability.pdf`: "Identifique tácticas y patrones
      relevantes para los escenarios de Disponibilidad identificados en su
      proyecto." No se especifica fecha límite ni si debe ir en el SAD,
      `Work/ArchitecturalProposal.tex`, o la Bitácora — se recomienda
      resolverlo en la Bitácora Arquitectónica (registrar el análisis) y,
      si aplica, reflejar tácticas/patrones elegidos en
      `ArchitecturalProposal.tex`. Ver detalle en
      `Work/Notes/06. Availability.md`.
      **Hecho 2026-08-25**: se identificaron 6 escenarios de disponibilidad
      del proyecto (falla de instancia de validación QR, picos en apertura
      de venta, caída del API Gateway, indisponibilidad de la pasarela de
      pagos, falla del proveedor de notificaciones en emergencia, falla del
      nodo Redis del bloqueo de reventa) y se les aplicó el catálogo de
      tácticas (detección/recuperación/prevención) y patrones (redundancia
      activa/pasiva, Circuit Breaker) de Bass/Kazman. Documentado en detalle
      en la Bitácora (entrada del 2026-08-25) y reflejado en
      `Work/ArchitecturalProposal.tex` § "Disponibilidad — Alta" con una
      tabla escenario/estímulo-respuesta/tácticas/patrón. Recompilado sin
      errores (17 páginas) y re-copiado a
      `Submission/ArchitecturalProposal.pdf`.
      **2026-08-27**: se agregó `Work/AnalisisDisponibilidad-TacticasPatrones.md`,
      un documento de trabajo **informal** (no LaTeX, no va a `Submission/`)
      que repasa el catálogo completo de Bass/Kazman contra los 6 escenarios
      — no solo lo finalmente elegido, sino qué otras tácticas/patrones se
      consideraron y por qué se descartaron, qué partes del catálogo el
      proyecto no usa todavía en ningún escenario, y 5 preguntas abiertas
      para el equipo (persistencia de la fila virtual, nombrar SAGA
      explícitamente, caída total del Gateway por mala config, rollback de
      compra a mitad de failover de Redis, ack de notificaciones). Sirve de
      respaldo para la sustentación y como checklist antes de Entrega 1.
- [ ] **Revisar clases 07–14 (Deployability, Performance, Modifiability,
      Integrabilidad, Safety, Security, Testability, Usability) — ningún
      "Ejercicio" explícito encontrado**, a diferencia de la clase 06. No
      hay fechas de Entrega 1/Entrega 2/sustentación mencionadas en ninguna
      de estas 9 clases. Sugerencia (no confirmada por el profesor): dado
      el patrón de la clase 06, es razonable esperar que en algún momento
      se pida el mismo ejercicio (aplicar tácticas/patrones al proyecto)
      para los demás atributos de calidad — vale la pena preguntar en clase
      o revisar si aparece en una diapositiva posterior no capturada aún.
      Ver notas individuales en `Work/Notes/07...md` a `Work/Notes/14...md`.
- [ ] **Revisar cobertura de Seguridad en el SAD.** La clase 12 (Security)
      cubre en detalle autenticación/autorización (RBAC/DAC/MAC), cifrado
      de datos, validación de entradas y no repudiación — vale la pena
      confirmar que `Work/ArchitecturalProposal.tex` mencione
      explícitamente estos mecanismos para el manejo de usuarios/pagos del
      proyecto. Sugerencia, no un ejercicio confirmado del profesor.
- [ ] **Revisar y validar los 7 casos de uso nuevos (CU-026 a CU-032).**
      Añadidos 2026-08-20 a `Submission/CU_eventos_completo.xlsx` para
      cerrar huecos de CRUD que no tenían caso de uso propio: Gestión de
      Eventos, Cuentas de Usuario, Roles y Permisos, Recintos y Zonas,
      Proveedores, Pagos y Conciliación Financiera, Reportes y Analítica.
      Pendiente: ~~(1) actualizar el campo "Autor"~~ hecho 2026-08-20 (las
      32 hojas ya tienen el dueño real, no `Hexacore`); ~~(3) confirmar con
      el equipo el reparto CU-021..CU-032~~ hecho 2026-08-20 (el usuario
      confirmó con el equipo). Sigue pendiente: (2) revisar si
      `Work/ArchitecturalProposal.tex` y los diagramas C4 necesitan
      reflejar nuevos microservicios/entidades (p. ej. Recintos, Roles) que
      estos CU asumen. Detalle completo en la Bitácora.
- [x] **Crear cronograma completo del proyecto.** `Cronograma.md` creado
      2026-08-20: planificación semana a semana desde 2026-07-31 hasta
      2026-11-28 (fin de semestre, dato confirmado por el equipo), con lo
      que pide cada diapositiva (Clases 1–14), reparto de atributos de
      calidad entre los 4 integrantes (I1–I4, pendiente reemplazar por
      nombres reales), y checklists de Entrega 1/Entrega 2. Todas las
      fechas salvo el fin de semestre son tentativas — confirmar con el
      profesor y actualizar tanto `Cronograma.md` como la tabla de "Fechas
      clave" arriba en este archivo.

## Workflow

1. Work happens in `Work/` (LaTeX sources and drafts).
2. When a deliverable is finished and ready to hand in, compile it and place
   the final file(s) in `Submission/`, then set its status to `submitted`
   here (with the date).
3. When a new assignment comes up, add a row to **Deliverables** (or an item
   to **Backlog**) instead of just doing the work ad hoc, so the project
   stays trackable across sessions.
4. Export class slides from Microsoft Teams into `Work/Slides/` (PDF
   preferred). Running the `slides-analyst` agent reads them, writes notes to
   `Work/Notes/`, and adds any assignments/deadlines it finds here
   automatically — check the Backlog after running it.
