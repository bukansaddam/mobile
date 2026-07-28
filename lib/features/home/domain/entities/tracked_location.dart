class TrackedLocation {
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final String? address;

  TrackedLocation({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(),
      'address': address,
    };
  }

  factory TrackedLocation.fromJson(Map<String, dynamic> json) {
    return TrackedLocation(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      address: json['address'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackedLocation &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          timestamp == other.timestamp &&
          address == other.address;

  @override
  int get hashCode =>
      latitude.hashCode ^
      longitude.hashCode ^
      timestamp.hashCode ^
      address.hashCode;
}
