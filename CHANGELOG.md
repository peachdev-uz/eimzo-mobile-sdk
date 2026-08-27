## 2.1.2 — 2026-08-27

**Tuzatish: konfiguratsiya SDK'gacha yetmasdi.**

Flutter plagini iOS'da `EimzoConfig` ni butunlay tashlab yuborardi — test
rejimi, API manzillari va litsenziya platform kanalida to'xtardi. Android'da
esa litsenziya SDK ekrani ochilishi bilan o'chib ketardi, chunki ekran o'z
standart konfiguratsiyasi bilan qayta init qilardi. Ikkalasi ham tuzatildi:
endi berilgan litsenziyani keyingi standart konfiguratsiya o'chirmaydi.

**Yaxshilandi: "Litsenziya topilmadi" endi nima qilish kerakligini aytadi.**

Odatda sabab litsenziya yo'qligi emas, faylning ilova bundle'iga tushmagani
bo'ladi — iOS'da uni Xcode'da maqsadning *Copy Bundle Resources* bosqichiga
qo'shish kerak, buni o'tkazib yuborish oson va ilova ikkala holatda bir xil
ko'rinadi. Endi xabar bundle ichida nima borligini tekshirib aytadi.

Litsenziyani konfiguratsiya orqali ham berish mumkin: `EImzoConfig(license:)`
(Android va iOS), Flutter'da `EimzoConfig(license: ...)`.

Yo'l-yo'lakay: iOS sozlamalar ekrani `Versiya 2.0.0` ko'rsatib turgan edi.

## 2.1.1 — 2026-08-26

**Tuzatish: kalitsiz imzolashda kalit qo'sha olmaslik.**

Deeplink bilan kirgan, kaliti yo'q foydalanuvchi kalitlar ekranida tiqilib
qolishi mumkin edi — bo'sh ro'yxat, hech qanday harakat yo'q. Bosh ekrandagi
kartaning butun foni bosiladigan edi va u yerga o'tkazardi; kalitlar ekranida
esa ro'yxat bo'sh bo'lsa qo'shish qatori chiqmasdi. Ikkalasi ham tuzatildi.

**Tuzatish: litsenziya tekshiruvi paytida ortga qaytilsa ilova qulardi.**

Tekshiruv asinxron, javob esa activity tirikmi-yo'qmi ko'rmasdan qaytarilardi.
Endi yopilayotgan activity'ga javob yetkazilmaydi — bu himoya
`checkLicenseAndInit` ichida, ya'ni o'z activity'ingizni uzatsangiz ham amal
qiladi.

iOS binariga tegilmadi — u 2.1.0 da qoladi.

## 2.1.0 — 2026-08-26

**BUZUVCHI — raqam minor bo'lsa ham.** Ommaviy API faqat UI kirish
nuqtasidan iborat bo'ldi.

Odatda bunday o'zgarish major raqamni talab qiladi. Minor tanlandi, chunki
bu metodlarni to'g'ridan-to'g'ri chaqirayotgan integrator yo'q — ular hech
qachon hujjatlashtirilmagan ham edi.

Ilgari SDK'ning butun ichki mexanizmi tashqarida ochiq turardi — imzolash,
kalit qo'shish, kalit ombori, model'lar, callback interfeyslari. README esa
har doim faqat `EImzoActivity` ni ko'rsatgan, ya'ni ular hech qachon
hujjatlashtirilmagan edi. Endi kod ham shuni aytadi.

**Android** — tashqarida qolgani:

- `EImzoActivity` — SDK'ning kirish nuqtasi
- `EImzoConfig`
- `EImzoSDK.checkLicenseAndInit(activity, config) { allowed -> … }`

`importPfxKey`, `importQrKey`, `importNfcKey`, `importUsbTokenKey`,
`signWithQrKey`, `signWithNfc`, `signWithUsbToken`, `getAllKeys`, `deleteKey`,
`getCertInfo` va callback interfeyslari `internal` bo'ldi.

