"""
PoC-01: Bloqueo de concurrencia en la reventa de entradas.

Compara 3 alternativas para evitar que dos compradores completen
simultáneamente la compra de la misma entrada publicada en reventa
(ASR-01, RNF-06, ADR-03 en el SAD):

  1. sin_bloqueo -> check-then-act ingenuo (referencia, sin protección)
  2. optimista   -> compare-and-swap por versión, simulando un
                    `UPDATE entradas SET estado='vendida', version=version+1
                     WHERE id=X AND version=:version_leida` de una base de
                    datos relacional (alternativa "bloqueo optimista en BD"
                    mencionada en el ADR-03 y en GuiaEntrega1.md).
  3. redis_lock  -> `SET clave valor NX EX` distribuido en Redis (la
                    decisión ya tomada en el ADR-03).

Para cada modo se corren N_TRIALS repeticiones de N_COMPRADORES hilos
intentando "comprar" la misma entrada al mismo tiempo, y se mide cuántas
veces la entrada terminó vendida más de una vez (venta duplicada) y el
tiempo total de cada trial.
"""
import threading
import time

import redis

N_COMPRADORES = 50
N_TRIALS = 30


def intento_sin_bloqueo(estado, lock_medicion, resultados):
    # Simula: SELECT estado FROM entradas WHERE id = X  (lectura sin bloquear la fila)
    if estado["status"] == "disponible":
        time.sleep(0.005)  # ventana de carrera: tiempo de "procesar el pago"
        # Simula: UPDATE entradas SET estado = 'vendida' WHERE id = X
        estado["status"] = "vendida"
        with lock_medicion:
            resultados.append(True)
    else:
        with lock_medicion:
            resultados.append(False)


def intento_optimista(estado, lock_fila_bd, lock_medicion, resultados):
    version_leida = estado["version"]
    if estado["status"] != "disponible":
        with lock_medicion:
            resultados.append(False)
        return
    time.sleep(0.005)  # tiempo de "procesar el pago" antes del UPDATE
    # `lock_fila_bd` modela el bloqueo de fila que el motor de BD aplica
    # durante la ejecución del UPDATE condicionado a la versión leída.
    with lock_fila_bd:
        if estado["version"] == version_leida and estado["status"] == "disponible":
            estado["status"] = "vendida"
            estado["version"] += 1
            exito = True
        else:
            exito = False
    with lock_medicion:
        resultados.append(exito)


def intento_redis(cliente_redis, clave, lock_medicion, resultados):
    adquirido = cliente_redis.set(clave, "bloqueada", nx=True, ex=5)
    if not adquirido:
        with lock_medicion:
            resultados.append(False)
        return
    time.sleep(0.005)  # tiempo de "procesar el pago" con el bloqueo ya tomado
    with lock_medicion:
        resultados.append(True)


def correr_trial(modo, cliente_redis=None):
    resultados = []
    lock_medicion = threading.Lock()
    hilos = []

    if modo == "sin_bloqueo":
        estado = {"status": "disponible"}
        hilos = [
            threading.Thread(target=intento_sin_bloqueo, args=(estado, lock_medicion, resultados))
            for _ in range(N_COMPRADORES)
        ]
    elif modo == "optimista":
        estado = {"status": "disponible", "version": 0}
        lock_fila_bd = threading.Lock()
        hilos = [
            threading.Thread(target=intento_optimista, args=(estado, lock_fila_bd, lock_medicion, resultados))
            for _ in range(N_COMPRADORES)
        ]
    elif modo == "redis_lock":
        clave = f"poc01:lock:entrada:{time.time_ns()}"
        hilos = [
            threading.Thread(target=intento_redis, args=(cliente_redis, clave, lock_medicion, resultados))
            for _ in range(N_COMPRADORES)
        ]
    else:
        raise ValueError(f"modo desconocido: {modo}")

    inicio = time.perf_counter()
    for h in hilos:
        h.start()
    for h in hilos:
        h.join()
    duracion_ms = (time.perf_counter() - inicio) * 1000

    return sum(resultados), duracion_ms


def main():
    cliente_redis = redis.Redis(host="localhost", port=6379, decode_responses=True)
    cliente_redis.ping()

    print(f"PoC-01 — {N_COMPRADORES} compradores concurrentes x {N_TRIALS} trials por modo\n")
    print(f"{'Modo':12s} | {'Trials con venta duplicada':27s} | {'Máx. ventas en 1 trial':23s} | {'Tiempo medio/trial':18s}")
    print("-" * 95)

    for modo in ["sin_bloqueo", "optimista", "redis_lock"]:
        conteos = []
        tiempos = []
        for _ in range(N_TRIALS):
            exitosas, duracion_ms = correr_trial(modo, cliente_redis=cliente_redis)
            conteos.append(exitosas)
            tiempos.append(duracion_ms)

        duplicadas = sum(1 for c in conteos if c > 1)
        tiempo_medio = sum(tiempos) / len(tiempos)
        print(
            f"{modo:12s} | {duplicadas}/{N_TRIALS} trials{'':16s} | "
            f"{max(conteos)} venta(s){'':15s} | {tiempo_medio:.2f} ms"
        )


if __name__ == "__main__":
    main()
