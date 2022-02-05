import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future toggleFavoriteStatus(String token, String userId) async {
    final url = Uri.parse(
        'https://products-shop-app-default-rtdb.firebaseio.com/userFavs/$userId/$id.json?auth=$token');
    isFavorite = !isFavorite;
    notifyListeners();
    await http.put(
      url,
      body: jsonEncode(isFavorite),
    );
  }
}
