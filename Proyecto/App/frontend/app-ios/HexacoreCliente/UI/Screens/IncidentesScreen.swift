import SwiftUI

/// Reporte de incidentes durante el turno, disponible para todo el personal
/// salvo Jefe de Personal (CU-016..CU-020, seguimiento operativo del evento).
/// (Puerto 1:1 de `ui/screens/IncidentesScreen.kt` de la app Android.)
struct IncidentesScreen: View {
    var incidentesIniciales: [Incidente] = MockData.incidentes

    @State private var incidentes: [Incidente] = []
    @State private var titulo = ""
    @State private var descripcion = ""

    private static let formatoHora: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "h:mm a"
        return f
    }()

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Reportar incidente").font(.title3.weight(.medium))
                    TextField("Título", text: $titulo).textFieldStyle(.roundedBorder)
                    TextField("Descripción", text: $descripcion, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(3...6)
                    Button("Reportar") {
                        guard !titulo.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                        incidentes.insert(
                            Incidente(
                                id: "inc-\(Int(Date().timeIntervalSince1970 * 1000))",
                                titulo: titulo,
                                descripcion: descripcion,
                                zona: "—",
                                hora: Self.formatoHora.string(from: Date())
                            ),
                            at: 0
                        )
                        titulo = ""
                        descripcion = ""
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(titulo.trimmingCharacters(in: .whitespaces).isEmpty)
                    .frame(maxWidth: .infinity)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                Divider().padding(.vertical, 4)
                Text("Reportados en este turno").font(.title3.weight(.medium))

                ForEach(incidentes) { incidente in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(incidente.titulo).font(.title3.weight(.medium))
                        if !incidente.descripcion.trimmingCharacters(in: .whitespaces).isEmpty {
                            Text(incidente.descripcion).font(.subheadline)
                        }
                        Text(incidente.hora).font(.caption)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(16)
        }
        .onAppear { if incidentes.isEmpty { incidentes = incidentesIniciales } }
    }
}
