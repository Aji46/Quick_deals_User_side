import 'package:flutter/material.dart'; // Import this for ChangeNotifier
import 'package:latlong2/latlong.dart';

class ProductLocationProvider extends ChangeNotifier { // Extend ChangeNotifier
  LatLng? selectedLocation;
  String? selectedAddress;

  void setSelectedLocation(LatLng? location) {
    selectedLocation = location;
    notifyListeners(); // Notify listeners about the change
  }

  void setSelectedAddress(String? address) {
    selectedAddress = address;
    notifyListeners(); // Notify listeners about the change
  }
}
