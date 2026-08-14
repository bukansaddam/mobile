import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class LocationNativeDataSource {
  Future<String> getAddressFromLatLng(LatLng position);
  Future<LatLng> getCoordinatesFromAddress(String query);
  Future<LatLng> getCurrentPosition();
}

class LocationNativeDataSourceImpl implements LocationNativeDataSource {
  final Geocoding _geocoding = Geocoding();

  @override
  Future<String> getAddressFromLatLng(LatLng position) async {
    List<Placemark> placemarks = await _geocoding.placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      List<String> parts = [];

      if (place.street != null && place.street!.trim().isNotEmpty) {
        parts.add(place.street!.trim());
      }
      if (place.subLocality != null &&
          place.subLocality!.trim().isNotEmpty &&
          place.subLocality != place.street) {
        parts.add('Kel. ${place.subLocality!.trim()}');
      }
      if (place.locality != null &&
          place.locality!.trim().isNotEmpty &&
          place.locality != place.subLocality) {
        parts.add('Kec. ${place.locality!.trim()}');
      }
      if (place.subAdministrativeArea != null &&
          place.subAdministrativeArea!.trim().isNotEmpty) {
        parts.add(place.subAdministrativeArea!.trim());
      } else if (place.administrativeArea != null &&
          place.administrativeArea!.trim().isNotEmpty) {
        parts.add(place.administrativeArea!.trim());
      }

      if (parts.isNotEmpty) {
        return parts.join(', ');
      }
    }
    return 'Lat: ${position.latitude.toStringAsFixed(6)}, Long: ${position.longitude.toStringAsFixed(6)}';
  }

  @override
  Future<LatLng> getCoordinatesFromAddress(String query) async {
    List<Location> locations = await _geocoding.locationFromAddress(query);
    if (locations.isNotEmpty) {
      final loc = locations.first;
      return LatLng(loc.latitude, loc.longitude);
    }
    throw Exception('Location not found');
  }

  @override
  Future<LatLng> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location service disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission denied forever');
    }

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 8),
      ),
    );

    if (position.latitude == 0 && position.longitude == 0) {
      throw Exception('Invalid location coordinates');
    }

    return LatLng(position.latitude, position.longitude);
  }
}
