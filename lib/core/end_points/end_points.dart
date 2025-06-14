class EndPoints {
  static const String baseUrl =
      'https://68480ed3ec44b9f3493f7760.mockapi.io/api/v1';
  static const String getProducts = '$baseUrl/products';
  static const String addProduct = '$baseUrl/products';

  // Dynamic functions for endpoints requiring a product ID
  static String productById(String id) => '$baseUrl/products/$id';

  static String updateProduct(String id) => '$baseUrl/products/$id';

  static String deleteProduct(String id) => '$baseUrl/products/$id';

  //Favorite products endpoint
  static const String favoriteProducts = '$baseUrl/favorites';
  static const String addFavoriteProduct = '$baseUrl/favorites';
  static const String deleteFavoriteProduct = '$baseUrl/favorites/';
}
