
  import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marriage/feature/myspace/presentation/cubit/ConsultationCubit/consultation_cubit.dart';

Widget ConsultingbuildEmptyStateWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/emptyMySpace.png", height: 200.h),
          SizedBox(height: 20.h),
          Text(
            "اشترك مع المستشارين لجعل حياتك افضل",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget ConsultingbuildErrorStateWidget(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60.w, color: Colors.red),
          SizedBox(height: 16.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              context.read<ConsultationCubit>().fetchConsultations();
            },
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
