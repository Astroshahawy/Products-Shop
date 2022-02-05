import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  String authToken;
  String userId;

  void updateVars({String token, String id}) {
    authToken = token;
    userId = id;
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return items.firstWhere((prod) => prod.id == id);
  }

  Future addProduct(Product product) async {
    final url = Uri.parse(
        'https://products-shop-app-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'creatorId': userId,
        }),
      );

      _items.add(
        Product(
          id: json.decode(response.body)['name'].toString(),
          title: product.title,
          price: product.price,
          description: product.description,
          imageUrl: product.imageUrl,
        ),
      );
      notifyListeners();
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  Future updateProduct(String id, Product updatedProduct) async {
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      final url = Uri.parse(
          'https://products-shop-app-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
      await http.patch(
        url,
        body: json.encode({
          'title': updatedProduct.title,
          'price': updatedProduct.price,
          'description': updatedProduct.description,
          'imageUrl': updatedProduct.imageUrl,
        }),
      );
      _items[productIndex] = updatedProduct;
      notifyListeners();
    } else {
      debugPrint('...');
    }
  }

  Future deleteProduct(String id) async {
    final url = Uri.parse(
        'https://products-shop-app-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    await http.delete(url);
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }

  Future fetchProducts({bool filterByUser = false}) async {
    final filteringValue =
        filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    var url = Uri.parse(
        'https://products-shop-app-default-rtdb.firebaseio.com/products.json?auth=$authToken$filteringValue');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url = Uri.parse(
          'https://products-shop-app-default-rtdb.firebaseio.com/userFavs/$userId.json?auth=$authToken');
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'] as String,
            description: prodData['description'] as String,
            price: prodData['price'] as double,
            imageUrl: prodData['imageUrl'] as String,
            isFavorite: (favoriteData == null
                ? false
                : favoriteData[prodId] ?? false) as bool,
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
