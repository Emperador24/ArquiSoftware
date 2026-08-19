# ArquiSoftware

Software Architecture course project: "Sistema Integral de Gestión de Eventos"
(event management system). Deliverables are written in LaTeX.

## Structure

- `Work/` — working sources and drafts (the `.tex` files being actively edited).
  - `Work/Slides/` — class slides exported from Microsoft Teams by the user
    (PDF preferred, PPTX also accepted). Claude never fetches these itself —
    the user drops the exported files here manually.
  - `Work/Notes/` — one summary note per slide deck, written by the
    `slides-analyst` agent.
- `Submission/` — final files ready to hand in, one subfolder or file set per
  deliverable. Nothing goes here until it's actually finished; don't put
  drafts in this folder.
- `TASKS.md` — the task tracker for this project. Read it at the start of a
  session to see what's pending, and update it (status, new tasks, due dates)
  whenever something changes — see the Workflow section in that file.
- `.claude/agents/slides-analyst.md` — a subagent that studies whatever is in
  `Work/Slides/`, writes notes to `Work/Notes/`, extracts assignments/
  deadlines into `TASKS.md`, and proposes edits to the `Work/*.tex`
  deliverables. Invoke it whenever new slides are added, or ask the user to
  run it explicitly.

## Working conventions

- New deliverables start as `.tex` files in `Work/`.
- When a deliverable is finished: compile it, copy the final file(s) into
  `Submission/`, and mark it `submitted` in `TASKS.md`.
- When the user mentions a new assignment/task, add it to `TASKS.md` rather
  than only doing the work — that's what keeps tasks discoverable across
  sessions.
- These rules are mirrored in `.claude/agents/slides-analyst.md` so that
  agent stays consistent even when it runs in isolation. If you change the
  structure or workflow here, update that file too (and vice versa).
