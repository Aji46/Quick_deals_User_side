

class Product {
  String name;
  String details;
  String price;
  String additionalInfo;
  final List<String> images; 
    final Map<String, dynamic>? location;

  Product({
    required this.name,
    required this.details,
    required this.price,
    required this.additionalInfo,
    required this.images,
       this.location,
  });
}
