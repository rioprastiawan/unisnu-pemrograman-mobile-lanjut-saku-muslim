import 'dart:math';

class QiblaService {
  // Koordinat Ka'bah di Mekkah
  static const double kaabaLatitude = 21.4225;
  static const double kaabaLongitude = 39.8262;

  /// Menghitung arah kiblat dari koordinat user ke Ka'bah
  /// Returns: sudut dalam derajat (0-360)
  static double calculateQiblaDirection(double userLat, double userLon) {
    // Convert ke radian
    final double lat1 = _toRadians(userLat);
    final double lon1 = _toRadians(userLon);
    final double lat2 = _toRadians(kaabaLatitude);
    final double lon2 = _toRadians(kaabaLongitude);

    // Hitung delta longitude
    final double dLon = lon2 - lon1;

    // Rumus untuk menghitung bearing (arah)
    final double y = sin(dLon) * cos(lat2);
    final double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    
    double bearing = atan2(y, x);
    
    // Convert dari radian ke derajat
    bearing = _toDegrees(bearing);
    
    // Normalize ke 0-360
    bearing = (bearing + 360) % 360;
    
    return bearing;
  }

  /// Convert derajat ke radian
  static double _toRadians(double degrees) {
    return degrees * pi / 180;
  }

  /// Convert radian ke derajat
  static double _toDegrees(double radians) {
    return radians * 180 / pi;
  }

  /// Menghitung jarak ke Ka'bah dalam kilometer
  static double calculateDistanceToKaaba(double userLat, double userLon) {
    const double earthRadius = 6371; // km

    final double lat1 = _toRadians(userLat);
    final double lon1 = _toRadians(userLon);
    final double lat2 = _toRadians(kaabaLatitude);
    final double lon2 = _toRadians(kaabaLongitude);

    final double dLat = lat2 - lat1;
    final double dLon = lon2 - lon1;

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  /// Format jarak dalam format yang mudah dibaca
  static String formatDistance(double kilometers) {
    if (kilometers >= 1000) {
      return '${(kilometers / 1000).toStringAsFixed(1)} ribu km';
    } else if (kilometers >= 100) {
      return '${kilometers.toStringAsFixed(0)} km';
    } else {
      return '${kilometers.toStringAsFixed(1)} km';
    }
  }
}
