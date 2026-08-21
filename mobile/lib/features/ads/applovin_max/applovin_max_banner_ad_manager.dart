import 'dart:io';
import 'package:flutter/material.dart';
import 'package:applovin_max/applovin_max.dart';
import 'applovin_max_config.dart';
import 'applovin_max_unit_id_manager.dart';

class AppLovinMaxBannerAdManager {
  static final AppLovinMaxBannerAdManager _singletonBannerAdManager =
      AppLovinMaxBannerAdManager._internal();
  static AppLovinMaxBannerAdManager get getInstance =>
      _singletonBannerAdManager;
  factory AppLovinMaxBannerAdManager() => _singletonBannerAdManager;
  AppLovinMaxBannerAdManager._internal();

  bool _isLoaded = false;

  String get _adUnitId => AppLovinMaxUnitIdManager().banner;

  bool get isLoaded => _isLoaded;

  void initialize() {
    // SDK is initialized automatically by the plugin when first method is called
    loadAd();
  }

  void loadAd() {
    if (_isLoaded) return;

    AppLovinMAX.setBannerListener(AdViewAdListener(
      onAdLoadedCallback: (ad) {
        _isLoaded = true;
        if (AppLovinMaxConfig.enableLogs) {
          print('[AppLovinMax] Banner loaded');
        }
      },
      onAdLoadFailedCallback: (adUnitId, error) {
        _isLoaded = false;
        if (AppLovinMaxConfig.enableLogs) {
          print('[AppLovinMax] Banner failed: $error');
        }
      },
      onAdClickedCallback: (ad) {
        if (AppLovinMaxConfig.enableLogs) {
          print('[AppLovinMax] Banner clicked');
        }
      },
      onAdExpandedCallback: (ad) {
        if (AppLovinMaxConfig.enableLogs) {
          print('[AppLovinMax] Banner expanded');
        }
      },
      onAdCollapsedCallback: (ad) {
        if (AppLovinMaxConfig.enableLogs) {
          print('[AppLovinMax] Banner collapsed');
        }
      },
      onAdRevenuePaidCallback: (ad) {
        if (AppLovinMaxConfig.enableLogs) {
          print('[AppLovinMax] Banner revenue: \$${ad.revenue}');
        }
      },
    ));

    AppLovinMAX.loadBanner(_adUnitId);
  }

  Widget get widget {
    if (!_isLoaded) return Container();

    return MaxAdView(
      adUnitId: _adUnitId,
      adFormat: AdFormat.banner,
      placement: 'Banner',
      isAutoRefreshEnabled: true,
      isAdaptiveBannerEnabled: true,
    );
  }

  void dispose() {
    _isLoaded = false;
    AppLovinMAX.destroyBanner(_adUnitId);
  }
}