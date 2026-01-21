
import 'package:get_it/get_it.dart';
import 'package:marriage/core/utils/networking/api_service.dart';
import 'package:marriage/feature/myspace/data/datasources/local/local.dart';
import 'package:marriage/feature/myspace/data/datasources/remote/consultation_remote_datasource.dart';
import 'package:marriage/feature/myspace/presentation/cubit/BookingCubit/booking_cubit.dart';
import 'package:marriage/feature/myspace/presentation/cubit/ConsultationCubit/consultation_cubit.dart';
import 'package:marriage/feature/myspace/presentation/cubit/Ratingcubit/rating_cubit.dart';
import 'package:marriage/feature/myspace/presentation/cubit/SessionDetailscubit/session_details_cubit.dart';
import 'package:http/http.dart' as http;
import '../../../../feature/myspace/data/repository/ConsultationRepositoryImpl .dart';
import '../../../../feature/myspace/domain/repository/ConsultationRepository .dart';
import '../../../../feature/myspace/domain/usecases/BookConsultationUseCase .dart';
import '../../../../feature/myspace/domain/usecases/GetConsultationsUseCase .dart';
import '../../../../feature/myspace/domain/usecases/SubmitRatingUseCase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - MySpace
  
  // Cubits
  sl.registerFactory(
    () => ConsultationCubit(
      getConsultationsUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => BookingCubit(
      bookConsultationUseCase: sl(),
      repository: sl(),
    ),
  );

  sl.registerFactory(
    () => RatingCubit(
      submitRatingUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => SessionDetailsCubit(
      repository: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetConsultationsUseCase(sl()));
  sl.registerLazySingleton(() => BookConsultationUseCase(sl()));
  sl.registerLazySingleton(() => SubmitRatingUseCase(sl()));

  // Repository
  sl.registerLazySingleton<ConsultationRepository>(
    () => ConsultationRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ConsultationRemoteDataSource>(
    () => ConsultationRemoteDataSourceImpl(apiClient: sl()),
  );

  sl.registerLazySingleton<ConsultationLocalDataSource>(
    () => ConsultationLocalDataSourceImpl(),
  );

  //! Core
  sl.registerLazySingleton(() => ApiClient(client: sl()));

  //! External
  sl.registerLazySingleton(() => http.Client());
}