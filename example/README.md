# E-IMZO Mobile SDK — misollar

Bu papkada SDK'ni turli platformalarga integratsiya qilish misollari
joylashgan. Har bir misol o'zicha to'liq, ishlovchi proyekt —
`git clone` qilib darhol ishga tushirsa bo'ladi.

Ikkala misol ham SDK 2.4.0 uchun. Ular `eimzo://` havolalarini tashqaridan
qabul qilmaydi: imzo so'rovini ilova o'zi `EImzoSignLink.create` bilan
yasaydi. SDK ishlashi uchun ilova YT'da ro'yxatdan o'tgan bo'lishi kerak —
har bir misolning README'siga qarang.

---

## 📂 Mavjud misollar

| Misol | Tavsif | Platforma |
|---|---|---|
| [`android-kotlin/`](android-kotlin/) | Minimal Kotlin Android ilova — 2 tugma: SDK'ni ochish va imzo so'rovi bilan imzolash. SDK — shu repodagi `maven/` dan | Android (Kotlin) |
| [`ios-swift/`](ios-swift/) | Minimal SwiftUI ilova — muhit, SDK'ni ochish, `siteId`/`documentId`/`hash` dan imzo so'rovi | iOS (Swift) |

---

## 🚧 Rejada

| Misol | Tavsif | Holati |
|---|---|---|
| `android-java/` | Java tilida bir xil misol | Rejada |
| `flutter/` | Flutter `eimzo_flutter` plugin misoli | ✅ [alohida repo](https://github.com/peachdev-uz/eimzo_flutter/tree/main/example) |

---

## 🤝 Hissa qo'shish

Yangi misol qo'shmoqchi bo'lsangiz — Pull Request yuboring.
Misol minimal, izohli va `git clone && build` bilan ishlovchi
bo'lishi kerak.

📧 **info@yt.uz** • 🐛 **[GitHub Issues](https://github.com/peachdev-uz/eimzo-mobile-sdk/issues)**
