# E-IMZO Mobile SDK

> O'zbekiston Respublikasi rasmiy elektron raqamli imzo (ERI) tizimi uchun mobil SDK.
> **Android** native + **Flutter** plugin.

[![Version](https://img.shields.io/badge/version-1.2.6-blue.svg)](https://github.com/peachdev-uz/eimzo-mobile-sdk/releases)
[![Android](https://img.shields.io/badge/Android-API%2024+-green.svg)](https://developer.android.com)
[![Flutter](https://img.shields.io/badge/Flutter-3.10+-blue.svg)](https://flutter.dev)
[![pub.dev](https://img.shields.io/pub/v/eimzo_flutter?label=pub.dev)](https://pub.dev/packages/eimzo_flutter)
[![License](https://img.shields.io/badge/license-Proprietary-red.svg)](#-litsenziya)

---

## 🚀 Asosiy g'oya

**Hech qanday UI yozish shart emas.** SDK to'liq E-IMZO interfeysini o'zi taqdim etadi —
Home ekrani, kalitlar ro'yxati, PFX/QR/NFC orqali kalit qo'shish, parol so'rash, imzolash
oqimi, NFC kutish animatsiyalari, QR scanner — hammasi tayyor.

Sizning ilovangiz **bir qator kod** bilan butun E-IMZO oqimini ochadi:

```kotlin
startActivity(Intent(this, EImzoActivity::class.java))
```

Yoki imzolash uchun deeplink bilan to'g'ridan-to'g'ri imzo ekraniga o'tish:

```kotlin
startActivity(Intent(this, EImzoActivity::class.java).apply {
    data = Uri.parse("eimzo://sign?qc=1a4759282737...")
})
```

Tamom. Integrator faqat **kachachi/launcher** rolini bajaradi — qolganini SDK bajaradi.

---

## 📦 Yuklab olish

### Android

📥 **[eimzo-sdk-1.2.6.aar](android/eimzo-sdk-1.2.6.aar)** (11 MB) — to'liq UI bundlanган

Yoki Releases sahifasidan: **[GitHub Releases →](https://github.com/peachdev-uz/eimzo-mobile-sdk/releases/latest)**

### Flutter

```yaml
dependencies:
  eimzo_flutter: ^1.0.9
```

🔗 https://pub.dev/packages/eimzo_flutter

---

## 🎯 Ishlovchi misol

Tezda boshlash uchun **`example/android-kotlin/`** ichidagi to'liq
ishlovchi misol proyektga qarang:

```bash
git clone https://github.com/peachdev-uz/eimzo-mobile-sdk.git
cd eimzo-mobile-sdk/example/android-kotlin
./gradlew installDebug
```

📁 **[example/android-kotlin/](example/android-kotlin/)** — minimal Kotlin
ilova, 2 tugma, `eimzo://sign?qc=...` deep link qo'llab-quvvatlash.

Yoki quyidagi 4 qadamni qo'lda bajaring:

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
    implementation 'uz.eimzo:eimzo-sdk:1.2.6'
}
```

Bu **bitta qator** barcha tranzit dependency'larni avtomatik tortib oladi
(Kotlin coroutines, AndroidX, Room, OkHttp, Gson, BouncyCastle, Material, Lottie, Navigation va h.k.).

### 3. Permission va activity'lar — `AndroidManifest.xml`

Faqat permission'lar qo'shing — barcha SDK activity'lari (`EImzoActivity`, `QrScannerActivity`,
`BlockedAppActivity`) AAR manifest'ida allaqachon e'lon qilingan va Gradle manifest merger
orqali avtomatik qo'shiladi.

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.NFC" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-feature android:name="android.hardware.nfc" android:required="false" />
```

### 4. SDK UI'ni oching

Ilovangizning istalgan joyidan (tugma, menyu, deeplink router…):

```kotlin
import uz.eimzo.sdk.fullui.EImzoActivity

class MyActivity : AppCompatActivity() {
    fun openEimzo() {
        startActivity(Intent(this, EImzoActivity::class.java))
    }

    fun signDocument(qrCode: String) {
        startActivity(Intent(this, EImzoActivity::class.java).apply {
            data = Uri.parse("eimzo://sign?qc=$qrCode")
        })
    }
}
```

✅ **Tamom.** `EImzoActivity` license tekshiruvi, kalitlar boshqaruvi, imzolash, NFC va QR oqimlarini o'zi bajaradi.

---

## 🎨 Foydalanuvchi tomonidagi oqim

`EImzoActivity` ochilgach foydalanuvchi quyidagilarni ko'radi:

| Ekran | Tasvir |
|---|---|
| **Loading** | Sakura gradient fon + Lottie spinner. License tekshirilayotgan paytda. |
| **Blocked** | Agar ilova ro'yxatdan o'tmagan bo'lsa — package name + email yuborish formasi. |
| **Home** | "Kalit qo'shish" tugmasi + so'nggi kalitlar (gradient kartochkalar). |
| **Add Key** | PFX, QR, NFC, USB token tanlash. |
| **Keys** | Saqlangan kalitlar ro'yxati. Tap qilib default qilish / o'chirish. |
| **Sign flow** | Deeplink qabul qilinganda parol so'rash, imzolash, "IMZOLANYABDI..." → "IMZOLANDI" indikator. |
| **NFC wait** | 3 ta Lottie animatsiyali bottom sheet (kartani yaqinlashtiring → o'qilyapti → bajarildi). |

---

## 🛠 Alternativ: AAR ni qo'lda yuklash

Maven repo'siz, offline kerak bo'lsa:

### 1. AAR ni `app/libs/` ga ko'chiring

```
your-app/
└── app/libs/
    └── eimzo-sdk-1.2.6.aar
```

Yuklab olish: **[android/eimzo-sdk-1.2.6.aar](android/eimzo-sdk-1.2.6.aar)** (11 MB)

### 2. `app/build.gradle`
```gradle
dependencies {
    implementation files('libs/eimzo-sdk-1.2.6.aar')

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
| OzDST 1092 elektron imzo (milliy standart) | ✅ |
| OzDST 1106 hash funksiyasi | ✅ |
| Deeplink (`eimzo://sign?qc=...`) | ✅ |
| Sertifikat validatsiyasi (m.e-imzo.uz) | ✅ |
| License guard (Firebase) | ✅ |
| R8 obfuscation + string encryption + tamper detection | ✅ |
| iOS qo'llab-quvvatlash | 🚧 (rejada) |

---

## 🔐 Litsenziya tartibi

E-IMZO SDK **license-gated** — har bir integrator ilovasi Firebase orqali ro'yxatdan o'tishi shart.

### Ro'yxatdan o'tish jarayoni

1. SDK'ni loyihangizga qo'shing va `EImzoActivity` ni oching
2. Birinchi run'da **Blocked ekran** ko'rasiz (package name + signature hash)
3. **"RUXSAT SO'RASH"** tugmasini bosing → email orqali so'rov yuboriladi
4. Yoki to'g'ridan-to'g'ri **info@yt.uz** ga `packageName` yuboring
5. YT komandasi 1-2 ish kunida tasdiqlaydi
6. Ilovangizni qaytadan ishga tushiring → ishlay boshlaydi

---

## 📋 Versiyalar

So'nggi versiya: **[1.2.6](https://github.com/peachdev-uz/eimzo-mobile-sdk/releases/tag/v1.2.6)** (2026-06-10)

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
Firebase orqali tasdiqlangan integratorlarga ruxsat etiladi.
Reverse engineering, modification yoki redistribution man etilgan.
```

To'liq matn: [LICENSE](LICENSE)
