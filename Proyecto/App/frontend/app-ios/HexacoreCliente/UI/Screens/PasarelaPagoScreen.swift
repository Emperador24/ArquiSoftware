import SwiftUI

/// Pago del pedido (CU-011). Sin pasarela de pagos real todavía: el cliente
/// elige entre medios de pago ya guardados (nunca se piden datos de tarjeta
/// aquí) y confirma; eso genera el pedido con su QR de retiro.
/// (Puerto 1:1 de `ui/screens/PasarelaPagoScreen.kt` de la app Android.)
struct PasarelaPagoScreen: View {
    let carrito: [ItemCarrito]
    let onConfirmarPago: () -> Void

    @State private var metodoSeleccionado = 0
    private let metodos = ["Tarjeta terminada en 4321", "Efectivo en el punto de entrega"]

    private var total: Double { carrito.reduce(0) { $0 + $1.producto.precio * Double($1.cantidad) } }

    var body: some View {
        VStack(spacing: 0) {
            List {
                Section("Resumen del pedido") {
                    ForEach(carrito) { item in
                        HStack {
                            Text("\(item.cantidad)x \(item.producto.nombre)")
                            Spacer()
                            Text(moneda(item.producto.precio * Double(item.cantidad)))
                        }
                    }
                    HStack {
                        Text("Total").font(.headline)
                        Spacer()
                        Text(moneda(total)).font(.headline)
                    }
                }

                Section("Método de pago") {
                    ForEach(metodos.indices, id: \.self) { indice in
                        Button {
                            metodoSeleccionado = indice
                        } label: {
                            HStack {
                                Image(systemName: metodoSeleccionado == indice ? "largecircle.fill.circle" : "circle")
                                Text(metodos[indice])
                            }
                        }
                        .foregroundStyle(.primary)
                    }
                }
            }
            .listStyle(.insetGrouped)

            Button {
                onConfirmarPago()
            } label: {
                Text("Confirmar pago").frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(16)
        }
    }
}
