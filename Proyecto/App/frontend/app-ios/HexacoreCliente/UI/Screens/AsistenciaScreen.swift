import SwiftUI

/// Registro de entrada/salida del turno del día (CU-016..CU-020: asistencia).
/// (Puerto 1:1 de `ui/screens/AsistenciaScreen.kt` de la app Android.)
struct AsistenciaScreen: View {
    var turno: Turno? = MockData.turnos.first

    @State private var registro: RegistroAsistencia?

    private static let formatoHora: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "h:mm a"
        return f
    }()

    var body: some View {
        VStack {
            if let turno {
                VStack(spacing: 12) {
                    Text(turno.eventoNombre).font(.title2.weight(.semibold))
                    Text(turno.zona).font(.subheadline)
                    Text("\(turno.fecha) · \(turno.horaInicio) a \(turno.horaFin)").font(.subheadline)

                    if let reg = registro, let horaEntrada = reg.horaEntrada {
                        if let horaSalida = reg.horaSalida {
                            Text("Turno registrado: \(horaEntrada) a \(horaSalida)")
                        } else {
                            Text("En turno desde las \(horaEntrada)")
                            Button("Registrar salida") {
                                registro?.horaSalida = Self.formatoHora.string(from: Date())
                            }
                            .buttonStyle(.borderedProminent)
                            .frame(maxWidth: .infinity)
                        }
                    } else {
                        Text("Sin registrar todavía")
                        Button("Registrar entrada") {
                            registro = RegistroAsistencia(turnoId: turno.id, horaEntrada: Self.formatoHora.string(from: Date()))
                        }
                        .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(16)
            } else {
                Text("No tienes turno asignado.").foregroundStyle(.secondary)
            }
            Spacer()
        }
        .onAppear {
            if let turno, registro == nil { registro = RegistroAsistencia(turnoId: turno.id) }
        }
    }
}
