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

## Deliverables

| Task | File(s) | Status | Due | Notes |
|---|---|---|---|---|
| Project summary | Work/Summary.tex → Submission/Summary.pdf | submitted (2026-08-18) | — | Compiled, no LaTeX errors. |
| Architectural proposal | Work/ArchitecturalProposal.tex → Submission/ArchitecturalProposal.pdf | submitted (2026-08-18) | — | Compiled, no LaTeX errors. Re-checked 2026-08-20 against the Clase 2/3 exercise (prioritize QA alta/media/baja, define components/connections, explain how the architecture satisfies each QA) — already covers all three explicitly, no changes needed. |
| C4 diagrams | Work/C4Diagrams.tex → Submission/C4Diagrams.pdf | submitted (2026-08-20) | — | Now covers all 6 C4 diagrams (Context, Container, Component, System Landscape, Dynamic, Deployment) per the Clase 4 exercise; Level 4/Code deliberately excluded with justification. Checklist section rewritten to cover every official c4model.com item for all 6 diagrams. Compiled clean, 16 pages. |
| Bitácora Arquitectónica | Work/BitacoraArquitectonica.md | in-progress (ongoing) | continuous | **New required deliverable** (from Clase 5): a permanently-updated log of meetings, design decisions, architectural changes, analyses, and PoCs. Created 2026-08-18; foundational decisions from ArchitecturalProposal.tex migrated in as a dated entry on 2026-08-20 (with alternatives/risks). Keep adding to it all semester — it's graded as part of the process, not a one-time submission. |
| Use-case spreadsheet | Submission/CU_eventos_completo.xlsx | submitted (2026-08-20) | — | 25 use cases, renumbered CU-001..CU-025, all ≥8 steps, all with quality-attribute + infrastructure sections. See Bitácora entries from 2026-08-20 for details. |

## Backlog / new tasks

_(Add new tasks here as they're assigned, e.g. from the course syllabus or professor's instructions.)_

- [ ] **Confirm project/team status vs. syllabus.** Clase 1's slides list
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
- [ ] **Strengthen ASR justification with a Utility Tree.** Clase 5 teaches
      the Utility Tree technique (Quality Attribute → refinement →
      prioritized scenario, e.g. (H,H)) for justifying which requirements are
      architecturally significant. `Work/ArchitecturalProposal.tex` lists
      prioritized quality attributes but doesn't use this explicit
      scenario-tree format — consider adding one for the highest-priority
      attributes. (This was a suggestion inferred from Clase 5's material,
      not the literal graded "Ejercicio" slide of that class — the literal
      exercise, the Bitácora, is done. Still worth doing to strengthen the
      SAD.)
- [x] Migrate the architectural decisions already in
      `Work/ArchitecturalProposal.tex` ("Resumen de decisiones
      arquitectónicas") into a dated entry in `Work/BitacoraArquitectonica.md`,
      including alternatives considered and risks. Done 2026-08-20.

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
