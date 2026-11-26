import 'package:flutter/material.dart';
import '../models/target.dart';
import '../services/session_service.dart';
import '../services/target_service.dart';
import '../widgets/add_target_dialog.dart';
import 'login_screen.dart';
import 'settings_screen.dart';

class TargetListScreen extends StatefulWidget {
  final String displayName;
  const TargetListScreen({super.key, required this.displayName});

  @override
  State<TargetListScreen> createState() => _TargetListScreenState();
}

class _TargetListScreenState extends State<TargetListScreen> {
  final _targetService = TargetService();
  final _session = SessionService();
  List<Target> _targets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final targets = await _targetService.getTargets();
    if (!mounted) return;
    setState(() {
      _targets = targets;
      _isLoading = false;
    });
  }

  Future<void> _add() async {
    final result = await showDialog<({String judul, DateTime? tenggat})>(
      context: context,
      builder: (_) => const AddTargetDialog(),
    );
    if (result == null) return;
    await _targetService.addTarget(result.judul, result.tenggat);
    await _load();
  }

  Future<void> _toggle(Target t) async {
    await _targetService.toggleTarget(t.id);
    await _load();
  }

  Future<void> _delete(Target t) async {
    await _targetService.deleteTarget(t.id);
    await _load();
  }

  Future<void> _logout() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text(
          'Session akan dihapus. Target dan pengaturan tetap tersimpan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    await _session.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';

  bool _isOverdue(Target t) {
    if (t.selesai || t.tenggat == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return t.tenggat!.isBefore(today);
  }

  @override
  Widget build(BuildContext context) {
    final int done = _targets.where((t) => t.selesai).length;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Halo, ${widget.displayName}'),
            Text(
              'Selesai $done dari ${_targets.length}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Pengaturan',
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
          IconButton(
            tooltip: 'Keluar',
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        tooltip: 'Tambah target',
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _targets.isEmpty
              ? const Center(child: Text('Belum ada target.'))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                  itemCount: _targets.length,
                  itemBuilder: (context, index) {
                    final t = _targets[index];
                    return Card(
                      child: ListTile(
                        leading: Checkbox(
                          value: t.selesai,
                          onChanged: (_) => _toggle(t),
                        ),
                        title: Text(
                          t.judul,
                          style: TextStyle(
                            decoration:
                                t.selesai ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        subtitle: t.tenggat == null
                            ? null
                            : Text(
                                'Tenggat: ${_formatDate(t.tenggat!)}'
                                '${_isOverdue(t) ? ' (terlambat)' : ''}',
                                style: TextStyle(
                                  color: _isOverdue(t)
                                      ? Theme.of(context).colorScheme.error
                                      : null,
                                ),
                              ),
                        trailing: IconButton(
                          tooltip: 'Hapus',
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _delete(t),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
