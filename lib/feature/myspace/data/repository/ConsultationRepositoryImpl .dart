import 'package:dartz/dartz.dart';
import 'package:marriage/core/utils/networking/error/AppException.dart';
import 'package:marriage/core/utils/networking/error/Failure.dart';
import 'package:marriage/feature/myspace/data/models/ConsultantModel.dart';
import 'package:marriage/feature/myspace/data/models/ConsultationModel.dart';
import 'package:marriage/feature/myspace/domain/entities/ConsultantEntity.dart';
import 'package:marriage/feature/myspace/domain/entities/ConsultationEntity.dart';

import '../../domain/repository/ConsultationRepository .dart';
import '../datasources/local/local.dart';
import '../datasources/remote/consultation_remote_datasource.dart';

/// Repository Implementation - Implements domain repository interface
/// Handles data flow between data sources and domain layer
class ConsultationRepositoryImpl implements ConsultationRepository {
  final ConsultationRemoteDataSource remoteDataSource;
  final ConsultationLocalDataSource localDataSource;

  ConsultationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<ConsultationEntity>>> getConsultations() async {
    try {
      // Try to get data from remote
      final consultations = await remoteDataSource.getConsultations();
      
      // Cache the data locally
      await localDataSource.cacheConsultations(
        consultations.map((e) => e.toJson()).toList(),
      );
      
      return Right(consultations);
    } on ServerException catch (e) {
      // If server fails, try to get cached data
      try {
        final cachedData = await localDataSource.getCachedConsultations();
        if (cachedData != null && cachedData.isNotEmpty) {
          // Return cached data
          return Right(
            cachedData.map((json) => ConsultationModel.fromJson(json)).toList(),
          );
        }
      } catch (_) {}
      
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('حدث خطأ غير متوقع: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, SessionDetailsEntity>> getConsultationDetails(
    String id,
  ) async {
    try {
      final details = await remoteDataSource.getConsultationDetails(id);
      return Right(details);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('حدث خطأ غير متوقع: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ConsultantEntity>> getConsultantProfile(
    String id,
  ) async {
    try {
      final consultant = await remoteDataSource.getConsultantProfile(id);
      return Right(consultant);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('حدث خطأ غير متوقع: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<TimeSlotEntity>>> getAvailableTimeSlots({
    required String consultantId,
    required DateTime date,
    required int duration,
  }) async {
    try {
      final timeSlots = await remoteDataSource.getAvailableTimeSlots(
        consultantId: consultantId,
        date: date,
        duration: duration,
      );
      return Right(timeSlots);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('حدث خطأ غير متوقع: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> bookConsultation(
    BookingRequestEntity request,
  ) async {
    try {
      // Convert entity to model
      final model = BookingRequestModel.fromEntity(request);
      
      // Make API call
      final consultationId = await remoteDataSource.bookConsultation(
        model.toJson(),
      );
      
      return Right(consultationId);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('حدث خطأ غير متوقع: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> rescheduleConsultation({
    required String consultationId,
    required DateTime newDate,
    required String newTimeSlotId,
  }) async {
    try {
      final success = await remoteDataSource.rescheduleConsultation({
        'consultation_id': consultationId,
        'new_date': newDate.toIso8601String(),
        'new_time_slot_id': newTimeSlotId,
      });
      
      // Clear cache to force refresh
      await localDataSource.clearCache();
      
      return Right(success);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('حدث خطأ غير متوقع: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> cancelConsultation(String consultationId) async {
    try {
      final success = await remoteDataSource.cancelConsultation(consultationId);
      
      // Clear cache to force refresh
      await localDataSource.clearCache();
      
      return Right(success);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('حدث خطأ غير متوقع: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> submitRating(RatingRequestEntity rating) async {
    try {
      // Convert entity to model
      final model = RatingRequestModel.fromEntity(rating);
      
      // Make API call
      final success = await remoteDataSource.submitRating(model.toJson());
      
      return Right(success);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('حدث خطأ غير متوقع: ${e.toString()}'));
    }
  }
}