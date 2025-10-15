import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/products_model.dart';

class ProductsProvider with ChangeNotifier {
  static List<ProductModel> _productsList = [];
  List<ProductModel> get getProducts => _productsList;

  List<ProductModel> get getOnSaleProducts =>
      _productsList.where((element) => element.isOnSale).toList();

  Future<void> fetchProducts() async {
    try {
      final QuerySnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .get();

      _productsList = [];

      for (var element in productSnapshot.docs) {
        // 🔹 Price va salePrice uchun xavfsiz parse
        double parseDouble(dynamic value) {
          if (value == null) return 0.0;
          if (value is int) return value.toDouble();
          if (value is double) return value;
          if (value is String) return double.tryParse(value) ?? 0.0;
          return 0.0;
        }

        _productsList.insert(
          0,
          ProductModel(
            id: element.get('id') ?? '',
            title: element.get('title') ?? '',
            imageUrl: element.get('imageUrl') ?? '',
            productCategoryName: element.get('productCategoryName') ?? '',
            price: parseDouble(element.get('price')),
            salePrice: parseDouble(element.get('salePrice')),
            isOnSale: element.get('isOnSale') ?? false,
            isPiece: element.get('isPiece') ?? false,
          ),
        );
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching products: $e');
    }
  }

  ProductModel findProdById(String productId) {
    return _productsList.firstWhere((element) => element.id == productId);
  }

  List<ProductModel> findByCategory(String categoryName) {
    return _productsList
        .where(
          (element) => element.productCategoryName.toLowerCase().contains(
            categoryName.toLowerCase(),
          ),
        )
        .toList();
  }

  List<ProductModel> searchQuery(String searchText) {
    return _productsList
        .where(
          (element) =>
              element.title.toLowerCase().contains(searchText.toLowerCase()),
        )
        .toList();
  }
}
