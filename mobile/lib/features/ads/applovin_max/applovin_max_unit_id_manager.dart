import 'dart:io';

import 'applovin_max_config.dart';

class AppLovinMaxUnitIdManager {
  static final AppLovinMaxUnitIdManager _singletonUnitIdManager =
      AppLovinMaxUnitIdManager._internal();

  static AppLovinMaxUnitIdManager get getInstance => _singletonUnitIdManager;

  factory AppLovinMaxUnitIdManager() {
    return _singletonUnitIdManager;
  }
  AppLovinMaxUnitIdManager._internal();

  /// Test Unit IDs (sử dụng AppLovin test key)
  final String bannerTest = 'R-P-72924134261';
  final String interstitialTest = 'R-P-72924134263';
  final String rewardedTest = 'R-P-72924134265';
  final String appOpenTest = 'R-P-72924134267';

  /// Production Unit IDs (sử dụng key từ dashboard AppLovin MAX)
  final String bannerProduction = 'YOUR_BANNER_AD_UNIT_ID';
  final String interstitialProduction = 'YOUR_INTERSTITIAL_AD_UNIT_ID';
  final String rewardedProduction = 'YOUR_REWARDED_AD_UNIT_ID';
  final String appOpenProduction = 'YOUR_APP_OPEN_AD_UNIT_ID';

  String get banner {
    if (AppLovinMaxConfig.useTestAds) {
      return bannerTest;
    }
    return bannerProduction;
  }

  String get interstitial {
    if (AppLovinMaxConfig.useTestAds) {
      return interstitialTest;
    }
    return interstitialProduction;
  }

  String get appOpen {
    if (AppLovinMaxConfig.useTestAds) {
      return appOpenTest;
    }
    return appOpenProduction;
  }

  String get rewarded {
    if (AppLovinMaxConfig.useTestAds) {
      return rewardedTest;
    }
    return rewardedProduction;
  }
}