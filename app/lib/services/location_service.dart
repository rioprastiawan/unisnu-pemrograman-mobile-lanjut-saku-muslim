import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  // Request location permission
  Future<bool> requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  // Get current location coordinates
  Future<Position?> getCurrentLocation() async {
    try {
      bool hasPermission = await requestLocationPermission();
      if (!hasPermission) {
        return null;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      return position;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  // Get city name from coordinates
  Future<String?> getCityNameFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        // Try to get locality (city) or subAdministrativeArea as fallback
        // String? cityName = placemark.locality ?? placemark.subAdministrativeArea;
        String? cityName = placemark.subAdministrativeArea;
        return cityName;
      }
      
      return null;
    } catch (e) {
      print('Error getting city name: $e');
      return null;
    }
  }

  // Normalize city name to match API format
  // Transform "Kabupaten X" -> "KAB. X"
  // Keep "Kota X" as "KOTA X" (uppercase)
  // Keep plain city name as is
  String normalizeForApiSearch(String cityName) {
    // Trim whitespace
    String normalized = cityName.trim();
    
    // Check if starts with "Kabupaten " (with space)
    if (normalized.toLowerCase().startsWith('kabupaten ')) {
      // Remove "Kabupaten " and add "KAB. " prefix
      String cityCore = normalized.substring(10).trim(); // Remove "Kabupaten "
      return 'KAB. ${cityCore.toUpperCase()}';
    }
    
    // Check if starts with "Kota " (with space)
    if (normalized.toLowerCase().startsWith('kota ')) {
      // Keep as "KOTA X" format
      String cityCore = normalized.substring(5).trim(); // Remove "Kota "
      return 'KOTA ${cityCore.toUpperCase()}';
    }
    
    // If no prefix, return uppercase
    return normalized.toUpperCase();
  }

  // Get full location info
  Future<Map<String, dynamic>?> getLocationInfo() async {
    try {
      Position? position = await getCurrentLocation();
      if (position == null) {
        return null;
      }

      String? cityName = await getCityNameFromCoordinates(
        position.latitude,
        position.longitude,
      );

      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'cityName': cityName,
      };
    } catch (e) {
      print('Error getting location info: $e');
      return null;
    }
  }

  // Calculate distance between two coordinates (in meters)
  Future<double> getDistanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) async {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }
}