**iOS** — tashqarida qolgani: `EImzoView`, `EImzoConfig`, `SignResult`.
UI'dan tashqari 141 ta ommaviy e'lon o'rniga uchtasi. `KeyStore`,
`EImzoSigner`, `EImzoApiClient`, `PkiUtils`, `HexUtils`, `TokenSession`,
`EImzoApplet` endi ko'rinmaydi.

### Nega

Imzolash oqimi litsenziya tekshiruvi, PIN so'rash, sessiya muddati va backend
bilan aloqani o'z ichiga oladi. Uni bo'lak-bo'lak tashqariga chiqarish har bir
integratorga o'sha ketma-ketlikni qayta yig'ish — va noto'g'ri yig'ish —
imkonini berardi.

### Migratsiya

`EImzoActivity` (Android) yoki `EImzoView` (iOS) ni ochsangiz, hech narsa
o'zgarmaydi. Agar ichki metodlarni to'g'ridan-to'g'ri chaqirayotgan bo'lsangiz,
`info@yt.uz` ga yozing — nima kerakligini birga ko'rib chiqamiz.

2.0.x maven'da qoladi.

## 2.0.2 — 2026-08-26

**Bosh ekrandan qayta dizayndan qolgan tugmalar olib tashlandi.**

TEZ IMZO ostida eski interfeysning uchta bo'lagi turardi: "USB TOKENNI ULANG"
tugmasi, "Kalit qo'shish" ajratgichi va "ERI qo'shish" qatori. Kalit qo'shish
kartasi va TEZ IMZO ularning o'rnini bosgan edi — ekranda bir xil narsa ikki
marta ko'rinardi. Endi ekran TEZ IMZO da tugaydi.

**E'tibor bering:** USB tokendan to'g'ridan-to'g'ri, hech nima saqlamasdan
imzolash tugmasi kalit saqlagan foydalanuvchilarga ham ko'rinardi. U endi yo'q —
token "USB token orqali" yo'li bilan kalit sifatida qo'shiladi va odatdagidek
imzolanadi. `signWithUsbToken` API'si o'zgarmagan, ya'ni o'z interfeysingizdan
chaqirsangiz ishlayveradi.

iOS binariga tegilmadi — u 2.0.0 da qoladi.

## 2.0.1 — 2026-08-26

**Tuzatish: SDK ekranlari release build'da ochilmasdi.**

2.0.0 da to'rtta ekran — sozlamalar, til, mavzu va imzo natijasi — AAR ichida
umuman yo'q edi. Ularni ochmoqchi bo'lganda ilova `ClassNotFoundException`
bilan yiqilardi.

Sabab kutubxonaning o'zida edi: u release'da R8 bilan qisqartirilardi. Bu
ekranlar faqat navigatsiya grafidan, `android:name` orqali chaqiriladi,
kutubxona uchun AAPT yozadigan keep qoidalari esa navigatsiya grafini qamrab
olmaydi — u faqat manifest komponentlarini va layout'dagi custom view'larni
ko'radi. R8 shu sababli ularni "hech kim chaqirmaydi" deb hisoblab, AAR'dan
olib tashlagan.

Endi kutubxona o'zini qisqartirmaydi. Ilovangizning R8'i uchun qo'shimcha
ProGuard qoidasi kerak emas — ilova darajasida AAPT nav-graf fragmentlari
uchun keep qoidasini o'zi yozadi.

**2.0.0 dan foydalanmang.** Agar unga o'tgan bo'lsangiz, 2.0.1 ga yangilang;
API, litsenziya va sozlamalar o'zgarmagan, faqat versiya raqamini almashtirasiz.

iOS binariga tegilmadi — u 2.0.0 da qoladi.

## 2.0.0 — 2026-08-25

**BUZUVCHI: litsenziya majburiy bo'ldi.**

