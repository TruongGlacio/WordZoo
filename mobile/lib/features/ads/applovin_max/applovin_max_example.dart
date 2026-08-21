import 'package:flutter/material.dart';
import 'applovin_max_banner_ad_manager.dart';
import 'applovin_max_interstitial_ad_manager.dart';
import 'applovin_max_manager.dart';
import 'applovin_max_rewarded_ad_manager.dart';

/// Example: Using AppLovinMaxBannerAdManager
class AppLovinBannerExample extends StatefulWidget {
  @override
  _AppLovinBannerExampleState createState() => _AppLovinBannerExampleState();
}

class _AppLovinBannerExampleState extends State<AppLovinBannerExample> {
  @override
  void initState() {
    super.initState();
    // Initialize banner ads
    AppLovinMaxBannerAdManager.getInstance.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AppLovin Banner Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Banner is displayed at the bottom
            AppLovinMaxBannerAdManager.getInstance.widget ??
                CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

/// Example: Using AppLovinMaxInterstitialAdManager
class AppLovinInterstitialExample extends StatefulWidget {
  @override
  _AppLovinInterstitialExampleState createState() =>
      _AppLovinInterstitialExampleState();
}

class _AppLovinInterstitialExampleState
    extends State<AppLovinInterstitialExample> {
  @override
  void initState() {
    super.initState();
    // Initialize interstitial ads
    AppLovinMaxInterstitialAdManager.getInstance.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AppLovin Interstitial Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                AppLovinMaxInterstitialAdManager.getInstance.show();
              },
              child: Text('Show Interstitial Ad'),
            ),
            Text(
              '\nisAvailable: ${AppLovinMaxInterstitialAdManager.getInstance.isAvailable}',
            ),
          ],
        ),
      ),
    );
  }
}

/// Example: Using AppLovinMaxRewardedAdManager
class AppLovinRewardedExample extends StatefulWidget {
  @override
  _AppLovinRewardedExampleState createState() =>
      _AppLovinRewardedExampleState();
}

class _AppLovinRewardedExampleState extends State<AppLovinRewardedExample> {
  @override
  void initState() {
    super.initState();
    // Initialize rewarded ads
    AppLovinMaxRewardedAdManager.getInstance.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AppLovin Rewarded Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                AppLovinMaxRewardedAdManager.getInstance.show(
                  onAdDismissed: (ad) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ad dismissed')),
                    );
                  },
                  onAdFailedToShow: (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to show: $error')),
                    );
                  },
                );
              },
              child: Text('Show Rewarded Ad'),
            ),
            Text(
              '\nisAvailable: ${AppLovinMaxRewardedAdManager.getInstance.isAvailable}',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

/// Example: Using AppLovinMaxManager (Single entry point)
class AppLovinMasterExample extends StatefulWidget {
  @override
  _AppLovinMasterExampleState createState() => _AppLovinMasterExampleState();
}

class _AppLovinMasterExampleState extends State<AppLovinMasterExample> {
  @override
  void initState() {
    super.initState();
    // Initialize all ad managers
    AppLovinMaxManager.getInstance.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AppLovin Master Example')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: Text('Banner'),
              subtitle: Text('Display banner at bottom'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AppLovinBannerExample()),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Interstitial'),
              subtitle:
                  Text('Show interstitial ad between content'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AppLovinInterstitialExample()),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Rewarded'),
              subtitle:
                  Text('Show rewarded ad for rewards'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AppLovinRewardedExample()),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              AppLovinMaxManager.getInstance.showRewardAds(
                onRewardEarned: (ad, reward) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Reward earned: ${reward.amount} ${reward.amount}'),
                    ),
                  );
                },
                onAdDismissed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reward ad dismissed')),
                  )
                  ;
                },
                onAdFailedToShow: (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to show: $error'),
                    ),
                  );
                },
              );
            },
            child: const Text('Show Rewarded Ad (from Master)'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              AppLovinMaxManager.getInstance.showAppOpenAds(
                onAdShowedFullScreenContent: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('App Open Ad shown')),
                  );
                },
                onAdDismissedFullScreenContent: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('App Open Ad dismissed')),
                  );
                },
              );
            },
            child: Text('Show App Open Ad'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              AppLovinMaxManager.getInstance.dispose();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('All ads disposed')),
              );
            },
            child: Text('Dispose All Ads'),
          ),
          SizedBox(height: 20),
          Text(
            'Banner Available: ${AppLovinMaxManager.getInstance.banner.isLoaded}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'Interstitial Available: ${AppLovinMaxManager.getInstance.interstitial.isAvailable}',
          ),
          Text(
            'Rewarded Available: ${AppLovinMaxManager.getInstance.rewarded.isAvailable}',
          ),
          Text(
            'App Open Available: ${AppLovinMaxManager.getInstance.appOpen.isAdAvailable}',
          ),
        ],
      ),
    );
  }
}