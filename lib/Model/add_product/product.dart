class Product {
  final String name;
  final String details;
  final String price;
  final String additionalInfo;
  final List<String> images;

  final String address; // Add this line for address

  Product({
    required this.name,
    required this.details,
    required this.price,
    required this.additionalInfo,
    required this.images,
    required this.address, // Add this line for address
  });
}
