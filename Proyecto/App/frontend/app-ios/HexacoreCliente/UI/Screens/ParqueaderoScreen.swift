import SwiftUI
import UIKit

/// Reservas de parqueadero del cliente (CU-021..CU-025), mostradas igual que
/// las entradas: una boleta deslizable por reserva, con su QR, un botón
/// "Cómo llegar" que abre el mapa con la ruta, y — una vez el personal
/// registra el ingreso del vehículo — el tiempo parqueado en vivo.
/// (Puerto 1:1 de `ui/screens/ParqueaderoScreen.kt` de la app Android.)
struct ParqueaderoScreen: View {
    var reservas: [ReservaParqueadero] = [MockData.reservaParqueadero]

    @State private var paginaActual = 0

    var body: some View {
        if reservas.isEmpty {
            VStack {
                Spacer()
                Text("No tienes reservas de parqueadero.").foregroundStyle(.secondary)
                Spacer()
            }
        } else {
            VStack(spacing: 0) {
                if reservas.count > 1 {
                    PagerHeaderParqueadero(paginaActual: paginaActual, total: reservas.count)
                }

                TabView(selection: $paginaActual) {
                    ForEach(Array(reservas.enumerated()), id: \.element.id) { indice, reserva in
                        ScrollView {
                            ReservaCard(reserva: reserva)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 16)
                        }
                        .tag(indice)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
        }
    }
}

private struct PagerHeaderParqueadero: View {
    let paginaActual: Int
    let total: Int

    var body: some View {
        VStack(spacing: 8) {
            Text("Reserva \(paginaActual + 1) de \(total)").font(.headline)
            HStack(spacing: 6) {
                ForEach(0..<total, id: \.self) { indice in
                    Circle()
                        .fill(indice == paginaActual ? Color.accentColor : Color(.tertiaryLabel))
                        .frame(width: indice == paginaActual ? 10 : 8, height: indice == paginaActual ? 10 : 8)
                }
            }
        }
        .padding(.top, 16)
    }
}

private struct ReservaCard: View {
    let reserva: ReservaParqueadero

    @State private var horaIngreso: Date?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(reserva.eventoNombre).font(.title2.weight(.semibold))
                Text(reserva.lugarEvento).font(.subheadline).foregroundStyle(.secondary)
            }

            Chip(texto: "\(reserva.zona) · \(reserva.espacioId)")

            Button {
                abrirMapa(hacia: reserva.lugarEvento)
            } label: {
                Text("Cómo llegar").frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            Divider()

            HStack {
                Spacer()
                QrPlaceholder(codigo: reserva.codigoQr)
                Spacer()
            }

            Divider()

            // El conteo de horas no arranca hasta que el personal de
            // parqueadero valide este QR en la entrada y registre el
            // ingreso del vehículo (ParqueaderoOperativoScreen). Como el
            // ingreso lo registra otro rol y no hay backend real conectando
            // ambas apps, se simula esa validación con un botón de demo.
            if let horaIngreso {
                TiempoParqueadoEnVivo(horaIngreso: horaIngreso)
            } else {
                EsperandoValidacion { horaIngreso = Date() }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .onAppear { horaIngreso = reserva.horaIngreso }
    }

    private func abrirMapa(hacia lugar: String) {
        guard let codificado = lugar.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://maps.apple.com/?daddr=\(codificado)") else { return }
        UIApplication.shared.open(url)
    }
}

private struct EsperandoValidacion: View {
    let onSimularValidacion: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Text("Muestra este código QR al personal en la entrada del parqueadero para que valide tu ingreso.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
            Button("Simular validación en la entrada (demo)", action: onSimularValidacion)
                .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct TiempoParqueadoEnVivo: View {
    let horaIngreso: Date

    @State private var ahora = Date()
    private let temporizador = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            Text("Llevas parqueado").font(.subheadline.weight(.medium))
            Text(tiempoFormateado)
                .font(.title2.weight(.semibold))
        }
        .frame(maxWidth: .infinity)
        .onReceive(temporizador) { ahora = $0 }
    }

    private var tiempoFormateado: String {
        let totalSegundos = max(0, Int(ahora.timeIntervalSince(horaIngreso)))
        let horas = totalSegundos / 3600
        let minutos = (totalSegundos % 3600) / 60
        let segundos = totalSegundos % 60
        return String(format: "%dh %02dm %02ds", horas, minutos, segundos)
    }
}
