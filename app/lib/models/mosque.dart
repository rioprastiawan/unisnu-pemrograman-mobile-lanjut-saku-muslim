class Mosque {
  final String id;
  final String name;
  final String? address;
  final String city;
  final double latitude;
  final double longitude;
  double? distance; // in kilometers

  Mosque({
    required this.id,
    required this.name,
    this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    this.distance,
  });

  factory Mosque.fromMap(Map<String, dynamic> map) {
    return Mosque(
      id: map['id'].toString(),
      name: map['name'] as String,
      address: map['address'] as String?,
      city: map['city'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      distance: map['distance'] as double?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Mosque.fromCsv(String line) {
    final parts = line.split(',');
    return Mosque(
      id: parts[0],
      name: parts[1],
      address: parts[2].isEmpty ? null : parts[2],
      city: parts[3],
      latitude: double.parse(parts[4]),
      longitude: double.parse(parts[5]),
    );
  }
}
