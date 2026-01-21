import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marriage/core/widgets/Background.dart';
import 'package:marriage/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:marriage/feature/auth/presentation/pages/SignupView.dart';
import 'package:marriage/feature/myspace/presentation/pages/layoutpages/Mainlayout.dart';
import 'package:svg_flutter/svg.dart';

class SignInPage extends StatelessWidget {
  final bool isHuawei;

  const SignInPage({
    super.key,
    required this.isHuawei,
  });

  @override
  Widget build(BuildContext context) {
    return BG(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("تسجيل الدخول"),
        ),
        body: BG(
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                Fluttertoast.showToast(
                  msg: "تم تسجيل الدخول بنجاح",
                  backgroundColor: Colors.green,
                );
                
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainLayoutPage(),
                  ),
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
                  key: cubit.signInFormKey,
                  child: Column(
                    children: [
                      SizedBox(height: 40.h),
                
                      // Email Field
                      TextFormField(
                        controller: cubit.signInEmailController,
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
                
                      // Password Field
                      TextFormField(
                        controller: cubit.signInPasswordController,
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
                          return null;
                        },
                      ),
                
                      SizedBox(height: 30.h),
                
                      // Sign In Button
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
                            onPressed: cubit.signIn,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: Text(
                              "تسجيل الدخول",
                              style: TextStyle(fontSize: 16.sp),
                            ),
                          ),
                        ),
                
                      SizedBox(height: 20.h),
                
                      // Google Sign In Button (if not Huawei)
                      if (!isHuawei && state is! AuthLoading)
                        OutlinedButton.icon(
                          onPressed: cubit.signInWithGoogle,
                          icon: SvgPicture.asset(
                            "assets/images/google_icon.svg",
                            height: 24.h,
                            width: 24.w,
                          
                          ),
                          label: Text(
                            "تسجيل الدخول بواسطة Google",
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        ),
                
                      SizedBox(height: 20.h),
                
                      // Navigate to Sign Up
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "ليس لديك حساب؟",
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpPage(),
                                ),
                              );
                            },
                            child: Text(
                              "إنشاء حساب",
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
      ),
    );
  }
}