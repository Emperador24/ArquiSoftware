import SwiftUI

/// Destinos a los que se puede navegar empujando (push) dentro de la app
/// Cliente: no son tabs propios — se llega a ellos desde Inicio/Pedidos, o
/// desde el menú lateral.
enum ClienteRuta: Hashable {
    case entradas(eventoId: String)
    case menu(establecimientoId: String)
    case pasarelaPago
    case perfil
    case ajustes
}

/// App del rol Cliente (SAD §2): tabs de Inicio/Parqueadero/Pedidos con menú
/// lateral (Perfil/Ajustes) y las pantallas a las que se navega empujando
/// (Entradas de un evento, Menú de un establecimiento, Pasarela de pago).
/// (Puerto 1:1 de `ClienteApp` en `MainActivity.kt`.)
struct ClienteAppView: View {
    @EnvironmentObject private var appState: AppState
    let onCerrarSesion: () -> Void

    @State private var tab: DestinoCliente = .inicio
    @State private var path: [ClienteRuta] = []
    @State private var drawerAbierto = false

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
                        .navigationDestination(for: ClienteRuta.self) { ruta in
                            destino(para: ruta)
                        }
                }

                BottomBar(
                    destinos: DestinoCliente.allCases,
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

    @ViewBuilder
    private var contenidoTab: some View {
        switch tab {
        case .inicio:
            InicioScreen(onEventoClick: { evento in path.append(.entradas(eventoId: evento.id)) })
        case .parqueadero:
            ParqueaderoScreen()
        case .pedidos:
            PedidosScreen(
                pedidos: appState.misPedidos,
                onEstablecimientoClick: { establecimiento in path.append(.menu(establecimientoId: establecimiento.id)) }
            )
        }
    }

    @ViewBuilder
    private func destino(para ruta: ClienteRuta) -> some View {
        switch ruta {
        case .entradas(let eventoId):
            EntradasScreen(eventoId: eventoId, nombreRemitente: appState.usuarioActual?.nombre ?? "")
                .navigationTitle(MockData.eventos.first { $0.id == eventoId }?.nombre ?? "Inicio")
                .navigationBarTitleDisplayMode(.inline)

        case .menu(let establecimientoId):
            MenuRestauranteScreen(
                establecimientoId: establecimientoId,
                carrito: appState.carrito,
                onAgregar: { appState.agregarAlCarrito($0) },
                onQuitar: { appState.quitarDelCarrito($0) },
                onContinuarAlPago: { path.append(.pasarelaPago) }
            )
            .navigationTitle(MockData.establecimientos.first { $0.id == establecimientoId }?.nombre ?? "Restaurantes")
            .navigationBarTitleDisplayMode(.inline)

        case .pasarelaPago:
            PasarelaPagoScreen(
                carrito: appState.carrito,
                onConfirmarPago: {
                    appState.confirmarPagoPedido()
                    path = []
                    tab = .pedidos
                }
            )
            .navigationTitle("Resumen del pedido")
            .navigationBarTitleDisplayMode(.inline)

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
