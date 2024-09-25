import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider with ChangeNotifier {
  Position? currentPosition;
  String _location = 'Fetching location...';
  String get location => _location;

  Future<void> fetchLocation(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        _location = '${placemark.locality}, ${placemark.country}';
        print('${placemark.locality}, ${placemark.country}');
      } else {
        _location = 'Location not found';
      }
    } catch (e) {
      _location = 'Error fetching location';
    }
    notifyListeners();
  }

  Future<void> fetchCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Check for permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    // Get the current position
    currentPosition = await Geolocator.getCurrentPosition();
    
    // Fetch the human-readable address using the coordinates
    if (currentPosition != null) {
      await fetchLocation(currentPosition!.latitude, currentPosition!.longitude);
    }
  }
}
