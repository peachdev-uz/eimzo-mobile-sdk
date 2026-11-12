import SwiftUI

/// App entry point.
///
/// No `eimzo` scheme in `Info.plist` and no `onOpenURL`: that scheme is the
/// E-IMZO app's, and an app that claims it opens its SDK for any page or app
/// that sends a link. A sign request is made inside the app — see
/// `ContentView`.
@main
struct EimzoExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
