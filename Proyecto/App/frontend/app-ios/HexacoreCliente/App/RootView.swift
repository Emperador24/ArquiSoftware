import SwiftUI

/// Punto de entrada de la app (SAD §8). Un único login identifica el rol
/// (Cliente o Personal — ver `MockAuth`) y abre el conjunto de pantallas
/// correspondiente dentro de la misma app. Para Personal, el cargo del
/// usuario además decide qué función operativa se activa (ver
/// `destinosPara`). El menú lateral (Perfil/Ajustes) es el mismo para ambos
/// roles.
/// (Puerto 1:1 de `HexacoreApp` en `MainActivity.kt`.)
struct RootView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        Group {
            switch appState.usuarioActual?.rol {
            case .none:
                LoginScreen { usuario in appState.iniciarSesion(usuario) }
            case .cliente:
                ClienteAppView(onCerrarSesion: appState.cerrarSesion)
            case .personal:
                PersonalAppView(usuario: appState.usuarioActual, onCerrarSesion: appState.cerrarSesion)
                    .id(appState.usuarioActual?.id)
            }
        }
        .preferredColorScheme(appState.modoOscuro ? .dark : .light)
    }
}
