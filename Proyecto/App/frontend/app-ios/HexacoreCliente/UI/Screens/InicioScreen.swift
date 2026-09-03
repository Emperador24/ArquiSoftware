import SwiftUI

/// Eventos del cliente (CU-001..CU-005), separados en Próximos/Pasados. Al
/// seleccionar un evento se entra a ver sus entradas con QR — ver
/// `EntradasScreen`, ya no es una pestaña propia.
/// (Puerto 1:1 de `ui/screens/InicioScreen.kt` de la app Android.)
struct InicioScreen: View {
    var eventos: [Evento] = MockData.eventos
    var onEventoClick: (Evento) -> Void = { _ in }

    @State private var pestanaSeleccionada = 0

    private var proximos: [Evento] { eventos.filter { !$0.pasado }.sorted { $0.fechaOrden > $1.fechaOrden } }
    private var pasados: [Evento] { eventos.filter { $0.pasado }.sorted { $0.fechaOrden > $1.fechaOrden } }
    private var visibles: [Evento] { pestanaSeleccionada == 0 ? proximos : pasados }

    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $pestanaSeleccionada) {
                Text("Próximos").tag(0)
                Text("Pasados").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)

            if visibles.isEmpty {
                Spacer()
                Text(pestanaSeleccionada == 0 ? "No tienes eventos próximos." : "No tienes eventos pasados.")
                    .foregroundStyle(.secondary)
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(visibles) { evento in
                            EventoCard(evento: evento) { onEventoClick(evento) }
                        }
                    }
                    .padding(16)
                }
            }
        }
    }
}

private struct EventoCard: View {
    let evento: Evento
    let onClick: () -> Void

    var body: some View {
        Button(action: onClick) {
            HStack(spacing: 12) {
                EventoPoster(evento: evento)
                VStack(alignment: .leading, spacing: 2) {
                    Text(evento.nombre).font(.title3.weight(.medium)).foregroundStyle(.primary)
                    Text("\(evento.fecha) · \(evento.lugar)").font(.subheadline).foregroundStyle(.secondary)
                }
                Spacer()
            }
            .padding(12)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}

// Poster del evento: la imagen la sube el Administrador al crear el evento en
// el Portal Web (Evento.imagenUrl). Si un evento todavía no tiene imagen, se
// usa un bloque con la inicial del nombre como respaldo.
private struct EventoPoster: View {
    let evento: Evento

    var body: some View {
        Group {
            if let imagenUrl = evento.imagenUrl, let url = URL(string: imagenUrl) {
                AsyncImage(url: url) { fase in
                    if let imagen = fase.image {
                        imagen.resizable().scaledToFill()
                    } else {
                        PosterPlaceholder(nombreEvento: evento.nombre)
                    }
                }
            } else {
                PosterPlaceholder(nombreEvento: evento.nombre)
            }
        }
        .frame(width: 56, height: 72)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct PosterPlaceholder: View {
    let nombreEvento: String

    var body: some View {
        ZStack {
            Color.accentColor.opacity(0.2)
            Text(nombreEvento.prefix(1).uppercased())
                .font(.title2.weight(.semibold))
                .foregroundStyle(Color.accentColor)
        }
    }
}
