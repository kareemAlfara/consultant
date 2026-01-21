// ========================================
// 📁 lib/feature/auth/presentation/cubit/auth_cubit.dart
// ========================================
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marriage/feature/auth/data/auth_local_data_source.dart';
import 'package:marriage/feature/auth/data/auth_remote_data_source.dart';
import 'package:marriage/feature/auth/data/models/userModel.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthCubit({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        super(AuthInitial());

  // ========================================
  // FORM KEYS & CONTROLLERS
  // ========================================
  final signInFormKey = GlobalKey<FormState>();
  final signUpFormKey = GlobalKey<FormState>();

  final signInEmailController = TextEditingController();
  final signInPasswordController = TextEditingController();

  final signUpEmailController = TextEditingController();
  final signUpPasswordController = TextEditingController();
  final signUpNameController = TextEditingController();
  final signUpPhoneController = TextEditingController();

  bool isPasswordVisible = false;

  // ========================================
  // ✅ SIGN IN
  // ========================================
  Future<void> signIn() async {
    if (!signInFormKey.currentState!.validate()) return;

    emit(AuthLoading());

    try {
      final user = await _remoteDataSource.signin(
        email: signInEmailController.text.trim(),
        password: signInPasswordController.text,
      );

      await _localDataSource.saveUser(user);

      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // ========================================
  // ✅ SIGN UP
  // ========================================
  Future<void> signUp() async {
    if (!signUpFormKey.currentState!.validate()) return;

    emit(AuthLoading());

    try {
      final user = await _remoteDataSource.signup(
        email: signUpEmailController.text.trim(),
        password: signUpPasswordController.text,
        name: signUpNameController.text.trim(),
        phone: signUpPhoneController.text.trim(),
      );

      await _localDataSource.saveUser(user);

      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // ========================================
  // ✅ GOOGLE SIGN IN
  // ========================================
  Future<void> signInWithGoogle() async {
    emit(AuthLoading());

    try {
      final user = await _remoteDataSource.signinWithGoogle();

      await _localDataSource.saveUser(user);

      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // ========================================
  // ✅ SIGN OUT
  // ========================================
  Future<void> signOut() async {
    emit(AuthLoading());

    try {
      await _remoteDataSource.signOut();
      await _localDataSource.clearUser();

      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // ========================================
  // ✅ GET CURRENT USER
  // ========================================
  Future<UserModel?> getCurrentUser() async {
    emit(AuthLoading());

    try {
      // Try local first
      var user = await _localDataSource.getUser();

      // If no local user, check Firebase
      if (user == null) {
        user = await _remoteDataSource.getCurrentUser();

        if (user != null) {
          await _localDataSource.saveUser(user);
        }
      }

      if (user == null) {
        emit(AuthUnauthenticated());
        return null;
      }

      emit(AuthAuthenticated(user));
      return user;
    } catch (e) {
      emit(AuthError(e.toString()));
      return null;
    }
  }

  // ========================================
  // UTILITIES
  // ========================================
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(AuthPasswordVisibilityChanged(isPasswordVisible));
  }

  void clearSignInForm() {
    signInEmailController.clear();
    signInPasswordController.clear();
  }

  void clearSignUpForm() {
    signUpEmailController.clear();
    signUpPasswordController.clear();
    signUpNameController.clear();
    signUpPhoneController.clear();
  }

  @override
  Future<void> close() {
    signInEmailController.dispose();
    signInPasswordController.dispose();
    signUpEmailController.dispose();
    signUpPasswordController.dispose();
    signUpNameController.dispose();
    signUpPhoneController.dispose();
    return super.close();
  }
}