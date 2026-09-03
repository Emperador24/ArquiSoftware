import SwiftUI

/// Login único para ambos roles (SAD §3): las mismas credenciales identifican
/// si quien entra es Cliente o Personal — ver `MockAuth`. Sin backend
/// todavía, valida contra los usuarios quemados de la demo.
/// (Puerto 1:1 de `ui/screens/LoginScreen.kt` de la app Android.)
struct LoginScreen: View {
    let onLoginExitoso: (Usuario) -> Void

    @State private var correo = ""
    @State private var contrasena = ""
    @State private var error = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            Text("HEXACORE Cliente").font(.largeTitle.bold())
            Text("Inicia sesión")
                .font(.body)
                .foregroundStyle(.secondary)
                .padding(.top, 4)
                .padding(.bottom, 32)

            TextField("Correo", text: $correo)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .onChange(of: correo) { _ in error = false }

            SecureField("Contraseña", text: $contrasena)
                .textFieldStyle(.roundedBorder)
                .padding(.top, 12)
                .onChange(of: contrasena) { _ in error = false }

            if error {
                Text("Correo o contraseña incorrectos.")
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding(.top, 8)
            }

            Button {
                if let usuario = MockAuth.autenticar(correo: correo, contrasena: contrasena) {
                    onLoginExitoso(usuario)
                } else {
                    error = true
                }
            } label: {
                Text("Ingresar").frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 20)

            Text("Demo (clave: 1234) — Cliente: cliente@hexacore.com · Personal: personal@hexacore.com (Entrada), parqueadero@hexacore.com, restaurante@hexacore.com, jefepersonal@hexacore.com")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.top, 24)

            Spacer()
            Spacer()
        }
        .padding(24)
    }
}
