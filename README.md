# Sistema Integral de Gestión de Eventos

Proyecto semestral del curso de Arquitectura de Software (Pontificia
Universidad Javeriana). Centraliza en una sola plataforma los procesos que
hoy suelen estar dispersos en la gestión de un evento: venta de entradas,
reventa, personal, parqueaderos, operación del evento y administración
general — evitando información duplicada, errores humanos y falta de
trazabilidad, especialmente con miles de asistentes concurrentes.

Se materializa en una aplicación web (dos portales) y una aplicación móvil
(dos variantes según el tipo de usuario), todas consumiendo el mismo
backend.

## Estructura del repositorio

```
Work/                       Documentos de trabajo (fuentes .tex, en progreso)
├── Summary.tex             Resumen del proyecto
├── ArchitecturalProposal.tex   Propuesta arquitectónica completa
├── C4Diagrams.tex          Diagramas C4 (contexto, contenedores, componentes)
├── BitacoraArquitectonica.md   Registro permanente de decisiones de diseño
├── Slides/                 Diapositivas de clase exportadas de Teams (PDF)
└── Notes/                  Resúmenes por clase, generados a partir de Slides/

Submission/                 Entregables finales (PDF compilados), listos para
                             subir al curso — nunca se edita directamente aquí

TASKS.md                    Seguimiento de tareas, entregas y fechas
CLAUDE.md                   Convenciones del proyecto para trabajar con Claude Code
.claude/agents/
└── slides-analyst.md       Agente que estudia las diapositivas nuevas y
                             actualiza Notes/, TASKS.md y la bitácora
```

## Flujo de trabajo

1. El trabajo se hace en `Work/` (fuentes `.tex` y borradores).
2. Cuando un entregable está terminado, se compila a PDF y se copia a
   `Submission/`.
3. Las diapositivas de clase se exportan desde Microsoft Teams a
   `Work/Slides/` (PDF); el agente `slides-analyst` las estudia y actualiza
   `Work/Notes/`, `TASKS.md` y la bitácora.
4. `TASKS.md` es la fuente de verdad de qué está pendiente, en progreso o
   entregado — se actualiza con cada avance.

## Compilar los documentos

Requiere una distribución de LaTeX (`pdflatex`). Desde `Work/`:

```bash
pdflatex -interaction=nonstopmode Summary.tex
pdflatex -interaction=nonstopmode ArchitecturalProposal.tex
pdflatex -interaction=nonstopmode C4Diagrams.tex
```

(Correr `pdflatex` dos veces por archivo si hay tabla de contenido o
referencias cruzadas.)

## Estado actual

Ver [`TASKS.md`](TASKS.md) para el estado detallado de cada entregable y las
tareas pendientes.
