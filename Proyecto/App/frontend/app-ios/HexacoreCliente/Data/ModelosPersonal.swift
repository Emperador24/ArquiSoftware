import Foundation

/// Modelos básicos del rol Personal/Empleado (SAD §4: Personal, Turno,
/// RegistroAsistencia — CU-016..CU-020). Al igual que los modelos de Cliente,
/// hoy son datos de ejemplo hasta que exista el Servicio de Personal.
/// (Puerto 1:1 de `data/ModelosPersonal.kt` de la app Android.)

struct Turno: Identifiable, Equatable {
    let id: String
    let eventoNombre: String
    let zona: String
    let fecha: String
    let horaInicio: String
    let horaFin: String
}

struct RegistroAsistencia: Equatable {
    let turnoId: String
    var horaEntrada: String? = nil
    var horaSalida: String? = nil
}

/// Incidente reportado por cualquier miembro del personal durante su turno.
struct Incidente: Identifiable, Equatable {
    let id: String
    let titulo: String
    let descripcion: String
    let zona: String
    let hora: String
}

/// Protocolo de evacuación específico para el cargo de un empleado (CU-010:
/// evacuación ante emergencias), pensado para leerse de un vistazo en la
/// ventana emergente que aparece al activarse una emergencia — ver
/// `EmergenciaScreen`.
struct InstruccionEmergencia {
    /// Ruta de evacuación a seguir.
    let ruta: String
    /// Dónde debe ubicarse este trabajador durante la evacuación.
    let puestoPersonal: String
    /// Qué debe hacer, en pocas palabras.
    let protocolo: String
}

/// Boleta que el personal de entrada valida en la puerta (CU-0xx: ingreso).
/// Reutiliza la forma de `Entrada` del cliente — misma boleta, vista operativa.
struct EntradaPorValidar: Identifiable, Equatable {
    let id: String
    let eventoNombre: String
    let zona: String
    let codigoQr: String
    var validada: Bool = false

    static func == (a: EntradaPorValidar, b: EntradaPorValidar) -> Bool { a.id == b.id }
}

/// Reserva de parqueadero desde la perspectiva del personal operativo: la
/// escanean al ingreso (asignan puesto) y al registrar la salida, donde se
/// calcula el cobro por hora si no venía prepagada desde la reserva.
struct ReservaParqueaderoOperativa: Identifiable, Equatable {
    let id: String
    let codigoQr: String
    let placa: String
    let prepagada: Bool
    var espacioAsignado: String? = nil
    var horaIngreso: Date? = nil
    var horaSalida: Date? = nil

    static func == (a: ReservaParqueaderoOperativa, b: ReservaParqueaderoOperativa) -> Bool { a.id == b.id }
}

/// Miembro del personal que el Jefe de Personal valida al ingreso/salida por QR.
struct PersonalOperativo: Identifiable, Equatable {
    let id: String
    let nombre: String
    let cargo: Cargo
    let codigoQr: String
    var ingresoRegistrado: Bool = false
    var salidaRegistrada: Bool = false

    static func == (a: PersonalOperativo, b: PersonalOperativo) -> Bool { a.id == b.id }
}
