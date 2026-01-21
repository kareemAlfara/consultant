import 'package:marriage/core/utils/enums/cubit_status.dart';
import 'package:marriage/feature/chating/data/datasource/users_remote_data_source.dart';

// ========================================
// 📋 USERS LIST STATE CLASS
// ========================================
class UsersListState {
  final CubitStatus status;
  final List<UserWithLastMessage> users;
  final String? errorMessage;

  const UsersListState({
    this.status = CubitStatus.initial,
    this.users = const [],
    this.errorMessage,
  });

  // ✅ copyWith method
  UsersListState copyWith({
    CubitStatus? status,
    List<UserWithLastMessage>? users,
    String? errorMessage,
  }) {
    return UsersListState(
      status: status ?? this.status,
      users: users ?? this.users,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  // ✅ Convenience getters using extension
  bool get isInitial => status.isInitial;
  bool get isLoading => status.isLoading;
  bool get isSuccess => status.isSuccess;
  bool get isEmpty => status.isEmpty;
  bool get isError => status.isError;
  bool get hasUsers => users.isNotEmpty;
}