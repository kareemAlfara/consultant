import 'package:dartz/dartz.dart';
import 'package:marriage/core/utils/networking/error/Failure.dart';
/// Base class for all use cases
/// Type: Return type
/// Params: Parameters needed for the use case
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use case with no parameters
class NoParams {
  const NoParams();
}