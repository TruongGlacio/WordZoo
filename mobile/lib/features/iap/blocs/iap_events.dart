part of 'iap_bloc.dart';

sealed class IapEvent extends Equatable {
  const IapEvent();
  @override
  List<Object?> get props => [];
}

class CheckPremiumStatus extends IapEvent {
  const CheckPremiumStatus();
}

class PurchasePremium extends IapEvent {
  final String productId;
  const PurchasePremium(this.productId);
  @override
  List<Object?> get props => [productId];
}

class ConsumeRewardedAd extends IapEvent {
  final String entityId;
  const ConsumeRewardedAd(this.entityId);
  @override
  List<Object?> get props => [entityId];
}

class RestorePurchases extends IapEvent {
  const RestorePurchases();
}
