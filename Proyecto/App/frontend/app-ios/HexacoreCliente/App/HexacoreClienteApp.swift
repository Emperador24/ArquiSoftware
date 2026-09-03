import SwiftUI
import UIKit

@main
struct HexacoreClienteApp: App {
    @StateObject private var appState = AppState(modoOscuroInicial: UITraitCollection.current.userInterfaceStyle == .dark)

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
        }
    }
}
