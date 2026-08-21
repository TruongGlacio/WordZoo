import 'dart:io';
import 'dart:math';
import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';
import 'package:flutter/material.dart';
import 'package:applovin_max/applovin_max.dart';
import 'applovin_max_config.dart';
import 'applovin_max_unit_id_manager.dart';

class AppLovinMaxRewardedAdManager {
  static final AppLovinMaxRewardedAdManager _singletonRewardedAdManager = AppLovinMaxRewardedAdManager._internal();
  static AppLovinMaxRewardedAdManager get getInstance => _singletonRewardedAdManager;
  factory AppLovinMaxRewardedAdManager() => _singletonRewardedAdManager;
  AppLovinMaxRewardedAdManager._internal();

  bool _isLoading = false;
  bool _isShowing = false;

  String get _adUnitId => AppLovinMaxUnitIdManager().rewarded;

  Future<bool> get isAvailable async => await _isReady();
  bool get isShowing => _isShowing;

  Future<bool> _isReady() async {
    return !(_isLoading || _isShowing) && (await AppLovinMAX.isRewardedAdReady(_adUnitId) ?? false);
  }

  void initialize() {
    loadAd();
  }

  Future<void> loadAd() async {
    if (_isLoading || await _isReady()) return;

    _isLoading = true;

    AppLovinMAX.setRewardedAdListener(
      RewardedAdListener(
        onAdLoadedCallback: (ad) {
          _isLoading = false;
          if (AppLovinMaxConfig.enableLogs) {
            print('[AppLovinMax] Rewarded Ad loaded');
          }
        },
        onAdLoadFailedCallback: (adUnitId, error) {
          _isLoading = false;
          if (AppLovinMaxConfig.enableLogs) {
            print('[AppLovinMax] Rewarded Ad failed: $error');
          }
        },
        onAdClickedCallback: (ad) {
          if (AppLovinMaxConfig.enableLogs) {
            print('[AppLovinMax] Rewarded Ad clicked');
          }
        },
        onAdDisplayedCallback: (ad) {
          if (AppLovinMaxConfig.enableLogs) {
            print('[AppLovinMax] Rewarded Ad displayed');
          }
        },
        onAdHiddenCallback: (ad) {
          _isShowing = false;
          if (AppLovinMaxConfig.enableLogs) {
            print('[AppLovinMax] Rewarded Ad hidden');
          }
          // Preload next ad
          loadAd();
        },
        onAdDisplayFailedCallback: (ad, error) {
          _isShowing = false;
          if (AppLovinMaxConfig.enableLogs) {
            print('[AppLovinMax] Rewarded Ad display failed: $error');
          }
        },
        onAdRevenuePaidCallback: (ad) {
          if (AppLovinMaxConfig.enableLogs) {
            print('[AppLovinMax] Rewarded Ad revenue: \$${ad.revenue}');
          }
        },
        onAdReceivedRewardCallback: (ad, reward) {
          if (AppLovinMaxConfig.enableLogs) {
            print('[AppLovinMax] Reward earned: ${reward.amount}, ${reward.amount}');
          }
        },
      ),
    );

    AppLovinMAX.loadRewardedAd(_adUnitId);
  }

  Future<void> show(
      {
        required void Function(MaxAd ad)? onAdDismissed,
        void Function(MaxError error)? onAdFailedToShow,
      }) async {
    if (_isShowing) {
      return;
    }

    if (!await _isReady()) {
      if (AppLovinMaxConfig.enableLogs) {
        print('[AppLovinMax] Rewarded Ad not ready, loading...');
      }
      loadAd();
      return;
    }

    AppLovinMAX.setRewardedAdListener(
      RewardedAdListener(
          onAdLoadedCallback: (ad) {

          },
          onAdLoadFailedCallback: (adUnitId, error) {
            onAdFailedToShow?.call(error);
          },
          onAdDisplayedCallback: (ad) {},
          onAdDisplayFailedCallback: (ad, error) {
            onAdFailedToShow?.call(error);
          },
          onAdClickedCallback: (ad) {
          },
          onAdHiddenCallback: (ad) {
            onAdDismissed?.call(ad);
          },
          onAdReceivedRewardCallback: (ad, reward) {
            onAdDismissed?.call(ad);
          }),
    );
    AppLovinMAX.showRewardedAd(_adUnitId, placement: 'Rewarded');
    _isShowing = true;
  }

  void dispose() {
    _isLoading = false;
    _isShowing = false;
  }
}
