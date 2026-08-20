import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:wordzoo/features/iap/blocs/iap_bloc.dart';

/// Service to handle In-App Purchase events and lifecycle management
class IAPService {
  static final IAPService _instance = IAPService._internal();
  factory IAPService() => _instance;
  IAPService._internal();

  StreamSubscription<List<PurchaseDetails>>? _subscription;
  bool _isInitialized = false;

  /// Initialize the purchase stream listener
  Future<void> initialize(IAPBloc bloc) async {
    if (_isInitialized) return;
    
    await InAppPurchase.instance.isAvailable();
    
    _subscription = InAppPurchase.instance.purchaseStream.listen(
      (List<PurchaseDetails> updates) => _handlePurchaseUpdates(updates, bloc),
      onError: (Object error) {
        debugPrint('[IAP] Purchase stream error: $error');
      },
    );
    
    _isInitialized = true;
  }

  /// Handle all purchase updates from the platform
  Future<void> _handlePurchaseUpdates(
    List<PurchaseDetails> updates,
    IAPBloc bloc,
  ) async {
    for (final purchase in updates) {
      await _handleSinglePurchase(purchase, bloc);
    }
  }

  /// Handle a single purchase event
  Future<void> _handleSinglePurchase(
    PurchaseDetails purchase,
    IAPBloc bloc,
  ) async {
    debugPrint('[IAP] Handling purchase: ${purchase.productID} - Status: ${purchase.status}');
    
    try {
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _handleSuccessfulPurchase(purchase, bloc);
          break;
        case PurchaseStatus.pending:
          debugPrint('[IAP] Purchase pending: ${purchase.productID}');
          break;
        case PurchaseStatus.canceled:
          debugPrint('[IAP] Purchase canceled: ${purchase.productID}');
          // After cancellation, check status to make sure UI is updated properly
          bloc.add(const CheckPremiumStatus());
          break;
        case PurchaseStatus.error:
          debugPrint('[IAP] Purchase error for ${purchase.productID}: ${purchase.error?.message}');
          // After error, check status to make sure UI is updated properly
          bloc.add(const CheckPremiumStatus());
          break;
      }
    } catch (e) {
      debugPrint('[IAP] Error handling purchase: $e');
      bloc.add(const CheckPremiumStatus());
    }
  }

  /// Handle successful purchase or restore
  Future<void> _handleSuccessfulPurchase(
    PurchaseDetails purchase,
    IAPBloc bloc,
  ) async {
    try {
      // The service doesn't directly trigger state changes anymore. Instead, 
      // it's handled entirely in the BLoC with proper state management.
      
      debugPrint('[IAP] Successfully completed purchase: ${purchase.productID}');
      
      // Mark transaction as complete (important for Android)
      if (purchase.pendingCompletePurchase == true) {
        await _completeTransaction(purchase);
      }

      // After handling, trigger status check so the UI is properly updated
      bloc.add(const CheckPremiumStatus());
    } catch (e) {
      debugPrint('[IAP] Error in successful purchase handling: $e');
      bloc.add(const CheckPremiumStatus());
    }
  }

  /// Complete transaction to avoid pending state
  Future<void> _completeTransaction(PurchaseDetails purchase) async {
    try {
      await InAppPurchase.instance.completePurchase(purchase);
      debugPrint('[IAP] Transaction completed for ${purchase.productID}');
    } catch (e) {
      debugPrint('[IAP] Error completing transaction: $e');
    }
  }

  /// Dispose and cancel subscription
  Future<void> dispose() async {
    await _subscription?.cancel();
    _isInitialized = false;

    // Handle any pending transactions at shutdown
    try {
      final pending = InAppPurchase.instance.purchaseStream;
      pending.listen((event) async {
        if (event.isNotEmpty) {
          debugPrint('[IAP] Cleaning up ${pending.length} pending purchases');
          for (final purchase in event) {
            if(purchase.status == PurchaseStatus.pending) {
            await InAppPurchase.instance.completePurchase(purchase);
          }
        }
      }});

    } catch (e) {
      debugPrint('[IAP] Error during cleanup: $e');
    }
  }

  /// Restore previous purchases
  Future<void> restorePurchases(IAPBloc bloc) async {
    try {
      debugPrint('[IAP] Attempting to restore purchases');
      await InAppPurchase.instance.restorePurchases();
      
      // After restore, check status to update UI properly
      bloc.add(const CheckPremiumStatus());
    } catch (e) {
      debugPrint('[IAP] Error restoring purchases: $e');
      // Even if there's an error, we still want to update the premium status
      bloc.add(const CheckPremiumStatus());
    }
  }

  /// Query available products for purchase
  Future<List<ProductDetails>> queryProductDetails(List<String> productIds) async {
    try {
      final response = await InAppPurchase.instance.queryProductDetails(Set.from(productIds));
      
      if (response.error != null) {
        debugPrint('[IAP] Product query error: ${response.error}');
        return [];
      }
      
      return response.productDetails;
    } catch (e) {
      debugPrint('[IAP] Error querying product details: $e');
      return [];
    }
  }

  /// Start purchase flow for a specific product
  Future<void> startPurchase(String productId, IAPBloc bloc) async {
    try {
      final products = await queryProductDetails([productId]);
      
      if (products.isEmpty) {
        debugPrint('[IAP] No product found for ID: $productId');
        return;
      }
      
      final product = products.first;
      final purchaseParam = PurchaseParam(productDetails: product);
      
      // For Android, we want to handle the result properly
      await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      debugPrint('[IAP] Error starting purchase for $productId: $e');
      bloc.add(const CheckPremiumStatus());
    }
  }
}