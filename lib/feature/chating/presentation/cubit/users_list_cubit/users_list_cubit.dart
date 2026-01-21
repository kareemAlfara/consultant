import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marriage/core/utils/enums/cubit_status.dart';
import 'package:marriage/feature/chating/data/datasource/users_remote_data_source.dart';
import 'package:marriage/feature/chating/presentation/cubit/users_list_cubit/users_list_state.dart';

class UsersListCubit extends Cubit<UsersListState> {
  final UsersRemoteDataSource remoteDataSource;
  StreamSubscription<List<UserWithLastMessage>>? _usersSubscription;

  UsersListCubit({required this.remoteDataSource}) : super(const UsersListState());

  // ========================================
  // ✅ LISTEN TO USERS WITH MESSAGES
  // ========================================
  void listenToUsers(String currentUserId) {
    try {
      print('👥 Listening to users with messages...');
      emit(state.copyWith(status: CubitStatus.loading));

      _usersSubscription?.cancel();

      _usersSubscription = remoteDataSource
          .getUsersWithLastMessage(currentUserId)
          .listen(
            (users) {
              print('📊 Received ${users.length} users');
              
              if (users.isEmpty) {
                emit(state.copyWith(status: CubitStatus.empty));
              } else {
                emit(state.copyWith(
                  status: CubitStatus.success,
                  users: users,
                ));
              }
            },
            onError: (error) {
              print('❌ Error listening to users: $error');
              emit(state.copyWith(
                status: CubitStatus.error,
                errorMessage: 'فشل في تحميل المستخدمين: $error',
              ));
            },
          );
    } catch (e) {
      print('❌ Error in listenToUsers: $e');
      emit(state.copyWith(
        status: CubitStatus.error,
        errorMessage: 'حدث خطأ: $e',
      ));
    }
  }

  // ========================================
  // ✅ REFRESH USERS LIST
  // ========================================
  void refreshUsers(String currentUserId) {
    print('🔄 Refreshing users list...');
    listenToUsers(currentUserId);
  }

  @override
  Future<void> close() {
    _usersSubscription?.cancel();
    return super.close();
  }
}