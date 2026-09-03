import SwiftUI

/// Pedidos del cliente (CU-011..CU-015): "Restaurantes" para armar uno nuevo
/// y "Mis pedidos" para ver el estado/QR de los ya hechos.
/// (Puerto 1:1 de `ui/screens/PedidosScreen.kt` de la app Android.)
struct PedidosScreen: View {
    let pedidos: [Pedido]
    let onEstablecimientoClick: (Establecimiento) -> Void

    @State private var pestanaSeleccionada = 0

    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $pestanaSeleccionada) {
                Text("Restaurantes").tag(0)
                Text("Mis pedidos").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)

            if pestanaSeleccionada == 0 {
                RestaurantesScreen(onEstablecimientoClick: onEstablecimientoClick)
            } else {
                MisPedidosScreen(pedidos: pedidos)
            }
        }
    }
}
