

class Product {
  String name;
  String details;
  String price;
  String additionalInfo;
  final List<String> images; 

  Product({
    required this.name,
    required this.details,
    required this.price,
    required this.additionalInfo,
    required this.images,
  });
}
