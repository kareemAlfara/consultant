// ========================================
// 📁 lib/core/utils/services/service_locator/users_injection.dart
// ========================================
import 'package:get_it/get_it.dart';
import 'package:marriage/feature/chating/data/datasource/users_remote_data_source.dart';
import 'package:marriage/feature/chating/presentation/cubit/users_list_cubit/users_list_cubit.dart';

final sl = GetIt.instance;

Future<void> initUsersListDependencies() async {
  print('🔧 Initializing Users List dependencies...');

  // ========================================
  // 📦 DATA SOURCES
  // ========================================
  sl.registerLazySingleton<UsersRemoteDataSource>(
    () => UsersRemoteDataSource(),
  );

  // ========================================
  // 📦 CUBITS
  // ========================================
  sl.registerFactory<UsersListCubit>(
    () => UsersListCubit(
      remoteDataSource: sl<UsersRemoteDataSource>(),
    ),
  );

  print('✅ Users List dependencies initialized');
}