<<<<<<< HEAD
# League-Predictor
League Predictor
=======
# Football Prediction Pro

This package reconstructs the 77 Dart source files supplied in `football_prediction_complete_code.txt`, plus small build-readiness additions for missing router targets and manual dependency injection.

## Prerequisites

- Flutter stable (Dart 3+)
- A Firebase project
- A Football-Data.org API token

## Setup

1. Run `flutter create .` in this directory to generate the platform folders.
2. Run `flutter pub get`.
3. Install/configure FlutterFire for your Firebase project: `flutterfire configure`.
4. Enable Email/Password (and optionally Google/Apple) authentication in Firebase.
5. Create the Firestore collections used by the app.
6. Run with your API token without committing it:

```bash
flutter run --dart-define=FOOTBALL_API_KEY=YOUR_TOKEN
```

The supplied source used a placeholder API key; this build changes it to a `--dart-define` value so a real secret is not hard-coded.

## Important

The original specification contains demo/mock AI analysis and placeholder Firebase/API configuration. This archive preserves that behavior unless explicitly noted above; it does not include your private Firebase project configuration or API credentials.

## Build APK

After Firebase/platform configuration:

```bash
flutter build apk --release --dart-define=FOOTBALL_API_KEY=YOUR_TOKEN
```

The Flutter SDK was not available in the build environment used to assemble this archive, so platform-generated Android/iOS folders and a compiled APK are not embedded here.
>>>>>>> 4ea530d (Initial commit)
