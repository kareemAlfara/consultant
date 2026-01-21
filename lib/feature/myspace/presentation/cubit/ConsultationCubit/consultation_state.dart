import 'package:marriage/core/utils/enums/enums_state.dart';
import 'package:marriage/feature/myspace/domain/entities/ConsultationEntity.dart';

/// States for consultation list
class ConsultationState {
  final ConsultationStatusEnum status;
  // final List<ConsultationEntity> consultations;
    final List<ConsultationEntity> activeConsultations;
  final List<ConsultationEntity> previousConsultations;
  final String? errorMessage;

  ConsultationState({
     this.status=ConsultationStatusEnum.initial,
     this.activeConsultations=const [],
     this.previousConsultations=const [],
     this.errorMessage,
  });
  
ConsultationState copyWith({
 ConsultationStatusEnum? status,
    List<ConsultationEntity>? activeConsultations,
    List<ConsultationEntity>? previousConsultations,
    String? errorMessage,
}){
  return ConsultationState(
      status: status ?? this.status,
      previousConsultations: previousConsultations ?? this.previousConsultations,
      activeConsultations: activeConsultations ?? this.activeConsultations,
      errorMessage: errorMessage ?? this.errorMessage,
    );
}

}

// /// Initial state
// class ConsultationInitial extends ConsultationState {}

// /// Loading consultations
// class ConsultationLoading extends ConsultationState {}

// /// Consultations loaded successfully
// class ConsultationLoaded extends ConsultationState {
//   final List<ConsultationEntity> activeConsultations;
//   final List<ConsultationEntity> previousConsultations;

//   const ConsultationLoaded({
//     required this.activeConsultations,
//     required this.previousConsultations,
//   });

//   @override
//   List<Object?> get props => [activeConsultations, previousConsultations];
// }

// /// Empty state (no consultations)
// class ConsultationEmpty extends ConsultationState {}

// /// Error state
// class ConsultationError extends ConsultationState {
//   final String message;

//   const ConsultationError(this.message);

//   @override
//   List<Object?> get props => [message];
// }
