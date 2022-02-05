import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final String imageUrl;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get cartCounter {
    return _items.length;
  }

  double get totalPrice {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, String title, String imgUrl, double price) {
    _items.putIfAbsent(
      productId,
      () => CartItem(
        id: DateTime.now().toString(),
        title: title,
        imageUrl: imgUrl,
        quantity: 1,
        price: price,
      ),
    );
    notifyListeners();
  }

  void removeItem({@required String productId}) {
    _items.remove(productId);
    notifyListeners();
  }

  void increaseItemCount({@required String productId}) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (cartItem) => CartItem(
            id: cartItem.id,
            title: cartItem.title,
            imageUrl: cartItem.imageUrl,
            quantity: cartItem.quantity + 1,
            price: cartItem.price),
      );
    }
    notifyListeners();
  }

  void decreaseItemCount({@required String productId}) {
    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (cartItem) => CartItem(
            id: cartItem.id,
            title: cartItem.title,
            imageUrl: cartItem.imageUrl,
            quantity: cartItem.quantity - 1,
            price: cartItem.price),
      );
    }
    notifyListeners();
  }

  void removeSingleCartItem({@required String productId}) {
    if (_items[productId].quantity > 1) {
      decreaseItemCount(productId: productId);
    } else {
      removeItem(productId: productId);
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
