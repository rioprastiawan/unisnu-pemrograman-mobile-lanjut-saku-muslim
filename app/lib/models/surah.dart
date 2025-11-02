class Surah {
  final int nomor;
  final String nama;
  final String namaLatin;
  final String arti;
  final int jumlahAyat;
  final String tempatTurun;
  final String audioFull;
  
  Surah({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.arti,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.audioFull,
  });
  
  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      nomor: json['nomor'] as int,
      nama: json['nama'] as String,
      namaLatin: json['namaLatin'] as String,
      arti: json['arti'] as String,
      jumlahAyat: json['jumlahAyat'] as int,
      tempatTurun: json['tempatTurun'] as String,
      audioFull: json['audioFull']?['05'] as String? ?? '',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'nomor': nomor,
      'nama': nama,
      'namaLatin': namaLatin,
      'arti': arti,
      'jumlahAyat': jumlahAyat,
      'tempatTurun': tempatTurun,
      'audioFull': audioFull,
    };
  }
  
  factory Surah.fromMap(Map<String, dynamic> map) {
    return Surah(
      nomor: map['nomor'] as int,
      nama: map['nama'] as String,
      namaLatin: map['namaLatin'] as String,
      arti: map['arti'] as String,
      jumlahAyat: map['jumlahAyat'] as int,
      tempatTurun: map['tempatTurun'] as String,
      audioFull: map['audioFull'] as String? ?? '',
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'nomor': nomor,
      'nama': nama,
      'namaLatin': namaLatin,
      'arti': arti,
      'jumlahAyat': jumlahAyat,
      'tempatTurun': tempatTurun,
      'audioFull': audioFull,
    };
  }
}
