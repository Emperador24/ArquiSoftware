import SwiftUI

/// Placeholder visual del QR que recibe el cliente una vez algo queda pagado
/// (entrada, pedido o reserva de parqueadero — SAD §2/§4). La generación real
/// del código llega con la integración al backend; por ahora solo representa
/// que existe y muestra su identificador de texto.
/// (Puerto 1:1 de `ui/components/QrPlaceholder.kt` de la app Android.)
struct QrPlaceholder: View {
    let codigo: String

    var body: some View {
        VStack(spacing: 4) {
            Rectangle()
                .strokeBorder(Color.secondary, lineWidth: 1)
                .frame(width: 72, height: 72)
                .overlay(Text("QR").font(.headline))
            Text(codigo).font(.caption)
        }
    }
}
