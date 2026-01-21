import 'package:marriage/core/utils/enums/enums_state.dart';

/// Rating states
 class RatingState {
  final RatingEnum status;
  final String? errorMessage;
  final String? successMessage;

  RatingState({
    this.status = RatingEnum.initial,
    this.errorMessage,
    this.successMessage,
  });
  RatingState copyWith({
    RatingEnum? status,
    String? errorMessage,
    String? successMesage,
  }) {
    return RatingState(
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      successMessage: successMesage ?? successMessage,
    );
  }
}

