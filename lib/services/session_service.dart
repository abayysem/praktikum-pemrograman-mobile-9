import 'package:shared_preferences/shared_preferences.dart';

/// Mengelola session ("Ingat saya"). Tidak ada password pada aplikasi ini.
class SessionService {
  static const String _kIsLoggedIn = 'session_is_logged_in';
  static const String _kDisplayName = 'session_display_name';

  /// Menyimpan session (dipanggil hanya jika "Ingat saya" dicentang).
  Future<void> saveSession(String displayName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kIsLoggedIn, true);
    await prefs.setString(_kDisplayName, displayName);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kIsLoggedIn) ?? false;
  }

  Future<String?> currentName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kDisplayName);
  }

  /// Hanya menghapus kunci session. Target dan pengaturan tetap ada.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kIsLoggedIn);
    await prefs.remove(_kDisplayName);
  }
}
