import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  Future<void> addItem(String productId, String title, double price) async {
    if (_items.containsKey(productId)) {
      _items.update(productId, (existingId) {
        return CartItem(
          id: existingId.id,
          title: existingId.title,
          price: existingId.price,
          quantity: existingId.quantity,
        );
      });
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                price: price,
                quantity: 1,
              ));
    }
    notifyListeners();
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  int get itemCount {
    return _items.length;
  }

  void removeItem(String prodId) {
    _items.remove(prodId);
    notifyListeners();
  }

  void removeSingleItem(String prodId) {
    if (!_items.containsKey(prodId)) return;
    if (_items[prodId].quantity > 1)
      _items.update(
          prodId,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                price: existingCartItem.price,
                title: existingCartItem.title,
                quantity: existingCartItem.quantity - 1,
              ));
    else
      _items.remove(prodId);
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
