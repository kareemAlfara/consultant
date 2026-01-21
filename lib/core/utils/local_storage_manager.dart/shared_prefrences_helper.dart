import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  // ✅ Make instance public so it can be updated from AuthLocalDataSource
  static SharedPreferences? _instance;

  Prefs._internal();

  // ✅ CRITICAL FIX: Always ensure initialization before any operation
  static Future<SharedPreferences> _getInstance() async {
    _instance ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  static Future<void> init() async {
    _instance = await SharedPreferences.getInstance();
    await _instance!.reload(); // ✅ Force reload from disk
    print('✅ SharedPreferences initialized and reloaded');
  }

  // ✅ Expose setter for external updates (used by AuthLocalDataSource)
  static set instance(SharedPreferences prefs) {
    _instance = prefs;
  }

  // ========================================
  // ✅ FIXED: Async getString
  // ========================================
  static Future<String> getStringAsync(String key) async {
    final prefs = await _getInstance();
    return prefs.getString(key) ?? "";
  }

  // ✅ FIXED: Sync getString with proper initialization check
  static String getString(String key) {
    if (_instance == null) {
      print('⚠️ WARNING: Prefs not initialized, returning empty string for key: $key');
      return "";
    }
    final value = _instance!.getString(key) ?? "";
    // Remove excessive logging
    // print('📖 Read from Prefs: $key = $value');
    return value;
  }

  // ========================================
  // ✅ FIXED: All other methods
  // ========================================
  static Future<void> setString(String key, String value) async {
    final prefs = await _getInstance();
    await prefs.setString(key, value);
    // Remove excessive logging
    // print('💾 Saved to Prefs: $key = $value');
  }

  static Future<void> setBool(String key, bool value) async {
    final prefs = await _getInstance();
    await prefs.setBool(key, value);
  }

  static bool getBool(String key) {
    if (_instance == null) return false;
    return _instance!.getBool(key) ?? false;
  }

  static Future<void> setStringList(String key, List<String> value) async {
    final prefs = await _getInstance();
    await prefs.setStringList(key, value);
  }

  static List<String>? getStringList(String key) {
    if (_instance == null) return null;
    return _instance!.getStringList(key);
  }

  static Future<void> remove(String key) async {
    final prefs = await _getInstance();
    await prefs.remove(key);
  }

  static Future<void> clear() async {
    final prefs = await _getInstance();
    await prefs.clear();
  }

  static bool containsKey(String key) {
    if (_instance == null) return false;
    return _instance!.containsKey(key);
  }
}