Firestore ro'yxatidan tekshirish olib tashlandi. SDK endi faqat YT chiqargan
imzolangan oflayn litsenziya bilan ishlaydi; litsenziyasiz ilova bloklanadi
va orqada tushadigan zaxira yo'l yo'q.

Chiqarilgan ilovalarga tegmaydi — ular o'z SDK versiyasi bilan ishlashda
davom etadi. O'zgarish 2.0.0 ga yangilanganda kuchga kiradi.

### Migratsiya

1. `info@yt.uz` ga release APK imzo sertifikatining SHA-256 ini yuboring:
   `apksigner verify --print-certs app-release.apk | grep -i "SHA-256"`
2. Kelgan faylni `app/src/main/assets/eimzo-license.txt` ga qo'ying
   (yoki matnini `EImzoConfig(license = "EIMZO1.…")` orqali bering).
3. `implementation 'uz.eimzo:eimzo-sdk:2.0.0'`

Debug build'lar uchun alohida litsenziya kerak — debug keystore boshqa
sertifikat bilan imzolaydi. Debug hash'ini ham yuboring.

### R8 / ProGuard

AAR ichidagi consumer qoidalariga BouncyCastle qo'shildi. Litsenziya Ed25519
bilan imzolangan va uni tekshiruvchi shu kutubxonada — R8 uni olib tashlasa,
har bir litsenziya tekshiruvdan o'tmaydi va ilova bloklanadi.

### Boshqa

- Yangi dizayn tizimi: qorong'i rejim, uz/ru/en, Montserrat, tanlanadigan
  oboylar, qayta ishlangan 11 ta ekran.
- USB-token endi kalit sifatida saqlanadi (ilgari faqat imzolash uchun edi).
- `uses-feature android:required="false"` — usiz Google Play ilovani USB
  host'i yo'q qurilmalardan filtrlardi.
- Sozlamalardagi versiya endi SDK'niki (ilgari host ilovaning versiyasini
  ko'rsatardi).
- "Ruxsat so'rash" dialogi olib tashlandi — o'rniga `info@yt.uz`.

## 1.2.10 — 2026-06-29

🐛 **Kalit qo'shishda krash tuzatildi** (`Parameter specified as non-null
is null: …RoomSQLiteQuery`).

- Server `pki.cert_info` javobida `serial_number` (yoki boshqa
  maydonlar) bo'lmasa, Gson `Unsafe` orqali obyekt yaratgani uchun
  non-null Kotlin maydonlari `null` bo'lib qolar va bu `null` Room'ga
  yetib borib ilovani yiqitardi. Ko'pincha yaroqsiz yoki ro'yxatdan
  o'tmagan (masalan, test) kalitda yuz berardi.
- Endi `EImzoApiClient.certInfo()` javobni bir joyda tekshiradi:
  `serial_number` bo'lmasa krash o'rniga tushunarli xato ko'rsatiladi,
  qolgan maydonlar esa coalesce qilinib Room'ga hech qachon `null`
  tushmaydi.

## 1.2.9 — 2026-06-29

🔧 **Test muhiti URL manzili yangilandi.**

- `EImzoConfig.testApiUrl` endi `https://test.e-imzo.uz/api/rpc`
  (avval `https://m.test.e-imzo.uz/api/rpc` edi). Production URL
  (`https://m.e-imzo.uz/api/rpc`) o'zgarmagan.

## 1.2.8 — 2026-06-12

🔌 **USB token orqali imzolash tuzatildi** (FEITIAN 2.0.1.7 oqimi,
jismoniy JavaCard Token V1.0 bilan tasdiqlangan).

### Tuzatishlar

- **Birinchi urinishda "USB token topilmadi" xatosi.** FEITIAN
  2.0.1.7 kutubxonasi USB ruxsat so'ralayotganda darhol "Device Not
  Found" tashlaydi. Endi token jismonan ulangan bo'lsa bu xato
  yutiladi va ruxsat kutiladi.
