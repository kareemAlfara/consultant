import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marriage/core/utils/enums/enums_state.dart';
import 'package:marriage/feature/myspace/domain/usecases/SubmitRatingUseCase.dart';
import 'package:marriage/feature/myspace/presentation/cubit/Ratingcubit/rating_state.dart';

import '../../../domain/entities/ConsultantEntity.dart';

/// Cubit for managing rating submission
class RatingCubit extends Cubit<RatingState> {
  final SubmitRatingUseCase submitRatingUseCase;

  RatingCubit({required this.submitRatingUseCase}) : super(RatingState());

  /// Submit rating for consultation
  Future<void> submitRating({
    required String consultationId,
    required int rating,
    required String comment,
  }) async {
    emit(state.copyWith(status: RatingEnum.loading));
    final request = RatingRequestEntity(
      consultationId: consultationId,
      rating: rating,
      comment: comment,
    );

    final result = await submitRatingUseCase(request);

    result.fold(
      (failure) => emit(state.copyWith(status: RatingEnum.error,errorMessage:failure.message)),
      (_) => emit( state.copyWith(status: RatingEnum.success,successMesage:'تم إرسال التقييم بنجاح' ) ),
    );
  }

  /// Reset state
  void reset() {
    emit(state.copyWith(status: RatingEnum.initial));
  }
}
