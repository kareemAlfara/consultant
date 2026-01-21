import 'package:dartz/dartz.dart';
import 'package:marriage/core/utils/networking/error/Failure.dart';
import 'package:marriage/core/usecases/usecase.dart.dart';
import 'package:marriage/feature/myspace/domain/entities/ConsultantEntity.dart';

import '../repository/ConsultationRepository .dart';

/// Use case for booking a consultation
class BookConsultationUseCase implements UseCase<String, BookingRequestEntity> {
  final ConsultationRepository repository;

  BookConsultationUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(BookingRequestEntity params) async {
    // Business logic validation
    if (params.duration != 45 && params.duration != 90) {
      return Left(ValidationFailure('مدة الجلسة يجب أن تكون 45 أو 90 دقيقة'));
    }

    if (params.date.isBefore(DateTime.now())) {
      return Left(ValidationFailure('لا يمكن حجز موعد في الماضي'));
    }

    return await repository.bookConsultation(params);
  }
}