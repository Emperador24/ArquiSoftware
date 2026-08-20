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
| Architectural proposal | Work/ArchitecturalProposal.tex → Submission/ArchitecturalProposal.pdf | submitted (2026-08-18) | — | Compiled, no LaTeX errors. |
| C4 diagrams | Work/C4Diagrams.tex → Submission/C4Diagrams.pdf | submitted (2026-08-18) | — | Compiled, no LaTeX errors. See backlog: may be missing Deployment/Dynamic/System Landscape diagrams. |
| Bitácora Arquitectónica | Work/BitacoraArquitectonica.md | in-progress (ongoing) | continuous | **New required deliverable** (from Clase 5): a permanently-updated log of meetings, design decisions, architectural changes, analyses, and PoCs. Created 2026-08-18; needs the team to migrate past decisions into dated entries and keep adding to it all semester — it's graded as part of the process, not a one-time submission. |

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
      (https://c4model.com/diagrams/checklist). `Work/C4Diagrams.tex`
      currently covers Context, Container, and Component (+ a checklist
      section) but has no explicit **Deployment**, **Dynamic**, or **System
      Landscape** diagram — add them if the team wants full C4 coverage.
- [x] **Strengthen ASR justification with a Utility Tree.** Clase 5 teaches
      the Utility Tree technique (Quality Attribute → refinement →
      prioritized scenario, e.g. (H,H)) for justifying which requirements are
      architecturally significant. `Work/ArchitecturalProposal.tex` lists
      prioritized quality attributes but doesn't use this explicit
      scenario-tree format — consider adding one for the highest-priority
      attributes.
- [x] Migrate the architectural decisions already in
      `Work/ArchitecturalProposal.tex` ("Resumen de decisiones
      arquitectónicas") and `Work/C4Diagrams.tex` into dated entries in
      `Work/BitacoraArquitectonica.md`, including alternatives considered and
      risks (not just the final decision).

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
