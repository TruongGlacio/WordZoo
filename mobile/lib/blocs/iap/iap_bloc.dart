import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repositories/iap_repository.dart';

part 'iap_event.dart';
part 'iap_state.dart';

class IapBloc extends Bloc<IapEvent, IapState> {
  final IapRepository iapRepo;

  IapBloc({required this.iapRepo}) : super(const IapInitial()) {
    on<CheckPremiumStatus>(_onCheckPremiumStatus);
    on<PurchasePremium>(_onPurchasePremium);
    on<ConsumeRewardedAd>(_onConsumeRewardedAd);
  }

  Future<void> _onCheckPremiumStatus(
    CheckPremiumStatus event,
    Emitter<IapState> emit,
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
    Emitter<IapState> emit,
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
    Emitter<IapState> emit,
  ) async {
    try {
      await iapRepo.consumeRewardedAd();
      // TODO: unlock temporary access
    } catch (e) {
      emit(IapError(e.toString()));
    }
  }
}
