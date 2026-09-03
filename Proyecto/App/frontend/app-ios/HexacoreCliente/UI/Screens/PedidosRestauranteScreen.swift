import SwiftUI

/// Validación de pedidos en el punto de comida (cargo Restaurante): el
/// personal lee el QR del pedido y ahí aparece toda su información —
/// incluyendo si ya está pagado o hay que cobrarlo (CU-011..CU-015).
/// (Puerto 1:1 de `ui/screens/PedidosRestauranteScreen.kt` de la app Android.)
struct PedidosRestauranteScreen: View {
    var pedidosIniciales: [Pedido] = MockData.pedidosPorValidar

    @State private var lista: [Pedido] = []
    @State private var indiceEscaneo = 0
    @State private var escaneadoId: String?

    var body: some View {
        VStack {
            if let escaneado = lista.first(where: { $0.id == escaneadoId }) {
                PedidoEscaneadoCard(
                    pedido: escaneado,
                    onValidar: {
                        if let i = lista.firstIndex(where: { $0.id == escaneado.id }) {
                            lista[i].estado = .entregado
                        }
                    },
                    onEscanearOtro: { escaneadoId = nil }
                )
            } else {
                EscanearQrCard(
                    instruccion: "Apunta la cámara al código QR del pedido.",
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
        .onAppear { if lista.isEmpty { lista = pedidosIniciales } }
    }
}

private struct PedidoEscaneadoCard: View {
    let pedido: Pedido
    let onValidar: () -> Void
    let onEscanearOtro: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(pedido.establecimiento).font(.title2.weight(.semibold))
            Text(pedido.items.joined(separator: ", ")).font(.subheadline)
            Text("Total: \(moneda(pedido.total))").font(.subheadline)
            if let codigoQr = pedido.codigoQr {
                Text(codigoQr).font(.caption)
            }

            switch pedido.estado {
            case .entregado:
                Chip(texto: "Validado", destacado: true)
            case .pendientePago:
                Chip(texto: "Pago pendiente")
                Button("Cobrar y entregar", action: onValidar)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
            default:
                Chip(texto: "Ya pagado")
                Button("Validar entrega", action: onValidar)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
            }

            Button("Escanear otro pedido", action: onEscanearOtro)
                .buttonStyle(.bordered)
                .frame(maxWidth: .infinity)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
