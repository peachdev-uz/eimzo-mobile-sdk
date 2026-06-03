# E-IMZO Flutter Plugin

Flutter integratorlari uchun **rasmiy plugin** allaqachon pub.dev'da.

## 📦 O'rnatish

```yaml
dependencies:
  eimzo_flutter: ^1.0.1
```

🔗 https://pub.dev/packages/eimzo_flutter

## 🚀 Ishlatish

```dart
import 'package:eimzo_flutter/eimzo_flutter.dart';

final eimzo = EimzoFlutter.instance;

// To'liq E-IMZO UI'ni ochish
await eimzo.openSignUi();

// Yoki imzolash uchun deeplink bilan
await eimzo.openSignUi(deepLink: 'eimzo://sign?qc=1a4759...');
```

Plugin Android tomonda `EImzoActivity` ni ochadi — barcha license tekshiruvi,
kalit boshqaruvi va imzolash oqimini SDK o'zi bajaradi. Hech qanday Dart UI yozish shart emas.

## 📞 Aloqa

- 📧 info@yt.uz
- 🌐 https://yt.uz
- 🐛 GitHub Issues: https://github.com/peachdev-uz/eimzo_flutter/issues
