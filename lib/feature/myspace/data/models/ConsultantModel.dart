import 'package:marriage/feature/myspace/domain/entities/ConsultantEntity.dart';

// علشان بيانات المستشار
/// Consultant Model
class ConsultantModel extends ConsultantEntity {
  const ConsultantModel({
    required super.id,
    required super.name,
    required super.image,
    required super.username,
    required super.isVerified,
    required super.rating,
    required super.consultationsCount,
    required super.yearsOfExperience,
    required super.followersCount,
    required super.bio,
    required super.specializations,
  });

  factory ConsultantModel.fromJson(Map<String, dynamic> json) {
    return ConsultantModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      username: json['username'] ?? '',
      isVerified: json['is_verified'] ?? false,
      rating: (json['rating'] ?? 0.0).toDouble(),
      consultationsCount: json['consultations_count'] ?? 0,
      yearsOfExperience: json['years_of_experience'] ?? 0,
      followersCount: json['followers_count'] ?? 0,
      bio: json['bio'] ?? '',
      specializations: List<String>.from(json['specializations'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'username': username,
      'is_verified': isVerified,
      'rating': rating,
      'consultations_count': consultationsCount,
      'years_of_experience': yearsOfExperience,
      'followers_count': followersCount,
      'bio': bio,
      'specializations': specializations,
    };
  }
}

/// Time Slot Model
class TimeSlotModel extends TimeSlotEntity {
  const TimeSlotModel({
    required super.id,
    required super.time,
    required super.isAvailable,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      id: json['id'] ?? '',
      time: json['time'] ?? '',
      isAvailable: json['is_available'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time,
      'is_available': isAvailable,
    };
  }
}

/// Booking Request Model
class BookingRequestModel {
  final String consultantId;
  final String date;
  final String timeSlotId;
  final int duration;
  final bool isAnonymous;
  final String? notes;

  BookingRequestModel({
    required this.consultantId,
    required this.date,
    required this.timeSlotId,
    required this.duration,
    required this.isAnonymous,
    this.notes,
  });

  factory BookingRequestModel.fromEntity(BookingRequestEntity entity) {
    return BookingRequestModel(
      consultantId: entity.consultantId,
      date: entity.date.toIso8601String(),
      timeSlotId: entity.timeSlotId,
      duration: entity.duration,
      isAnonymous: entity.isAnonymous,
      notes: entity.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'consultant_id': consultantId,
      'date': date,
      'time_slot_id': timeSlotId,
      'duration': duration,
      'is_anonymous': isAnonymous,
      'notes': notes,
    };
  }
}

/// Rating Request Model
class RatingRequestModel {
  final String consultationId;
  final int rating;
  final String comment;

  RatingRequestModel({
    required this.consultationId,
    required this.rating,
    required this.comment,
  });

  factory RatingRequestModel.fromEntity(RatingRequestEntity entity) {
    return RatingRequestModel(
      consultationId: entity.consultationId,
      rating: entity.rating,
      comment: entity.comment,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'consultation_id': consultationId,
      'rating': rating,
      'comment': comment,
    };
  }
}