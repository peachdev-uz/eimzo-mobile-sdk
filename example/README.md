# E-IMZO Mobile SDK — misollar

Bu papkada SDK'ni turli platformalarga integratsiya qilish misollari
joylashgan. Har bir misol o'zicha to'liq, ishlovchi proyekt —
`git clone` qilib darhol ishga tushirsa bo'ladi.

Ikkala misol ham SDK 2.6.0 uchun. Ular `eimzo://` havolalarini tashqaridan
qabul qilmaydi: imzo so'rovini ilova o'zi `EImzoSignLink.create` bilan
yasaydi. SDK ishlashi uchun ilova YT'da ro'yxatdan o'tgan bo'lishi kerak —
har bir misolning README'siga qarang.

Ikkalasida «Kalitlar API» tugmalari ham bor: «Kalitlar ro'yxati»
foydalanuvchi SDK'ga qo'shgan kalitlarni JSON'da ko'rsatadi va ulardan biri
tanlanadi, «Tanlangan kalit bilan imzolash» esa o'sha imzo so'rovini shu
kalit bilan SDK oynasida imzolaydi. Kalitlar API faqat YT ruxsat bergan
integratorlar uchun: ruxsat YT bilan shartnoma tuzilgach, **info@yt.uz** ga
yozilgan so'rov bo'yicha yoqiladi. Ruxsatsiz «Kalitlar ro'yxati»
`api_not_allowed` xatosini ko'rsatadi va kalit tanlanmaydi.

---

## 📂 Mavjud misollar

| Misol | Tavsif | Platforma |
|---|---|---|
| [`android-kotlin/`](android-kotlin/) | Minimal Kotlin Android ilova — SDK'ni ochish, imzo so'rovi bilan imzolash va Kalitlar API: kalitlar ro'yxati, tanlangan kalit bilan imzolash. SDK — shu repodagi `maven/` dan | Android (Kotlin) |
| [`ios-swift/`](ios-swift/) | Minimal SwiftUI ilova — muhit, SDK'ni ochish, `siteId`/`documentId`/`hash` dan imzo so'rovi va Kalitlar API | iOS (Swift) |

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
