## 1.2.4 — 2026-06-10

🐛 **Muhim tuzatish: PFX fayldan import ommaviy Maven foydalanuvchilarida ishlamayotgan edi.**

### Tuzatishlar

- 🚨 **PFX import crash.** `1.0.0`–`1.2.3` versiyalarda ommaviy
  Maven repodan SDK o'rnatgan integratorlar fayl orqali kalit
  qo'shganda quyidagi crash bilan to'qnashardi:
  ```
  java.lang.UnsatisfiedLinkError: dlopen failed:
    library "libgojni.so" not found
  ```
  Sabab: SDK `uz.yt:pfx2qr:1.0` ga bog'liq edi, lekin u kutubxona
  faqat YT ichki Nexus repositorysida joylashgan — ommaviy Maven
  consumer'larida hech qachon resolve qila olmasdi. PFX faylni o'qish
  uchun zarur bo'lgan `libgojni.so` (4.5 MB native lib) va `pfx2qr.jar`
  (Java wrapper) endi to'g'ridan-to'g'ri AAR ichiga bundled qilingan
  — barcha 4 ABI (arm64-v8a, armeabi-v7a, x86, x86_64) uchun.

### Hajm

- AAR endi **~11 MB** (avval ~989 KB). O'sish to'liq `libgojni.so` × 4
  ABI = ~18 MB native code bundlanganidan. R8 hech qanday native
  kodni olib tashlay olmaydi.

### Migratsiya

`1.2.3` dan o'tish uchun **kod o'zgartirish kerak emas**. Faqat
versiya raqamini yangilang:

```gradle
implementation 'uz.eimzo:eimzo-sdk:1.2.4'
```

---

## 1.2.3 — 2026-06-09

🎨 **UX yaxshilanishlar va NFC imzolashda muhim bug-fix.**

### Yangiliklar

- **Sessiya taymeri deeplink uchun (103 sekund).** Tashqi
  `eimzo://sign?qc=...` deeplink kelganida endi sarlavhada toza,
  qisqa taymer ko'rsatiladi (`Sessiya: 1:43 qoldi`). Foydalanuvchi
  kerak bo'lsa kalit qo'shishi va keyin imzolashi mumkin —
  deeplink ushlab turiladi. QR hash matni endi ekranga
  chiqarilmaydi (ortiqcha, foydalanuvchiga ma'nosiz edi).
- **Orqaga qaytish tugmasi.** AppBar'ga back tugmasi qo'shildi:
  Home ekranida deeplink orqali ochilganda integrator ilovasiga
  qaytish, AddKey va Keys ekranlarida toolbar-back navigatsiyasi.
- **NFC imzolashda bottom sheet.** Endi NFC kalit bilan
  imzolashda ham xuddi kalit qo'shishda bo'lganidek 3 ta Lottie
  animatsiyasi (kartani yaqinlashtiring → o'qilmoqda → bajarildi)
  ko'rsatiladi. Avval faqat oddiy Toast bor edi.

### Tuzatishlar

- 🐛 **NFC tag tashlanmasdi.** `dispatchNfcTag` resumed
  fragment'larni qidirgan, lekin OS NFC intent'ini yuborganda
  Activity qisqa vaqtga pause→resume tsikliga kiradi va o'sha
  paytda hech bir fragment "resumed" emas — natijada tag jim
  tashlanardi. Endi `NavController.primaryNavigationFragment`
  ishlatiladi.
- 🐛 **Imzolashda crash.** `HomeFragment.disableNfcForeground`
  Activity hali resumed bo'lmaganida chaqirilib
  `IllegalStateException: You must disable foreground dispatching
  while your activity is still resumed` xatosi bilan crash
  qilardi. Endi try-catch ichida.
- 🐛 **Sessiya tugaganda app yopilib qolardi.** 103 sekundlik
  taymer NFC kalit qo'shish vaqtidan tezroq tugar edi va keyin
  app majburan yopilib ketardi — foydalanuvchi imzolay olmasdi.
  Endi taymer faqat informatsion: tugaganida "Sessiya tugadi"
  toast chiqadi, lekin deeplink saqlanib qoladi va foydalanuvchi
  imzolashga harakat qilishi mumkin.

### Migratsiya

`1.2.2` dan o'tish uchun **kod o'zgartirish kerak emas**. Faqat
versiya raqamini yangilang:

```gradle
implementation 'uz.eimzo:eimzo-sdk:1.2.3'
```

---

## 1.2.2 — 2026-06-06

🔌 **USB token avtomatik aniqlash + ommaviy API tozalandi.**

### Yangiliklar

- **USB token avtomatik aniqlash.** "USB Token orqali imzolash" tugmasi
  endi faqat FEITIAN / CCID smart-card reader telefonga ulanganda
  faollashadi. SDK `USB_DEVICE_ATTACHED` / `DETACHED` broadcastlarini
  real vaqtda kuzatadi (yangi `UsbTokenDetector` klassi) va tugmani
  yoqadi / o'chiradi. Ulanmagan paytda matn "USB tokenni ulang" ga
  o'zgaradi.

### Tuzatishlar

- **USB ulanganda ilova endi avtomatik ochilmaydi.** Avvalgi
  versiyalarning birida `USB_DEVICE_ATTACHED` intent-filter
  qo'shilgan edi — natijada foydalanuvchi tokenni boshqa maqsadda
  ulasa ham OS native UI'ni majburan ochib yuborardi. Intent-filter
  olib tashlandi; aniqlash hali ham ishlaydi — faqat foydalanuvchi
  native UI ichida bo'lganida.

### Ichki o'zgarishlar

- **Ommaviy API tozalandi.** Barcha ichki implementatsiya klasslari
  (`UsbTokenManager`, `NfcManager`, `EImzoApiClient`, Room
  `KeyDao`/`KeyDatabase`/`KeyEntity`, `LicenseGuard`,
  `QrCryptoManager`, `PkiUtils`, `HexUtils`, ViewModel'lar,
  adapterlar va boshqalar) Kotlin `internal` deb belgilandi. Endi
  AAR consumer'larida IDE autocomplete faqat haqiqatan zarur
  APIlarni ko'rsatadi: `EImzoSDK`, `EImzoConfig`, callback
  interfeyslar va model klasslar.
- **Past darajali `signUsbHash` primitivi yashirildi.** USB token
  imzolash uchun yagona ommaviy API endi
  `signWithUsbToken(pin, deepLink, callback)`.
- Manifest'da `USB_DEVICE_ATTACHED` intent-filter va
  `res/xml/eimzo_usb_device_filter.xml` olib tashlandi.

### Migratsiya

`1.0.2` dan o'tish uchun **kod o'zgartirish kerak emas** — `EImzoSDK`
fasadi va public callback'lar saqlangan. Faqat versiya raqamini
yangilang:

```gradle
implementation 'uz.eimzo:eimzo-sdk:1.2.2'
```

---

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

[1.2.4]: https://github.com/peachdev-uz/eimzo-mobile-sdk/releases/tag/v1.2.4
[1.2.3]: https://github.com/peachdev-uz/eimzo-mobile-sdk/releases/tag/v1.2.3
[1.2.2]: https://github.com/peachdev-uz/eimzo-mobile-sdk/releases/tag/v1.2.2
[1.0.1]: https://github.com/peachdev-uz/eimzo-mobile-sdk/releases/tag/v1.0.1
[1.0.0]: https://github.com/peachdev-uz/eimzo-mobile-sdk/releases/tag/v1.0.0
