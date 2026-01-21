import 'package:marriage/feature/myspace/domain/entities/ConsultationEntity.dart';


/// Consultation Model - extends Entity and adds JSON serialization
class ConsultationModel extends ConsultationEntity {
  const ConsultationModel({
    required super.id,
    required super.consultantName,
    required super.consultantImage,
    required super.consultantUsername,
    required super.date,
    required super.time,
    required super.status,
    required super.isActive,
    required super.isAnonymous,
    required super.duration,
  });

  /// From JSON
  factory ConsultationModel.fromJson(Map<String, dynamic> json) {
    return ConsultationModel(
      id: json['id'] ?? '',
      consultantName: json['consultant_name'] ?? '',
      consultantImage: json['consultant_image'] ?? '',
      consultantUsername: json['consultant_username'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      status: _parseStatus(json['status']),
      isActive: json['is_active'] ?? false,
      isAnonymous: json['is_anonymous'] ?? false,
      duration: json['duration'] ?? 60,
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'consultant_name': consultantName,
      'consultant_image': consultantImage,
      'consultant_username': consultantUsername,
      'date': date,
      'time': time,
      'status': _statusToString(status),
      'is_active': isActive,
      'is_anonymous': isAnonymous,
      'duration': duration,
    };
  }

  /// Parse status from string
  static BookingStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
        return BookingStatus.cancelled;
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'waiting_payment':
        return BookingStatus.waitingPayment;
      default:
        return BookingStatus.cancelled;
    }
  }

  /// Convert status to string
  static String _statusToString(BookingStatus status) {
    switch (status) {
      case BookingStatus.completed:
        return 'completed';
      case BookingStatus.cancelled:
        return 'cancelled';
      case BookingStatus.confirmed:
        return 'confirmed';
      case BookingStatus.waitingPayment:
        return 'waiting_payment';
    }
  }

  /// Copy with method
  ConsultationModel copyWith({
    String? id,
    String? consultantName,
    String? consultantImage,
    String? consultantUsername,
    String? date,
    String? time,
    BookingStatus? status,
    bool? isActive,
    bool? isAnonymous,
    int? duration,
  }) {
    return ConsultationModel(
      id: id ?? this.id,
      consultantName: consultantName ?? this.consultantName,
      consultantImage: consultantImage ?? this.consultantImage,
      consultantUsername: consultantUsername ?? this.consultantUsername,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      isActive: isActive ?? this.isActive,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      duration: duration ?? this.duration,
    );
  }
}

/// Session Details Model
class SessionDetailsModel extends SessionDetailsEntity {
  const SessionDetailsModel({
    required super.id,
    required ConsultantInfoModel super.consultant,
    required super.status,
    required SessionDataModel super.sessionData,
    required PricingModel super.pricing,
    required List<PaymentMethodModel> super.paymentMethods,
  });

  factory SessionDetailsModel.fromJson(Map<String, dynamic> json) {
    return SessionDetailsModel(
      id: json['id'] ?? '',
      consultant: ConsultantInfoModel.fromJson(json['consultant'] ?? {}),
      status: ConsultationModel._parseStatus(json['status']),
      sessionData: SessionDataModel.fromJson(json['session_data'] ?? {}),
      pricing: PricingModel.fromJson(json['pricing'] ?? {}),
      paymentMethods: (json['payment_methods'] as List?)
              ?.map((e) => PaymentMethodModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'consultant': (consultant as ConsultantInfoModel).toJson(),
      'status': ConsultationModel._statusToString(status),
      'session_data': (sessionData as SessionDataModel).toJson(),
      'pricing': (pricing as PricingModel).toJson(),
      'payment_methods':
          paymentMethods.map((e) => (e as PaymentMethodModel).toJson()).toList(),
    };
  }
}

/// Consultant Info Model
class ConsultantInfoModel extends ConsultantInfoEntity {
  const ConsultantInfoModel({
    required super.name,
    required super.image,
    required super.username,
  });

  factory ConsultantInfoModel.fromJson(Map<String, dynamic> json) {
    return ConsultantInfoModel(
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      username: json['username'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'username': username,
    };
  }
}

/// Session Data Model
class SessionDataModel extends SessionDataEntity {
  const SessionDataModel({
    required super.date,
    required super.timeStart,
    required super.timeEnd,
    required super.isAnonymous,
  });

  factory SessionDataModel.fromJson(Map<String, dynamic> json) {
    return SessionDataModel(
      date: json['date'] ?? '',
      timeStart: json['time_start'] ?? '',
      timeEnd: json['time_end'] ?? '',
      isAnonymous: json['is_anonymous'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'time_start': timeStart,
      'time_end': timeEnd,
      'is_anonymous': isAnonymous,
    };
  }
}

/// Pricing Model
class PricingModel extends PricingEntity {
  const PricingModel({
    required super.sessionPrice,
    required super.taxes,
    required super.fees,
    required super.discount,
    required super.total,
  });

  factory PricingModel.fromJson(Map<String, dynamic> json) {
    return PricingModel(
      sessionPrice: (json['session_price'] ?? 0).toDouble(),
      taxes: (json['taxes'] ?? 0).toDouble(),
      fees: (json['fees'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_price': sessionPrice,
      'taxes': taxes,
      'fees': fees,
      'discount': discount,
      'total': total,
    };
  }
}

/// Payment Method Model
class PaymentMethodModel extends PaymentMethodEntity {
  const PaymentMethodModel({
    required super.id,
    required super.name,
    required super.icon,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }
}