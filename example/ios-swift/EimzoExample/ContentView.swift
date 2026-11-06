import SwiftUI
import EimzoSDK

/// Minimal demo of the E-IMZO Mobile SDK on iOS, mirroring
/// `example/android-kotlin`.
///
/// Two things an integrating app does:
///
/// 1. **Open the full UI** — present `EImzoView` with no sign request. The
///    user lands on Home, adds keys (PFX / QR / ID card / USB token / BAIK
///    token), and signs by scanning a QR code.
/// 2. **Sign a document** — the app's backend hands it the document's
///    `siteId`, `documentId` and `hash`; `EImzoSignLink.create` makes the
///    sign request from them and `EImzoView` opens with it.
///
/// The app takes no `eimzo://` links from outside: that scheme is the E-IMZO
/// app's, so there is no `CFBundleURLTypes` entry and no `onOpenURL`.
///
/// The SDK owns everything else: the gateway check, blocked screen, key
/// management, NFC animations, QR scanner, the network round-trip.
struct ContentView: View {

    /// What the sheet shows: the SDK, with or without a sign request.
    ///
    /// One item rather than a flag plus a separate link: with
    /// `sheet(isPresented:)` the content closure could read the link before
    /// its update landed, and the SDK opened with none.
    private struct Presentation: Identifiable {
        let id = UUID()
        let deepLink: String?
    }

    @State private var presentation: Presentation?

    /// `.dev` is YT's test environment on `test.e-imzo.uz`, where only test
    /// keys sign; `.prod` is E-IMZO itself on `m.e-imzo.uz`. A document signs
    /// only in the environment that issued it, and the app must be
    /// registered in the one it uses.
    @State private var environment = EImzoEnvironment.dev

    /// A document from a QA signing session. In your app the three values
    /// come from your backend.
    @State private var siteId = "1a47"
    @State private var documentId = "59282737"
    @State private var hash = "518b091cc3878831103872e422ec71d2e6ee501e255dce3290af02042edfcd69"

    /// The SDK's step-by-step log, in debug builds only — never ship it on.
    #if DEBUG
    private static let debugLogging = true
    #else
    private static let debugLogging = false
    #endif

    /// The sign request the three values make, or why they make none:
    /// `EImzoSignLink.Error` says which value is not in E-IMZO's form.
    private var signLink: Result<String, Error> {
        Result { try EImzoSignLink.create(siteId: siteId, documentId: documentId, hash: hash) }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle(isOn: Binding(get: { environment == .dev },
                                         set: { environment = $0 ? .dev : .prod })) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Test muhiti (dev)")
                            Text(environment == .dev ? "test.e-imzo.uz" : "m.e-imzo.uz")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                } header: {
                    Text("Muhit")
                }

                Section {
                    Button("E-IMZO oynasini ochish") {
                        presentation = Presentation(deepLink: nil)
                    }
                } header: {
                    Text("1 — To'liq interfeys")
                } footer: {
                    Text("So'rovsiz. Foydalanuvchi kalit qo'shadi va QR kodni skanerlab imzolaydi.")
                }

                Section {
                    field("siteId", text: $siteId)
                    field("documentId", text: $documentId)
                    field("hash", text: $hash)

                    switch signLink {
                    case .success(let link):
                        // One line, cut in the middle: wrapped, the hex got
                        // hyphens it does not have.
                        LabeledContent("Havola") {
                            Text(link)
                                .font(.system(.caption2, design: .monospaced))
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                                .truncationMode(.middle)
                        }
                    case .failure(let error):
                        Text(String(describing: error))
                            .font(.caption)
                            .foregroundStyle(.red)
                    }

                    Button("Shu so'rov bilan imzolash") {
                        guard case .success(let link) = signLink else { return }
                        presentation = Presentation(deepLink: link)
                    }
                    .disabled((try? signLink.get()) == nil)
                } header: {
                    Text("2 — Hujjatni imzolash")
                } footer: {
                    Text("siteId, documentId va hash backend'ingizdan keladi, havolani "
                         + "EImzoSignLink.create yasaydi. eimzo:// havolasi tashqaridan olinmaydi.")
                }
            }
            .navigationTitle("E-IMZO iOS")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $presentation) { shown in
                EImzoView(
                    config: EImzoConfig(environment: environment, debugLogging: Self.debugLogging),
                    deepLink: shown.deepLink,
                    // E-IMZO has the signature: the SDK calls back from
                    // «Ilovaga qaytish» — tapped, or by itself after about
                    // 3 s — or, for a QR it scanned, from «Tayyor». It does
                    // not close itself, so the sheet is closed here.
                    onSignComplete: { _ in presentation = nil }
                )
            }
        }
    }

    /// One of the document's values: hex, so no autocorrection or capitals,
    /// and one line that scrolls rather than wraps.
    private func field(_ title: String, text: Binding<String>) -> some View {
        LabeledContent(title) {
            TextField(title, text: text)
                .font(.system(.footnote, design: .monospaced))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
        }
    }
}

#Preview {
    ContentView()
}
