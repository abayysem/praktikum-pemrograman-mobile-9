import 'package:flutter/material.dart';

/// Dialog tambah target. Mengembalikan record (judul, tenggat) atau null.
class AddTargetDialog extends StatefulWidget {
  const AddTargetDialog({super.key});

  @override
  State<AddTargetDialog> createState() => _AddTargetDialogState();
}

class _AddTargetDialogState extends State<AddTargetDialog> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  DateTime? _tenggat;

  @override
  void dispose() {
    _judulController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _tenggat ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 5),
    );
    if (!mounted) return;
    if (picked != null) setState(() => _tenggat = picked);
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, (
        judul: _judulController.text.trim(),
        tenggat: _tenggat,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final String tenggatText = _tenggat == null
        ? 'Pilih tenggat (opsional)'
        : '${_tenggat!.day}/${_tenggat!.month}/${_tenggat!.year}';

    return AlertDialog(
      title: const Text('Target Baru'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _judulController,
              decoration: const InputDecoration(
                labelText: 'Judul target',
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Judul tidak boleh kosong'
                  : null,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.event),
              label: Text(tenggatText),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Simpan')),
      ],
    );
  }
}
