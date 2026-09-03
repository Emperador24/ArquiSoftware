import SwiftUI

/// Perfil/Ajustes están fuera de las tabs de Personal, igual que en Cliente.
private enum PersonalRuta: Hashable {
    case perfil
    case ajustes
}

/// App del rol Personal/Empleado (SAD §2/§4): tabs dinámicas según el
/// `Cargo` del usuario (ver `destinosPara`), con el mismo menú lateral
/// Perfil/Ajustes que la app Cliente. El Jefe de Personal es la excepción:
/// solo tiene una pantalla, así que no muestra barra de tabs.
/// (Puerto 1:1 de `PersonalApp` en `MainActivity.kt`.)
struct PersonalAppView: View {
    @EnvironmentObject private var appState: AppState
    let onCerrarSesion: () -> Void

    @State private var path: [PersonalRuta] = []
    @State private var drawerAbierto = false
    @State private var tab: DestinoPersonal

    private let destinos: [DestinoPersonal]
    private let cargo: Cargo?

    init(usuario: Usuario?, onCerrarSesion: @escaping () -> Void) {
        self.onCerrarSesion = onCerrarSesion
        let cargo = usuario?.cargo
        self.cargo = cargo
        let destinos = destinosPara(cargo)
        self.destinos = destinos
        _tab = State(initialValue: destinos.first ?? .turnos)
    }

    var body: some View {
        DrawerContainer(
            isOpen: $drawerAbierto,
            usuario: appState.usuarioActual,
            onPerfil: { path.append(.perfil) },
            onAjustes: { path.append(.ajustes) },
            onCerrarSesion: onCerrarSesion
        ) {
            VStack(spacing: 0) {
                NavigationStack(path: $path) {
                    contenidoTab
                        .navigationTitle(tab.etiqueta)
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button {
                                    drawerAbierto.toggle()
                                } label: {
                                    Image(systemName: "line.3.horizontal")
                                }
                            }
                        }
                        .navigationDestination(for: PersonalRuta.self) { ruta in
                            destino(para: ruta)
                        }
                }

                // El Jefe de Personal solo tiene una pantalla: no hace falta barra de tabs.
                if destinos.count > 1 {
                    BottomBar(
                        destinos: destinos,
                        seleccionado: $tab,
                        etiqueta: { $0.etiqueta },
                        icono: { $0.icono },
                        onSeleccionar: { nuevoTab in
                            tab = nuevoTab
                            path = []
                        }
                    )
                }
            }
        }
    }

    @ViewBuilder
    private var contenidoTab: some View {
        switch tab {
        case .turnos: TurnosScreen()
        case .asistencia: AsistenciaScreen()
        case .validarEntradas: ValidarEntradasScreen()
        case .parqueaderoOperativo: ParqueaderoOperativoScreen()
        case .pedidosRestaurante: PedidosRestauranteScreen()
        case .validarPersonal: ValidarPersonalScreen()
        case .incidentes: IncidentesScreen()
        case .emergencia: EmergenciaScreen(cargo: cargo)
        }
    }

    @ViewBuilder
    private func destino(para ruta: PersonalRuta) -> some View {
        switch ruta {
        case .perfil:
            if let usuario = appState.usuarioActual {
                PerfilScreen(usuario: usuario, onGuardar: { appState.actualizarUsuario($0) })
                    .navigationTitle("Perfil")
                    .navigationBarTitleDisplayMode(.inline)
            }
        case .ajustes:
            AjustesScreen(modoOscuro: $appState.modoOscuro, onCerrarSesion: onCerrarSesion)
                .navigationTitle("Ajustes")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
