import SwiftUI

/// Protocolo de evacuación por cargo (CU-010). Quien activa, coordina y
/// finaliza la evacuación es el Supervisor de Emergencia u Organizador desde
/// el Portal Web Administrativo — no el personal operativo (Entrada,
/// Parqueadero, Restaurante): intentarlo desde su rol sería justamente el
/// camino de excepción CU-010H (activación no autorizada), que el sistema
/// debe rechazar. Este personal solo *recibe* la alerta — en producción, vía
/// notificación push que abre esta ventana automáticamente; aquí, sin ese
/// backend todavía, el botón simula la llegada de esa alerta.
/// (Puerto 1:1 de `ui/screens/EmergenciaScreen.kt` de la app Android.)
struct EmergenciaScreen: View {
    let cargo: Cargo?
    var instrucciones: [Cargo: InstruccionEmergencia] = MockData.instruccionesEmergencia

    @State private var ventanaVisible = false

    private var instruccion: InstruccionEmergencia? { cargo.flatMap { instrucciones[$0] } }

    var body: some View {
        VStack {
            VStack(spacing: 16) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(.orange)
                Text("No hay ninguna emergencia activa en este momento. El Supervisor de Emergencia la activa desde el Portal Web Administrativo; aquí solo recibirás la alerta.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                Button("Simular alerta recibida (demo)") { ventanaVisible = true }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            Spacer()
        }
        .padding(16)
        .alert("Protocolo de evacuación activo", isPresented: $ventanaVisible) {
            Button("Entendido", role: .cancel) {}
        } message: {
            if let instruccion {
                Text("Ruta: \(instruccion.ruta)\nTu puesto: \(instruccion.puestoPersonal)\nQué debes hacer: \(instruccion.protocolo)")
            } else {
                Text("No hay instrucciones para tu cargo todavía.")
            }
        }
    }
}
