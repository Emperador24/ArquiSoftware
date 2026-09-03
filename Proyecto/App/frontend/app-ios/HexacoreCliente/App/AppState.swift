import Foundation
import Combine

/// Estado compartido de la app (equivalente al estado elevado en
/// `HexacoreApp`/`ClienteApp` de `MainActivity.kt`): quién inició sesión, el
/// modo oscuro y el carrito/pedidos del cliente, que deben sobrevivir a la
/// navegación entre pantallas. Un único login identifica el rol (Cliente o
/// Personal — ver `MockAuth`) y abre el conjunto de pantallas correspondiente
/// (SAD §8).
@MainActor
final class AppState: ObservableObject {
    @Published var usuarioActual: Usuario?
    @Published var modoOscuro: Bool
    /// Hoisted aquí (igual que en Android) para que el carrito sobreviva la
    /// navegación entre Restaurantes → Menú → Pasarela de pago, y para que un
    /// pedido recién pagado aparezca de inmediato en "Mis pedidos".
    @Published var carrito: [ItemCarrito] = []
    @Published var misPedidos: [Pedido] = MockData.pedidos

    init(modoOscuroInicial: Bool = false) {
        self.modoOscuro = modoOscuroInicial
    }

    func iniciarSesion(_ usuario: Usuario) {
        usuarioActual = usuario
    }

    func cerrarSesion() {
        usuarioActual = nil
        carrito = []
        misPedidos = MockData.pedidos
    }

    func actualizarUsuario(_ usuario: Usuario) {
        usuarioActual = usuario
    }

    func agregarAlCarrito(_ producto: ProductoMenu) {
        if let i = carrito.firstIndex(where: { $0.producto.id == producto.id }) {
            carrito[i].cantidad += 1
        } else {
            carrito.append(ItemCarrito(producto: producto, cantidad: 1))
        }
    }

    func quitarDelCarrito(_ producto: ProductoMenu) {
        guard let i = carrito.firstIndex(where: { $0.producto.id == producto.id }) else { return }
        if carrito[i].cantidad <= 1 {
            carrito.remove(at: i)
        } else {
            carrito[i].cantidad -= 1
        }
    }

    /// Confirma el pago del carrito actual: crea el pedido con su QR de
    /// retiro y lo agrega de primero en "Mis pedidos".
    func confirmarPagoPedido() {
        guard !carrito.isEmpty else { return }
        let nombreEstablecimiento = MockData.establecimientos
            .first { $0.id == carrito.first?.producto.establecimientoId }?.nombre ?? ""
        let total = carrito.reduce(0.0) { $0 + $1.producto.precio * Double($1.cantidad) }
        let pedido = Pedido(
            id: "ped-\(Int(Date().timeIntervalSince1970 * 1000))",
            establecimiento: nombreEstablecimiento,
            items: carrito.map { "\($0.cantidad)x \($0.producto.nombre)" },
            total: total,
            estado: .enPreparacion,
            codigoQr: "HXC-PED-\(Int.random(in: 100_000...999_999))"
        )
        misPedidos.insert(pedido, at: 0)
        carrito.removeAll()
    }
}
