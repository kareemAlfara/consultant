import 'package:dartz/dartz.dart';
import 'package:marriage/core/utils/networking/error/Failure.dart';
import 'package:marriage/core/usecases/usecase.dart.dart';

import '../entities/ConsultantEntity.dart';
import '../repository/ConsultationRepository .dart';

/// Use case for submitting consultation rating
class SubmitRatingUseCase implements UseCase<bool, RatingRequestEntity> {
  final ConsultationRepository repository;

  SubmitRatingUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(RatingRequestEntity params) async {
    // Business logic validation
    if (params.rating < 1 || params.rating > 5) {
      return Left(ValidationFailure('التقييم يجب أن يكون بين 1 و 5'));
    }

    if (params.comment.trim().isEmpty) {
      return Left(ValidationFailure('يرجى كتابة تعليق'));
    }

    if (params.comment.length < 10) {
      return Left(ValidationFailure('التعليق يجب أن يكون 10 أحرف على الأقل'));
    }

    return await repository.submitRating(params);
  }
}