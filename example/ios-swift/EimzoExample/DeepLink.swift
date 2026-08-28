import Foundation

/// Building and reading `eimzo://sign?qc=…` URLs.
///
/// This is the part that has no counterpart in the Android example, which
/// hard-codes one sample string. On Android a deeplink is an `Intent` whose
/// `data` you set; on iOS it is a `URL` you either hand to `EImzoView` or open
/// through the system. Neither platform validates it for you — a malformed
/// `qc` reaches the SDK, fails at the portal, and surfaces as a signing error
/// far away from the typo that caused it.
///
/// So the construction lives here, in one place, with the rules written down.
enum EimzoDeepLink {

    /// The scheme and host the SDK answers to. Anything else is not ours —
    /// see [parse].
    static let scheme = "eimzo"
    static let host = "sign"

    /// Builds `eimzo://sign?qc=<code>` from the code a signing portal issues.
    ///
    /// Use `URLComponents` rather than string interpolation. The `qc` value is
    /// hex today, but it is the portal's field, not ours: the day it carries a
    /// `+` or a `/`, a hand-built string silently produces a different code
    /// than the one the portal issued, and the failure appears as "imzo
    /// noto'g'ri" at the far end.
    ///
    /// Returns nil for an empty code rather than producing `eimzo://sign?qc=`,
    /// which the SDK would accept and only fail on later.
    static func make(qc code: String) -> URL? {
        let trimmed = code.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.queryItems = [URLQueryItem(name: "qc", value: trimmed)]
        return components.url
    }

    /// Pulls the `qc` back out of an incoming URL, or nil if this is not an
    /// E-IMZO sign link.
    ///
    /// Worth doing even when your app registers only the `eimzo` scheme:
    /// `onOpenURL` fires for every URL the system routes to you, and a future
    /// `eimzo://something-else` must not be mistaken for a signing request.
    static func parse(_ url: URL) -> String? {
        guard url.scheme?.lowercased() == scheme,
              url.host?.lowercased() == host,
              let items = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems,
              let qc = items.first(where: { $0.name == "qc" })?.value,
              !qc.isEmpty
        else { return nil }
        return qc
    }
}
