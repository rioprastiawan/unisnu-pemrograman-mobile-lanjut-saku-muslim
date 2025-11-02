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
      version: 1,
      onCreate: _onCreate,
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

  // ==================== UTILITY METHODS ====================
  
  Future<void> clearAllCache() async {
    final db = await database;
    await db.delete('location_cache');
    await db.delete('prayer_schedule_cache');
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

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
