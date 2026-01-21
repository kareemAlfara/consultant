// ========================================
// 📁 lib/feature/auth/presentation/cubit/auth_state.dart
// ========================================
part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// ========================================
// INITIAL STATE
// ========================================
class AuthInitial extends AuthState {}

// ========================================
// LOADING STATE
// ========================================
class AuthLoading extends AuthState {}

// ========================================
// AUTHENTICATED STATE
// ========================================
class AuthAuthenticated extends AuthState {
  final UserModel user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

// ========================================
// UNAUTHENTICATED STATE
// ========================================
class AuthUnauthenticated extends AuthState {}

// ========================================
// ERROR STATE
// ========================================
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

// ========================================
// PASSWORD VISIBILITY STATE
// ========================================
class AuthPasswordVisibilityChanged extends AuthState {
  final bool isVisible;

  const AuthPasswordVisibilityChanged(this.isVisible);

  @override
  List<Object?> get props => [isVisible];
}