import SwiftUI
import EimzoSDK

/// Minimal demo of the E-IMZO Mobile SDK on iOS, mirroring
/// `example/android-kotlin`.
///
/// Four things an integrating app does, in the order it usually needs them:
///
/// 1. **Open the full UI** — present `EImzoView` with no deeplink. The user
///    lands on Home, adds keys (PFX / QR / NFC / USB token), and signs.
/// 2. **Open the sign flow directly** — pass an `eimzo://sign?qc=…` URL. The
///    SDK opens the confirmation screen for that document.
/// 3. **Build a link from a `qc` code** — what the portal actually hands you
///    is the code, not the URL. See `EimzoDeepLink.make`.
/// 4. **Send a link to yourself** — the same round trip an external app makes,
///    useful for testing the `onOpenURL` path without a second app.
///
/// The SDK owns everything else: licence check, blocked screen, key
/// management, NFC animations, QR scanner, the network round-trip.
struct ContentView: View {

    /// Set by the app entry point when an external `eimzo://` URL arrives.
    @Binding var incomingDeepLink: String?

    @State private var showEimzo = false
    @State private var presentedLink: String?
    @State private var qcCode = Self.sampleQc
    @State private var note: String?

    /// Flips the endpoint between `m.e-imzo.uz` and `test.e-imzo.uz`.
    /// A QR issued by one stand does not verify against the other, so this has
    /// to match whatever produced the code.
    @State private var isTestMode = false

    /// Sample code from a QA signing session. Replace with whatever the
    /// issuing portal hands your user.
    private static let sampleQc =
        "1a4759282737518b091cc3878831103872e422ec71d2e6ee501e255dce3290af02042edfcd6989e4017b"

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle(isOn: $isTestMode) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Test rejimi")
                            Text(isTestMode ? "test.e-imzo.uz" : "m.e-imzo.uz")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                } header: {
                    Text("Muhit")
                }

                Section {
                    Button("E-IMZO oynasini ochish") {
                        presentedLink = nil
                        showEimzo = true
                    }
                } header: {
                    Text("1 — To'liq interfeys")
                } footer: {
                    Text("Deeplinksiz. Foydalanuvchi kalit qo'shadi va imzolaydi.")
                }

                Section {
                    TextField("qc kodi", text: $qcCode, axis: .vertical)
                        .font(.system(.footnote, design: .monospaced))
                        .lineLimit(2 ... 4)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)

                    if let url = EimzoDeepLink.make(qc: qcCode) {
                        LabeledContent("Havola") {
                            Text(url.absoluteString)
                                .font(.system(.caption2, design: .monospaced))
                                .foregroundStyle(.secondary)
                                .lineLimit(3)
                        }
                    } else {
                        Text("qc kodi bo'sh")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }

                    Button("Shu havola bilan imzolash") {
                        guard let url = EimzoDeepLink.make(qc: qcCode) else { return }
                        presentedLink = url.absoluteString
                        showEimzo = true
                    }
                    .disabled(EimzoDeepLink.make(qc: qcCode) == nil)
                } header: {
                    Text("2 — Deeplink tuzish va ochish")
                } footer: {
                    Text("Portal sizga qc kodini beradi, havolani siz tuzasiz — "
                         + "EimzoDeepLink.make ga qarang.")
                }

                Section {
                    Button("Havolani tizim orqali yuborish") { sendToSelf() }
                        .disabled(EimzoDeepLink.make(qc: qcCode) == nil)
                    if let note {
                        Text(note).font(.caption).foregroundStyle(.secondary)
                    }
                } header: {
                    Text("3 — Tashqi havolani sinash")
                } footer: {
                    Text("Havolani o'zingizga yuboradi. Tizim uni qaytarib "
                         + "beradi va onOpenURL ishga tushadi — tashqi ilova "
                         + "yuborganidagi bilan bir xil yo'l.")
                }
            }
            .navigationTitle("E-IMZO iOS")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showEimzo) {
                EImzoView(
                    config: EImzoConfig(isTestMode: isTestMode),
                    deepLink: presentedLink,
                    // The SDK shows IMZOLANDI for ~1.5 s, then calls back.
                    onSignComplete: { _ in showEimzo = false }
                )
            }
            // Bir argumentli shakl — iOS 17 dagi ikki argumentlisi
            // deployment target 16.0 da mavjud emas.
            .onChange(of: incomingDeepLink) { newValue in
                guard let link = newValue else { return }
                presentedLink = link
                showEimzo = true
                incomingDeepLink = nil
                note = "Tashqaridan keldi: \(link.prefix(40))…"
            }
        }
    }

    /// Opens our own `eimzo://` URL through the system.
    ///
    /// The system routes it back to this app because `Info.plist` registers
    /// the scheme — which is the point: it exercises the same `onOpenURL` path
    /// an external app would use, with nothing else installed.
    private func sendToSelf() {
        guard let url = EimzoDeepLink.make(qc: qcCode) else { return }
        UIApplication.shared.open(url) { opened in
            note = opened
                ? "Yuborildi — onOpenURL kutilyapti"
                : "Tizim ochmadi. Info.plist da CFBundleURLTypes bormi?"
        }
    }
}

#Preview {
    ContentView(incomingDeepLink: .constant(nil))
}
