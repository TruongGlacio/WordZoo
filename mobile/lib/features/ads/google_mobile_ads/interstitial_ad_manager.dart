import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'google_mobile_ads_unit_id_manager.dart';

class InterstitialAdManager {
  static final InterstitialAdManager _singletonInterstitialAdManager = InterstitialAdManager._internal();
  static InterstitialAdManager get getInstance => _singletonInterstitialAdManager;
  factory InterstitialAdManager() {
    return _singletonInterstitialAdManager;
  }
  InterstitialAdManager._internal();
  InterstitialAd? _interstitialAd;

  bool _isLoading = false;
  bool _isShowing = false;

  String get _adUnitId {
      return GoogleMobileAdsUnitIdManager().interstitial;
  }

  bool get isAvailable => _interstitialAd != null;

  void loadAd() {
    if (_isLoading || _interstitialAd != null) {
      return;
    }

    _isLoading = true;

    InterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _isLoading = false;
          _interstitialAd = ad;

          debugPrint('Interstitial loaded');

          _setCallbacks(ad);
        },
        onAdFailedToLoad: (error) {
          _isLoading = false;
          _interstitialAd = null;

          debugPrint('Interstitial failed: $error');
        },
      ),
    );
  }

  void _setCallbacks(InterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowing = true;
      },

      onAdDismissedFullScreenContent: (ad) {
        _isShowing = false;

        ad.dispose();
        _interstitialAd = null;

        // Preload quảng cáo tiếp theo
        loadAd();
      },

      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowing = false;

        ad.dispose();
        _interstitialAd = null;

        loadAd();
      },
    );
  }

  void show() {
    if (_isShowing) {
      return;
    }

    final ad = _interstitialAd;

    if (ad == null) {
      // Chưa có quảng cáo thì preload
      loadAd();
      return;
    }

    _interstitialAd = null;

    ad.show();
  }

  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }
}