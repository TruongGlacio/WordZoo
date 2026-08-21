import 'dart:io';
import 'package:flutter/material.dart';
import 'package:applovin_max/applovin_max.dart';
import 'applovin_max_config.dart';
import 'applovin_max_unit_id_manager.dart';

class AppLovinMaxInterstitialAdManager {
  static final AppLovinMaxInterstitialAdManager _singletonInterstitialAdManager =
      AppLovinMaxInterstitialAdManager._internal();
  static AppLovinMaxInterstitialAdManager get getInstance =>
      _singletonInterstitialAdManager;
  factory AppLovinMaxInterstitialAdManager() => _singletonInterstitialAdManager;
  AppLovinMaxInterstitialAdManager._internal();

  bool _isLoading = false;
  bool _isShowing = false;

  String get _adUnitId => AppLovinMaxUnitIdManager().interstitial;

  Future<bool> get isAvailable async => await _isReady();

  Future<bool> _isReady() async {
    return !(_isLoading || _isShowing) && (await AppLovinMAX.isInterstitialReady(_adUnitId)??false);
  }

  void initialize() {
    loadAd();
  }

  Future<void> loadAd() async {
    if (_isLoading || await _isReady()) return;

    _isLoading = true;

    AppLovinMAX.setInterstitialListener(InterstitialListener(
      onAdLoadedCallback: (ad) {
        _isLoading = false;
        if (AppLovinMaxConfig.enableLogs) {
          print('[AppLovinMax] Interstitial loaded');
        }
      },
      onAdLoadFailedCallback: (adUnitId, error) {
        _isLoading = false;
        if (AppLovinMaxConfig.enableLogs) {
          print('[AppLovinMax] Interstitial failed: $error');
        }
      },
      onAdClickedCallback: (ad) {
        if (AppLovinMaxConfig.enableLogs) {
          print('[AppLovinMax] Interstitial clicked');
        }
      },
      onAdDisplayedCallback: (ad) {
        if (AppLovinMaxConfig.enableLogs) {
          print('[AppLovinMax] Interstitial displayed');
        }
      },
      onAdHiddenCallback: (ad) {
        _isShowing = false;
        if (AppLovinMaxConfig.enableLogs) {
          print('[AppLovinMax] Interstitial hidden');
        }
        // Preload next ad
        loadAd();
      },
      onAdDisplayFailedCallback: (ad, error) {
        _isShowing = false;
        if (AppLovinMaxConfig.enableLogs) {
          print('[AppLovinMax] Interstitial display failed: $error');
        }
      },
    ));

    AppLovinMAX.loadInterstitial(_adUnitId);
  }

  Future<void> show() async {
    if (_isShowing) {
      return;
    }

    if (!await _isReady()) {
      if (AppLovinMaxConfig.enableLogs) {
        print('[AppLovinMax] Interstitial not ready, loading...');
      }
      loadAd();
      return;
    }

    AppLovinMAX.setInterstitialListener(null);
    AppLovinMAX.showInterstitial(
      _adUnitId,
      placement: 'Interstitial',
    );
    _isShowing = true;
  }

  void dispose() {
    _isLoading = false;
    _isShowing = false;
  }
}