# PoC-02 — Estrategia de generación/validación de QR a escala

**Desafío técnico:** validar el código QR de una entrada en el ingreso masivo dentro del umbral
de RNF-01 (≤ 500 ms p95).

**ASR / RNF que respalda:** ASR-02 (disponibilidad durante ingreso masivo), ASR-04/RNF-01/RNF-02
(rendimiento bajo carga).

## Alternativas comparadas

1. **`uuid_bd`** — el QR es un UUID opaco; cada validación necesita **2 accesos a la base de
   datos**: `SELECT` (¿existe? ¿ya se usó?) + `UPDATE` (marcarla usada).
2. **`jwt_firmado`** — el QR es un token firmado con HMAC-SHA256 que ya contiene
   `entrada_id`/`evento_id`; la validación verifica la firma **en memoria** (sin ir a la BD) y
   solo hace **1 acceso a la base de datos**: un `UPDATE ... WHERE id=? AND usada=0` condicional
   (evita el `SELECT` previo, porque la firma ya garantiza autenticidad).

## Cómo correrlo

Sin dependencias externas (usa `sqlite3` y `hmac` de la librería estándar de Python):

```bash
cd Proyecto/App/PoCs/poc-02-validacion-qr
python3 poc.py
```

Valida 5000 códigos QR contra una base de datos **SQLite real en disco** (no un diccionario en
memoria), para que el costo de I/O sea representativo.

## Resultado medido (corrida real, 2026-09-06)

| Estrategia | Tiempo total (5000 validaciones) | Tiempo por validación | Accesos a BD/validación |
|---|---|---|---|
| `uuid_bd` | **8.0 ms** | 1.6 µs | 2 (SELECT + UPDATE) |
| `jwt_firmado` | 11.1 ms | 2.2 µs | 1 (UPDATE condicional) |

## Decisión — resultado honesto, no el esperado

**`uuid_bd` midió más rápido que `jwt_firmado` en este benchmark**, al contrario de la hipótesis
inicial ("evitar un round-trip a la BD debería ser más rápido"). La razón: SQLite corre **local,
sin red**, así que el `SELECT` extra de `uuid_bd` es casi gratis (lectura de página en caché), y
en cambio el cómputo criptográfico HMAC-SHA256 de `jwt_firmado` sí tiene un costo real por
validación — con latencia de red cercana a cero, ese costo criptográfico pesa más que el
`SELECT` que se ahorra.

**Esto no significa que la decisión deba ser `uuid_bd` todavía** — significa que este PoC, tal
como está, **no reproduce la condición real** que motivaba la hipótesis: en producción la base de
datos del Servicio de Entradas es una instancia PostgreSQL en red (posiblemente en otra zona de
disponibilidad), no un archivo SQLite local, así que el `SELECT` evitado sí tendría un costo de
red real (típicamente 0.5–5 ms por round-trip, no microsegundos). El argumento de fondo a favor de
`jwt_firmado` — reducir accesos a una BD remota bajo la carga de un ingreso masivo (ASR-02,
ASR-04) — sigue siendo válido en principio, pero **no quedó demostrado con evidencia real**, y no
se debe adoptar sin repetir este PoC contra una base de datos en red.

**Próximo paso recomendado** (dejado explícitamente pendiente, no inventado): repetir este mismo
benchmark contra una instancia PostgreSQL real accedida por red (o al menos con latencia
artificial simulada, ej. `tc netem` o un `time.sleep` calibrado al RTT esperado) antes de decidir
entre las dos estrategias en el ADR correspondiente.

**Evidencia / pruebas:** tabla de arriba, corrida real disponible reproduciendo `poc.py`.

**Riesgos / desventajas de cada alternativa:**
- `uuid_bd`: cada validación depende de que la BD esté disponible y responda rápido — bajo la
  carga real de un ingreso masivo (miles de escaneos/minuto contra una BD remota), el `SELECT`
  adicional si pesa.
- `jwt_firmado`: si la clave de firma se filtra, cualquiera puede generar QR válidos — requiere
  gestión cuidadosa del secreto (rotación, almacenamiento seguro) que `uuid_bd` no necesita.
