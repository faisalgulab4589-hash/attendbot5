# AttendBot — Flutter (Android + iOS)

## پہلی بار Setup

1. Email، Password اور وقت سیٹ کریں
2. Save Settings دبائیں
3. Auto Bot toggle ON کریں

Bot ہر روز خودکار CHECK IN اور CHECK OUT کرے گا۔

## Build کرنے کا طریقہ

### Requirements
- Flutter SDK 3.10+
- Android Studio (Android کے لیے)
- Xcode 14+ (iOS کے لیے، Mac ضروری ہے)

### Android APK
```bash
flutter pub get
flutter build apk --release
```
APK ملے گی: `build/app/outputs/flutter-apk/app-release.apk`

### iOS IPA (Mac پر)
```bash
flutter pub get
flutter build ios --release
```
پھر Xcode سے Archive کریں۔

## Dependencies
- webview_flutter — in-app browser
- shared_preferences — local storage
- workmanager — background tasks
- flutter_local_notifications — alerts
- connectivity_plus — network check
- intl — date formatting
