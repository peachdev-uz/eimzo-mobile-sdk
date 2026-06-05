## 1.0.2 — 2026-06-04

🔐 **Security hardening.**

- **Saved passwords encrypted in Room.** `PasswordCipher.kt` uses
  AndroidKeyStore-bound AES-256-GCM to wrap the saved-password column.
  Rooted-device SQLite reads and `adb backup` extracts yield ciphertext
  only — the symmetric key is bound to the application UID via
  AndroidKeyStore and cannot be exfiltrated.
- **Backup exclusion.** New `res/xml/eimzo_backup_rules.xml` +
  `eimzo_data_extraction_rules.xml` exclude `eimzo_keys.db` and the
  SDK's encrypted SharedPreferences from `auto-backup`, Google Drive
  cloud backup, and Android 12+ device-transfer. Consumer-app data is
  unaffected — only the SDK's storage paths are filtered.
- Manifest declares `android:fullBackupContent` +
  `android:dataExtractionRules` with `tools:replace` so the exclusion
  applies even if the host app sets `android:allowBackup="true"` for
  its own data.

# Changelog

E-IMZO Mobile SDK uchun barcha muhim o'zgartirishlar shu yerda yoziladi.
Format [Keep a Changelog](https://keepachangelog.com/) standartiga mos.

## [1.0.1] - 2026-06-03

### Tuzatishlar

- 🐛 **Asosiy bug:** PFX/QR kalit import qilishda `JsonIOException: Abstract classes can't be instantiated! Class name: uz.eimzo.sdk.network.JsonRpcResponse` xatosi tuzatildi. R8 minifikatsiya tarmoq DTO klasslarining no-arg konstruktorlarini olib tashlagan edi va Gson reflektsiya orqali javobni deserializatsiya qila olmadi. ProGuard qoidalariga `uz.eimzo.sdk.network.*` paketidagi barcha DTO klasslari uchun aniq `-keep` qoidalari qo'shildi:
  - `JsonRpcRequest`, `JsonRpcResponse`
  - `CertInfoParams`, `CertInfoResult`
  - `SiteInfoParams`, `SiteInfoResult`
  - `SendPkcs7Params`, `Pkcs7Result`
- 🔧 Diagnostik logging kuchaytirildi: kalit import va tarmoq qatlamida exception klassi va to'liq stack trace log xabariga to'g'ridan-to'g'ri yoziladi (R8 olib tashlamasligi uchun).

### Texnik tafsilotlar

- **AAR hajmi:** 994 KB (oldingi 971 KB — qo'shilgan keep qoidalari tufayli)
- **Public API:** o'zgarishsiz qoldi
- **Migratsiya:** version raqamini `1.0.0` → `1.0.1` ga o'zgartirish kifoya

---

## [1.0.0] - 2026-06-03

### Birinchi rasmiy reliz

**Asosiy funksiyalar:**
- ✨ PFX (.pfx) fayldan kalit import qilish
- ✨ QR kod orqali kalit import (kamera)
- ✨ NFC ID-karta orqali kalit import
- ✨ OzDST 1092 elektron imzo (milliy standart)
- ✨ OzDST 1106 hash funksiyasi (GOST 34.311 oilasi)
- ✨ Deeplink qo'llab-quvvatlash (`eimzo://sign?qc=...`)
- ✨ Sertifikat validatsiyasi (Soliq serveri orqali)
- ✨ USB Token bilan imzolash (FT-1280)
- ✨ Parolni saqlash (ixtiyoriy)

**UI komponentlari:**
- ✨ NfcWaitBottomSheet (Lottie animatsiyali NFC kutish)
- ✨ LoadingOverlay (spinner + logo)
- ✨ BlockedAppActivity (license blocked ekran)
- ✨ Sakura background, gradient kartochkalar

**Xavfsizlik:**
- 🔐 R8 obfuscation + 5x optimization passes
- 🔐 String encryption (Firebase API key XOR-encoded)
- 🔐 Anti-tamper (Frida/Xposed/root manager detection)
- 🔐 License guard (Firebase Firestore orqali)
- 🔐 In-app access request (pending_integrators)

**Tasdiqlangan komponentlar:**
- ✅ OzDST 1106 hash — standart test vektorlari bilan
- ✅ EC scalar multiplication (Q=G\*d) — standart test vektor
- ✅ EC signature (r, s) — standart test vektor
- ✅ End-to-end imzolash — server `send.success` qaytaradi

### Texnik tafsilotlar

- **MinSdk:** 24 (Android 7.0)
- **TargetSdk:** 34 (Android 14)
- **Kotlin:** 1.9.0
- **Compose:** native View tizimi (Compose qo'llanmagan)
- **Hajmi:** 681 KB (himoyalangan AAR)
- **NDK:** 21.1.6352462

---

## [Unreleased]

### Rejalashtirilgan

- 🚧 iOS qo'llab-quvvatlash (alohida framework)
- 🚧 Flutter plugin (eimzo_flutter)
- 🚧 EncryptedSharedPreferences (parol shifrlangan saqlash)
- 🚧 Native code (NDK) — license check
- 🚧 Certificate pinning (Soliq serveriga TLS pin)

---

[1.0.1]: https://github.com/peachdev-uz/eimzo-mobile-sdk/releases/tag/v1.0.1
[1.0.0]: https://github.com/peachdev-uz/eimzo-mobile-sdk/releases/tag/v1.0.0
