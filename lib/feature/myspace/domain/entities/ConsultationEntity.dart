import 'package:equatable/equatable.dart';

enum BookingStatus { 
  completed, 
  cancelled, 
  confirmed, 
  waitingPayment 
}
// علشان سجل الجلسات
/// Pure domain entity - no dependencies
class ConsultationEntity extends Equatable {
  final String id;
  final String consultantName;
  final String consultantImage;
  final String consultantUsername;
  final String date;
  final String time;
  final BookingStatus status;
  final bool isActive;
  final bool isAnonymous;
  final int duration; // in minutes

  const ConsultationEntity({
    required this.id,
    required this.consultantName,
    required this.consultantImage,
    required this.consultantUsername,
    required this.date,
    required this.time,
    required this.status,
    required this.isActive,
    required this.isAnonymous,
    required this.duration,
  });

  @override
  List<Object?> get props => [
        id,
        consultantName,
        consultantImage,
        consultantUsername,
        date,
        time,
        status,
        isActive,
        isAnonymous,
        duration,
      ];
}
// تفاصيل الجلسة
/// Session details entity
class SessionDetailsEntity extends Equatable {
  final String id;
  final ConsultantInfoEntity consultant;
  final BookingStatus status;
  final SessionDataEntity sessionData;
  final PricingEntity pricing;
  final List<PaymentMethodEntity> paymentMethods;

  const SessionDetailsEntity({
    required this.id,
    required this.consultant,
    required this.status,
    required this.sessionData,
    required this.pricing,
    required this.paymentMethods,
  });

  @override
  List<Object?> get props => [
        id,
        consultant,
        status,
        sessionData,
        pricing,
        paymentMethods,
      ];
}
//  جزء بيانات الشخص في تفاصيل الجلسة
/// Consultant basic info
class ConsultantInfoEntity extends Equatable {
  final String name;
  final String image;
  final String username;

  const ConsultantInfoEntity({
    required this.name,
    required this.image,
    required this.username,
  });

  @override
  List<Object?> get props => [name, image, username];
}
//  جزء بيانات الجلسة في تفاصيل الجلسة

/// Session data
class SessionDataEntity extends Equatable {
  final String date;
  final String timeStart;
  final String timeEnd;
  final bool isAnonymous;

  const SessionDataEntity({
    required this.date,
    required this.timeStart,
    required this.timeEnd,
    required this.isAnonymous,
  });

  @override
  List<Object?> get props => [date, timeStart, timeEnd, isAnonymous];
}

/// Pricing details
class PricingEntity extends Equatable {
  final double sessionPrice;
  final double taxes;
  final double fees;
  final double discount;
  final double total;

  const PricingEntity({
    required this.sessionPrice,
    required this.taxes,
    required this.fees,
    required this.discount,
    required this.total,
  });

  @override
  List<Object?> get props => [sessionPrice, taxes, fees, discount, total];
}

/// Payment method
class PaymentMethodEntity extends Equatable {
  final String id;
  final String name;
  final String icon;

  const PaymentMethodEntity({
    required this.id,
    required this.name,
    required this.icon,
  });

  @override
  List<Object?> get props => [id, name, icon];
}