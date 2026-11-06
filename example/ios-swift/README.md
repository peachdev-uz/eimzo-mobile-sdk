# E-IMZO Mobile SDK — iOS (Swift) misol

Minimal SwiftUI ilovasi, EimzoSDK 2.3.0. `example/android-kotlin` bilan bir
xil narsani ko'rsatadi: SDK'ni ochish va ilova ichida yasalgan imzo so'rovi
bilan hujjatni imzolash.

---

## 🚀 Ishga tushirish

```bash
git clone https://github.com/peachdev-uz/eimzo-mobile-sdk.git
cd eimzo-mobile-sdk/example/ios-swift
open EimzoExample.xcodeproj
```

Xcode birinchi ochilishda EimzoSDK'ni (`from: "2.3.0"`) GitHub Releases'dan
o'zi yuklab oladi. Keyin **Signing & Capabilities** da o'z **Team**'ingizni
tanlang, bundle ID'ni o'zingiznikiga almashtiring va ▶ **Run**.

SDK E-IMZO bilan YT gateway orqali ishlaydi va ilovani App Attest bilan
taniydi, shuning uchun:

- ilova ro'yxatdan o'tgan bo'lishi kerak (pastda);
- uni haqiqiy iPhone'da sinang: iOS Simulator attestatsiya qila olmaydi,
  u yerda SDK bloklangan ekranni ko'rsatadi.

---

## 📁 Nima qayerda

```
example/ios-swift/
├── EimzoExample.xcodeproj        ← SPM orqali EimzoSDK 2.3.0 ga bog'langan
├── generate-xcodeproj.rb         ← loyihani qayta yaratish (odatda kerak emas)
└── EimzoExample/
    ├── EimzoExampleApp.swift     ← kirish nuqtasi, eimzo:// qabul qilinmaydi
    ├── ContentView.swift         ← muhit, SDK'ni ochish, imzo so'rovi
    ├── Info.plist                ← kamera va NFC
    └── EimzoExample.entitlements ← NFC
```

---

## ✍️ Imzo so'rovi

Hujjatning `siteId`, `documentId` va `hash` qiymatlari backend'ingizdan
keladi, havolani SDK yasaydi:

```swift
let link = try EImzoSignLink.create(siteId: siteId, documentId: documentId, hash: hash)
presentation = Presentation(deepLink: link)
```

Qiymat formati noto'g'ri bo'lsa (`siteId` — 4, `documentId` — 8, 10, 12,
14 yoki 16, `hash` — 64 hex belgi), `create` `EImzoSignLink.Error`
tashlaydi. Misol uning matnini maydonlar ostida ko'rsatadi.

SDK `sheet(item:)` bilan ochiladi:

```swift
.sheet(item: $presentation) { shown in
    EImzoView(
        config: EImzoConfig(environment: environment),
        deepLink: shown.deepLink,
        onSignComplete: { _ in presentation = nil }
    )
}
```

`sheet(isPresented:)` va alohida havola bilan sheet havola
yangilanishidan oldin ochilib, SDK so'rovsiz ochilishi mumkin.

Imzolangach SDK «Ilovaga qaytish» tugmasini ko'rsatadi. Tugma bosilganda
yoki taxminan 3 soniyadan keyin `onSignComplete` keladi va sheet yopiladi.

`eimzo` sxemasini `Info.plist`dagi `CFBundleURLTypes`ga qo'shmang va
`onOpenURL` bilan ushlamang: bu sxema E-IMZO ilovasiniki.

---

## 🌐 Muhit

Ekrandagi «Test muhiti (dev)» `EImzoConfig(environment:)` ni tanlaydi:
`.dev` — YT test muhiti (test.e-imzo.uz, faqat test kalitlari), `.prod` —
haqiqiy E-IMZO. Misol `.dev` da ochiladi. Hujjat qaysi muhitda yaratilgan
bo'lsa, faqat o'sha muhitda imzolanadi.

---

## 🔑 Ro'yxatdan o'tish

Litsenziya fayli kerak emas. `info@yt.uz` ga bundle ID, Team ID va muhitni
(`dev` va/yoki `prod`) yuboring:

```bash
codesign -dvvv YourApp.app 2>&1 | grep TeamIdentifier
```

Ro'yxatdan o'tmagan ilovada SDK bloklangan ekranni ko'rsatadi, sababi
uning «Ishlab chiquvchi uchun» bo'limida yoziladi (masalan
`app_not_registered`).

---

## 🧪 Tekshirilgan

iOS Simulator uchun `xcodebuild` bilan yig'ilgan (EimzoSDK 2.3.0,
Xcode 27.2).

---

📧 **info@yt.uz** • 🐛 **[GitHub Issues](https://github.com/peachdev-uz/eimzo-mobile-sdk/issues)**
