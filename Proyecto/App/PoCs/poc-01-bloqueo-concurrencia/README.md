# PoC-01 — Bloqueo de concurrencia en la reventa de entradas

**Desafío técnico:** evitar que dos compradores completen simultáneamente la compra de la misma
entrada publicada en el mercado secundario (CU-006).

**ASR / RNF que respalda:** ASR-01 (bloqueo de doble venta), RNF-06 (0% de ventas duplicadas bajo
concurrencia). **Decisión que evidencia:** ADR-03 en `Work/DescripcionArquitecturaSoftware.tex`
(Redis para bloqueo temporal).

## Alternativas comparadas (≥2, como exige `GuiaEntrega1.md`)

1. **`sin_bloqueo`** — check-then-act ingenuo (leer estado, procesar, escribir estado), sin
   ninguna protección. Referencia para mostrar el problema real, no una alternativa seria.
2. **`optimista`** — bloqueo optimista por versión, simulando el patrón
   `UPDATE entradas SET estado='vendida', version=version+1 WHERE id=X AND version=:version_leida`
   que se usaría contra PostgreSQL.
3. **`redis_lock`** — `SET clave valor NX EX` distribuido en Redis (la decisión ya tomada en
   ADR-03).

## Cómo correrlo

Requiere un Redis corriendo en `localhost:6379` (en esta sesión se instaló con
`brew install redis` y se levantó con `redis-server --daemonize yes`).

```bash
cd Proyecto/App/PoCs/poc-01-bloqueo-concurrencia
python3 -m venv .venv && ./.venv/bin/pip install redis
./.venv/bin/python poc.py
```

Simula 50 compradores concurrentes (hilos) intentando comprar la misma entrada, repetido en 30
trials por cada uno de los 3 modos.

## Resultado medido (corrida real, 2026-09-06)

| Modo | Trials con venta duplicada | Máx. ventas simultáneas en 1 trial | Tiempo medio/trial |
|---|---|---|---|
| `sin_bloqueo` | **30/30** | **50** (los 50 compradores "compraron" la misma entrada) | 7.15 ms |
| `optimista` | 0/30 | 1 | 8.35 ms |
| `redis_lock` | 0/30 | 1 | 7.22 ms |

## Decisión

Se **mantiene Redis** (ADR-03) como mecanismo de bloqueo, con evidencia real ahora: sin ninguna
protección, el 100% de los trials terminó en venta duplicada (hasta 50 "ventas" de la misma
entrada en un solo trial) — confirma que el riesgo de ASR-01 es real y no hipotético. Tanto el
bloqueo optimista en base de datos como Redis eliminan por completo la duplicación (0/30 en
ambos), así que la elección entre los dos **no se decide por corrección** (ambos son correctos)
sino por lo que este PoC no mide directamente:

- **Redis no compite por locks de fila con las transacciones normales de la base de datos
  relacional** — bajo alta contención (miles de intentos simultáneos en una apertura de venta,
  ASR-04), un bloqueo optimista en Postgres generaría muchos reintentos fallidos contra la misma
  fila, mientras que Redis resuelve el `SETNX` en memoria, fuera del camino crítico de la BD.
- Redis ya es una pieza de infraestructura compartida con otros escenarios (caché de aforo/sesión,
  ver `ArchitecturalProposal.tex` § Infraestructura de soporte), así que no se añade un componente
  nuevo solo para esto.

**Evidencia / pruebas:** tabla de arriba, corrida real disponible reproduciendo `poc.py`.

**Riesgos / desventajas de lo elegido:** Redis es un punto de falla adicional (ya cubierto en la
sección de Disponibilidad del SAD, con redundancia activa/pasiva vía Redis Sentinel/Cluster). La
diferencia de tiempo medido aquí (7-8 ms) no es concluyente sobre rendimiento real bajo carga
—ambas alternativas corrieron en el mismo proceso Python, sin la latencia de red/disco de un
Postgres real ni de un Redis remoto—; el argumento de fondo para preferir Redis es evitar
contención sobre la base de datos primaria bajo alta concurrencia, no la latencia medida aquí.
