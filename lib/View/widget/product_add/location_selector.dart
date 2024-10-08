import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_o_deals/Controller/auth/provider/product_location_provider.dart';
import 'package:quick_o_deals/View/Pages/product_add/location.dart';

class LocationSelector extends StatelessWidget {
  const LocationSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final productLocationProvider = Provider.of<ProductLocationProvider>(context);

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.location_on),
          color: const Color.fromARGB(255, 243, 33, 33),
          iconSize: 35.0,
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OpenStreetMapExample()),
            );

            if (result != null) {
              productLocationProvider.setSelectedLocation(result['location']);
              productLocationProvider.setSelectedAddress(result['address']);
            }
          },
        ),
        const SizedBox(width: 10),
        productLocationProvider.selectedAddress != null
            ? Flexible(
                child: Text(
                  productLocationProvider.selectedAddress!,
                  style: const TextStyle(fontSize: 16),
                ),
              )
            : const Text("No address selected", style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
