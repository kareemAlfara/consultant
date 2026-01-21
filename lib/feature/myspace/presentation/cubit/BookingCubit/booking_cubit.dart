import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marriage/feature/myspace/domain/entities/ConsultantEntity.dart';

import '../../../domain/repository/ConsultationRepository .dart';
import '../../../domain/usecases/BookConsultationUseCase .dart';
import 'booking_state.dart';

/// Cubit for managing booking process
/// Single Responsibility: Only handles booking/rescheduling
class BookingCubit extends Cubit<BookingState> {
  final BookConsultationUseCase bookConsultationUseCase;
  final ConsultationRepository repository;

  BookingCubit({
    required this.bookConsultationUseCase,
    required this.repository,
  }) : super(BookingInitial());

  /// Fetch available time slots for selected date and duration
  Future<void> fetchAvailableTimeSlots({
    required String consultantId,
    required DateTime date,
    required int duration,
  }) async {
    emit(BookingLoadingSlots());

    final result = await repository.getAvailableTimeSlots(
      consultantId: consultantId,
      date: date,
      duration: duration,
    );

    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (timeSlots) => emit(BookingSlotsLoaded(timeSlots)),
    );
  }

  /// Book a consultation
  Future<void> bookConsultation({
    required String consultantId,
    required DateTime date,
    required String timeSlotId,
    required int duration,
    required bool isAnonymous,
  }) async {
    emit(BookingInProgress());

    final request = BookingRequestEntity(
      consultantId: consultantId,
      date: date,
      timeSlotId: timeSlotId,
      duration: duration,
      isAnonymous: isAnonymous,
    );

    final result = await bookConsultationUseCase(request);

    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (consultationId) => emit(BookingSuccess(
        consultationId: consultationId,
        message: 'تم حجز الاستشارة بنجاح',
      )),
    );
  }

  /// Reschedule existing consultation
  Future<void> rescheduleConsultation({
    required String consultationId,
    required DateTime newDate,
    required String newTimeSlotId,
  }) async {
    emit(BookingInProgress());

    final result = await repository.rescheduleConsultation(
      consultationId: consultationId,
      newDate: newDate,
      newTimeSlotId: newTimeSlotId,
    );

    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (_) => emit(const BookingSuccess(
        consultationId: '',
        message: 'تم إعادة جدولة الموعد بنجاح',
      )),
    );
  }

  /// Cancel consultation
  Future<void> cancelConsultation(String consultationId) async {
    emit(BookingInProgress());

    final result = await repository.cancelConsultation(consultationId);

    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (_) => emit(const BookingSuccess(
        consultationId: '',
        message: 'تم إلغاء الحجز بنجاح',
      )),
    );
  }

  /// Reset state
  void reset() {
    emit(BookingInitial());
  }
}