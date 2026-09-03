import SwiftUI

/// Menú de un establecimiento (CU-011: gestión integral de pedidos). El
/// cliente arma su pedido aquí y pasa a la pasarela de pago cuando termina.
/// (Puerto 1:1 de `ui/screens/MenuRestauranteScreen.kt` de la app Android.)
struct MenuRestauranteScreen: View {
    let establecimientoId: String
    let carrito: [ItemCarrito]
    let onAgregar: (ProductoMenu) -> Void
    let onQuitar: (ProductoMenu) -> Void
    let onContinuarAlPago: () -> Void
    var establecimientos: [Establecimiento] = MockData.establecimientos
    var menuCompleto: [ProductoMenu] = MockData.menu

    private var establecimiento: Establecimiento? { establecimientos.first { $0.id == establecimientoId } }
    private var productos: [ProductoMenu] { menuCompleto.filter { $0.establecimientoId == establecimientoId } }
    private var total: Double { carrito.reduce(0) { $0 + $1.producto.precio * Double($1.cantidad) } }

    var body: some View {
        VStack(spacing: 0) {
            if let establecimiento {
                Text(establecimiento.nombre)
                    .font(.title2.weight(.semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
            }

            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(productos) { producto in
                        let cantidad = carrito.first { $0.producto.id == producto.id }?.cantidad ?? 0
                        ProductoCard(
                            producto: producto,
                            cantidad: cantidad,
                            onAgregar: { onAgregar(producto) },
                            onQuitar: { onQuitar(producto) }
                        )
                    }
                }
                .padding(.horizontal, 16)
            }

            Divider()

            VStack(spacing: 8) {
                Text("Total: \(moneda(total))")
                    .font(.title3.weight(.medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button {
                    onContinuarAlPago()
                } label: {
                    Text("Continuar al pago").frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(carrito.isEmpty)
            }
            .padding(16)
        }
    }
}

private struct ProductoCard: View {
    let producto: ProductoMenu
    let cantidad: Int
    let onAgregar: () -> Void
    let onQuitar: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(producto.nombre).font(.title3.weight(.medium))
                Text(moneda(producto.precio)).font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer()

            if !producto.disponible {
                Chip(texto: "No disponible")
            } else if cantidad == 0 {
                Button("Agregar", action: onAgregar).buttonStyle(.bordered)
            } else {
                HStack(spacing: 12) {
                    Button(action: onQuitar) {
                        Image(systemName: "minus.circle")
                    }
                    .accessibilityLabel("Quitar uno")
                    Text("\(cantidad)").font(.title3.weight(.medium))
                    Button(action: onAgregar) {
                        Image(systemName: "plus.circle")
                    }
                    .accessibilityLabel("Agregar uno más")
                }
                .font(.title2)
            }
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
