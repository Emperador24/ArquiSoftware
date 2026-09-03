import SwiftUI

/// Menú lateral estándar (ícono de tres barras): perfil resumido arriba,
/// navegación a Perfil/Ajustes y "Cerrar sesión" abajo — el patrón que trae
/// cualquier app con cuenta de usuario. SwiftUI no trae un
/// `ModalNavigationDrawer` nativo como Compose, así que este panel se monta
/// a mano dentro de `DrawerContainer`.
/// (Puerto de `ui/components/HexacoreDrawer.kt` de la app Android.)
struct HexacoreDrawerContent: View {
    let usuario: Usuario?
    let onPerfil: () -> Void
    let onAjustes: () -> Void
    let onCerrarSesion: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Avatar(nombre: usuario?.nombre ?? "", fotoUri: usuario?.fotoUri, tamano: 56)
                Text(usuario?.nombre ?? "")
                    .font(.title3.weight(.medium))
                    .padding(.top, 12)
                Text(usuario?.correo ?? "")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(20)

            Divider()

            FilaDrawer(icono: "person.fill", texto: "Perfil", onTap: onPerfil)
            FilaDrawer(icono: "gearshape.fill", texto: "Ajustes", onTap: onAjustes)

            Spacer()
            Divider()

            FilaDrawer(icono: "rectangle.portrait.and.arrow.right", texto: "Cerrar sesión", onTap: onCerrarSesion)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

private struct FilaDrawer: View {
    let icono: String
    let texto: String
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Image(systemName: icono).frame(width: 24)
                Text(texto)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .foregroundStyle(.primary)
    }
}

/// Envuelve el contenido principal de una app (Cliente o Personal) con un
/// menú lateral deslizable, equivalente al `ModalNavigationDrawer` de Compose.
struct DrawerContainer<Content: View>: View {
    @Binding var isOpen: Bool
    let usuario: Usuario?
    let onPerfil: () -> Void
    let onAjustes: () -> Void
    let onCerrarSesion: () -> Void
    @ViewBuilder var content: Content

    private let anchoDrawer: CGFloat = 300

    var body: some View {
        ZStack(alignment: .leading) {
            content
                .disabled(isOpen)

            if isOpen {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .onTapGesture { withAnimation(.easeInOut(duration: 0.2)) { isOpen = false } }
                    .transition(.opacity)
            }

            HexacoreDrawerContent(
                usuario: usuario,
                onPerfil: { withAnimation { isOpen = false }; onPerfil() },
                onAjustes: { withAnimation { isOpen = false }; onAjustes() },
                onCerrarSesion: { withAnimation { isOpen = false }; onCerrarSesion() }
            )
            .frame(width: anchoDrawer)
            .background(.regularMaterial)
            .ignoresSafeArea()
            .offset(x: isOpen ? 0 : -anchoDrawer)
        }
    }
}
