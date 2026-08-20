import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'google_mobile_ads_unit_id_manager.dart';

class BannerAdManager {

  static final BannerAdManager _singletonBannerAdManager = BannerAdManager._internal();
  static BannerAdManager get getInstance => _singletonBannerAdManager;
  factory BannerAdManager() {
    return _singletonBannerAdManager;
  }
  BannerAdManager._internal();
  BannerAd? _bannerAd;

  bool _isLoaded = false;

  String get _adUnitId {
      return GoogleMobileAdsUnitIdManager().banner;
  }

  bool get isLoaded => _isLoaded;

  void loadAd() {
    _bannerAd?.dispose();

    _bannerAd = BannerAd(
      adUnitId: _adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _isLoaded = true;
          debugPrint('Banner loaded');
        },
        onAdFailedToLoad: (ad, error) {
          _isLoaded = false;

          debugPrint('Banner failed: $error');

          ad.dispose();
          _bannerAd = null;
        },
      ),
    );

    _bannerAd!.load();
  }

  Widget? get widget {
    if (!_isLoaded || _bannerAd == null) {
      return null;
    }

    return SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }

  void dispose() {
    _bannerAd?.dispose();
    _bannerAd = null;
    _isLoaded = false;
  }
}

