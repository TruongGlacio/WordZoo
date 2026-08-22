import 'dart:io';

import 'google_mobile_ads_config.dart';

class GoogleMobileAdsUnitIdManager {
  static final GoogleMobileAdsUnitIdManager _singletonUnitIdManager = GoogleMobileAdsUnitIdManager._internal();

  static GoogleMobileAdsUnitIdManager get getInstance => _singletonUnitIdManager;

  factory GoogleMobileAdsUnitIdManager() {
    return _singletonUnitIdManager;
  }
  GoogleMobileAdsUnitIdManager._internal();


  /// test unit ads

  final String bannerAndroidTest = 'ca-app-pub-3940256099942544/6300978111';
  final String bannerOpenIOSTest = 'ca-app-pub-3940256099942544/2934735716';
  final String appOpenAndroidTest = 'ca-app-pub-3940256099942544/9257395921';
  final String appOpenIOSTest = 'ca-app-pub-3940256099942544/5575463023';

  final String interstitialAndroidTest = 'ca-app-pub-3940256099942544/1033173712';
  final String interstitialOpenIOSTest = 'ca-app-pub-3940256099942544/4411468910';

  final String rewardedAndroidTest = 'ca-app-pub-3940256099942544/5224354917';
  final String rewardedIOSTest = 'ca-app-pub-3940256099942544/1712485313';


  /// product unit ads
  final String androidProductionBanner = 'ca-app-pub-4928233575981265/2195262927';
  final String iosProductionBanner = 'ca-app-pub-4928233575981265/3777450677';

  final String androidProductionInterstitial = 'ca-app-pub-4928233575981265/4028732117';
  final String iosProductionInterstitial = 'ca-app-pub-4928233575981265/8808772736';

  final String androidProductionAppOpen ='ca-app-pub-4928233575981265/5444242796' ;
  final String iosProductionAppOpen = 'ca-app-pub-4928233575981265/5859175768';

  final String androidProductionRewarded = 'ca-app-pub-4928233575981265/7528264476';
  final String iOSProductionRewarded = 'ca-app-pub-4928233575981265/1402568771';

   String get banner {
    if (GoogleMobileAdsConfig.useTestAds) {
      return Platform.isAndroid ? bannerAndroidTest : bannerOpenIOSTest;
    }
    return Platform.isAndroid ? androidProductionBanner : iosProductionBanner;
  }

   String get interstitial {
    if (GoogleMobileAdsConfig.useTestAds) {
      return Platform.isAndroid ? interstitialAndroidTest : interstitialOpenIOSTest;
    }

    return Platform.isAndroid ? androidProductionInterstitial : iosProductionInterstitial;
  }

   String get appOpen {
    if (GoogleMobileAdsConfig.useTestAds) {
      return Platform.isAndroid ? appOpenAndroidTest : appOpenIOSTest;
    }
    return Platform.isAndroid ? androidProductionAppOpen : iosProductionAppOpen;
  }
  String get rewarded {
    if (GoogleMobileAdsConfig.useTestAds) {
      return Platform.isAndroid ? rewardedAndroidTest : rewardedIOSTest;
    }

    return Platform.isAndroid ? androidProductionRewarded : iOSProductionRewarded;
  }
}