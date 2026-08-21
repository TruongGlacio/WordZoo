import 'dart:io';
import 'package:flutter/material.dart';
import 'package:applovin_max/applovin_max.dart';
import 'applovin_max_config.dart';
import 'applovin_max_unit_id_manager.dart';

class AppLovinMaxAppOpenAdManager {
  static final AppLovinMaxAppOpenAdManager _singletonAppOpenAdManager =
      AppLovinMaxAppOpenAdManager._internal();
  static AppLovinMaxAppOpenAdManager get getInstance =>
      _singletonAppOpenAdManager;
  factory AppLovinMaxAppOpenAdManager() => _singletonAppOpenAdManager;
  AppLovinMaxAppOpenAdManager._internal();

  bool _isShowingAd = false;
  DateTime? _loadedTime;

  String get _adUnitId => AppLovinMaxUnitIdManager().appOpen;

  Future<bool> get isAdAvailable async {
    return !(_isShowingAd) && (await AppLovinMAX.isAppOpenAdReady(_adUnitId)??false);
  }

  void initialize() {
    loadAd();
  }

  void loadAd() {
    AppLovinMAX.loadAppOpenAd(_adUnitId);
  }

  Future<void> showAdIfAvailable({
    VoidCallback? onAdShowedFullScreenContent,
    VoidCallback? onAdDismissedFullScreenContent,
  }) async {
    if (_isShowingAd || ! await isAdAvailable) {
      loadAd();
      return;
    }

    // App Open Ad chỉ nên được sử dụng trong khoảng thời gian hợp lệ.
    if (_loadedTime != null &&
        DateTime.now().difference(_loadedTime!).inHours >= 4) {
      if (AppLovinMaxConfig.enableLogs) {
        print('[AppLovinMax] App Open Ad expired, reloading...');
      }

      AppLovinMAX.loadAppOpenAd(_adUnitId);
      return;
    }

    _isShowingAd = true;
    AppLovinMAX.showAppOpenAd(
      _adUnitId,
      placement: 'App Open',
    );

    onAdShowedFullScreenContent?.call();
    onAdDismissedFullScreenContent?.call();
  }

  void dispose() {
    _isShowingAd = false;
  }
}