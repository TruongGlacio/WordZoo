import 'package:flutter/foundation.dart';

class AdConfig {
  AdConfig._();

  /// Có thể override bằng:
  ///
  /// flutter run --dart-define=USE_TEST_ADS=true
  ///
  /// hoặc:
  ///
  /// flutter build appbundle --dart-define=USE_TEST_ADS=false
  static const bool useTestAds = bool.fromEnvironment(
    'USE_TEST_ADS',
    defaultValue: !kReleaseMode,
  );

  /// Tắt toàn bộ quảng cáo.
  ///
  /// Có thể dùng cho Premium/IAP.
  static bool adsEnabled = true;

  /// Debug log.
  static const bool enableLogs = true;

  /// Interstitial tối thiểu giữa 2 lần show.
  static const Duration interstitialCooldown = Duration(minutes: 2);

  /// App Open tối thiểu giữa 2 lần show.
  static const Duration appOpenCooldown = Duration(minutes: 10);

  /// App Open Ad hết hạn sau 4 giờ.
  static const Duration appOpenAdMaxAge = Duration(hours: 4);
}