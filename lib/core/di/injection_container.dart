import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dio/dio.dart';
import 'package:noc_task_plexus/features/auth/data/data_sources/auth_local_data_source.dart';

import '../network/network_info.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_user.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../theme/presentation/bloc/theme_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // --- Core ---
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // Theme
  sl.registerFactory(() => ThemeBloc());

  // --- Features ---
  // Auth
  sl.registerFactory(() => AuthBloc(loginUseCase: sl()));

  // Use Cases
  sl.registerLazySingleton(() => LoginUser(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(localDataSource: sl(), networkInfo: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );

  // --- External ---
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Connectivity());

  // Hive init
  await Hive.initFlutter();
  await Hive.openBox('authBox');
  await Hive.openBox('deviceCache');
  await Hive.openBox('settings');
}
