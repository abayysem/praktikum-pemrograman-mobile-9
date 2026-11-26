import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pengaturan: tema terang/gelap dan ukuran teks (disimpan lokal).
class SettingsService {
  static const String _kDarkMode = 'pref_dark_mode';
  static const String _kTextSize = 'pref_text_size';

  /// Pilihan ukuran teks -> faktor skala.
  static const Map<String, double> textScales = {
    'kecil': 0.85,
    'sedang': 1.0,
    'besar': 1.25,
  };

  static final ValueNotifier<ThemeMode> mode =
      ValueNotifier<ThemeMode>(ThemeMode.light);
  static final ValueNotifier<String> textSize = ValueNotifier<String>('sedang');

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isDark = prefs.getBool(_kDarkMode) ?? false;
    final String size = prefs.getString(_kTextSize) ?? 'sedang';
    mode.value = isDark ? ThemeMode.dark : ThemeMode.light;
    textSize.value = textScales.containsKey(size) ? size : 'sedang';
  }

  static Future<void> setDark(bool value) async {
    mode.value = value ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kDarkMode, value);
  }

  static Future<void> setTextSize(String size) async {
    if (!textScales.containsKey(size)) return;
    textSize.value = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kTextSize, size);
  }
}
