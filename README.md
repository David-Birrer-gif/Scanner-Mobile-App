# Scanner Mobile App (Android)

Clean-architecture Flutter app for scanning groceries, tracking expiry, and local reminders.

## Implemented now
- Material 3 app shell with Home / Scan / Stats / Settings.
- Barcode scan flow (EAN-13) with `mobile_scanner`.
- Open Food Facts prefill with manual fallback.
- Local persistence schema via Drift (products table).
- Save product flow with reminder scheduling using `flutter_local_notifications`.
- OCR integration placeholder using Google ML Kit text recognizer.

## Project structure
```
lib/
 ├─ core/
 ├─ features/
 │   ├─ products/
 │   ├─ notifications/
 │   ├─ statistics/
 │   ├─ settings/
 ├─ main.dart
```

## TODO (next iterations)
- Complete ML Kit camera capture pipeline for real expiry date OCR.
- Add generated drift files (`build_runner`) and DB migrations.
- Implement background daily expiry checks (workmanager).
- Add product status actions (consumed/wasted) from UI.
- Add comprehensive localization resources and tests.
