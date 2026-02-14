# Scanner Mobile App (Android)

Offline-first grocery scanner app built with Flutter, Riverpod, Drift, Open Food Facts, ML Kit OCR, and local notifications.

## Features
- EAN-13 barcode scan with Open Food Facts prefill and manual fallback.
- Add/edit products with quantity, category, expiry date picker, and OCR expiry detection.
- Local SQLite persistence (Drift-backed SQL access).
- Expiry reminder orchestration with global and per-product reminder offsets.
- Reminder reconciliation at app start and daily background run via Workmanager.
- Product state handling (active / consumed / wasted) with reminder cancel/reschedule.
- Home filters: all, expiring soon, expired, by category.
- Statistics: consumed, wasted, waste ratio, category breakdown.
- EN/DE localization-ready strings and ARB files.

## Run in Emulator
1. Install Flutter SDK and Android Studio.
2. In project root:
   ```bash
   flutter pub get
   flutter analyze
   flutter test
   flutter run -d emulator-5554
   ```
3. Alternatively start an emulator in Android Studio and run with the green Run button.

## Known limitations
- Open Food Facts coverage depends on product/barcode availability.
- OCR quality depends on camera focus, lighting, and date print style.
- Android boot-time full reschedule is approximated by app-start and daily Workmanager reconciliation.
