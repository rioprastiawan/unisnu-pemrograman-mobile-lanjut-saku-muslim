class Doa {
  final int id;
  final String grup;
  final String nama;
  final String ar;
  final String tr;
  final String idn;
  final String tentang;
  final List<String> tag;

  Doa({
    required this.id,
    required this.grup,
    required this.nama,
    required this.ar,
    required this.tr,
    required this.idn,
    required this.tentang,
    required this.tag,
  });

  factory Doa.fromJson(Map<String, dynamic> json) {
    return Doa(
      id: json['id'] as int,
      grup: json['grup'] as String,
      nama: json['nama'] as String,
      ar: json['ar'] as String,
      tr: json['tr'] as String,
      idn: json['idn'] as String,
      tentang: json['tentang'] as String,
      tag: (json['tag'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'grup': grup,
      'nama': nama,
      'ar': ar,
      'tr': tr,
      'idn': idn,
      'tentang': tentang,
      'tag': tag,
    };
  }
}