- **Ruxsat berilgach jarayon osilib qolishi.** Kutubxona ruxsatdan
  keyin `USB_IN` xabarini yubormaydi — endi ruxsat broadcast'i
  ko'ringach `readerFind()` avtomatik qayta chaqiriladi.
- **Reader noto'g'ri adreslanardi.** 2.0.1.7 slot chaqiruvlari
  Android `UsbDevice` nomini (`/dev/bus/usb/...`) kutadi —
  `readerOpen(null)` o'rniga endi device nomi uzatiladi.
- **Tokenlarda karta hech aniqlanmasdi.** FT JavaCard tokenlarда
  interrupt endpoint yo'q, shuning uchun kutubxonaning karta-poller'i
  `CARD_IN` yubora olmaydi. Endi reader ochilgach slot holati
  to'g'ridan-to'g'ri so'raladi va karta bor bo'lsa imzolash darhol
  boshlanadi.
- Sessiya yakunida slot endi kanal yopilishidan **oldin**
  o'chiriladi (soxta "no device connected" cleanup xatosi yo'q).

## 1.2.7 — 2026-06-12

📐 **16 KB page size muvofiqligi (Android 15+).**

Android 15+ va 16 KB xotira sahifali qurilmalar native `.so`
kutubxonalarning ELF LOAD segmentlari 16 KB ga tekislanishini
talab qiladi. Aks holda qurilma ogohlantiradi va haqiqiy 16 KB
rejimda `dlopen` ishlamaydi. Google Play SDK 35 ni target qiluvchi
yuklamalar uchun 2025-yil 1-noyabrdan majburiy.

### Tuzatishlar

- **`libgojni.so` (pfx2qr) 16 KB ga tekislandi.** Go manbasidan
  `-Wl,-z,max-page-size=16384` bilan qayta build qilindi. ELF LOAD
  segmentlari endi `2**14` (16 KB).
- **FEITIAN kutubxonasi `1.0.9.6 → 2.0.1.7` ga yangilandi.** Eski
  `libFTReaderPCSC_1.0.9.6.so` 4 KB tekislangan edi va manba bizda
  yo'q. FEITIAN'ning rasmiy SDK 2.0.1.7 versiyasi 16 KB tekislangan
  `.so` bilan keladi (4 ABI). API o'zgarishi: `readerXfr`,
  `readerClose`, `readerPowerOn/Off` endi reader nomini (String)
  qabul qiladi — `UsbTokenManager` / `FtCardChannel` shunga
  moslashtirildi.

Endi ikkala bundlangan native lib ham **16 KB** ELF.

### ⚠️ Integratorlar uchun muhim

SDK 16 KB tekislangan `.so` beradi (avtomatik), lekin **yakuniy
APK ZIP alignment** sizning ilovangiz AGP versiyasiga bog'liq:

| AGP | Native lib zipalign |
|---|---|
| < 8.5.1 | 4 KB ❌ |
| **≥ 8.5.1** | 16 KB ✅ avtomatik |

To'liq 16 KB muvofiqlik uchun **AGP 8.5.1+** ishlating.

### Migratsiya

```gradle
implementation 'uz.eimzo:eimzo-sdk:1.2.7'
```

> USB token imzolash FEITIAN 2.0.1.7 API'ga o'tdi — jismoniy token
> bilan test qilish tavsiya etiladi.

---

## 1.2.6 — 2026-06-11

🔒 **Muddati tugagan sertifikat bilan imzolash bloklandi.**

### Yangiliklar

- **Muddati o'tgan kalit bilan imzolab bo'lmaydi.** Sertifikatning
  `validTo` sanasi o'tgan bo'lsa:
  - Kalit kartochkasida qizil **"Muddati tugagan"** badge chiqadi.
  - Home ekranida **IMZOLASH** tugmasi o'chiriladi (alpha 0.4) va
    kartochka biroz xira ko'rinadi (alpha 0.75) — foydalanuvchiga
    kalit ishlamasligi darhol bildiriladi.
  - "Mening kalitlarim" ro'yxatida ham har bir muddati o'tgan
    kartochka badge bilan belgilanadi va xira ko'rinadi (alpha 0.7),
    lekin tanlash / o'chirish uchun bosish mumkin.
  - Defence-in-depth: agar tugma holati biror sabab bilan o'tib
    ketsa ham, bosilganda "Bu kalit muddati tugagan — imzolab
    bo'lmaydi" toast chiqadi va imzolash boshlanmaydi.
