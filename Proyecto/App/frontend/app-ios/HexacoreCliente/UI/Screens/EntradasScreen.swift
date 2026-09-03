import SwiftUI

/// Entradas del cliente para un evento puntual (CU-006, CU-009: QR de
/// ingreso y envío de una entrada a otro usuario), a las que se llega
/// tocando ese evento en Inicio — no es una pestaña propia. Presentadas como
/// boletas deslizables, al estilo de apps de boletería como TuBoleta Pass.
///
/// La reventa no se gestiona desde la app móvil (queda en el Portal Web);
/// aquí la única transferencia posible es enviarle la entrada directamente
/// a otro usuario por su correo, lo que le llega como notificación.
/// (Puerto 1:1 de `ui/screens/EntradasScreen.kt` de la app Android.)
struct EntradasScreen: View {
    let eventoId: String
    var nombreRemitente: String = ""

    @State private var lista: [Entrada]
    @State private var paginaActual = 0
    @State private var entradaAEnviar: Entrada?
    @State private var mensajeConfirmacion: String?

    init(eventoId: String, entradas: [Entrada]? = nil, nombreRemitente: String = "") {
        self.eventoId = eventoId
        self.nombreRemitente = nombreRemitente
        _lista = State(initialValue: entradas ?? MockData.entradas.filter { $0.eventoId == eventoId })
    }

    var body: some View {
        Group {
            if lista.isEmpty {
                VStack {
                    Spacer()
                    Text("Todavía no tienes entradas para este evento.").foregroundStyle(.secondary)
                    Spacer()
                }
            } else {
                VStack(spacing: 0) {
                    PagerHeader(paginaActual: paginaActual, total: lista.count)

                    TabView(selection: $paginaActual) {
                        ForEach(Array(lista.enumerated()), id: \.element.id) { indice, entrada in
                            ScrollView {
                                EntradaCard(
                                    entrada: entrada,
                                    evento: MockData.eventos.first { $0.id == entrada.eventoId },
                                    onEnviar: { entradaAEnviar = entrada }
                                )
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
        .sheet(item: $entradaAEnviar) { entrada in
            DialogoEnviarEntrada(
                onCancelar: { entradaAEnviar = nil },
                onEnviar: { correo in
                    lista.removeAll { $0.id == entrada.id }
                    NotificacionesEntradas.notificarEntradaRecibida(
                        remitente: nombreRemitente.isEmpty ? "HEXACORE Cliente" : nombreRemitente,
                        eventoNombre: entrada.eventoNombre
                    )
                    mensajeConfirmacion = "Entrada enviada a \(correo)."
                    entradaAEnviar = nil
                }
            )
        }
        .alert("Entrada enviada", isPresented: Binding(get: { mensajeConfirmacion != nil }, set: { if !$0 { mensajeConfirmacion = nil } })) {
            Button("Aceptar", role: .cancel) { mensajeConfirmacion = nil }
        } message: {
            Text(mensajeConfirmacion ?? "")
        }
        .onAppear { NotificacionesEntradas.solicitarPermiso() }
    }
}

private struct DialogoEnviarEntrada: View {
    let onCancelar: () -> Void
    let onEnviar: (String) -> Void

    @State private var correo = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("Se transferirá esta entrada a la cuenta de este correo. Dejarás de tenerla en tu app.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    TextField("Correo del destinatario", text: $correo)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
            }
            .navigationTitle("Enviar entrada")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar", action: onCancelar)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enviar") { onEnviar(correo) }.disabled(!correo.contains("@"))
                }
            }
        }
        .presentationDetents([.medium])
    }
}

private struct PagerHeader: View {
    let paginaActual: Int
    let total: Int

    var body: some View {
        VStack(spacing: 8) {
            Text("Entrada \(paginaActual + 1) de \(total)").font(.headline)
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

private struct EntradaCard: View {
    let entrada: Entrada
    let evento: Evento?
    let onEnviar: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Poster del evento (Evento.imagenUrl) — lo sube el Administrador
            // al crear el evento en el Portal Web; da contexto visual antes de
            // entrar en el detalle puntual de la boleta.
            if let imagenUrl = evento?.imagenUrl, let url = URL(string: imagenUrl) {
                AsyncImage(url: url) { fase in
                    (fase.image ?? Image(systemName: "photo")).resizable().scaledToFill()
                }
                .frame(height: 140)
                .clipped()
            }

            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(entrada.eventoNombre).font(.title2.weight(.semibold))
                    Text("\(entrada.fecha) · \(entrada.lugar)").font(.subheadline).foregroundStyle(.secondary)
                }

                Chip(texto: entrada.estado.etiqueta)

                Divider()

                HStack {
                    CampoLocalidad(etiqueta: "Zona", valor: entrada.zona)
                    Spacer()
                    CampoLocalidad(etiqueta: "Fila", valor: entrada.fila)
                    Spacer()
                    CampoLocalidad(etiqueta: "Silla", valor: entrada.silla)
                }

                Divider()

                // Identificadores únicos de esta boleta y del pago que la
                // generó, para poder rastrear/conciliar cualquier reclamo.
                VStack(alignment: .leading, spacing: 4) {
                    FilaDato(etiqueta: "N.º de ticket", valor: entrada.numeroTicket)
                    FilaDato(etiqueta: "N.º de transacción", valor: entrada.numeroTransaccion)
                }

                Divider()

                HStack {
                    Spacer()
                    QrPlaceholder(codigo: entrada.codigoQr)
                    Spacer()
                }

                // La reventa se gestiona desde el Portal Web, no desde la app
                // móvil: aquí solo se puede enviar la entrada a otro usuario.
                if entrada.estado == .valida {
                    Button(action: onEnviar) {
                        Text("Enviar entrada").frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding(20)
        }
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

private struct FilaDato: View {
    let etiqueta: String
    let valor: String

    var body: some View {
        HStack {
            Text(etiqueta).foregroundStyle(.secondary)
            Spacer()
            Text(valor)
        }
    }
}

private struct CampoLocalidad: View {
    let etiqueta: String
    let valor: String

    var body: some View {
        VStack {
            Text(etiqueta).font(.caption2).foregroundStyle(.secondary)
            Text(valor).font(.title3.weight(.medium))
        }
    }
}

struct Chip: View {
    let texto: String
    var destacado: Bool = false

    var body: some View {
        Text(texto)
            .font(.footnote.weight(.medium))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(destacado ? Color.accentColor.opacity(0.25) : Color(.tertiarySystemFill))
            .clipShape(Capsule())
    }
}
