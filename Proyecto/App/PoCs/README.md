# Pruebas de concepto (PoCs)

Código real y ejecutable para los desafíos técnicos más complejos del proyecto, exigido por
Entrega 1 (`Cronograma.md` § "Checklist consolidado — Entrega 1", punto 4) y desarrollado siguiendo
la metodología de `Proyecto/Documentation/Work/GuiaEntrega1.md`: cada PoC compara **al menos 2
alternativas reales**, mide **evidencia** concreta, y respalda una decisión ya tomada (o por tomar)
ligada a un **atributo de calidad** explícito del SAD.

| PoC | Desafío | Atributo(s) | Alternativas comparadas | Resultado |
|---|---|---|---|---|
| [`poc-01-bloqueo-concurrencia`](./poc-01-bloqueo-concurrencia) | Doble venta en reventa de entradas | Consistencia (ASR-01, RNF-06) | Sin bloqueo vs. optimista (BD) vs. Redis (ADR-03) | Confirma ADR-03: Redis y bloqueo optimista eliminan la duplicación (0/30 trials); sin protección, duplicó ventas en el 100% de los trials. |
| [`poc-02-validacion-qr`](./poc-02-validacion-qr) | Validación de QR a escala | Rendimiento (ASR-04, RNF-01/02) | UUID + BD vs. JWT firmado | Resultado honesto y **no concluyente**: en SQLite local, UUID+BD midió más rápido — el benchmark no reprodujo la latencia de red real que motivaría a JWT; queda pendiente repetirlo contra una BD en red antes de decidir. |

Pendiente (ver `GuiaEntrega1.md` punto 4 y checklist): un tercer PoC de **failover** (réplica
activa vs. pasiva del API Gateway o del Servicio de Entradas), y repetir el PoC-02 contra una base
de datos en red para obtener una decisión con evidencia real.

## Requisitos para correrlos

- **PoC-01** necesita un Redis local: `brew install redis && redis-server --daemonize yes` (puerto
  6379 por defecto), y un entorno virtual de Python con el cliente `redis` (`python3 -m venv .venv
  && ./.venv/bin/pip install redis`).
- **PoC-02** no tiene dependencias externas — solo Python 3 (usa `sqlite3` y `hmac` de la
  librería estándar).
