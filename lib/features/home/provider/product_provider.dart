
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../../core/api/logger_service.dart';
import '../../../core/error_handling/dio_exception_erros.dart';
import '../../../core/static_texts/request_texts.dart';
import '../../../core/end_points/end_points.dart';
import '../model/product_model.dart';


class ProductProvider extends ChangeNotifier {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: EndPoints.baseUrl,
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {RequestTexts.contentType: RequestTexts.applicationJson},
    ),
  );

  List<ProductModel> _products = [];
  ProductModel? _selectedProduct;

  List<ProductModel> get products => _products;
  ProductModel? get selectedProduct => _selectedProduct;

  void _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      throw Exception(DioExceptionErrors.connectionTimeout);
    } else if (e.type == DioExceptionType.receiveTimeout) {
      throw Exception(DioExceptionErrors.receiveTimeout);
    } else if (e.type == DioExceptionType.badResponse) {
      throw Exception('${DioExceptionErrors.badresponse}: ${e.response?.statusCode}');
    } else {
      throw Exception('${DioExceptionErrors.unknown}: $e');
    }
  }

  Future<void> fetchProducts() async {
    try {
      LoggerService.logRequest(
        title: 'Fetch All Products',
        method: 'GET',
        endpoint: EndPoints.getProducts,
        headers: _dio.options.headers,
        body: {},
      );

      final response = await _dio.get(EndPoints.getProducts);

      LoggerService.logResponse(
        title: 'Fetch All Products',
        statusCode: response.statusCode,
        data: response.data,
      );

      _products = (response.data as List)
          .map((item) => ProductModel.fromJson(item))
          .toList();
      notifyListeners();
    } on DioException catch (e) {
      LoggerService.logError("Error fetching products", e);
      _handleError(e);
    }
  }

  Future<void> fetchProductById(String productId) async {
    _selectedProduct = null;
    try {
      LoggerService.logRequest(
        title: 'Fetch Product by ID',
        method: 'GET',
        endpoint: EndPoints.productById(productId),
        headers: _dio.options.headers,
        body: {},
      );

      final response = await _dio.get(EndPoints.productById(productId));

      LoggerService.logResponse(
        title: 'Fetch Product by ID',
        statusCode: response.statusCode,
        data: response.data,
      );

      _selectedProduct = ProductModel.fromJson(response.data);
      notifyListeners();
    } on DioException catch (e) {
      LoggerService.logError("Error fetching product by ID", e);
      _handleError(e);
    }
  }

  Future<void> addProduct(ProductModel product) async {
    try {
      LoggerService.logRequest(
        title: 'Add Product',
        method: 'POST',
        endpoint: EndPoints.addProduct,
        headers: _dio.options.headers,
        body: product.toJson(),
      );

      final response = await _dio.post(
        EndPoints.addProduct,
        data: product.toJson(),
      );

      LoggerService.logResponse(
        title: 'Add Product',
        statusCode: response.statusCode,
        data: response.data,
      );

      _products.add(ProductModel.fromJson(response.data));
      notifyListeners();
    } on DioException catch (e) {
      LoggerService.logError("Error adding product", e);
      _handleError(e);
    }
  }

  Future<void> updateProduct(String productId, ProductModel product) async {
    try {
      LoggerService.logRequest(
        title: 'Update Product',
        method: 'PUT',
        endpoint: EndPoints.updateProduct(productId),
        headers: _dio.options.headers,
        body: product.toJson(),
      );

      final response = await _dio.put(
        EndPoints.updateProduct(productId),
        data: product.toJson(),
      );

      LoggerService.logResponse(
        title: 'Update Product',
        statusCode: response.statusCode,
        data: response.data,
      );

      int index = _products.indexWhere((p) => p.id == productId);
      if (index != -1) {
        _products[index] = ProductModel.fromJson(response.data);
        notifyListeners();
      }
    } on DioException catch (e) {
      LoggerService.logError("Error updating product", e);
      _handleError(e);
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      LoggerService.logRequest(
        title: 'Delete Product',
        method: 'DELETE',
        endpoint: EndPoints.deleteProduct(productId),
        headers: _dio.options.headers,
        body: {},
      );

      final response = await _dio.delete(EndPoints.deleteProduct(productId));

      LoggerService.logResponse(
        title: 'Delete Product',
        statusCode: response.statusCode,
        data: {"message": "Deleted successfully"},
      );

      _products.removeWhere((p) => p.id == productId);
      notifyListeners();
    } on DioException catch (e) {
      LoggerService.logError("Error deleting product", e);
      _handleError(e);
    }
  }
}
