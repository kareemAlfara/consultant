
import 'package:dartz/dartz.dart';
import 'package:marriage/core/utils/networking/error/Failure.dart';
import 'package:marriage/core/usecases/usecase.dart.dart';
import 'package:marriage/feature/myspace/domain/entities/ConsultationEntity.dart';

import '../repository/ConsultationRepository .dart';

/// Use case for getting consultations list
/// Single Responsibility: Only handles getting consultations
class GetConsultationsUseCase implements UseCase<List<ConsultationEntity>, NoParams> {
  final ConsultationRepository repository;

  GetConsultationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ConsultationEntity>>> call(NoParams params) async {
    return await repository.getConsultations();
  }
}