# WordZoo In-App Purchase System

## Overview

This document describes the In-App Purchase system implementation for the WordZoo Flutter application, including all components from service layer to BLoC integration.

## Architecture

The IAP system follows a clean architecture pattern with:

1. **Service Layer** (`IapService`) - Handles the actual platform interaction, error handling and transaction lifecycle
2. **Repository Layer** (`IapRepository`) - Abstracts platform details and integrates with Supabase backend 
3. **BLoC Layer** (`IapBloc`) - Manages state and handles business logic for premium status
4. **UI Layer** - Uses the BLoC to determine premium status and trigger purchases

## Components

### 1. IAP Service (`lib/data/services/iap_service.dart`)

Key features:
- Implements platform-specific purchase stream listening
- Handles all transaction lifecycle events (purchased, canceled, error, restored)
- Manages proper transaction completion for Android
- Supports restore purchases functionality
- Provides product query capabilities

### 2. IAP Repository (`lib/data/repositories/iap_repository.dart`)

Key features:
- Integrates with Supabase `user_profiles.is_premium` column
- Abstracts platform details via `in_app_purchase` package
- Calls Supabase Edge Functions for receipt verification
- Implements purchase flow with proper error handling

### 3. IAP BLoC (`lib/blocs/iap/`)

Key features:
- Manages premium status state (Initial, Loading, Active, Inactive, Error)
- Handles all IAP events: CheckStatus, Purchase, RestorePurchases, ConsumeRewardedAd
- Updates UI automatically based on premium status changes

## Integration Points

### AndroidManifest.xml
```xml
<uses-permission android:name="com.android.vending.BILLING"/>
```

### Native iOS Integration
iOS integration is handled automatically by Flutter via StoreKit. No explicit configuration
required in the Xcode project.

## API Endpoints

The system calls `verify-iap` Edge Function with:
- platform: 'android' or 'ios'
- product_id: The purchased product ID  
- transaction_id: Platform-specific transaction ID
- receipt_data: Base64 encoded receipt data

## Error Handling

1. All purchase events are wrapped in try-catch blocks for error prevention
2. Stream errors are logged and handled gracefully
3. Transaction state is cleared if errors occur during processing (using `completeTransaction`)
4. Fallback status updates to ensure UI reflects current premium status

## Usage Patterns

### Initialize Service
Service should be initialized in app startup, typically after the BLoC is available:

```dart
IapBloc iapBloc = context.read<IapBloc>();
iapService.initialize(iapBloc);
```

### Making Purchases
Trigger purchases via BLoC events:
```dart
context.read<IapBloc>().add(PurchasePremium(productId: 'premium_monthly'));
```

### Restoring Purchases
```dart
context.read<IapBloc>().add(RestorePurchases());
```

## Reusable Structure

This IAP implementation is designed to be completely portable to other Flutter apps:
1. All platform-specific calls encapsulated in `iap_service.dart`
2. BLoC pattern ensures UI independent state management
3. Repository abstraction allows easy swapping of backend implementations
4. No hardcoded values, all configurable through constants