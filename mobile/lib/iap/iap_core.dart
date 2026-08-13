/// IAP Constants - Lưu trữ tất cả constant liên quan đến IAP

class IAPConfig {
  /// App Store Product ID cho Subscription tháng
  static const String premiumMonthId = 'premium_monthly';

  /// App Store Product ID cho Subscription năm
  static const String premiumYearId = 'premium_yearly';

  /// Giá Subscription tháng (USD)
  static const double premiumMonthPrice = 4.99;

  /// Giá Subscription năm (USD)
  static const double premiumYearPrice = 49.99;

  /// Bật sandbox mode để test
  static const bool enableSandbox = true;

  /// Bật logging để debug
  static const bool enableLogging = true;

  /// Package name Android
  static const String androidPackageName = 'com.yourapp.wordzoo';

  /// App Store ID (iOS)
  static const String appStoreId = '';
}