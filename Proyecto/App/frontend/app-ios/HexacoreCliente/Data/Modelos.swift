import Foundation

/// Modelos de datos básicos del cliente (SAD §4, modelo de dominio).
/// Por ahora son solo la forma de los datos que consumirá la UI; la carga real
/// vendrá del API Gateway cuando el backend esté disponible — ver `MockData`.
/// (Puerto 1:1 de `data/Modelos.kt` de la app Android.)

struct Evento: Identifiable, Equatable {
    let id: String
    let nombre: String
    let fecha: String
    let lugar: String
    let precioDesde: Double
    /// true si el evento ya ocurrió — separa "Próximos" de "Pasados" en Inicio.
    var pasado: Bool = false
    /// Fecha real del evento, solo para ordenar (más reciente primero) — `fecha`
    /// es el texto ya formateado para mostrar y no se puede ordenar de forma fiable.
    let fechaOrden: Date
    /// Imagen/poster del evento, la sube el Administrador al crear el evento
    /// desde el Portal Web; aquí llega como URL servida por el API Gateway. Si
    /// un evento todavía no tiene imagen (o el backend no responde), la UI cae
    /// en un poster con la inicial del nombre — ver `PosterPlaceholder`.
    var imagenUrl: String? = nil
}

enum EstadoEntrada {
    case valida, enReventa, usada

    var etiqueta: String {
        switch self {
        case .valida: return "Válida"
        case .enReventa: return "En reventa"
        case .usada: return "Usada"
        }
    }
}

/// Boleta del cliente para un evento (CU-001..CU-010). Trae la localidad
/// asignada (zona/fila/silla) además del QR de ingreso, siguiendo el formato
/// de boleta con el que ya está familiarizado el cliente (p. ej. TuBoleta Pass).
struct Entrada: Identifiable, Equatable {
    let id: String
    let eventoId: String
    let eventoNombre: String
    let fecha: String
    let lugar: String
    let zona: String
    let fila: String
    let silla: String
    let codigoQr: String
    var estado: EstadoEntrada
    /// Identifica esta boleta puntual — único por entrada, para trazabilidad/soporte.
    let numeroTicket: String
    /// Identifica el pago con el que se generó esta entrada — único, para conciliar con el cobro.
    let numeroTransaccion: String

    static func == (a: Entrada, b: Entrada) -> Bool { a.id == b.id }
}

/// Reserva de parqueadero ya pagada por el cliente (CU-021..CU-025). Al igual
/// que una `Entrada`, una vez pagada trae su propio QR para el ingreso/salida
/// del vehículo — no se genera hasta que el pago se confirma. Incluye el
/// lugar del evento (para el botón "Cómo llegar") y la hora de ingreso una
/// vez el personal de parqueadero registra que el vehículo ya entró, para
/// poder mostrar cuánto tiempo lleva parqueado.
struct ReservaParqueadero: Identifiable, Equatable {
    let id: String
    let eventoNombre: String
    let lugarEvento: String
    let espacioId: String
    let zona: String
    let codigoQr: String
    var horaIngreso: Date? = nil
}

// El pedido nace sin pagar (sin QR); al confirmarse el pago se le asigna el
// código QR que el cliente muestra en el establecimiento para retirarlo.
enum EstadoPedido {
    case pendientePago, enPreparacion, listo, entregado

    var etiqueta: String {
        switch self {
        case .pendientePago: return "Pendiente de pago"
        case .enPreparacion: return "En preparación"
        case .listo: return "Listo"
        case .entregado: return "Entregado"
        }
    }
}

struct Pedido: Identifiable, Equatable {
    let id: String
    let establecimiento: String
    let items: [String]
    let total: Double
    var estado: EstadoPedido
    var codigoQr: String? = nil

    static func == (a: Pedido, b: Pedido) -> Bool { a.id == b.id }
}

/// Punto de comida del evento (CU-011..CU-015) donde el cliente puede pedir.
struct Establecimiento: Identifiable, Equatable {
    let id: String
    let nombre: String
    let descripcion: String
}

/// Producto del menú de un `Establecimiento`.
struct ProductoMenu: Identifiable, Equatable {
    let id: String
    let establecimientoId: String
    let nombre: String
    let precio: Double
    var disponible: Bool = true
}

/// Línea del pedido que el cliente está armando antes de pagar.
struct ItemCarrito: Identifiable, Equatable {
    var producto: ProductoMenu
    var cantidad: Int

    var id: String { producto.id }
}

/// Formato de moneda simple compartido por toda la UI (equivalente a los
/// `String.format("$%.0f", …)` de la app Android).
func moneda(_ valor: Double) -> String {
    "$" + String(format: "%.0f", valor)
}
