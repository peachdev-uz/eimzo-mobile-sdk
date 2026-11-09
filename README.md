# E-IMZO Mobile SDK

> O'zbekiston Respublikasi rasmiy elektron raqamli imzo (ERI) tizimi uchun mobil SDK.
> **Android** native + **Flutter** plugin.

[![Version](https://img.shields.io/badge/version-2.4.0-blue.svg)](https://github.com/peachdev-uz/eimzo-mobile-sdk/releases)
[![Android](https://img.shields.io/badge/Android-API%2024+-green.svg)](https://developer.android.com)
[![Flutter](https://img.shields.io/badge/Flutter-3.10+-blue.svg)](https://flutter.dev)
[![pub.dev](https://img.shields.io/pub/v/eimzo_flutter?label=pub.dev)](https://pub.dev/packages/eimzo_flutter)
[![License](https://img.shields.io/badge/license-Proprietary-red.svg)](#-litsenziya)

---

## 🚀 Asosiy g'oya

**Hech qanday UI yozish shart emas.** SDK to'liq E-IMZO interfeysini o'zi taqdim etadi —
Home ekrani, kalitlar ro'yxati, ERI fayl, QR kod, ID-karta (NFC), USB token va BAIK token
orqali kalit qo'shish, parol va PIN so'rash, imzo so'rovini tasdiqlash, QR scanner — hammasi tayyor.

Sizning ilovangiz **bir qator kod** bilan butun E-IMZO oqimini ochadi:

```kotlin
startActivity(Intent(this, EImzoActivity::class.java))
```

Hujjatni imzolash uchun so'rovni ilovangizning o'zi yasaydi va SDK'ga beradi:

```kotlin
val link = EImzoSignLink.create(siteId, documentId, hash)
startActivity(Intent(this, EImzoActivity::class.java).setData(Uri.parse(link)))
```

Tamom. Integrator faqat **kachachi/launcher** rolini bajaradi — qolganini SDK bajaradi.

---

## 🔐 Ro'yxatdan o'tish

2.3 dan SDK E-IMZO bilan faqat YT gateway orqali ishlaydi. Gateway ilovani
platforma attestatsiyasi bilan taniydi: Android'da key attestation ilovaning
paket nomini va uni imzolagan sertifikatni tasdiqlaydi. **Litsenziya fayli
kerak emas** — ilovani gateway'da ro'yxatdan o'tkazish kifoya.

**info@yt.uz** ga yozing va yuboring:

- **Android** — paket nomi va ilovani imzolagan sertifikatning SHA-256 i:
  ```
  apksigner verify --print-certs app-release.apk | grep -i "SHA-256"
  ```
  Ilova Google Play'da Play App Signing bilan tarqatilsa, Play Console'dagi
  **App signing key certificate** ning SHA-256 ini yuboring: foydalanuvchi
  telefoniga ilova shu sertifikat bilan imzolangan holda tushadi.
- **iOS** (Flutter ilovangiz iOS'da ham chiqsa) — bundle id va Team ID:
  ```
  codesign -dvvv MyApp.app 2>&1 | grep TeamIdentifier
  ```

Qaysi muhit uchun ekanini ham yozing: sinov paytida `dev`, reliz uchun `prod`
([Muhit](#muhit-prod-va-dev)). Har bir muhitda ro'yxat alohida. Debug build
boshqa sertifikat bilan imzolanadi, shuning uchun uning SHA-256 ini ham yuboring
(`./gradlew signingReport` ko'rsatadi).

Ro'yxatdan o'tmagan ilovada SDK bloklangan ekranni ko'rsatadi. Ekranning
«Ishlab chiquvchi uchun» bo'limida paket nomi va sabab yozilgan.

### Telefon talablari

Android'da key attestation uchun telefonda apparat darajasidagi (hardware-backed)
attestatsiya va qulflangan bootloader bilan o'zgartirilmagan tizim bo'lishi
kerak — ya'ni Google sertifikatlagan telefon. Root qilingan yoki bootloader'i
ochilgan telefonlarda va Google xizmatlarisiz Huawei telefonlarida SDK
ishlamaydi: ular bloklangan ekranni ko'radi. Emulyator faqat `dev` muhitida
ishlaydi.

iOS'da App Attest ishlatiladi: haqiqiy iPhone yoki iPad kerak, iOS Simulator
attestatsiya qila olmaydi.

### Ilovangizda litsenziya bo'lsa

2.0–2.2 uchun berilgan `EIMZO1.…` litsenziyali ilova 2.3 da gateway
sessiyasini attestatsiya o'rniga litsenziya bilan ochadi. Buning uchun
litsenziya gateway'da ro'yxatda bo'lishi kerak, aks holda bloklangan ekran
chiqadi. Shuning uchun bunday ilovani 2.3 ga o'tkazishdan oldin info@yt.uz ga
yozing va YT tasdiqlamaguncha 2.2 da qoling. Litsenziya joyida qoladi
(`eimzo-license.txt` yoki `EImzoConfig(license = …)`).

SDK bekor qilingan litsenziyalar ro'yxatini (`revoked.txt`) endi o'zi yuklab
olmaydi: bekor qilingan, ro'yxatda yo'q yoki muddati o'tgan litsenziyani
gateway rad etadi.

Yangi ilova uchun litsenziya kerak emas — yuqoridagi ro'yxatdan o'tish yetarli.

---

## ⚠️ 2.2 dan o'tish

1. Ilovani `dev` va `prod` uchun ro'yxatdan o'tkazing (yuqoriga qarang).
   Ilovangizda litsenziya bo'lsa, avval info@yt.uz ga yozing va YT
   tasdiqlamaguncha 2.2 da qoling.
2. Versiyani yangilang: `implementation 'uz.eimzo:eimzo-sdk:2.4.0'`
   (Flutter: `eimzo_flutter: ^2.4.0`).
3. `AndroidManifest.xml` dan `eimzo` sxemali `intent-filter` ni olib tashlang;
   Flutter ilovasida iOS `Info.plist` dagi `CFBundleURLTypes` dan `eimzo` ni ham.
   2.2 da bu filtr SDK'ning o'z manifest'idan ham qo'shilardi. 2.3 da u yo'q,
   ya'ni ilova `eimzo://` havolasi bilan tashqaridan ochilmaydi.
4. Imzo so'rovini ilova ichida yasang: `EImzoSignLink.create(siteId, documentId, hash)`
   va havolani `EImzoActivity` ga `data` sifatida bering
   ([4-qadam](#4-sdk-uini-oching)).
5. `isTestMode` o'rniga `environment` yozing: `EImzoEnvironment.DEV` yoki
   `EImzoEnvironment.PROD`. `isTestMode` hali ishlaydi, lekin eskirgan;
   `productionApiUrl` va `testApiUrl` endi ishlatilmaydi.
6. Flutter ilovangiz iOS'da ham chiqsa, App Store Connect → App Privacy'ni
   yangilang ([Xato va crash hisobotlari](#-xato-va-crash-hisobotlari)).
7. Haqiqiy telefonda avval `dev` da, keyin `prod` da imzolab ko'ring.

Manifest'ga boshqa hech narsa qo'shilmaydi: 2.3 da kerak bo'lgan
`ACCESS_NETWORK_STATE` AAR manifest'idan avtomatik birlashadi.

---

## 📦 Yuklab olish

### Android

📥 **[eimzo-sdk-2.4.0.aar](android/eimzo-sdk-2.4.0.aar)** (13 MB) — to'liq UI bundlangan

Yoki Releases sahifasidan: **[GitHub Releases →](https://github.com/peachdev-uz/eimzo-mobile-sdk/releases/latest)**

### Flutter

```yaml
dependencies:
  eimzo_flutter: ^2.4.0
```

🔗 https://pub.dev/packages/eimzo_flutter

### iOS

Alohida SDK — **[eimzo-ios-sdk](https://github.com/peachdev-uz/eimzo-ios-sdk)**
(Swift Package Manager, iOS 16+):

```swift
.package(url: "https://github.com/peachdev-uz/eimzo-ios-sdk", from: "2.4.0")
```

---

## 🎯 Misollar

[`example/`](example/) dagi ikkala misol ham 2.4.0 uchun:

- [example/android-kotlin/](example/android-kotlin/) — pastdagi 4 qadam asosida
  yozilgan ilova: SDK'ni ochish va `EImzoSignLink.create` bilan yasalgan so'rov
  bilan imzolash. SDK'ni shu repodagi `maven/` dan oladi.
- [example/ios-swift/](example/ios-swift/) — xuddi shu SwiftUI'da, SDK
  [eimzo-ios-sdk](https://github.com/peachdev-uz/eimzo-ios-sdk) dan SPM orqali.

Ikkalasi ham `eimzo://` havolalarini tashqaridan qabul qilmaydi.

---

## ⚡ Tezkor integratsiya — 4 qadam

### 1. Maven repo'ni qo'shing

**`settings.gradle`** (Groovy):
```gradle
dependencyResolutionManagement {
    repositories {
        google()
        mavenCentral()
        maven { url 'https://raw.githubusercontent.com/peachdev-uz/eimzo-mobile-sdk/main/maven/' }
    }
}
```

**`settings.gradle.kts`** (Kotlin DSL):
```kotlin
maven { url = uri("https://raw.githubusercontent.com/peachdev-uz/eimzo-mobile-sdk/main/maven/") }
```

### 2. Dependency

**`app/build.gradle`:**
```gradle
android {
    compileSdk 34
    defaultConfig {
        minSdk 24
    }
}
dependencies {
    implementation 'uz.eimzo:eimzo-sdk:2.4.0'
}
```

Bu **bitta qator** barcha tranzit dependency'larni avtomatik tortib oladi
(Kotlin coroutines, AndroidX, Room, OkHttp, Gson, BouncyCastle, Material, Lottie, Navigation va h.k.).

### 3. `AndroidManifest.xml` — hech narsa qo'shilmaydi

Permission'lar (`INTERNET`, `ACCESS_NETWORK_STATE`, `NFC`, `CAMERA`,
`READ_EXTERNAL_STORAGE` — API 32 gacha), NFC va USB host uchun
`<uses-feature android:required="false">` hamda SDK activity'lari
(`EImzoActivity`, `QrScannerActivity`, `BlockedAppActivity`) AAR manifest'ida
e'lon qilingan va Gradle manifest merger orqali avtomatik qo'shiladi.

**`eimzo` sxemali `intent-filter` qo'shmang.** `eimzo://` — E-IMZO ilovasining
sxemasi: uni e'lon qilgan ilova istalgan sayt yoki ilova yuborgan so'rov bilan
SDK'ni ochib beradi. Imzo so'rovi ilova ichida yasaladi (4-qadam). SDK bunday
filtrni topsa, logcat'ga ogohlantirish yozadi.

### 4. SDK UI'ni oching

```kotlin
import uz.eimzo.sdk.EImzoConfig
import uz.eimzo.sdk.EImzoEnvironment
import uz.eimzo.sdk.EImzoSDK
import uz.eimzo.sdk.EImzoSignLink
import uz.eimzo.sdk.fullui.EImzoActivity

class MyActivity : AppCompatActivity() {

    private val eimzoConfig = EImzoConfig(
        environment = if (BuildConfig.DEBUG) EImzoEnvironment.DEV else EImzoEnvironment.PROD,
    )

    // Kalitlar, kalit qo'shish, QR kodni skanerlab imzolash
    fun openEimzo() = launchEimzo(link = null)

    // Hujjatni imzolash: siteId, documentId va hash backend'ingizdan keladi
    fun signDocument(siteId: String, documentId: String, hash: String) =
        launchEimzo(EImzoSignLink.create(siteId, documentId, hash))

    private fun launchEimzo(link: String?) {
        EImzoSDK.checkLicenseAndInit(this, eimzoConfig) { allowed ->
            if (!allowed) return@checkLicenseAndInit // SDK bloklangan ekranni ko'rsatdi
            startActivity(Intent(this, EImzoActivity::class.java).apply {
                if (link != null) data = Uri.parse(link)
            })
        }
    }
}
```

- `checkLicenseAndInit` sozlamani SDK'ga beradi va ilovani gateway'da
  tekshiradi. SDK birinchi o'rnatilgan sozlamani ilova jarayoni (process)
  tugaguncha saqlaydi, shuning uchun uni `EImzoActivity` dan oldin chaqiring:
  `EImzoActivity` to'g'ridan-to'g'ri ochilsa, standart `EImzoConfig()`, ya'ni
  `PROD` ishlatiladi.
- Ilova rad etilsa, SDK bloklangan ekranni uzatilgan activity ustida o'zi
  ochadi va `allowed = false` qaytaradi. Activity yopilmaydi: foydalanuvchi
  ekranni yopsa, ilovaga qaytadi.
- `siteId`, `documentId` va `hash` — E-IMZO saytga hujjat uchun beradigan
  qiymatlar; ularni backend'ingiz beradi. `EImzoSignLink.create` ularning
  shaklini tekshiradi (`siteId` — 4, `documentId` — 8, 10, 12, 14 yoki 16,
  `hash` — 64 ta hex belgi), CRC32 qo'shadi va `eimzo://sign?qc=…` havolasini
  qaytaradi. Qiymat noto'g'ri bo'lsa, `IllegalArgumentException` tashlaydi.
- SDK avval tasdiq ekranini ko'rsatadi — sayt, xesh va kalit — va faqat
  foydalanuvchi IMZOLASH ni bossa imzolaydi. Kalit hali bo'lmasa, so'rov bosh
  ekranda kutadi va birinchi kalit qo'shilishi bilan ochiladi. Telefonda
  taymer yo'q: so'rov muddati o'tgan bo'lsa, buni server aytadi.

✅ **Tamom.** `EImzoActivity` gateway tekshiruvi, kalitlar boshqaruvi, imzolash, NFC va QR oqimlarini o'zi bajaradi.

### Imzodan keyin

Ilova yuborgan so'rov imzolangach, SDK bitta «Ilovaga qaytish» tugmasini
ko'rsatadi va taxminan 3 soniyadan keyin ilovangizga o'zi qaytadi
(`EImzoActivity` yopiladi). Foydalanuvchining maxsus imkoniyatlar sozlamalari
ko'proq vaqt so'rasa, kutish uzunroq bo'ladi. E-IMZO ilovasidagi
«Saytga qaytish» va «Ilovada qolish» SDK'da yo'q. SDK ichida QR kodni
skanerlab boshlangan imzo esa «Tayyor» bilan tugaydi.

`EImzoActivity` ilovangizga natija qaytarmaydi: imzo E-IMZO'ga yuboriladi,
natijani o'z backend'ingizdan bilasiz.

### Muhit: `prod` va `dev`

`environment` SDK qaysi E-IMZO bilan ishlashini tanlaydi:

- `EImzoEnvironment.PROD` (sukut bo'yicha) — E-IMZO, haqiqiy kalitlar bilan.
- `EImzoEnvironment.DEV` — YT test muhiti (test.e-imzo.uz), sinov va QA
  build'lari uchun. U yerda faqat test kalitlari imzolaydi.

Boshqa hech narsa sozlanmaydi: SDK ikkala muhitning gateway manzilini o'zi
biladi. Bir muhitdagi QR kod faqat o'sha muhitda ishlaydi. Kalit qaysi muhitda
qo'shilganini eslab qoladi: boshqa muhitda u ro'yxatda qoladi, lekin «Boshqa
server» deb belgilanadi va imzolamaydi. 2.3 dan oldin qo'shilgan kalitlarda
belgi yo'q, ular ikkala muhitda ishlaydi.

2.2 dagi `isTestMode` hali ishlaydi (`true` — `DEV`), lekin eskirgan.

`EImzoConfig(debugLogging = true)` SDK qadamlarini logcat'ga yozadi (teg
`EImzoSDK`) — kalit, PIN va imzo hech qachon yozilmaydi. Release build'da
o'chiq qoldiring.

---

## 🔑 Kalitlar API

2.4.0 dan SDK ilovaga ikkita metod beradi:

- `EImzoSDK.getKeys` — foydalanuvchi SDK'ga qo'shgan kalitlar ro'yxati, JSON'da;
- `EImzoSDK.sign` — imzo so'rovini ilova tanlagan kalit bilan SDK'ning o'z
  oynasida imzolaydi.

Ikkalasi ham javobni JSON qatori sifatida `EImzoResultCallback` ga bir marta,
main thread'da beradi. JSON va xato kodlari iOS SDK va Flutter plaginidagi
bilan bir xil.

### Ruxsat

«Kalitlar API» faqat YT ruxsat bergan integratorlar uchun. Ruxsat YT bilan
shartnoma tuzilgach, so'rov bo'yicha yoqiladi — **info@yt.uz** ga yozing. U
integratorga beriladi va uning barcha ilovalariga tegishli, sukut bo'yicha
o'chiq. Ruxsat bo'lmasa, ikkala metod ham hech narsa ko'rsatmay
`api_not_allowed` qaytaradi. Yoqilgan ruxsat ilova qayta ishga tushganda (yoki
bir soat ichida) kuchga kiradi. `EImzoActivity` ruxsatsiz ham avvalgidek
ishlaydi.

Kalitlar ilovada qo'shilmaydi: foydalanuvchi ularni avvalgidek
`EImzoActivity` da qo'shadi — ERI fayl, QR kod, ID-karta, USB token yoki BAIK
token orqali. Parol yoki PIN faqat SDK oynasida teriladi: hech bir metod parol
olmaydi va kalitning o'zini qaytarmaydi.

Metodlar `EImzoSDK.checkLicenseAndInit` `true` qaytargandan keyin ishlaydi
([4-qadam](#4-sdk-uini-oching)), undan oldin — `not_initialized`. Ular
bloklangan ekranni ochmaydi: ilova yoki telefon rad etilsa, `blocked` qaytadi.

### `getKeys`

```kotlin
EImzoSDK.getKeys { json ->
    val reply = JSONObject(json)
    if (reply.getString("status") != "ok") {
        showError(reply.getString("code")) // pastdagi jadval
        return@getKeys
    }
    val keys = reply.getJSONArray("keys")
    for (i in 0 until keys.length()) {
        val key = keys.getJSONObject(i)
        // key.getString("id") — sign() ga shu beriladi
    }
}
```

```json
{"status":"ok","keys":[
  {"id":"7a3f…","pinfl":"31234567890123","name":"ALIYEV VALI ALIYEVICH",
   "validFrom":"2025-03-01","validTo":"2027-03-01"}
]}
```

- `id` — sertifikat seriya raqami: uni o'zgartirmay `sign()` ga bering;
- `pinfl` — JSHSHIR, sertifikatda bo'lmasa `null`;
- `name` — sertifikat egasining ismi;
- `validFrom`, `validTo` — sertifikat muddati, `yyyy-MM-dd`; o'qib bo'lmasa `null`.

Boshqa hech narsa berilmaydi: STIR, tashkilot, kalit turi, kalitning o'zi va
saqlangan parol SDK'da qoladi. Ro'yxatda joriy `environment` da imzolay
oladigan har turdagi kalit bor, asosiy kalit birinchi; boshqa muhitda
qo'shilgan kalit ko'rsatilmaydi. Muddati o'tgan kalit ham ko'rsatiladi — buni
`validTo` dan biling. Kalit bo'lmasa — `{"status":"ok","keys":[]}`.

### `sign`

```kotlin
// siteId, documentId va hash — backend'ingizdan, keyId — getKeys() dan
fun signDocument(siteId: String, documentId: String, hash: String, keyId: String) {
    val link = EImzoSignLink.create(siteId, documentId, hash)
    EImzoSDK.sign(this, keyId, link) { json ->
        val reply = JSONObject(json)
        when (reply.getString("status")) {
            "signed" -> refreshDocument()                 // natija — backend'ingizda
            "cancelled" -> Unit                           // foydalanuvchi oynani yopdi
            "error" -> showError(reply.getString("code")) // pastdagi jadval
        }
    }
}
```

Oyna ochilishidan oldin tekshiriladi: ruxsat, imzo so'rovi, kalit shu muhitda
borligi va muddati, boshqa `sign()` ochiq emasligi. Birortasi o'tmasa, hech
narsa ochilmaydi va `error` qaytadi. Keyin SDK imzo oynasini uzatilgan
activity ustida ochadi — manifest'ga hech narsa qo'shilmaydi:

- Oynada sayt, xesh va tanlangan kalit ko'rinadi, kalitni almashtirib
  bo'lmaydi. Parol yoki PIN (ID-karta va tokenda — karta yoki token ham)
  faqat shu oynada so'raladi, saqlangan parol avvalgidek ishlaydi.
- Foydalanuvchi IMZOLASH ni bosmaguncha hech narsa imzolanmaydi. Imzodan
  keyin «Imzolandi» ekrani 3 soniyadan keyin ilovaga o'zi qaytadi va callback
  `{"status":"signed"}` oladi.
- Tuzatsa bo'ladigan xato (noto'g'ri parol yoki PIN, internet yo'q, karta yoki
  token yo'q) oynada ko'rsatiladi: foydalanuvchi qayta urinadi yoki oynani
  yopadi — `{"status":"cancelled"}`. Oqimni tugatadigan xatoda `error`
  qaytadi: ilova yoki ruxsat rad etilsa yoki E-IMZO saytni tanimasa, oyna
  darhol yopiladi; kalit muddati tugasa, E-IMZO imzoni rad etsa yoki PIN
  bloklansa, SDK avval sababini ko'rsatadi.

Bir vaqtda bitta `sign()`: oyna ochiqligida chaqirilgan ikkinchisi `busy`
oladi. Callback bir marta keladi — activity oyna ochiqligida qayta yaratilsa
(masalan, ekran burilsa) ham, shuning uchun unda eski activity'ga emas, joriy
ekranga murojaat qiling. Imzolangan hujjatni (PKCS#7) E-IMZO avvalgidek
backend'ingizga beradi, ilova uni olmaydi: `signed` dan keyin hujjat holatini
backend'ingizdan biling.

### Xato kodlari

`{"status":"error","code":"…","message":"…"}`:

| `code` | Qachon |
|---|---|
| `api_not_allowed` | Integratorda «Kalitlar API» ruxsati yo'q |
| `not_initialized` | `EImzoSDK.checkLicenseAndInit` bu jarayonda hali `true` qaytarmagan |
| `blocked` | Litsenziya tekshiruvi yoki gateway ilovani yoki telefonni rad etdi; `message` — gateway kodi, masalan `app_blocked` |
| `network` | Gateway'ga ulanib bo'lmadi yoki u javob bermadi |
| `invalid_request` | `deepLink` imzo so'rovi emas yoki E-IMZO undagi saytni tanimaydi |
| `key_not_found` | Shu muhitda bu `id` li kalit yo'q |
| `key_expired` | Kalit sertifikatining muddati tugagan |
| `busy` | Boshqa `sign()` hali ochiq |
| `sign_failed` | E-IMZO imzoni rad etdi (`message` — uning o'z javobi), ID-karta yoki token PIN'i bloklandi (`message`: `pin_blocked`) yoki oqim boshqa xato bilan tugadi |

`message` — ishlab chiquvchi uchun matn: inglizcha, E-IMZO rad etganda esa
uning o'z javobi (rus yoki o'zbek tilida bo'lishi mumkin). Foydalanuvchiga uni
emas, `code` bo'yicha o'z matningizni ko'rsating. Unda kalit, parol yoki xesh
hech qachon bo'lmaydi.

---

## 🐛 Xato va crash hisobotlari

SDK foydalanuvchi duch kelgan xatolarni va SDK ichidagi crash'larni YT
gateway'iga yuboradi — YT shular bo'yicha SDK'ni tuzatadi. Bu har bir ilova
uchun doim yoqilgan.

- **Yuboriladi:** amal (kalit qo'shish, imzolash, QR skanerlash, kalitni
  o'chirish), xato kodi, foydalanuvchiga ko'rsatilgan matn, kalit turi, SDK va
  OS versiyasi, qurilma modeli; crash'da — uning stack'i.
- **Hech qachon yuborilmaydi:** ism, JSHSHIR va STIR, sertifikat seriya raqami,
  parol, PIN, QR kod, hujjat va uning xeshi. Matn va stack telefondan
  chiqishidan oldin shunday qiymatlardan tozalanadi.
- Crash keyingi ishga tushishda yuboriladi; ilovangizning o'z crash
  reporter'i (masalan, Crashlytics) uni avvalgidek oladi.
- **iOS (Flutter):** App Store Connect → App Privacy'da **Crash Data** va
  **Other Diagnostic Data** ni e'lon qiling: foydalanuvchiga bog'lanmagan,
  kuzatish (tracking) uchun ishlatilmaydi, maqsad — *App Functionality*. iOS
  SDK privacy manifest bilan keladi.

Gateway imzolarni ilova va kalit turi (ERI fayl, QR kod, ID-karta, USB token,
BAIK token) bo'yicha sanaydi. Nima va kim imzolagani saqlanmaydi.

---

## 🎨 Foydalanuvchi tomonidagi oqim

`EImzoActivity` ochilgach foydalanuvchi quyidagilarni ko'radi:

| Ekran | Tasvir |
|---|---|
| **Loading** | Gateway tekshiruvi paytida spinner. |
| **Blocked** | Ilova ro'yxatdan o'tmagan yoki qurilma tekshiruvdan o'tmagan bo'lsa — sababi bitta jumlada; «Ishlab chiquvchi uchun» bo'limida paket nomi va texnik sabab. |
| **Home** | Asosiy kalit kartasi va «Kalit qo'shish». |
| **Add Key** | ERI fayl, QR kod, ID-karta, USB token yoki BAIK token — bitta ro'yxatdan. |
| **Keys** | Saqlangan kalitlar: asosiy qilish, o'chirish. Boshqa muhitda qo'shilgan kalit «Boshqa server» deb belgilanadi. |
| **Sign flow** | Tasdiq ekrani: sayt, xesh va kalit. Faqat IMZOLASH tugmasi imzolaydi; parol oynasi yoki PIN klaviaturasi. |
| **Signed** | «Ilovaga qaytish» — taxminan 3 soniyadan keyin ilovangizga o'zi qaytadi. QR koddan boshlangan imzo «Tayyor» bilan tugaydi. |
| **NFC wait** | ID-kartani kutish oynasi: o'qilmoqda, o'qilmadi, topilmadi, bloklandi. Noto'g'ri PIN'da qolgan urinishlar soni ko'rsatiladi. |

Xatolar ekran tepasidagi bannerda oddiy jumla bilan chiqadi. SDK matnlari
o'zbek, rus va ingliz tillarida: tilni foydalanuvchi SDK sozlamalarida
tanlaydi, ilovangizning tili o'zgarmaydi.

---

## 🛠 Alternativ: AAR ni qo'lda yuklash

Maven repo'siz, offline kerak bo'lsa:

### 1. AAR ni `app/libs/` ga ko'chiring

```
your-app/
└── app/libs/
    └── eimzo-sdk-2.4.0.aar
```

Yuklab olish: **[android/eimzo-sdk-2.4.0.aar](android/eimzo-sdk-2.4.0.aar)** (13 MB)

### 2. `app/build.gradle`
```gradle
dependencies {
    implementation files('libs/eimzo-sdk-2.4.0.aar')

    // Tranzit dependency'larni qo'lda yozing:
    implementation 'org.jetbrains.kotlinx:kotlinx-coroutines-android:1.7.3'
    implementation 'androidx.core:core-ktx:1.12.0'
    implementation 'androidx.appcompat:appcompat:1.6.1'
    implementation 'com.google.android.material:material:1.11.0'
    implementation 'androidx.lifecycle:lifecycle-runtime-ktx:2.6.2'
    implementation 'androidx.lifecycle:lifecycle-viewmodel-ktx:2.6.2'
    implementation 'androidx.lifecycle:lifecycle-livedata-ktx:2.6.2'
    implementation 'androidx.fragment:fragment-ktx:1.6.2'
    implementation 'androidx.activity:activity-ktx:1.8.2'
    implementation 'androidx.constraintlayout:constraintlayout:2.1.4'
    implementation 'androidx.navigation:navigation-fragment-ktx:2.7.6'
    implementation 'androidx.navigation:navigation-ui-ktx:2.7.6'
    implementation 'androidx.room:room-runtime:2.6.1'
    implementation 'androidx.room:room-ktx:2.6.1'
    implementation 'androidx.databinding:viewbinding:8.1.0'
    implementation 'com.squareup.okhttp3:okhttp:4.12.0'
    implementation 'com.google.code.gson:gson:2.10.1'
    implementation 'org.bouncycastle:bcprov-jdk15on:1.70'
    implementation 'org.bouncycastle:bcpkix-jdk15on:1.70'
    implementation 'com.airbnb.android:lottie:6.4.0'
    implementation 'com.journeyapps:zxing-android-embedded:4.3.0'
    implementation 'com.google.zxing:core:3.5.2'
}
```

### 3. Ishga tushirish — yuqoridagi 4-qadam bilan bir xil

---

## ✨ Imkoniyatlar

| Funksiya | Holati |
|---|---|
| **Tayyor to'liq UI** (Home, Keys, AddKey, Sign flow, NFC, QR scanner) | ✅ |
| PFX (.pfx) fayldan kalit import | ✅ |
| QR kod orqali kalit import (kamera) | ✅ |
| NFC ID-karta orqali kalit import | ✅ |
| USB Token (FT-1280) bilan imzolash | ✅ |
| BAIK USB token | ✅ |
| OzDST 1092 elektron imzo (milliy standart) | ✅ |
| OzDST 1106 hash funksiyasi | ✅ |
| Ilova ichida yasalgan imzo so'rovi (`EImzoSignLink`) | ✅ |
| [Kalitlar API](#-kalitlar-api): kalitlar ro'yxati va tanlangan kalit bilan SDK oynasida imzolash (YT ruxsati bilan) | ✅ |
| Sertifikat va sayt tekshiruvi (E-IMZO, YT gateway orqali) | ✅ |
| Ro'yxatdan o'tish: YT gateway, key attestation | ✅ |
| Xato va crash hisobotlari | ✅ |
| `prod` va `dev` muhitlari | ✅ |
| O'zbek, rus va ingliz tillari | ✅ |
| Tamper detection (Frida, Xposed, root manager) | ✅ |
| iOS | ✅ alohida SDK: [eimzo-ios-sdk](https://github.com/peachdev-uz/eimzo-ios-sdk) |

---

## 📋 Versiyalar

So'nggi versiya: **[2.4.0](https://github.com/peachdev-uz/eimzo-mobile-sdk/releases/tag/v2.4.0)** (2026-11-09)

**O'zgartirishlar** uchun: [CHANGELOG.md](CHANGELOG.md)

---

## 📞 Aloqa

- 📧 **Email:** info@yt.uz
- 🌐 **Sayt:** https://yt.uz
- 🐛 **Bug report:** [GitHub Issues](https://github.com/peachdev-uz/eimzo-mobile-sdk/issues)

---

## 📄 Litsenziya

```
Copyright (c) 2026 Yangi Texnologiyalar (YT).
Barcha huquqlar himoyalangan.

E-IMZO SDK proprietary kutubxona hisoblanadi. Foydalanish faqat
YT ro'yxatdan o'tkazgan integratorlarga ruxsat etiladi.
Reverse engineering, modification yoki redistribution man etilgan.
```

To'liq matn: [LICENSE](LICENSE)
