import SwiftUI

/// Pedidos ya realizados por el cliente (CU-011..CU-015): estado y, una vez
/// pagado, el QR para retirarlo. Sub-pestaña de Pedidos, junto a Restaurantes
/// (donde se arma uno nuevo) — ver `PedidosScreen`.
/// (Puerto 1:1 de `ui/screens/MisPedidosScreen.kt` de la app Android.)
struct MisPedidosScreen: View {
    var pedidos: [Pedido] = MockData.pedidos

    var body: some View {
        if pedidos.isEmpty {
            VStack {
                Spacer()
                Text("Todavía no has hecho ningún pedido.").foregroundStyle(.secondary)
                Spacer()
            }
        } else {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(pedidos) { pedido in
                        PedidoCard(pedido: pedido)
                    }
                }
                .padding(16)
            }
        }
    }
}

private struct PedidoCard: View {
    let pedido: Pedido

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(pedido.establecimiento).font(.title3.weight(.medium))
            Text(pedido.items.joined(separator: ", ")).font(.subheadline)
            Text("Total: \(moneda(pedido.total))").font(.subheadline)
            Chip(texto: pedido.estado.etiqueta)

            if pedido.estado == .pendientePago {
                // Sin pago confirmado todavía no hay QR de retiro — la acción
                // de pago se conecta cuando exista la pasarela de pagos real.
                Button("Pagar pedido") {}
                    .buttonStyle(.bordered)
            } else if let codigoQr = pedido.codigoQr {
                QrPlaceholder(codigo: codigoQr)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
