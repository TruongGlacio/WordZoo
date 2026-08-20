import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wordzoo/base/store/cache_storage.dart';

import 'app_open_ad_manager.dart';
import 'banner_ad_manager.dart';
import 'interstitial_ad_manager.dart';
import 'rewarded_ad_manager.dart';

class AdsManager {
  static final AdsManager _singletonAdsManager = AdsManager._internal();
  static AdsManager get getInstance => _singletonAdsManager;
  factory AdsManager() {
    return _singletonAdsManager;
  }
  AdsManager._internal();

  final AppOpenAdManager appOpen = AppOpenAdManager();
  final BannerAdManager banner = BannerAdManager();
  final InterstitialAdManager interstitial = InterstitialAdManager();
  final RewardedAdManager rewarded = RewardedAdManager();

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    appOpen.loadAd();
    banner.loadAd();
    interstitial.loadAd();
    rewarded.loadAd();

  }

  Future<void>showRewardAds({
    required void Function(AdWithoutView ad, RewardItem reward, )? onRewardEarned,
    void Function()? onAdDismissed,
    void Function(AdError error)? onAdFailedToShow})async {
    rewarded.show(
      onRewardEarned: (ad, reward) {
        print("object");
        onRewardEarned?.call(ad, reward);
      },
      onAdDismissed: () {
        print("object");
        onAdDismissed?.call();

      },
      onAdFailedToShow: (error) {
        print("object");
        onAdFailedToShow?.call(error);

      },
    );
  }

  Future<void>showAppOpenAds({void Function(AppOpenAd)? onAdDismissedFullScreenContent, void Function(AppOpenAd)? onAdShowedFullScreenContent})async {
    appOpen.showAdIfAvailable(
      onAdDismissedFullScreenContent: (p0) {
        print("object");
        onAdDismissedFullScreenContent?.call(p0);
      },
      onAdShowedFullScreenContent: (p0) {
        print("object");
        onAdShowedFullScreenContent?.call(p0);

      },
    );
  }
  void dispose() {
    banner.dispose();
    interstitial.dispose();
    rewarded.dispose();
  }
}