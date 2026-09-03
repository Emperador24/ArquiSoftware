import SwiftUI

/// Estado "listo para escanear": la vista que ve el personal antes de leer
/// un QR (de entrada, de pedido o de carné). Sin lector de cámara real
/// todavía — el botón simula la lectura tomando el siguiente código de la
/// lista mock (ver las pantallas que lo usan).
/// (Puerto 1:1 de `ui/components/EscanearQr.kt` de la app Android.)
struct EscanearQrCard: View {
    let instruccion: String
    let textoBoton: String
    let onEscanear: () -> Void

    var body: some View {
        GroupBox {
            VStack(spacing: 16) {
                Rectangle()
                    .strokeBorder(Color.secondary, lineWidth: 1)
                    .frame(width: 140, height: 140)
                    .overlay(Text("QR").font(.title2))
                Text(instruccion)
                    .font(.body)
                    .multilineTextAlignment(.center)
                Button(action: onEscanear) {
                    Text(textoBoton).frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(8)
            .frame(maxWidth: .infinity)
        }
    }
}
