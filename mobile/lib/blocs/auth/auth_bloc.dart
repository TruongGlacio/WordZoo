import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wordzoo/data/repositories/data_sync_repository.dart';
import 'package:wordzoo/data/service/zip_asset_service.dart';
import '../../data/models/user_profile.dart';
import '../../data/repositories/supabase_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SupabaseRepository authRepo;

  AuthBloc({required this.authRepo}) : super(const AuthInitial()) {
    on<LoadingDataProcess>((event, emit) async {

      emit(const AuthLoading());
      await ZipAssetService.instance.getRootDir();
      final data = await DataSyncRepositoryImpl.instance.getData();
      add(const AuthStatusChanged());
    },);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<GuestModeRequested>(_onGuestModeRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthStatusChanged>(_onAuthStatusChanged);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await authRepo.signIn(event.email.trim(), event.password.trim());
      final profile = await authRepo.getCurrentUserProfile();
      if (profile != null) {
        emit(Authenticated(user: profile, isPremium: profile.isPremium));
      } else {
        emit(const AuthError('Không thể tải thông tin người dùng'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await authRepo.signUp(event.email.trim(), event.password.trim(), event.displayName.trim());
      final profile = await authRepo.getCurrentUserProfile();
      if (profile != null) {
        emit(Authenticated(user: profile, isPremium: profile.isPremium));
      } else {
        emit(const AuthError('Không thể tải thông tin người dùng'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onGuestModeRequested(
    GuestModeRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await authRepo.signIn("WordZooDemo@gmail.com", '123456');
      final profile = await authRepo.getCurrentUserProfile();
      if(profile!=null) {
        emit(Authenticated(user: profile, isPremium: false));
      }
      else
        {
          emit(const AuthError('Không thể tải thông tin người dùng'));
        }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await authRepo.signOut();
      emit(const Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onAuthStatusChanged(
    AuthStatusChanged event,
    Emitter<AuthState> emit,
  ) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final profile = await authRepo.getCurrentUserProfile();
      if (profile != null) {
        emit(Authenticated(user: profile, isPremium: profile.isPremium));
      } else {
        emit(const Unauthenticated());
      }
    } else {
      emit(const Unauthenticated());
    }
  }
}
