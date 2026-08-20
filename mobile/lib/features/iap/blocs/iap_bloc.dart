import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/repositories/iap_repository.dart';
import '../data/services/iap_service.dart';

part 'iap_events.dart';
part 'iap_states.dart';

class IAPBloc extends Bloc<IapEvent, IAPState> {
  final IapRepository iapRepo;
  final IAPService iapService = IAPService();

  IAPBloc({required this.iapRepo}) : super(const IapInitial()) {
    on<CheckPremiumStatus>(_onCheckPremiumStatus);
    on<PurchasePremium>(_onPurchasePremium);
    on<ConsumeRewardedAd>(_onConsumeRewardedAd);
    on<RestorePurchases>(_onRestorePurchases);
  }

  Future<void> _onCheckPremiumStatus(
    CheckPremiumStatus event,
    Emitter<IAPState> emit,
  ) async {
    emit(const IapLoading());
    try {
      final isPremium = await iapRepo.isPremium();
      if (isPremium) {
        emit(const PremiumActive());
      } else {
        emit(const PremiumInactive());
      }
    } catch (e) {
      emit(IapError(e.toString()));
    }
  }

  Future<void> _onPurchasePremium(
    PurchasePremium event,
    Emitter<IAPState> emit,
  ) async {
    emit(const IapLoading());
    try {
      await iapRepo.purchase(event.productId);
      final isPremium = await iapRepo.isPremium();
      if (isPremium) {
        emit(const PremiumActive());
      } else {
        emit(const PremiumInactive());
      }
    } catch (e) {
      emit(IapError(e.toString()));
    }
  }

  Future<void> _onConsumeRewardedAd(
    ConsumeRewardedAd event,
    Emitter<IAPState> emit,
  ) async {
    try {
      await iapRepo.consumeRewardedAd();
      // TODO: unlock temporary access
    } catch (e) {
      emit(IapError(e.toString()));
    }
  }

  Future<void> _onRestorePurchases(
    RestorePurchases event,
    Emitter<IAPState> emit,
  ) async {
    emit(const IapLoading());
    try {
      await iapService.restorePurchases(this);
      final isPremium = await iapRepo.isPremium();
      if (isPremium) {
        emit(const PremiumActive());
      } else {
        emit(const PremiumInactive());
      }
    } catch (e) {
      emit(IapError(e.toString()));
    }
  }

  /// Initialize the purchase listener when the BLoC is created
  void initializeListener() {
    // This will be called from the UI or app initialization where we have access to context and bloc
  }
}