- **`PfxKey.isExpired()` public helper.** `validTo` timestamp'ini
  joriy vaqt bilan solishtiradi (Soliq `yyyy.MM.dd HH:mm:ss` va NFC
  `yyyy.MM.dd` formatlari qo'llab-quvvatlanadi). Parse qilib bo'lmasa
  import paytidagi `validNow` ga fallback qiladi.

### Migratsiya

`1.2.5` dan o'tish uchun **kod o'zgartirish kerak emas**:

```gradle
implementation 'uz.eimzo:eimzo-sdk:1.2.6'
```

---

## 1.2.5 — 2026-06-10

🐛 **PFX import hot-fix №2: R8 minifying consumer apps still crashed even with 1.2.4.**

### Tuzatish

1.2.4 versiyada `libgojni.so` va `pfx2qr.jar` AAR ichiga bundle qilingan
edi, lekin `R8 minification` yoqilgan integrator app'lar (`uz.soliq.edo.mobile`
kabi) hali ham PFX qo'shganda crash qilardi:

```
F/go/Seq : failed to find method Seq.getRef
F/libc   : Fatal signal 6 (SIGABRT) in Java_go_Seq_init
```

**Sabab:** `libgojni.so` JNI orqali Java tomondagi `go.Seq.getRef`,
`go.Seq.incRef` kabi metodlarni nom orqali topadi. Integrator
app'ning R8 minification'i Kotlin/Java koddan hech kim ularni
chaqirmasligini ko'rib, ularni rename/strip qilar edi — keyin
native kod ularni topa olmasdi va class loader `<clinit>` paytida
abort qilardi.

**Yechim:** SDK ning `consumer-rules.pro` ga `go.**` paketini
butunlay saqlash qoidalari qo'shildi:

```proguard
-keep class go.** { *; }
-keepclassmembers class go.** { *; }
-dontwarn go.**
```

Bu qoidalar AAR ichida ship qilinadi va consumer app R8 ga
avtomatik ravishda qo'shiladi — qo'shimcha sozlash kerak emas.

### Migratsiya

`1.2.4` dan o'tish uchun **kod o'zgartirish kerak emas**:

```gradle
implementation 'uz.eimzo:eimzo-sdk:1.2.5'
```

---

## 1.2.4 — 2026-06-10

🐛 **Muhim tuzatish: PFX fayldan import ommaviy Maven foydalanuvchilarida ishlamayotgan edi.**

### Tuzatishlar

- 🚨 **PFX import crash.** `1.0.0`–`1.2.3` versiyalarda ommaviy
  Maven repodan SDK o'rnatgan integratorlar fayl orqali kalit
  qo'shganda quyidagi crash bilan to'qnashardi:
  ```
  java.lang.UnsatisfiedLinkError: dlopen failed:
    library "libgojni.so" not found
  ```
  Sabab: SDK `uz.yt:pfx2qr:1.0` ga bog'liq edi, lekin u kutubxona
  faqat YT ichki Nexus repositorysida joylashgan — ommaviy Maven
  consumer'larida hech qachon resolve qila olmasdi. PFX faylni o'qish
  uchun zarur bo'lgan `libgojni.so` (4.5 MB native lib) va `pfx2qr.jar`
  (Java wrapper) endi to'g'ridan-to'g'ri AAR ichiga bundled qilingan
  — barcha 4 ABI (arm64-v8a, armeabi-v7a, x86, x86_64) uchun.

### Hajm

