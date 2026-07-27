import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'package:wordzoo/utils/logger.dart';
import 'package:wordzoo/presentation/theme/app_theme.dart';
import 'package:wordzoo/data/repositories/supabase_repository.dart';
import 'package:wordzoo/data/repositories/data_sync_repository.dart';
import 'package:wordzoo/data/repositories/progress_repository.dart';
import 'package:wordzoo/data/repositories/iap_repository.dart';
import 'package:wordzoo/blocs/auth/auth_bloc.dart';
import 'package:wordzoo/blocs/category/category_bloc.dart';
import 'package:wordzoo/blocs/entity/entity_bloc.dart';
import 'package:wordzoo/blocs/progress/progress_bloc.dart';
import 'package:wordzoo/blocs/iap/iap_bloc.dart';
import 'package:wordzoo/blocs/language/language_bloc.dart';
import 'package:wordzoo/presentation/screens/splash_screen.dart';
import 'package:wordzoo/presentation/screens/login_screen.dart';
import 'package:wordzoo/presentation/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  await dotenv.load(fileName: '.env');

  await Hive.initFlutter();
  await Hive.openBox<String>('app_data');

  await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    anonKey: dotenv.get('SUPABASE_ANON_KEY'),
  );

  AppLogger.i('Supabase initialized');

  final supabaseRepo = SupabaseRepositoryImpl.instance;
  final dataSyncRepo = DataSyncRepositoryImpl.instance;
  final progressRepo = ProgressRepositoryImpl.instance;
  final iapRepo = IapRepositoryImpl.instance;

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SupabaseRepository>.value(value: supabaseRepo),
        RepositoryProvider<DataSyncRepository>.value(value: dataSyncRepo),
        RepositoryProvider<ProgressRepository>.value(value: progressRepo),
        RepositoryProvider<IapRepository>.value(value: iapRepo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(authRepo: supabaseRepo)..add(AuthStatusChanged()),
          ),
          BlocProvider<CategoryBloc>(
            create: (_) => CategoryBloc(dataSyncRepo: dataSyncRepo)..add(LoadCategories()),
          ),
          BlocProvider<EntityBloc>(
            create: (_) => EntityBloc(dataSyncRepo: dataSyncRepo, progressRepo: progressRepo),
          ),
          BlocProvider<ProgressBloc>(
            create: (_) => ProgressBloc(progressRepo: progressRepo)..add(LoadProgress()),
          ),
          BlocProvider<IapBloc>(
            create: (_) => IapBloc(iapRepo: iapRepo)..add(CheckPremiumStatus()),
          ),
          BlocProvider<LanguageBloc>(
            create: (_) => LanguageBloc(),
          ),
        ],
        child: const WordZooApp(),
      ),
    ),
  );
}

class WordZooApp extends StatelessWidget {
  const WordZooApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBreakpoints(
      breakpoints: const [
        Breakpoint(start: 0, end: 840, name: 'PHONE'),
        Breakpoint(start: 841, end: 1200, name: 'TABLET'),
        Breakpoint(start: 1201, end: double.infinity, name: 'DESKTOP'),
      ],
      child: MaterialApp(
        title: 'WordZoo',
        theme: AppTheme.lightTheme,
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return const HomeScreen();
        } else if (state is AuthLoading) {
          return const SplashScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
