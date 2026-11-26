import 'package:flutter/material.dart';
import '../services/session_service.dart';
import 'login_screen.dart';
import 'target_list_screen.dart';

/// Memeriksa session lalu mengarahkan ke daftar target atau layar Masuk.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _session = SessionService();

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(milliseconds: 800));
    final bool loggedIn = await _session.isLoggedIn();
    final String? name = await _session.currentName();
    if (!mounted) return;

    final Widget next = (loggedIn && name != null && name.isNotEmpty)
        ? TargetListScreen(displayName: name)
        : const LoginScreen();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => next),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.flag, size: 96),
            SizedBox(height: 16),
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Memeriksa session...'),
          ],
        ),
      ),
    );
  }
}
