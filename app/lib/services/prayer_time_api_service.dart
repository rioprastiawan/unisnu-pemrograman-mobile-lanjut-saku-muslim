import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/city.dart';
import '../models/prayer_schedule.dart';

class PrayerTimeApiService {
  static const String baseUrl = 'https://api.myquran.com/v2';

  // Search city by keyword
  Future<List<City>> searchCity(String keyword) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/sholat/kota/cari/$keyword'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['status'] == true && jsonData['data'] != null) {
          final List<dynamic> cityList = jsonData['data'];
          return cityList.map((city) => City.fromJson(city)).toList();
        }
      }
      
      return [];
    } catch (e) {
      print('Error searching city: $e');
      return [];
    }
  }

  // Get city info by ID
  Future<City?> getCityById(String cityId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/sholat/kota/$cityId'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['status'] == true && jsonData['data'] != null) {
          return City.fromJson(jsonData['data']);
        }
      }
      
      return null;
    } catch (e) {
      print('Error getting city by ID: $e');
      return null;
    }
  }

  // Get all cities
  Future<List<City>> getAllCities() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/sholat/kota/semua'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['status'] == true && jsonData['data'] != null) {
          final List<dynamic> cityList = jsonData['data'];
          return cityList.map((city) => City.fromJson(city)).toList();
        }
      }
      
      return [];
    } catch (e) {
      print('Error getting all cities: $e');
      return [];
    }
  }

  // Get prayer schedule by city ID and date (format: yyyy-MM-dd)
  Future<PrayerSchedule?> getPrayerSchedule(String cityId, String date) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/sholat/jadwal/$cityId/$date'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['status'] == true && jsonData['data'] != null) {
          return PrayerSchedule.fromJson(jsonData['data']);
        }
      }
      
      return null;
    } catch (e) {
      print('Error getting prayer schedule: $e');
      return null;
    }
  }

  // Get prayer schedule by city ID and date components (year, month, day)
  Future<PrayerSchedule?> getPrayerScheduleByComponents(
    String cityId,
    int year,
    int month,
    int day,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/sholat/jadwal/$cityId/$year/$month/$day'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['status'] == true && jsonData['data'] != null) {
          return PrayerSchedule.fromJson(jsonData['data']);
        }
      }
      
      return null;
    } catch (e) {
      print('Error getting prayer schedule: $e');
      return null;
    }
  }

  // Get today's prayer schedule by city ID
  Future<PrayerSchedule?> getTodayPrayerSchedule(String cityId) async {
    final now = DateTime.now();
    final dateString = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    return await getPrayerSchedule(cityId, dateString);
  }
}
