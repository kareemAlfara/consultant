import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marriage/core/utils/manager/color_manager/color_manager.dart';
import 'package:marriage/core/widgets/Background.dart';
import 'package:marriage/feature/chating/data/datasource/users_remote_data_source.dart';
import 'package:marriage/feature/chating/presentation/cubit/users_list_cubit/users_list_cubit.dart';
import 'package:marriage/feature/chating/presentation/cubit/users_list_cubit/users_list_state.dart';
import 'package:marriage/feature/chating/presentation/pages/consuiltant_Chat.dart';
import 'package:get_it/get_it.dart';
import 'package:marriage/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:marriage/feature/auth/data/models/userModel.dart';

class ConsultationsListPage extends StatelessWidget {
  const ConsultationsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final authState = context.read<AuthCubit>().state;
        final currentUserId = authState is AuthAuthenticated
            ? authState.user.id
            : '';

        final usersListCubit = GetIt.instance<UsersListCubit>();

        if (currentUserId.isNotEmpty) {
          usersListCubit.listenToUsers(currentUserId);
        }

        return usersListCubit;
      },
      child: Scaffold(
        body: BG(
          child: BlocBuilder<UsersListCubit, UsersListState>(
            builder: (context, state) {
              // ✅ Using general enum getters
              if (state.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary300),
                );
              }

              if (state.isSuccess) {
                return _buildUsersList(context, state.users);
              }

              if (state.isEmpty) {
                return _buildAllUsersView(context);
              }

              if (state.isError) {
                return _buildErrorState(context, state.errorMessage ?? 'حدث خطأ');
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAllUsersView(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    final currentUserId = authState is AuthAuthenticated
        ? authState.user.id
        : '';

    return FutureBuilder<List<UserModel>>(
      future: GetIt.instance<UsersRemoteDataSource>().getAllUsersExceptCurrent(
        currentUserId,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary300),
          );
        }

        if (snapshot.hasError) {
          return _buildErrorState(context, snapshot.error.toString());
        }

        final users = snapshot.data ?? [];

        if (users.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () async {
            if (currentUserId.isNotEmpty) {
              context.read<UsersListCubit>().refreshUsers(currentUserId);
            }
          },
          child: Padding(
            padding: EdgeInsets.all(18.0.w),
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return _buildSimpleUserCard(context: context, user: user);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildSimpleUserCard({
    required BuildContext context,
    required UserModel user,
  }) {
    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConsultantChatPage(
              consultantId: user.id,
              consultantName: user.name,
              consultantImage: "assets/images/profile_image.jpg",
            ),
          ),
        );

        if (context.mounted) {
          final authState = context.read<AuthCubit>().state;
          final currentUserId = authState is AuthAuthenticated
              ? authState.user.id
              : '';

          if (currentUserId.isNotEmpty) {
            context.read<UsersListCubit>().refreshUsers(currentUserId);
          }
        }
      },
      child: Container(
        padding: EdgeInsets.all(5.w),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[200]!, width: 2.w),
                  ),
                  child: CircleAvatar(
                    radius: 25.r,
                    backgroundColor: AppColors.primary300,
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                          fontFamily: 'IBM Plex Sans Arabic',
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'ابدأ محادثة',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey[500],
                          fontFamily: 'IBM Plex Sans Arabic',
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16.sp,
                  color: Colors.grey[400],
                ),
              ],
            ),
            SizedBox(height: 11.h),
            Container(
              margin: EdgeInsets.only(right: 33.w),
              child: Divider(height: 1.h, color: Colors.grey[400]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersList(
    BuildContext context,
    List<UserWithLastMessage> users,
  ) {
    final authState = context.read<AuthCubit>().state;
    final currentUserId = authState is AuthAuthenticated
        ? authState.user.id
        : '';

    return RefreshIndicator(
      onRefresh: () async {
        if (currentUserId.isNotEmpty) {
          context.read<UsersListCubit>().refreshUsers(currentUserId);
        }
      },
      child: Padding(
        padding: EdgeInsets.all(18.0.w),
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final userWithMessage = users[index];
            return _buildUserCard(
              context: context,
              userWithMessage: userWithMessage,
            );
          },
        ),
      ),
    );
  }

  Widget _buildUserCard({
    required BuildContext context,
    required UserWithLastMessage userWithMessage,
  }) {
    final user = userWithMessage.user;

    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConsultantChatPage(
              consultantId: user.id,
              consultantName: user.name,
              consultantImage: "assets/images/profile_image.jpg",
            ),
          ),
        );

        if (context.mounted) {
          final authState = context.read<AuthCubit>().state;
          final currentUserId = authState is AuthAuthenticated ? authState.user.id : '';
          
          if (currentUserId.isNotEmpty) {
            context.read<UsersListCubit>().refreshUsers(currentUserId);
          }
        }
      },
      child: Container(
        padding: EdgeInsets.all(5.w),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[200]!, width: 2.w),
                  ),
                  child: CircleAvatar(
                    radius: 25.r,
                    backgroundImage: AssetImage(
                      "assets/images/profile_image.jpg",
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                          fontFamily: 'IBM Plex Sans Arabic',
                        ),
                      ),
                      if (userWithMessage.lastMessage.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            if (userWithMessage.isLastMessageFromMe)
                              Icon(
                                Icons.done,
                                size: 14.sp,
                                color: Colors.grey[500],
                              ),
                            if (userWithMessage.isLastMessageFromMe)
                              SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                userWithMessage.lastMessage,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: userWithMessage.hasUnreadMessages
                                      ? Colors.black
                                      : Colors.grey[500],
                                  fontWeight: userWithMessage.hasUnreadMessages
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  fontFamily: 'IBM Plex Sans Arabic',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      userWithMessage.timeAgo,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: userWithMessage.hasUnreadMessages
                            ? const Color(0xFFFF6B9D)
                            : const Color(0xFF999999),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'IBM Plex Sans Arabic',
                      ),
                    ),
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (userWithMessage.hasUnreadMessages) ...[
                            SizedBox(height: 8.h),
                            Container(
                              padding: EdgeInsets.all(2.w),
                              constraints: BoxConstraints(
                                minWidth: 22.w,
                                minHeight: 22.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary300,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  "${userWithMessage.unreadCount}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xffFFFFFF),
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 11.h),
            Container(
              margin: EdgeInsets.only(right: 33.w),
              child: Divider(height: 1.h, color: Colors.grey[400]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: 0.4,
            child: Transform.rotate(
              angle: 0.5,
              child: Image.asset(
                "assets/images/emptyMySpace.png",
                width: 280.w,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.chat_bubble_outline,
                    size: 120.sp,
                    color: Colors.grey[300],
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            "لا يوجد مستخدمون",
            style: TextStyle(
              fontFamily: 'IBM Plex Sans Arabic',
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              color: Color(0xFF999999),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final authState = context.read<AuthCubit>().state;
    final currentUserId = authState is AuthAuthenticated
        ? authState.user.id
        : '';

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
              if (currentUserId.isNotEmpty) {
                context.read<UsersListCubit>().refreshUsers(currentUserId);
              }
            },
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}