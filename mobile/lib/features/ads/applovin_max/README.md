# AppLovin MAX Ads Module

Module quản lý quảng cáo AppLovin MAX cho Flutter.

## Installation

```yaml
dependencies:
  applovin_max: ^4.6.4
```

## Configuration

Để sử dụng AppLovin MAX, bạn cần thiết lập Unit ID trong `applovin_max_unit_id_manager.dart`.

```dart
class AppLovinMaxUnitIdManager {
  static String get banner => 'R-P-BANNER-UNIT-ID';
  static String get interstitial => 'R-P-INTERSTITIAL-UNIT-ID';
  static String get rewarded => 'R-P-REWARDED-UNIT-ID';
  static String get appOpen => 'R-P-APPOPEN-UNIT-ID';
}
```

## Quick Start

### 1. Initialize module

```dart
import 'package:wordzoo/features/ads/applovin_max/applovin_max_manager.dart';

// Trong app startup
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppLovinMaxManager.getInstance.initialize();
  runApp(MyApp());
}
```

### 2. Show Banner Ad

```dart
// Tạo widget banner tại bất kỳ đâu trong UI
MaxAdView(
  adUnitId: 'YOUR_BANNER_UNIT_ID',
  adFormat: AdFormat.banner,
  placement: 'Banner',
  isAutoRefreshEnabled: true,
  isAdaptiveBannerEnabled: true,
)
```

Hoặc sử dụng `AppLovinMaxBannerAdManager`:

```dart
// Initialize
AppLovinMaxBannerAdManager.getInstance.initialize();

// Display banner
AppLovinMaxBannerAdManager.getInstance.widget
```

### 3. Show Interstitial Ad

```dart
AppLovinMaxInterstitialAdManager.getInstance.show();
```

### 4. Show Rewarded Ad

```dart
AppLovinMaxRewardedAdManager.getInstance.show(
  onAdDismissed: () {
    print('Ad dismissed');
    // Cung cấp reward cho user
  },
  onAdFailedToShow: (error) {
    print('Failed to show ad: $error');
  },
);
```

### 5. Show App Open Ad

```dart
AppLovinMaxAppOpenAdManager.getInstance.showAdIfAvailable(
  onAdDismissedFullScreenContent: () {
    print('Ad dismissed');
  },
  onAdShowedFullScreenContent: () {
    print('Ad shown');
  },
);
```

## Usage Example

### Using AppLovinMaxBannerAdManager

```dart
class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  @override
  void initState() {
    super.initState();
    AppLovinMaxBannerAdManager.getInstance.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Main Content'),
            // Banner ad at bottom
            AppLovinMaxBannerAdManager.getInstance.widget ?? Container(),
          ],
        ),
      ),
    );
  }
}
```

### Using AppLovinMaxInterstitialAdManager

```dart
class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Game')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Show interstitial ad after game ends
            if (AppLovinMaxInterstitialAdManager.getInstance.isAvailable) {
              AppLovinMaxInterstitialAdManager.getInstance.show();
            }
          },
          child: Text('End Game'),
        ),
      ),
    );
  }
}
```

### Using AppLovinMaxRewardedAdManager

```dart
class LevelCompleteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Level Complete')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Level Complete!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                AppLovinMaxRewardedAdManager.getInstance.show(
                  onAdDismissed: () {
                    // Cung cấp reward
                    Navigator.pop(context);
                  },
                  onAdFailedToShow: (error) {
                    Navigator.pop(context);
                  },
                );
              },
              child: Text('Watch Ad for Reward'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Using AppLovinMaxManager (Single Entry Point)

```dart
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    AppLovinMaxManager.getInstance.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    // Show app open ad
    AppLovinMaxManager.getInstance.showAppOpenAds(
      onAdShowedFullScreenContent: () {
        print('App Open Ad shown');
      },
      onAdDismissedFullScreenContent: () {
        print('App Open Ad dismissed');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Main')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            AppLovinMaxManager.getInstance.showRewardAds(
              onRewardEarned: (ad, reward) {
                print('Reward earned: ${reward.amount} ${reward.type}');
              },
              onAdDismissed: () {
                print('Ad dismissed');
              },
              onAdFailedToShow: (error) {
                print('Failed to show: $error');
              },
            );
          },
          child: Text('Show Reward Ad'),
        ),
      ),
    );
  }
}
```

## API Reference

### AppLovinMaxBannerAdManager

- `AppLovinMaxBannerAdManager.getInstance.initialize()` - Initialize banner ads
- `isLoaded` - Check if banner is loaded
- `widget` - Get the banner widget

### AppLovinMaxInterstitialAdManager

- `AppLovinMaxInterstitialAdManager.getInstance.initialize()` - Initialize interstitial ads
- `isAvailable` - Check if interstitial is available
- `show()` - Show interstitial ad

### AppLovinMaxRewardedAdManager

- `AppLovinMaxRewardedAdManager.getInstance.initialize()` - Initialize rewarded ads
- `isAvailable` - Check if rewarded ad is available
- `isShowing` - Check if rewarded ad is showing
- `show({onAdDismissed, onAdFailedToShow})` - Show rewarded ad

### AppLovinMaxAppOpenAdManager

- `AppLovinMaxAppOpenAdManager.getInstance.initialize()` - Initialize app open ads
- `isAdAvailable` - Check if app open ad is available
- `showAdIfAvailable({onAdShowedFullScreenContent, onAdDismissedFullScreenContent})` - Show app open ad

### AppLovinMaxManager

- `initialize()` - Initialize all ad managers
- `showRewardAds({onRewardEarned, onAdDismissed, onAdFailedToShow})` - Show rewarded ad
- `showAppOpenAds({onAdDismissedFullScreenContent, onAdShowedFullScreenContent})` - Show app open ad
- `dispose()` - Dispose all ad managers
- `banner` - AppLovinMaxBannerAdManager instance
- `interstitial` - AppLovinMaxInterstitialAdManager instance
- `rewarded` - AppLovinMaxRewardedAdManager instance
- `appOpen` - AppLovinMaxAppOpenAdManager instance

## Best Practices

1. **Always check availability** before showing ads:
   ```dart
   if (AppLovinMaxInterstitialAdManager.getInstance.isAvailable) {
     AppLovinMaxInterstitialAdManager.getInstance.show();
   }
   ```

2. **Preload ads** by calling `initialize()` at app startup.

3. **Handle rewards** from rewarded ads:
   ```dart
   AppLovinMaxRewardedAdManager.getInstance.show(
     onAdDismissed: () {
       // Provide reward to user
     },
   );
   ```

4. **Dispose ads** when needed:
   ```dart
   AppLovinMaxManager.getInstance.dispose();
   ```

5. **Set up correct unit IDs** in `applovin_max_unit_id_manager.dart`.

## Error Handling

Module tự động xử lý lỗi và preload lại ads khi fail. Bạn có thể thêm callback để xử lý lỗi:

```dart
AppLovinMaxRewardedAdManager.getInstance.show(
  onAdDismissed: () {
    print('Ad dismissed');
  },
  onAdFailedToShow: (error) {
    print('Error: $error');
    // Handle error (e.g., show alternative)
  },
);
```

## Notes

- AppLovin SDK được initialize tự động khi gọi methods đầu tiên của plugin.
- Banner ads nên được hiển thị ở vị trí hiển thị rõ ràng.
- Interstitial ads nên hiển thị khi user hoàn thành hành động.
- Rewarded ads nên hiển thị khi user muốn nhận thưởng.
- App open ads chỉ nên hiển thị khi app mở lại.