import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

/// Model for location data
class LocationData {
  final double latitude;
  final double longitude;
  final String cityName;
  final String countryName;
  final String displayName;

  const LocationData({
    required this.latitude,
    required this.longitude,
    required this.cityName,
    required this.countryName,
    required this.displayName,
  });

  @override
  String toString() {
    return 'LocationData(lat: $latitude, lon: $longitude, display: $displayName)';
  }
}

/// Service for location-related operations
class LocationService {
  static const double _defaultLatitude = -6.2088; // Jakarta
  static const double _defaultLongitude = 106.8456;
  static const String _defaultCity = 'Jakarta';
  static const String _defaultCountry = 'Indonesia';

  /// Get current device location
  Future<LocationData?> getCurrentLocation() async {
    try {
      // Check and request location permission
      final permission = await _checkLocationPermission();
      if (!permission) {
        return null;
      }

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      // Get address from coordinates
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        return LocationData(
          latitude: position.latitude,
          longitude: position.longitude,
          cityName:
              placemark.locality ??
              placemark.administrativeArea ??
              _defaultCity,
          countryName: placemark.country ?? _defaultCountry,
          displayName: _buildDisplayName(placemark),
        );
      } else {
        return LocationData(
          latitude: position.latitude,
          longitude: position.longitude,
          cityName: _defaultCity,
          countryName: _defaultCountry,
          displayName:
              'Koordinat (${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)})',
        );
      }
    } catch (e) {
      return null;
    }
  }

  /// Get location from city name
  Future<LocationData?> getLocationFromCity(
    String cityName, [
    String? countryName,
  ]) async {
    try {
      final query = countryName != null ? '$cityName, $countryName' : cityName;
      final locations = await locationFromAddress(query);

      if (locations.isNotEmpty) {
        final location = locations.first;
        final placemarks = await placemarkFromCoordinates(
          location.latitude,
          location.longitude,
        );

        if (placemarks.isNotEmpty) {
          final placemark = placemarks.first;
          return LocationData(
            latitude: location.latitude,
            longitude: location.longitude,
            cityName:
                placemark.locality ?? placemark.administrativeArea ?? cityName,
            countryName: placemark.country ?? countryName ?? _defaultCountry,
            displayName: _buildDisplayName(placemark),
          );
        } else {
          return LocationData(
            latitude: location.latitude,
            longitude: location.longitude,
            cityName: cityName,
            countryName: countryName ?? _defaultCountry,
            displayName:
                countryName != null ? '$cityName, $countryName' : cityName,
          );
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  /// Get default location (Jakarta)
  LocationData getDefaultLocation() {
    return const LocationData(
      latitude: _defaultLatitude,
      longitude: _defaultLongitude,
      cityName: _defaultCity,
      countryName: _defaultCountry,
      displayName: '$_defaultCity, $_defaultCountry',
    );
  }

  /// Check and request location permission
  Future<bool> _checkLocationPermission() async {
    final status = await Permission.location.status;

    if (status.isDenied) {
      final result = await Permission.location.request();
      return result.isGranted;
    }

    return status.isGranted;
  }

  /// Build display name from placemark
  String _buildDisplayName(Placemark placemark) {
    final parts = <String>[];

    if (placemark.locality != null && placemark.locality!.isNotEmpty) {
      parts.add(placemark.locality!);
    } else if (placemark.administrativeArea != null &&
        placemark.administrativeArea!.isNotEmpty) {
      parts.add(placemark.administrativeArea!);
    }

    if (placemark.country != null && placemark.country!.isNotEmpty) {
      parts.add(placemark.country!);
    }

    return parts.join(', ');
  }

  /// Calculate distance between two points in kilometers
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
  }

  /// Calculate bearing from current location to Kaaba
  double calculateQiblaDirection(double latitude, double longitude) {
    // Kaaba coordinates
    const double kaabaLat = 21.4225;
    const double kaabaLon = 39.8262;

    return Geolocator.bearingBetween(latitude, longitude, kaabaLat, kaabaLon);
  }
}
