
import 'blocs/iap_bloc.dart';
import 'data/repositories/iap_repository.dart';
import 'data/services/iap_service.dart';

/// Helper class để truy cập IAP
class IAPHelper {
  /// Khởi tạo IAP Service
  static Future<IAPService> initializeService() async {
    final service = IAPService();
    await service.initialize(IAPBloc(iapRepo: IapRepositoryImpl()));
    return service;
  }

  /// Kiểm tra Premium status
  static Future<bool> checkPremium() async {
    final repo = IapRepositoryImpl();
    return await repo.isPremium();
  }
}