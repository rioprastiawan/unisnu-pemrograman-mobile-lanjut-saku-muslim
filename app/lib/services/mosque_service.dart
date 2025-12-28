import 'dart:math';
import 'package:flutter/services.dart';
import '../models/mosque.dart';
import 'database_helper.dart';
import 'location_service.dart';

class MosqueService {
  static final MosqueService _instance = MosqueService._internal();
  factory MosqueService() => _instance;
  MosqueService._internal();

  final DatabaseHelper _dbHelper = DatabaseHelper();
  final LocationService _locationService = LocationService();

  /// Load mosques data from CSV into database
  Future<void> loadMosquesData() async {
    // Check if already loaded
    final isLoaded = await _dbHelper.isMosquesDataLoaded();
    if (isLoaded) return;

    try {
      // Load CSV from assets
      final csvData = await rootBundle.loadString(
        'assets/mosques_semarang.csv',
      );
      final lines = csvData.split('\n');

      // Skip header and parse
      final mosques = <Map<String, dynamic>>[];
      for (var i = 1; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;

        try {
          final mosque = Mosque.fromCsv(line);
          mosques.add(mosque.toMap());
        } catch (e) {
          // Skip invalid lines
          continue;
        }
      }

      // Insert into database
      if (mosques.isNotEmpty) {
        await _dbHelper.insertMosques(mosques);
      }
    } catch (e) {
      // Handle error silently or log
      print('Error loading mosques data: $e');
    }
  }

  /// Get nearby mosques based on user location
  Future<List<Mosque>> getNearbyMosques({
    double? userLat,
    double? userLon,
    String? city,
    int limit = 50,
  }) async {
    // Get mosques from database
    final List<Map<String, dynamic>> mosquesMaps;
    if (city != null) {
      mosquesMaps = await _dbHelper.getMosquesByCity(city);
    } else {
      mosquesMaps = await _dbHelper.getAllMosques();
    }

    // Convert to Mosque objects
    final mosques = mosquesMaps.map((map) => Mosque.fromMap(map)).toList();

    // If no user location provided, try to get current location
    if (userLat == null || userLon == null) {
      try {
        final position = await _locationService.getCurrentLocation();
        if (position != null) {
          userLat = position.latitude;
          userLon = position.longitude;
        }
      } catch (e) {
        // If can't get location, return mosques without distance sorting
        return mosques;
      }
    }

    // Calculate distances
    for (final mosque in mosques) {
      mosque.distance = _calculateDistance(
        userLat!,
        userLon!,
        mosque.latitude,
        mosque.longitude,
      );
    }

    // Sort by distance
    mosques.sort((a, b) {
      if (a.distance == null) return 1;
      if (b.distance == null) return -1;
      return a.distance!.compareTo(b.distance!);
    });

    // Return limited results
    return mosques.take(limit).toList();
  }

  /// Calculate distance between two coordinates (Haversine formula)
  /// Returns distance in kilometers
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const R = 6371; // Radius of Earth in kilometers
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  /// Format distance for display
  String formatDistance(double? kilometers) {
    if (kilometers == null) return '-';
    if (kilometers < 1) {
      return '${(kilometers * 1000).toStringAsFixed(0)} m';
    }
    return '${kilometers.toStringAsFixed(2)} km';
  }
}
