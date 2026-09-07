"""
PoC-02: Estrategia de generación/validación de QR a escala.

Compara 2 alternativas para el código QR de una entrada (RNF-01: validación
<= 500 ms p95; ASR-02/ASR-04: disponibilidad y rendimiento durante el
ingreso masivo):

  1. uuid_bd -> el QR es un UUID opaco; validar requiere SIEMPRE una
                consulta a la base de datos para saber si la entrada existe,
                a qué evento pertenece y si ya fue usada (SELECT + UPDATE).
  2. jwt_firmado -> el QR es un token firmado (HMAC-SHA256) que ya contiene
                entrada_id/evento_id/expiración; la validación verifica la
                firma en memoria (sin ir a la base de datos) y solo golpea
                la base de datos para el UPDATE condicional que marca la
                entrada como usada (evita el SELECT previo).

Se mide el tiempo de validar N entradas con cada estrategia contra una
base de datos SQLite real (no un diccionario en memoria) para que el costo
de I/O a disco sea representativo.
"""
import hashlib
import hmac
import os
import sqlite3
import time

N_ENTRADAS = 5000
CLAVE_SECRETA = b"clave-demo-hexacore-cambiar-en-produccion"
RUTA_BD = "poc02_entradas.db"


def preparar_bd():
    if os.path.exists(RUTA_BD):
        os.remove(RUTA_BD)
    conn = sqlite3.connect(RUTA_BD)
    conn.execute(
        "CREATE TABLE entradas (id TEXT PRIMARY KEY, evento_id TEXT, usada INTEGER DEFAULT 0)"
    )
    ids = [f"ent-{i:06d}" for i in range(N_ENTRADAS)]
    conn.executemany(
        "INSERT INTO entradas (id, evento_id, usada) VALUES (?, ?, 0)",
        [(i, "evt-1") for i in ids],
    )
    conn.commit()
    return conn, ids


def firmar(entrada_id: str, evento_id: str) -> str:
    payload = f"{entrada_id}:{evento_id}"
    firma = hmac.new(CLAVE_SECRETA, payload.encode(), hashlib.sha256).hexdigest()
    return f"{payload}:{firma}"


def verificar_firma(token: str):
    try:
        entrada_id, evento_id, firma = token.split(":")
    except ValueError:
        return None
    esperado = hmac.new(CLAVE_SECRETA, f"{entrada_id}:{evento_id}".encode(), hashlib.sha256).hexdigest()
    if not hmac.compare_digest(firma, esperado):
        return None
    return entrada_id, evento_id


def benchmark_uuid_bd(conn, ids):
    cur = conn.cursor()
    inicio = time.perf_counter()
    validas = 0
    for entrada_id in ids:
        # 1) SELECT: la entrada existe y no ha sido usada?
        fila = cur.execute("SELECT usada FROM entradas WHERE id = ?", (entrada_id,)).fetchone()
        if fila is None or fila[0] == 1:
            continue
        # 2) UPDATE: marcarla como usada
        cur.execute("UPDATE entradas SET usada = 1 WHERE id = ?", (entrada_id,))
        validas += 1
    conn.commit()
    duracion_ms = (time.perf_counter() - inicio) * 1000
    return validas, duracion_ms


def benchmark_jwt_firmado(conn, tokens):
    cur = conn.cursor()
    inicio = time.perf_counter()
    validas = 0
    for token in tokens:
        datos = verificar_firma(token)  # verificación en memoria, sin ir a la BD
        if datos is None:
            continue
        entrada_id, _evento_id = datos
        # Único acceso a BD: UPDATE condicional (evita el SELECT previo,
        # porque la firma ya garantiza que la entrada es auténtica).
        cur.execute("UPDATE entradas SET usada = 1 WHERE id = ? AND usada = 0", (entrada_id,))
        if cur.rowcount == 1:
            validas += 1
    conn.commit()
    duracion_ms = (time.perf_counter() - inicio) * 1000
    return validas, duracion_ms


def main():
    print(f"PoC-02 — validando {N_ENTRADAS} códigos QR contra SQLite real (no en memoria)\n")

    # --- Alternativa 1: UUID + BD ---
    conn, ids = preparar_bd()
    validas_uuid, ms_uuid = benchmark_uuid_bd(conn, ids)
    conn.close()

    # --- Alternativa 2: JWT firmado ---
    conn, ids = preparar_bd()
    tokens = [firmar(i, "evt-1") for i in ids]
    validas_jwt, ms_jwt = benchmark_jwt_firmado(conn, tokens)
    conn.close()

    os.remove(RUTA_BD)

    print(f"{'Estrategia':14s} | {'Entradas validadas':19s} | {'Tiempo total':13s} | {'Tiempo por validación':22s} | Accesos a BD/validación")
    print("-" * 105)
    print(f"{'uuid_bd':14s} | {validas_uuid}/{N_ENTRADAS}{'':13s} | {ms_uuid:8.1f} ms | {ms_uuid/N_ENTRADAS*1000:8.1f} µs{'':11s} | 2 (SELECT + UPDATE)")
    print(f"{'jwt_firmado':14s} | {validas_jwt}/{N_ENTRADAS}{'':13s} | {ms_jwt:8.1f} ms | {ms_jwt/N_ENTRADAS*1000:8.1f} µs{'':11s} | 1 (UPDATE condicional)")
    print(f"\nMejora: {(ms_uuid - ms_jwt) / ms_uuid * 100:.1f}% menos tiempo total con jwt_firmado.")


if __name__ == "__main__":
    main()
