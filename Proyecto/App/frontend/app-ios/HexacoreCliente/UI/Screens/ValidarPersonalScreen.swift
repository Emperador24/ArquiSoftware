import SwiftUI

/// Único cargo con acceso exclusivo: el Jefe de Personal lee el QR del carné
/// de cada empleado (uno a la vez) y ahí mismo aparece si le corresponde
/// validar ingreso o salida — sin lista previa de todo el personal.
/// (Puerto 1:1 de `ui/screens/ValidarPersonalScreen.kt` de la app Android.)
struct ValidarPersonalScreen: View {
    var personalInicial: [PersonalOperativo] = MockData.personalDelEvento

    @State private var lista: [PersonalOperativo] = []
    @State private var indiceEscaneo = 0
    @State private var escaneadoId: String?

    var body: some View {
        VStack {
            if let escaneado = lista.first(where: { $0.id == escaneadoId }) {
                PersonalEscaneadoCard(
                    empleado: escaneado,
                    onValidarIngreso: {
                        if let i = lista.firstIndex(where: { $0.id == escaneado.id }) {
                            lista[i].ingresoRegistrado = true
                        }
                    },
                    onValidarSalida: {
                        if let i = lista.firstIndex(where: { $0.id == escaneado.id }) {
                            lista[i].salidaRegistrada = true
                        }
                    },
                    onEscanearOtro: { escaneadoId = nil }
                )
            } else {
                EscanearQrCard(
                    instruccion: "Apunta la cámara al código QR del carné del empleado.",
                    textoBoton: "Escanear código QR"
                ) {
                    guard !lista.isEmpty else { return }
                    escaneadoId = lista[indiceEscaneo % lista.count].id
                    indiceEscaneo += 1
                }
            }
            Spacer()
        }
        .padding(16)
        .onAppear { if lista.isEmpty { lista = personalInicial } }
    }
}

private struct PersonalEscaneadoCard: View {
    let empleado: PersonalOperativo
    let onValidarIngreso: () -> Void
    let onValidarSalida: () -> Void
    let onEscanearOtro: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(empleado.nombre).font(.title2.weight(.semibold))
            Text(empleado.codigoQr).font(.caption)

            if !empleado.ingresoRegistrado {
                Chip(texto: "Ingreso pendiente")
                Button("Validar ingreso", action: onValidarIngreso)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
            } else if !empleado.salidaRegistrada {
                Chip(texto: "Ingreso OK")
                Button("Validar salida", action: onValidarSalida)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
            } else {
                Chip(texto: "Turno completo")
            }

            Button("Escanear otro código", action: onEscanearOtro)
                .buttonStyle(.bordered)
                .frame(maxWidth: .infinity)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
