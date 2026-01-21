import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:marriage/core/utils/services/service_locator/auth_injection.dart';
import 'package:marriage/core/widgets/Background.dart';
import 'package:marriage/feature/myspace/presentation/pages/layoutpages/Mainlayout.dart';
import '../cubit/auth_cubit.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BG(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("إنشاء حساب"),
        ),
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              Fluttertoast.showToast(
                msg: "تم إنشاء الحساب بنجاح",
                backgroundColor: Colors.green,
              );
      
              // Navigate to home
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainLayoutPage()),
              );
            } else if (state is AuthError) {
              Fluttertoast.showToast(
                msg: state.message,
                backgroundColor: Colors.red,
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<AuthCubit>();
      
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Form(
                key: cubit.signUpFormKey,
                child: Column(
                  children: [
                    SizedBox(height: 40.h),
      
                    // Name Field
                    TextFormField(
                      controller: cubit.signUpNameController,
                      decoration: InputDecoration(
                        labelText: "الاسم",
                        labelStyle: TextStyle(fontSize: 14.sp),
                        border: const OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person, size: 20.sp),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.sp),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال الاسم';
                        }
                        if (value.length < 3) {
                          return 'الاسم يجب أن يكون 3 أحرف على الأقل';
                        }
                        return null;
                      },
                    ),
      
                    SizedBox(height: 15.h),
      
                    // Email Field
                    TextFormField(
                      controller: cubit.signUpEmailController,
                      decoration: InputDecoration(
                        labelText: "البريد الإلكتروني",
                        labelStyle: TextStyle(fontSize: 14.sp),
                        border: const OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email, size: 20.sp),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.sp),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال البريد الإلكتروني';
                        }
                        if (!value.contains('@')) {
                          return 'الرجاء إدخال بريد إلكتروني صالح';
                        }
                        return null;
                      },
                    ),
      
                    SizedBox(height: 15.h),
      
                    // Phone Field
                    TextFormField(
                      controller: cubit.signUpPhoneController,
                      decoration: InputDecoration(
                        labelText: "رقم الهاتف",
                        labelStyle: TextStyle(fontSize: 14.sp),
                        border: const OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone, size: 20.sp),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.sp),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال رقم الهاتف';
                        }
                        if (value.length < 10) {
                          return 'رقم الهاتف يجب أن يكون 10 أرقام على الأقل';
                        }
                        return null;
                      },
                    ),
      
                    SizedBox(height: 15.h),
      
                    // Password Field
                    TextFormField(
                      controller: cubit.signUpPasswordController,
                      decoration: InputDecoration(
                        labelText: "كلمة المرور",
                        labelStyle: TextStyle(fontSize: 14.sp),
                        border: const OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock, size: 20.sp),
                        suffixIcon: IconButton(
                          icon: Icon(
                            cubit.isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 20.sp,
                          ),
                          onPressed: cubit.togglePasswordVisibility,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.sp),
                      obscureText: !cubit.isPasswordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال كلمة المرور';
                        }
                        if (value.length < 6) {
                          return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                        }
                        return null;
                      },
                    ),
      
                    SizedBox(height: 30.h),
      
                    // Sign Up Button
                    if (state is AuthLoading)
                      SizedBox(
                        height: 50.h,
                        child: const Center(child: CircularProgressIndicator()),
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: cubit.signUp,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            "إنشاء حساب",
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ),
                      ),
      
                    SizedBox(height: 20.h),
      
                    // Navigate to Sign In
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "لديك حساب بالفعل؟",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "تسجيل الدخول",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
// ========================================
// 📁 lib/core/di/injection_container.dart
// ========================================

final sl = GetIt.instance;

/// Initialize all app dependencies
/// Call this in main.dart before runApp()
Future<void> initDependencies() async {
  print('🔧 Initializing dependencies...');

  // Initialize Auth feature
  await initAuthDependencies();

  // TODO: Initialize other features here
  // await initProfileDependencies();
  // await initMySpaceDependencies();
  // etc.

  print('✅ Dependencies initialized successfully');
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await sl.reset();
  await initDependencies();
}
