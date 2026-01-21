import 'package:equatable/equatable.dart';
import 'package:marriage/feature/myspace/domain/entities/ConsultantEntity.dart';

/// States for booking process
abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class BookingInitial extends BookingState {}

/// Loading available time slots
class BookingLoadingSlots extends BookingState {}

/// Time slots loaded
class BookingSlotsLoaded extends BookingState {
  final List<TimeSlotEntity> timeSlots;

  const BookingSlotsLoaded(this.timeSlots);

  @override
  List<Object?> get props => [timeSlots];
}

/// Booking in progress
class BookingInProgress extends BookingState {}

/// Booking successful
class BookingSuccess extends BookingState {
  final String consultationId;
  final String message;

  const BookingSuccess({
    required this.consultationId,
    required this.message,
  });

  @override
  List<Object?> get props => [consultationId, message];
}

/// Booking failed
class BookingError extends BookingState {
  final String message;

  const BookingError(this.message);

  @override
  List<Object?> get props => [message];
}