import 'dart:convert';
import 'package:marriage/feature/auth/data/models/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthLocalDataSource {
  static const String _userKey = 'cached_user';
  static const String _hasSeenOnboarding = 'has_seen_onboarding';

  // ========================================
  // ✅ SAVE USER
  // ========================================
  Future<void> saveUser(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      print('💾 Saving user: ${user.id}');

      // Save as JSON
      await prefs.setString(_userKey, jsonEncode(user.toJson()));

      // Save individual fields for easy access
      await prefs.setString('id', user.id);
      await prefs.setString('name', user.name);
      await prefs.setString('email', user.email);
      await prefs.setString('phone', user.phone);

      // Force reload
      await prefs.reload();

      // Verify
      final savedId = prefs.getString('id');
      if (savedId != user.id) {
        throw Exception('Failed to save user correctly');
      }

      print('✅ User saved successfully');
    } catch (e) {
      print('❌ Error saving user: $e');
      rethrow;
    }
  }

  // ========================================
  // ✅ GET USER
  // ========================================
  Future<UserModel?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Try cached JSON first
      final userJson = prefs.getString(_userKey);
      if (userJson != null) {
        return UserModel.fromJson(jsonDecode(userJson));
      }

      // Fallback to individual fields
      final id = prefs.getString('id');
      final name = prefs.getString('name');
      final email = prefs.getString('email');

      if (id != null && email != null) {
        return UserModel(
          id: id,
          name: name ?? '',
          email: email,
          phone: prefs.getString('phone') ?? '',
        );
      }

      return null;
    } catch (e) {
      print('❌ Error getting user: $e');
      return null;
    }
  }

  // ========================================
  // ✅ CLEAR USER - PRESERVE ONBOARDING
  // ========================================
  Future<void> clearUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save onboarding flag before clearing
      final hasSeenOnboarding = prefs.getBool(_hasSeenOnboarding) ?? false;

      // Remove user data
      await prefs.remove(_userKey);
      await prefs.remove('id');
      await prefs.remove('name');
      await prefs.remove('email');
      await prefs.remove('phone');
      await prefs.remove('is_guest');
      await prefs.remove('recent_products');

      // Restore onboarding flag
      await prefs.setBool(_hasSeenOnboarding, hasSeenOnboarding);

      print('✅ User data cleared, onboarding preserved: $hasSeenOnboarding');
    } catch (e) {
      print('❌ Error clearing user: $e');
      rethrow;
    }
  }

  // ========================================
  // ✅ CHECK IF USER EXISTS
  // ========================================
  Future<bool> hasUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isGuest = prefs.getBool('is_guest') ?? false;
      return prefs.containsKey('id') && !isGuest;
    } catch (e) {
      print('❌ Error checking user: $e');
      return false;
    }
  }
}