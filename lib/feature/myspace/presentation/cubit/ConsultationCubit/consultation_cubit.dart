import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marriage/core/usecases/usecase.dart.dart';
import 'package:marriage/core/utils/enums/enums_state.dart';
import 'package:marriage/feature/myspace/presentation/cubit/ConsultationCubit/consultation_state.dart';

import '../../../domain/usecases/GetConsultationsUseCase .dart';

/// Cubit for managing consultations list
/// Single Responsibility: Only handles consultation list state
class ConsultationCubit extends Cubit<ConsultationState> {
  final GetConsultationsUseCase getConsultationsUseCase;

  ConsultationCubit({required this.getConsultationsUseCase})
    : super(ConsultationState());

  /// Fetch consultations from repository
  Future<void> fetchConsultations() async {
    emit(state.copyWith(status: ConsultationStatusEnum.loading));

    final result = await getConsultationsUseCase(NoParams());
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ConsultationStatusEnum.error,
            errorMessage: failure.message,
          ),
        );
      },
      (consultations) {
        if (consultations.isEmpty) {
          emit(state.copyWith(status: ConsultationStatusEnum.empty));
        } else {
          // Separate active and previous consultations
          final active = consultations.where((c) => c.isActive).toList();
          final previous = consultations.where((c) => !c.isActive).toList();
          emit(
            state.copyWith(
              status: ConsultationStatusEnum.success,
              activeConsultations: active,
              previousConsultations: previous,
            ),
          );
        }
      },
    );
  }

  /// Refresh consultations
  Future<void> refreshConsultations() async {
    await fetchConsultations();
  }
}
