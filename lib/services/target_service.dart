import 'package:shared_preferences/shared_preferences.dart';
import '../models/target.dart';

/// Mengelola penyimpanan daftar target sebagai satu String JSON.
class TargetService {
  static const String _kTargets = 'targets';

  Future<List<Target>> getTargets() async {
    final prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_kTargets);
    if (raw == null) return [];
    try {
      return Target.decodeList(raw);
    } catch (_) {
      // Data rusak: jangan membuat aplikasi crash.
      return [];
    }
  }

  Future<void> _save(List<Target> targets) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kTargets, Target.encodeList(targets));
  }

  Future<void> addTarget(String judul, DateTime? tenggat) async {
    final targets = await getTargets();
    targets.insert(
      0,
      Target(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        judul: judul,
        tenggat: tenggat,
      ),
    );
    await _save(targets);
  }

  Future<void> toggleTarget(String id) async {
    final targets = await getTargets();
    final updated = targets
        .map((t) => t.id == id ? t.copyWith(selesai: !t.selesai) : t)
        .toList();
    await _save(updated);
  }

  Future<void> deleteTarget(String id) async {
    final targets = await getTargets();
    targets.removeWhere((t) => t.id == id);
    await _save(targets);
  }
}
