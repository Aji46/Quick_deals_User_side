import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class OpenStreetMapExample extends StatefulWidget {
  @override
  _OpenStreetMapExampleState createState() => _OpenStreetMapExampleState();
}

class _OpenStreetMapExampleState extends State<OpenStreetMapExample> {
  LatLng selectedLocation = const LatLng(11.258753, 75.780411); // Default location
  Position? currentPosition;

  @override
  void initState() {
    super.initState();
    fetchCurrentLocation(); // Fetch the current location when the map is initialized
  }

  Future<void> fetchCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    // Check for permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permissions are permanently denied.')),
      );
      return;
    }

    // Get the current position
    currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Update the selectedLocation with the fetched coordinates
    if (currentPosition != null) {
      setState(() {
        selectedLocation = LatLng(currentPosition!.latitude, currentPosition!.longitude);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick a Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // Return the selected location when the user confirms
              Navigator.pop(context, selectedLocation);
            },
          ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          center: selectedLocation,
          zoom: 13.0,
          onTap: (tapPosition, point) {
            // Update the selected location on map tap
            setState(() {
              selectedLocation = point;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: selectedLocation,
                width: 80.0,
                height: 80.0,
                builder: (ctx) => const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
