import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'services/settings_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SettingsService.load();
  runApp(const TargetBelajarApp());
}

class TargetBelajarApp extends StatelessWidget {
  const TargetBelajarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: SettingsService.mode,
      builder: (context, mode, _) {
        return ValueListenableBuilder<String>(
          valueListenable: SettingsService.textSize,
          builder: (context, size, _) {
            final double scale = SettingsService.textScales[size] ?? 1.0;
            return MaterialApp(
              title: 'TargetBelajar',
              debugShowCheckedModeBanner: false,
              themeMode: mode,
              theme: ThemeData(
                colorSchemeSeed: Colors.teal,
                useMaterial3: true,
                brightness: Brightness.light,
              ),
              darkTheme: ThemeData(
                colorSchemeSeed: Colors.teal,
                useMaterial3: true,
                brightness: Brightness.dark,
              ),
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: TextScaler.linear(scale)),
                child: child!,
              ),
              home: const SplashScreen(),
            );
          },
        );
      },
    );
  }
}
