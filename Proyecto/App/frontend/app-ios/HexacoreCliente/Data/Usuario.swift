import Foundation

/// Rol del usuario autenticado (SAD §3, roles del sistema). El login es el
/// mismo formulario para todos; el rol es lo que decide qué conjunto de
/// pantallas se muestra después — ver `MockAuth`.
/// (Puerto 1:1 de `data/Usuario.kt` de la app Android.)
enum RolUsuario {
    case cliente, personal
}

/// Puesto del personal en el evento. Cada cargo activa una función operativa
/// distinta en la App Móvil, además de las comunes a todo el personal
/// (Turnos, Asistencia, Incidentes, Emergencia) — Jefe de Personal es la
/// excepción: solo tiene la validación de ingreso/salida del personal.
enum Cargo {
    case entrada, parqueadero, restaurante, jefePersonal
}

/// - Parameter fotoUri: URI (como texto) de la foto de perfil elegida por el
///   usuario desde el selector de imágenes del sistema; nil hasta que la
///   cambie — ver `PerfilScreen`.
struct Usuario: Identifiable, Equatable {
    let id: String
    let nombre: String
    var correo: String
    var telefono: String = ""
    let rol: RolUsuario
    let cargo: Cargo?
    var fotoUri: String? = nil
}

/// Autenticación con credenciales quemadas (sin backend todavía). Cuando
/// exista el Servicio de Personal/Usuarios (SAD §5) esto se reemplaza por una
/// llamada real al API Gateway que devuelva el usuario, su rol y su cargo.
///
/// Hay un usuario demo de Personal por cada cargo para poder probar las
/// cuatro variantes de pantallas sin necesidad de un selector de cargo en la UI.
enum MockAuth {
    private static let contrasenaDemo = "1234"

    private static let usuarios: [Usuario] = [
        Usuario(id: "usr-cliente-1", nombre: "Ana Torres", correo: "cliente@hexacore.com", telefono: "300 123 4567", rol: .cliente, cargo: nil),
        Usuario(id: "usr-personal-1", nombre: "Luis Ramírez", correo: "personal@hexacore.com", telefono: "301 234 5678", rol: .personal, cargo: .entrada),
        Usuario(id: "usr-personal-2", nombre: "Marta Gómez", correo: "parqueadero@hexacore.com", telefono: "302 345 6789", rol: .personal, cargo: .parqueadero),
        Usuario(id: "usr-personal-3", nombre: "Carlos Peña", correo: "restaurante@hexacore.com", telefono: "303 456 7890", rol: .personal, cargo: .restaurante),
        Usuario(id: "usr-personal-4", nombre: "Isabel Rojas", correo: "jefepersonal@hexacore.com", telefono: "304 567 8901", rol: .personal, cargo: .jefePersonal)
    ]

    /// Devuelve el usuario si las credenciales coinciden, o nil si no.
    static func autenticar(correo: String, contrasena: String) -> Usuario? {
        guard contrasena == contrasenaDemo else { return nil }
        let correoBuscado = correo.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return usuarios.first { $0.correo.lowercased() == correoBuscado }
    }
}
