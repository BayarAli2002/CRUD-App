import 'package:crud_app/core/end_points/end_points.dart';
import 'package:crud_app/features/home/model/product_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  final Dio _dio = Dio();

  final List<ProductModel> _favoriteProducts = [];

  List<ProductModel> get favoriteProducts => _favoriteProducts;

  // Fetch all favorites from the API
  Future<void> fetchFavorites() async {
    try {
      final response = await _dio.get(EndPoints.favoriteProducts);
      if (response.statusCode == 200) {
        final List data = response.data;
        _favoriteProducts.clear();

        // Each favorite item contains favorite_id and product info including id
        _favoriteProducts.addAll(
          data.map((json) => ProductModel.fromJson(json)).toList(),
        );

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to fetch favorites: $e');
    }
  }

  // Add a favorite if not already added
  Future<void> addFavorite(ProductModel product) async {
    final isAlreadyFavorite = _favoriteProducts.any((p) => p.id == product.id);
    if (!isAlreadyFavorite) {
      try {
        final response = await _dio.post(
          EndPoints.addFavoriteProduct,
          data: {
            ...product.toJson(),
            'productId': product.id,
            // you can include productId for clarity if API expects it
          },
        );

        if (response.statusCode == 201) {
          final addedFavorite = ProductModel.fromJson(response.data);
          _favoriteProducts.add(addedFavorite);
          notifyListeners();
        }
      } catch (e) {
        debugPrint('Failed to add favorite: $e');
      }
    }
  }

  // Remove favorite by product ID (find favorite_id first)
  Future<void> removeFavorite(String productId) async {
    try {
      // Find favorite by product ID
      final favorite = _favoriteProducts.firstWhere((p) => p.id == productId);
      if (favorite.favoriteId != null && favorite.favoriteId!.isNotEmpty) {
        final response = await _dio.delete(
          '${EndPoints.deleteFavoriteProduct}/${favorite.favoriteId}',
        );
        if (response.statusCode == 200 || response.statusCode == 204) {
          _favoriteProducts.removeWhere((p) => p.id == productId);
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Failed to remove favorite: $e');
    }
  }

  // Check if product is favorite by product ID
  bool isFavorite(String productId) {
    return _favoriteProducts.any((p) => p.id == productId);
  }
}
