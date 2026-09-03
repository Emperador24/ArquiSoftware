import SwiftUI
import UIKit

/// Foto de perfil del usuario si eligió una desde la galería, o su inicial
/// sobre un círculo de color como respaldo — mismo patrón que el "poster" de
/// eventos en `InicioScreen`.
/// (Puerto 1:1 de `ui/components/Avatar.kt` de la app Android.)
struct Avatar: View {
    let nombre: String
    let fotoUri: String?
    var tamano: CGFloat = 48

    var body: some View {
        ZStack {
            Circle().fill(Color.accentColor.opacity(0.2))
            if let fotoUri, let url = URL(string: fotoUri), url.isFileURL, let datos = try? Data(contentsOf: url), let uiImagen = UIImage(data: datos) {
                // Foto elegida desde la galería del dispositivo (PerfilScreen).
                Image(uiImage: uiImagen).resizable().scaledToFill()
            } else if let fotoUri, let url = URL(string: fotoUri) {
                // URL remota, como los posters de evento servidos por el API Gateway.
                AsyncImage(url: url) { fase in
                    if let imagen = fase.image {
                        imagen.resizable().scaledToFill()
                    } else {
                        inicial
                    }
                }
            } else {
                inicial
            }
        }
        .frame(width: tamano, height: tamano)
        .clipShape(Circle())
    }

    private var inicial: some View {
        Text(nombre.trimmingCharacters(in: .whitespaces).first.map { String($0).uppercased() } ?? "?")
            .font(.system(size: tamano * 0.4, weight: .semibold))
            .foregroundStyle(Color.accentColor)
    }
}
