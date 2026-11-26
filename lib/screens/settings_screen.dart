import 'package:flutter/material.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: SettingsService.mode,
            builder: (context, mode, _) => SwitchListTile(
              title: const Text('Tema gelap'),
              value: mode == ThemeMode.dark,
              onChanged: SettingsService.setDark,
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('Ukuran teks'),
          ),
          ValueListenableBuilder<String>(
            valueListenable: SettingsService.textSize,
            builder: (context, size, _) => SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'kecil', label: Text('Kecil')),
                ButtonSegment(value: 'sedang', label: Text('Sedang')),
                ButtonSegment(value: 'besar', label: Text('Besar')),
              ],
              selected: {size},
              onSelectionChanged: (s) => SettingsService.setTextSize(s.first),
            ),
          ),
        ],
      ),
    );
  }
}
