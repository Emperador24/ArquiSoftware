import SwiftUI

/// Ajustes generales de la app: preferencias, soporte y versión — lo que
/// siempre trae el apartado de "Ajustes"/"Configuración" de cualquier app.
/// El modo oscuro sí queda conectado al tema real; notificaciones e idioma
/// son preferencias locales hasta que exista el backend correspondiente.
/// (Puerto 1:1 de `ui/screens/AjustesScreen.kt` de la app Android.)
struct AjustesScreen: View {
    @Binding var modoOscuro: Bool
    let onCerrarSesion: () -> Void

    @State private var notificaciones = true

    private var version: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    }

    var body: some View {
        List {
            Section("Preferencias") {
                Toggle("Notificaciones", isOn: $notificaciones)
                Toggle("Modo oscuro", isOn: $modoOscuro)
            }

            Section("Soporte") {
                Text("¿Necesitas ayuda? Escríbenos a soporte@hexacore.com.")
            }

            Section("Acerca de") {
                Text("Versión \(version)")
                Text("HEXACORE — Sistema Integral de Gestión de Eventos")
            }

            Section {
                Button("Cerrar sesión", role: .destructive, action: onCerrarSesion)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}
