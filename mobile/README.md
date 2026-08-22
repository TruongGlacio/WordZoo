# wordzoo

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


build intro: 
- intl_utils:
  - flutter pub run intl_utils:generate
  - dart run intl_utils:generate
- Run config: 
  - dart run flutter_native_splash:create
  - dart run flutter_launcher_icons:generate
- Build
  - Android
    - flutter build appbundle -t lib/main.dart --release
    - flutter build appbundle --dart-define=USE_TEST_ADS=false -t lib/main.dart --release
    - flutter build apk -t lib/main.dart --release
    - flutter build apk --dart-define=USE_TEST_ADS=false -t lib/main.dart --release
