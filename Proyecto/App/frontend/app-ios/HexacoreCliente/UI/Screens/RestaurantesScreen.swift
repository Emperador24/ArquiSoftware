import SwiftUI

/// Restaurantes/puntos de comida del evento (CU-011): el punto de partida
/// para armar un pedido nuevo — sub-pestaña de Pedidos junto a Mis pedidos.
/// (Puerto 1:1 de `ui/screens/RestaurantesScreen.kt` de la app Android.)
struct RestaurantesScreen: View {
    var establecimientos: [Establecimiento] = MockData.establecimientos
    var onEstablecimientoClick: (Establecimiento) -> Void = { _ in }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(establecimientos) { establecimiento in
                    EstablecimientoCard(establecimiento: establecimiento) {
                        onEstablecimientoClick(establecimiento)
                    }
                }
            }
            .padding(16)
        }
    }
}

private struct EstablecimientoCard: View {
    let establecimiento: Establecimiento
    let onClick: () -> Void

    var body: some View {
        Button(action: onClick) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8).fill(Color.accentColor.opacity(0.2))
                    Text(establecimiento.nombre.prefix(1).uppercased())
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(Color.accentColor)
                }
                .frame(width: 56, height: 56)

                VStack(alignment: .leading) {
                    Text(establecimiento.nombre).font(.title3.weight(.medium)).foregroundStyle(.primary)
                    Text(establecimiento.descripcion).font(.subheadline).foregroundStyle(.secondary)
                }
                Spacer()
            }
            .padding(12)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}
