import 'dart:convert';

/// Model target belajar. Dapat dikonversi ke/dari JSON.
class Target {
  final String id;
  final String judul;
  final bool selesai;
  final DateTime? tenggat;

  const Target({
    required this.id,
    required this.judul,
    this.selesai = false,
    this.tenggat,
  });

  Target copyWith({bool? selesai}) => Target(
        id: id,
        judul: judul,
        selesai: selesai ?? this.selesai,
        tenggat: tenggat,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'judul': judul,
        'selesai': selesai,
        'tenggat': tenggat?.toIso8601String(),
      };

  factory Target.fromMap(Map<String, dynamic> map) => Target(
        id: map['id'] as String,
        judul: map['judul'] as String,
        selesai: map['selesai'] as bool? ?? false,
        tenggat: map['tenggat'] == null
            ? null
            : DateTime.tryParse(map['tenggat'] as String),
      );

  static String encodeList(List<Target> list) =>
      jsonEncode(list.map((t) => t.toMap()).toList());

  static List<Target> decodeList(String source) {
    final List<dynamic> data = jsonDecode(source) as List<dynamic>;
    return data
        .map((item) => Target.fromMap(item as Map<String, dynamic>))
        .toList();
  }
}
