import 'package:marriage/core/utils/networking/api_service.dart';
import 'package:marriage/core/utils/networking/error/AppException.dart';
import 'package:marriage/feature/myspace/data/models/ConsultantModel.dart';
import 'package:marriage/feature/myspace/data/models/ConsultationModel.dart';
import 'package:marriage/feature/myspace/domain/entities/ConsultationEntity.dart';

/// Remote data source interface
abstract class ConsultationRemoteDataSource {
  Future<List<ConsultationModel>> getConsultations();
  Future<SessionDetailsModel> getConsultationDetails(String id);
  Future<ConsultantModel> getConsultantProfile(String id);
  Future<List<TimeSlotModel>> getAvailableTimeSlots({
    required String consultantId,
    required DateTime date,
    required int duration,
  });
  Future<String> bookConsultation(Map<String, dynamic> data);
  Future<bool> rescheduleConsultation(Map<String, dynamic> data);
  Future<bool> cancelConsultation(String id);
  Future<bool> submitRating(Map<String, dynamic> data);
}

/// Remote data source implementation
class ConsultationRemoteDataSourceImpl implements ConsultationRemoteDataSource {
  final ApiClient apiClient;

  ConsultationRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ConsultationModel>> getConsultations() async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      return _getMockConsultations();
    } catch (e) {
      throw ServerException('فشل في جلب الاستشارات: ${e.toString()}');
    }
  }

  @override
  Future<SessionDetailsModel> getConsultationDetails(String id) async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      // ✅ إرجاع التفاصيل الصحيحة بناءً على الـ ID
      return _getMockSessionDetailsById(id);
    } catch (e) {
      throw ServerException('فشل في جلب تفاصيل الجلسة: ${e.toString()}');
    }
  }

  @override
  Future<ConsultantModel> getConsultantProfile(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return _getMockConsultant();
    } catch (e) {
      throw ServerException('فشل في جلب بيانات المستشار: ${e.toString()}');
    }
  }

  @override
  Future<List<TimeSlotModel>> getAvailableTimeSlots({
    required String consultantId,
    required DateTime date,
    required int duration,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      return _getMockTimeSlots();
    } catch (e) {
      throw ServerException('فشل في جلب الأوقات المتاحة: ${e.toString()}');
    }
  }

  @override
  Future<String> bookConsultation(Map<String, dynamic> data) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return 'consultation_123';
    } catch (e) {
      throw ServerException('فشل في حجز الاستشارة: ${e.toString()}');
    }
  }

  @override
  Future<bool> rescheduleConsultation(Map<String, dynamic> data) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      throw ServerException('فشل في إعادة جدولة الموعد: ${e.toString()}');
    }
  }

  @override
  Future<bool> cancelConsultation(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return true;
    } catch (e) {
      throw ServerException('فشل في إلغاء الحجز: ${e.toString()}');
    }
  }

  @override
  Future<bool> submitRating(Map<String, dynamic> data) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      return true;
    } catch (e) {
      throw ServerException('فشل في إرسال التقييم: ${e.toString()}');
    }
  }

  // ✅ Mock Data Helpers
  List<ConsultationModel> _getMockConsultations() {
    return [
      ConsultationModel(
        id: '1',
        consultantName: 'أحمد منصور',
        consultantImage: 'assets/images/profile_image.jpg',
        consultantUsername: '@fdtgsyhujkl',
        date: 'الثلاثاء، 7 فبراير',
        time: '01:00 م - 02:00 م',
        status: BookingStatus.confirmed,
        isActive: true,
        isAnonymous: false,
        duration: 60,
      ),
      ConsultationModel(
        id: '2',
        consultantName: 'محمد علي',
        consultantImage: 'assets/images/profile_image.jpg',
        consultantUsername: '@mohammed_ali',
        date: 'الأربعاء، 1 يناير',
        time: '03:00 م - 04:00 م',
        status: BookingStatus.waitingPayment,
        isActive: false,
        isAnonymous: true,
        duration: 60,
      ),
      ConsultationModel(
        id: '3',
        consultantName: 'مني زكي',
        consultantImage: 'assets/images/Ellipse.png',
        consultantUsername: '@monazaki',
        date: 'الثلاثاء، 3 مارس',
        time: '02:00 م - 03:00 م',
        status: BookingStatus.completed,
        isActive: false,
        isAnonymous: false,
        duration: 60,
      ),
    ];
  }

  // ✅ إرجاع التفاصيل الصحيحة بناءً على الـ ID
  SessionDetailsModel _getMockSessionDetailsById(String id) {
    switch (id) {
      case '1':
        return SessionDetailsModel(
          id: '1',
          consultant: ConsultantInfoModel(
            name: 'أحمد منصور',
            image: 'assets/images/profile_image.jpg',
            username: '@fdtgsyhujkl',
          ),
          status: BookingStatus.confirmed,
          sessionData: SessionDataModel(
            date: 'الثلاثاء، 7 فبراير',
            timeStart: '01:00 م',
            timeEnd: '02:00 م',
            isAnonymous: false,
          ),
          pricing: PricingModel(
            sessionPrice: 200,
            taxes: 15,
            fees: 10,
            discount: 25,
            total: 200,
          ),
          paymentMethods: [
            PaymentMethodModel(
              id: '1',
              name: 'محفظتي',
              icon: 'assets/images/wallet.svg',
            ),
            PaymentMethodModel(
              id: '2',
              name: 'ماستركارد تنتهي بـ 4567',
              icon: 'assets/images/mastercard.svg',
            ),
          ],
        );

      case '2':
        return SessionDetailsModel(
          id: '2',
          consultant: ConsultantInfoModel(
            name: 'محمد علي',
            image: 'assets/images/profile_image.jpg',
            username: '@mohammed_ali',
          ),
          status: BookingStatus.waitingPayment,
          sessionData: SessionDataModel(
            date: 'الأربعاء، 1 يناير',
            timeStart: '03:00 م',
            timeEnd: '04:00 م',
            isAnonymous: true,
          ),
          pricing: PricingModel(
            sessionPrice: 180,
            taxes: 10,
            fees: 10,
            discount: 50,
            total: 150,
          ),
          paymentMethods: [
            PaymentMethodModel(
              id: '1',
              name: 'محفظتي',
              icon: 'assets/images/wallet.svg',
            ),
          ],
        );

      case '3':
        return SessionDetailsModel(
          id: '3',
          consultant: ConsultantInfoModel(
            name: 'مني زكي',
            image: 'assets/images/Ellipse.png',
            username: '@monazaki',
          ),
          status: BookingStatus.completed,
          sessionData: SessionDataModel(
            date: 'الثلاثاء، 3 مارس',
            timeStart: '02:00 م',
            timeEnd: '03:00 م',
            isAnonymous: false,
          ),
          pricing: PricingModel(
            sessionPrice: 180,
            taxes: 10,
            fees: 10,
            discount: 40,
            total: 160,
          ),
          paymentMethods: [
            PaymentMethodModel(
              id: '1',
              name: 'محفظتي',
              icon: 'assets/images/wallet.svg',
            ),
            PaymentMethodModel(
              id: '2',
              name: 'ماستركارد تنتهي بـ 4567',
              icon: 'assets/images/mastercard.svg',
            ),
          ],
        );

      default:
        // Default case
        return SessionDetailsModel(
          id: id,
          consultant: ConsultantInfoModel(
            name: 'مستشار افتراضي',
            image: 'assets/images/profile_image.jpg',
            username: '@default',
          ),
          status: BookingStatus.confirmed,
          sessionData: SessionDataModel(
            date: 'تاريخ افتراضي',
            timeStart: '12:00 م',
            timeEnd: '01:00 م',
            isAnonymous: false,
          ),
          pricing: PricingModel(
            sessionPrice: 100,
            taxes: 5,
            fees: 5,
            discount: 0,
            total: 110,
          ),
          paymentMethods: [
            PaymentMethodModel(
              id: '1',
              name: 'محفظتي',
              icon: 'assets/images/wallet.svg',
            ),
          ],
        );
    }
  }

  ConsultantModel _getMockConsultant() {
    return ConsultantModel(
      id: '1',
      name: 'Dr. Anna Mary',
      image: 'assets/images/profile_image.jpg',
      username: '@anna_mary',
      isVerified: true,
      rating: 4.5,
      consultationsCount: 398,
      yearsOfExperience: 10,
      followersCount: 1621,
      bio: 'استشاري نفسي متخصص في العلاقات الزوجية',
      specializations: ['علاقات زوجية', 'استشارات نفسية'],
    );
  }

  List<TimeSlotModel> _getMockTimeSlots() {
    return [
      TimeSlotModel(id: '1', time: '09:00 ص', isAvailable: true),
      TimeSlotModel(id: '2', time: '10:00 ص', isAvailable: false),
      TimeSlotModel(id: '3', time: '11:00 ص', isAvailable: true),
      TimeSlotModel(id: '4', time: '12:00 م', isAvailable: false),
      TimeSlotModel(id: '5', time: '01:00 م', isAvailable: false),
      TimeSlotModel(id: '6', time: '02:00 م', isAvailable: false),
      TimeSlotModel(id: '7', time: '03:00 م', isAvailable: false),
      TimeSlotModel(id: '8', time: '04:00 م', isAvailable: true),
      TimeSlotModel(id: '9', time: '05:00 م', isAvailable: false),
    ];
  }
}