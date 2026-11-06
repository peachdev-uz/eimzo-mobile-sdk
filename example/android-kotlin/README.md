# E-IMZO Mobile SDK — Android (Kotlin) misol

Minimal Android Kotlin ilovasi, `uz.eimzo:eimzo-sdk:2.3.0`. Ikkita tugma:
SDK'ni ochish va ilova ichida yasalgan imzo so'rovi bilan hujjatni
imzolash.

---

## 🚀 Ishga tushirish

```bash
git clone https://github.com/peachdev-uz/eimzo-mobile-sdk.git
cd eimzo-mobile-sdk/example/android-kotlin
./gradlew installDebug
```

Yoki **Android Studio** orqali:

1. `File → Open…` → `eimzo-mobile-sdk/example/android-kotlin`
2. Gradle sync tugashini kuting
3. ▶ **Run** (yashil tugma)

Misol SDK'ni shu repodagi [`maven/`](../../maven/) papkasidan oladi, ya'ni
klonlangan versiyadagi SDK bilan yig'iladi. SDK ishlashi uchun ilova
ro'yxatdan o'tgan bo'lishi kerak — pastda «Ro'yxatdan o'tish».

---

## 📁 Loyiha tuzilmasi

```
example/android-kotlin/
├── settings.gradle              ← Maven repo (shu repodagi maven/)
├── build.gradle                 ← Root build script
├── gradle.properties
├── gradlew, gradlew.bat         ← Gradle wrapper
└── app/
    ├── build.gradle             ← uz.eimzo:eimzo-sdk:2.3.0 (BIR qator)
    ├── proguard-rules.pro
    └── src/main/
        ├── AndroidManifest.xml  ← faqat MainActivity, eimzo:// filtri yo'q
        ├── java/uz/eimzo/example/
        │   └── MainActivity.kt  ← sozlama va 2 tugma
        └── res/
            ├── layout/activity_main.xml
            ├── values/{strings,themes,colors}.xml
            ├── mipmap-anydpi-v26/, mipmap-hdpi/
            └── drawable/ic_launcher_foreground.xml
```

---

## 🧩 Integratsiya — 3 qadam

### 1. `settings.gradle` — Maven repo

O'z ilovangizda ochiq repo manzilini yozing:

```gradle
dependencyResolutionManagement {
    repositories {
        google()
        mavenCentral()
        maven { url 'https://raw.githubusercontent.com/peachdev-uz/eimzo-mobile-sdk/main/maven/' }
    }
}
```

### 2. `app/build.gradle` — bitta qator

```gradle
dependencies {
    implementation 'uz.eimzo:eimzo-sdk:2.3.0'
}
```

Bu yagona qator butun SDK'ni va uning **barcha tranzit
dependency'larini** (Kotlin coroutines, Room, OkHttp, Gson,
BouncyCastle, Material, Lottie, Navigation va h.k.) avtomatik
import qiladi. Permission'lar va SDK activity'lari AAR manifest'idan
o'zi qo'shiladi — `AndroidManifest.xml` ga hech narsa yozilmaydi.

### 3. `MainActivity.kt` — sozlama va SDK'ni ochish

```kotlin
private val eimzoConfig = EImzoConfig(
    environment = if (BuildConfig.DEBUG) EImzoEnvironment.DEV else EImzoEnvironment.PROD,
)

private fun launchEimzo(link: String?) {
    EImzoSDK.checkLicenseAndInit(this, eimzoConfig) { allowed ->
        if (!allowed) return@checkLicenseAndInit // SDK bloklangan ekranni ko'rsatdi
        startActivity(Intent(this, EImzoActivity::class.java).apply {
            if (link != null) data = Uri.parse(link)
        })
    }
}

// SDK'ni ochish:
launchEimzo(link = null)

// Hujjatni imzolash: siteId, documentId va hash backend'ingizdan keladi
launchEimzo(EImzoSignLink.create(siteId, documentId, hash))
```

- `checkLicenseAndInit` sozlamani SDK'ga beradi va ilovani YT
  gateway'ida tekshiradi. Uni `EImzoActivity` dan oldin chaqiring.
- `EImzoSignLink.create` qiymatlar shaklini tekshiradi va
  `eimzo://sign?qc=…` havolasini qaytaradi; qiymat noto'g'ri bo'lsa,
  `IllegalArgumentException` tashlaydi.
- `eimzo` sxemali `intent-filter` qo'shmang: bu sxema E-IMZO ilovasiniki.
- Imzolangach SDK «Ilovaga qaytish» ni ko'rsatadi va taxminan 3
  soniyadan keyin ilovaga o'zi qaytadi.

Misolda debug build YT test muhitida (`DEV`, test.e-imzo.uz — faqat test
kalitlari), release build haqiqiy E-IMZO'da (`PROD`) imzolaydi.

**Tamom.** Kalitlar, PFX/QR/NFC import, NFC kutish, QR scanner, USB
token, imzolash — hammasini SDK o'zi bajaradi.

---

## 🔐 Ro'yxatdan o'tish

SDK E-IMZO bilan YT gateway orqali ishlaydi va ilovani key attestation
bilan taniydi. Litsenziya fayli kerak emas, lekin ilova ro'yxatdan o'tgan
bo'lishi kerak. **info@yt.uz** ga yuboring:

- `applicationId` (paket nomi)
- ilovani imzolagan sertifikatning SHA-256 i: debug build uchun
  `./gradlew signingReport`, release uchun
  `apksigner verify --print-certs app-release.apk`
- muhit: `dev` (debug build) va/yoki `prod`

Misoldagi `uz.eimzo.example` o'rniga o'z `applicationId` ingizni yozing va
shuni ro'yxatdan o'tkazing. Ro'yxatdan o'tmagan ilovada SDK bloklangan
ekranni ko'rsatadi; uning «Ishlab chiquvchi uchun» bo'limida paket nomi va
sabab yozilgan.

Emulyator faqat `dev` muhitida ishlaydi. Root qilingan yoki bootloader'i
ochilgan telefonda SDK ishlamaydi.

---

## 🛠 Talablar

| | |
|---|---|
| **Min SDK** | 24 (Android 7.0) |
| **Target SDK** | 34 (Android 14) |
| **Kotlin** | 1.9.0+ |
| **AGP** | 8.1.0+ |
| **Gradle** | 8.5+ |
| **JDK** | 17 |

---

## 📞 Yordam

- 📧 **Email:** info@yt.uz
- 🐛 **GitHub Issues:** https://github.com/peachdev-uz/eimzo-mobile-sdk/issues
- 📖 **To'liq hujjat:** [../../README.md](../../README.md)
