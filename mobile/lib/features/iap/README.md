# In-App Purchase (IAP) Module

Dự án sử dụng cấu trúc BLoC Pattern để quản lý IAP, tổ chức độc lập trong thư mục `lib/iap/`.

## 📁 Cấu trúc thư mục

```
lib/iap/
├── blocs/
│   ├── iap_bloc.dart           # BLoC Controller - Quản lý state và business logic
│   ├── iap_event.dart          # BLoC Events - Định nghĩa các events
│   └── iap_state.dart          # BLoC States - Định nghĩa các states
├── data/
│   ├── services/
│   │   └── iap_service.dart    # IAP Service - Quản lý purchase flow
│   └── repositories/
│       └── iap_repository.dart # IAP Repository - Interact với Backend (Supabase)
├── iap_core.dart               # Constants và configs (Product IDs, prices, etc.)
├── iap_constants.dart          # Helper functions
├── iap_widgets.dart            # UI Components (PremiumStatusWidget, etc.)
└── README.md                   # Documentation này
```

## 🎯 Architecture

### Component Roles

1. **BLoC (iap_bloc.dart)**
   - Quản lý state transitions
   - Xử lý business logic
   - Connects UI với Data layer

2. **Service (iap_service.dart)**
   - Xử lý purchase flow
   - Listen purchase updates
   - Complete transactions
   - Restore purchases

3. **Repository (iap_repository.dart)**
   - Gọi API Backend
   - Verify receipts
   - Check premium status

4. **Events/States**
   - Events: Các hành động người dùng
   - States: Các trạng thái của application

## 🚀 Usage

### 1. Initialize BLoC

```dart
import 'package:wordzoo/iap/iap_core.dart';
import 'package:wordzoo/iap/blocs/iap_bloc.dart';
import 'package:wordzoo/iap/data/repositories/iap_repository.dart';
import 'package:wordzoo/iap/data/services/iap_service.dart';

// Create and initialize
final bloc = IapBloc(
  iapRepo: IAPRepositoryImpl(),
)..initializeListener();
```

### 2. Check Premium Status

```dart
import 'package:wordzoo/iap/iap_core.dart';
import 'package:wordzoo/iap/blocs/iap_bloc.dart';
import 'package:wordzoo/iap/iap_widgets.dart';

class MyScreen extends StatelessWidget {
  final IapBloc bloc = IapBloc(
    iapRepo: IAPRepositoryImpl(),
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IapBloc, IAPState>(
      bloc: bloc,
      builder: (context, state) {
        return PremiumStatusWidget(
          state: state,
          onUpgrade: () {
            bloc.add(const CheckPremiumStatus());
          },
          message: 'Nâng cấp Premium',
        );
      },
    );
  }
}
```

### 3. Purchase Subscription

```dart
// Mua subscription tháng
bloc.add(const PurchasePremium(IAPConfig.premiumMonthId));

// Mua subscription năm
bloc.add(const PurchasePremium(IAPConfig.premiumYearId));
```

### 4. Restore Purchases

```dart
bloc.add(const RestorePurchases());
```

## 📝 Events

### IAP Events

- `CheckPremiumStatus` - Kiểm tra premium status
- `PurchasePremium(productId)` - Mua subscription
- `ConsumeRewardedAd(entityId)` - Tiêu thụ quảng cáo
- `RestorePurchases` - Khôi phục purchases

### IAP States

- `IapInitial` - State ban đầu
- `IapLoading` - Đang loading
- `PremiumActive` - Tài khoản Premium
- `PremiumInactive` - Tài khoản không Premium
- `IapError(message)` - Có lỗi

## 🔧 Configuration

### Cấu hình trong `iap_core.dart`

```dart
class IAPConfig {
  static const String premiumMonthId = 'premium_monthly';
  static const String premiumYearId = 'premium_yearly';
  static const double premiumMonthPrice = 4.99;
  static const double premiumYearPrice = 49.99;
  static const bool enableSandbox = true;
  static const bool enableLogging = true;
}
```

### Supabase Setup

1. Table `user_profiles`:
   - `id` (UUID, primary key)
   - `is_premium` (boolean)
   - `premium_expires_at` (datetime)

2. Table `user_subscriptions`:
   - `user_id` (UUID, foreign key)
   - `subscription_id` (text)
   - `is_premium` (boolean)
   - `expires_at` (datetime)
   - `created_at` (datetime)

3. Supabase Function `verify-iap`:
   - Function name: `verify-iap`
   - Triggers: Receives receipt data

## 🎨 UI Widgets

### PremiumStatusWidget

```dart
PremiumStatusWidget(
  state: bloc.state,
  onUpgrade: () { /* Handle upgrade */ },
  message: 'Mua Premium',
)
```

### IAPLoadingWidget

```dart
IAPLoadingWidget(
  message: 'Đang kiểm tra...',
  size: 30.0,
)
```

### IAPErrorWidget

```dart
IAPErrorWidget(
  message: 'Lỗi khi kết nối',
  onRetry: () { /* Handle retry */ },
  icon: Icons.wifi_off,
)
```

## 🔒 Security Notes

1. **Server-side verification** is REQUIRED for production
2. Never store receipts on client-side
3. Always verify purchases on backend
4. Validate user session before granting premium

## 🧪 Testing

Sandbox mode được bật mặc định. Để test:

```dart
// Enable sandbox mode
IAPConfig.enableSandbox = true;
```

## 📚 Integration Guide

### Thêm IAP vào App

1. Import necessary modules:
```dart
import 'package:wordzoo/iap/iap_core.dart';
import 'package:wordzoo/iap/blocs/iap_bloc.dart';
import 'package:wordzoo/iap/data/repositories/iap_repository.dart';
```

2. Initialize in main.dart:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize other services...
  await IAPHelper.initializeService();
  runApp(MyApp());
}
```

3. Use in screens:
```dart
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => IapBloc(iapRepo: IAPRepositoryImpl()),
      child: SettingsContent(),
    );
  }
}

class SettingsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<IapBloc, IAPState>(
      listener: (context, state) {
        if (state is PremiumActive) {
          showPremiumBanner();
        }
      },
      child: BlocBuilder<IapBloc, IAPState>(
        bloc: BlocProvider.of<IapBloc>(context)..add(const CheckPremiumStatus()),
        builder: (context, state) {
          return PremiumStatusWidget(state: state);
        },
      ),
    );
  }
}
```

## 📄 License

Copyright © 2026 WordZoo. All rights reserved.