import SwiftUI

/// Validación de boletas en la puerta (cargo Entrada). El personal lee el QR
/// de cada boleta (una a la vez) y ahí aparece toda su información con la
/// opción de validar el ingreso — sin lista previa de todas las entradas.
/// (Puerto 1:1 de `ui/screens/ValidarEntradasScreen.kt` de la app Android.)
struct ValidarEntradasScreen: View {
    var entradasIniciales: [EntradaPorValidar] = MockData.entradasPorValidar

    @State private var lista: [EntradaPorValidar] = []
    @State private var indiceEscaneo = 0
    @State private var escaneadaId: String?

    var body: some View {
        VStack {
            if let escaneada = lista.first(where: { $0.id == escaneadaId }) {
                EntradaEscaneadaCard(
                    entrada: escaneada,
                    onValidar: {
                        if let i = lista.firstIndex(where: { $0.id == escaneada.id }) {
                            lista[i].validada = true
                        }
                    },
                    onEscanearOtra: { escaneadaId = nil }
                )
            } else {
                EscanearQrCard(
                    instruccion: "Apunta la cámara al código QR de la entrada.",
                    textoBoton: "Escanear código QR"
                ) {
                    guard !lista.isEmpty else { return }
                    escaneadaId = lista[indiceEscaneo % lista.count].id
                    indiceEscaneo += 1
                }
            }
            Spacer()
        }
        .padding(16)
        .onAppear { if lista.isEmpty { lista = entradasIniciales } }
    }
}

private struct EntradaEscaneadaCard: View {
    let entrada: EntradaPorValidar
    let onValidar: () -> Void
    let onEscanearOtra: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(entrada.eventoNombre).font(.title2.weight(.semibold))
            Text(entrada.zona).font(.subheadline)
            Text(entrada.codigoQr).font(.caption)

            if entrada.validada {
                Chip(texto: "Validado", destacado: true)
            } else {
                Button("Validar ingreso", action: onValidar)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
            }

            Button("Escanear otra entrada", action: onEscanearOtra)
                .buttonStyle(.bordered)
                .frame(maxWidth: .infinity)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
