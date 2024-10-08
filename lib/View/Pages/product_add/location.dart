// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:latlong2/latlong.dart';

// class OpenStreetMapExample extends StatefulWidget {
//   @override
//   _OpenStreetMapExampleState createState() => _OpenStreetMapExampleState();
// }

// class _OpenStreetMapExampleState extends State<OpenStreetMapExample> {
//   LatLng selectedLocation = const LatLng(11.258753, 75.780411); // Default location
//   Position? currentPosition;
//   String apiKey = '395ab558c996402592d39f26c91691e4'; // Geoapify API key
//   String address = "38 Upper Montagu Street, Westminster W1H 1LJ, United Kingdom";

//   @override
//   void initState() {
//     super.initState();
//     fetchCurrentLocation(); // Fetch the current location when the map is initialized
//     fetchLocationFromApi(); // Fetch the location from Geoapify API
//   }

//   Future<void> fetchCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Check if location services are enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Location services are disabled.')),
//       );
//       return;
//     }

//     // Check for permission
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Location permissions are denied.')),
//         );
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Location permissions are permanently denied.')),
//       );
//       return;
//     }

//     // Get the current position
//     currentPosition = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );

//     // Update the selectedLocation with the fetched coordinates
//     if (currentPosition != null) {
//       setState(() {
//         selectedLocation = LatLng(currentPosition!.latitude, currentPosition!.longitude);
//       });
//     }
//   }

//   Future<void> fetchLocationFromApi() async {
//     final url =
//         'https://api.geoapify.com/v1/geocode/search?text=$address&apiKey=$apiKey';
//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final lat = data['features'][0]['geometry']['coordinates'][1];
//         final lon = data['features'][0]['geometry']['coordinates'][0];

//         // Update the selectedLocation with the fetched coordinates
//         setState(() {
//           selectedLocation = LatLng(lat, lon);
//         });
//         print("Location from API: $lat, $lon");
//       } else {
//         print("Failed to load location data");
//       }
//     } catch (e) {
//       print("Error: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Pick a Location'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.check),
//             onPressed: () {
//               // Return the selected location when the user confirms
//               Navigator.pop(context, selectedLocation);
//             },
//           ),
//         ],
//       ),
//       body: FlutterMap(
//         options: MapOptions(
//           center: selectedLocation,
//           zoom: 13.0,
//           onTap: (tapPosition, point) {
//             // Update the selected location on map tap
//             setState(() {
//               selectedLocation = point;
//             });
//           },
//         ),
//         children: [
//           TileLayer(
//             urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//             subdomains: const ['a', 'b', 'c'],
//           ),
//           MarkerLayer(
//             markers: [
//               Marker(
//                 point: selectedLocation,
//                 width: 80.0,
//                 height: 80.0,
//                 builder: (ctx) => const Icon(
//                   Icons.location_on,
//                   color: Colors.red,
//                   size: 40,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class OpenStreetMapExample extends StatefulWidget {
  const OpenStreetMapExample({super.key});

  @override
  _OpenStreetMapExampleState createState() => _OpenStreetMapExampleState();
}

class _OpenStreetMapExampleState extends State<OpenStreetMapExample> {
  LatLng selectedLocation = const LatLng(11.258753, 75.780411); // Default location
  Position? currentPosition;
  String apiKey = '395ab558c996402592d39f26c91691e4'; // Geoapify API key
  String address = "38 Upper Montagu Street, Westminster W1H 1LJ, United Kingdom";

  @override
  void initState() {
    super.initState();
    fetchCurrentLocation(); // Fetch the current location when the map is initialized
    fetchLocationFromApi(); // Fetch the location from Geoapify API
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

  Future<void> fetchLocationFromApi() async {
    final url =
        'https://api.geoapify.com/v1/geocode/search?text=$address&apiKey=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final lat = data['features'][0]['geometry']['coordinates'][1];
        final lon = data['features'][0]['geometry']['coordinates'][0];

        // Update the selectedLocation with the fetched coordinates
        setState(() {
          selectedLocation = LatLng(lat, lon);
        });
        print("Location from API: $lat, $lon");
      } else {
        print("Failed to load location data");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<String> fetchAddressFromCoordinates(LatLng coordinates) async {
    final url =
        'https://api.geoapify.com/v1/geocode/reverse?lat=${coordinates.latitude}&lon=${coordinates.longitude}&apiKey=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['features'][0]['properties']['formatted'] ?? "Address not found";
      } else {
        print("Failed to load address data");
        return "Failed to load address";
      }
    } catch (e) {
      print("Error: $e");
      return "Error occurred";
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
            onPressed: () async {
              // Get the address when the user confirms
              String fetchedAddress = await fetchAddressFromCoordinates(selectedLocation);
              print("Selected Address: $fetchedAddress");
              // Return the selected location and address when the user confirms
              Navigator.pop(context, {'location': selectedLocation, 'address': fetchedAddress});
            },
          ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          center: selectedLocation,
          zoom: 13.0,
          onTap: (tapPosition, point) async {
            // Update the selected location on map tap
            setState(() {
              selectedLocation = point;
            });
            // Fetch address for the selected location
            String fetchedAddress = await fetchAddressFromCoordinates(selectedLocation);
            print("Address from coordinates: $fetchedAddress");
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
