import 'prayer_time.dart';

class PrayerSchedule {
  final String id;
  final String lokasi;
  final String daerah;
  final PrayerTime jadwal;

  PrayerSchedule({
    required this.id,
    required this.lokasi,
    required this.daerah,
    required this.jadwal,
  });

  factory PrayerSchedule.fromJson(Map<String, dynamic> json) {
    return PrayerSchedule(
      id: json['id'].toString(),
      lokasi: json['lokasi'] as String,
      daerah: json['daerah'] as String,
      jadwal: PrayerTime.fromJson(json['jadwal'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lokasi': lokasi,
      'daerah': daerah,
      'jadwal': jadwal.toJson(),
    };
  }
}
