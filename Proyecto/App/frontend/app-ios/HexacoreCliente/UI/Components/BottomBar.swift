import SwiftUI

/// Barra de navegación inferior genérica, compartida por `ClienteAppView` y
/// `PersonalAppView` (equivalente a `NavigationBar` en `MainActivity.kt`).
/// Se implementa a mano — en vez de un `TabView` de SwiftUI — porque debe
/// seguir visible incluso en las pantallas a las que se navega empujando
/// (Entradas, Menú, Pasarela de pago, Perfil, Ajustes), igual que el
/// `bottomBar` del `Scaffold` de Compose envuelve todo el `NavHost`.
struct BottomBar<Destino: Hashable>: View {
    let destinos: [Destino]
    @Binding var seleccionado: Destino
    let etiqueta: (Destino) -> String
    let icono: (Destino) -> String
    let onSeleccionar: (Destino) -> Void

    var body: some View {
        HStack(spacing: 0) {
            ForEach(destinos, id: \.self) { destino in
                Button {
                    onSeleccionar(destino)
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: icono(destino))
                        Text(etiqueta(destino)).font(.caption2)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
                    .foregroundStyle(destino == seleccionado ? Color.accentColor : Color.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.bottom, 4)
        .background(.bar)
        .overlay(Divider(), alignment: .top)
    }
}
