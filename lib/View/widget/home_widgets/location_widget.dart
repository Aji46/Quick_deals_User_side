import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/Provider/location_provider.dart';

class LocationWidget extends StatelessWidget {
  const LocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,  
      children: [
        GestureDetector(
          onTap: () {
            context.read<LocationProvider>().fetchCurrentLocation();
          },
          child: const Icon(
            Icons.location_on,
            color: Colors.red,
            size: 24,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Consumer<LocationProvider>(
            builder: (context, locationProvider, child) {
              return Text(
                locationProvider.location.isNotEmpty
                    ? locationProvider.location
                    : 'Fetching location...',
                style: const TextStyle(color: Colors.black87),
                overflow: TextOverflow.ellipsis, // To handle long text
              );
            },
          ),
        ),
      ],
    );
  }
}
