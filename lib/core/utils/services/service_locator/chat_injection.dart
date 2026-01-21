// ========================================
// 📁 lib/core/utils/services/service_locator/chat_injection.dart
// ========================================
import 'package:get_it/get_it.dart';
import 'package:marriage/feature/chating/data/datasource/chat_remote_data_source.dart';
import 'package:marriage/feature/chating/presentation/cubit/chatcubit.dart';

final sl = GetIt.instance;

Future<void> initChatDependencies() async {
  print('🔧 Initializing Chat dependencies...');

  // ========================================
  // 📦 DATA SOURCES
  // ========================================
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSource(),
  );

  // ========================================
  // 📦 CUBITS
  // ========================================
  sl.registerFactory<ChatCubit>(
    () => ChatCubit(
      remoteDataSource: sl<ChatRemoteDataSource>(),
    ),
  );

  print('✅ Chat dependencies initialized');
}