- AAR endi **~11 MB** (avval ~989 KB). O'sish to'liq `libgojni.so` × 4
  ABI = ~18 MB native code bundlanganidan. R8 hech qanday native
  kodni olib tashlay olmaydi.

### Migratsiya

`1.2.3` dan o'tish uchun **kod o'zgartirish kerak emas**. Faqat
versiya raqamini yangilang:

```gradle
implementation 'uz.eimzo:eimzo-sdk:1.2.4'
```

---

## 1.2.3 — 2026-06-09

🎨 **UX yaxshilanishlar va NFC imzolashda muhim bug-fix.**

### Yangiliklar

- **Sessiya taymeri deeplink uchun (103 sekund).** Tashqi
  `eimzo://sign?qc=...` deeplink kelganida endi sarlavhada toza,
  qisqa taymer ko'rsatiladi (`Sessiya: 1:43 qoldi`). Foydalanuvchi
  kerak bo'lsa kalit qo'shishi va keyin imzolashi mumkin —
  deeplink ushlab turiladi. QR hash matni endi ekranga
  chiqarilmaydi (ortiqcha, foydalanuvchiga ma'nosiz edi).
- **Orqaga qaytish tugmasi.** AppBar'ga back tugmasi qo'shildi:
  Home ekranida deeplink orqali ochilganda integrator ilovasiga
  qaytish, AddKey va Keys ekranlarida toolbar-back navigatsiyasi.
- **NFC imzolashda bottom sheet.** Endi NFC kalit bilan
  imzolashda ham xuddi kalit qo'shishda bo'lganidek 3 ta Lottie
  animatsiyasi (kartani yaqinlashtiring → o'qilmoqda → bajarildi)
  ko'rsatiladi. Avval faqat oddiy Toast bor edi.

### Tuzatishlar

- 🐛 **NFC tag tashlanmasdi.** `dispatchNfcTag` resumed
  fragment'larni qidirgan, lekin OS NFC intent'ini yuborganda
  Activity qisqa vaqtga pause→resume tsikliga kiradi va o'sha
  paytda hech bir fragment "resumed" emas — natijada tag jim
  tashlanardi. Endi `NavController.primaryNavigationFragment`
  ishlatiladi.
- 🐛 **Imzolashda crash.** `HomeFragment.disableNfcForeground`
  Activity hali resumed bo'lmaganida chaqirilib
  `IllegalStateException: You must disable foreground dispatching
  while your activity is still resumed` xatosi bilan crash
  qilardi. Endi try-catch ichida.
- 🐛 **Sessiya tugaganda app yopilib qolardi.** 103 sekundlik
  taymer NFC kalit qo'shish vaqtidan tezroq tugar edi va keyin
  app majburan yopilib ketardi — foydalanuvchi imzolay olmasdi.
  Endi taymer faqat informatsion: tugaganida "Sessiya tugadi"
  toast chiqadi, lekin deeplink saqlanib qoladi va foydalanuvchi
  imzolashga harakat qilishi mumkin.

### Migratsiya

`1.2.2` dan o'tish uchun **kod o'zgartirish kerak emas**. Faqat
versiya raqamini yangilang:

```gradle
implementation 'uz.eimzo:eimzo-sdk:1.2.3'
```

---

## 1.2.2 — 2026-06-06

🔌 **USB token avtomatik aniqlash + ommaviy API tozalandi.**

### Yangiliklar

- **USB token avtomatik aniqlash.** "USB Token orqali imzolash" tugmasi
  endi faqat FEITIAN / CCID smart-card reader telefonga ulanganda
  faollashadi. SDK `USB_DEVICE_ATTACHED` / `DETACHED` broadcastlarini
  real vaqtda kuzatadi (yangi `UsbTokenDetector` klassi) va tugmani
  yoqadi / o'chiradi. Ulanmagan paytda matn "USB tokenni ulang" ga
  o'zgaradi.

### Tuzatishlar

- **USB ulanganda ilova endi avtomatik ochilmaydi.** Avvalgi
  versiyalarning birida `USB_DEVICE_ATTACHED` intent-filter
  qo'shilgan edi — natijada foydalanuvchi tokenni boshqa maqsadda
  ulasa ham OS native UI'ni majburan ochib yuborardi. Intent-filter
  olib tashlandi; aniqlash hali ham ishlaydi — faqat foydalanuvchi
  native UI ichida bo'lganida.

### Ichki o'zgarishlar

- **Ommaviy API tozalandi.** Barcha ichki implementatsiya klasslari
  (`UsbTokenManager`, `NfcManager`, `EImzoApiClient`, Room
  `KeyDao`/`KeyDatabase`/`KeyEntity`, `LicenseGuard`,
  `QrCryptoManager`, `PkiUtils`, `HexUtils`, ViewModel'lar,
  adapterlar va boshqalar) Kotlin `internal` deb belgilandi. Endi
  AAR consumer'larida IDE autocomplete faqat haqiqatan zarur
  APIlarni ko'rsatadi: `EImzoSDK`, `EImzoConfig`, callback
  interfeyslar va model klasslar.
- **Past darajali `signUsbHash` primitivi yashirildi.** USB token
  imzolash uchun yagona ommaviy API endi
  `signWithUsbToken(pin, deepLink, callback)`.
- Manifest'da `USB_DEVICE_ATTACHED` intent-filter va
  `res/xml/eimzo_usb_device_filter.xml` olib tashlandi.

### Migratsiya

`1.0.2` dan o'tish uchun **kod o'zgartirish kerak emas** — `EImzoSDK`
fasadi va public callback'lar saqlangan. Faqat versiya raqamini
yangilang:

```gradle
implementation 'uz.eimzo:eimzo-sdk:1.2.2'
```

---

## 1.0.2 — 2026-06-04

🔐 **Security hardening.**

- **Saved passwords encrypted in Room.** `PasswordCipher.kt` uses
  AndroidKeyStore-bound AES-256-GCM to wrap the saved-password column.
  Rooted-device SQLite reads and `adb backup` extracts yield ciphertext
  only — the symmetric key is bound to the application UID via
  AndroidKeyStore and cannot be exfiltrated.
- **Backup exclusion.** New `res/xml/eimzo_backup_rules.xml` +
  `eimzo_data_extraction_rules.xml` exclude `eimzo_keys.db` and the
  SDK's encrypted SharedPreferences from `auto-backup`, Google Drive
  cloud backup, and Android 12+ device-transfer. Consumer-app data is
  unaffected — only the SDK's storage paths are filtered.
- Manifest declares `android:fullBackupContent` +
  `android:dataExtractionRules` with `tools:replace` so the exclusion
  applies even if the host app sets `android:allowBackup="true"` for
  its own data.

# Changelog

E-IMZO Mobile SDK uchun barcha muhim o'zgartirishlar shu yerda yoziladi.
Format [Keep a Changelog](https://keepachangelog.com/) standartiga mos.

## [1.0.1] - 2026-06-03

### Tuzatishlar

- 🐛 **Asosiy bug:** PFX/QR kalit import qilishda `JsonIOException: Abstract classes can't be instantiated! Class name: uz.eimzo.sdk.network.JsonRpcResponse` xatosi tuzatildi. R8 minifikatsiya tarmoq DTO klasslarining no-arg konstruktorlarini olib tashlagan edi va Gson reflektsiya orqali javobni deserializatsiya qila olmadi. ProGuard qoidalariga `uz.eimzo.sdk.network.*` paketidagi barcha DTO klasslari uchun aniq `-keep` qoidalari qo'shildi:
  - `JsonRpcRequest`, `JsonRpcResponse`
  - `CertInfoParams`, `CertInfoResult`
  - `SiteInfoParams`, `SiteInfoResult`
  - `SendPkcs7Params`, `Pkcs7Result`
- 🔧 Diagnostik logging kuchaytirildi: kalit import va tarmoq qatlamida exception klassi va to'liq stack trace log xabariga to'g'ridan-to'g'ri yoziladi (R8 olib tashlamasligi uchun).

### Texnik tafsilotlar

- **AAR hajmi:** 994 KB (oldingi 971 KB — qo'shilgan keep qoidalari tufayli)
- **Public API:** o'zgarishsiz qoldi
- **Migratsiya:** version raqamini `1.0.0` → `1.0.1` ga o'zgartirish kifoya

---

## [1.0.0] - 2026-06-03

### Birinchi rasmiy reliz

**Asosiy funksiyalar:**
- ✨ PFX (.pfx) fayldan kalit import qilish
- ✨ QR kod orqali kalit import (kamera)
- ✨ NFC ID-karta orqali kalit import
- ✨ OzDST 1092 elektron imzo (milliy standart)
- ✨ OzDST 1106 hash funksiyasi (GOST 34.311 oilasi)
- ✨ Deeplink qo'llab-quvvatlash (`eimzo://sign?qc=...`)
- ✨ Sertifikat validatsiyasi (Soliq serveri orqali)
- ✨ USB Token bilan imzolash (FT-1280)
- ✨ Parolni saqlash (ixtiyoriy)

**UI komponentlari:**
- ✨ NfcWaitBottomSheet (Lottie animatsiyali NFC kutish)
- ✨ LoadingOverlay (spinner + logo)
- ✨ BlockedAppActivity (license blocked ekran)
- ✨ Sakura background, gradient kartochkalar

**Xavfsizlik:**
- 🔐 R8 obfuscation + 5x optimization passes
- 🔐 String encryption (Firebase API key XOR-encoded)
- 🔐 Anti-tamper (Frida/Xposed/root manager detection)
- 🔐 License guard (Firebase Firestore orqali)
- 🔐 In-app access request (pending_integrators)

**Tasdiqlangan komponentlar:**
- ✅ OzDST 1106 hash — standart test vektorlari bilan
- ✅ EC scalar multiplication (Q=G\*d) — standart test vektor
- ✅ EC signature (r, s) — standart test vektor
- ✅ End-to-end imzolash — server `send.success` qaytaradi

### Texnik tafsilotlar

- **MinSdk:** 24 (Android 7.0)
- **TargetSdk:** 34 (Android 14)
- **Kotlin:** 1.9.0
- **Compose:** native View tizimi (Compose qo'llanmagan)
- **Hajmi:** 681 KB (himoyalangan AAR)
- **NDK:** 21.1.6352462

---

## [Unreleased]

### Rejalashtirilgan

- 🚧 iOS qo'llab-quvvatlash (alohida framework)
- 🚧 Flutter plugin (eimzo_flutter)
- 🚧 EncryptedSharedPreferences (parol shifrlangan saqlash)
- 🚧 Native code (NDK) — license check
- 🚧 Certificate pinning (Soliq serveriga TLS pin)

---

[1.2.7]: https://github.com/peachdev-uz/eimzo-mobile-sdk/releases/tag/v1.2.7
[1.2.6]: https://github.com/peachdev-uz/eimzo-mobile-sdk/releases/tag/v1.2.6
[1.2.5]: https://github.com/peachdev-uz/eimzo-mobile-sdk/releases/tag/v1.2.5
[1.2.4]: https://github.com/peachdev-uz/eimzo-mobile-sdk/releases/tag/v1.2.4
[1.2.3]: https://github.com/peachdev-uz/eimzo-mobile-sdk/releases/tag/v1.2.3
[1.2.2]: https://github.com/peachdev-uz/eimzo-mobile-sdk/releases/tag/v1.2.2
[1.0.1]: https://github.com/peachdev-uz/eimzo-mobile-sdk/releases/tag/v1.0.1
[1.0.0]: https://github.com/peachdev-uz/eimzo-mobile-sdk/releases/tag/v1.0.0
