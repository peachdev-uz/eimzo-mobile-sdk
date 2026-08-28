# E-IMZO Mobile SDK — iOS (Swift) misol

Minimal SwiftUI ilovasi. `example/android-kotlin` bilan bir xil narsani
ko'rsatadi, ustiga iOS'da alohida e'tibor talab qiladigan qismni —
**deeplink tuzish va qabul qilish**.

---

## 🚀 Ishga tushirish

```bash
git clone https://github.com/peachdev-uz/eimzo-mobile-sdk.git
cd eimzo-mobile-sdk/example/ios-swift
open EimzoExample.xcodeproj
```

Xcode birinchi ochilishda `EimzoSDK.xcframework` ni GitHub Releases'dan
o'zi yuklab oladi (~18 MB). Keyin **Signing & Capabilities** da o'z
**Team**'ingizni tanlang va ▶ **Run**.

Simulyatorda ham ishlaydi. Bitta farq: simulyatorda ilovalar imzolanmaydi,
shuning uchun litsenziyaning Team ID tekshiruvi o'tkazib yuboriladi —
litsenziyaning o'zi baribir kerak.

---

## 📁 Nima qayerda

```
example/ios-swift/
├── EimzoExample.xcodeproj        ← SPM orqali EimzoSDK ga bog'langan
├── generate-xcodeproj.rb         ← loyihani qayta yaratish (odatda kerak emas)
└── EimzoExample/
    ├── EimzoExampleApp.swift     ← onOpenURL — kiruvchi deeplink
    ├── ContentView.swift         ← uchta stsenariy, uchta tugma
    ├── DeepLink.swift            ← havolani tuzish va o'qish
    ├── Info.plist                ← CFBundleURLTypes — eimzo:// sxemasi
    └── EimzoExample.entitlements ← NFC
```

---

## 🔗 Deeplink

E-IMZO imzolash so'rovi `eimzo://sign?qc=<kod>` ko'rinishida keladi. `qc`
kodini imzolashni so'ragan portal beradi; havolani siz tuzasiz.

### Tuzish

`DeepLink.swift` dagi `EimzoDeepLink.make(qc:)` — `URLComponents` orqali:

```swift
var components = URLComponents()
components.scheme = "eimzo"
components.host = "sign"
components.queryItems = [URLQueryItem(name: "qc", value: code)]
let url = components.url
```

Satrni qo'lda yopishtirmang. `qc` bugun o'n oltilik sanoqda, lekin u
portalning maydoni: bir kun ichida `+` yoki `/` chiqsa, qo'lda tuzilgan satr
portal bergan koddan boshqa kodni yuboradi va xato imzolash bosqichida,
sababidan uzoqda ko'rinadi.

### Ochish

Havolani SDK'ga uzatasiz — Android'dagi `Intent.data` ning ekvivalenti:

```swift
EImzoView(deepLink: url.absoluteString, onSignComplete: { _ in ... })
```

### Qabul qilish

Ikkita qism kerak, ikkalasi ham majburiy:

**1. `Info.plist`** — Android'dagi `<intent-filter>` ning ekvivalenti:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLName</key><string>uz.eimzo.example.signing</string>
    <key>CFBundleURLSchemes</key><array><string>eimzo</string></array>
  </dict>
</array>
```

**2. `onOpenURL`** — tizim yo'naltirgan har bir URL shu yerga keladi:

```swift
ContentView(incomingDeepLink: $incomingDeepLink)
    .onOpenURL { url in
        guard EimzoDeepLink.parse(url) != nil else { return }
        incomingDeepLink = url.absoluteString
    }
```

E'lon qilinib, ushlanmagan sxema ilovani ochadi va hech nima qilmaydi;
ushlangan, lekin e'lon qilinmagan sxema esa umuman kelmaydi.

`parse` filtri ham bejiz emas: `onOpenURL` shu ilovaga yo'naltirilgan
**barcha** URL'lar uchun ishga tushadi, va kelajakdagi
`eimzo://boshqa-narsa` imzolash so'rovi deb o'qilmasligi kerak.

### Sinash

```bash
xcrun simctl openurl booted 'eimzo://sign?qc=TEST123'
```

Yoki ilovadagi **"Havolani tizim orqali yuborish"** tugmasi — havolani
o'zingizga yuboradi va xuddi tashqi ilova yuborganidagi yo'lni bosib o'tadi.
Buning uchun `Info.plist` da `LSApplicationQueriesSchemes` ham kerak.

> **Diqqat.** Qurilmada `eimzo://` ni e'lon qilgan bir nechta ilova bo'lsa
> (masalan rasmiy E-IMZO ilovasi va sizniki), iOS qaysi biri ochilishini
> o'zi tanlaydi va buni boshqarib bo'lmaydi. Android'da tanlash oynasi
> chiqadi — iOS'da chiqmaydi. Sinovda kutilmagan ilova ochilsa, sabab
> shu.

---

## 🔑 Litsenziya

SDK imzolangan oflayn litsenziyasiz ishlamaydi. `info@yt.uz` ga bundle id
va Team ID yuboring:

```bash
codesign -dvvv YourApp.app 2>&1 | grep TeamIdentifier
```

Kelgan `EIMZO1.…` tokenini ikki yo'ldan biri bilan bering:

- **Fayl** — `eimzo-license.txt` ni maqsadga qo'shing va **Build Phases →
  Copy Bundle Resources** da turganini tekshiring. Xcode faylni
  navigatorda ko'rsatib, bundle'ga ko'chirmasligi mumkin — eng ko'p
  uchraydigan xato shu.
- **Konfiguratsiya** — `EImzoView(config: EImzoConfig(license: token))`.

Bu misolda litsenziya yo'q, shuning uchun ishga tushirsangiz SDK
"Ilova tasdiqlanmagan" ekranini ko'rsatadi. Deeplink yo'li esa shundan
oldin ishlaydi — ya'ni `onOpenURL` va varaq ochilishini litsenziyasiz ham
sinab ko'rish mumkin.

---

## 🧪 Tekshirilgan

Bu misol iPhone 17 Pro simulyatorida (iOS 26) yig'ilib, ishga tushirilgan:
`simctl openurl` bilan yuborilgan havola `onOpenURL` ga yetib, SDK varag'i
ochilgan.

---

📧 **info@yt.uz** • 🐛 **[GitHub Issues](https://github.com/peachdev-uz/eimzo-mobile-sdk/issues)**
