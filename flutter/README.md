# E-IMZO Flutter Plugin

Flutter integratorlari uchun **rasmiy plugin** allaqachon pub.dev'da.
U Android SDK 2.4.0 ni o'z ichiga oladi, iOS'da esa
[eimzo-ios-sdk](https://github.com/peachdev-uz/eimzo-ios-sdk) 2.4.0 ni ishlatadi.

## 📦 O'rnatish

```yaml
dependencies:
  eimzo_flutter: ^2.4.0
```

🔗 https://pub.dev/packages/eimzo_flutter

Android va iOS sozlamalari (iOS 16+, `Info.plist`, NFC entitlement) —
plaginning pub.dev sahifasida.

## 🚀 Ishlatish

```dart
import 'package:eimzo_flutter/eimzo_flutter.dart';

final eimzo = EimzoFlutter.instance;

// Sozlama — openSignUi dan oldin. Android'da gateway tekshiruvi shu yerda,
// iOS'da esa SDK UI'si ichida o'tadi.
final allowed = await eimzo.init(
  config: const EimzoConfig(environment: EimzoEnvironment.prod), // sinovda: EimzoEnvironment.dev
);
if (!allowed) return; // SDK bloklangan ekranni ko'rsatmoqda

// To'liq E-IMZO UI'ni ochish
await eimzo.openSignUi();

// Yoki hujjatni imzolash: siteId, documentId va hash backend'ingizdan keladi
final link = EimzoSignLink.create(siteId: siteId, documentId: documentId, hash: hash);
await eimzo.openSignUi(deepLink: link);
```

Plugin Android tomonda `EImzoActivity` ni, iOS'da `EImzoView` ni ochadi — gateway
tekshiruvi, kalit boshqaruvi va imzolash oqimini SDK o'zi bajaradi. Hech qanday
Dart UI yozish shart emas.

## 2.4 da nima o'zgardi

- «Kalitlar API» — YT ruxsat bergan integrator uchun plaginda ikkita yangi
  metod: `EimzoFlutter.instance.getKeys()` foydalanuvchi SDK'ga qo'shgan
  kalitlar ro'yxatini beradi, `EimzoFlutter.instance.sign(keyId:, deepLink:)`
  esa so'rovni tanlangan kalit bilan SDK oynasida imzolaydi. Ikkalasi ham
  native SDK'ning JSON'ini `String` sifatida qaytaradi; JSON va xato kodlari
  Android va iOS bilan bir xil. Ruxsat shartnomadan keyin beriladi —
  info@yt.uz ga yozing.
- Kalitlar avvalgidek `openSignUi()` ochgan SDK ekranlarida qo'shiladi,
  parol yoki PIN faqat SDK oynasida teriladi.
- Batafsil — plaginning [pub.dev sahifasidagi](https://pub.dev/packages/eimzo_flutter)
  «Keys API («Kalitlar API»)» bo'limida; JSON va xato kodlari —
  [Kalitlar API](../README.md#-kalitlar-api).

## 2.3 da nima o'zgardi

- Ilova YT gateway'da ro'yxatdan o'tishi kerak, litsenziya fayli kerak emas:
  [Ro'yxatdan o'tish](../README.md#-royxatdan-otish).
- `eimzo://` havolalari tashqaridan qabul qilinmaydi: `AndroidManifest.xml` va
  `Info.plist` ga `eimzo` sxemasini qo'shmang. `getInitialDeeplink()`,
  `onNewDeeplink()` va `launchDeeplink()` olib tashlandi — imzo so'rovi
  `EimzoSignLink.create` bilan ilova ichida yasaladi.
- `isTestMode` o'rniga `environment`: `EimzoEnvironment.prod` (sukut bo'yicha)
  yoki `EimzoEnvironment.dev`. `isTestMode` hali ishlaydi, lekin eskirgan.
- Xato va crash hisobotlari YT gateway'iga yuboriladi. iOS'da App Store Connect →
  App Privacy'da **Crash Data** va **Other Diagnostic Data** ni e'lon qiling:
  [Xato va crash hisobotlari](../README.md#-xato-va-crash-hisobotlari).

## 📞 Aloqa

- 📧 info@yt.uz
- 🌐 https://yt.uz
- 🐛 GitHub Issues: https://github.com/peachdev-uz/eimzo_flutter/issues
