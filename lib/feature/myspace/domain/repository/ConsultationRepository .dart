import 'package:dartz/dartz.dart';
import 'package:marriage/core/utils/networking/error/Failure.dart';
import 'package:marriage/feature/myspace/domain/entities/ConsultantEntity.dart';
import 'package:marriage/feature/myspace/domain/entities/ConsultationEntity.dart';


/// Repository interface - Domain layer doesn't know about implementation
abstract class ConsultationRepository {
  /// Get list of consultations
  Future<Either<Failure, List<ConsultationEntity>>> getConsultations();

  /// Get consultation details
  Future<Either<Failure, SessionDetailsEntity>> getConsultationDetails(String id);

  /// Get consultant profile
  Future<Either<Failure, ConsultantEntity>> getConsultantProfile(String id);

  /// Get available time slots for a consultant
  Future<Either<Failure, List<TimeSlotEntity>>> getAvailableTimeSlots({
    required String consultantId,
    required DateTime date,
    required int duration,
  });

  /// Book a consultation
  Future<Either<Failure, String>> bookConsultation(BookingRequestEntity request);

  /// Reschedule a consultation
  Future<Either<Failure, bool>> rescheduleConsultation({
    required String consultationId,
    required DateTime newDate,
    required String newTimeSlotId,
  });

  /// Cancel a consultation
  Future<Either<Failure, bool>> cancelConsultation(String consultationId);

  /// Submit rating
  Future<Either<Failure, bool>> submitRating(RatingRequestEntity rating);
}