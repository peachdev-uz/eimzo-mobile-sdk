import SwiftUI

/// App entry point.
///
/// The iOS half of Android's `<intent-filter>`: the scheme is declared in
/// `Info.plist` under `CFBundleURLTypes`, and every URL the system routes here
/// arrives through `onOpenURL`. Both halves are required — a scheme that is
/// declared but not handled opens the app and does nothing, and a handler
/// without the declaration never fires.
@main
struct EimzoExampleApp: App {
    @State private var incomingDeepLink: String?

    var body: some Scene {
        WindowGroup {
            ContentView(incomingDeepLink: $incomingDeepLink)
                .onOpenURL { url in
                    // Filtered rather than forwarded blindly: onOpenURL fires
                    // for anything routed to this app, and a future
                    // eimzo://something-else must not be read as a signing
                    // request.
                    guard EimzoDeepLink.parse(url) != nil else { return }
                    incomingDeepLink = url.absoluteString
                }
        }
    }
}
