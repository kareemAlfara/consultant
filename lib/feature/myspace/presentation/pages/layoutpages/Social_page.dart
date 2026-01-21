import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marriage/core/widgets/Background.dart';
import 'package:marriage/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:marriage/feature/auth/presentation/pages/SigninView.dart';

class SocialPage extends StatelessWidget {
  const SocialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BG(
        child: Center(
          child: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthUnauthenticated) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SignInPage(isHuawei: false),
                  ),
                  (route) => false,
                );
              }
        
              if (state is AuthError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            child: ElevatedButton.icon(
              icon:  Icon(Icons.logout,size:  18.sp,),
              label:  Text('تسجيل الخروج',style: TextStyle(
                fontSize: 18.sp,
              ),),
              style: ElevatedButton.styleFrom(
                
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                context.read<AuthCubit>().signOut();
              },
            ),
          ),
        ),
      ),
    );
  }
}
