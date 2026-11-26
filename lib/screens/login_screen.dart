import 'package:flutter/material.dart';
import '../services/session_service.dart';
import 'target_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _session = SessionService();
  bool _remember = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _masuk() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final String name = _nameController.text.trim();
    if (_remember) {
      await _session.saveSession(name);
    } else {
      // Pastikan tidak ada session lama yang tertinggal.
      await _session.logout();
    }

    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => TargetListScreen(displayName: name)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Icon(Icons.flag, size: 72),
                  const SizedBox(height: 8),
                  Text(
                    'TargetBelajar',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Text('Catat target belajar mingguan Anda'),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama tampilan',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Nama wajib diisi'
                        : null,
                  ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text('Ingat saya'),
                    value: _remember,
                    onChanged: (v) => setState(() => _remember = v ?? false),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _isLoading ? null : _masuk,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Masuk'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
