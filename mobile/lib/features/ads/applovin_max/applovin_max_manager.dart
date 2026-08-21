import 'dart:math';
import 'dart:ui';

import 'package:applovin_max/applovin_max.dart';

import 'applovin_max_app_open_ad_manager.dart';
import 'applovin_max_banner_ad_manager.dart';
import 'applovin_max_config.dart';
import 'applovin_max_interstitial_ad_manager.dart';
import 'applovin_max_rewarded_ad_manager.dart';

class AppLovinMaxManager {
  static final AppLovinMaxManager _singletonAdsManager =
      AppLovinMaxManager._internal();
  static AppLovinMaxManager get getInstance => _singletonAdsManager;
  factory AppLovinMaxManager() {
    return _singletonAdsManager;
  }
  AppLovinMaxManager._internal();

  final AppLovinMaxAppOpenAdManager appOpen = AppLovinMaxAppOpenAdManager();
  final AppLovinMaxBannerAdManager banner = AppLovinMaxBannerAdManager();
  final AppLovinMaxInterstitialAdManager interstitial =
      AppLovinMaxInterstitialAdManager();
  final AppLovinMaxRewardedAdManager rewarded = AppLovinMaxRewardedAdManager();

  void initialize() {
    appOpen.initialize();
    banner.initialize();
    interstitial.initialize();
    rewarded.initialize();
  }

  Future<void> showRewardAds({
    required void Function(
        MaxAd ad, MaxReward reward)? onRewardEarned,
    VoidCallback? onAdDismissed,
    void Function(MaxError error)? onAdFailedToShow,
  }) async {
    rewarded.show(
      onAdDismissed: (ad) {
        if (AppLovinMaxConfig.enableLogs) {
          print('[AppLovinMax] onAdDismissed called');
        }
        onAdDismissed?.call();
      },
      onAdFailedToShow:(error) {
        if (AppLovinMaxConfig.enableLogs) {
          print('[AppLovinMax] onAdFailedToShow called:');
        }
        onAdFailedToShow?.call(error);
      },
    );
  }

  void showAppOpenAds({
    VoidCallback? onAdDismissedFullScreenContent,
    VoidCallback? onAdShowedFullScreenContent,
  }) {
    appOpen.showAdIfAvailable(
      onAdDismissedFullScreenContent: () {
        if (AppLovinMaxConfig.enableLogs) {
          print('[AppLovinMax] onAdDismissedFullScreenContent called');
        }
        onAdDismissedFullScreenContent?.call();
      },
      onAdShowedFullScreenContent: () {
        if (AppLovinMaxConfig.enableLogs) {
          print('[AppLovinMax] onAdShowedFullScreenContent called');
        }
        onAdShowedFullScreenContent?.call();
      },
    );
  }

  void dispose() {
    banner.dispose();
    interstitial.dispose();
    rewarded.dispose();
  }
}