part of 'iap_bloc.dart';

sealed class IapState extends Equatable {
  const IapState();
  @override
  List<Object?> get props => [];
}

class IapInitial extends IapState {
  const IapInitial();
}

class IapLoading extends IapState {
  const IapLoading();
}

class PremiumActive extends IapState {
  const PremiumActive();
}

class PremiumInactive extends IapState {
  const PremiumInactive();
}

class IapError extends IapState {
  final String message;
  const IapError(this.message);
  @override
  List<Object?> get props => [message];
}
