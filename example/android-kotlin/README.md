# E-IMZO Mobile SDK — Android (Kotlin) misol

Minimal Android Kotlin ilovasi — E-IMZO Mobile SDK'ni integratsiya
qilishning eng qisqa yo'lini ko'rsatadi. **Ikkita tugma, ~80 qator
asosiy kod** — to'liq E-IMZO oqimi ochilgani.

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

---

## 📁 Loyiha tuzilmasi

```
example/android-kotlin/
├── settings.gradle              ← E-IMZO Maven repo shu yerda
├── build.gradle                 ← Root build script
├── gradle.properties
├── gradlew, gradlew.bat         ← Gradle wrapper
└── app/
    ├── build.gradle             ← uz.eimzo:eimzo-sdk:1.2.2 (BIR qator)
    ├── proguard-rules.pro
    └── src/main/
        ├── AndroidManifest.xml  ← Permissions + eimzo:// deep link
        ├── java/uz/eimzo/example/
        │   └── MainActivity.kt  ← 2 tugma, ~80 qator
        └── res/
            ├── layout/activity_main.xml
            ├── values/{strings,themes,colors}.xml
            ├── mipmap-anydpi-v26/, mipmap-hdpi/
            └── drawable/ic_launcher_foreground.xml
```

---

## 🧩 Integratsiya — bor-yo'g'i 3 qadam

### 1. `settings.gradle` — Maven repo

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
    implementation 'uz.eimzo:eimzo-sdk:1.2.2'
}
```

Bu yagona qator butun SDK ni va uning **barcha tranzit
dependency'larini** (Kotlin coroutines, Room, OkHttp, Gson,
BouncyCastle, Material, Lottie, Navigation va h.k.) avtomatik
import qiladi.

### 3. `MainActivity.kt` — SDK'ni ochish

```kotlin
import uz.eimzo.sdk.fullui.EImzoActivity

// To'liq UI (Home → Keys → AddKey → Sign):
startActivity(Intent(this, EImzoActivity::class.java))

// Yoki deep link orqali to'g'ridan-to'g'ri imzolash:
startActivity(Intent(this, EImzoActivity::class.java).apply {
    data = Uri.parse("eimzo://sign?qc=...")
})
```

**Tamom.** Boshqa hech narsa kerak emas — SDK license tekshiruvi,
kalit boshqaruvi, PFX/QR/NFC import, NFC kutish, QR scanner, USB
token aniqlash, imzolash — hammasi avtomatik.

---

## 🔐 Birinchi marta ishlatishda

Ilova birinchi marta ochilganda **"BLOKLANGAN"** ekrani chiqishi
mumkin — bu E-IMZO Mobile SDK'ning license-gate funksiyasi.
Hech qanday integrator package name avtomatik tasdiqlanmaydi.

Ro'yxatdan o'tish uchun:

1. Blocked ekrandagi **"RUXSAT SO'RASH"** tugmasini bosing, **yoki**
2. To'g'ridan-to'g'ri **info@yt.uz** ga elektron pochta yuboring:
   - `applicationId` (masalan: `uz.eimzo.example`)
   - SHA-256 signature hash (ekrаnda ko'rsatiladi)
3. 1-2 ish kuni ichida YT komandasi tasdiqlaydi
4. Ilovani qayta ishga tushiring

Bu misol uchun `applicationId` = `uz.eimzo.example` ish bermaydi —
o'zingizning `applicationId` bilan o'zgartirib ro'yxatdan o'ting.

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
