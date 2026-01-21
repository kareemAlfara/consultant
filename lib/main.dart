import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marriage/core/utils/constants/keys.dart';
import 'package:marriage/core/utils/services/service_locator/chat_injection.dart';
import 'package:marriage/core/utils/services/service_locator/users_injection.dart' hide sl;
import 'package:marriage/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:marriage/feature/auth/presentation/pages/SigninView.dart';
import 'package:marriage/feature/auth/presentation/pages/SignupView.dart' hide sl;
import 'package:marriage/core/utils/services/service_locator/di.dart' as di;
import 'feature/myspace/presentation/cubit/BookingCubit/booking_cubit.dart';
import 'feature/myspace/presentation/cubit/ConsultationCubit/consultation_cubit.dart';
import 'feature/myspace/presentation/cubit/Ratingcubit/rating_cubit.dart';
import 'feature/myspace/presentation/cubit/SessionDetailscubit/session_details_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Initialize dependency injection
  await di.init();
  await initDependencies();
   await initChatDependencies();
    await initUsersListDependencies(); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
           BlocProvider<AuthCubit>(
          create: (_) => sl<AuthCubit>()..getCurrentUser(),
        ),
        
        // Consultation Cubit - for consultations list
        BlocProvider<ConsultationCubit>(
          create: (context) => di.sl<ConsultationCubit>()..fetchConsultations(),
        ),
        // BlocProvider<AuthCubit>(
        //   create: (_) => sl<AuthCubit>()..getCurrentUser(),
        // ),
        // Booking Cubit - for booking and rescheduling
        BlocProvider<BookingCubit>(create: (context) => di.sl<BookingCubit>()),

        // Rating Cubit - for submitting ratings
        BlocProvider<RatingCubit>(create: (context) => di.sl<RatingCubit>()),

        // Session Details Cubit - for session details
        BlocProvider<SessionDetailsCubit>(
          create: (context) => di.sl<SessionDetailsCubit>(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(430, 932),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,

            // Localization
            localizationsDelegates: const [
              // S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            // supportedLocales: S.delegate.supportedLocales,
            supportedLocales: [Locale('ar')],
            locale: const Locale('ar'),

            // Theme
            theme: ThemeData(
              fontFamily: Keys.TextFontfamily,
              useMaterial3: true,
            ),

            // Home page - change based on your logic
            home: SignInPage(isHuawei: false,),
          );
        },
      ),
    );
  }
}
