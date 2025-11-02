import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'saku_muslim.db');
    return await openDatabase(
      path,
      version: 4,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Table for location cache
    await db.execute('''
      CREATE TABLE location_cache (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        city_id TEXT NOT NULL,
        city_name TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        last_updated INTEGER NOT NULL
      )
    ''');

    // Table for prayer schedule cache
    await db.execute('''
      CREATE TABLE prayer_schedule_cache (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        city_id TEXT NOT NULL,
        date TEXT NOT NULL,
        prayer_data TEXT NOT NULL,
        last_updated INTEGER NOT NULL,
        UNIQUE(city_id, date)
      )
    ''');

    // Table for surah cache
    await db.execute('''
      CREATE TABLE surah_cache (
        nomor INTEGER PRIMARY KEY,
        nama TEXT NOT NULL,
        namaLatin TEXT NOT NULL,
        arti TEXT NOT NULL,
        jumlahAyat INTEGER NOT NULL,
        tempatTurun TEXT NOT NULL,
        audioFull TEXT,
        last_updated INTEGER NOT NULL
      )
    ''');

    // Table for surah detail cache
    await db.execute('''
      CREATE TABLE surah_detail_cache (
        nomor INTEGER PRIMARY KEY,
        detail_data TEXT NOT NULL,
        last_updated INTEGER NOT NULL
      )
    ''');

    // Table for notification settings
    await db.execute('''
      CREATE TABLE notification_settings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        prayer_name TEXT NOT NULL UNIQUE,
        is_enabled INTEGER NOT NULL DEFAULT 1,
        sound_enabled INTEGER NOT NULL DEFAULT 1,
        vibrate_enabled INTEGER NOT NULL DEFAULT 1
      )
    ''');

    // Insert default notification settings for 5 prayers
    await db.execute('''
      INSERT INTO notification_settings (prayer_name, is_enabled, sound_enabled, vibrate_enabled)
      VALUES 
        ('subuh', 1, 1, 1),
        ('dzuhur', 1, 1, 1),
        ('ashar', 1, 1, 1),
        ('maghrib', 1, 1, 1),
        ('isya', 1, 1, 1)
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add surah cache table for version 2
      await db.execute('''
        CREATE TABLE surah_cache (
          nomor INTEGER PRIMARY KEY,
          nama TEXT NOT NULL,
          namaLatin TEXT NOT NULL,
          arti TEXT NOT NULL,
          jumlahAyat INTEGER NOT NULL,
          tempatTurun TEXT NOT NULL,
          audioFull TEXT,
          last_updated INTEGER NOT NULL
        )
      ''');
    }
    if (oldVersion < 3) {
      // Add surah detail cache table for version 3
      await db.execute('''
        CREATE TABLE surah_detail_cache (
          nomor INTEGER PRIMARY KEY,
          detail_data TEXT NOT NULL,
          last_updated INTEGER NOT NULL
        )
      ''');
    }
    if (oldVersion < 4) {
      // Add notification settings table for version 4
      await db.execute('''
        CREATE TABLE notification_settings (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          prayer_name TEXT NOT NULL UNIQUE,
          is_enabled INTEGER NOT NULL DEFAULT 1,
          sound_enabled INTEGER NOT NULL DEFAULT 1,
          vibrate_enabled INTEGER NOT NULL DEFAULT 1
        )
      ''');

      // Insert default notification settings
      await db.execute('''
        INSERT INTO notification_settings (prayer_name, is_enabled, sound_enabled, vibrate_enabled)
        VALUES 
          ('subuh', 1, 1, 1),
          ('dzuhur', 1, 1, 1),
          ('ashar', 1, 1, 1),
          ('maghrib', 1, 1, 1),
          ('isya', 1, 1, 1)
      ''');
    }
  }

  // ==================== LOCATION METHODS ====================
  
  Future<Map<String, dynamic>?> getLocationCache() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'location_cache',
      orderBy: 'last_updated DESC',
      limit: 1,
    );

    if (results.isEmpty) return null;

    return results.first;
  }

  Future<void> saveLocationCache({
    required String cityId,
    required String cityName,
    required double latitude,
    required double longitude,
  }) async {
    final db = await database;
    
    // Delete old records
    await db.delete('location_cache');
    
    // Insert new record
    await db.insert('location_cache', {
      'city_id': cityId,
      'city_name': cityName,
      'latitude': latitude,
      'longitude': longitude,
      'last_updated': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<bool> isLocationStale({int maxAgeMinutes = 10}) async {
    final cache = await getLocationCache();
    if (cache == null) return true;

    final lastUpdated = DateTime.fromMillisecondsSinceEpoch(cache['last_updated']);
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);

    return difference.inMinutes >= maxAgeMinutes;
  }

  // ==================== PRAYER SCHEDULE METHODS ====================
  
  Future<Map<String, dynamic>?> getPrayerScheduleCache(String cityId, String date) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'prayer_schedule_cache',
      where: 'city_id = ? AND date = ?',
      whereArgs: [cityId, date],
      limit: 1,
    );

    if (results.isEmpty) return null;

    final result = results.first;
    return {
      'city_id': result['city_id'],
      'date': result['date'],
      'prayer_data': jsonDecode(result['prayer_data']),
      'last_updated': result['last_updated'],
    };
  }

  Future<void> savePrayerScheduleCache({
    required String cityId,
    required String date,
    required Map<String, dynamic> prayerData,
  }) async {
    final db = await database;
    
    await db.insert(
      'prayer_schedule_cache',
      {
        'city_id': cityId,
        'date': date,
        'prayer_data': jsonEncode(prayerData),
        'last_updated': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> isPrayerScheduleStale(String cityId, String date, {int maxAgeMinutes = 10}) async {
    final cache = await getPrayerScheduleCache(cityId, date);
    if (cache == null) return true;

    final lastUpdated = DateTime.fromMillisecondsSinceEpoch(cache['last_updated']);
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);

    return difference.inMinutes >= maxAgeMinutes;
  }

  // ==================== SURAH METHODS ====================
  
  Future<List<Map<String, dynamic>>> getAllSurahsCache() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'surah_cache',
      orderBy: 'nomor ASC',
    );
    return results;
  }

  Future<void> saveSurahsCache(List<Map<String, dynamic>> surahs) async {
    final db = await database;
    final batch = db.batch();
    
    // Delete old cache
    batch.delete('surah_cache');
    
    // Insert all surahs
    for (var surah in surahs) {
      batch.insert('surah_cache', {
        'nomor': surah['nomor'],
        'nama': surah['nama'],
        'namaLatin': surah['namaLatin'],
        'arti': surah['arti'],
        'jumlahAyat': surah['jumlahAyat'],
        'tempatTurun': surah['tempatTurun'],
        'audioFull': surah['audioFull'],
        'last_updated': DateTime.now().millisecondsSinceEpoch,
      });
    }
    
    await batch.commit(noResult: true);
  }

  Future<bool> isSurahCacheEmpty() async {
    final db = await database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM surah_cache')
    );
    return count == 0;
  }

  Future<bool> isSurahCacheStale({int maxAgeDays = 30}) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'surah_cache',
      limit: 1,
    );

    if (results.isEmpty) return true;

    final lastUpdated = DateTime.fromMillisecondsSinceEpoch(results.first['last_updated']);
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);

    return difference.inDays >= maxAgeDays;
  }

  // ==================== SURAH DETAIL METHODS ====================
  
  Future<Map<String, dynamic>?> getSurahDetailCache(int nomorSurah) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'surah_detail_cache',
      where: 'nomor = ?',
      whereArgs: [nomorSurah],
      limit: 1,
    );

    if (results.isEmpty) return null;

    final result = results.first;
    return {
      'nomor': result['nomor'],
      'detail_data': jsonDecode(result['detail_data']),
      'last_updated': result['last_updated'],
    };
  }

  Future<void> saveSurahDetailCache(int nomorSurah, Map<String, dynamic> detailData) async {
    final db = await database;
    
    await db.insert(
      'surah_detail_cache',
      {
        'nomor': nomorSurah,
        'detail_data': jsonEncode(detailData),
        'last_updated': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> isSurahDetailCacheStale(int nomorSurah, {int maxAgeDays = 30}) async {
    final cache = await getSurahDetailCache(nomorSurah);
    if (cache == null) return true;

    final lastUpdated = DateTime.fromMillisecondsSinceEpoch(cache['last_updated']);
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);

    return difference.inDays >= maxAgeDays;
  }

  // ==================== UTILITY METHODS ====================
  
  Future<void> clearAllCache() async {
    final db = await database;
    await db.delete('location_cache');
    await db.delete('prayer_schedule_cache');
    await db.delete('surah_cache');
    await db.delete('surah_detail_cache');
  }

  Future<void> clearOldPrayerSchedules() async {
    final db = await database;
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    final yesterdayString = '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
    
    // Delete schedules older than yesterday
    await db.delete(
      'prayer_schedule_cache',
      where: 'date < ?',
      whereArgs: [yesterdayString],
    );
  }

  // ==================== NOTIFICATION SETTINGS METHODS ====================
  
  Future<List<Map<String, dynamic>>> getAllNotificationSettings() async {
    final db = await database;
    return await db.query('notification_settings', orderBy: 'id ASC');
  }

  Future<Map<String, dynamic>?> getNotificationSetting(String prayerName) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'notification_settings',
      where: 'prayer_name = ?',
      whereArgs: [prayerName],
      limit: 1,
    );

    return results.isEmpty ? null : results.first;
  }

  Future<void> updateNotificationSetting({
    required String prayerName,
    bool? isEnabled,
    bool? soundEnabled,
    bool? vibrateEnabled,
  }) async {
    final db = await database;
    final Map<String, dynamic> updates = {};

    if (isEnabled != null) updates['is_enabled'] = isEnabled ? 1 : 0;
    if (soundEnabled != null) updates['sound_enabled'] = soundEnabled ? 1 : 0;
    if (vibrateEnabled != null) updates['vibrate_enabled'] = vibrateEnabled ? 1 : 0;

    if (updates.isNotEmpty) {
      await db.update(
        'notification_settings',
        updates,
        where: 'prayer_name = ?',
        whereArgs: [prayerName],
      );
    }
  }

  Future<void> toggleAllNotifications(bool enabled) async {
    final db = await database;
    await db.update(
      'notification_settings',
      {'is_enabled': enabled ? 1 : 0},
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
