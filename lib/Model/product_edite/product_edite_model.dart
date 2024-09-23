class UserProductModels {
  String? productName;
  String? productDetails;
  String? productPrice;
  String? productAdditionalInfo;
  List<String>? images;

  UserProductModels({
    this.productName,
    this.productDetails,
    this.productPrice,
    this.productAdditionalInfo,
    this.images,
  });

  // Define the fromMap method
  factory UserProductModels.fromMap(Map<String, dynamic> map) {
    return UserProductModels(
      productName: map['productName'] ?? '',
      productDetails: map['productDetails'] ?? '',
      productPrice: map['productPrice'] ?? '',
      productAdditionalInfo: map['productAdditionalInfo'] ?? '',
      images: List<String>.from(map['images'] ?? []), // Assuming images is a list of strings
    );
  }

  // Optionally, you can also add a toMap method to convert this model back to a map
  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'productDetails': productDetails,
      'productPrice': productPrice,
      'productAdditionalInfo': productAdditionalInfo,
      'images': images,
    };
  }
}
