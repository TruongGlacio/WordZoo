import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'dart:io';

import 'unit_id_manager.dart';

class AppOpenAdManager {
  static final AppOpenAdManager _singletonAppOpenAdManager = AppOpenAdManager._internal();
  static AppOpenAdManager get getInstance => _singletonAppOpenAdManager;
  factory AppOpenAdManager() {
    return _singletonAppOpenAdManager;
  }
  AppOpenAdManager._internal();
  AppOpenAd? _appOpenAd;

  bool _isShowingAd = false;

  DateTime? _loadedTime;

  String get _adUnitId {
      return UnitIdManager().appOpen;
  }

  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  Future<void> initial() async {
    await MobileAds.instance.initialize();
  }
  void loadAd() {
    AppOpenAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _loadedTime = DateTime.now();

          print('App Open Ad loaded');
        },
        onAdFailedToLoad: (error) {
          print('App Open Ad failed: $error');

          _appOpenAd = null;
          _loadedTime = null;
        },
      ),
    );
  }

  void showAdIfAvailable({void Function(AppOpenAd)? onAdShowedFullScreenContent, void Function(AppOpenAd)? onAdDismissedFullScreenContent}) {
    if (_isShowingAd) {
      return;
    }

    final ad = _appOpenAd;

    if (ad == null) {
      loadAd();
      return;
    }

    // App Open Ad chỉ nên được sử dụng
    // trong khoảng thời gian hợp lệ.
    if (_loadedTime != null &&
        DateTime.now().difference(_loadedTime!).inHours >= 4) {
      ad.dispose();

      _appOpenAd = null;
      _loadedTime = null;

      loadAd();
      return;
    }

    _isShowingAd = true;
    _appOpenAd = null;
    _loadedTime = null;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        print('App Open Ad showed');
        onAdShowedFullScreenContent?.call(ad);
      },

      onAdDismissedFullScreenContent: (ad) {
        print('App Open Ad dismissed');
        onAdDismissedFullScreenContent?.call(ad);
        _isShowingAd = false;

        ad.dispose();

        // preload quảng cáo tiếp theo
        loadAd();
      },

      onAdFailedToShowFullScreenContent: (ad, error) {
        print('App Open Ad failed to show: $error');

        _isShowingAd = false;

        ad.dispose();

        loadAd();
      },
    );

    ad.show();
  }
}