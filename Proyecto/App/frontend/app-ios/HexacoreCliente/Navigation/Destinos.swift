import Foundation

/// Las tres secciones del rol Cliente (SAD §2, responsabilidades del
/// contenedor App Móvil Cliente): eventos (con acceso a sus entradas),
/// parqueadero y pedidos. "Entradas" ya no es una pestaña propia — se llega
/// a ella desde el evento correspondiente en Inicio.
/// (Puerto 1:1 de `navigation/Destinos.kt` de la app Android.)
enum DestinoCliente: CaseIterable, Hashable {
    case inicio, parqueadero, pedidos

    var etiqueta: String {
        switch self {
        case .inicio: return "Inicio"
        case .parqueadero: return "Parqueadero"
        case .pedidos: return "Pedidos"
        }
    }

    var icono: String {
        switch self {
        case .inicio: return "house.fill"
        case .parqueadero: return "mappin.and.ellipse"
        case .pedidos: return "cart.fill"
        }
    }
}

/// Secciones del rol Personal/Empleado (SAD §2/§4: Personal, Turno,
/// RegistroAsistencia — CU-016..CU-020). Turnos, Asistencia, Incidentes y
/// Emergencia son comunes a todo el personal; el resto se activa según el
/// `Cargo` del usuario autenticado — ver `destinosPara`.
enum DestinoPersonal: CaseIterable, Hashable {
    case turnos, asistencia, validarEntradas, parqueaderoOperativo, pedidosRestaurante, validarPersonal, incidentes, emergencia

    var etiqueta: String {
        switch self {
        case .turnos: return "Turnos"
        case .asistencia: return "Asistencia"
        case .validarEntradas: return "Validar entradas"
        case .parqueaderoOperativo: return "Parqueadero"
        case .pedidosRestaurante: return "Pedidos"
        case .validarPersonal: return "Validar personal"
        case .incidentes: return "Incidentes"
        case .emergencia: return "Emergencia"
        }
    }

    var icono: String {
        switch self {
        case .turnos: return "person.fill"
        case .asistencia: return "checkmark.circle.fill"
        case .validarEntradas: return "list.bullet"
        case .parqueaderoOperativo: return "mappin.and.ellipse"
        case .pedidosRestaurante: return "cart.fill"
        case .validarPersonal: return "person.fill"
        case .incidentes: return "pencil"
        case .emergencia: return "exclamationmark.triangle.fill"
        }
    }
}

/// El Jefe de Personal solo tiene la validación de ingreso/salida del
/// personal; los demás cargos comparten Turnos/Asistencia/Incidentes/
/// Emergencia más su función operativa específica.
func destinosPara(_ cargo: Cargo?) -> [DestinoPersonal] {
    if cargo == .jefePersonal { return [.validarPersonal] }

    let especifico: DestinoPersonal?
    switch cargo {
    case .entrada: especifico = .validarEntradas
    case .parqueadero: especifico = .parqueaderoOperativo
    case .restaurante: especifico = .pedidosRestaurante
    default: especifico = nil
    }

    return [.turnos, .asistencia, especifico, .incidentes, .emergencia].compactMap { $0 }
}
