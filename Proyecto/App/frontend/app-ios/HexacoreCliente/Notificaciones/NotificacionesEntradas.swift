import Foundation
import UserNotifications

/// Notificación local que simula, en este mismo dispositivo, la que le
/// llegaría al otro usuario cuando alguien le envía una entrada — no hay
/// backend/push real todavía que la entregue en el teléfono del destinatario.
/// (Puerto 1:1 de `notificaciones/NotificacionesEntradas.kt` de la app Android.)
enum NotificacionesEntradas {

    /// Pide el permiso de notificaciones si todavía no se ha preguntado —
    /// equivalente a `POST_NOTIFICATIONS` en Android 13+.
    static func solicitarPermiso() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .notDetermined else { return }
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
        }
    }

    static func notificarEntradaRecibida(remitente: String, eventoNombre: String) {
        let contenido = UNMutableNotificationContent()
        contenido.title = "🎟️ Recibiste una entrada"
        contenido.body = "\(remitente) te envió su entrada para \(eventoNombre)."
        contenido.sound = .default

        let solicitud = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: contenido,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        )
        UNUserNotificationCenter.current().add(solicitud)
    }
}
