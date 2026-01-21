import 'package:equatable/equatable.dart';

/// Consultant full profile entity
class ConsultantEntity extends Equatable {
  final String id;
  final String name;
  final String image;
  final String username;
  final bool isVerified;
  final double rating;
  final int consultationsCount;
  final int yearsOfExperience;
  final int followersCount;
  final String bio;
  final List<String> specializations;

  const ConsultantEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.username,
    required this.isVerified,
    required this.rating,
    required this.consultationsCount,
    required this.yearsOfExperience,
    required this.followersCount,
    required this.bio,
    required this.specializations,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        image,
        username,
        isVerified,
        rating,
        consultationsCount,
        yearsOfExperience,
        followersCount,
        bio,
        specializations,
      ];
}

/// Available time slot
class TimeSlotEntity extends Equatable {
  final String id;
  final String time;
  final bool isAvailable;

  const TimeSlotEntity({
    required this.id,
    required this.time,
    required this.isAvailable,
  });

  @override
  List<Object?> get props => [id, time, isAvailable];
}

/// Booking request
class BookingRequestEntity extends Equatable {
  final String consultantId;
  final DateTime date;
  final String timeSlotId;
  final int duration; // 45 or 90 minutes
  final bool isAnonymous;
  final String? notes;

  const BookingRequestEntity({
    required this.consultantId,
    required this.date,
    required this.timeSlotId,
    required this.duration,
    required this.isAnonymous,
    this.notes,
  });

  @override
  List<Object?> get props => [
        consultantId,
        date,
        timeSlotId,
        duration,
        isAnonymous,
        notes,
      ];
}

/// Rating request
class RatingRequestEntity extends Equatable {
  final String consultationId;
  final int rating; // 1-5
  final String comment;

  const RatingRequestEntity({
    required this.consultationId,
    required this.rating,
    required this.comment,
  });

  @override
  List<Object?> get props => [consultationId, rating, comment];
}