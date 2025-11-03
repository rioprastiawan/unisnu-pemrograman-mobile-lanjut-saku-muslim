/// Model for prayer times data
class PrayerTime {
  final String name;
  final String time;
  final String nameIndonesian;
  final PrayerStatus status;
  final bool isNext;

  const PrayerTime({
    required this.name,
    required this.time,
    required this.nameIndonesian,
    required this.status,
    this.isNext = false,
  });

  factory PrayerTime.fromJson(Map<String, dynamic> json, String prayerName) {
    return PrayerTime(
      name: prayerName,
      time: json[prayerName] as String,
      nameIndonesian: _getIndonesianName(prayerName),
      status: PrayerStatus.upcoming,
    );
  }

  static String _getIndonesianName(String englishName) {
    const Map<String, String> translations = {
      'Fajr': 'Subuh',
      'Sunrise': 'Terbit',
      'Dhuhr': 'Dzuhur',
      'Asr': 'Ashar',
      'Maghrib': 'Maghrib',
      'Isha': 'Isya',
    };
    return translations[englishName] ?? englishName;
  }

  PrayerTime copyWith({
    String? name,
    String? time,
    String? nameIndonesian,
    PrayerStatus? status,
    bool? isNext,
  }) {
    return PrayerTime(
      name: name ?? this.name,
      time: time ?? this.time,
      nameIndonesian: nameIndonesian ?? this.nameIndonesian,
      status: status ?? this.status,
      isNext: isNext ?? this.isNext,
    );
  }

  @override
  String toString() {
    return 'PrayerTime(name: $name, time: $time, nameIndonesian: $nameIndonesian, status: $status, isNext: $isNext)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PrayerTime &&
        other.name == name &&
        other.time == time &&
        other.nameIndonesian == nameIndonesian &&
        other.status == status &&
        other.isNext == isNext;
  }

  @override
  int get hashCode {
    return Object.hash(name, time, nameIndonesian, status, isNext);
  }
}

/// Status of prayer time
enum PrayerStatus { passed, current, upcoming }

/// Model for daily prayer times
class DailyPrayerTimes {
  final List<PrayerTime> prayers;
  final DateTime date;
  final HijriDate hijriDate;
  final String locationName;
  final double latitude;
  final double longitude;

  const DailyPrayerTimes({
    required this.prayers,
    required this.date,
    required this.hijriDate,
    required this.locationName,
    required this.latitude,
    required this.longitude,
  });

  factory DailyPrayerTimes.fromJson(
    Map<String, dynamic> json,
    String locationName,
    double latitude,
    double longitude,
  ) {
    final timingsData = json['data']['timings'] as Map<String, dynamic>;
    final dateData = json['data']['date'] as Map<String, dynamic>;

    // Create prayer times list
    final List<PrayerTime> prayersList = [];
    const prayerNames = ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

    for (String prayerName in prayerNames) {
      if (timingsData.containsKey(prayerName)) {
        prayersList.add(PrayerTime.fromJson(timingsData, prayerName));
      }
    }

    return DailyPrayerTimes(
      prayers: prayersList,
      date: DateTime.now(),
      hijriDate: HijriDate.fromJson(dateData['hijri'] as Map<String, dynamic>),
      locationName: locationName,
      latitude: latitude,
      longitude: longitude,
    );
  }

  /// Get next prayer time
  PrayerTime? get nextPrayer {
    final now = DateTime.now();
    final currentTimeInMinutes = now.hour * 60 + now.minute;

    for (PrayerTime prayer in prayers) {
      final prayerTimeparts = prayer.time.split(':');
      final prayerTimeInMinutes =
          int.parse(prayerTimeparts[0]) * 60 + int.parse(prayerTimeparts[1]);

      if (prayerTimeInMinutes > currentTimeInMinutes) {
        return prayer;
      }
    }

    // If no prayer found for today, return first prayer of tomorrow
    return prayers.isNotEmpty ? prayers.first : null;
  }

  /// Get current prayer time
  PrayerTime? get currentPrayer {
    final now = DateTime.now();
    final currentTimeInMinutes = now.hour * 60 + now.minute;
    PrayerTime? lastPassedPrayer;

    for (PrayerTime prayer in prayers) {
      final prayerTimeparts = prayer.time.split(':');
      final prayerTimeInMinutes =
          int.parse(prayerTimeparts[0]) * 60 + int.parse(prayerTimeparts[1]);

      if (prayerTimeInMinutes <= currentTimeInMinutes) {
        lastPassedPrayer = prayer;
      } else {
        break;
      }
    }

    return lastPassedPrayer;
  }

  /// Get time until next prayer in minutes
  int get minutesUntilNextPrayer {
    final next = nextPrayer;
    if (next == null) return 0;

    final now = DateTime.now();
    final currentTimeInMinutes = now.hour * 60 + now.minute;
    final prayerTimeparts = next.time.split(':');
    final prayerTimeInMinutes =
        int.parse(prayerTimeparts[0]) * 60 + int.parse(prayerTimeparts[1]);

    int difference = prayerTimeInMinutes - currentTimeInMinutes;
    if (difference < 0) {
      difference += 24 * 60; // Add 24 hours for next day
    }

    return difference;
  }

  /// Get formatted time until next prayer
  String get timeUntilNextPrayer {
    final minutes = minutesUntilNextPrayer;
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    final seconds = DateTime.now().second;

    return '${hours.toString().padLeft(2, '0')}:'
        '${remainingMinutes.toString().padLeft(2, '0')}:'
        '${(59 - seconds).toString().padLeft(2, '0')}';
  }

  /// Update prayer statuses based on current time
  DailyPrayerTimes updatePrayerStatuses() {
    final now = DateTime.now();
    final currentTimeInMinutes = now.hour * 60 + now.minute;

    final updatedPrayers =
        prayers.map((prayer) {
          final prayerTimeparts = prayer.time.split(':');
          final prayerTimeInMinutes =
              int.parse(prayerTimeparts[0]) * 60 +
              int.parse(prayerTimeparts[1]);

          PrayerStatus status;
          bool isNext = false;

          if (prayerTimeInMinutes <= currentTimeInMinutes) {
            status = PrayerStatus.passed;
          } else {
            status = PrayerStatus.upcoming;
            // Check if this is the next prayer
            final next = nextPrayer;
            isNext = (next != null && prayer.name == next.name);
          }

          return prayer.copyWith(status: status, isNext: isNext);
        }).toList();

    return DailyPrayerTimes(
      prayers: updatedPrayers,
      date: date,
      hijriDate: hijriDate,
      locationName: locationName,
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  String toString() {
    return 'DailyPrayerTimes(prayers: ${prayers.length}, date: $date, location: $locationName)';
  }
}

/// Model for Hijri date
class HijriDate {
  final String date;
  final String day;
  final String month;
  final String year;
  final String weekday;

  const HijriDate({
    required this.date,
    required this.day,
    required this.month,
    required this.year,
    required this.weekday,
  });

  factory HijriDate.fromJson(Map<String, dynamic> json) {
    return HijriDate(
      date: json['date'] as String? ?? '',
      day: json['day'] as String? ?? '',
      month: (json['month'] as Map<String, dynamic>?)?['en'] as String? ?? '',
      year: json['year'] as String? ?? '',
      weekday:
          (json['weekday'] as Map<String, dynamic>?)?['en'] as String? ?? '',
    );
  }

  String get formattedDate => '$day $month $year H';

  @override
  String toString() {
    return 'HijriDate(date: $date, day: $day, month: $month, year: $year)';
  }
}
