# App Móvil Cliente (iOS)

Interfaz móvil para el rol Cliente (SAD §8, vista de contenedores) — contraparte nativa en iOS de
`../app-movil` (Android/Kotlin/Jetpack Compose). Mismo alcance funcional, puerto 1:1 pantalla por
pantalla: eventos y entradas con QR, parqueadero, pedidos (rol Cliente) y turnos, asistencia,
validación de entradas/pedidos/personal, incidentes y emergencia (rol Personal, según el `Cargo`
del usuario autenticado).

**Responsabilidad:** misma funcionalidad orientada a cliente/personal que la app Android y el
Portal Web Cliente, consumiendo el mismo backend vía API Gateway (`../../gateway`) sin duplicar
lógica de negocio (ASR-10). Hoy, igual que la app Android, corre sobre datos mock
(`HexacoreCliente/Data/MockData.swift`) hasta que exista el backend real.

**Stack:** Swift + SwiftUI, deployment target iOS 16. Proyecto Xcode generado con
[XcodeGen](https://github.com/yonaskolb/XcodeGen) a partir de `project.yml` (no hay `.xcodeproj`
escrito a mano).

**Estado:** puerto inicial completo de las 19 pantallas (2026-09-02) — ver la Bitácora
Arquitectónica para el detalle de qué se validó y qué falta. **No compilado ni corrido todavía**:
se construyó en una máquina sin Xcode.app completo (solo Command Line Tools), sin SDK de iOS.

## Cómo abrirlo

1. Necesitas una Mac con **Xcode 15+** instalado (Xcode.app completo, no solo las Command Line
   Tools).
2. Si cambias `project.yml`, regenera el proyecto con
   [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`):
   ```
   xcodegen generate
   ```
3. Abre `HexacoreCliente.xcodeproj` y corre el esquema `HexacoreCliente` en un simulador de
   iPhone.

`HexacoreCliente.xcodeproj` ya está commiteado — si no tocas `project.yml` no hace falta
regenerarlo, basta con abrirlo directamente.

## Estructura

```
HexacoreCliente/
  App/            — punto de entrada, estado compartido (AppState) y las dos apps raíz
                    (ClienteAppView / PersonalAppView), equivalentes a MainActivity.kt
  Data/           — modelos (Modelos.swift, ModelosPersonal.swift, Usuario.swift) y MockData.swift
  Navigation/     — Destinos.swift (tabs de Cliente/Personal, destinosPara(cargo))
  Notificaciones/ — notificación local al enviar una entrada (equivalente a NotificacionesEntradas.kt)
  UI/Components/  — Avatar, QrPlaceholder, EscanearQrCard, HexacoreDrawer (menú lateral), BottomBar
  UI/Screens/     — las 19 pantallas, una por archivo, mismo nombre que su equivalente en Android
```

## Diferencias de plataforma frente a la app Android

SwiftUI no tiene equivalentes directos de dos piezas de Compose, así que se construyeron a mano:

- **Menú lateral** (`ModalNavigationDrawer` en Compose) → `DrawerContainer` + `HexacoreDrawerContent`.
- **Barra de navegación inferior**: no es un `TabView` de sistema, sino una vista propia
  (`BottomBar`) que vive fuera del `NavigationStack` — debe permanecer visible incluso en
  pantallas alcanzadas por navegación en profundidad (Entradas, Menú, Pasarela de pago, Perfil,
  Ajustes), igual que el `bottomBar` de `Scaffold` en Compose envuelve todo el `NavHost`.
