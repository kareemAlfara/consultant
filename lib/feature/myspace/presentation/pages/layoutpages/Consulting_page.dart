import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marriage/core/utils/enums/enums_state.dart';
import 'package:marriage/core/utils/manager/color_manager/color_manager.dart';
import 'package:marriage/core/widgets/Background.dart';
import 'package:marriage/core/widgets/defultAppBar.dart';
import 'package:marriage/feature/myspace/presentation/cubit/ConsultationCubit/consultation_cubit.dart';
import 'package:marriage/feature/myspace/presentation/cubit/ConsultationCubit/consultation_state.dart';
import '../../widgets/ConsultingbuildConsultationsContentWidget.dart';
import '../../widgets/ConsultingbuildEmptyStateWidget.dart';

/// Consulting page - now StatelessWidget using Cubit
class ConsultingPage extends StatelessWidget {
  const ConsultingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: const CustomBottomNav(),
      body: BG(
        child: SafeArea(
          child: Column(
            children: [
              DefaultAppBar(
                title: "سجل الجلسات",
              
              ),
              Expanded(
                child: BlocBuilder<ConsultationCubit, ConsultationState>(
                  buildWhen: (p, c) => p.status != c.status,
                  builder: (context, state) {
                    switch (state.status) {
                      case ConsultationStatusEnum.initial:
                      case ConsultationStatusEnum.loading:
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary300,
                          ),
                        );
                      case ConsultationStatusEnum.success:
                        // ✅ تصفية الجلسات: فقط جلسات المستشار المحدد
                        return ConsultingbuildConsultationsContentWidget(
                          context,
                          state.activeConsultations,
                          state.previousConsultations,
                        );
                      case ConsultationStatusEnum.empty:
                        return ConsultingbuildEmptyStateWidget();
                      case ConsultationStatusEnum.error:
                        return ConsultingbuildErrorStateWidget(
                          context,
                          state.errorMessage!,
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
