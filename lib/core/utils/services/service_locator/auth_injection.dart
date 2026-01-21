// ========================================
// 📁 lib/feature/auth/di/auth_di.dart
// ========================================
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:marriage/feature/auth/data/auth_local_data_source.dart';
import 'package:marriage/feature/auth/data/auth_remote_data_source.dart';
import 'package:marriage/feature/auth/presentation/cubit/auth_cubit.dart';

final sl = GetIt.instance;

/// Initialize all authentication dependencies
Future<void> initAuthDependencies() async {
  // ========================================
  // 🔥 FIREBASE INSTANCES
  // ========================================
  sl.registerLazySingleton<FirebaseAuth>(
    () => FirebaseAuth.instance,
  );

  sl.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  sl.registerLazySingleton<GoogleSignIn>(
    () => GoogleSignIn(),
  );

  // ========================================
  // 💾 DATA SOURCES
  // ========================================
  
  // Local Data Source
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(),
  );

  // Remote Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(
      auth: sl<FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
      googleSignIn: sl<GoogleSignIn>(),
    ),
  );

  // ========================================
  // 🎯 CUBIT (Factory - new instance each time)
  // ========================================
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
    ),
  );
}

/// Reset all auth dependencies (useful for testing or logout)
Future<void> resetAuthDependencies() async {
  if (sl.isRegistered<AuthCubit>()) {
    await sl.unregister<AuthCubit>();
  }
  
  // Re-register the factory
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
    ),
  );
}