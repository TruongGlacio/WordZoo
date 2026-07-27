import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wordzoo/utils/constants.dart';
import 'package:wordzoo/utils/logger.dart';

abstract class IapRepository {
  Future<bool> isPremium();
  Future<void> purchase(String productId);
  Future<void> consumeRewardedAd();
  Future<void> verifyReceipt({
    required String platform,
    required String productId,
    required String transactionId,
    required String receiptData,
  });
}

class IapRepositoryImpl implements IapRepository {
  IapRepositoryImpl._internal();
  static final IapRepositoryImpl _instance = IapRepositoryImpl._internal();
  static IapRepositoryImpl get instance => _instance;
  factory IapRepositoryImpl() => _instance;

  final InAppPurchase _iap = InAppPurchase.instance;
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<bool> isPremium() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return false;

      final response = await _client
          .from('user_profiles')
          .select('is_premium')
          .eq('id', user.id)
          .single();

      return response['is_premium'] as bool? ?? false;
    } catch (e, st) {
      AppLogger.e('isPremium failed', e, st);
      return false;
    }
  }

  @override
  Future<void> purchase(String productId) async {
    try {
      final products = await _iap.queryProductDetails({
        if (defaultTargetPlatform == TargetPlatform.android)
          AppConstants.iapProductMonthly
        else
          AppConstants.iapProductYearly,
      });

      if (products.error != null) {
        throw products.error!;
      }

      if (products.productDetails.isEmpty) {
        throw Exception('Product not found');
      }

      final product = products.productDetails.first;
      final purchaseParam = PurchaseParam(productDetails: product);

      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e, st) {
      AppLogger.e('purchase failed', e, st);
      rethrow;
    }
  }

  @override
  Future<void> consumeRewardedAd() async {
    AppLogger.i('consumeRewardedAd: placeholder');
  }

  @override
  Future<void> verifyReceipt({
    required String platform,
    required String productId,
    required String transactionId,
    required String receiptData,
  }) async {
    try {
      final response = await _client.functions.invoke('verify-iap', body: {
        'platform': platform,
        'product_id': productId,
        'transaction_id': transactionId,
        'receipt_data': receiptData,
      });

      if (response.data != null && response.data['success'] == true) {
        AppLogger.i('IAP receipt verified');
      } else {
        throw Exception(response.data?['error'] ?? 'Verification failed');
      }
    } catch (e, st) {
      AppLogger.e('verifyReceipt failed', e, st);
      rethrow;
    }
  }
}
