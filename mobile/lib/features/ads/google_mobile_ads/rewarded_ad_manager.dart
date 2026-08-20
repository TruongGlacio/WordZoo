import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'google_mobile_ads_unit_id_manager.dart';

class RewardedAdManager {
  RewardedAd? _rewardedAd;

  bool _isLoading = false;
  bool _isShowing = false;

  String get _adUnitId {
      return GoogleMobileAdsUnitIdManager().rewarded;
  }

  bool get isAvailable => _rewardedAd != null;

  bool get isShowing => _isShowing;

  /// Preload Rewarded Ad
  void loadAd() {
    if (_isLoading || _rewardedAd != null) {
      return;
    }

    _isLoading = true;

    RewardedAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _isLoading = false;
          _rewardedAd = ad;

          debugPrint('Rewarded Ad loaded');
        },
        onAdFailedToLoad: (error) {
          _isLoading = false;
          _rewardedAd = null;

          debugPrint(
            'Rewarded Ad failed to load: '
                '${error.code} - ${error.message}',
          );
        },
      ),
    );
  }

  /// Show Rewarded Ad
  ///
  /// [onRewardEarned] chỉ được gọi khi user thực sự
  /// hoàn thành điều kiện nhận reward.
  void show({required void Function(
        AdWithoutView ad,
        RewardItem reward,
        ) onRewardEarned,
    VoidCallback? onAdDismissed,
    void Function(AdError error)? onAdFailedToShow,
  }) {
    if (_isShowing) {
      debugPrint('Rewarded Ad is already showing');
      return;
    }

    final ad = _rewardedAd;

    if (ad == null) {
      debugPrint('Rewarded Ad is not ready');

      loadAd();
      return;
    }

    _rewardedAd = null;
    _isShowing = true;

    bool rewardEarned = false;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        debugPrint('Rewarded Ad showed');
      },

      onAdDismissedFullScreenContent: (ad) {
        debugPrint(
          'Rewarded Ad dismissed. '
              'Reward earned: $rewardEarned',
        );

        _isShowing = false;

        ad.dispose();

        // Preload quảng cáo tiếp theo
        loadAd();

        onAdDismissed?.call();
      },

      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint(
          'Rewarded Ad failed to show: '
              '${error.code} - ${error.message}',
        );

        _isShowing = false;

        ad.dispose();

        // Preload quảng cáo tiếp theo
        loadAd();

        onAdFailedToShow?.call(error);
      },
    );

    ad.show(onUserEarnedReward: (ad, reward) {
        rewardEarned = true;
        debugPrint('Reward earned: ''${reward.amount} ${reward.type}',);
        onRewardEarned(ad, reward);
      },
    );
  }

  /// Dispose current ad.
  void dispose() {
    _rewardedAd?.dispose();
    _rewardedAd = null;

    _isLoading = false;
    _isShowing = false;
  }
}