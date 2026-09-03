import SwiftUI
import Foundation

/// Ingreso y salida de vehículos (cargo Parqueadero). Al ingresar, el
/// personal asigna un puesto libre; al salir, se calcula el cobro por hora
/// salvo que la reserva ya viniera prepagada desde que se hizo (CU-021..025).
/// (Puerto 1:1 de `ui/screens/ParqueaderoOperativoScreen.kt` de la app Android.)
struct ParqueaderoOperativoScreen: View {
    var porIngresarInicial: [ReservaParqueaderoOperativa] = MockData.reservasParqueaderoPorIngresar
    var enParqueaderoInicial: [ReservaParqueaderoOperativa] = MockData.vehiculosEnParqueadero
    var espaciosDisponiblesIniciales: [String] = MockData.espaciosDisponiblesParaAsignar

    @State private var ingresar: [ReservaParqueaderoOperativa] = []
    @State private var adentro: [ReservaParqueaderoOperativa] = []
    @State private var libres: [String] = []

    private static let formatoHora: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "h:mm a"
        return f
    }()

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                Text("Por ingresar").font(.title3.weight(.medium)).frame(maxWidth: .infinity, alignment: .leading)

                ForEach(ingresar) { reserva in
                    ReservaPorIngresarCard(reserva: reserva, espacioSugerido: libres.first) {
                        guard let espacio = libres.first else { return }
                        libres.removeFirst()
                        ingresar.removeAll { $0.id == reserva.id }
                        var actualizada = reserva
                        actualizada.espacioAsignado = espacio
                        actualizada.horaIngreso = Date()
                        adentro.append(actualizada)
                    }
                }

                Divider().padding(.vertical, 4)
                Text("En el parqueadero").font(.title3.weight(.medium)).frame(maxWidth: .infinity, alignment: .leading)

                ForEach(adentro) { reserva in
                    VehiculoEnLoteCard(reserva: reserva, formatoHora: Self.formatoHora) {
                        if let i = adentro.firstIndex(where: { $0.id == reserva.id }) {
                            adentro[i].horaSalida = Date()
                        }
                    }
                }
            }
            .padding(16)
        }
        .onAppear {
            if ingresar.isEmpty && adentro.isEmpty {
                ingresar = porIngresarInicial
                adentro = enParqueaderoInicial
                libres = espaciosDisponiblesIniciales
            }
        }
    }
}

private struct ReservaPorIngresarCard: View {
    let reserva: ReservaParqueaderoOperativa
    let espacioSugerido: String?
    let onAsignar: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(reserva.placa).font(.title3.weight(.medium))
            Text(reserva.codigoQr).font(.caption)
            Chip(texto: reserva.prepagada ? "Ya pagado" : "Pago pendiente")
            Button(espacioSugerido != nil ? "Asignar puesto \(espacioSugerido!)" : "Sin puestos disponibles", action: onAsignar)
                .buttonStyle(.borderedProminent)
                .disabled(espacioSugerido == nil)
                .frame(maxWidth: .infinity)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

private struct VehiculoEnLoteCard: View {
    let reserva: ReservaParqueaderoOperativa
    let formatoHora: DateFormatter
    let onRegistrarSalida: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(reserva.placa) · \(reserva.espacioAsignado ?? "—")").font(.title3.weight(.medium))
            if let horaIngreso = reserva.horaIngreso {
                Text("Ingreso: \(formatoHora.string(from: horaIngreso))").font(.subheadline)
            }

            if let horaSalida = reserva.horaSalida {
                Text("Salida: \(formatoHora.string(from: horaSalida))").font(.subheadline)
                if reserva.prepagada {
                    Chip(texto: "Ya pagado", destacado: true)
                } else if let horaIngreso = reserva.horaIngreso {
                    // Si el turno cruza medianoche la resta puede dar negativo;
                    // se corrige sumando un día completo de minutos.
                    let minutosCrudos = Int(horaSalida.timeIntervalSince(horaIngreso) / 60)
                    let minutos = minutosCrudos < 0 ? minutosCrudos + 24 * 60 : minutosCrudos
                    let horas = max(1, Int(ceil(Double(minutos) / 60.0)))
                    let total = Double(horas) * MockData.tarifaParqueaderoPorHora
                    Text("\(horas) h · Total a cobrar: \(moneda(total))").font(.title3.weight(.medium))
                }
            } else {
                Button("Registrar salida", action: onRegistrarSalida)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
