class ProductModel {
  final String? favoriteId; // This is the original product ID from the API
  final String? id;
  final String? title;
  final int? price;
  final String? image;
  final String? description;

  ProductModel({
    this.favoriteId,
    this.id,
    this.title,
    this.price,
    this.image,
    this.description,
  });

  //Special Constructor to convert json data from API to dart objects then we can simply deal with the data
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      favoriteId: json['favorite_id'],
      // Use 'productId' for the original product ID
      title: json['title'],
      price: (json['price']).toInt(),
      // Ensure price is a double
      image: json['image'],
      description: json['description'],
    );
  }

  //to convert the data to a JSON API format which is a Map of key and value pairs
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "favorite_id": favoriteId, // Use 'productId' for the original product ID
      "title": title,
      "price": price,
      "image": image,
      "description": description,
    };
  }
}
