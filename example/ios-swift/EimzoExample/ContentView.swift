import SwiftUI
import EimzoSDK

/// Minimal demo of the E-IMZO Mobile SDK on iOS, mirroring
/// `example/android-kotlin`.
///
/// Three things an integrating app does:
///
/// 1. **Open the full UI** — present `EImzoView` with no sign request. The
///    user lands on Home, adds keys (PFX / QR / ID card / USB token / BAIK
///    token), and signs by scanning a QR code.
/// 2. **Sign a document** — the app's backend hands it the document's
///    `siteId`, `documentId` and `hash`; `EImzoSignLink.create` makes the
///    sign request from them and `EImzoView` opens with it.
/// 3. **Keys API** («Kalitlar API») — `EImzoAPI.getKeys` lists the keys the
///    user has added in `EImzoView`, as JSON, and `EImzoAPI.sign` signs the
///    same request with the key picked here, in the SDK's own sheet. Only for
///    an integrator YT has given the permission (info@yt.uz, after a
///    contract); without it both answer `api_not_allowed`, and the example
///    shows that.
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

    /// What the example reads from `getKeys`' JSON: the keys of an `ok`
    /// answer, which also carry `pinfl` and `validFrom`. An error has none.
    private struct KeyList: Decodable {
        struct Key: Decodable, Identifiable {
            let id: String
            let name: String
            let validTo: String?
        }
        let keys: [Key]?
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

    /// The Keys API: the keys from the last `getKeys`, the one picked for
    /// `sign`, and the last JSON either gave.
    @State private var keys: [KeyList.Key] = []
    @State private var keyId: String?
    @State private var keysJSON: String?

    /// The SDK's step-by-step log, in debug builds only — never ship it on.
    #if DEBUG
    private static let debugLogging = true
    #else
    private static let debugLogging = false
    #endif

    /// One config for the sheet and the Keys API.
    private var config: EImzoConfig {
        EImzoConfig(environment: environment, debugLogging: Self.debugLogging)
    }

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

                Section {
                    Button("Kalitlar ro'yxati") {
                        Task { await listKeys() }
                    }

                    if !keys.isEmpty {
                        Picker("Kalit", selection: $keyId) {
                            ForEach(keys) { key in
                                Text(Self.label(key)).tag(Optional(key.id))
                            }
                        }
                    }

                    Button("Tanlangan kalit bilan imzolash") {
                        Task { await signWithPickedKey() }
                    }
                    .disabled(keyId == nil || (try? signLink.get()) == nil)

                    if let keysJSON {
                        // One line that scrolls: wrapped, the JSON got
                        // hyphens it does not have.
                        ScrollView(.horizontal) {
                            Text(keysJSON)
                                .font(.system(.caption2, design: .monospaced))
                                .textSelection(.enabled)
                        }
                    }
                } header: {
                    Text("3 — Kalitlar API")
                } footer: {
                    Text("Faqat YT ruxsat bergan integratorlar uchun (info@yt.uz, shartnomadan keyin); "
                         + "ruxsatsiz javob — api_not_allowed. Imzo 2-bo'limdagi so'rov bilan.")
                }
            }
            .navigationTitle("E-IMZO iOS")
            .navigationBarTitleDisplayMode(.inline)
            // A key added in one environment is not listed in the other, so
            // the list goes when the environment changes.
            .onChange(of: environment) { _ in
                keys = []
                keyId = nil
                keysJSON = nil
            }
            .sheet(item: $presentation) { shown in
                EImzoView(
                    config: config,
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

    /// «Kalitlar ro'yxati»: the keys the user has added in `EImzoView`.
    /// iOS has no init step — the call runs the gateway check itself.
    private func listKeys() async {
        let json = await EImzoAPI.getKeys(config: config)
        keys = (try? JSONDecoder().decode(KeyList.self, from: Data(json.utf8)))?.keys ?? []
        if !keys.contains(where: { $0.id == keyId }) {
            keyId = keys.first?.id
        }
        keysJSON = json
    }

    /// «Tanlangan kalit bilan imzolash»: section 2's request, signed with the
    /// picked key in the SDK's own sheet. The JSON says how it ended —
    /// signed, cancelled or an error; the signed document goes from E-IMZO to
    /// the site's backend, not to the app.
    private func signWithPickedKey() async {
        guard let keyId, case .success(let link) = signLink else { return }
        keysJSON = await EImzoAPI.sign(keyId: keyId, deepLink: link, config: config)
    }

    /// A key in the picker: its owner and `validTo` — expired keys are
    /// listed too.
    private static func label(_ key: KeyList.Key) -> String {
        guard let validTo = key.validTo else { return key.name }
        let today = Date.now.formatted(Date.ISO8601FormatStyle(timeZone: .current).year().month().day())
        return validTo < today ? "\(key.name) · \(validTo) (muddati o'tgan)" : "\(key.name) · \(validTo)"
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
