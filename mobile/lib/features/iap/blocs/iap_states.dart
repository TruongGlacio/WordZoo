part of 'iap_bloc.dart';

sealed class IAPState extends Equatable {
  const IAPState();
  @override
  List<Object?> get props => [];
}

class IapInitial extends IAPState {
  const IapInitial();
}

class IapLoading extends IAPState {
  const IapLoading();
}

class PremiumActive extends IAPState {
  const PremiumActive();
}

class PremiumInactive extends IAPState {
  const PremiumInactive();
}

class IapError extends IAPState {
  final String message;
  const IapError(this.message);
  @override
  List<Object?> get props => [message];
}
