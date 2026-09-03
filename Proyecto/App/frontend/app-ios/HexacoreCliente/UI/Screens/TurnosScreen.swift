import SwiftUI

/// Turnos asignados al empleado (CU-016..CU-020: asignación y turnos).
/// (Puerto 1:1 de `ui/screens/TurnosScreen.kt` de la app Android.)
struct TurnosScreen: View {
    var turnos: [Turno] = MockData.turnos

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(turnos) { turno in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(turno.eventoNombre).font(.title3.weight(.medium))
                        Text(turno.zona).font(.subheadline)
                        Text("\(turno.fecha) · \(turno.horaInicio) a \(turno.horaFin)").font(.subheadline)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(16)
        }
    }
}
