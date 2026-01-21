import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marriage/feature/myspace/presentation/cubit/SessionDetailscubit/session_details_state.dart';

import '../../../domain/repository/ConsultationRepository .dart';

/// Cubit for managing session details
class SessionDetailsCubit extends Cubit<SessionDetailsState> {
  final ConsultationRepository repository;

  SessionDetailsCubit({required this.repository}) 
      : super(SessionDetailsInitial());

  /// Fetch session details
  Future<void> fetchSessionDetails(String consultationId) async {
    emit(SessionDetailsLoading());

    final result = await repository.getConsultationDetails(consultationId);

    result.fold(
      (failure) => emit(SessionDetailsError(failure.message)),
      (session) => emit(SessionDetailsLoaded(session)),
    );
  }
}
