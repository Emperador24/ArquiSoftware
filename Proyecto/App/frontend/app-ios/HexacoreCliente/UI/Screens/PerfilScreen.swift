import SwiftUI
import PhotosUI

/// Perfil del usuario: nombre y rol son de solo lectura (los define el
/// sistema), correo, teléfono y foto se pueden cambiar aquí.
/// (Puerto 1:1 de `ui/screens/PerfilScreen.kt` de la app Android.)
struct PerfilScreen: View {
    let usuario: Usuario
    let onGuardar: (Usuario) -> Void

    @State private var correo: String
    @State private var telefono: String
    @State private var fotoUri: String?
    @State private var guardado = false
    @State private var seleccionFoto: PhotosPickerItem?

    init(usuario: Usuario, onGuardar: @escaping (Usuario) -> Void) {
        self.usuario = usuario
        self.onGuardar = onGuardar
        _correo = State(initialValue: usuario.correo)
        _telefono = State(initialValue: usuario.telefono)
        _fotoUri = State(initialValue: usuario.fotoUri)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Avatar(nombre: usuario.nombre, fotoUri: fotoUri, tamano: 96)

                PhotosPicker(selection: $seleccionFoto, matching: .images) {
                    Text("Cambiar foto")
                }
                .buttonStyle(.bordered)
                .onChange(of: seleccionFoto) { nuevaSeleccion in
                    Task { await cargarFoto(nuevaSeleccion) }
                }

                Text(usuario.nombre)
                    .font(.title2.weight(.semibold))
                    .padding(.top, 12)

                TextField("Correo", text: $correo)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .onChange(of: correo) { _ in guardado = false }

                TextField("Teléfono", text: $telefono)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.phonePad)
                    .onChange(of: telefono) { _ in guardado = false }

                Button {
                    var actualizado = usuario
                    actualizado.correo = correo
                    actualizado.telefono = telefono
                    actualizado.fotoUri = fotoUri
                    onGuardar(actualizado)
                    guardado = true
                } label: {
                    Text("Guardar cambios").frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                if guardado {
                    Text("Cambios guardados.").font(.caption).foregroundStyle(.secondary)
                }
            }
            .padding(24)
        }
    }

    private func cargarFoto(_ item: PhotosPickerItem?) async {
        guard let item, let datos = try? await item.loadTransferable(type: Data.self) else { return }
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".jpg")
        guard (try? datos.write(to: url)) != nil else { return }
        fotoUri = url.absoluteString
        guardado = false
    }
}
